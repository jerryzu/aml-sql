/*
*/
-- DROP TABLE `edw_cust_ply_party` ;

-- drop TABLE `edw_cust_ply_party` ;
-- CREATE TABLE `edw_cust_ply_party` (
--   `c_dpt_cde` varchar(20) DEFAULT NULL COMMENT '机构网点代码',
--   `c_ply_no` varchar(50) DEFAULT NULL COMMENT '保单编号',
--   `c_app_no` varchar(50) DEFAULT NULL COMMENT '申请单号，批改申请单号',
--   `c_cst_no` varchar(32) DEFAULT NULL COMMENT '统一客户编号',
--   `c_acc_name` varchar(40) DEFAULT NULL COMMENT '客户名称',
--   `c_cert_cls` varchar(8) DEFAULT NULL COMMENT '身份证件种类',
--   `c_cert_cde` varchar(50) DEFAULT NULL COMMENT '身份证件号码',
--   `c_app_ins_relation` varchar(2) DEFAULT NULL COMMENT '投保人、被保人之间的关系',
--   `c_ins_bnf_relation` varchar(2) DEFAULT NULL COMMENT '被保险人与受 益人之间的关 系',
--   `t_bgn_tm` date DEFAULT NULL COMMENT '保险起期',
--   `t_end_tm` date DEFAULT NULL COMMENT '保险止期',
--   `c_clnt_mrk` varchar(1) DEFAULT NULL COMMENT '客户类型',
--   `c_biz_type` varchar(2) DEFAULT NULL COMMENT '客户角色',
--   `pt` varchar(15) DEFAULT NULL COMMENT '分区字段'
-- ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='保单相关方关系表'
-- /*!50500 PARTITION BY RANGE  COLUMNS(pt)
-- (PARTITION pt20190822000000 VALUES LESS THAN ('20190822999999') ENGINE = InnoDB,
--  PARTITION pt20191013000000 VALUES LESS THAN ('20191013999999') ENGINE = InnoDB) */


alter table edw_cust_ply_party truncate partition pt20191013000000;

drop table  if exists ply_party_tmp;
create temporary table ply_party_tmp select * from edw_cust_ply_party where 1 = 2;

INSERT INTO ply_party_tmp(
    c_dpt_cde,
    c_cst_no,
    c_ply_no,
    c_app_no,
    t_bgn_tm,
    t_end_tm,
    c_clnt_mrk,   -- 客户分类,0 法人，1 个人
    c_app_ins_relation, --  投保人、被保人之间的关系
    c_biz_type,
    pt
)
select  distinct
    c_dpt_cde c_dpt_cde
    ,case 
        when c_clnt_mrk = 1 then 
            concat('1', c_cst_no, mod(substr(c_cst_no, -7, 6), 9)) 
        else
            concat('2', c_cst_no, mod(substr(c_cst_no, -7, 6), 9)) 
    end c_cst_no
    ,c_ply_no
    ,c_app_no
    ,t_bgn_tm 
    ,t_end_tm  
    ,c_clnt_mrk
    ,c_rel_cde c_app_ins_relation --  投保人、被保人之间的关系
    ,c_biz_type
    ,'20191013000000' pt
from (	
        select 
                b.c_dpt_cde c_dpt_cde
                , c_cst_no -- 投保人代码,投保人唯一客户代码
                ,b.c_ply_no
                ,b.c_app_no
                ,date_format(b.t_insrnc_bgn_tm, '%Y%m%d') t_bgn_tm
                ,date_format(greatest(b.t_insrnc_bgn_tm,b.t_udr_tm,coalesce(b.t_edr_bgn_tm,b.t_insrnc_bgn_tm)), '%Y%m%d') t_end_tm
                ,a.c_clnt_mrk
                ,null c_rel_cde --  与被保人关系
                ,c_per_biztype c_biz_type -- 10: 收款人, 21: 投保人, 22: 法人投保人, 31:被保人, 32:法人被保人, 33: 团单被保人，41: 受益人, 42: 法人受益人, 43: 团单受益人
        from  x_edw_cust_pers_units_info  a
                inner join rpt_fxq_tb_ply_base_ms b on a.c_app_no = b.c_app_no
        where b.t_next_edr_bgn_tm > now() 
                and c_cert_cls is not null and trim(c_cert_cls)  <> '' and c_cert_cls REGEXP '[^0-9.]' = 0
                and c_cert_cde is not null and trim(c_cert_cde)  <> ''
) v;

drop table if exists ply_party_info_tmp;

create table ply_party_info_tmp 
select 
	c_cst_no, 
	c_acc_name, 
	c_cert_cls, 
	c_cert_cde
from edw_cust_pers_info partition(pt20191013000000)
union all
select 
	c_cst_no, 
	c_acc_name, 
	c_certf_cls, 
	c_certf_cde
from edw_cust_units_info  partition(pt20191013000000);

insert into edw_cust_ply_party(
    c_dpt_cde	--  机构网点代码
    ,c_ply_no	--  保单编号
    ,c_app_no	--  申请单号，批改申请单号
    ,c_cst_no	--  统一客户编号
    ,c_acc_name	--  客户名称
    ,c_cert_cls	--  身份证件种类
    ,c_cert_cde	--  身份证件号码
    ,t_bgn_tm	--  保险起期
    ,t_end_tm	--  保险止期
    ,c_clnt_mrk	--  客户类型
    ,c_biz_type	--  客户角色
    ,pt	--  分区字段
)
SELECT distinct
    m.c_dpt_cde,	--  机构网点代码
    m.c_ply_no,	--  保单编号
    m.c_app_no,	--  申请单号，批改申请单号
    m.c_cst_no,	--  统一客户编号
    p1.c_acc_name,	--  客户名称
    p1.c_cert_cls,	--  身份证件种类
    p1.c_cert_cde,	--  身份证件号码
    m.t_bgn_tm,	--  保险起期
    m.t_end_tm,	--  保险止期
    m.c_clnt_mrk,	--  客户类型
    m.c_biz_type,	--  客户角色
    '20191013000000'	--  分区字段
FROM ply_party_tmp m
    inner join ply_party_info_tmp p1 on m.c_cst_no = p1.c_cst_no;