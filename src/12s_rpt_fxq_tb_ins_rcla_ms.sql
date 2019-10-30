-- *******************eeeerrrrr**************************************************************
--  文件名称: 12s_rpt_fxq_tb_ins_rcla_ms.sql
--  所属主题: 中国人民银行反洗钱执法检查数据提取接口
--  功能描述: 
--  1.关联保单中间表(x_rpt_fxq_tb_ins_rpol_gpol)与理赔主单(ods_cthx_web_clm_main)生成理赔保单,再次关联保单相关方(edw_cust_ply_party)取出投保人信息，得到含保单，理赔单，投保人信息表
--  2.取出保单号，申请单号，理赔单号用于获取对应理赔的被保人与受益人信息
--  3.通过步骤2取出的申请单号过滤团单成员表(ods_cthx_web_app_grp_member)中获取团单对应的被保人与受益人信息
--  4.通过步骤2取出的申请单号两次关联(x_edw_cust_pers_units_info)取个单对应的被保人与受益人
--  5.合并个单与团单形成最终保单，被保人，受益人对应关系表
--  6.合并客户主题自然人客户(edw_cust_pers_info)与非自然人客户(edw_cust_units_info)，形成完整客户信息
--  7.使用步骤5.的保单，被保人，受益人对应表关联合并后客户信息表获取一致化的保单，投保人，被保人，受益人对应关系表
--  8.将结果写入目标表(s_rpt_fxq_tb_ins_rcla_ms)
--   表提取数据
--            导入到 (s_rpt_fxq_tb_ins_rcla_ms) 表
--  创建者:祖新合 
--  输入:  
--  ods_cthx_web_clm_main -- 理赔主表,用于关联保单信息与理赔信息
--  ods_cthx_web_app_grp_member -- 团单成员,用于取团单被保人与受益人对应关系
--  x_rpt_fxq_tb_ins_rpol_gpol -- 保单中间表(包括个单与团单),用于获取保单信息
--  x_edw_cust_pers_units_info --  保单分类客户信息(投保人信息,被保人信息,受益人信息,每个一条记录),用于获取被保人与受益人信息
--  edw_cust_ply_party -- 保单相关方,用于获取投保人信息
--  edw_cust_pers_info -- 客户主题-自然人信息表,用于获取自然人客户信息
--  edw_cust_units_info --  客户主题-非自然人信息表,用于获取非自然人客户信息
--  rpt_fxq_tb_company_ms 
--  输出:
--    s_rpt_fxq_tb_ins_rcla_ms
--  创建日期: 2019/10/30
--  修改日志: 
--  修改日期: 
--  修改人: 
--  修改内容：
--  说明：

drop table if exists s_rpt_fxq_tb_ins_rcla_ms;
create table s_rpt_fxq_tb_ins_rcla_ms (
    company_code1	varchar(20)	comment '机构网点代码',
    company_code2	varchar(16)	comment '金融机构编码，人行科技司制定的14位金融标准化编码  暂时取“监管机构码，机构外部码，列为空”',
    company_code3	varchar(20)	comment '保单归属机构网点代码',
    company_code4	varchar(20)	comment '受理业务机构网点代码',
    c_clm_no	varchar(60)	comment '赔案号',
    c_ply_no	varchar(60)	comment '保单号',
    c_app_no	varchar(60)	comment '投保单号',
    t_app_tm	datetime          comment '投保日期',
    t_insrnc_bgn_tm	datetime	comment '保单起效日期',
    app_name	varchar(120)	comment '投保人名称',
    app_cst_no	varchar(30)	comment '投保人客户号',
    app_id_no	varchar(30)	comment '投保人证件号码',
    c_app_clnt_mrk	varchar(2)	comment '投保人客户类型 11:个人;12:单位',
    ins_name	varchar(120)	comment '被保险人客户名称',
    ins_cst_no	varchar(30)	comment '被保险人客户号',
    ins_id_no	varchar(50)	comment '被保险人证件号码',
    c_ins_clnt_mrk	varchar(2)	comment '被保险人客户类型 11:个人;12:单位',
    benefit_name	varchar(120)	comment '受益人名称',
    benefit_id_no	varchar(50)	comment '受益人身份证件号码',
    c_bnfc_clnt_mrk	varchar(2)	comment '受益人类型 11:个人;12:单位',
    relation_1	varchar(2)	comment '投保人被保人之间的关系 11:本人;12:配偶;13:父母;14:子女;15:其他近亲属;16:雇佣或劳务;17:其他',
    relation_2	varchar(2)	comment '受益人被保人之间的关系 11:本人;12:配偶;13:父母;14:子女;15:其他近亲属;16:雇佣或劳务;18:其他',
    tsf_flag	varchar(2)	comment '现转标识',
    receipt_no	varchar(40)	comment ''
);

