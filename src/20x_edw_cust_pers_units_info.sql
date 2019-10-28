truncate table x_edw_cust_pers_units_info;

/*
投保人信息导入
*/
insert into x_edw_cust_pers_units_info(
        c_ply_no	 -- 	保单号，保单号 Policy No
        ,c_app_no	 -- 	申请单号，批改申请单号
        ,c_per_biztype	 -- 	保单人员参于类型:投保人: 个人:21, 法人:22 ,    被保人:个人:31, 法人:32 ,受益人:个人:41, 法人:42, 团单被保人:33,团单受益人:43,收款人:11
        ,c_cst_no	 -- 	客户号
        ,c_app_ins_rel -- 投保人与被保人之间的关系
        ,c_bnfc_ins_rel -- 受益人与被保险人之间的关系
        ,c_ins_app_rel -- 被保险人与投保人之间的关系
        ,c_clnt_mrk	 -- 	客户分类,0 法人，1 个人
        ,c_acc_name	 -- 	投保人名称
        ,c_cert_cls	 -- 	证件类型
        ,c_cert_cde	 -- 	证件号码
        ,c_manage_area	 -- 	经营范围
        ,c_buslicence_no	 -- 	营业执照号
        ,c_buslicence_valid	 -- 	营业执照号有效期
        ,c_organization_no	 -- 	组织机构代码
        ,c_cevenue_no	 -- 	税务登记号
        ,c_legal_nme	 -- 	法定代表人姓名
        ,c_legal_certf_cls	 -- 	法定代表人证件类型
        ,c_legal_certf_cde	 -- 	法定代表人证件号码
        ,t_legal_certf_end_tm	 -- 	法定代表人证件有效期限
        ,c_actualholding_nme	 -- 	控股股东或者实际控制人姓名
        ,c_acth_certf_cls	 -- 	控股股东或者实际控制人身份证件类型
        ,c_acth_certf_cde	 -- 	控股股东或者实际控制人身份证件号码
        ,t_acth_certf_end_tm	 -- 	控股股东或者实际控制人身份证件有效期限到期日
        ,c_ope_name	 -- 	授权办理业务人员名称(投保人联系人)
        ,c_ope_certf_cls	 -- 	授权办理业务人员身份证件类型
        ,c_ope_certf_cde	 -- 	授权办理业务人员身份证件号码
        ,t_ope_certf_end_tm	 -- 	授权办理业务人员身份证件有效期限到期日
        ,c_trd_cde	 -- 	行业代码
        ,c_sub_trd_cde	 -- 	行业细分代码
        ,n_reg_amt	 -- 	注册资本金
        ,c_sex	 -- 	性别
        ,c_aml_country	 -- 	国籍
        ,t_certf_end_date	 -- 	证件有效期止
        ,c_occup_cde	 -- 	职业代码
        ,n_income	 -- 	年收入
        ,c_mobile	 -- 	移动电话
        ,c_clnt_addr	 -- 	地址
        ,c_work_dpt	 -- 	工作单位
)
select 
    c_ply_no
    ,c_app_no
    ,case c_clnt_mrk 
	when 1 then  -- 客户分类,0 法人，1 个人
		21 
	when 0 then   -- 客户分类,0 法人，1 个人
		22
    end c_per_biztype	 -- 	保单人员参于类型:投保人: 个人:21, 法人:22 ,    被保人:个人:31, 法人:32 ,受益人:个人:41, 法人:42, 团单被保人:33,团单受益人:43,收款人:11
    -- c_cst_no已经编码由身份证类型6位,身份证号码18位组成,这里校验码取倒数第7位至倒数第2位与9取MOD
    ,case c_clnt_mrk 
	when 1 then  -- 客户分类,0 法人，1 个人
               concat('1', concat(rpad(c_certf_cls, 6, '0') , rpad(c_certf_cde, 18, '0')), mod(substr(concat(rpad(c_certf_cls, 6, '0') , rpad(c_certf_cde, 18, '0')), -7, 6), 9)) 
	when 0 then   -- 客户分类,0 法人，1 个人
               concat('2', concat(rpad(c_certf_cls, 6, '0') , rpad(c_certf_cde, 18, '0')), mod(substr(concat(rpad(c_certf_cls, 6, '0') , rpad(c_certf_cde, 18, '0')), -7, 6), 9)) 
    end c_cst_no

	,c_rel_cde c_app_ins_rel -- 投保人与被保人之间的关系[ods_cthx_web_ply_applicant.c_rel_cde]',
    ,null c_bnfc_ins_rel -- 受益人与被保险人之间的关系[ods_cthx_web_ply_bnfc.c_rel_cde ]',
    ,null c_ins_app_rel -- 被保险人与投保人之间的关系[web_app_insured.c_app_relation]',	

    ,c_clnt_mrk  -- 客户分类,0 法人，1 
	,c_app_nme c_acc_name -- 投保人名称
    ,c_certf_cls c_cert_cls -- 证件类型
    ,c_certf_cde  c_cert_cde -- 证件号码
    
    ,c_manage_area -- 经营范围/业务范围
    ,c_buslicence_no -- 依法设立或经营的执照号码
    ,c_buslicence_valid
    ,c_organization_no -- 组织机构代码
    ,c_cevenue_no -- 税务登记证号码
    
    ,c_legal_nme -- 法定代表人或负责人姓名
    ,c_legal_certf_cls  -- 法定代表人或负责人身份证件种类
    ,c_legal_certf_cde  -- 法定代表人或负责人身份证件号码
    ,t_legal_certf_end_tm -- 有效期限到期日
    
    ,c_actualholding_nme  -- 控股股东或者实际控制人姓名
    ,c_acth_certf_cls -- 控股股东或者实际控制人身份证件类型
    ,c_acth_certf_cde  -- 控股股东或者实际控制人身份证件号码
    , t_acth_certf_end_tm -- 控股股东或者实际控制人身份证件有效期限到期日
    ,c_cntr_nme  c_ope_name-- 授权办理业务人员名称(c_cntr_nme as c_ope_name)
    ,null c_ope_certf_cls -- 授权办理业务人员身份证件类型
    ,null c_ope_certf_cde -- 授权办理业务人员身份证件号码
    ,null t_ope_certf_end_tm -- 授权办理业务人员身份证件有效期限到期日
    ,c_trd_cde  -- 行业代码
    ,c_sub_trd_cde  -- 行业
    ,null n_reg_amt
    
    ,c_sex -- 性别
    ,c_aml_country -- 国籍
    ,t_certf_end_date -- 证件有效期止
    ,c_occup_cde  -- 职业代码
    ,null n_income -- 个人收入
    ,c_mobile  -- 移动电话
    ,c_clnt_addr  -- 地址
    ,c_work_dpt  -- 工作单位
