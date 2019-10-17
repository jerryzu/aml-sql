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
alter table edw_cust_ply_party truncate partition pt20191013000000;

INSERT INTO edw_cust_ply_party(
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
    ,concat('1', c_cst_no, mod(substr(c_cst_no, -7, 6), 9)) c_cst_no
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
		    ,1 c_clnt_mrk -- ?????????
		    ,10 c_biz_type -- 10: 收款人, 21: 投保人, 22: 法人投保人, 31:被保人, 32:法人被保人, 33: 团单被保人，41: 受益人, 42: 法人受益人, 43: 团单受益人
		from ods_cthx_web_clm_bank  partition(pt20191013000000)  a
		    inner join ods_cthx_web_clm_main partition(pt20191013000000) c on a.c_clm_no = c.c_clm_no
            inner join rpt_fxq_tb_ply_base_ms b on c.c_ply_no = b.c_ply_no
		where c_card_type is not null and trim(c_card_type)  <> '' and c_card_type REGEXP '[^0-9.]' = 0
			and c_card_cde is not null and trim(c_card_cde)  <> '' 
		union 
		select b.c_dpt_cde c_dpt_cde
		    ,concat(rpad(a.c_certf_cls, 6, '0') , rpad(a.c_certf_cde, 18, '0')) c_cst_no -- 投保人代码,投保人唯一客户代码
            ,b.c_ply_no
            ,b.c_app_no
		    ,date_format(b.t_insrnc_bgn_tm, '%Y%m%d') t_bgn_tm
		    ,date_format(greatest(b.t_insrnc_bgn_tm,b.t_udr_tm,coalesce(b.t_edr_bgn_tm,b.t_insrnc_bgn_tm)), '%Y%m%d') t_end_tm
		    ,a.c_clnt_mrk
		    ,21 c_biz_type -- 10: 收款人, 21: 投保人, 22: 法人投保人, 31:被保人, 32:法人被保人, 33: 团单被保人，41: 受益人, 42: 法人受益人, 43: 团单受益人
		from rpt_fxq_tb_ply_applicant_ms  a
            inner join rpt_fxq_tb_ply_base_ms b on a.c_app_no = b.c_app_no
		where b.t_next_edr_bgn_tm > now() and a.c_clnt_mrk = 1
			and c_certf_cls is not null and trim(c_certf_cls)  <> '' and c_certf_cls REGEXP '[^0-9.]' = 0
			and c_certf_cde is not null and trim(c_certf_cde)  <> '' 
		union 
		select b.c_dpt_cde c_dpt_cde
		    ,concat(rpad(a.c_certf_cls, 6, '0') , rpad(a.c_certf_cde, 18, '0')) c_cst_no -- 被保人编码  
            ,b.c_ply_no
            ,b.c_app_no
		    ,date_format(b.t_insrnc_bgn_tm, '%Y%m%d') t_bgn_tm
		    ,date_format(greatest(b.t_insrnc_bgn_tm,b.t_udr_tm,coalesce(b.t_edr_bgn_tm,b.t_insrnc_bgn_tm)), '%Y%m%d') t_end_tm
		    ,a.c_clnt_mrk
		    ,31 c_biz_type -- 10: 收款人, 21: 投保人, 22: 法人投保人, 31:被保人, 32:法人被保人, 33: 团单被保人，41: 受益人, 42: 法人受益人, 43: 团单受益人
		from rpt_fxq_tb_ply_insured_ms  a
            inner join rpt_fxq_tb_ply_base_ms b on a.c_app_no = b.c_app_no
		where b.t_next_edr_bgn_tm > now() and a.c_clnt_mrk = 1
			and c_certf_cls is not null and trim(c_certf_cls)  <> '' and c_certf_cls REGEXP '[^0-9.]' = 0
			and c_certf_cde is not null and trim(c_certf_cde)  <> '' 
		union
		select b.c_dpt_cde c_dpt_cde
		    ,concat(rpad(a.c_cert_typ, 6, '0') , rpad(a.c_cert_no, 18, '0'))  c_cst_no -- 被保人编码  
            ,b.c_ply_no
            ,b.c_app_no
		    ,date_format(b.t_insrnc_bgn_tm, '%Y%m%d') t_bgn_tm
		    ,date_format(greatest(b.t_insrnc_bgn_tm,b.t_udr_tm,coalesce(b.t_edr_bgn_tm,b.t_insrnc_bgn_tm)), '%Y%m%d') t_end_tm
		    ,1 c_clnt_mrk  --  采集结果显示团单受益人只有自然人,另一个原因没有ods_cthx_web_app_grp_member.c_clnt_mrk
		    ,33 c_biz_type -- 10: 收款人, 21: 投保人, 22: 法人投保人, 31:被保人, 32:法人被保人, 33: 团单被保人，41: 受益人, 42: 法人受益人, 43: 团单受益人
		from rpt_fxq_tb_ply_grp_member_ms  a
            inner join rpt_fxq_tb_ply_base_ms b on a.c_app_no = b.c_app_no
        --    inner join ods_cthx_web_ply_bnfc partition(pt20191013000000) bn  on bn.c_app_no = b.c_app_no
		-- where b.t_next_edr_bgn_tm > now() and bn.c_clnt_mrk = 1
		where c_cert_typ is not null and trim(c_cert_typ)  <> '' and c_cert_typ REGEXP '[^0-9.]' = 0
			and c_cert_no is not null and trim(c_cert_no)  <> '' 
		union
		select b.c_dpt_cde c_dpt_cde
		    ,concat(rpad(a.c_certf_cls, 6, '0') , rpad(a.c_certf_cde, 18, '0')) c_cst_no-- 受益人代码,受益人唯一客户代码
            ,b.c_ply_no
            ,b.c_app_no
		    ,date_format(b.t_insrnc_bgn_tm, '%Y%m%d') t_bgn_tm
		    ,date_format(greatest(b.t_insrnc_bgn_tm,b.t_udr_tm,coalesce(b.t_edr_bgn_tm,b.t_insrnc_bgn_tm)), '%Y%m%d') t_end_tm
		    ,a.c_clnt_mrk
		    ,41 c_biz_type -- 10: 收款人, 21: 投保人, 22: 法人投保人, 31:被保人, 32:法人被保人, 33: 团单被保人，41: 受益人, 42: 法人受益人, 43: 团单受益人
		from rpt_fxq_tb_ply_bnfc_ms  a
            inner join rpt_fxq_tb_ply_base_ms b on a.c_app_no = b.c_app_no
		where b.t_next_edr_bgn_tm > now() and substr(a.c_certf_cls, 1, 2) in ('12')  --  and a.c_clnt_mrk = 0 -- 客户分类,0 法人，1 个人
			and c_certf_cls is not null and trim(c_certf_cls)  <> '' and c_certf_cls REGEXP '[^0-9.]' = 0
			and c_certf_cde is not null and trim(c_certf_cde)  <> '' 
        union 
		select b.c_dpt_cde c_dpt_cde
		    ,concat(rpad(a.c_bnfc_cert_typ, 6, '0') , rpad(a.c_bnfc_cert_no, 18, '0'))  c_cst_no -- 被保人编码  
            ,b.c_ply_no
            ,b.c_app_no
		    ,date_format(b.t_insrnc_bgn_tm, '%Y%m%d') t_bgn_tm
		    ,date_format(greatest(b.t_insrnc_bgn_tm,b.t_udr_tm,coalesce(b.t_edr_bgn_tm,b.t_insrnc_bgn_tm)), '%Y%m%d') t_end_tm
		    ,1 c_clnt_mrk  --  采集结果显示团单受益人只有自然人,另一个原因没有ods_cthx_web_app_grp_member.c_clnt_mrk
		    ,43 c_biz_type -- 10: 收款人, 21: 投保人, 22: 法人投保人, 31:被保人, 32:法人被保人, 33: 团单被保人，41: 受益人, 42: 法人受益人, 43: 团单受益人
		from rpt_fxq_tb_ply_grp_member_ms  a
            inner join rpt_fxq_tb_ply_base_ms b on a.c_app_no = b.c_app_no
        --    inner join ods_cthx_web_ply_bnfc partition(pt20191013000000) bn  on bn.c_app_no = b.c_app_no
		-- where b.t_next_edr_bgn_tm > now() and bn.c_clnt_mrk = 1
		where c_bnfc_cert_typ is not null and trim(c_bnfc_cert_typ)  <> '' and c_bnfc_cert_typ REGEXP '[^0-9.]' = 0
			and c_bnfc_cert_no is not null and trim(c_bnfc_cert_no)  <> '' 

) v
where c_cst_no is not null and c_cst_no REGEXP '[^0-9.]' = 0;

