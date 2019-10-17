/*
create table rpt_fxq_tb_ply_grp_member_ms(
        c_ply_no varchar(30) collate utf8_bin comment '保单号',
        c_app_no varchar(50) COLLATE utf8_bin NOT NULL COMMENT '申请单号,批改申请单号',
        c_nme varchar(100) collate utf8_bin comment '姓名',
        c_cert_typ varchar(30) collate utf8_bin comment '证件类型',
        c_cert_no varchar(30) collate utf8_bin comment '证件号码',
        c_bnfc_nme varchar(100) collate utf8_bin comment '受益人',
        c_bnfc_cert_typ varchar(30) collate utf8_bin comment '受益人证件类型',
        c_bnfc_cert_no varchar(20) collate utf8_bin comment '受益人证件号码',
        n_edr_prj_no decimal(6,0) comment '批改次数 times of endorsement',
        c_occup_cde varchar(30) collate utf8_bin comment '职业代码',
        c_country varchar(30) collate utf8_bin comment '  国籍',
        c_occup_sub_cde varchar(30) collate utf8_bin comment '  职业细分',
        c_work_cde varchar(30) collate utf8_bin comment '  工种',
        c_work_lvl varchar(30) collate utf8_bin comment '  级别'
)   engine=innodb default charset=utf8;
*/
truncate table  rpt_fxq_tb_ply_grp_member_ms;
insert into rpt_fxq_tb_ply_grp_member_ms(
    c_ply_no	--  保单号
    ,c_app_no   -- 申请单号,批改申请单号
    ,c_nme	
    ,c_cert_typ	--  证件类型
    ,c_cert_no	--  证件类型
    ,c_bnfc_nme	--  证件号码
    ,c_bnfc_cert_typ	--  受益人证件类型
    ,c_bnfc_cert_no	--  受益人证件号码
    ,n_edr_prj_no	--  批改次数 Times of Endorsement
    ,c_occup_cde	--  职业代码
    ,c_country	  --  国籍
    ,c_occup_sub_cde	  --  职业细分
    ,c_work_cde	  --  工种
    ,c_work_lvl	  --  级别
)
select 
    c_ply_no	--  保单号
    ,c_app_no   -- 申请单号,批改申请单号
    ,c_nme	
    ,c_cert_typ	--  证件类型
    ,c_cert_no	--  证件类型
    ,c_bnfc_nme	--  证件号码
    ,c_bnfc_cert_typ	--  受益人证件类型
    ,c_bnfc_cert_no	--  受益人证件号码
    ,n_edr_prj_no	--  批改次数 Times of Endorsement
    ,c_occup_cde	--  职业代码
    ,c_country	  --  国籍
    ,c_occup_sub_cde	  --  职业细分
    ,c_work_cde	  --  工种
    ,c_work_lvl	  --  级别
from ods_cthx_web_app_grp_member  partition(pt20191013000000) a