from ods_cthx_web_ply_applicant partition(pt20191013000000)
where c_certf_cls is not null and trim(c_certf_cls)  <> '' and c_certf_cls REGEXP '[^0-9.]' = 0
        and c_certf_cde is not null and trim(c_certf_cde)  <> '' and left(c_certf_cde, 17)  REGEXP '[^0-9.]' = 0;

/*
被保人导入
*/
insert into x_edw_cust_pers_units_info(
        c_ply_no	 -- 	保单号，保单号 Policy No
        ,c_app_no	 -- 	申请单号，批改申请单号
        ,c_per_biztype	 -- 	保单人员参于类型:投保人: 个人:21, 法人:22 ,    被保人:个人:31, 法人:32 ,受益人:个人:41, 法人:42, 团单被保人:33,团单受益人:43,收款人:11
        ,c_cst_no	 -- 	客户号
        ,c_app_ins_rel -- 投保人与被保人之间的关系
        ,c_bnfc_ins_rel -- 受益人与被保险人之间的关系
        ,c_ins_app_rel -- 被保险人与投保人之间的关系
        ,c_clnt_mrk	 -- 	客户分类,0 法人，1 个人
        ,c_acc_name	 -- 	投保人名称
        ,c_cert_cls	 -- 	证件类型
        ,c_cert_cde	 -- 	证件号码
        ,c_manage_area	 -- 	经营范围
        ,c_buslicence_no	 -- 	营业执照号
        ,c_buslicence_valid	 -- 	营业执照号有效期
        ,c_organization_no	 -- 	组织机构代码
        ,c_cevenue_no	 -- 	税务登记号
        ,c_legal_nme	 -- 	法定代表人姓名
        ,c_legal_certf_cls	 -- 	法定代表人证件类型
        ,c_legal_certf_cde	 -- 	法定代表人证件号码
        ,t_legal_certf_end_tm	 -- 	法定代表人证件有效期限
        ,c_actualholding_nme	 -- 	控股股东或者实际控制人姓名
        ,c_acth_certf_cls	 -- 	控股股东或者实际控制人身份证件类型
        ,c_acth_certf_cde	 -- 	控股股东或者实际控制人身份证件号码
        ,t_acth_certf_end_tm	 -- 	控股股东或者实际控制人身份证件有效期限到期日
        ,c_ope_name	 -- 	授权办理业务人员名称(投保人联系人)
        ,c_ope_certf_cls	 -- 	授权办理业务人员身份证件类型
        ,c_ope_certf_cde	 -- 	授权办理业务人员身份证件号码
        ,t_ope_certf_end_tm	 -- 	授权办理业务人员身份证件有效期限到期日
        ,c_trd_cde	 -- 	行业代码
        ,c_sub_trd_cde	 -- 	行业细分代码
        ,n_reg_amt	 -- 	注册资本金
        ,c_sex	 -- 	性别
        ,c_aml_country	 -- 	国籍
        ,t_certf_end_date	 -- 	证件有效期止
        ,c_occup_cde	 -- 	职业代码
        ,n_income	 -- 	年收入
        ,c_mobile	 -- 	移动电话
        ,c_clnt_addr	 -- 	地址
        ,c_work_dpt	 -- 	工作单位
)
select 
         null c_ply_no  -- 保单号，保单号 Policy No
        ,c_app_no  -- 申请单号，批改申请单号
        ,case c_clnt_mrk 
	when 1 then  -- 客户分类,0 法人，1 个人
		31 
	when 0 then   -- 客户分类,0 法人，1 个人
		32
    end c_per_biztype	 -- 	保单人员参于类型:投保人: 个人:21, 法人:22 ,    被保人:个人:31, 法人:32 ,受益人:个人:41, 法人:42, 团单被保人:33,团单受益人:43,收款人:11
    -- c_cst_no已经编码由身份证类型6位,身份证号码18位组成,这里校验码取倒数第7位至倒数第2位与9取MOD
	,case c_clnt_mrk 
	when 1 then  -- 客户分类,0 法人，1 个人
               concat('1', concat(rpad(c_certf_cls, 6, '0') , rpad(c_certf_cde, 18, '0')), mod(substr(concat(rpad(c_certf_cls, 6, '0') , rpad(c_certf_cde, 18, '0')), -7, 6), 9)) 
	when 0 then   -- 客户分类,0 法人，1 个人
               concat('2', concat(rpad(c_certf_cls, 6, '0') , rpad(c_certf_cde, 18, '0')), mod(substr(concat(rpad(c_certf_cls, 6, '0') , rpad(c_certf_cde, 18, '0')), -7, 6), 9)) 
        end c_cst_no

	,null c_app_ins_rel -- 投保人与被保人之间的关系[ods_cthx_web_ply_applicant.c_rel_cde]',
    ,null c_bnfc_ins_rel -- 受益人与被保险人之间的关系[ods_cthx_web_ply_bnfc.c_rel_cde ]',
    ,c_app_relation c_ins_app_rel -- 被保险人与投保人之间的关系[web_app_insured.c_app_relation]',	

        ,c_clnt_mrk  -- 客户分类,0 法人，1 个人
        ,c_insured_nme  -- 被保人名称
        ,c_certf_cls -- 证件类型
        ,c_certf_cde -- 证件号码
        ,c_manage_area  -- 经营范围/业务范围
        ,c_buslicence_no  -- 依法设立或经营的执照号码
        ,c_buslicence_valid -- 依法设立或经营的执照有效期限到期日
        ,c_organization_no  -- 组织机构代码
        ,c_cevenue_no  -- 税务登记证号码
        ,c_legal_nme  -- 法定代表人或负责人姓名
        ,c_legal_certf_cls  -- 法定代表人或负责人身份证件种类
        ,c_legal_certf_cde  -- 法定代表人或负责人身份证件号码
        ,t_legal_certf_end_tm -- 有效期限到期日
        ,c_actualholding_nme  -- 控股股东或者实际控制人姓名
        ,c_acth_certf_cls  -- 控股股东或者实际控制人身份证件类型
        ,c_acth_certf_cde  -- 控股股东或者实际控制人身份证件号码
        ,t_acth_certf_end_tm -- 控股股东或者实际控制人身份证件有效期限到期日
        ,c_cntr_nme c_ope_name -- 授权办理业务人员名称
        ,c_operater_certf_cde  -- 授权办理业务人员身份证件号码
        ,null c_ope_certf_cde -- 授权办理业务人员身份证件号码
        ,null t_ope_certf_end_tm
        ,c_trd_cde  -- 行业
        ,null  c_sub_trd_cde  -- 行业
        ,null  reg_amt -- 注册资本金
        ,c_sex  -- 性别
        ,c_aml_country  -- 国籍
        ,t_certf_end_date -- 证件有效期止
        ,c_occup_cde -- 职业代码  
        ,n_income  -- 年薪
        ,c_mobile  -- 移动电话
        ,c_clnt_addr -- 地址
        ,c_work_dpt -- 工作单位
