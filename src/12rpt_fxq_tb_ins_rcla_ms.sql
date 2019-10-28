-- *******************eeeerrrrr**************************************************************
--  文件名称: .sql
--  所属主题: 理赔
--  功能描述: 从 
--   表提取数据
--            导入到 () 表
--  创建者: 
--  输入: 
--  输出:  
--  创建日期: 2017/6/7
--  修改日志: 
--  修改日期: 
--  修改人: 
--  修改内容：
-- 说明：
--   1.本表数据范围为检查业务期限内，检查对象所有理赔信息，每一笔理赔支付业务生成一条完整的记录，一份赔案涉及多个受益人或实际收款人的，相应生成多条记录。  
--   2.理赔日期为实际资金交易日期。

--  表十二	tb_ins_rcla	检查期所有理赔业务保单

--  投保人，被保人，受益人，[投保人、被保人关系|被保人、受益人关系]，理赔申请人，实际领款人,理赔金额[实际领款人领取的理赔款项金额]，

alter table rpt_fxq_tb_ins_rcla_ms truncate partition pt20191013000000;

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
	m.c_dpt_cde as company_codel,-- 机构网点代码
	co.company_code2 as company_code2, -- 金融机构编码，人行科技司制定的14位金融标准化编码  暂时取“监管机构码，机构外部码，列为空”
	'' as company_code3,-- 保单归属机构网点代码
	'' as company_code4,-- 受理业务机构网点代码
	m.c_ply_no as pol_no,-- 保单号
	m.c_app_no as app_no,-- 投保单号
	date_format(m.t_app_tm,'%Y%m%d') as ins_date,-- 投保日期
	date_format(m.t_insrnc_bgn_tm,'%Y%m%d') as eff_date,-- 合同生效日期
---- 待优化
	a.c_acc_name as app_name,-- 投保人名称
	a.c_cst_no as app_cst_no,-- 投保人客户号
	a.c_cert_cde as app_id_no,-- 投保人证件号码
	a.c_clnt_mrk as app_cus_pro,-- 投保人客户类型 11:个人;12:单位;
	
	i.c_acc_name as ins_name,-- 被保险人客户名称
	i.c_cst_no as ins_cst_no,-- 被保险人客户号
	i.c_cert_cde as ins_id_no,-- 被保险人证件号码
	i.c_clnt_mrk as ins_cus_pro,-- 被保险人客户类型 11:个人;12:单位;
	b.c_acc_name as benefit_name,-- 受益人名称
	b.c_cert_cde as benefit_id_no,-- 受益人身份证件号码
	b.c_clnt_mrk as benefit_type,-- 受益人类型 11:个人;12:单位;
	i.c_app_ins_relation as relation_1,-- 投保人被保人之间的关系 11:本人;12:配偶;13:父母;14:子女;15:其他近亲属;16:雇佣或劳务;17:其他;
	i.c_ins_bnf_relation as relation_2,-- 受益人被保人之间的关系 11:本人;12:配偶;13:父母;14:子女;15:其他近亲属;16:雇佣或劳务;18:其他;
----	
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
	case m.c_pay_mde_cde when 5 then 11 else 10 end as tsf_flag,-- b.c_pay_mde_cde  as tsf_flag,-- 现转标识 --  SELECT C_CDE, C_CNM, 'codeKind' FROM  WEB_BAS_CODELIST PARTITION(pt20190818000000)   WHERE C_PAR_CDE = 'shoufeifangshi' ORDER BY C_CDE ;
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
	cm.c_clm_no as receipt_no,-- 作业流水号,唯一标识号	
    '20191013000000' pt
from x_rpt_fxq_tb_ins_rpol_gpol m -- 8472
	inner join edw_cust_ply_party   partition(pt20191013000000) a on m.c_ply_no =a.c_ply_no and a.c_per_biztype in (21, 22) -- 10: 收款人, 21: 投保人, 22: 法人投保人, 31:被保人, 32:法人被保人, 41: 受益人, 42: 法人受益人, 43: 间接受益人, 44: 法人间接受益人
	inner join edw_cust_ply_party   partition(pt20191013000000) i on m.c_ply_no =i.c_ply_no and i.c_per_biztype in (21, 22) -- 10: 收款人, 21: 投保人, 22: 法人投保人, 31:被保人, 32:法人被保人, 41: 受益人, 42: 法人受益人, 43: 间接受益人, 44: 法人间接受益人
	inner join edw_cust_ply_party   partition(pt20191013000000) b on m.c_ply_no =b.c_ply_no and b.c_per_biztype in (21, 22) -- 10: 收款人, 21: 投保人, 22: 法人投保人, 31:被保人, 32:法人被保人, 41: 受益人, 42: 法人受益人, 43: 间接受益人, 44: 法人间接受益人
	inner join ods_cthx_web_clm_main partition(pt20191013000000) cm on m.c_ply_no = cm.c_ply_no -- 理赔主表  1194
	inner join ods_cthx_web_clm_rpt partition(pt20191013000000) e on cm.c_clm_no=e.c_clm_no -- 理赔申请人（理赔号唯一)  1172
	inner join ods_cthx_web_clm_accdnt partition(pt20191013000000) ac on cm.c_clm_no = ac.c_clm_no -- 出险表   1205	
	inner join ods_cthx_web_clmnv_endcase partition(pt20191013000000) u on cm.c_clm_no = u.c_clm_no -- 结案 694
	inner join ods_cthx_web_clm_bank partition(pt20191013000000) g on cm.c_clm_no=g.c_clm_no -- 领款人 1480    
	left join  rpt_fxq_tb_company_ms partition (pt20191013000000) co on co.company_code1 = m.c_dpt_cde
where m.t_next_edr_udr_tm > now() 
	-- and m.t_edr_bgn_tm between {lastday} and {lastday}
	
-- 1.一份赔案涉及多个受益人或实际收款人的，相应生成多条记录。  
-- 2.理赔日期为实际资金交易日期。
-- 检查业务期限内，检查对象所有给付信息，每一笔业务生成一条完整的记录

/*
drop table  if exists accdnt;
create temporary table accdnt
select 
        c_clm_no 
        ,m.c_insured_cde -- 被保人编码
        ,i.c_insured_cde c_insured_cde_o-- 被保人编码
        ,m.c_insured_nme -- 被保人名称
        ,i.c_insured_nme c_insured_nme_o-- 被保人名称
        ,c_cert_typ -- 证件类型
        ,i.c_certf_cls c_cert_typ_o-- 证件类型 
        ,c_cert_no  -- 证件号码
        ,i.c_certf_cde c_cert_no_o -- 证件号码
from ods_cthx_web_clm_accdnt partition (pt20191013000000) m
        left join ods_cthx_web_ply_insured  partition (pt20191013000000) i --因为一个c_insured_cde在insured中有多条，所以取消连接
                on m.c_insured_cde = i.c_insured_cde                
*/