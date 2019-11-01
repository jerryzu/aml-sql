-- *********************************************************************************
--  文件名称: 14rpt_fxq_tb_ins_risk_new_ms.sql
--  所属主题: 中国人民银行反洗钱执法检查数据提取接口
--  功能描述: 通过客户风险等级表(rpt_fxq_tb_amltp_risk),根据客户号倒排序获取客户最新风险等级
--   表提取数据
--            导入到 (rpt_fxq_tb_ins_risk_new_ms) 表
--  创建者:祖新合 
--  输入:  rpt_fxq_tb_amltp_risk
--  输出:  rpt_fxq_tb_ins_risk_new_ms
--  创建日期: 2019/10/30
--  修改日志: 
--  修改日期: 
--  修改人: 
--  修改内容：
--  说明：
--   1.本表数据范围为截止检查业务期限结束日，在检查对象尚存在业务关系的所有客户（投保人）的最新一次（最新时间为提取数据当日）风险等级划分记录。  
--   2.对于检查业务期限起始日至提取数据日期间结束业务关系的客户，其风险等级划分记录也应导入本表。  
--   3.对于检查业务期限起始日前已结束业务关系的客户，以及检查业务期限结束日至提数日新建业务关系的客户，其风险等级划分记录可不导入本表。

alter table rpt_fxq_tb_ins_risk_new_ms truncate partition pt{workday}000000;

insert into rpt_fxq_tb_ins_risk_new_ms(
	company_code1,	--	机构网点代码
	company_code2,	--	金融机构编码
	company_code3,	--	保单归属机构网点代码
	app_name,	--	投保人名称
	app_cst_no,	--	投保人客户号
	app_id_no,	--	投保人证件号码
	risk_code,	--	风险等级
	div_date,	--	划分日期
	score,	--	评分分值
	norm,	--	划分依据
	pt	--	分区字段
)
select
    company_code1,
    company_code2,
    company_code3,
    app_name,
    app_cst_no,
    app_id_no,
    risk_code,
    div_date,
    score,
    norm,
    pt
from (
    select
        company_code1,	--	机构网点代码
        company_code2,	--	金融机构编码
        company_code3,	--	保单归属机构网点代码
        c_acc_name app_name,	--	投保人名称
        c_cst_no app_cst_no,	--	投保人客户号
        c_cert_cde app_id_no,	--	投保人证件号码
        risk_code,	--	风险等级
        score_time,	--	划分日期
        date_format(score_time,'%Y%m%d') div_date,	--	划分日期
		-- 倒排序每人取最新记录
        if(@u=c_cst_no,@n:=0,@n:=1) as rank,
        @u:=                             c_cst_no,
        @s:=                             score_time,
        score,	--	评分分值
		/* 划分依据 unpass*/  -- 填写具体划分标准及相应得分分值, 多个标准间用"; "隔开。如, 保单险种2分; 保险期间3分等, 如采用直接评级的, 填写评级理由, 如"涉及保险欺诈"等。
        norm,	--	划分依据
        '{workday}000000' pt	--	分区字段
    from rpt_fxq_tb_amltp_risk  partition (pt{workday}000000) r,  (select @u:=null, @r:=0, @n:=0) r1
    order by app_cst_no, div_date desc
    ) v
where v.rank = 1 and v.score_time between str_to_date('{beginday}000000','%Y%m%d%H%i%s') and str_to_date('{endday}235959','%Y%m%d%H%i%s')