drop table if exists clm_ply;
create temporary table clm_ply
select
        m.c_dpt_cde as company_code1,-- 机构网点代码
        co.company_code2 as company_code2, -- 金融机构编码，人行科技司制定的14位金融标准化编码  暂时取“监管机构码，机构外部码，列为空”
        '' as company_code3,-- 保单归属机构网点代码
        '' as company_code4,-- 受理业务机构网点代码
        cm.c_clm_no, -- 赔案号
        m.c_ply_no as c_ply_no,-- 保单号
        m.c_app_no as c_app_no,-- 投保单号
        m.t_app_tm,-- 投保日期
        m.t_insrnc_bgn_tm,-- 合同生效日期
        case m.c_pay_mde_cde when 5 then 11 else 10 end as tsf_flag,-- b.c_pay_mde_cde  as tsf_flag,-- 现转标识 --  SELECT C_CDE, C_CNM, 'codeKind' FROM  WEB_BAS_CODELIST PARTITION(pt20190818000000)   WHERE C_PAR_CDE = 'shoufeifangshi' ORDER BY C_CDE ;
        cm.c_clm_no as receipt_no -- 作业流水号,唯一标识号
from  ods_cthx_web_clm_main partition(pt20191013000000) cm -- 8472
	inner join x_rpt_fxq_tb_ins_rpol_gpol m on cm.c_ply_no = m.c_ply_no -- 理赔主表  1194
	left join  rpt_fxq_tb_company_ms partition (pt20191013000000) co on co.company_code1 = m.c_dpt_cde;
	inner join ods_cthx_web_clm_bank partition(pt20191013000000) g on cm.c_clm_no=g.c_clm_no -- 领款人 1480    
where g.t_pay_tm between {beginday} and {endday}; -- 支付时间

drop table if exists clm_ply_app;
create temporary table clm_ply_app
select
	m.company_code1,-- 机构网点代码
	m.company_code2, -- 金融机构编码，人行科技司制定的14位金融标准化编码  暂时取“监管机构码，机构外部码，列为空”
	m.company_code3,-- 保单归属机构网点代码
	m.company_code4,-- 受理业务机构网点代码
    m.c_clm_no, -- 赔案号
	m.c_ply_no,-- 保单号
	m.c_app_no,-- 投保单号
    m.t_app_tm,  -- 投保日期,
    m.t_insrnc_bgn_tm,  -- 保单起效日期
	a.c_acc_name as app_name,-- 投保人名称
	a.c_cst_no as app_cst_no,-- 投保人客户号
	a.c_cert_cde as app_id_no,-- 投保人证件号码
	a.c_clnt_mrk as c_app_clnt_mrk,-- 投保人客户类型 11:个人;12:单位;
	m.tsf_flag,-- 现转标识 --  SELECT C_CDE, C_CNM, 'codeKind' FROM  WEB_BAS_CODELIST PARTITION(pt20190818000000)   WHERE C_PAR_CDE = 'shoufeifangshi' ORDER BY C_CDE ;
	m.receipt_no -- 作业流水号,唯一标识号
from  clm_ply m
    --  保单人员参于类型: 投保人: [个人:21, 法人:22]; 被保人: [个人:31, 法人:32, 团单被保人:33]; 受益人: [个人:41, 法人:42,团单受益人:43]; 收款人:[11]
    inner join edw_cust_ply_party   partition(pt20191013000000) a on m.c_app_no =a.c_app_no and a.c_per_biztype in (21, 22);

