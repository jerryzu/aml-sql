-- *********************************************************************************
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

alter table rpt_fxq_tb_ins_fav_cst_ms truncate partition pt20191013000000;

INSERT INTO rpt_fxq_tb_ins_fav_cst_ms(
        company_code1,
        company_code2,
        company_code3,
        pol_no,
        ins_date,
        app_name,
        app_cst_no,
        app_id_no,
        insfav_type,
        insbene_cus_pro,
        relation,
        fav_type,
        name,
        insbene_cst_no,
        insbene_id_no,
        pt
)
select
	a.c_dpt_cde as company_codel,-- 机构网点代码
    co.company_code2 as company_code2, -- 金融机构编码，人行科技司制定的14位金融标准化编码  暂时取“监管机构码，机构外部码，列为空”
	'' as company_code3,-- 保单归属机构网点代码
	a.c_ply_no as pol_no,-- 保单号
	date_format(a.t_app_tm,'%y%m%d') as ins_date,-- 投保日期

	b.c_applicant_name as app_name,-- 投保人名称
	b.c_cst_no as app_cst_no,-- 投保人客户号
	b.c_cert_cde as app_id_no,-- 投保人证件号码

	'11' as insfav_type,-- 被保人或受益人标识 11:被保险人； 12：受益人
	case c.c_clnt_mrk
        when '1' then '11' -- 11:个人
        when '0' then '12' -- 12:单位
        else 
        null-- 其它
    end	as insbene_cus_pro,-- 被保人或受益人类型 11：个人；12：单位
	case c.c_app_relation
	when '601001' then '12' -- 配偶
	when '601002' then '13' -- 父母
	when '601003' then '14' -- 子女
	when '601004' then '17' -- 兄弟姐妹
	when '601005' then '11' -- 本人
	when '601006' then '17' -- 雇主
	when '601007' then '16' -- 雇员
	when '601008' then '17' -- 祖父母、外祖父母
	when '601009' then '17' -- 祖孙、外祖孙
	when '601010' then '17' -- 监护人
	when '601011' then '17' -- 被监护人
	when '601012' then '17' -- 朋友
	when '601013' then '17' -- 未知
	when '601014' then '17' -- 其他
	else
	'@N' -- 其它
	end  as relation,-- 投保人、被保人之间的关系 11：本单位；12本单位董事、监事或高级管理人员；13：雇佣或劳务；14：其他
	'' as fav_type,-- 受益人标识 11：法定受益人；12非法定受益人 insfav_type=12时填写
	c.c_insured_name as name,-- 被保人或受益人名称
	concat(rpad(c.c_cert_cls, 6, '0') , rpad(c.c_cert_cde, 18, '0')) as insbene_cst_no,-- 被保险人或受益人客户号
	c.c_cert_cde as insbene_id_no,-- 被保险人或受益人身份证件号码
    '20191013000000' pt
from rpt_fxq_tb_ply_base partition(pt20191013000000) a
	inner join edw_cust_ply_party_applicant partition(pt20191013000000) b on a.c_app_no=b.c_app_no
	inner join edw_cust_ply_party_insured partition(pt20191013000000) c on a.c_app_no=c.c_app_no
	inner join rpt_fxq_tb_company_ms partition (pt20191013000000) co on co.company_code1 = a.c_dpt_cde
where a.t_next_edr_bgn_tm > now() and b.c_clnt_mrk = 1
union all
select
	a.c_dpt_cde as company_codel,-- 机构网点代码
    co.company_code2 as company_code2, -- 金融机构编码，人行科技司制定的14位金融标准化编码  暂时取“监管机构码，机构外部码，列为空”
	'' as company_code3,-- 保单归属机构网点代码
	a.c_ply_no as pol_no,-- 保单号
	date_format(a.t_app_tm,'%y%m%d') as ins_date,-- 投保日期
	b.c_applicant_name as app_name,-- 投保人名称
	b.c_cst_no as app_cst_no,-- 投保人客户号
	b.c_cert_cde as app_id_no,-- 投保人证件号码
	'12' as insfav_type,-- 被保人或受益人标识 11:被保险人； 12：受益人
	/* 被保险人或受益人类型 unpass*/   -- 11: 个人; 12: 单位客户。填写数字。
	case c.c_clnt_mrk
        when '1' then '11' -- 11:个人
        when '0' then '12' -- 12:单位
        else 
        null-- 其它
    end	as insbene_cus_pro,-- 被保人或受益人类型 11：个人；12：单位
	/* 投保人、被保险人之间的关系 unpass*/  -- 11: 本单位; 12: 本单位董事、监事或高级管理人员; 13: 雇佣或劳务; 14: 其他填写数字。
	'' as relation,-- 投保人、被保人之间的关系 11：本单位；12本单位董事、监事或高级管理人员；13：雇佣或劳务；14：其他
	/* 受益人标识 unpass*/  -- 11: 法定受益人; 12: 非法定受益人。当被保险人或受益人标识Insfav_type='12'时填写。
	'' as fav_type,-- 受益人标识 11：法定受益人；12非法定受益人 insfav_type=12时填写
	c.c_bnfc_name as name,-- 被保人或受益人名称
	concat(rpad(c.c_cert_cls, 6, '0') , rpad(c.c_cert_cde, 18, '0')) as insbene_cst_no,-- 被保险人或受益人客户号
	c.c_cert_cde as insbene_id_no,-- 被保险人或受益人身份证件号码
	'20191013000000' pt	
from rpt_fxq_tb_ply_base partition(pt20191013000000) a
	inner join edw_cust_ply_party_applicant partition(pt20191013000000) b on a.c_app_no=b.c_app_no
	inner join edw_cust_ply_party_bnfc partition(pt20191013000000) c on a.c_app_no=c.c_app_no
	inner join rpt_fxq_tb_company_ms partition (pt20191013000000) co on co.company_code1 = a.c_dpt_cde
where a.t_next_edr_bgn_tm > now() and b.c_clnt_mrk = 1