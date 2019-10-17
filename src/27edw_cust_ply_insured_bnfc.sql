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

drop table if exists edw_cust_ply_insured_bnfc_tmp;

create temporary table edw_cust_ply_insured_bnfc_tmp select * from edw_cust_ply_insured_bnfc;


insert into edw_cust_ply_insured_bnfc_tmp(
    c_dpt_cde,
    c_ply_no,
    c_app_no,
    c_insured_no,
    c_bnfc_no,
    c_clnt_mrk,
    c_biz_type,
    pt
)
select 
    c_dpt_cde c_dpt_cde
    ,c_ply_no
    ,c_app_no
    ,concat('1', c_insured_no, mod(substr(c_insured_no, -7, 6), 9)) c_insured_no
    ,concat('1', c_bnfc_no, mod(substr(c_bnfc_no, -7, 6), 9)) c_bnfc_no
    ,c_clnt_mrk
    ,c_biz_type
    ,'{lastday}000000' pt
from (
        select 
                b.c_dpt_cde c_dpt_cde
                ,concat(rpad(a.c_cert_typ, 6, '0') , rpad(a.c_cert_no, 18, '0'))  c_insured_no -- 被保人编码  
                ,concat(rpad(a.c_bnfc_cert_typ, 6, '0') , rpad(a.c_bnfc_cert_no, 18, '0'))  c_bnfc_no -- 被保人编码  
                ,b.c_ply_no
                ,b.c_app_no
                ,date_format(b.t_insrnc_bgn_tm, '%Y%m%d') t_bgn_tm
                ,date_format(greatest(b.t_insrnc_bgn_tm,b.t_udr_tm,coalesce(b.t_edr_bgn_tm,b.t_insrnc_bgn_tm)), '%Y%m%d') t_end_tm
                ,1 c_clnt_mrk  --  采集结果显示团单受益人只有自然人,另一个原因没有ods_cthx_web_app_grp_member.c_clnt_mrk
                ,null c_biz_type -- 10: 收款人, 21: 投保人, 22: 法人投保人, 31:被保人, 32:法人被保人, 33: 团单被保人，41: 受益人, 42: 法人受益人, 43: 团单受益人
        from ods_cthx_web_app_grp_member  partition(pt{lastday}000000)  a
                inner join ods_cthx_web_ply_base partition(pt{lastday}000000) b on a.c_app_no = b.c_app_no
        where c_cert_typ is not null and trim(c_cert_typ)  <> '' and c_cert_typ REGEXP '[^0-9.]' = 0 and c_cert_no is not null and trim(c_cert_no)  <> '' 
                and c_bnfc_cert_typ is not null and trim(c_bnfc_cert_typ)  <> '' and c_bnfc_cert_typ REGEXP '[^0-9.]' = 0 and c_bnfc_cert_no is not null and trim(c_bnfc_cert_no)  <> '' 
) v
where c_insured_no is not null and c_insured_no REGEXP '[^0-9.]' = 0 and c_bnfc_no is not null and c_bnfc_no REGEXP '[^0-9.]' = 0;

insert into edw_cust_ply_insured_bnfc_tmp(
    c_dpt_cde,
    c_ply_no,
    c_app_no,
    c_insured_no,
    c_bnfc_no,
    c_clnt_mrk,
    c_biz_type,
    pt
)
select 
    c_dpt_cde c_dpt_cde
    ,c_ply_no
    ,c_app_no
    ,concat('1', c_insured_no, mod(substr(c_insured_no, -7, 6), 9)) c_insured_no
    ,concat('1', c_bnfc_no, mod(substr(c_bnfc_no, -7, 6), 9)) c_bnfc_no
    ,c_clnt_mrk
    ,c_biz_type
    ,'{lastday}000000' pt
