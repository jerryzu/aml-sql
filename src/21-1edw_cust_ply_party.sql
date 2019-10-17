/*
DROP TABLE `edw_cust_ply_party` ;

CREATE TABLE `edw_cust_ply_party` (
  `c_dpt_cde` varchar(20) DEFAULT NULL COMMENT '机构网点代码',
  `c_ply_no` varchar(50) DEFAULT NULL COMMENT '保单编号',
  `c_app_no` varchar(50) DEFAULT NULL COMMENT '申请单号，批改申请单号',
  `c_cst_no` varchar(32) DEFAULT NULL COMMENT '统一客户编号',
  `c_acc_name` varchar(40) DEFAULT NULL COMMENT '客户名称',
  `c_cert_cls` varchar(8) DEFAULT NULL COMMENT '身份证件种类',
  `c_cert_cde` varchar(50) DEFAULT NULL COMMENT '身份证件号码',
  `app_insured_relation` varchar(2) DEFAULT NULL COMMENT '投保人、被保人之间的关系',
  `t_bgn_tm` date DEFAULT NULL COMMENT '保险起期',
  `t_end_tm` date DEFAULT NULL COMMENT '保险止期',
  `c_clnt_mrk` varchar(1) DEFAULT NULL COMMENT '客户类型',
  `c_biz_type` varchar(2) DEFAULT NULL COMMENT '客户角色',
  `pt` varchar(15) DEFAULT NULL COMMENT '分区字段'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='保单相关方关系表'
*/
/*!50500 PARTITION BY RANGE  COLUMNS(pt)
(PARTITION pt20190822000000 VALUES LESS THAN ('20190822999999') ENGINE = InnoDB,
 PARTITION pt20191013000000 VALUES LESS THAN ('20191013999999') ENGINE = InnoDB) */


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
    c_biz_type,
    pt
)
select 
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
    ,c_biz_type
    ,'20191013000000' pt
from (
	select 
        b.c_dpt_cde c_dpt_cde
        ,concat(rpad(a.c_certf_cls, 6, '0') , rpad(a.c_certf_cde, 18, '0')) c_cst_no -- 投保人代码,投保人唯一客户代码
        ,b.c_ply_no
        ,b.c_app_no
        ,date_format(b.t_insrnc_bgn_tm, '%Y%m%d') t_bgn_tm
        ,date_format(greatest(b.t_insrnc_bgn_tm,b.t_udr_tm,coalesce(b.t_edr_bgn_tm,b.t_insrnc_bgn_tm)), '%Y%m%d') t_end_tm
        ,a.c_clnt_mrk
        ,case a.c_clnt_mrk when 1 then 21 when 0 then 22 end c_biz_type -- 10: 收款人, 21: 投保人, 22: 法人投保人, 31:被保人, 32:法人被保人, 33: 团单被保人，41: 受益人, 42: 法人受益人, 43: 团单受益人
	from rpt_fxq_tb_ply_applicant_ms  a
	    inner join rpt_fxq_tb_ply_base_ms b on a.c_app_no = b.c_app_no
	where b.t_next_edr_bgn_tm > now() 
        and c_certf_cls is not null and trim(c_certf_cls)  <> '' and c_certf_cls REGEXP '[^0-9.]' = 0
        and c_certf_cde is not null and trim(c_certf_cde)  <> '' 
) v;

INSERT INTO ply_party_tmp(
    c_dpt_cde,
    c_cst_no,
    c_ply_no,
    c_app_no,
    t_bgn_tm,
    t_end_tm,
    c_clnt_mrk,
    c_biz_type,
    pt
)
select 
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
    ,c_biz_type
    ,'20191013000000' pt
