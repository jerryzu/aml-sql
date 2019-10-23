CREATE TABLE `rpt_fxq_manual_company_ms` (
  `head_no` varchar(20) DEFAULT NULL COMMENT '法人机构报告机构编码',
  `company_code1` varchar(20) DEFAULT NULL COMMENT '机构网点代码',
  `company_code2` varchar(16) DEFAULT NULL COMMENT '金融机构编码',
  `company_name` varchar(160) DEFAULT NULL COMMENT '机构名称',
  `bord_flag` varchar(2) DEFAULT NULL COMMENT '境内外标识',
  `pt` varchar(15) DEFAULT NULL COMMENT '分区字段'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='机构对照表'
/*!50500 PARTITION BY RANGE  COLUMNS(pt)
(PARTITION pt20190822000000 VALUES LESS THAN ('20190822999999') ENGINE = InnoDB,
 PARTITION pt20191013000000 VALUES LESS THAN ('20191013999999') ENGINE = InnoDB,
 PARTITION future VALUES LESS THAN ('99991231999999') ENGINE = InnoDB) */
--   c_cert_ok varchar(1) character set utf8 collate utf8_bin default null comment '证件有效',

DROP TABLE IF EXISTS x_edw_cust_pers_units_info;
CREATE TABLE x_edw_cust_pers_units_info (
  c_ply_no varchar(50) character set utf8 collate utf8_bin comment '保单号，保单号 policy no',
  c_app_no varchar(50) character set utf8 collate utf8_bin comment '申请单号，批改申请单号',
  c_per_biztype varchar(2) character set utf8 collate utf8_bin default null comment '保单人员参于类型:投保人:21,被保人:31,受益人:41,团单被保人:33,团单受益人:43,收款人:11',
  c_cst_no varchar(48) character set utf8 collate utf8_bin default null comment '客户号',
  c_clnt_mrk varchar(1) character set utf8 collate utf8_bin default null comment '客户分类,0 法人，1 个人',
  c_acc_name varchar(100) character set utf8 collate utf8_bin comment '投保人名称',
  c_cert_cls varchar(30) character set utf8 collate utf8_bin default null comment '证件类型',
  c_cert_cde varchar(30) character set utf8 collate utf8_bin default null comment '证件号码',
  c_manage_area varchar(50) character set utf8 collate utf8_bin default null comment '经营范围',
  c_buslicence_no varchar(50) character set utf8 collate utf8_bin default null comment '营业执照号',
  c_buslicence_valid datetime default null comment '营业执照号有效期',
  c_organization_no varchar(50) character set utf8 collate utf8_bin default null comment '组织机构代码',
  c_cevenue_no varchar(50) character set utf8 collate utf8_bin default null comment '税务登记号',
  c_legal_nme varchar(100) character set utf8 collate utf8_bin default null comment '法定代表人姓名',
  c_legal_certf_cls varchar(30) character set utf8 collate utf8_bin default null comment '法定代表人证件类型',
  c_legal_certf_cde varchar(20) character set utf8 collate utf8_bin default null comment '法定代表人证件号码',
  t_legal_certf_end_tm datetime default null comment '法定代表人证件有效期限',
  c_actualholding_nme varchar(100) default null comment '控股股东或者实际控制人姓名',
  c_acth_certf_cls varchar(30) default null comment '控股股东或者实际控制人身份证件类型',
  c_acth_certf_cde varchar(30) default null comment '控股股东或者实际控制人身份证件号码',
  t_acth_certf_end_tm date default null comment '控股股东或者实际控制人身份证件有效期限到期日',
  c_ope_name varchar(100) character set utf8 collate utf8_bin default null comment '授权办理业务人员名称(投保人联系人)',
  c_ope_certf_cls varchar(30) default null comment '授权办理业务人员身份证件类型',
  c_ope_certf_cde varchar(20) default null comment '授权办理业务人员身份证件号码',
  t_ope_certf_end_tm datetime default null comment '授权办理业务人员身份证件有效期限到期日',
  c_trd_cde varchar(30) character set utf8 collate utf8_bin default null comment '行业代码',
  c_sub_trd_cde varchar(30) character set utf8 collate utf8_bin default null comment '行业细分代码',
  n_reg_amt decimal(18,2) default null comment '注册资本金',
  c_sex varchar(30) character set utf8 collate utf8_bin default null comment '性别',
  c_aml_country varchar(30) default null comment '国籍',
  t_certf_end_date datetime default null comment '证件有效期止',
  c_occup_cde varchar(30) character set utf8 collate utf8_bin default null comment '职业代码',
  n_income decimal(18,2) default null comment '年收入',
  c_mobile varchar(20) character set utf8 collate utf8_bin default null comment '移动电话',
  c_clnt_addr varchar(200) character set utf8 collate utf8_bin default null comment '地址',
  c_work_dpt varchar(100) character set utf8 collate utf8_bin default null comment '工作单位'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
