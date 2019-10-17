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

/*
受益人代码,受益人唯一客户代码
c_cst_no已经编码由身份证类型6位,身份证号码18位组成,这里校验码取倒数第7位至倒数第2位与9取MOD
concat('1', c_cst_no, mod(substr(c_cst_no, -7, 6), 9)) c_cst_no
concat('2', c_cst_no, mod(substr(c_cst_no, -7, 6), 9)) c_cst_no
concat(rpad(c_certf_cls, 6, '0') , rpad(c_certf_cde, 18, '0')) c_cst_no
concat(rpad(c_certf_cls, 6, '0') , rpad(c_certf_cde, 18, '0')) c_cst_no -- 客户号
*/
alter table rpt_fxq_tb_amltp_entity truncate partition pt{lastday}000000;

insert into rpt_fxq_tb_amltp_entity(
    c_cst_no	
    ,c_clnt_nme	
    ,c_cert_type	
    ,c_cert_cde	
    ,c_clnt_cde
	,pt
)
select 
    c_cst_no
    ,c_clnt_nme 
    ,c_certf_type c_cert_type
    ,c_certf_cde c_cert_cde
    ,c_clnt_cde
    ,'{lastday}000000' pt	--	分区字段
from (select
        concat(rpad(c_certf_type, 6, '0') , rpad(c_certf_cde, 18, '0')) c_cst_no,
        c_clnt_nme,
        c_certf_type,
        c_certf_cde,
        c_clnt_cde,
        t_crt_tm,
		--  以下用于每个客户一条记录,处理记录重复
        if(@u=c_clnt_cde ,@r:=@r+1,@r:=1) as rank, 
		@u:=c_clnt_cde 
    from
        ods_amltp_t_score partition(pt{lastday}000000),(select @u:=null, @r:=0) r 
    where
        app_or_ins = 1
    order by
        c_clnt_cde, t_crt_tm
) v
where rank = 1;