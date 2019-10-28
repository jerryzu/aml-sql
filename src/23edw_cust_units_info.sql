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

SELECT @@global.group_concat_max_len;
SET SESSION group_concat_max_len=102400;
alter table edw_cust_units_info truncate partition pt20191013000000;

insert into edw_cust_units_info(
    c_dpt_cde,
    c_cst_no,
    c_certf_cls,
    c_certf_cde,
    t_open_time,
    t_close_time,
    c_acc_name,
    c_clnt_addr,
    c_manage_area,
    c_buslicence_no,
    c_buslicence_valid,
    c_organization_no,
    c_cevenue_no,
    c_legal_nme,
    c_legal_certf_cls,
    c_legal_certf_cde,
    t_legal_cert_end_tm,
    c_actualholding_nme,
    c_acth_certf_cls,
    c_acth_certf_cde,
    t_acth_certf_end_tm,
    c_ope_name,
    c_ope_certf_cls,
    c_ope_certf_cde,
    t_ope_certf_end_tm,
    c_trd_cde,
    c_sub_trd_cde,
    n_reg_amt,
    pt
)
select 
    substring_index(c_dpt_cde,',',1) c_dpt_cde
    ,c_cst_no 
    ,substring_index(c_certf_cls,',',1) c_certf_cls
    ,substring_index(c_certf_cde,',',1) c_certf_cde
    ,t_open_time t_open_time
    ,t_close_time  t_close_time
    ,substring_index(c_acc_name,',',1) c_acc_name
    ,substring_index(c_clnt_addr,',',1) c_clnt_addr
    ,substring_index(c_manage_area,',',1) c_manage_area
    ,substring_index(c_buslicence_no,',',1) c_buslicence_no
    ,substring_index(c_buslicence_valid,',',1) c_buslicence_valid
    ,substring_index(c_organization_no,',',1) c_organization_no
    ,substring_index(c_cevenue_no,',',1) c_cevenue_no
    ,substring_index(c_legal_nme,',',1) c_legal_nme
    ,substring_index(c_legal_certf_cls,',',1) c_legal_certf_cls
    ,substring_index(c_legal_certf_cde,',',1) c_legal_certf_cde
    ,substring_index(t_legal_certf_end_tm,',',1) t_legal_certf_end_tm
    ,substring_index(c_actualholding_nme,',',1) c_actualholding_nme
    ,substring_index(c_acth_certf_cls,',',1) c_acth_certf_cls
    ,substring_index(c_acth_certf_cde,',',1) c_acth_certf_cde
    ,substring_index(t_acth_certf_end_tm,',',1) t_acth_certf_end_tm
    ,substring_index(c_ope_name,',',1) c_ope_name
    ,substring_index(c_ope_certf_cls,',',1) c_ope_certf_cls
    ,substring_index(c_ope_certf_cde,',',1) c_ope_certf_cde
    ,substring_index(t_ope_certf_end_tm,',',1) t_ope_certf_end_tm
    ,substring_index(c_trd_cde,',',1) c_trd_cde
    ,substring_index(c_sub_trd_cde,',',1) c_sub_trd_cde
    ,substring_index(n_reg_amt,',',1) n_reg_amt    
    ,'20191013000000' pt    
