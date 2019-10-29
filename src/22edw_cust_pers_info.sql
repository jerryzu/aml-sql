-- *********************************************************************************
--  文件名称: 22edw_cust_pers_info.sql
--  所属主题: 保单-客户主题
--  功能描述: 保单人员中间表过滤保单人员类型为1(自然人) 
--   关联保单表,根据规则策略取最新保单人员信息
--   表提取数据
--            导入到 (edw_cust_pers_info) 表
--  创建者: 
--  输入: 
--  x_edw_cust_pers_units_info  --  保单人员中间表
--  ods_cthx_web_ply_base  -- 保单表
--  输出:  edw_cust_pers_info
--  创建日期: 2017/6/7
--  修改日志: 
--  修改日期: 
--  修改人: 
--  修改内容：

SELECT @@global.group_concat_max_len;
SET SESSION group_concat_max_len=1024000;


alter table edw_cust_pers_info truncate partition pt20191013000000;

INSERT INTO edw_cust_pers_info(
    c_dpt_cde,
    c_cst_no,
    t_open_time,
    t_close_time,
    c_acc_name,
    c_cst_sex,
    c_country,
    c_cert_cls,
    c_cert_cde,
    t_cert_end_date,
    c_occup_cde,
    n_income,
    c_mobile,
    c_clnt_addr,
    c_work_dpt,
    pt
)
select 
    substring_index(c_dpt_cde,',',1) c_dpt_cde
    ,c_cst_no
    ,t_open_time t_open_time
    ,t_close_time  t_close_time
    ,substring_index(c_acc_name,',',1) c_acc_name
    ,substring_index(c_cst_sex,',',1) c_cst_sex
    ,substring_index(c_country,',',1) c_country
    ,substring_index(c_cert_cls,',',1) c_cert_cls
    ,substring_index(c_cert_cde,',',1) c_cert_cde
    ,substring_index(c_cert_end_date,',',1) c_cert_end_date
    ,substring_index(c_occup_cde,',',1) c_occup_cde
    ,substring_index(n_income,',',1) n_income
    ,substring_index(c_mobile,',',1) c_mobile
    ,substring_index(c_clnt_addr,',',1) c_clnt_addr
    ,substring_index(c_work_dpt,',',1) c_work_dpt
    ,'20191013000000' pt
from (
	select     
	    group_concat(c_dpt_cde order by biz_type)  c_dpt_cde
	    ,c_cst_no -- ,group_concat(c_cst_no order by biz_type)  c_cst_no
	    ,min(t_open_time)  t_open_time
	    ,max(ifnull(t_close_time,adddate('9999-12-31',0)))  t_close_time
	    ,group_concat(c_acc_name order by biz_type)  c_acc_name
	    ,group_concat(c_sex order by biz_type)  c_cst_sex
	    ,group_concat(c_country order by biz_type)  c_country
	    ,group_concat(c_cert_cls order by biz_type)  c_cert_cls
	    ,group_concat(c_cert_cde order by biz_type)  c_cert_cde
	    ,group_concat(c_cert_end_date order by biz_type)  c_cert_end_date
	    ,group_concat(c_occup_cde order by biz_type)  c_occup_cde
	    ,group_concat(n_income order by biz_type)  n_income
	    ,group_concat(c_mobile order by biz_type)  c_mobile
	    ,group_concat(c_clnt_addr order by biz_type)  c_clnt_addr
	    ,group_concat(c_work_dpt order by biz_type)  c_work_dpt
	from (
	    select b.c_dpt_cde c_dpt_cde
		    , c_cst_no -- 投保人代码,投保人唯一客户代码
		    ,date_format(b.t_insrnc_bgn_tm, '%Y%m%d') t_open_time
		    ,date_format(greatest(b.t_insrnc_bgn_tm,b.t_udr_tm,coalesce(b.t_edr_bgn_tm,b.t_insrnc_bgn_tm)), '%Y%m%d') t_close_time
		    , c_acc_name -- 投保人名称
		    ,c_sex  -- 性别
		    ,c_aml_country c_country -- 国籍
		    , c_cert_cls -- 证件类型
		    ,  c_cert_cde -- 证件号码
		    ,date_format(t_certf_end_date, '%Y%m%d') c_cert_end_date -- 证件有效期止
		    ,c_occup_cde  -- 职业代码
		    ,null n_income
		    ,c_mobile  -- 移动电话
		    ,c_clnt_addr c_clnt_addr -- 地址
		    ,c_work_dpt  -- 工作单位
		    ,21 biz_type -- 10: 收款人, 21: 投保人, 22: 法人投保人, 31:被保人, 32:法人被保人, 33: 团单被保人，41: 受益人, 42: 法人受益人, 43: 团单受益人
		from  x_edw_cust_pers_units_info a
            inner join ods_cthx_web_ply_base partition(pt20191013000000)   b on a.c_app_no = b.c_app_no
		where b.t_next_edr_udr_tm > now() and a.c_clnt_mrk = 1 -- 客户分类,0 法人，1 个人
			and c_cert_cls is not null and trim(c_cert_cls)  <> '' and c_cert_cls REGEXP '[^0-9.]' = 0
			and c_cert_cde is not null and trim(c_cert_cde)  <> ''  and left(c_cert_cde, 17)  REGEXP '[^0-9.]' = 0 
		) vw
	where c_cst_no is not null and c_cst_no REGEXP '[^0-9.]' = 0
	group by c_cst_no
) vw