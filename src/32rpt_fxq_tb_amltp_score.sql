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

alter table rpt_fxq_tb_amltp_score truncate partition pt20191013000000;

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
    '20191013000000' pt	--	分区字段
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
        ods_amltp_t_sco partition(pt20191013000000)  t,  (select @u:=null, @s:=null, @r:=0, @n:=0) r
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