from ods_cthx_web_app_insured partition(pt20191013000000)
where c_certf_cls is not null and trim(c_certf_cls)  <> '' and c_certf_cls REGEXP '[^0-9.]' = 0
        and c_certf_cde is not null and trim(c_certf_cde)  <> '' and left(c_certf_cde, 17)  REGEXP '[^0-9.]' = 0;


/* 
受益人导入
*/
insert into x_edw_cust_pers_units_info(
        c_ply_no	 -- 	保单号，保单号 Policy No
        ,c_app_no	 -- 	申请单号，批改申请单号
        ,c_per_biztype	 -- 	保单人员参于类型:投保人: 个人:21, 法人:22 ,    被保人:个人:31, 法人:32 ,受益人:个人:41, 法人:42, 团单被保人:33,团单受益人:43,收款人:11
        ,c_cst_no	 -- 	客户号
        ,c_app_ins_rel -- 投保人与被保人之间的关系
        ,c_bnfc_ins_rel -- 受益人与被保险人之间的关系
        ,c_ins_app_rel -- 被保险人与投保人之间的关系
        ,c_clnt_mrk	 -- 	客户分类,0 法人，1 个人
        ,c_acc_name	 -- 	投保人名称
        ,c_cert_cls	 -- 	证件类型
        ,c_cert_cde	 -- 	证件号码
        ,c_manage_area	 -- 	经营范围
        ,c_buslicence_no	 -- 	营业执照号
        ,c_buslicence_valid	 -- 	营业执照号有效期
        ,c_organization_no	 -- 	组织机构代码
        ,c_cevenue_no	 -- 	税务登记号
        ,c_legal_nme	 -- 	法定代表人姓名
        ,c_legal_certf_cls	 -- 	法定代表人证件类型
        ,c_legal_certf_cde	 -- 	法定代表人证件号码
        ,t_legal_certf_end_tm	 -- 	法定代表人证件有效期限
        ,c_actualholding_nme	 -- 	控股股东或者实际控制人姓名
        ,c_acth_certf_cls	 -- 	控股股东或者实际控制人身份证件类型
        ,c_acth_certf_cde	 -- 	控股股东或者实际控制人身份证件号码
        ,t_acth_certf_end_tm	 -- 	控股股东或者实际控制人身份证件有效期限到期日
        ,c_ope_name	 -- 	授权办理业务人员名称(投保人联系人)
        ,c_ope_certf_cls	 -- 	授权办理业务人员身份证件类型
        ,c_ope_certf_cde	 -- 	授权办理业务人员身份证件号码
        ,t_ope_certf_end_tm	 -- 	授权办理业务人员身份证件有效期限到期日
        ,c_trd_cde	 -- 	行业代码
        ,c_sub_trd_cde	 -- 	行业细分代码
        ,n_reg_amt	 -- 	注册资本金
        ,c_sex	 -- 	性别
        ,c_aml_country	 -- 	国籍
        ,t_certf_end_date	 -- 	证件有效期止
        ,c_occup_cde	 -- 	职业代码
        ,n_income	 -- 	年收入
        ,c_mobile	 -- 	移动电话
        ,c_clnt_addr	 -- 	地址
        ,c_work_dpt	 -- 	工作单位
)
select 
         c_ply_no  -- 保单号，保单号 Policy No
        ,c_app_no  -- 申请单号，批改申请单号
        ,case c_clnt_mrk 
	when 1 then  -- 客户分类,0 法人，1 个人
		41 
	when 0 then   -- 客户分类,0 法人，1 个人
		42
    end c_per_biztype  -- 	保单人员参于类型:投保人: 个人:21, 法人:22 ,    被保人:个人:31, 法人:32 ,受益人:个人:41, 法人:42, 团单被保人:33,团单受益人:43,收款人:11
    -- c_cst_no已经编码由身份证类型6位,身份证号码18位组成,这里校验码取倒数第7位至倒数第2位与9取MOD
	,case c_clnt_mrk 
	when 1 then  -- 客户分类,0 法人，1 个人
               concat('1', concat(rpad(c_certf_cls, 6, '0') , rpad(c_certf_cde, 18, '0')), mod(substr(concat(rpad(c_certf_cls, 6, '0') , rpad(c_certf_cde, 18, '0')), -7, 6), 9)) 
	when 0 then   -- 客户分类,0 法人，1 个人
               concat('2', concat(rpad(c_certf_cls, 6, '0') , rpad(c_certf_cde, 18, '0')), mod(substr(concat(rpad(c_certf_cls, 6, '0') , rpad(c_certf_cde, 18, '0')), -7, 6), 9)) 
        end c_cst_no

        ,null c_app_ins_rel -- 投保人与被保人之间的关系[ods_cthx_web_ply_applicant.c_rel_cde]',
        ,c_rel_cde c_bnfc_ins_rel -- 受益人与被保险人之间的关系[ods_cthx_web_ply_bnfc.c_rel_cde ]',
        ,null c_ins_app_rel -- 被保险人与投保人之间的关系[web_app_insured.c_app_relation]',	

        ,c_clnt_mrk -- 客户分类,0 法人，1 个人
        ,c_bnfc_nme c_acc_name -- 受益人名称
        ,c_certf_cls -- 证件类型
        ,c_certf_cde --  证件号码
        ,null c_manage_area        
        ,null c_buslicence_no
        ,null c_buslicence_valid
        ,null c_organization_no
        ,null c_cevenue_no
        ,null c_legal_nme        
        ,null c_legal_certf_cls
        ,null c_legal_certf_cde
        ,null t_legal_certf_end_tm
        ,null c_actualholding_nme
        ,null c_acth_certf_cls
        ,null c_acth_certf_cde
        ,null t_acth_certf_end_tm
        ,c_cntr_nme c_ope_name -- 授权办理业务人员名称
        ,null c_ope_certf_cls -- 授权办理业务人员身份证件类型
        ,null c_ope_certf_cde -- 授权办理业务人员身份证件号码
        ,null t_ope_certf_end_tm
        ,null c_trd_cde
        ,null c_sub_trd_cde
        ,null reg_amt
        ,c_sex  c_cst_sex -- 性别
        ,c_country -- 国家
        ,null t_certf_end_date
        ,null occupation_code
        ,null n_income
        ,c_mobile  c_mobile -- 移动电话
        ,null  c_clnt_addr -- 地址
        ,null c_work_dpt  -- 工作单位
