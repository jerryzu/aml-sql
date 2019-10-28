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
-- 说明：
--   1.本表数据范围为检查业务期限内，检查对象所有退费类信息，每一笔业务生成一条完整的记录。  
--   2.退费类业务包括退保、减保、万能险部分领取、保单贷款等业务。

alter table rpt_fxq_tb_ins_rsur_ms truncate partition pt20191013000000;

INSERT INTO rpt_fxq_tb_ins_rsur_ms(
        company_code1,
        company_code2,
        company_code3,
        company_code4,
        pay_type,
        pol_no,
        app_no,
        ins_date,
        eff_date,
        cur_code,
        pre_amt_all,
        usd_amt_all,
        pay_amt_all,
        usd_pay_amt_all,
        app_name,
        app_cst_no,
        id_no,
        cus_pro,
        sur_name,
        sur_id_no,
        sur_date,
        pay_date,
        cur_code2,
        sur_amt,
        usd_sur_amt,
        tsf_flag,
        acc_name,
        acc_no,
        acc_bank,
        receipt_no,
        endorse_no,
        pt
)
select distinct
    m.c_dpt_cde as company_codel,-- 机构网点代码
    co.company_code2 as company_code2, -- 金融机构编码，人行科技司制定的14位金融标准化编码  暂时取“监管机构码，机构外部码，列为空”
    '' as company_code3,-- 保单归属机构网点代码
    '' as company_code4,-- 受理业务机构网点代码
	/* 业务类型 unpass*/  -- 11: 退保; 12: 减保; 13: 保单部分领取; 14: 保单贷款; 15: 其他
    case m.c_edr_rsn_bundle_cde 
	when '08' then 12 
	when 's1' then 11
	when 's2' then 11 end as pay_type,-- 业务类型 11:退保;12:减保;13:保单部分领取;14:保单贷款;15:其他
    m.c_ply_no as pol_no,-- 保单号
    m.c_app_no as app_no,-- 投保单号
    date_format(m.t_app_tm,'%y%m%d') as ins_date,-- 投保日期
    date_format(m.t_insrnc_bgn_tm,'%y%m%d') as eff_date,-- 合同生效日期
	/* 保费货币代码 unpass*/   -- 按照GB/T12406-2008表示货币和资金的代码标准填写, 如CNY, USD等。
    '' as cur_code,-- 保费货币代码
    null as pre_amt_all,-- 按合同币种累计缴纳保费金额
    null as usd_amt_all,-- 累计缴纳保费折合美元金额
    null as pay_amt_all,-- 累计退费金额
    null as usd_pay_amt_all,-- 累计退费金额折合美元金额
    a.c_acc_name as app_name,-- 投保人名称
    a.c_cst_no as app_cst_no,-- 投保人客户号
    a.c_cert_cde as id_no,-- 投保人证件号码
	/* 投保人客户类型 unpass*/  -- 11: 个人; 12: 单位客户。填写数字。
    case a.c_clnt_mrk
        when '1' then '11' -- 11:个人
        when '0' then '12' -- 12:单位
        else 
        null-- 其它
    end	as cus_pro,-- 投保人客户类型 11:个人;12:单位;
    '' as sur_name,-- 业务申请人名称
	/* 业务申请人证件号码 unpass*/  -- 个人填写身份证件号码, 单位按表4License字段要求填写。
    '' as sur_id_no,-- 业务申请人证件号码
    '' as sur_date,-- 业务日期
    '' as pay_date,-- 资金交易日期
	/* 币种 unpass*/  -- 按照GB/T12406-2008表示货币和资金的代码标准填写, 如CNY, USD等。
    '' as cur_code2,-- 币种
    null as sur_amt,-- 业务发生金额
    null as usd_sur_amt,-- 折合美元金额
	/* 支付方式 unpass*/   -- 10: 现金; 11: 银行转账; 12: 其他。填写数字。
    case m.c_pay_mde_cde when 5 then 11 else 10 end as tsf_flag,-- d.c_pay_mde_cde  as tsf_flag,-- 现转标识 --  SELECT C_CDE, C_CNM, 'codeKind' FROM  WEB_BAS_CODELIST PARTITION(pt20190818000000)   WHERE C_PAR_CDE = 'shoufeifangshi' ORDER BY C_CDE ;
    m.acc_name         as acc_name,-- 交费账号名称
    m.acc_no          as acc_no,-- 交费账号
    m.acc_bank	          as acc_bank,-- 交费账户开户机构名称
    m.c_app_no  as receipt_no,-- 作业流水号,唯一标识号
    m.c_edr_no as endorse_no,-- 批单号
    '20191013000000' pt
from x_rpt_fxq_tb_ins_rpol_gpol m
    --  保单人员参于类型: 投保人: [个人:21, 法人:22]; 被保人: [个人:31, 法人:32, 团单被保人:33]; 受益人: [个人:41, 法人:42,团单受益人:43]; 收款人:[11]
	inner join edw_cust_ply_party partition(pt20191013000000) a on m.c_ply_no=a.c_ply_no and a.c_per_biztype in (21, 22)
	inner join ods_cthx_web_bas_edr_rsn   partition(pt20191013000000) e on m.c_edr_rsn_bundle_cde=e.c_rsn_cde and substr(m.c_prod_no,1,2)=e.c_kind_no
	left join rpt_fxq_tb_company_ms partition (pt20191013000000) co on co.company_code1 = m.c_dpt_cde
where e.c_rsn_cde in ('08','s1','s2') and m.t_next_edr_udr_tm > now() 
	-- and m.t_edr_bgn_tm between {lastday} and {lastday}

--  退费类业务包括退保、减保、万能险部分领取、保单贷款等业务    
-- 检查业务期限内，检查对象所有退费类信息，每一笔业务生成一条完整的记录