INSERT INTO edw_cust_ply_party(
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
    ,concat('2', c_cst_no, mod(substr(c_cst_no, -7, 6), 9)) c_cst_no
    ,c_ply_no
    ,c_app_no
    ,t_bgn_tm 
    ,t_end_tm  
    ,c_clnt_mrk
    ,c_biz_type
    ,'20191013000000' pt
from (
        select b.c_dpt_cde c_dpt_cde
            ,concat(rpad(a.c_certf_cls, 6, '0') , rpad(a.c_certf_cde, 18, '0')) c_cst_no -- 客户号
            ,b.c_ply_no
            ,b.c_app_no
		    ,date_format(b.t_insrnc_bgn_tm, '%Y%m%d') t_bgn_tm
		    ,date_format(greatest(b.t_insrnc_bgn_tm,b.t_udr_tm,coalesce(b.t_edr_bgn_tm,b.t_insrnc_bgn_tm)), '%Y%m%d') t_end_tm
		    ,c_clnt_mrk
            ,22 c_biz_type -- 10: 收款人, 21: 投保人, 22: 法人投保人, 31:被保人, 32:法人被保人, 33: 团单被保人，41: 受益人, 42: 法人受益人, 43: 团单受益人
        from rpt_fxq_tb_ply_applicant_ms a
            inner join rpt_fxq_tb_ply_base_ms b on a.c_app_no = b.c_app_no
        where b.t_next_edr_bgn_tm > now() and a.c_clnt_mrk = 0 -- 客户分类,0 法人，1 个人
			and c_certf_cls is not null and trim(c_certf_cls)  <> '' and c_certf_cls REGEXP '[^0-9.]' = 0
			and c_certf_cde is not null and trim(c_certf_cde)  <> '' 
        union 
        select b.c_dpt_cde c_dpt_cde
            ,concat(rpad(a.c_certf_cls, 6, '0') , rpad(a.c_certf_cde, 18, '0'))  c_cst_no -- 客户号
            ,b.c_ply_no
            ,b.c_app_no
		    ,date_format(b.t_insrnc_bgn_tm, '%Y%m%d') t_bgn_tm
		    ,date_format(greatest(b.t_insrnc_bgn_tm,b.t_udr_tm,coalesce(b.t_edr_bgn_tm,b.t_insrnc_bgn_tm)), '%Y%m%d') t_end_tm
		    ,c_clnt_mrk
            ,32 c_biz_type -- 10: 收款人, 21: 投保人, 22: 法人投保人, 31:被保人, 32:法人被保人, 33: 团单被保人，41: 受益人, 42: 法人受益人, 43: 团单受益人
        from rpt_fxq_tb_ply_insured_ms a -- 被保人
            inner join rpt_fxq_tb_ply_base_ms b on a.c_app_no = b.c_app_no
        where b.t_next_edr_bgn_tm > now() and a.c_clnt_mrk = 0 -- 客户分类,0 法人，1 个人
			and c_certf_cls is not null and trim(c_certf_cls)  <> '' and c_certf_cls REGEXP '[^0-9.]' = 0
			and c_certf_cde is not null and trim(c_certf_cde)  <> '' 
        union  
        select b.c_dpt_cde c_dpt_cde
            ,concat(rpad(a.c_certf_cls, 6, '0') , rpad(a.c_certf_cde, 18, '0')) c_cst_no -- 客户号
            ,b.c_ply_no
            ,b.c_app_no
		    ,date_format(b.t_insrnc_bgn_tm, '%Y%m%d') t_bgn_tm
		    ,date_format(greatest(b.t_insrnc_bgn_tm,b.t_udr_tm,coalesce(b.t_edr_bgn_tm,b.t_insrnc_bgn_tm)), '%Y%m%d') t_end_tm
		    ,c_clnt_mrk
            ,42 c_biz_type -- 10: 收款人, 21: 投保人, 22: 法人投保人, 31:被保人, 32:法人被保人, 33: 团单被保人，41: 受益人, 42: 法人受益人, 43: 团单受益人
        from rpt_fxq_tb_ply_bnfc_ms a
            inner join rpt_fxq_tb_ply_base_ms b on a.c_app_no = b.c_app_no
        where b.t_next_edr_bgn_tm > now() and substr(a.c_certf_cls, 1, 2) in ('10','11')   --  and a.c_clnt_mrk = 0 -- 客户分类,0 法人，1 个人
			and c_certf_cls is not null and trim(c_certf_cls)  <> '' and c_certf_cls REGEXP '[^0-9.]' = 0
			and c_certf_cde is not null and trim(c_certf_cde)  <> '' 
        /*
        union
        select b.c_dpt_cde c_dpt_cde
		    ,concat(rpad(a.c_bnfc_cert_typ, 6, '0') , rpad(a.c_bnfc_cert_no, 18, '0'))  c_cst_no -- 被保人编码  
            ,b.c_ply_no
            ,b.c_app_no
		    ,date_format(b.t_insrnc_bgn_tm, '%Y%m%d') t_bgn_tm
		    ,date_format(greatest(b.t_insrnc_bgn_tm,b.t_udr_tm,coalesce(b.t_edr_bgn_tm,b.t_insrnc_bgn_tm)), '%Y%m%d') t_end_tm
		    ,bn.c_clnt_mrk
		    ,44 c_biz_type -- 10: 收款人, 21: 投保人, 22: 法人投保人, 31:被保人, 32:法人被保人, 33: 团单被保人，41: 受益人, 42: 法人受益人, 43: 团单受益人
		from rpt_fxq_tb_ply_grp_member  a
            inner join rpt_fxq_tb_ply_base_ms b on a.c_app_no = b.c_app_no
            inner join rpt_fxq_tb_ply_bnfc bn  on bn.c_app_no = b.c_app_no
		where b.t_next_edr_bgn_tm > now() and bn.c_clnt_mrk = 0
        */
) vw
where c_cst_no is not null and c_cst_no REGEXP '[^0-9.]' = 0