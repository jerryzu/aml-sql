-- *********************************************************************************
--  文件名称: 21edw_cust_ply_party.sql
--  所属主题: 保单-客户主题
--  功能描述: 从保单人员信息(客户信息))表中取出投保人，被保人，受益人，关联保单表获取保单信息及相关人员信息
--  对于仅有被保人、投保人关系，中间做一次转换，变成投保人被保人关系
--  合并相关方自然人表与相关方非自然人表获取唯一客户信息
--  关联保单相关人员信息与唯一客户信息获取完整客户信息，形成最终包括保单状态信息，客户类型信息(投保、被保、受益人))，客户关系信息(投保、被保、受益人关系)，客户详细信息的保单三方关系表
--   表提取数据
--            导入到 (edw_cust_ply_party) 表
--  创建者: 
--  输入: 
--  x_edw_cust_pers_units_info --保单客户信息表
--  ods_cthx_web_ply_base --保单主表
--    edw_cust_pers_info -- 相关方自然人表
--    edw_cust_units_info -- 相关方非自然人表
--  输出:  edw_cust_ply_party
--  创建日期: 2017/6/7
--  修改日志: 
--  修改日期: 
--  修改人: 
--  修改内容：

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
    c_per_biztype 	--  保单人员参于类型: 投保人: [个人:21, 法人:22]; 被保人: [个人:31, 法人:32, 团单被保人:33]; 受益人: [个人:41, 法人:42,团单受益人:43]; 收款人:[11]
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
    ,c_per_biztype 	--  保单人员参于类型: 投保人: [个人:21, 法人:22]; 被保人: [个人:31, 法人:32, 团单被保人:33]; 受益人: [个人:41, 法人:42,团单受益人:43]; 收款人:[11]
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
                ,c_per_biztype --  保单人员参于类型: 投保人: [个人:21, 法人:22]; 被保人: [个人:31, 法人:32, 团单被保人:33]; 受益人: [个人:41, 法人:42,团单受益人:43]; 收款人:[11]
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
where c_per_biztype in (31,32) 	--  保单人员参于类型: 投保人: [个人:21, 法人:22]; 被保人: [个人:31, 法人:32, 团单被保人:33]; 受益人: [个人:41, 法人:42,团单受益人:43]; 收款人:[11]
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
    c_per_biztype 	--  保单人员参于类型: 投保人: [个人:21, 法人:22]; 被保人: [个人:31, 法人:32, 团单被保人:33]; 受益人: [个人:41, 法人:42,团单受益人:43]; 收款人:[11]
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
    ,c_per_biztype	--  保单人员参于类型: 投保人: [个人:21, 法人:22]; 被保人: [个人:31, 法人:32, 团单被保人:33]; 受益人: [个人:41, 法人:42,团单受益人:43]; 收款人:[11]
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
    m.c_per_biztype,		--  保单人员参于类型: 投保人: [个人:21, 法人:22]; 被保人: [个人:31, 法人:32, 团单被保人:33]; 受益人: [个人:41, 法人:42,团单受益人:43]; 收款人:[11]
    '20191013000000'	--  分区字段
FROM ply_party_tmp2 m
    inner join ply_party_info_tmp p1 on m.c_cst_no = p1.c_cst_no;