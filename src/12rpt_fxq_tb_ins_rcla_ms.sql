--  文件名称: 12rpt_fxq_tb_ins_rcla_ms.sql
--  所属主题: 中国人民银行反洗钱执法检查数据提取接口
--  功能描述: 
-- 1.处理出险表,生成被保险人客户号
-- 2. 理赔保单中间表(s_rpt_fxq_tb_ins_rcla_ms)
--    通过赔案号关联理赔申请人(ods_cthx_web_clm_rpt) -- 一次
-- 	    通过赔案号、被保险人客户编号(c_cst_no)关联出险表(ods_cthx_web_clm_accdnt) -- 多次
-- 		  通过赔案号关联结案(ods_cthx_web_clmnv_endcase) -- 多次
-- 		    通过赔案号关联领款人ods_cthx_web_clm_bank) -- 多次
-- 			  生成最终数据
--   表提取数据
--            导入到 (rpt_fxq_tb_ins_rcla_ms) 表
--  创建者:祖新合 
--  输入:  
--  s_rpt_fxq_tb_ins_rcla_ms  -- 理赔保单中间表
--  ods_cthx_web_clm_rpt  -- 理赔申请人(理赔号唯一) 
--  ods_cthx_web_clm_accdnt  -- 出险表(用于取出被保险人信息,关联结案表确定被保人,但由于关联关系暂末确定)，使用赔案号与客户号(c_ins_no[c_cst_no])关联
--  ods_cthx_web_clmnv_endcase  -- 结案
--  ods_cthx_web_clm_bank -- 领款人
--  输出:
--    rpt_fxq_tb_ins_rcla_ms
--  创建日期: 2019/10/30
--  修改日志: 
--  修改日期: 
--  修改人: 
--  修改内容：
--  说明：
--   1.本表数据范围为检查业务期限内，检查对象所有理赔信息，每一笔理赔支付业务生成一条完整的记录，一份赔案涉及多个受益人或实际收款人的，相应生成多条记录。  
--   2.理赔日期为实际资金交易日期。

--  表十二	tb_ins_rcla	检查期所有理赔业务保单

--  投保人，被保人，受益人，[投保人、被保人关系|被保人、受益人关系]，理赔申请人，实际领款人,理赔金额[实际领款人领取的理赔款项金额]，

alter table rpt_fxq_tb_ins_rcla_ms truncate partition pt20191013000000;

drop table if exists clm_accdnt;

create temporary table clm_accdnt 
select distinct
        c_clm_no
--        ,c_cert_typ
--        ,c_cert_no
--        ,c_insured_cde	
--        ,c_insured_nme	
        ,case left(c_cert_typ,2) 
        when 10 then   -- 客户分类,0 法人，1 个人
                concat('2', concat(rpad(c_cert_typ, 6, '0') , rpad(c_cert_no, 18, '0')), mod(substr(concat(rpad(c_cert_typ, 6, '0') , rpad(c_cert_no, 18, '0')), -7, 6), 9)) 
        when 11 then   -- 客户分类,0 法人，1 个人
                concat('2', concat(rpad(c_cert_typ, 6, '0') , rpad(c_cert_no, 18, '0')), mod(substr(concat(rpad(c_cert_typ, 6, '0') , rpad(c_cert_no, 18, '0')), -7, 6), 9)) 
        when 12 then  -- 客户分类,0 法人，1 个人
                concat('1', concat(rpad(c_cert_typ, 6, '0') , rpad(c_cert_no, 18, '0')), mod(substr(concat(rpad(c_cert_typ, 6, '0') , rpad(c_cert_no, 18, '0')), -7, 6), 9)) 
        end c_ins_no
from ods_cthx_web_clm_accdnt partition(pt20191013000000) 	
where c_cert_typ is not null and trim(c_cert_typ)  <> '' and c_cert_typ REGEXP '[^0-9.]' = 0
	and c_cert_no is not null and trim(c_cert_no)  <> '' and left(c_cert_no, 17)  REGEXP '[^0-9.]' = 0;


drop table if exists clm_pay;

