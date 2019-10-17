/*
create table rpt_fxq_tb_ply_bnfc_ms (
        c_ply_no varchar(50) collate utf8_bin comment '保单号 policy no',
        c_app_no varchar(50) COLLATE utf8_bin NOT NULL COMMENT '申请单号,批改申请单号',
        c_bnfc_nme varchar(100) collate utf8_bin comment '  受益人名称',
        c_certf_cls varchar(30) collate utf8_bin comment '  证件类型',
        c_certf_cde varchar(20) collate utf8_bin comment '  证件号码',
        c_country varchar(30) collate utf8_bin comment '  国家',
        c_sex varchar(30) collate utf8_bin comment '  性别',
        c_mobile varchar(20) collate utf8_bin comment '  移动电话',
        c_addr varchar(200) collate utf8_bin comment '  联系地址,地址',
        c_cntr_nme varchar(100) collate utf8_bin comment '  联系人',
        c_clnt_mrk varchar(1) collate utf8_bin comment '  客户分类,客户分类,0 法人，1 个人'
)  engine=innodb default charset=utf8;
*/
truncate table  rpt_fxq_tb_ply_bnfc_ms;
insert into rpt_fxq_tb_ply_bnfc_ms(
        c_ply_no	
        ,c_app_no   -- 申请单号,批改申请单号
        ,c_bnfc_nme	  --  受益人名称
        ,c_certf_cls	  --  证件类型
        ,c_certf_cde	  --  证件号码
        ,c_country	  --  国家
        ,c_sex	  --  性别
        ,c_mobile	  --  移动电话
        ,c_addr	  --  联系地址,地址
        ,c_cntr_nme	  --  联系人
        ,c_clnt_mrk	  --  客户分类,客户分类,0 法人，1 个人
)
select 
        null c_ply_no
        ,a.c_app_no   -- 申请单号,批改申请单号
        ,a.c_bnfc_nme  -- 受益人名称
        ,a.c_certf_cls -- 证件类型
        ,a.c_certf_cde  -- 证件号码
        ,a.c_country -- 国家
        ,a.c_sex   -- 性别
        ,a.c_mobile   -- 移动电话
        ,a.c_addr  -- 实际经营地址或注册地址
        ,a.c_cntr_nme  -- 授权办理业务人员名称
        ,a.c_clnt_mrk
from ods_cthx_web_ply_bnfc  partition(pt20191013000000) a