from (
	select     
	    group_concat(c_dpt_cde order by c_per_biztype)  c_dpt_cde
        ,c_cst_no
	    ,group_concat(c_cert_cls order by c_per_biztype)  c_certf_cls
	    ,group_concat(c_cert_cde order by c_per_biztype)  c_certf_cde
	    ,min(t_open_time)  t_open_time
	    ,max(ifnull(t_close_time,adddate('9999-12-31',0)))  t_close_time
	    ,group_concat(c_acc_name order by c_per_biztype)  c_acc_name
	    ,group_concat(c_clnt_addr order by c_per_biztype)  c_clnt_addr
	    ,group_concat(c_manage_area order by c_per_biztype)  c_manage_area
	    ,group_concat(c_buslicence_no order by c_per_biztype)  c_buslicence_no
	    ,group_concat(c_buslicence_valid order by c_per_biztype)  c_buslicence_valid
	    ,group_concat(c_organization_no order by c_per_biztype)  c_organization_no
	    ,group_concat(c_cevenue_no order by c_per_biztype)  c_cevenue_no
	    ,group_concat(c_legal_nme order by c_per_biztype)  c_legal_nme
	    ,group_concat(c_legal_certf_cls order by c_per_biztype)  c_legal_certf_cls
	    ,group_concat(c_legal_certf_cde order by c_per_biztype)  c_legal_certf_cde
	    ,group_concat(t_legal_certf_end_tm order by c_per_biztype)  t_legal_certf_end_tm	    
	    ,group_concat(c_actualholding_nme order by c_per_biztype)  c_actualholding_nme
	    ,group_concat(c_acth_certf_cls order by c_per_biztype)  c_acth_certf_cls
	    ,group_concat(c_acth_certf_cde order by c_per_biztype)  c_acth_certf_cde
	    ,group_concat(t_acth_certf_end_tm order by c_per_biztype)  t_acth_certf_end_tm	    
	    ,group_concat(c_ope_name order by c_per_biztype)  c_ope_name
	    ,group_concat(c_ope_certf_cls order by c_per_biztype)  c_ope_certf_cls
	    ,group_concat(c_ope_certf_cde order by c_per_biztype)  c_ope_certf_cde
	    ,group_concat(t_ope_certf_end_tm order by c_per_biztype)  t_ope_certf_end_tm
	    ,group_concat(c_trd_cde order by c_per_biztype)  c_trd_cde
	    ,group_concat(c_sub_trd_cde order by c_per_biztype)  c_sub_trd_cde
	    ,group_concat(n_reg_amt order by c_per_biztype)  n_reg_amt	  
	from (	  
        select b.c_dpt_cde c_dpt_cde
            , c_cst_no -- 客户号
            ,a.c_cert_cls  -- 证件种类
            ,a.c_cert_cde  -- 证件号码
		    ,date_format(b.t_insrnc_bgn_tm, '%Y%m%d') t_open_time
		    ,date_format(greatest(b.t_insrnc_bgn_tm,b.t_udr_tm,coalesce(b.t_edr_bgn_tm,b.t_insrnc_bgn_tm)), '%Y%m%d') t_close_time
            ,a.c_acc_name  -- 客户名称，
            ,a.c_clnt_addr -- 实际经营地址或注册地址
            ,a.c_manage_area -- 经营范围/业务范围
            ,a.c_buslicence_no -- 依法设立或经营的执照号码
            ,date_format(a.c_buslicence_valid, '%Y%m%d')  c_buslicence_valid -- 依法设立或经营的执照有效期限到期日
            ,a.c_organization_no -- 组织机构代码
            ,a.c_cevenue_no -- 税务登记证号码
            ,a.c_legal_nme -- 法定代表人或负责人姓名
            ,a.c_legal_certf_cls  -- 法定代表人或负责人身份证件种类
            ,a.c_legal_certf_cde  -- 法定代表人或负责人身份证件号码
            ,date_format(a.t_legal_certf_end_tm, '%Y%m%d')  t_legal_certf_end_tm -- 有效期限到期日
            ,a.c_actualholding_nme  -- 控股股东或者实际控制人姓名
            ,a.c_acth_certf_cls -- 控股股东或者实际控制人身份证件类型
            ,a.c_acth_certf_cde  -- 控股股东或者实际控制人身份证件号码
            ,date_format(a.t_acth_certf_end_tm, '%Y%m%d')  t_acth_certf_end_tm -- 控股股东或者实际控制人身份证件有效期限到期日
            ,a.c_ope_name  -- 授权办理业务人员名称
            ,null c_ope_certf_cls -- 授权办理业务人员身份证件类型
            ,null c_ope_certf_cde -- 授权办理业务人员身份证件号码
            ,null t_ope_certf_end_tm -- 授权办理业务人员身份证件有效期限到期日
            ,a.c_trd_cde  -- 行业代码
            ,a.c_sub_trd_cde  -- 行业
            ,null n_reg_amt
            ,c_per_biztype -- 10: 收款人, 21: 投保人, 22: 法人投保人, 31:被保人, 32:法人被保人, 33: 团单被保人，41: 受益人, 42: 法人受益人, 43: 团单受益人
        from x_edw_cust_pers_units_info a
            inner join ods_cthx_web_ply_base partition(pt20191013000000)   b on a.c_app_no = b.c_app_no
        where b.t_next_edr_udr_tm > now() and a.c_clnt_mrk = 0 -- 客户分类,0 法人，1 个人
			and c_cert_cls is not null and trim(c_cert_cls)  <> '' and c_cert_cls REGEXP '[^0-9.]' = 0
			and c_cert_cde is not null and trim(c_cert_cde)  <> '' 
		) vw
	where c_cst_no is not null and c_cst_no REGEXP '[^0-9.]' = 0
	group by vw.c_cst_no
) vw