drop table if exists clm_ply_no;
create temporary table clm_ply_no 
select     
    m.c_clm_no, -- 赔案号
	m.c_ply_no, -- 保单号
	m.c_app_no -- 投保单号
from clm_ply_app m;

drop table if exists grp_member;
create temporary table grp_member
select 
    c_clm_no
    ,c_ply_no
    ,c_app_no
    ,concat('1', c_ins_no, mod(substr(c_ins_no, -7, 6), 9)) c_ins_no
    ,1 c_ins_clnt_mrk -- 被保险人客户分类,0 法人，1 个人 团单默认为1 个人
    ,concat('1', c_bnfc_no, mod(substr(c_bnfc_no, -7, 6), 9)) c_bnfc_no
    ,1 c_bnfc_clnt_mrk  -- 受益人客户分类,0 法人，1 个人 团单默认为1 个人
    ,null c_ins_app_rel -- 被保险人与投保人之间的关系
    ,null c_bnfc_ins_rel -- 受益人与被保险人之间的关系
from (select 
        pn.c_clm_no
        ,pn.c_ply_no
        ,pn.c_app_no
        ,concat(rpad(gmb.c_cert_typ, 6, '0') , rpad(gmb.c_cert_no, 18, '0'))  c_ins_no -- 被保人编码
        ,concat(rpad(gmb.c_bnfc_cert_typ, 6, '0') , rpad(gmb.c_bnfc_cert_no, 18, '0'))  c_bnfc_no -- 受益人编码
    from ods_cthx_web_app_grp_member partition(pt20191013000000) gmb
        inner join clm_ply_no pn
            on gmb.c_app_no = pn.c_app_no
    where c_cert_typ is not null and trim(c_cert_typ)  <> '' and c_cert_typ REGEXP '[^0-9.]' = 0 and c_cert_no is not null and trim(c_cert_no)  <> '' 
    and c_bnfc_cert_typ is not null and trim(c_bnfc_cert_typ)  <> '' and c_bnfc_cert_typ REGEXP '[^0-9.]' = 0 and c_bnfc_cert_no is not null and trim(c_bnfc_cert_no)  <> '' 
) v
where c_ins_no is not null and c_ins_no REGEXP '[^0-9.]' = 0 and c_bnfc_no is not null and c_bnfc_no REGEXP '[^0-9.]' = 0;


drop table if exists single_ins;
create temporary table single_ins
select distinct
    c_clm_no
    ,c_ply_no
    ,c_app_no
    ,c_ins_no
    ,c_ins_clnt_mrk -- 被保险人客户分类,0 法人，1 个人 团单默认为1 个人
    ,c_ins_app_rel -- 被保险人与投保人之间的关系
 from (
        select 
            m.c_clm_no
            ,m.c_ply_no
            ,m.c_app_no
            ,i.c_cst_no  c_ins_no -- 被保人编码  
            ,i.c_clnt_mrk c_ins_clnt_mrk
            ,i.c_ins_app_rel -- 被保险人与投保人之间的关系
        from clm_ply_no m  
            --  保单人员参于类型: 投保人: [个人:21, 法人:22]; 被保人: [个人:31, 法人:32, 团单被保人:33]; 受益人: [个人:41, 法人:42,团单受益人:43]; 收款人:[11]
            --  inner join edw_cust_ply_party  i on m.c_app_no = i.c_app_no and i.c_per_biztype in (31, 32)  -- 156
    		inner join x_edw_cust_pers_units_info  i on m.c_app_no = i.c_app_no and i.c_per_biztype in (31, 32)  
        where i.c_cert_cls is not null and trim(i.c_cert_cls)  <> '' and i.c_cert_cls REGEXP '[^0-9.]' = 0 and i.c_cert_cde is not null and trim(i.c_cert_cde)  <> '' 
) v
where c_ins_no is not null and c_ins_no REGEXP '[^0-9.]' = 0;