from (
    select b.c_dpt_cde c_dpt_cde
        ,concat(rpad(a.c_certf_cls, 6, '0') , rpad(a.c_certf_cde, 18, '0'))  c_cst_no -- 客户号
        ,b.c_ply_no
        ,b.c_app_no
        ,date_format(b.t_insrnc_bgn_tm, '%Y%m%d') t_bgn_tm
        ,date_format(greatest(b.t_insrnc_bgn_tm,b.t_udr_tm,coalesce(b.t_edr_bgn_tm,b.t_insrnc_bgn_tm)), '%Y%m%d') t_end_tm
        ,c_clnt_mrk
        ,case a.c_clnt_mrk when 1 then 31 when 0 then 32 end c_biz_type -- 10: 收款人, 21: 投保人, 22: 法人投保人, 31:被保人, 32:法人被保人, 33: 团单被保人，41: 受益人, 42: 法人受益人, 43: 团单受益人
    from rpt_fxq_tb_ply_insured_ms a -- 被保人
        inner join rpt_fxq_tb_ply_base_ms b on a.c_app_no = b.c_app_no
    where b.t_next_edr_bgn_tm > now()
        and c_certf_cls is not null and trim(c_certf_cls)  <> '' and c_certf_cls REGEXP '[^0-9.]' = 0
        and c_certf_cde is not null and trim(c_certf_cde)  <> '' 
) v;


INSERT INTO ply_party_tmp(
    c_dpt_cde,
    c_cst_no,
    c_ply_no,
    c_app_no,
    t_bgn_tm,
    t_end_tm,
    c_clnt_mrk,
    c_biz_type,
    pt
)
select 
    c_dpt_cde c_dpt_cde
    ,case 
        when c_clnt_mrk = '12' then 
            concat('1', c_cst_no, mod(substr(c_cst_no, -7, 6), 9)) 
        else
            concat('2', c_cst_no, mod(substr(c_cst_no, -7, 6), 9)) 
    end c_cst_no
    ,c_ply_no
    ,c_app_no
    ,t_bgn_tm 
    ,t_end_tm  
    ,case c_clnt_mrk when '12' then 1 else 0 end c_clnt_mrk  -- 客户分类,0 法人，1 个人
    ,case c_clnt_mrk when '12' then 41 else 42 end c_biz_type
    ,'20191013000000' pt
from (
        select 
                b.c_dpt_cde c_dpt_cde
                ,concat(rpad(a.c_certf_cls, 6, '0') , rpad(a.c_certf_cde, 18, '0')) c_cst_no-- 受益人代码,受益人唯一客户代码
                ,b.c_ply_no
                ,b.c_app_no
                ,date_format(b.t_insrnc_bgn_tm, '%Y%m%d') t_bgn_tm
                ,date_format(greatest(b.t_insrnc_bgn_tm,b.t_udr_tm,coalesce(b.t_edr_bgn_tm,b.t_insrnc_bgn_tm)), '%Y%m%d') t_end_tm
                ,substr(a.c_certf_cls, 1, 2) c_clnt_mrk --  c_clnt_mrk无值,这里判断身份证类型,
                ,41 c_biz_type -- 10: 收款人, 21: 投保人, 22: 法人投保人, 31:被保人, 32:法人被保人, 33: 团单被保人，41: 受益人, 42: 法人受益人, 43: 团单受益人
        from rpt_fxq_tb_ply_bnfc_ms  a
                inner join rpt_fxq_tb_ply_base_ms b on a.c_app_no = b.c_app_no
        where b.t_next_edr_bgn_tm > now() 
                and c_certf_cls is not null and trim(c_certf_cls)  <> '' and c_certf_cls REGEXP '[^0-9.]' = 0
                and c_certf_cde is not null and trim(c_certf_cde)  <> ''
) v;

/* 团单被保人与受益人 */
INSERT INTO ply_party_tmp(
    c_dpt_cde,
    c_cst_no,
    c_ply_no,
    c_app_no,
    t_bgn_tm,
    t_end_tm,
    c_clnt_mrk,
    c_biz_type,
    pt
)
select 
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
    ,c_clnt_mrk  -- 客户分类,0 法人，1 个人
    ,c_biz_type
    ,'20191013000000' pt
