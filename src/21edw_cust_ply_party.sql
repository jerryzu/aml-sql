alter table edw_cust_ply_party truncate partition pt20191013000000;
-- select * from edw_cust_ply_party
drop table  if exists ply_party_tmp;
create temporary table ply_party_tmp select * from edw_cust_ply_party where 1 = 2;

INSERT INTO ply_party_tmp(
    c_dpt_cde,
    c_cst_no,
    c_ply_no,
    c_app_no,
    c_app_ins_rel, -- 投保人与被保人之间的关系
    c_bnfc_ins_rel, -- 受益人与被保险人之间的关系
    c_ins_app_rel, -- 被保险人与投保人之间的关系
    t_bgn_tm,
    t_end_tm,
    t_app_tm, -- 投保日期
    t_next_edr_udr_tm, -- 下次批改核保日期 
    c_clnt_mrk,   -- 客户分类,0 法人，1 个人
    c_per_biztype
)
select  distinct
    c_dpt_cde c_dpt_cde
    ,c_cst_no
    ,c_ply_no
    ,c_app_no
	,c_app_ins_rel -- 投保人与被保人之间的关系
	,c_bnfc_ins_rel -- 受益人与被保险人之间的关系
	,c_ins_app_rel -- 被保险人与投保人之间的关系
    ,t_bgn_tm 
    ,t_end_tm  
    ,t_app_tm -- 投保日期
    ,t_next_edr_udr_tm -- 下次批改核保日期 
    ,c_clnt_mrk
    ,c_per_biztype
from (	
        select 
                b.c_dpt_cde c_dpt_cde
                , c_cst_no -- 投保人代码,投保人唯一客户代码
                ,b.c_ply_no
                ,b.c_app_no
                ,date_format(b.t_insrnc_bgn_tm, '%Y%m%d') t_bgn_tm
                ,date_format(greatest(b.t_insrnc_bgn_tm,b.t_udr_tm,coalesce(b.t_edr_bgn_tm,b.t_insrnc_bgn_tm)), '%Y%m%d') t_end_tm
                ,b.t_app_tm -- 投保日期
                ,b.t_next_edr_udr_tm -- 下次批改核保日期 
                ,a.c_clnt_mrk
				,c_app_ins_rel -- 投保人与被保人之间的关系
				,c_bnfc_ins_rel -- 受益人与被保险人之间的关系
				,c_ins_app_rel -- 被保险人与投保人之间的关系
                ,c_per_biztype c_per_biztype -- 10: 收款人, 21: 投保人, 22: 法人投保人, 31:被保人, 32:法人被保人, 33: 团单被保人，41: 受益人, 42: 法人受益人, 43: 团单受益人
        from  x_edw_cust_pers_units_info  a
                inner join ods_cthx_web_ply_base partition(pt20191013000000)  b on a.c_app_no = b.c_app_no
        where b.t_next_edr_udr_tm > now() 
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

drop table if exists ply_party_tmp_ins;

create temporary table ply_party_tmp_ins 
select c_app_no, max(c_ins_app_rel) c_ins_app_rel 
from ply_party_tmp  
where c_per_biztype in (31,32)
group by c_app_no;

drop table if exists ply_party_tmp2;
create temporary table ply_party_tmp2 select * from edw_cust_ply_party where 1 = 2;
INSERT INTO ply_party_tmp2(
    c_dpt_cde,
    c_cst_no,
    c_ply_no,
    c_app_no,
    c_app_ins_rel, -- 投保人与被保人之间的关系
    c_bnfc_ins_rel, -- 受益人与被保险人之间的关系
    c_ins_app_rel, -- 被保险人与投保人之间的关系
    t_bgn_tm,
    t_end_tm,
    b.t_app_tm, -- 投保日期
    b.t_next_edr_udr_tm, -- 下次批改核保日期 
    c_clnt_mrk,   -- 客户分类,0 法人，1 个人
    c_per_biztype
)
select 
    l.c_dpt_cde,
    l.c_cst_no,
    l.c_ply_no,
    l.c_app_no,
    ifnull(r.c_ins_app_rel, l.c_ins_app_rel) c_app_ins_rel, -- 投保人与被保人之间的关系
	l.c_bnfc_ins_rel, -- 受益人与被保险人之间的关系
    l.c_ins_app_rel, -- 被保险人与投保人之间的关系
    l.t_bgn_tm,
    l.t_end_tm,
    l.t_app_tm, -- 投保日期
    l.t_next_edr_udr_tm, -- 下次批改核保日期 
    l.c_clnt_mrk,   -- 客户分类,0 法人，1 个人
    l.c_per_biztype
from ply_party_tmp l
	left join ply_party_tmp_ins r on l.c_app_no = r.c_app_no ;

insert into edw_cust_ply_party(
    c_dpt_cde	--  机构网点代码
    ,c_ply_no	--  保单编号
    ,c_app_no	--  申请单号，批改申请单号
    ,c_cst_no	--  统一客户编号
	,c_app_ins_rel -- 投保人与被保人之间的关系
	,c_bnfc_ins_rel -- 受益人与被保险人之间的关系
	,c_ins_app_rel -- 被保险人与投保人之间的关系
    ,c_acc_name	--  客户名称
    ,c_cert_cls	--  身份证件种类
    ,c_cert_cde	--  身份证件号码
    ,t_bgn_tm	--  保险起期
    ,t_end_tm	--  保险止期
    ,t_app_tm -- 投保日期
    ,t_next_edr_udr_tm -- 下次批改核保日期 
    ,c_clnt_mrk	--  客户类型
    ,c_per_biztype	--  客户角色
    ,pt	--  分区字段
)
SELECT distinct
    m.c_dpt_cde,	--  机构网点代码
    m.c_ply_no,	--  保单编号
    m.c_app_no,	--  申请单号，批改申请单号
    m.c_cst_no,	--  统一客户编号
    c_app_ins_rel, -- 投保人与被保人之间的关系
    c_bnfc_ins_rel, -- 受益人与被保险人之间的关系
    c_ins_app_rel, -- 被保险人与投保人之间的关系
    p1.c_acc_name,	--  客户名称
    p1.c_cert_cls,	--  身份证件种类
    p1.c_cert_cde,	--  身份证件号码
    m.t_bgn_tm,	--  保险起期
    m.t_end_tm,	--  保险止期
    m.t_app_tm, -- 投保日期
    m.t_next_edr_udr_tm, -- 下次批改核保日期 
    m.c_clnt_mrk,	--  客户类型
    m.c_per_biztype,	--  客户角色
    '20191013000000'	--  分区字段
FROM ply_party_tmp2 m
    inner join ply_party_info_tmp p1 on m.c_cst_no = p1.c_cst_no;