drop table if exists single;
create temporary table single
select distinct
    c_clm_no
    ,c_ply_no
    ,c_app_no
    ,c_ins_no
    ,c_ins_clnt_mrk -- 被保险人客户分类,0 法人，1 个人 团单默认为1 个人
    ,c_bnfc_no
    ,c_bnfc_clnt_mrk  -- 受益人客户分类,0 法人，1 个人 团单默认为1 个人
    ,c_ins_app_rel -- 被保险人与投保人之间的关系
    ,c_bnfc_ins_rel -- 受益人与被保险人之间的关系
from (
        select 
            m.c_clm_no
            ,m.c_ply_no
            ,m.c_app_no
            ,m.c_ins_no -- 被保人编码
            ,m.c_ins_clnt_mrk -- 被保险人客户分类,0 法人，1 个人 团单默认为1 个人  
            ,b.c_cst_no  c_bnfc_no -- 受益编码  
            ,b.c_clnt_mrk c_bnfc_clnt_mrk
            ,m.c_ins_app_rel -- 被保险人与投保人之间的关系
            ,b.c_bnfc_ins_rel -- 受益人与被保险人之间的关系
        from single_ins m  
                --  保单人员参于类型: 投保人: [个人:21, 法人:22]; 被保人: [个人:31, 法人:32, 团单被保人:33]; 受益人: [个人:41, 法人:42,团单受益人:43]; 收款人:[11]
                -- inner join edw_cust_ply_party  b on m.c_app_no = b.c_app_no and b.c_per_biztype in (41, 42) 
                inner join x_edw_cust_pers_units_info  b on m.c_app_no = b.c_app_no and b.c_per_biztype in (41, 42) 
        where b.c_cert_cls is not null and trim(b.c_cert_cls)  <> '' and b.c_cert_cls REGEXP '[^0-9.]' = 0 and b.c_cert_cde is not null and trim(b.c_cert_cde)  <> '' 
) v
where c_ins_no is not null and c_ins_no REGEXP '[^0-9.]' = 0 and c_bnfc_no is not null and c_bnfc_no REGEXP '[^0-9.]' = 0;


drop table if exists ins_bnf;
create temporary table ins_bnf
select 
    c_clm_no
    ,c_ply_no
    ,c_app_no
    ,c_ins_no
    ,c_ins_clnt_mrk -- 被保险人客户分类,0 法人，1 个人 团单默认为1 个人
    ,c_bnfc_no
    ,c_bnfc_clnt_mrk  -- 受益人客户分类,0 法人，1 个人 团单默认为1 个人
    ,c_ins_app_rel -- 被保险人与投保人之间的关系
    ,c_bnfc_ins_rel -- 受益人与被保险人之间的关系
from  grp_member
union all
select 
    c_clm_no
    ,c_ply_no
    ,c_app_no
    ,c_ins_no
    ,c_ins_clnt_mrk -- 被保险人客户分类,0 法人，1 个人 团单默认为1 个人
    ,c_bnfc_no
    ,c_bnfc_clnt_mrk  -- 受益人客户分类,0 法人，1 个人 团单默认为1 个人
    ,c_ins_app_rel -- 被保险人与投保人之间的关系
    ,c_bnfc_ins_rel -- 受益人与被保险人之间的关系
from  single;

drop table if exists party_info;

create temporary table party_info 
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

drop table if exists party_info2;

create temporary table party_info2 select * from  party_info;

drop table if exists ins_bnf_info;

create temporary table ins_bnf_info 
select 
    ib.c_clm_no
    ,ib.c_ply_no
    ,ib.c_app_no
    ,ib.c_ins_no    
    ,i.c_acc_name ins_name
    -- ,i.c_cert_cls 
    ,i.c_cert_cde ins_id_no
    ,ib.c_ins_clnt_mrk -- 被保险人客户分类,0 法人，1 个人 团单默认为1 个人???????
    ,ib.c_bnfc_no
    ,b.c_acc_name benefit_name
    -- ,b.c_cert_cls 
    ,b.c_cert_cde benefit_id_no
    ,ib.c_bnfc_clnt_mrk  -- 受益人客户分类,0 法人，1 个人 团单默认为1 个人????????????
    ,ib.c_ins_app_rel -- 被保险人与投保人之间的关系
    ,ib.c_bnfc_ins_rel -- 受益人与被保险人之间的关系