from ods_cthx_web_ply_bnfc partition(pt20191013000000)		
where c_certf_cls is not null and trim(c_certf_cls)  <> '' and c_certf_cls REGEXP '[^0-9.]' = 0
        and c_certf_cde is not null and trim(c_certf_cde)  <> '' and left(c_certf_cde, 17)  REGEXP '[^0-9.]' = 0;

/* 
团单被保人导入
*/
insert into x_edw_cust_pers_units_info(
        c_ply_no	 -- 	保单号，保单号 Policy No
        ,c_app_no	 -- 	申请单号，批改申请单号
        ,c_per_biztype	 -- 	保单人员参于类型:投保人: 个人:21, 法人:22 ,    被保人:个人:31, 法人:32 ,受益人:个人:41, 法人:42, 团单被保人:33,团单受益人:43,收款人:11
        ,c_cst_no	 -- 	客户号
        ,c_app_ins_rel -- 投保人与被保人之间的关系
        ,c_bnfc_ins_rel -- 受益人与被保险人之间的关系
        ,c_ins_app_rel -- 被保险人与投保人之间的关系
        ,c_clnt_mrk	 -- 	客户分类,0 法人，1 个人
        ,c_acc_name	 -- 	投保人名称
        ,c_cert_cls	 -- 	证件类型
        ,c_cert_cde	 -- 	证件号码
        ,c_manage_area	 -- 	经营范围
        ,c_buslicence_no	 -- 	营业执照号
        ,c_buslicence_valid	 -- 	营业执照号有效期
        ,c_organization_no	 -- 	组织机构代码
        ,c_cevenue_no	 -- 	税务登记号
        ,c_legal_nme	 -- 	法定代表人姓名
        ,c_legal_certf_cls	 -- 	法定代表人证件类型
        ,c_legal_certf_cde	 -- 	法定代表人证件号码
        ,t_legal_certf_end_tm	 -- 	法定代表人证件有效期限
        ,c_actualholding_nme	 -- 	控股股东或者实际控制人姓名
        ,c_acth_certf_cls	 -- 	控股股东或者实际控制人身份证件类型
        ,c_acth_certf_cde	 -- 	控股股东或者实际控制人身份证件号码
        ,t_acth_certf_end_tm	 -- 	控股股东或者实际控制人身份证件有效期限到期日
        ,c_ope_name	 -- 	授权办理业务人员名称(投保人联系人)
        ,c_ope_certf_cls	 -- 	授权办理业务人员身份证件类型
        ,c_ope_certf_cde	 -- 	授权办理业务人员身份证件号码
        ,t_ope_certf_end_tm	 -- 	授权办理业务人员身份证件有效期限到期日
        ,c_trd_cde	 -- 	行业代码
        ,c_sub_trd_cde	 -- 	行业细分代码
        ,n_reg_amt	 -- 	注册资本金
        ,c_sex	 -- 	性别
        ,c_aml_country	 -- 	国籍
        ,t_certf_end_date	 -- 	证件有效期止
        ,c_occup_cde	 -- 	职业代码
        ,n_income	 -- 	年收入
        ,c_mobile	 -- 	移动电话
        ,c_clnt_addr	 -- 	地址
        ,c_work_dpt	 -- 	工作单位
)
select 
         c_ply_no  -- 保单号，保单号 Policy No
        ,c_app_no  -- 申请单号，批改申请单号
        ,33 c_per_biztype	 -- 	保单人员参于类型:投保人: 个人:21, 法人:22 ,    被保人:个人:31, 法人:32 ,受益人:个人:41, 法人:42, 团单被保人:33,团单受益人:43,收款人:11
        -- c_cst_no已经编码由身份证类型6位,身份证号码18位组成,这里校验码取倒数第7位至倒数第2位与9取MOD
	-- ,case c_clnt_mrk 
	-- when 1 then  -- 客户分类,0 法人，1 个人
        --        concat('1', concat(rpad(c_cert_typ, 6, '0') , rpad(c_cert_no, 18, '0')), mod(substr(concat(rpad(c_cert_typ, 6, '0') , rpad(c_cert_no, 18, '0')), -7, 6), 9)) 
	-- when 0 then   -- 客户分类,0 法人，1 个人
        --        concat('2', concat(rpad(c_cert_typ, 6, '0') , rpad(c_cert_no, 18, '0')), mod(substr(concat(rpad(c_cert_typ, 6, '0') , rpad(c_cert_no, 18, '0')), -7, 6), 9)) 
        -- end c_cst_no
        -- 团单中没找到客户类型标识字段，探 查没发现非自然人身份证类型
        ,concat('1', concat(rpad(c_cert_typ, 6, '0') , rpad(c_cert_no, 18, '0')), mod(substr(concat(rpad(c_cert_typ, 6, '0') , rpad(c_cert_no, 18, '0')), -7, 6), 9))  c_cst_no
    
        ,null c_app_ins_rel -- 投保人与被保人之间的关系
        ,null c_bnfc_ins_rel -- 受益人与被保险人之间的关系
        ,null c_ins_app_rel -- 被保险人与投保人之间的关系

	    ,1 c_clnt_mrk -- 客户分类,0 法人，1 个人
        ,c_nme c_acc_name -- 受益人 
        ,c_cert_typ  c_cert_cls -- 被保人证件类型
        ,c_cert_no c_cert_cde -- 被保人证件号码 
        ,null c_manage_area
        ,null c_buslicence_no
        ,null c_buslicence_valid
        ,null c_organization_no
        ,null c_cevenue_no
        ,null c_legal_nme
        ,null c_legal_certf_cls
        ,null c_legal_certf_cde
        ,null t_legal_certf_end_tm
        ,null c_actualholding_nme
        ,null c_acth_certf_cls
        ,null c_acth_certf_cde
        ,null t_acth_certf_end_tm
        ,null c_ope_name
        ,null c_ope_certf_cls
        ,null c_ope_certf_cde
        ,null t_ope_certf_end_tm
        ,null c_trd_cde
        ,null c_sub_trd_cde
        ,null n_reg_amt
        ,null c_cst_sex
        ,c_country  -- 国籍
        ,null c_cert_end_date
        ,c_occup_cde -- 职业代码
        ,null n_income
        ,null c_mobile
        ,null c_clnt_addr
        ,null c_work_dpt