create temporary table clm_pay
select 
    e.c_clm_no,
	e.c_rptman_nme as cla_app_name,-- 理赔申请人名称 11:居民身份证或临时身份证;12:军人或武警身份证件;13:港澳居民来往内地通行证,台湾居民来往大陆通行证或其他有效旅游证件;14:港澳台居民居住证;15:外国公民护照;16:户口簿;17:出生证;18:其他类个人身份证件;21:营业执照;22:其他,
	'' as  cla_id_type,-- 理赔申请人身份证件类型
	'' as  cla_id_no,-- 理赔申请人身份证件号码
	-- e.c_insured_rel as cla_pro,-- 理赔申请人类型 11:被保险人;12:受益人;13其他;
	null as cla_pro,-- 理赔申请人类型 11:被保险人;12:受益人;13其他;
	date_format(u.t_endcase_tm,'%Y%m%d') as cla_date,-- 理赔日期 web_clmnv_endcase.t_endcase_tm
	date_format(g.t_pay_tm,'%Y%m%d') as pay_date,-- 理赔日期 web_clmnv_endcase.t_endcase_tm
	'' as cur_code,-- 币种 CNY,USD
	-- u.n_due_amt as cla_amt,-- 理赔金额 same as n_paid_amt --web_clm_bank.n_amt
	g.n_amt as cla_amt,-- 理赔金额 same as n_paid_amt --web_clm_bank.n_amt 保留2位小数
	null as cla_usd_amt,-- 折合美元金额
	u.c_clm_no cla_no,-- 赔案号
    g.c_payee_nme as acc_name,-- 实际领款人名称
	g.c_bank_num as acc_no,-- 实际领款人账号
	g.c_bank_cde as acc_bank,-- 实际领款人开户机构
	g.c_pub_piv as acc_type,-- 实际领款人类型 11:个人;12:单位客户	
	case g.c_card_type
		when '100111' then 11 -- 税务登记证
		when '100112' then 13 -- 统一社会信用代码
		when '110001' then 12 -- 组织机构代码
		when '110002' then 13 -- 工商注册号码
		when '110003' then 14 -- 营业执照
		when '120001' then 11 -- 居民身份证
		when '120002' then 13 -- 护照
		when '120003' then 12 -- 军人证
		when '120004' then 13 -- 回乡证
		when '120005' then 14 -- 港澳居民居住证
		when '120006' then 14 -- 台湾居民居住证
		when '120009' then 18 -- 其它
	else 
		18 -- 其它
	end as acc_id_type,-- 实际领款人身份证件类型 11:居民身份证或临时身份证;12:军人或武警身份证件;13:港澳居民来往内地通行证,台湾居民来往大陆通行证或其他有效旅游证件;14:港澳台居民居住证;15:外国公民护照;16:户口簿;17:出生证;18:其他类个人身份证件;21:营业执照;22:其他,
	g.c_id_card as acc_id_no,-- 实际领款人身份证件号码
    '20191013000000' pt
from  ods_cthx_web_clm_rpt partition(pt20191013000000) e-- 理赔申请人（理赔号唯一)  1054
	inner join ods_cthx_web_clmnv_endcase partition(pt20191013000000) u on e.c_clm_no = u.c_clm_no -- 结案  47
	inner join ods_cthx_web_clm_bank partition(pt20191013000000) g on e.c_clm_no=g.c_clm_no;  -- 领款人    75
/*	
where g.t_pay_tm between {beginday} and {endday}; -- 支付时间
*/

alter table clm_pay  add index clm_pay_ix1 (c_clm_no);

alter table clm_accdnt  add index clm_accdnt_ix1 (c_clm_no, c_ins_no);