from (
        select 
                b.c_dpt_cde c_dpt_cde
                ,concat(rpad(i.c_certf_cls, 6, '0') , rpad(i.c_certf_cde, 18, '0'))  c_insured_no -- 被保人编码  
                ,concat(rpad(b1.c_certf_cls, 6, '0') , rpad(b1.c_certf_cde, 18, '0'))  c_bnfc_no -- 被保人编码  
                ,b.c_ply_no
                ,b.c_app_no
                ,date_format(b.t_insrnc_bgn_tm, '%Y%m%d') t_bgn_tm
                ,date_format(greatest(b.t_insrnc_bgn_tm,b.t_udr_tm,coalesce(b.t_edr_bgn_tm,b.t_insrnc_bgn_tm)), '%Y%m%d') t_end_tm
                ,1 c_clnt_mrk  --  采集结果显示团单受益人只有自然人,另一个原因没有ods_cthx_web_app_grp_member.c_clnt_mrk
                ,9 c_biz_type -- 10: 收款人, 21: 投保人, 22: 法人投保人, 31:被保人, 32:法人被保人, 33: 团单被保人，41: 受益人, 42: 法人受益人, 43: 团单受益人
        from ods_cthx_web_ply_base partition(pt{lastday}000000) b  
                inner join ods_cthx_web_app_insured  partition(pt{lastday}000000)  i on b.c_app_no = i.c_app_no
                inner join ods_cthx_web_ply_bnfc  partition(pt{lastday}000000)  b1 on b.c_app_no = b1.c_app_no
        where i.c_certf_cls is not null and trim(i.c_certf_cls)  <> '' and i.c_certf_cls REGEXP '[^0-9.]' = 0 and i.c_certf_cde is not null and trim(i.c_certf_cde)  <> '' 
                and b1.c_certf_cls is not null and trim(b1.c_certf_cls)  <> '' and b1.c_certf_cls REGEXP '[^0-9.]' = 0 and b1.c_certf_cde is not null and trim(b1.c_certf_cde)  <> '' 
) v
where c_insured_no is not null and c_insured_no REGEXP '[^0-9.]' = 0 and c_bnfc_no is not null and c_bnfc_no REGEXP '[^0-9.]' = 0;

drop table if exists edw_cust_partys_info_tmp;

create table edw_cust_partys_info_tmp 
select 
	c_cst_no, 
	c_acc_name, 
	c_cert_cls, 
	c_cert_cde
from edw_cust_pers_info partition(pt{lastday}000000)
union all
select 
	c_cst_no, 
	c_acc_name, 
	c_certf_cls, 
	c_certf_cde
from edw_cust_units_info  partition(pt{lastday}000000);

insert into edw_cust_ply_insured_bnfc(
    c_dpt_cde,
    c_insured_no,
    c_insured_name,
    c_insured_cert_cls,
    c_insured_cert_cde,
    c_bnfc_no,
    c_bnfc_name,
    c_bnfc_cert_cls,
    c_bnfc_cert_cde,
    c_ply_no,
    c_app_no,
    c_clnt_mrk,
    c_biz_type,
    pt
)
SELECT 
    m.c_dpt_cde,
    m.c_insured_no,
    p1.c_acc_name c_insured_acc_name,
    p1.c_cert_cls c_insured_cert_cls,
    p1.c_cert_cde c_insured_cert_cde,
    m.c_bnfc_no,
    p2.c_acc_name c_bnfc_cst_acc_name,
    p2.c_cert_cls c_bnfc_cst_cert_cls,
    p2.c_cert_cde c_bnfc_cst_cert_cde,
    m.c_ply_no,
    m.c_app_no,
    m.c_clnt_mrk,
    m.c_biz_type,
    m.pt
FROM edw_cust_ply_insured_bnfc_tmp m
    inner join edw_cust_partys_info_tmp p1 on m.c_insured_no = p1.c_cst_no
    inner join edw_cust_partys_info_tmp p2 on m.c_bnfc_no = p2.c_cst_no;