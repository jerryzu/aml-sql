-- *********************************************************************************
--  文件名称: 33rpt_fxq_tb_amltp_risk.sql
--  所属主题: 中国人民银行反洗钱执法检查数据提取接口
--  功能描述: 将风险评估的客户信息关联评风信息形成客户风险评估信息
--  关联保单客户表(合并自然人，非自然人)，形成最终客户一致化的客户风险评估信息表
--   表提取数据
--            导入到 (rpt_fxq_tb_amltp_risk) 表
--  创建者:祖新合
--  输入: 
--  rpt_fxq_tb_amltp_entity
--  rpt_fxq_tb_amltp_score
--    edw_cust_pers_info
--    edw_cust_units_info
--  rpt_fxq_manual_company_ms
--  输出:  rpt_fxq_tb_amltp_risk
--  创建日期: 2019/10/30
--  修改日志: 
--  修改日期: 
--  修改人: 
--  修改内容：

alter table rpt_fxq_tb_amltp_risk truncate partition pt{workday}000000;

insert into rpt_fxq_tb_amltp_risk(
	company_code1,
	company_code2,
	company_code3,
	c_acc_name,
	c_cst_no,
	c_cert_cde,
	risk_code,
	score_time,
	score,
	norm,
	pt
)
select
	co.company_code1,	--	机构网点代码
	co.company_code2,	--	金融机构编码
	null company_code3,	--	保单归属机构网点代码
	pi.c_acc_name c_acc_name,	--	投保人名称
	e.c_cst_no c_cst_no,	--	投保人客户号
	e.c_cert_cde c_cert_cde,	--	投保人证件号码
	case 
		when r.score > 90 then 10 -- '高'
		when r.score > 80 then 11 -- '中高'
		when r.score > 70 then 12 -- '中'
		when r.score > 50 then 13 -- '中低'
	else 
		14 -- '低'
	end as risk_code,	--	风险等级
	r.score_time score_time,	--	划分日期	
	r.score score,	--	评分分值
	'依据评分分值划分' norm,	--	划分依据
	'{workday}000000' pt	--	分区字段
from rpt_fxq_tb_amltp_entity  partition (pt{workday}000000) e
    inner join rpt_fxq_tb_amltp_score  partition (pt{workday}000000) r on e.c_clnt_cde = r.c_clnt_cde
    inner join (select c_cst_no, c_cert_cls, c_cert_cde, c_acc_name, c_dpt_cde from edw_cust_pers_info partition (pt{workday}000000)
		union 
		select c_cst_no, c_certf_cls, c_certf_cde, c_acc_name, c_dpt_cde from edw_cust_units_info partition (pt{workday}000000)
	--  ) pi on e.c_cst_no = pi.c_cst_no
	) pi on e.c_cert_type = pi.c_cert_cls and e.c_cert_cde = pi.c_cert_cde
    inner join  rpt_fxq_manual_company_ms co on co.company_code1 = pi.c_dpt_cde
where 	e.c_cert_type is not null and trim(e.c_cert_type)  <> '' and e.c_cert_type REGEXP '[^0-9.]' = 0
			and e.c_cert_cde is not null and trim(e.c_cert_cde)  <> '' 
order by r.c_clnt_cde, r.score_time;