from ods_cthx_web_app_grp_member partition(pt20191013000000)
where c_cert_typ is not null and trim(c_cert_typ)  <> '' and c_cert_typ REGEXP '[^0-9.]' = 0
        and c_cert_no is not null and trim(c_cert_no)  <> '' and left(c_cert_no, 17)  REGEXP '[^0-9.]' = 0;

/* 
团单受益人导入
*/
insert into x_edw_cust_pers_units_info(
        c_ply_no	 -- 	保单号，保单号 Policy No
        ,c_app_no	 -- 	申请单号，批改申请单号
        ,c_per_biztype	 -- 	保单人员参于类型:投保人: 个人:21, 法人:22 ,    被保人:个人:31, 法人:32 ,受益人:个人:41, 法人:42, 团单被保人:33,团单受益人:43,收款人:11
        ,c_cst_no	 -- 	客户号
        ,c_app_ins_rel -- 投保人与被保人之间的关系
        ,c_bnfc_ins_rel -- 受益人与被保险人之间的关系
        ,c_ins_app_rel -- 被保险人与投保人之间的关系
        ,c_clnt_mrk	 -- 	客户分类,0 法人，1 个人
        ,c_acc_name	 -- 	投保人名称
        ,c_cert_cls	 -- 	证件类型
        ,c_cert_cde	 -- 	证件号码
        ,c_manage_area	 -- 	经营范围
        ,c_buslicence_no	 -- 	营业执照号
        ,c_buslicence_valid	 -- 	营业执照号有效期
        ,c_organization_no	 -- 	组织机构代码
        ,c_cevenue_no	 -- 	税务登记号
        ,c_legal_nme	 -- 	法定代表人姓名
        ,c_legal_certf_cls	 -- 	法定代表人证件类型
        ,c_legal_certf_cde	 -- 	法定代表人证件号码
        ,t_legal_certf_end_tm	 -- 	法定代表人证件有效期限
        ,c_actualholding_nme	 -- 	控股股东或者实际控制人姓名
        ,c_acth_certf_cls	 -- 	控股股东或者实际控制人身份证件类型
        ,c_acth_certf_cde	 -- 	控股股东或者实际控制人身份证件号码
        ,t_acth_certf_end_tm	 -- 	控股股东或者实际控制人身份证件有效期限到期日
        ,c_ope_name	 -- 	授权办理业务人员名称(投保人联系人)
        ,c_ope_certf_cls	 -- 	授权办理业务人员身份证件类型
        ,c_ope_certf_cde	 -- 	授权办理业务人员身份证件号码
        ,t_ope_certf_end_tm	 -- 	授权办理业务人员身份证件有效期限到期日
        ,c_trd_cde	 -- 	行业代码
        ,c_sub_trd_cde	 -- 	行业细分代码
        ,n_reg_amt	 -- 	注册资本金
        ,c_sex	 -- 	性别
        ,c_aml_country	 -- 	国籍
        ,t_certf_end_date	 -- 	证件有效期止
        ,c_occup_cde	 -- 	职业代码
        ,n_income	 -- 	年收入
        ,c_mobile	 -- 	移动电话
        ,c_clnt_addr	 -- 	地址
        ,c_work_dpt	 -- 	工作单位
)
select 
         c_ply_no  -- 保单号，保单号 Policy No
        ,c_app_no  -- 申请单号，批改申请单号
        ,43 c_per_biztype	 -- 	保单人员参于类型:投保人: 个人:21, 法人:22 ,    被保人:个人:31, 法人:32 ,受益人:个人:41, 法人:42, 团单被保人:33,团单受益人:43,收款人:11
        -- c_cst_no已经编码由身份证类型6位,身份证号码18位组成,这里校验码取倒数第7位至倒数第2位与9取MOD
	-- ,case c_clnt_mrk 
	-- when 1 then  -- 客户分类,0 法人，1 个人
        --        concat('1', concat(rpad(c_bnfc_cert_typ, 6, '0') , rpad(c_bnfc_cert_no, 18, '0')), mod(substr(concat(rpad(c_bnfc_cert_typ, 6, '0') , rpad(c_bnfc_cert_no, 18, '0')), -7, 6), 9)) 
	-- when 0 then   -- 客户分类,0 法人，1 个人
        --        concat('2', concat(rpad(c_bnfc_cert_typ, 6, '0') , rpad(c_bnfc_cert_no, 18, '0')), mod(substr(concat(rpad(c_bnfc_cert_typ, 6, '0') , rpad(c_bnfc_cert_no, 18, '0')), -7, 6), 9)) 
        -- end c_cst_no
        -- 团单中没找到客户类型标识字段，探 查没发现非自然人身份证类型
        ,concat('1', concat(rpad(c_bnfc_cert_typ, 6, '0') , rpad(c_bnfc_cert_no, 18, '0')), mod(substr(concat(rpad(c_bnfc_cert_typ, 6, '0') , rpad(c_bnfc_cert_no, 18, '0')), -7, 6), 9))  c_cst_no

        ,null c_app_ins_rel -- 投保人与被保人之间的关系
        ,null c_bnfc_ins_rel -- 受益人与被保险人之间的关系
        ,null c_ins_app_rel -- 被保险人与投保人之间的关系

        ,1 c_clnt_mrk -- 客户分类,0 法人，1 个人
        ,null  c_acc_name -- 受益人 c_bnfc_nme NV75101--法定受益人， NV75102--指定受益人
        ,c_bnfc_cert_typ  c_cert_cls -- 受益人证件类型
        ,c_bnfc_cert_no c_cert_cde -- 受益人证件号码 
        ,null c_manage_area
        ,null c_buslicence_no
        ,null c_buslicence_valid
        ,null c_organization_no
        ,null c_cevenue_no
        ,null c_legal_nme
        ,null c_legal_certf_cls
        ,null c_legal_certf_cde
        ,null t_legal_certf_end_tm
        ,null c_actualholding_nme
        ,null c_acth_certf_cls
        ,null c_acth_certf_cde
        ,null t_acth_certf_end_tm
        ,null c_ope_name
        ,null c_ope_certf_cls
        ,null c_ope_certf_cde
        ,null t_ope_certf_end_tm
        ,null c_trd_cde
        ,null c_sub_trd_cde
        ,null n_reg_amt
        ,null c_cst_sex
        ,null c_country  -- 国籍
        ,null c_cert_end_date
        ,null c_occup_cde -- 职业代码
        ,null n_income
        ,null c_mobile
        ,null c_clnt_addr
        ,null c_work_dpt
