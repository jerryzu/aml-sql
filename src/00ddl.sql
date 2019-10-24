CREATE TABLE rpt_fxq_manual_company_ms (
  head_no varchar(20) DEFAULT NULL COMMENT '法人机构报告机构编码',
  company_code1 varchar(20) DEFAULT NULL COMMENT '机构网点代码',
  company_code2 varchar(16) DEFAULT NULL COMMENT '金融机构编码',
  company_name varchar(160) DEFAULT NULL COMMENT '机构名称',
  bord_flag varchar(2) DEFAULT NULL COMMENT '境内外标识',
  pt varchar(15) DEFAULT NULL COMMENT '分区字段'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='机构对照表';
/*!50500 PARTITION BY RANGE  COLUMNS(pt)
(PARTITION pt20190822000000 VALUES LESS THAN ('20190822999999') ENGINE = InnoDB,
 PARTITION pt20191013000000 VALUES LESS THAN ('20191013999999') ENGINE = InnoDB,
 PARTITION future VALUES LESS THAN ('99991231999999') ENGINE = InnoDB) */

INSERT INTO rpt_fxq_manual_company_ms (head_no, company_code1, company_code2, company_name, bord_flag, pt) VALUES ('030013304020046', '99000000', 'F1008933000019', '太平科技保险总公司', '10', '20190918000000');
INSERT INTO rpt_fxq_manual_company_ms (head_no, company_code1, company_code2, company_name, bord_flag, pt) VALUES ('030013304020046', '33000000', 'F1008933000020', '浙江分公司', '10', '20190918000000');
INSERT INTO rpt_fxq_manual_company_ms (head_no, company_code1, company_code2, company_name, bord_flag, pt) VALUES ('030013304020046', '99600000', 'F1008933000019', '总经理室', '10', '20190918000000');
INSERT INTO rpt_fxq_manual_company_ms (head_no, company_code1, company_code2, company_name, bord_flag, pt) VALUES ('030013304020046', '33600000', 'F1008933000020', '浙江分公司总经理室', '10', '20190918000000');
INSERT INTO rpt_fxq_manual_company_ms (head_no, company_code1, company_code2, company_name, bord_flag, pt) VALUES ('030013304020046', '33610000', 'F1008933000020', '浙江分公司综合管理部', '10', '20190918000000');
INSERT INTO rpt_fxq_manual_company_ms (head_no, company_code1, company_code2, company_name, bord_flag, pt) VALUES ('030013304020046', '33620000', 'F1008933000020', '浙江分公司财务部', '10', '20190918000000');
INSERT INTO rpt_fxq_manual_company_ms (head_no, company_code1, company_code2, company_name, bord_flag, pt) VALUES ('030013304020046', '33630000', 'F1008933000020', '浙江分公司运营管理部', '10', '20190918000000');
INSERT INTO rpt_fxq_manual_company_ms (head_no, company_code1, company_code2, company_name, bord_flag, pt) VALUES ('030013304020046', '33640000', 'F1008933000020', '浙江分公司销售管理部', '10', '20190918000000');
INSERT INTO rpt_fxq_manual_company_ms (head_no, company_code1, company_code2, company_name, bord_flag, pt) VALUES ('030013304020046', '99610000', 'F1008933000019', '董事会办公室', '10', '20190918000000');
INSERT INTO rpt_fxq_manual_company_ms (head_no, company_code1, company_code2, company_name, bord_flag, pt) VALUES ('030013304020046', '99620000', 'F1008933000019', '财务部', '10', '20190918000000');
INSERT INTO rpt_fxq_manual_company_ms (head_no, company_code1, company_code2, company_name, bord_flag, pt) VALUES ('030013304020046', '99630000', 'F1008933000019', '党委办公室/行政办公室', '10', '20190918000000');
INSERT INTO rpt_fxq_manual_company_ms (head_no, company_code1, company_code2, company_name, bord_flag, pt) VALUES ('030013304020046', '99640000', 'F1008933000019', '人力资源部/党委组织部/工会办公室', '10', '20190918000000');
INSERT INTO rpt_fxq_manual_company_ms (head_no, company_code1, company_code2, company_name, bord_flag, pt) VALUES ('030013304020046', '99650000', 'F1008933000019', '风险及法律合规部', '10', '20190918000000');
INSERT INTO rpt_fxq_manual_company_ms (head_no, company_code1, company_code2, company_name, bord_flag, pt) VALUES ('030013304020046', '99660000', 'F1008933000019', '战略企划部', '10', '20190918000000');
INSERT INTO rpt_fxq_manual_company_ms (head_no, company_code1, company_code2, company_name, bord_flag, pt) VALUES ('030013304020046', '99670000', 'F1008933000019', '投资管理部', '10', '20190918000000');
INSERT INTO rpt_fxq_manual_company_ms (head_no, company_code1, company_code2, company_name, bord_flag, pt) VALUES ('030013304020046', '99680000', 'F1008933000019', '运营技术部', '10', '20190918000000');
INSERT INTO rpt_fxq_manual_company_ms (head_no, company_code1, company_code2, company_name, bord_flag, pt) VALUES ('030013304020046', '99690000', 'F1008933000019', '产品精算部', '10', '20190918000000');
INSERT INTO rpt_fxq_manual_company_ms (head_no, company_code1, company_code2, company_name, bord_flag, pt) VALUES ('030013304020046', '99700000', 'F1008933000019', '运营管理部', '10', '20190918000000');
INSERT INTO rpt_fxq_manual_company_ms (head_no, company_code1, company_code2, company_name, bord_flag, pt) VALUES ('030013304020046', '99710000', 'F1008933000019', '再保险部', '10', '20190918000000');
INSERT INTO rpt_fxq_manual_company_ms (head_no, company_code1, company_code2, company_name, bord_flag, pt) VALUES ('030013304020046', '99720000', 'F1008933000019', '营销管理部', '10', '20190918000000');
INSERT INTO rpt_fxq_manual_company_ms (head_no, company_code1, company_code2, company_name, bord_flag, pt) VALUES ('030013304020046', '99730000', 'F1008933000019', '业务拓展部', '10', '20190918000000');
INSERT INTO rpt_fxq_manual_company_ms (head_no, company_code1, company_code2, company_name, bord_flag, pt) VALUES ('030013304020046', '99740000', 'F1008933000019', '客户服务部（虚拟）', '10', '20190918000000');
INSERT INTO rpt_fxq_manual_company_ms (head_no, company_code1, company_code2, company_name, bord_flag, pt) VALUES ('030013304020046', '99750000', 'F1008933000019', '公估公司（虚拟）', '10', '20190918000000');
INSERT INTO rpt_fxq_manual_company_ms (head_no, company_code1, company_code2, company_name, bord_flag, pt) VALUES ('030013304020046', '99750001', 'F1008933000019', '民太安', '10', '20190918000000');

DROP TABLE IF EXISTS x_edw_cust_pers_units_info;

CREATE TABLE x_edw_cust_pers_units_info (
  c_ply_no varchar(50) character set utf8 collate utf8_bin comment '保单号，保单号 policy no',
  c_app_no varchar(50) character set utf8 collate utf8_bin comment '申请单号，批改申请单号',
  c_per_biztype varchar(2) character set utf8 collate utf8_bin default null comment '保单人员参于类型:投保人: 个人:21, 法人:22 ,    被保人:个人:31, 法人:32 ,受益人:个人:41, 法人:42, 团单被保人:33,团单受益人:43,收款人:11',
  c_cst_no varchar(48) character set utf8 collate utf8_bin default null comment '客户号',
  c_app_ins_rel varchar(8) default null comment '投保人与被保人之间的关系',
  c_bnfc_ins_rel varchar(8) default null comment '受益人与被保险人之间的关系',
  c_ins_app_rel varchar(8) default null comment '被保险人与投保人之间的关系', 
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

DROP TABLE s_rpt_fxq_tb_ins_rpol_ms;

CREATE TABLE s_rpt_fxq_tb_ins_rpol_ms
(
    c_dpt_cde VARCHAR(20) COMMENT '机构网点代码',
    c_ply_no VARCHAR(50) COMMENT '保单编号',
    c_app_no VARCHAR(50) COMMENT '申请单号，批改申请单号',
    c_ins_no VARCHAR(32) COMMENT '被保人客户编号',
    c_ins_clnt_mrk varchar(1) COMMENT '被保人客户分类,0 法人，1 个人',
    c_ins_name VARCHAR(40) COMMENT '被保人名称',
    c_ins_cert_cls VARCHAR(8) COMMENT '被保人身份证件种类',
    c_ins_cert_cde VARCHAR(50) COMMENT '被保人身份证件号码',
    c_bnfc_no VARCHAR(32) COMMENT '受益人客户编号',
    c_bnfc_clnt_mrk varchar(1) COMMENT '受益人客户分类,0 法人，1 个人',
    c_bnfc_name VARCHAR(40) COMMENT '受益人名称',
    c_bnfc_cert_cls VARCHAR(8) COMMENT '受益人身份证件种类',
    c_bnfc_cert_cde VARCHAR(50) COMMENT '受益人身份证件号码',
    c_grp_mrk varchar(1)  COMMENT '团单标志( 0 个单; 1 团单) Group Insurance Flag',
    c_app_relation VARCHAR(30) COMMENT '与被保人关系',
    pt VARCHAR(15) COMMENT '分区字段',
    INDEX edw_cust_ply_party_insured_pk (c_ply_no, pt),
    INDEX edw_cust_ply_party_insured_pk1 (c_app_no, pt)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='保单相关方关系表';

drop table x_rpt_fxq_tb_ins_rpol_gpol;

create table x_rpt_fxq_tb_ins_rpol_gpol (
  c_dpt_cde varchar(30) character set utf8 collate utf8_bin default null comment '机构代码 department no',
  c_cha_subtype varchar(30) character set utf8 collate utf8_bin default null comment '渠道子类',
  c_brkr_cde varchar(30) character set utf8 collate utf8_bin default null comment '代理人/经纪人 agent/broker no',
  c_ply_no varchar(50) character set utf8 collate utf8_bin default null comment '保单号 policy no',
  c_app_no varchar(50) character set utf8 collate utf8_bin not null comment '申请单号',
  c_prod_no varchar(6) character set utf8 collate utf8_bin default null comment '产品代码 product code',
  t_insrnc_bgn_tm datetime default null comment '保险起期 policy effective date',
  t_insrnc_end_tm datetime default null comment '保险止期 policy expire date',
  t_app_tm datetime default null comment '投保日期 applying time',
  t_edr_app_tm datetime default null comment '批改申请日期',
  t_edr_bgn_tm datetime default null comment '批改生效起期',
  t_next_edr_bgn_tm datetime default null comment '批改生效起期 beginning of successive edorsement  effective time ',
  t_udr_tm datetime default null comment '核保日期 underwrite time',
  c_edr_type varchar(30) character set utf8 collate utf8_bin default null comment '批改类型,1 一般批改，2 注销，3退保  4、组合批改  5 满期返还  9 批单撤销',
  c_edr_no varchar(50) character set utf8 collate utf8_bin default null comment '批单号',
  c_edr_rsn_bundle_cde varchar(50) character set utf8 collate utf8_bin default null comment '批改原因或组合代码',
  c_prm_cur varchar(30) character set utf8 collate utf8_bin default null comment '保费币种 currency of premium',
  n_prm decimal(20,2) default null comment '保费合计 premium',
  n_prm_var decimal(20,2) default null comment '保费变化，批单保费上一批单（保单）保费',
  c_pay_mde_cde varchar(30) character set utf8 collate utf8_bin default null comment '付款方式',
  acc_name varchar(100) default null comment '缴款人',
  acc_no varchar(30) default null comment '存现银行',
  acc_bank varchar(100) default null comment '客户银行名称',
  c_edr_ctnt text character set utf8 collate utf8_bin comment '批文内容',
  c_grp_mrk varchar(1) character set utf8 collate utf8_bin default '0' comment '团单标志( 0 个单; 1 团单) group insurance flag'
) engine=innodb default charset=utf8;

 drop table edw_cust_ply_party ;
 create table edw_cust_ply_party (
   c_dpt_cde varchar(20) default null comment '机构网点代码',
   c_ply_no varchar(50) default null comment '保单编号',
   c_app_no varchar(50) default null comment '申请单号，批改申请单号',
   c_cst_no varchar(32) default null comment '统一客户编号',
   c_acc_name varchar(100) default null comment '客户名称',
   c_cert_cls varchar(8) default null comment '身份证件种类',
   c_cert_cde varchar(50) default null comment '身份证件号码',     
   c_app_ins_rel varchar(8) default null comment '投保人与被保人之间的关系',
   c_bnfc_ins_rel varchar(8) default null comment '受益人与被保险人之间的关系',
   c_ins_app_rel varchar(8) default null comment '被保险人与投保人之间的关系', 
   t_bgn_tm date default null comment '保险起期',
   t_end_tm date default null comment '保险止期',
   c_clnt_mrk varchar(1) default null comment '客户类型',  
   c_per_biztype varchar(2) default null comment '保单人员参于类型:投保人: 个人:21, 法人:22 ,    被保人:个人:31, 法人:32 ,受益人:个人:41, 法人:42, 团单被保人:33,团单受益人:43,收款人:11',
   pt varchar(15) default null comment '分区字段'
) engine=innodb default charset=utf8 comment='保单相关方关系表'
/*!50500 partition by range  columns(pt)
(partition pt20190822000000 values less than ('20190822999999') engine = innodb,
partition pt20191013000000 values less than ('20191013999999') engine = innodb) */;

alter table tpedw.edw_cust_pers_info modify column c_acc_name varchar(100) comment '客户名称';
alter table tpedw.edw_cust_ply_party modify column c_acc_name varchar(100) comment '客户名称';	
alter table tpedw.rpt_fxq_tb_ins_pers_ms modify column acc_name varchar(100) comment '客户名称';

alter table tpedw.x_edw_cust_pers_units_info add index xedwcustpersunitsinfo_ix_cst_no (c_cst_no);
alter table tpedw.x_edw_cust_pers_units_info add index xedwcustpersunitsinfo_ix_app_no (c_app_no);
