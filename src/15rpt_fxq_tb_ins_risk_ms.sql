-- *********************************************************************************
--  文件名称: 15rpt_fxq_tb_ins_risk_ms.sql
--  所属主题: 中国人民银行反洗钱执法检查数据提取接口
--  功能描述: 通过客户风险等级表(rpt_fxq_tb_amltp_risk),根据客户号排序获取客户等级，并进行首次标识( 11是, 12否)。
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
--   1.本表数据范围为检查业务期限内，曾经在检查对象建立过业务关系、且截至检查业务期限起始日尚存在业务关系的所有客户（投保人）的历次（指检查业务期限内历次）风险等级划分记录。  
--   2.对于检查业务期限起始日至提取数据日期（指保险机构提取检查所需数据的实际时点，具体到提数当天）间结束业务关系的客户，其风险等级划分记录也应导入本表。  
--   3.对于检查业务期限起始日前已结束业务关系的客户，其风险等级划分记录可不导入本表。存量客户每次的划分记录均应当生成一条记录。

alter table rpt_fxq_tb_ins_risk_ms truncate partition pt{workday}000000;

insert into rpt_fxq_tb_ins_risk_ms(
	company_code1,	--	机构网点代码
	company_code2,	--	金融机构编码
	company_code3,	--	保单归属机构网点代码
	app_name,	--	投保人名称
	app_cst_no,	--	投保人客户号
	app_id_no,	--	投保人证件号码
	risk_code,	--	风险等级
	div_date,	--	划分日期
	first_type,	--	首次标识
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
    first_type,
    score,
    norm,
    '{workday}000000' pt	--	分区字段
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
        date_format(score_time,'%Y%m%d')  div_date,	--	划分日期	
        if(@u=c_cst_no,@n:=12,@n:=11) as first_type,	--	首次标识 11是, 12否。
        if(@u=c_cst_no and @s=score_time,@r:=@r+1,@r:=1) as rank,
        @u:=                             c_cst_no,
        @s:=                             score_time,
        score,	--	评分分值
		/* 划分依据 unpass*/  -- 填写具体划分标准及相应得分分值, 多个标准间用"; "隔开。如, 保单险种2分; 保险期间3分等, 如采用直接评级的, 填写评级理由, 如"涉及保险欺诈"等。
		norm	--	划分依据
    from rpt_fxq_tb_amltp_risk  partition (pt{workday}000000) r,  (select @u:=null, @s:=null, @r:=0, @n:=0) r1
    order by app_cst_no, div_date
    ) v
where v.rank = 1 and v.score_time between str_to_date('{beginday}000000','%Y%m%d%H%i%s') and str_to_date('{endday}235959','%Y%m%d%H%i%s')