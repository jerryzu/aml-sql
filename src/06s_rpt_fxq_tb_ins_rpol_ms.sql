-- *********************************************************************************
--  文件名称: 06s_rpt_fxq_tb_ins_rpol_ms.sql
--  所属主题: 中国人民银行反洗钱执法检查数据提取接口
--  功能描述: 实现保单被保人与受益人关系信息表
--  处理逻辑
--  对于团单,直接通过团单成员信息表(ods_cthx_web_app_grp_member),获取团单被保人与受益人信息
--  对于个单,通过保单中间表(x_rpt_fxq_tb_ins_rpol_gpol),以保单相关方关系表(edw_cust_ply_party)过滤获取自然人保单
--  二次关联保单客户信息(x_edw_cust_pers_units_info),获取保单被保人,保单受益人关系
--  通过合并客户自然人表(edw_cust_pers_info),客户非自然人表(edw_cust_units_info)形成唯一客户信息
--  对已获取的保单关系表(保单,被保人,受益人),关联合并后的客户信息生成最终包括保单,保单被保人,保单受益人信息
--   表提取数据
--            导入到 (s_rpt_fxq_tb_ins_rpol_ms) 表
--  创建者:祖新合 
--  输入: 
--  ods_cthx_web_app_grp_member -- 团单成员信息表
--  x_rpt_fxq_tb_ins_rpol_gpol -- 保单中间表(包括个单与团单)
--  x_edw_cust_pers_units_info --保单分类客户信息(投保人信息,被保人信息,受益人信息,每个一条记录))
--  edw_cust_pers_info -- 身份证编号唯一自然人客户信息表
--  edw_cust_units_info -- 法人编号唯一非自然人客户信息表
--  输出:  
--  创建日期: 2019/10/30
--  修改日志: 
--  修改日期: 
--  修改人: 
--  修改内容：

truncate table s_rpt_fxq_tb_ins_rpol_ms;

drop table if exists s_rpt_fxq_tb_ins_rpol_ms_tmp;

create temporary table s_rpt_fxq_tb_ins_rpol_ms_tmp select * from s_rpt_fxq_tb_ins_rpol_ms;

/*插入团单的被保人受益人--这部分保单被保人与受益人一对多*/
insert into s_rpt_fxq_tb_ins_rpol_ms_tmp(
    c_dpt_cde,
    c_ply_no,
    c_app_no,
    c_ins_no,
    c_ins_clnt_mrk, -- 被保险人客户分类,0 法人，1 个人 团单默认为1 个人
    c_bnfc_no,
    c_bnfc_clnt_mrk,  -- 受益人客户分类,0 法人，1 个人 团单默认为1 个人
    c_grp_mrk  -- 团单标志( 0 个单; 1 团单) Group Insurance Flag
)
select distinct
    c_dpt_cde c_dpt_cde
    ,c_ply_no
    ,c_app_no
    ,concat('1', c_ins_no, mod(substr(c_ins_no, -7, 6), 9)) c_ins_no
    ,1 c_ins_clnt_mrk -- 被保险人客户分类,0 法人，1 个人 团单默认为1 个人
    ,concat('1', c_bnfc_no, mod(substr(c_bnfc_no, -7, 6), 9)) c_bnfc_no
    ,1 c_bnfc_clnt_mrk  -- 受益人客户分类,0 法人，1 个人 团单默认为1 个人
    ,0 c_grp_mrk  -- 团单标志( 0 个单; 1 团单) Group Insurance Flag
from (
        select 
                m.c_dpt_cde c_dpt_cde
                ,concat(rpad(gmb.c_cert_typ, 6, '0') , rpad(gmb.c_cert_no, 18, '0'))  c_ins_no -- 被保人编码
                ,concat(rpad(gmb.c_bnfc_cert_typ, 6, '0') , rpad(gmb.c_bnfc_cert_no, 18, '0'))  c_bnfc_no -- 受益人编码
                ,m.c_ply_no
                ,m.c_app_no
                ,date_format(m.t_insrnc_bgn_tm, '%Y%m%d') t_bgn_tm
                ,date_format(greatest(m.t_insrnc_bgn_tm,m.t_udr_tm,coalesce(m.t_edr_bgn_tm,m.t_insrnc_bgn_tm)), '%Y%m%d') t_end_tm
                ,1 c_clnt_mrk  --  采集结果显示团单受益人只有自然人,另一个原因没有ods_cthx_web_app_grp_member.c_clnt_mrk
        from ods_cthx_web_app_grp_member partition(pt20191013000000) gmb
                inner join x_rpt_fxq_tb_ins_rpol_gpol m on gmb.c_app_no = m.c_app_no
        where c_cert_typ is not null and trim(c_cert_typ)  <> '' and c_cert_typ REGEXP '[^0-9.]' = 0 and c_cert_no is not null and trim(c_cert_no)  <> '' 
                and c_bnfc_cert_typ is not null and trim(c_bnfc_cert_typ)  <> '' and c_bnfc_cert_typ REGEXP '[^0-9.]' = 0 and c_bnfc_cert_no is not null and trim(c_bnfc_cert_no)  <> '' 
) v
where c_ins_no is not null and c_ins_no REGEXP '[^0-9.]' = 0 and c_bnfc_no is not null and c_bnfc_no REGEXP '[^0-9.]' = 0;

