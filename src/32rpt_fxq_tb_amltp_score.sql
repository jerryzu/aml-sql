-- *********************************************************************************
--  文件名称: 32rpt_fxq_tb_amltp_score.sql
--  所属主题: 中国人民银行反洗钱执法检查数据提取接口

--  功能描述: 对客户风险等级打分明细表(ods_amltp_t_sco),按客户编号，打分时间，打分次，逆排序取出每次打分对应的分值
--   表提取数据
--            导入到 (rpt_fxq_tb_amltp_score) 表
--  创建者:祖新合 
--  输入: 
-- ods_amltp_t_sco
--  输出:  rpt_fxq_tb_amltp_score
 
--  创建日期: 2019/10/30
--  修改日志: 
--  修改日期: 
--  修改人: 
--  修改内容：

alter table rpt_fxq_tb_amltp_score truncate partition pt{workday}000000;

insert into rpt_fxq_tb_amltp_score(
	c_clnt_cde,
	bat,
	score,
	score_time,
	pt
)
select 
    user_id c_clnt_cde,
    bat,
    score,
    score_time,
    '{workday}000000' pt	--	分区字段
from (select
        t.user_id,
        t.bat,
        t.previous_score score,
        t.score_time,
		--  以下用于每个打分点一条记录,处理记录重复
        if(@u=user_id and @s=score_time,@r:=@r+1,@r:=1) as rank,
        @u:=                             user_id,
        @s:=                             score_time
    from 
        ods_amltp_t_sco partition(pt{workday}000000)  t,  (select @u:=null, @s:=null, @r:=0, @n:=0) r
    where 
        t.app_or_ins = 1 and previous_score is not null --  and t.status
    order by
        t.user_id,
        t.score_time,
        t.bat,
        t.previous_score
) v
where rank = 1
order by user_id;