from ods_cthx_web_app_grp_member partition(pt20191013000000)
where c_bnfc_cert_typ is not null and trim(c_bnfc_cert_typ)  <> '' and c_bnfc_cert_typ REGEXP '[^0-9.]' = 0
        and c_bnfc_cert_no is not null and trim(c_bnfc_cert_no)  <> '' and left(c_bnfc_cert_no, 17)  REGEXP '[^0-9.]' = 0;


/* 
收款人导入
*/
insert into x_edw_cust_pers_units_info(
        c_ply_no	 -- 	保单号，保单号 Policy No
        ,c_app_no	 -- 	申请单号，批改申请单号
        ,c_per_biztype	 -- 	保单人员参于类型:投保人: 个人:21, 法人:22 ,    被保人:个人:31, 法人:32 ,受益人:个人:41, 法人:42, 团单被保人:33,团单受益人:43,收款人:11
        ,c_cst_no	 -- 	客户号
        ,c_app_ins_rel -- 投保人与被保人之间的关系
        ,c_bnfc_ins_rel -- 受益人与被保险人之间的关系
        ,c_ins_app_rel -- 被保险人与投保人之间的关系
        ,c_clnt_mrk	 -- 	客户分类,0 法人，1 个人
        ,c_acc_name	 -- 	投保人名称
        ,c_cert_cls	 -- 	证件类型
        ,c_cert_cde	 -- 	证件号码
        ,c_manage_area	 -- 	经营范围
        ,c_buslicence_no	 -- 	营业执照号
        ,c_buslicence_valid	 -- 	营业执照号有效期
        ,c_organization_no	 -- 	组织机构代码
        ,c_cevenue_no	 -- 	税务登记号
        ,c_legal_nme	 -- 	法定代表人姓名
        ,c_legal_certf_cls	 -- 	法定代表人证件类型
        ,c_legal_certf_cde	 -- 	法定代表人证件号码
        ,t_legal_certf_end_tm	 -- 	法定代表人证件有效期限
        ,c_actualholding_nme	 -- 	控股股东或者实际控制人姓名
        ,c_acth_certf_cls	 -- 	控股股东或者实际控制人身份证件类型
        ,c_acth_certf_cde	 -- 	控股股东或者实际控制人身份证件号码
        ,t_acth_certf_end_tm	 -- 	控股股东或者实际控制人身份证件有效期限到期日
        ,c_ope_name	 -- 	授权办理业务人员名称(投保人联系人)
        ,c_ope_certf_cls	 -- 	授权办理业务人员身份证件类型
        ,c_ope_certf_cde	 -- 	授权办理业务人员身份证件号码
        ,t_ope_certf_end_tm	 -- 	授权办理业务人员身份证件有效期限到期日
        ,c_trd_cde	 -- 	行业代码
        ,c_sub_trd_cde	 -- 	行业细分代码
        ,n_reg_amt	 -- 	注册资本金
        ,c_sex	 -- 	性别
        ,c_aml_country	 -- 	国籍
        ,t_certf_end_date	 -- 	证件有效期止
        ,c_occup_cde	 -- 	职业代码
        ,n_income	 -- 	年收入
        ,c_mobile	 -- 	移动电话
        ,c_clnt_addr	 -- 	地址
        ,c_work_dpt	 -- 	工作单位
)
select 
         c_ply_no  -- 保单号，保单号 Policy No
        ,c_app_no  -- 申请单号，批改申请单号
        ,11 c_per_biztype	 -- 	保单人员参于类型:投保人: 个人:21, 法人:22 ,    被保人:个人:31, 法人:32 ,受益人:个人:41, 法人:42, 团单被保人:33,团单受益人:43,收款人:11
        -- c_cst_no已经编码由身份证类型6位,身份证号码18位组成,这里校验码取倒数第7位至倒数第2位与9取MOD
	-- ,case c_clnt_mrk 
	-- when 1 then  -- 客户分类,0 法人，1 个人
        --        concat('1', concat(rpad(c_cert_typ, 6, '0') , rpad(c_cert_no, 18, '0')), mod(substr(concat(rpad(c_cert_typ, 6, '0') , rpad(c_cert_no, 18, '0')), -7, 6), 9)) 
	-- when 0 then   -- 客户分类,0 法人，1 个人
        --        concat('2', concat(rpad(c_cert_typ, 6, '0') , rpad(c_cert_no, 18, '0')), mod(substr(concat(rpad(c_cert_typ, 6, '0') , rpad(c_cert_no, 18, '0')), -7, 6), 9)) 
        -- end c_cst_no
        -- 团单中没找到客户类型标识字段，探 查没发现非自然人身份证类型
        ,concat('1', concat(rpad(c_card_type, 6, '0') , rpad(c_card_cde, 18, '0')), mod(substr(concat(rpad(c_card_type, 6, '0') , rpad(c_card_cde, 18, '0')), -7, 6), 9))  c_cst_no

        ,null c_app_ins_rel -- 投保人与被保人之间的关系
        ,null c_bnfc_ins_rel -- 受益人与被保险人之间的关系
        ,null c_ins_app_rel -- 被保险人与投保人之间的关系

        ,1 c_clnt_mrk -- 客户分类,0 法人，1 个人
        ,c_payee_nme  c_acc_name -- 收款人名称
        ,c_card_type  c_cert_cls -- 收款人证件类型
        ,c_card_cde c_cert_cde -- 收款人证件号码 
        ,null c_manage_area
        ,null c_buslicence_no
        ,null c_buslicence_valid
        ,null c_organization_no
        ,null c_cevenue_no
        ,null c_legal_nme
        ,null c_legal_certf_cls
        ,null c_legal_certf_cde
        ,null t_legal_certf_end_tm
        ,null c_actualholding_nme
        ,null c_acth_certf_cls
        ,null c_acth_certf_cde
        ,null t_acth_certf_end_tm
        ,null c_ope_name
        ,null c_ope_certf_cls
        ,null c_ope_certf_cde
        ,null t_ope_certf_end_tm
        ,null c_trd_cde
        ,null c_sub_trd_cde
        ,null n_reg_amt
        ,null c_cst_sex
        ,null c_country  -- 国籍
        ,null c_cert_end_date
        ,null c_occup_cde -- 职业代码
        ,null n_income
        ,c_tel_no c_mobile
        ,null c_clnt_addr
        ,null c_work_dpt
from ods_cthx_web_clm_bank  partition(pt20191013000000) a
        inner join ods_cthx_web_clm_main partition(pt20191013000000) c on a.c_clm_no = c.c_clm_no
where c_card_type is not null and trim(c_card_type)  <> '' and c_card_type REGEXP '[^0-9.]' = 0
        and c_card_cde is not null and trim(c_card_cde)  <> '' and left(c_card_cde, 17)  REGEXP '[^0-9.]' = 0;