-- *********************************************************************************
--  文件名称: 13rpt_fxq_tb_ins_rchg_ms.sql
--  所属主题: 中国人民银行反洗钱执法检查数据提取接口
--  功能描述: 从保单中间表(x_rpt_fxq_tb_ins_rpol_gpol),通过保单相关方(edw_cust_ply_party)获取投保人信息
--   通过保单批改原因表(ods_cthx_web_bas_edr_rsn)过滤批改原因为'22','-J1','-Z1'(所有非支付类保全/批改业务),的批改记录,获取最终检查期所有非支付类保全/批改业务清单
--   表提取数据
--            导入到 (rpt_fxq_tb_ins_rchg_ms) 表
--  创建者:祖新合 
--  输入: 
--  x_rpt_fxq_tb_ins_rpol_gpol -- 保单中间表(包括个单与团单)
--  edw_cust_ply_party  --保单相关方表
--  ods_cthx_web_bas_edr_rsn -- 保单批改原因表
--  rpt_fxq_tb_company_ms
--  输出:
--    rpt_fxq_tb_ins_rchg_ms
--  创建日期: 2019/10/30
--  修改日志: 
--  修改日期: 
--  修改人: 
--  修改内容：
-- 说明：
--   本表提取除退保、加保、减保、理赔、给付、保单质押借款等以外的所有非支付类保全/批改业务，每一次保全业务生产一条记录。

alter table rpt_fxq_tb_ins_rchg_ms truncate partition pt{workday}000000;

INSERT INTO rpt_fxq_tb_ins_rchg_ms(
        company_code1,
        company_code2,
        company_code3,
        company_code4,
        pol_no,
        app_no,
        app_name,
        app_cst_no,
        app_date,
        chg_date,
        chg_no,
        item,
        con_bef,
        pt
)
select
	m.c_dpt_cde as company_codel,-- 机构网点代码
	co.company_code2 as company_code2, -- 金融机构编码，人行科技司制定的14位金融标准化编码  暂时取“监管机构码，机构外部码，列为空”
	'' as company_code3,-- 保单归属机构网点代码
	'' as company_code4,-- 受理业务机构网点代码
	m.c_ply_no as pol_no,-- 保单号
	m.c_app_no as app_no,-- 投保单号
	a.c_acc_name as app_name,-- 投保人名称
	a.c_cst_no as app_cst_no,-- 投保人客户号
	date_format(m.t_edr_app_tm,'%Y%m%d') as app_date,-- 申请日期
	date_format(m.t_edr_bgn_tm,'%Y%m%d') as chg_date,-- 变更或批改日期
	m.c_edr_no as chg_no,-- 批单号
    case 
    when m.c_edr_rsn_bundle_cde = '22' then 12 -- 变更团单被保险人 -> 12 团险替换被保险人
    -- when m.c_edr_rsn_bundle_cde = 'J1' then 13 -- 减少被保险人 -> 
    -- when m.c_edr_rsn_bundle_cde = 'Z1' then 12 -- 增加被保险人
    end as item, -- 保全/批改项目	11:变更投保人;12:团险替换被保险人;13:变更受益人;14:变更客户(投保人被保人)信息;15:保单转移;
	m.c_edr_ctnt as con_bef,-- 变更内容摘要
    '{workday}000000' pt
from x_rpt_fxq_tb_ins_rpol_gpol m    
	--  保单人员参于类型: 投保人: [个人:21, 法人:22]; 被保人: [个人:31, 法人:32, 团单被保人:33]; 受益人: [个人:41, 法人:42,团单受益人:43]; 收款人:[11]
	inner join edw_cust_ply_party partition(pt{workday}000000) a on m.c_ply_no = a.c_ply_no and a.c_per_biztype in (21, 22)
	inner join ods_cthx_web_bas_edr_rsn   partition(pt{workday}000000) e on m.c_edr_rsn_bundle_cde = e.c_rsn_cde and substr(m.c_prod_no,1,2) = e.c_kind_no
    left join  rpt_fxq_tb_company_ms partition (pt{workday}000000) co on co.company_code1 = m.c_dpt_cde
where e.c_rsn_cde in ('22','-J1','-Z1') -- and m.t_next_edr_udr_tm > now()  
    and m.n_prm_var <> 0 --  测试此条件没有满足记录
	and m.t_app_tm between str_to_date('{beginday}000000','%Y%m%d%H%i%s') and str_to_date('{endday}235959','%Y%m%d%H%i%s')