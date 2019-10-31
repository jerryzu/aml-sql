-- *********************************************************************************
--  文件名称: 31rpt_fxq_tb_amltp_entity.sql
--  所属主题: 中国人民银行反洗钱执法检查数据提取接口
--  功能描述: 对客户风险等级打分主表(ods_amltp_t_score),按客户编号，打分时间，逆排序取出最新打分对应的客户信息
--   表提取数据
--            导入到 (rpt_fxq_tb_amltp_entity) 表
--  创建者:祖新合 
--  输入: 
-- ods_amltp_t_score
--  输出:  rpt_fxq_tb_amltp_entity
--  创建日期: 2019/10/30
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

-- 100111		100111 11 -- 税务登记证
-- 100112		100112 13 -- 统一社会信用代码
-- 110001		110001 12 -- 组织机构代码
-- 110002		110002 13 -- 工商注册号码
-- 110003		110003 14 -- 营业执照
-- 110009		
-- 120001		120001 11 -- 居民身份证
-- 120002		120002 13 -- 护照
-- 120003		120003 12 -- 军人证
-- 120004		120004 13 -- 回乡证
-- 120005		120005 14 -- 港澳居民居住证
-- 120006		120006 14 -- 台湾居民居住证
-- 120009		120009 18 -- 其它

*/
alter table rpt_fxq_tb_amltp_entity truncate partition pt20191013000000;

insert into rpt_fxq_tb_amltp_entity(
    c_cst_no	
    ,c_clnt_nme	
    ,c_cert_type	
    ,c_cert_cde	
    ,c_clnt_cde
	,pt
)
select 
    case c_clnt_mrk 
	when 1 then  -- 客户分类,0 法人，1 个人
               concat('1', c_cst_no, mod(substr(c_cst_no, -7, 6), 9)) 
	when 0 then   -- 客户分类,0 法人，1 个人
               concat('2', c_cst_no, mod(substr(c_cst_no, -7, 6), 9)) 
        end c_cst_no


    ,c_clnt_nme 
    ,c_certf_type c_cert_type
    ,c_certf_cde c_cert_cde
    ,c_clnt_cde
    ,'20191013000000' pt	--	分区字段
from (select
        case left(c_certf_type,2) 
            when 10 then 0 
            when 11 then 0 
            when 12 then 1 
        else 
            1 
        end c_clnt_mrk, -- 客户分类,0 法人，1 个人
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
        ods_amltp_t_score partition(pt20191013000000),(select @u:=null, @r:=0) r 
    where  app_or_ins = 1
		and  c_certf_type is not null and trim(c_certf_type)  <> '' and c_certf_type REGEXP '[^0-9.]' = 0
        and c_certf_cde is not null and trim(c_certf_cde)  <> '' and left(c_certf_cde, 17)  REGEXP '[^0-9.]' = 0
    order by
        c_clnt_cde, t_crt_tm
) v
where rank = 1;

-- apply_date	投保日期
-- accept_date	保单承保日期