from (
		select b.c_dpt_cde c_dpt_cde
		    ,concat(rpad(a.c_cert_typ, 6, '0') , rpad(a.c_cert_no, 18, '0'))  c_cst_no -- 被保人编码  
            ,b.c_ply_no
            ,b.c_app_no
		    ,date_format(b.t_insrnc_bgn_tm, '%Y%m%d') t_bgn_tm
		    ,date_format(greatest(b.t_insrnc_bgn_tm,b.t_udr_tm,coalesce(b.t_edr_bgn_tm,b.t_insrnc_bgn_tm)), '%Y%m%d') t_end_tm
		    ,1 c_clnt_mrk  --  采集结果显示团单受益人只有自然人,另一个原因没有rpt_fxq_tb_ply_grp_member_ms.c_clnt_mrk
		    ,33 c_biz_type -- 10: 收款人, 21: 投保人, 22: 法人投保人, 31:被保人, 32:法人被保人, 33: 团单被保人，41: 受益人, 42: 法人受益人, 43: 团单受益人
		from rpt_fxq_tb_ply_grp_member_ms  a
            inner join rpt_fxq_tb_ply_base_ms b on a.c_app_no = b.c_app_no
		where c_cert_typ is not null and trim(c_cert_typ)  <> '' and c_cert_typ REGEXP '[^0-9.]' = 0
			and c_cert_no is not null and trim(c_cert_no)  <> '' 
		union
		select b.c_dpt_cde c_dpt_cde
		    ,concat(rpad(a.c_bnfc_cert_typ, 6, '0') , rpad(a.c_bnfc_cert_no, 18, '0'))  c_cst_no -- 被保人编码  
            ,b.c_ply_no
            ,b.c_app_no
		    ,date_format(b.t_insrnc_bgn_tm, '%Y%m%d') t_bgn_tm
		    ,date_format(greatest(b.t_insrnc_bgn_tm,b.t_udr_tm,coalesce(b.t_edr_bgn_tm,b.t_insrnc_bgn_tm)), '%Y%m%d') t_end_tm
		    ,1 c_clnt_mrk  --  采集结果显示团单受益人只有自然人,另一个原因没有rpt_fxq_tb_ply_grp_member_ms.c_clnt_mrk
		    ,43 c_biz_type -- 10: 收款人, 21: 投保人, 22: 法人投保人, 31:被保人, 32:法人被保人, 33: 团单被保人，41: 受益人, 42: 法人受益人, 43: 团单受益人
		from rpt_fxq_tb_ply_grp_member_ms  a
            inner join rpt_fxq_tb_ply_base_ms b on a.c_app_no = b.c_app_no
		where c_bnfc_cert_typ is not null and trim(c_bnfc_cert_typ)  <> '' and c_bnfc_cert_typ REGEXP '[^0-9.]' = 0
			and c_bnfc_cert_no is not null and trim(c_bnfc_cert_no)  <> '' 
) v;

/*
收款人
*/

INSERT INTO ply_party_tmp(
    c_dpt_cde,
    c_cst_no,
    c_ply_no,
    c_app_no,
    t_bgn_tm,
    t_end_tm,
    c_clnt_mrk,
    c_biz_type,
    pt
)
select 
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
    ,c_biz_type
    ,'20191013000000' pt
from (
		select b.c_dpt_cde c_dpt_cde
		    ,concat(rpad(a.c_card_type, 6, '0') , rpad(a.c_card_cde, 18, '0')) c_cst_no -- 收款人编号
            ,b.c_ply_no
            ,null c_app_no
		    ,date_format(b.t_insrnc_bgn_tm, '%Y%m%d') t_bgn_tm
		    ,date_format(greatest(b.t_insrnc_bgn_tm,b.t_udr_tm,coalesce(b.t_edr_bgn_tm,b.t_insrnc_bgn_tm)), '%Y%m%d') t_end_tm
		    ,1 c_clnt_mrk   -- 客户分类,0 法人，1 个人
		    ,10 c_biz_type -- 10: 收款人, 21: 投保人, 22: 法人投保人, 31:被保人, 32:法人被保人, 33: 团单被保人，41: 受益人, 42: 法人受益人, 43: 团单受益人
		from ods_cthx_web_clm_bank  partition(pt20191013000000)  a
		    inner join ods_cthx_web_clm_main partition(pt20191013000000) c on a.c_clm_no = c.c_clm_no
            inner join rpt_fxq_tb_ply_base_ms b on c.c_ply_no = b.c_ply_no
		where c_card_type is not null and trim(c_card_type)  <> '' and c_card_type REGEXP '[^0-9.]' = 0
			and c_card_cde is not null and trim(c_card_cde)  <> ''  
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
SELECT 
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