/*个单 被保人受益人--这部分保单被保人通过保单一多关系*/

drop table if exists s_rpt_fxq_tb_ins_rpol_ms_tmp_single;

create temporary table s_rpt_fxq_tb_ins_rpol_ms_tmp_single select * from s_rpt_fxq_tb_ins_rpol_ms;

insert into s_rpt_fxq_tb_ins_rpol_ms_tmp_single(
    c_dpt_cde,
    c_ply_no,
    c_app_no,
    c_ins_no,
    c_ins_clnt_mrk, -- 被保险人客户分类,0 法人，1 个人
    c_bnfc_no,
    c_bnfc_clnt_mrk,  -- 受益人客户分类,0 法人，1 个人
    c_grp_mrk  -- 团单标志( 0 个单; 1 团单) Group Insurance Flag
)
select distinct
    c_dpt_cde c_dpt_cde
    ,c_ply_no
    ,c_app_no
    ,c_ins_no
    ,c_ins_clnt_mrk 
    ,c_bnfc_no
    ,c_bnfc_clnt_mrk
    ,1 c_grp_mrk  -- 团单标志( 0 个单; 1 团单) Group Insurance Flag
from (
        select 
                m.c_dpt_cde c_dpt_cde
                ,i.c_clnt_mrk c_ins_clnt_mrk
                ,i.c_cst_no  c_ins_no -- 被保人编码  
                ,null c_bnfc_clnt_mrk
                ,null  c_bnfc_no -- 受益人编码  
                ,m.c_ply_no
                ,m.c_app_no
                ,date_format(m.t_insrnc_bgn_tm, '%Y%m%d') t_bgn_tm
                ,date_format(greatest(m.t_insrnc_bgn_tm,m.t_udr_tm,coalesce(m.t_edr_bgn_tm,m.t_insrnc_bgn_tm)), '%Y%m%d') t_end_tm
                ,1 c_clnt_mrk  
        from x_rpt_fxq_tb_ins_rpol_gpol m  
                --  保单人员参于类型: 投保人: [个人:21, 法人:22]; 被保人: [个人:31, 法人:32, 团单被保人:33]; 受益人: [个人:41, 法人:42,团单受益人:43]; 收款人:[11]
				inner join edw_cust_ply_party partition(pt20191013000000) a on m.c_app_no=a.c_app_no and a.c_per_biztype =  21 
                inner join x_edw_cust_pers_units_info  i on m.c_app_no = i.c_app_no and i.c_per_biztype in (31, 32)  
                -- inner join x_edw_cust_pers_units_info  b on m.c_app_no = b.c_app_no and b.c_per_biztype in (41, 42)  
        where i.c_cert_cls is not null and trim(i.c_cert_cls)  <> '' and i.c_cert_cls REGEXP '[^0-9.]' = 0 and i.c_cert_cde is not null and trim(i.c_cert_cde)  <> '' 
                -- and b.c_cert_cls is not null and trim(b.c_cert_cls)  <> '' and b.c_cert_cls REGEXP '[^0-9.]' = 0 and b.c_cert_cde is not null and trim(b.c_cert_cde)  <> '' 
) v
where c_ins_no is not null and c_ins_no REGEXP '[^0-9.]' = 0; 
    -- and c_bnfc_no is not null and c_bnfc_no REGEXP '[^0-9.]' = 0;


--  select * from s_rpt_fxq_tb_ins_rpol_ms_tmp_single where c_ply_no = 'P997306802201900000003'

insert into s_rpt_fxq_tb_ins_rpol_ms_tmp(
    c_dpt_cde,
    c_ply_no,
    c_app_no,
    c_ins_no,
    c_ins_clnt_mrk, -- 被保险人客户分类,0 法人，1 个人
    c_bnfc_no,
    c_bnfc_clnt_mrk,  -- 受益人客户分类,0 法人，1 个人
    c_grp_mrk  -- 团单标志( 0 个单; 1 团单) Group Insurance Flag
)
select distinct
    c_dpt_cde c_dpt_cde
    ,c_ply_no
    ,c_app_no
    ,c_ins_no
    ,c_ins_clnt_mrk 
    ,c_bnfc_no
    ,c_bnfc_clnt_mrk
    ,1 c_grp_mrk  -- 团单标志( 0 个单; 1 团单) Group Insurance Flag