INSERT INTO rpt_fxq_tb_ins_rcla_ms(
	company_code1,
	company_code2,
	company_code3,
	company_code4,
	pol_no,
	app_no,
	ins_date,
	eff_date,
	app_name,
	app_cst_no,
	app_id_no,
	app_cus_pro,
	ins_name,
	ins_cst_no,
	ins_id_no,
	ins_cus_pro,
	benefit_name,
	benefit_id_no,
	benefit_type,
	relation_1,
	relation_2,
	cla_app_name,
	cla_id_type,
	cla_id_no,
	cla_pro,
	cla_date,
	pay_date,
	cur_code,
	cla_amt,
	cla_usd_amt,
	cla_no,
	tsf_flag,
	acc_name,
	acc_no,
	acc_bank,
	acc_type,
	acc_id_type,
	acc_id_no,
	receipt_no,
	pt
)
select 
	cm.company_code1,-- 机构网点代码
	cm.company_code2, -- 金融机构编码，人行科技司制定的14位金融标准化编码  暂时取“监管机构码，机构外部码，列为空”
	cm.company_code3,-- 保单归属机构网点代码
	cm.company_code4,-- 受理业务机构网点代码
	cm.c_ply_no as pol_no,-- 保单号
	cm.c_app_no as app_no,-- 投保单号
	date_format(cm.t_app_tm,'%Y%m%d') as ins_date,-- 投保日期
	date_format(cm.t_insrnc_bgn_tm,'%Y%m%d') as eff_date, -- 合同生效日期
	cm.app_name,-- 投保人名称
	cm.app_cst_no,-- 投保人客户号
	cm.app_id_no,-- 投保人证件号码
	case cm.c_app_clnt_mrk when 1 then 11 when 0 then 12 end app_cus_pro,-- 投保人客户类型 11:个人;12:单位;
	
	cm.ins_name,-- 被保险人客户名称
	cm.ins_cst_no,-- 被保险人客户号
	cm.ins_id_no,-- 被保险人证件号码
	case cm.c_ins_clnt_mrk when 1 then 11 when 0 then 12 end ins_cus_pro,-- 被保险人客户类型 11:个人;12:单位;
	cm.benefit_name,-- 受益人名称
	cm.benefit_id_no,-- 受益人身份证件号码
	case cm.c_bnfc_clnt_mrk when 1 then 11 when 0 then 12 end benefit_type,-- 受益人类型 11:个人;12:单位;
	cm.relation_1,-- 投保人被保人之间的关系 11:本人;12:配偶;13:父母;14:子女;15:其他近亲属;16:雇佣或劳务;17:其他;
	cm.relation_2,-- 受益人被保人之间的关系 11:本人;12:配偶;13:父母;14:子女;15:其他近亲属;16:雇佣或劳务;18:其他;
	
	p.cla_app_name,-- 理赔申请人名称 11:居民身份证或临时身份证;12:军人或武警身份证件;13:港澳居民来往内地通行证,台湾居民来往大陆通行证或其他有效旅游证件;14:港澳台居民居住证;15:外国公民护照;16:户口簿;17:出生证;18:其他类个人身份证件;21:营业执照;22:其他,
	'' as  cla_id_type,-- 理赔申请人身份证件类型
	'' as  cla_id_no,-- 理赔申请人身份证件号码
	-- e.c_insured_rel as cla_pro,-- 理赔申请人类型 11:被保险人;12:受益人;13其他;
	null as cla_pro,-- 理赔申请人类型 11:被保险人;12:受益人;13其他;
	p.cla_date,-- 理赔日期 web_clmnv_endcase.t_endcase_tm
	p.pay_date,-- 理赔日期 web_clmnv_endcase.t_endcase_tm
	'' as cur_code,-- 币种 CNY,USD
	-- u.n_due_amt as cla_amt,-- 理赔金额 same as n_paid_amt --web_clm_bank.n_amt
	p.cla_amt,-- 理赔金额 same as n_paid_amt --web_clm_bank.n_amt 保留2位小数
	null as cla_usd_amt,-- 折合美元金额
	p.cla_no,-- 赔案号
	cm.tsf_flag,-- b.c_pay_mde_cde  as tsf_flag,-- 现转标识 --  SELECT C_CDE, C_CNM, 'codeKind' FROM  WEB_BAS_CODELIST PARTITION(pt20190818000000)   WHERE C_PAR_CDE = 'shoufeifangshi' ORDER BY C_CDE ;
    p.acc_name,-- 实际领款人名称
	p.acc_no,-- 实际领款人账号
	p.acc_bank,-- 实际领款人开户机构
	p.acc_type,-- 实际领款人类型 11:个人;12:单位客户	
	p.acc_id_type,-- 实际领款人身份证件类型 11:居民身份证或临时身份证;12:军人或武警身份证件;13:港澳居民来往内地通行证,台湾居民来往大陆通行证或其他有效旅游证件;14:港澳台居民居住证;15:外国公民护照;16:户口簿;17:出生证;18:其他类个人身份证件;21:营业执照;22:其他,
	p.acc_id_no,-- 实际领款人身份证件号码
	cm.c_clm_no as receipt_no,-- 作业流水号,唯一标识号	
    '20191013000000' pt
from s_rpt_fxq_tb_ins_rcla_ms cm
	inner join clm_accdnt ac on cm.c_clm_no = ac.c_clm_no and cm.ins_cst_no = ac.c_ins_no-- 出险表   58	--不用C_INSURED_CDE因为团单没找到被保人号码
	inner join clm_pay p on cm.c_clm_no = p.c_clm_no;

	/* inner join ods_cthx_web_clm_rpt partition(pt20191013000000) e on cm.c_clm_no=e.c_clm_no -- 理赔申请人（理赔号唯一)  1054
	inner join ods_cthx_web_clmnv_endcase partition(pt20191013000000) u on cm.c_clm_no = u.c_clm_no -- 结案  47
	inner join ods_cthx_web_clm_bank partition(pt20191013000000) g on cm.c_clm_no=g.c_clm_no -- 领款人    75 */
/*	
where g.t_pay_tm between {beginday} and {endday}; -- 支付时间
*/
