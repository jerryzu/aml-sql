-- *********************************************************************************
--  文件名称: 08rpt_fxq_tb_ins_fav_cst_ms.sql
--  所属主题: 中国人民银行反洗钱执法检查数据提取接口
--  功能描述: 获取非自然人保单(投保人)的被保人与受益人信息列表
--   保单中间表(x_rpt_fxq_tb_ins_rpol_gpol),以保单相关方关系表(edw_cust_ply_party)过滤获取非自然人保单
--   对形成结果非自然人保单,关联保单相关方关系表(edw_cust_ply_party)获取相关方被保人信息,得保单被保人列表
--   对形成结果非自然人保单,关联保单相关方关系表(edw_cust_ply_party)获取相关方受益人信息,得保单受益人列表
--  合并保单被保人列表,保单受益人列表形成单位客户保单对应的被保险人及受益人信息表
--   表提取数据
--            导入到 (rpt_fxq_tb_ins_fav_cst_ms) 表
--  创建者:祖新合 
--  输入: 
--  x_rpt_fxq_tb_ins_rpol_gpol -- 保单中间表(获取非自然人保单)
--  edw_cust_ply_party -- 用于过滤非自然人 c_per_biztype:22; 获取被保险人c_per_biztype: 31,32,33, 受益人c_per_biztype: 41,42,43
--  rpt_fxq_tb_company_ms
--  输出:  
--  rpt_fxq_tb_ins_fav_cst_ms
--  创建日期: 2019/10/30
--  修改日志: 
--  修改日期: 
--  修改人: 
--  修改内容：
-- 说明：
--   提取表七涉及的保单对应的被保险人、受益人信息，按被保险人、受益人分别增加记录；如一份保单存在多个被保险人或受益人的，需逐条增加记录。

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
/* 被保险人部分*/
select
	m.c_dpt_cde as company_codel,-- 机构网点代码
    co.company_code2 as company_code2, -- 金融机构编码，人行科技司制定的14位金融标准化编码  暂时取“监管机构码，机构外部码，列为空”
	'' as company_code3,-- 保单归属机构网点代码
	m.c_ply_no as pol_no,-- 保单号
	date_format(m.t_app_tm,'%y%m%d') as ins_date,-- 投保日期

	a.c_acc_name as app_name,-- 投保人名称
	a.c_cst_no as app_cst_no,-- 投保人客户号
	a.c_cert_cde as app_id_no,-- 投保人证件号码

	'11' as insfav_type,-- 被保人或受益人标识 11:被保险人； 12：受益人
	case i.c_clnt_mrk
        when '1' then '11' -- 11:个人
        when '0' then '12' -- 12:单位
        else 
        null-- 其它
    end	as insbene_cus_pro,-- 被保人或受益人类型 11：个人；12：单位
	case a.c_app_ins_rel
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
	i.c_acc_name as name,-- 被保人或受益人名称
    i.c_cst_no as insbene_cst_no,-- 被保险人或受益人客户号
	i.c_cert_cde as insbene_id_no,-- 被保险人或受益人身份证件号码
    '20191013000000' pt
from x_rpt_fxq_tb_ins_rpol_gpol m
    --  保单人员参于类型: 投保人: [个人:21, 法人:22]; 被保人: [个人:31, 法人:32, 团单被保人:33]; 受益人: [个人:41, 法人:42,团单受益人:43]; 收款人:[11]
	inner join edw_cust_ply_party partition(pt20191013000000) a on m.c_app_no=a.c_app_no and a.c_per_biztype =  22
	inner join edw_cust_ply_party partition(pt20191013000000) i on m.c_app_no=i.c_app_no and i.c_per_biztype in (31, 32, 33)
	inner join rpt_fxq_tb_company_ms partition (pt20191013000000) co on co.company_code1 = m.c_dpt_cde
where m.t_next_edr_udr_tm > {endday} and a.c_clnt_mrk = 0
	and m.t_app_tm between {beginday} and {endday} 
union all
/* 受益人部分提取*/
select
	m.c_dpt_cde as company_codel,-- 机构网点代码
    co.company_code2 as company_code2, -- 金融机构编码，人行科技司制定的14位金融标准化编码  暂时取“监管机构码，机构外部码，列为空”
	'' as company_code3,-- 保单归属机构网点代码
	m.c_ply_no as pol_no,-- 保单号
	date_format(m.t_app_tm,'%y%m%d') as ins_date,-- 投保日期
	a.c_acc_name as app_name,-- 投保人名称
	a.c_cst_no as app_cst_no,-- 投保人客户号
	a.c_cert_cde as app_id_no,-- 投保人证件号码
	'12' as insfav_type,-- 被保人或受益人标识 11:被保险人； 12：受益人
	/* 被保险人或受益人类型 unpass*/   -- 11: 个人; 12: 单位客户。填写数字。
	case b.c_clnt_mrk
        when '1' then '11' -- 11:个人
        when '0' then '12' -- 12:单位
        else 
        null-- 其它
    end	as insbene_cus_pro,-- 被保人或受益人类型 11：个人；12：单位
	/* 投保人、被保险人之间的关系 unpass*/  -- 11: 本单位; 12: 本单位董事、监事或高级管理人员; 13: 雇佣或劳务; 14: 其他填写数字。
	'' as relation,-- 投保人、被保人之间的关系 11：本单位；12本单位董事、监事或高级管理人员；13：雇佣或劳务；14：其他
	/* 受益人标识 unpass*/  -- 11: 法定受益人; 12: 非法定受益人。当被保险人或受益人标识Insfav_type='12'时填写。
	'' as fav_type,-- 受益人标识 11：法定受益人；12非法定受益人 insfav_type=12时填写
	b.c_acc_name as name,-- 被保人或受益人名称
	concat(rpad(b.c_cert_cls, 6, '0') , rpad(b.c_cert_cde, 18, '0')) as insbene_cst_no,-- 被保险人或受益人客户号
	b.c_cert_cde as insbene_id_no,-- 被保险人或受益人身份证件号码
	'20191013000000' pt	
from x_rpt_fxq_tb_ins_rpol_gpol m
    --  保单人员参于类型: 投保人: [个人:21, 法人:22]; 被保人: [个人:31, 法人:32, 团单被保人:33]; 受益人: [个人:41, 法人:42,团单受益人:43]; 收款人:[11]
	inner join edw_cust_ply_party partition(pt20191013000000) a on m.c_app_no=a.c_app_no and a.c_per_biztype =  22 
	inner join edw_cust_ply_party partition(pt20191013000000) b on m.c_app_no=b.c_app_no and b.c_per_biztype in (41, 42, 43) 
	inner join rpt_fxq_tb_company_ms partition (pt20191013000000) co on co.company_code1 = m.c_dpt_cde
where m.t_next_edr_udr_tm > {endday} and a.c_clnt_mrk = 0
	and m.t_app_tm between {beginday} and {endday} 