from (
        select 
                m.c_dpt_cde c_dpt_cde
                ,m.c_ins_clnt_mrk c_ins_clnt_mrk
                ,m.c_ins_no  c_ins_no -- 被保人编码  
                ,b.c_clnt_mrk c_bnfc_clnt_mrk
                ,b.c_cst_no  c_bnfc_no -- 受益人编码  
                ,m.c_ply_no
                ,m.c_app_no
                ,1 c_clnt_mrk  --  采集结果显示团单受益人只有自然人,另一个原因没有ods_cthx_web_app_grp_member.c_clnt_mrk
        from s_rpt_fxq_tb_ins_rpol_ms_tmp_single m  
            --  保单人员参于类型: 投保人: [个人:21, 法人:22]; 被保人: [个人:31, 法人:32, 团单被保人:33]; 受益人: [个人:41, 法人:42,团单受益人:43]; 收款人:[11]
			inner join x_edw_cust_pers_units_info  b on m.c_app_no = b.c_app_no and b.c_per_biztype in (41, 42) 
        where b.c_cert_cls is not null and trim(b.c_cert_cls)  <> '' and b.c_cert_cls REGEXP '[^0-9.]' = 0 and b.c_cert_cde is not null and trim(b.c_cert_cde)  <> '' 
) v
where c_ins_no is not null and c_ins_no REGEXP '[^0-9.]' = 0 and c_bnfc_no is not null and c_bnfc_no REGEXP '[^0-9.]' = 0;


drop table if exists edw_cust_partys_info_tmp;

create temporary table edw_cust_partys_info_tmp 
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
from edw_cust_units_info partition(pt20191013000000);


/*
以下sql多表关联运行不出来，准备修改成两两关联
*/

drop table if exists s_rpt_fxq_tb_ins_rpol_ms_tmp2;

create temporary table s_rpt_fxq_tb_ins_rpol_ms_tmp2 select * from s_rpt_fxq_tb_ins_rpol_ms;

insert into s_rpt_fxq_tb_ins_rpol_ms_tmp2(
    c_dpt_cde,
    c_ins_no,
    c_ins_clnt_mrk, -- 被保险人客户分类,0 法人，1 个人
    c_ins_name,
    c_ins_cert_cls,
    c_ins_cert_cde,
    c_bnfc_no,
    c_bnfc_clnt_mrk,  -- 受益人客户分类,0 法人，1 个人
    -- c_bnfc_name,
    -- c_bnfc_cert_cls,
    -- c_bnfc_cert_cde,
    c_ply_no,
    c_app_no,
    c_grp_mrk,
    pt
)
SELECT 
    m.c_dpt_cde,
    m.c_ins_no,
    m.c_ins_clnt_mrk,
    p1.c_acc_name c_ins_name,
    p1.c_cert_cls c_ins_cert_cls,
    p1.c_cert_cde c_ins_cert_cde,
    m.c_bnfc_no,
    m.c_bnfc_clnt_mrk, 
    -- p2.c_acc_name c_bnfc_name,
    -- p2.c_cert_cls c_bnfc_cert_cls,
    -- p2.c_cert_cde c_bnfc_cert_cde,
    m.c_ply_no,
    m.c_app_no,
    m.c_grp_mrk,
    '20191013000000' pt
FROM s_rpt_fxq_tb_ins_rpol_ms_tmp m
    inner join edw_cust_partys_info_tmp p1 on m.c_ins_no = p1.c_cst_no;
    -- inner join edw_cust_partys_info_tmp p2 on m.c_bnfc_no = p2.c_cst_no;

insert into s_rpt_fxq_tb_ins_rpol_ms(
    c_dpt_cde,
    c_ins_no,
    c_ins_clnt_mrk, 
    c_ins_name,
    c_ins_cert_cls,
    c_ins_cert_cde,
    c_bnfc_no,
    c_bnfc_clnt_mrk, 
    c_bnfc_name,
    c_bnfc_cert_cls,
    c_bnfc_cert_cde,
    c_ply_no,
    c_app_no,
    c_grp_mrk,
    pt
)
SELECT 
    m.c_dpt_cde,
    m.c_ins_no,
    m.c_ins_clnt_mrk,
    m.c_ins_name ,
    m.c_ins_cert_cls ,
    m.c_ins_cert_cde ,
    m.c_bnfc_no,
    m.c_bnfc_clnt_mrk, 
    p2.c_acc_name c_bnfc_name,
    p2.c_cert_cls c_bnfc_cert_cls,
    p2.c_cert_cde c_bnfc_cert_cde,
    m.c_ply_no,
    m.c_app_no,
    m.c_grp_mrk,
    '20191013000000' pt
FROM s_rpt_fxq_tb_ins_rpol_ms_tmp2 m
    -- inner join edw_cust_partys_info_tmp p1 on m.c_insured_no = p1.c_cst_no
    inner join edw_cust_partys_info_tmp p2 on m.c_bnfc_no = p2.c_cst_no;   