from ins_bnf ib
    left join party_info i on ib.c_ins_no = i.c_cst_no    
    left join party_info2 b on ib.c_bnfc_no = b.c_cst_no;

insert into s_rpt_fxq_tb_ins_rcla_ms(
    company_code1	-- 机构网点代码
    ,company_code2	-- 金融机构编码，人行科技司制定的14位金融标准化编码  暂时取“监管机构码，机构外部码，列为空”
    ,company_code3	-- 保单归属机构网点代码
    ,company_code4	-- 受理业务机构网点代码
    ,c_clm_no	-- 赔案号
    ,c_ply_no	-- 保单号
    ,c_app_no	-- 投保单号
    ,t_app_tm	-- 投保日期
    ,t_insrnc_bgn_tm -- 保单起效日期
    ,app_name	-- 投保人名称
    ,app_cst_no	-- 投保人客户号
    ,app_id_no	-- 投保人证件号码
    ,c_app_clnt_mrk	-- 投保人客户类型 11:个人;12:单位
    ,ins_name	-- 被保险人客户名称
    ,ins_cst_no	-- 被保险人客户号
    ,ins_id_no	-- 被保险人证件号码
    ,c_ins_clnt_mrk	-- 被保险人客户类型 11:个人;12:单位
    ,benefit_name	-- 受益人名称
    ,benefit_id_no	-- 受益人身份证件号码
    ,c_bnfc_clnt_mrk	-- 受益人类型 11:个人;12:单位
    ,relation_1	-- 投保人被保人之间的关系 11:本人;12:配偶;13:父母;14:子女;15:其他近亲属;16:雇佣或劳务;17:其他
    ,relation_2	-- 受益人被保人之间的关系 11:本人;12:配偶;13:父母;14:子女;15:其他近亲属;16:雇佣或劳务;18:其他
    ,tsf_flag	-- 现转标识
    ,receipt_no    
)
select 
    company_code1	-- 机构网点代码
    ,company_code2	-- 金融机构编码，人行科技司制定的14位金融标准化编码  暂时取“监管机构码，机构外部码，列为空”
    ,company_code3	-- 保单归属机构网点代码
    ,company_code4	-- 受理业务机构网点代码
    ,cpa.c_clm_no	-- 赔案号
    ,cpa.c_ply_no 	-- 保单号
    ,cpa.c_app_no	-- 投保单号
    ,t_app_tm	-- 投保日期
    ,t_insrnc_bgn_tm -- 保单起效日期
    ,app_name	-- 投保人名称
    ,app_cst_no	-- 投保人客户号
    ,app_id_no	-- 投保人证件号码
    ,c_app_clnt_mrk	-- 投保人客户类型 11:个人;12:单位
    ,ins_name	-- 被保险人客户名称
    ,c_ins_no ins_cst_no	-- 被保险人客户号
    ,ins_id_no	-- 被保险人证件号码
    ,c_ins_clnt_mrk	-- 被保险人客户类型 11:个人;12:单位
    ,benefit_name	-- 受益人名称
    ,benefit_id_no	-- 受益人身份证件号码
    ,c_bnfc_clnt_mrk 	-- 受益人类型 11:个人;12:单位
    ,ib.c_ins_app_rel relation_1	-- 投保人被保人之间的关系 11:本人;12:配偶;13:父母;14:子女;15:其他近亲属;16:雇佣或劳务;17:其他
    ,ib.c_bnfc_ins_rel relation_2	-- 受益人被保人之间的关系 11:本人;12:配偶;13:父母;14:子女;15:其他近亲属;16:雇佣或劳务;18:其他
    ,tsf_flag	-- 现转标识
    ,receipt_no    
from clm_ply_app cpa
    inner join ins_bnf_info ib on cpa.c_app_no = ib.c_app_no;