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

SELECT @@global.group_concat_max_len;
SET SESSION group_concat_max_len=10240;
alter table edw_cust_ply_party_applicant truncate partition pt{lastday}000000;

INSERT INTO edw_cust_ply_party_applicant(
        c_ply_no,
        c_app_no,
        c_cst_no,
        c_applicant_name,
        c_cert_cls,
        c_cert_cde,
        c_clnt_mrk,
        c_biz_type,
        pt
)
SELECT
    pp.c_ply_no,
    pp.c_app_no,
    pp.c_cst_no,
    c_acc_name as c_applicant_name,
    c_cert_cls as c_cert_cls,
    c_cert_cde as c_cert_cde,
    pp.c_clnt_mrk,
    pp.c_biz_type,
    pp.pt
FROM edw_cust_ply_party partition(pt{lastday}000000) pp
    inner join edw_cust_pers_info partition(pt{lastday}000000) p on pp.c_cst_no = p.c_cst_no
where pp.c_biz_type = 21; -- 10: 收款人, 21: 投保人, 22: 法人投保人, 31:被保人, 32:法人被保人, 33: 团单被保人，41: 受益人, 42: 法人受益人, 43: 团单受益人

INSERT INTO edw_cust_ply_party_applicant(
        c_ply_no,
        c_app_no,
        c_cst_no,
        c_applicant_name,
        c_cert_cls,
        c_cert_cde,
        c_clnt_mrk,
        c_biz_type,
        pt
)
SELECT
    pp.c_ply_no,
    pp.c_app_no,
    pp.c_cst_no,
    c_acc_name as c_applicant_name,
    c_certf_cls as c_cert_cls,
    c_certf_cde as c_cert_cde,
    pp.c_clnt_mrk,
    pp.c_biz_type,
    pp.pt
FROM edw_cust_ply_party partition(pt{lastday}000000) pp
    inner join edw_cust_units_info partition(pt{lastday}000000) p on pp.c_cst_no = p.c_cst_no
where pp.c_biz_type = 22; -- 10: 收款人, 21: 投保人, 22: 法人投保人, 31:被保人, 32:法人被保人, 33: 团单被保人，41: 受益人, 42: 法人受益人, 43: 团单受益人
