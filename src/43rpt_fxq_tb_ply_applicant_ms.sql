/*
CREATE TABLE `rpt_fxq_tb_ply_applicant_ms` (
  `c_ply_no` varchar(50) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '保单号 Policy No',
  `c_app_no` varchar(50) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '申请单号，批改申请单号',
  `c_clnt_mrk` varchar(1) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '客户分类,客户分类,0 法人，1 个人',
  `c_app_nme` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '投保人名称',
  `c_organization_no` varchar(50) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '组织机构代码',
  `c_buslicence_no` varchar(50) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '营业执照号',
  `c_buslicence_valid` datetime DEFAULT NULL COMMENT '营业执照号有效期',
  `c_cevenue_no` varchar(50) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '税务登记号',
  `c_manage_area` varchar(50) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '经营范围',
  `c_actualholding_nme` varchar(100) DEFAULT NULL,
  `c_acth_certf_cde` varchar(30) DEFAULT NULL,
  `c_acth_certf_cls` varchar(30) DEFAULT NULL,
  `t_acth_certf_end_tm` date DEFAULT NULL,
  `c_legal_nme` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '法定代表人姓名',
  `c_legal_certf_cls` varchar(30) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '法定代表人证件类型',
  `c_legal_certf_cde` varchar(20) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '法定代表人证件号码',
  `t_legal_certf_end_tm` datetime DEFAULT NULL COMMENT '法定代表人证件有效期限',
  `c_cntr_nme` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '联系人,投保人联系人',
  `c_clnt_addr` varchar(200) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '地址',
  `c_certf_cls` varchar(30) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '证件类型',
  `c_certf_cde` varchar(20) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '证件号码',
  `t_certf_end_date` datetime DEFAULT NULL COMMENT '证件有效期止',
  `c_aml_country` varchar(30) DEFAULT NULL,
  `c_sex` varchar(30) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '性别',
  `c_mobile` varchar(20) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '移动电话',
  `c_trd_cde` varchar(30) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '行业代码',
  `c_sub_trd_cde` varchar(30) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '行业细分代码',
  `c_occup_cde` varchar(30) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '职业代码',
  `c_work_dpt` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '工作单位'
) ENGINE=InnoDB DEFAULT CHARSET=utf8
*/
truncate table  rpt_fxq_tb_ply_applicant_ms;
insert into rpt_fxq_tb_ply_applicant_ms(
    c_ply_no	
    ,c_app_no	--  申请单号，批改申请单号
    ,c_clnt_mrk	--  客户分类,客户分类,0 法人，1 个人
    ,c_app_nme	--  投保人名称
    ,c_organization_no	--  组织机构代码
    ,c_buslicence_no	--  营业执照号
    ,c_buslicence_valid	--  营业执照号有效期
    ,c_cevenue_no	--  税务登记号
    ,c_manage_area	--  经营范围
    ,c_actualholding_nme	
    ,c_acth_certf_cde	
    ,c_acth_certf_cls	
    ,t_acth_certf_end_tm	
    ,c_legal_nme	--  法定代表人姓名
    ,c_legal_certf_cls	--  法定代表人证件类型
    ,c_legal_certf_cde	--  法定代表人证件号码
    ,t_legal_certf_end_tm	--  法定代表人证件有效期限
    ,c_cntr_nme	--  联系人,投保人联系人
    ,c_clnt_addr	--  地址
    ,c_certf_cls	--  证件类型
    ,c_certf_cde	--  证件号码
    ,t_certf_end_date	--  证件有效期止
    ,c_aml_country	
    ,c_sex	--  性别
    ,c_mobile	--  移动电话
    ,c_trd_cde	--  行业代码
    ,c_sub_trd_cde	--  行业细分代码
    ,c_occup_cde	--  职业代码
    ,c_work_dpt	--  工作单位
)
select 
    null c_ply_no
    ,a.c_app_no
    ,a.c_clnt_mrk
    ,a.c_app_nme  -- 投保人名称
    ,a.c_organization_no -- 组织机构代码
    ,a.c_buslicence_no -- 依法设立或经营的执照号码
    ,a.c_buslicence_valid -- 依法设立或经营的执照有效期限到期日
    ,a.c_cevenue_no -- 税务登记证号码
    ,a.c_manage_area -- 经营范围/业务范围

    ,a.c_actualholding_nme  -- 控股股东或者实际控制人姓名
    ,a.c_acth_certf_cde  -- 控股股东或者实际控制人身份证件号码
    ,a.c_acth_certf_cls -- 控股股东或者实际控制人身份证件类型
    ,a.t_acth_certf_end_tm -- 控股股东或者实际控制人身份证件有效期限到期日

    ,a.c_legal_nme -- 法定代表人或负责人姓名
    ,a.c_legal_certf_cls  -- 法定代表人或负责人身份证件种类
    ,a.c_legal_certf_cde  -- 法定代表人或负责人身份证件号码
    ,a.t_legal_certf_end_tm -- 有效期限到期日
    ,a.c_cntr_nme  -- 授权办理业务人员名称
    ,a.c_clnt_addr -- 实际经营地址或注册地址

    ,a.c_certf_cls  -- 证件种类
    ,a.c_certf_cde  -- 证件号码
    ,a.t_certf_end_date -- 证件有效期止

    ,a.c_aml_country  -- 国籍
    ,a.c_sex  -- 性别
    ,a.c_mobile  -- 移动电话
    ,a.c_trd_cde  -- 行业代码
    ,a.c_sub_trd_cde  -- 行业

    ,a.c_occup_cde  -- 职业代码
    ,a.c_work_dpt  -- 工作单位
from ods_cthx_web_ply_applicant  partition(pt20191013000000) a