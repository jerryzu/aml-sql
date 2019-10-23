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
--   本表数据范围为检查业务期限内，检查对象办理的所有的增加或追加保费、保额业务保单信息，每一条业务生成一条完整的记录，本表不含首期业务。

alter table rpt_fxq_tb_ins_renewal_ms truncate partition pt20191013000000;

INSERT INTO rpt_fxq_tb_ins_renewal_ms(
        company_code1,
        company_code2,
        company_code3,
        company_code4,
        pol_no,
        app_no,
        ins_date,
        app_name,
        app_cst_no,
        app_id_type,
        app_id_no,
        ins_no,
        renew_date,
        pay_date,
        cur_code,
        pre_amt,
        usd_amt,
        tsf_flag,
        acc_name,
        acc_no,
        acc_bank,
        receipt_no,
        endorse_no,
        pt
)
select
    m.c_dpt_cde as company_codel,-- 机构网点代码
    co.company_code2 as company_code2, -- 金融机构编码，人行科技司制定的14位金融标准化编码  暂时取“监管机构码，机构外部码，列为空”
    '' as company_code3,-- 保单归属机构网点代码
    '' as company_code4,-- 受理业务机构网点代码
    m.c_ply_no as pol_no,-- 保单号
    m.c_app_no as app_no,-- 投保单号
    date_format(m.t_app_tm,'%Y%m%d') as ins_date,-- 投保日期
    a.c_acc_name as app_name,-- 投保人名称
    a.c_cst_no as app_cst_no,-- 投保人客户号
    case a.c_cert_cls
    when '100111' then 22 -- 税务登记证
    when '100112' then 21 -- 统一社会信用代码
    when '110001' then 22 -- 组织机构代码
    when '110002' then 22 -- 工商注册号码
    when '110003' then 21 -- 营业执照
    when  '120001' then 11 -- 居民身份证
    when  '120002' then 13 -- 护照
    when  '120003' then 12 -- 军人证
    when  '120004' then 13 -- 回乡证
    when  '120005' then 14 -- 港澳居民居住证
    when  '120006' then 14 -- 台湾居民居住证
    when  '120009' then 18 -- 其它
    else 22 -- 其它
    end as app_id_type,-- 投保人身份证件类型
    a.c_cert_cde as app_id_no,-- 投保人证件号码
	/* 险种代码 unpass关于险种代码与产品代码*/ -- 如: tb_ins_rtype定义; 
    case p.c_kind_no
	when '01' then '11'
	when '02' then '11'
	when '03' then '10'
	when '04' then '13'
	when '05' then '15'
	when '06' then '14'
	when '07' then '14'
	when '08' then '11'
	when '09' then '11'
	when '10' then '16'
	when '11' then '12'
	when '12' then '15'
	when '16' then '16'
	else '其他'
    end as ins_no,-- 险种代码
    '' as renew_date,-- 业务发生日期
    '' as pay_date,-- 资金交易日期
    case m.c_prm_cur 
    when  '01' then 'CNY' -- 人民币
    when  '02' then 'USD' -- 美元
    when  '03' then 'HKD' -- 港币
    when  '04' then 'CHF' -- 瑞士法郎
    when  '05' then 'FF' -- 法国法郎
    when  '06' then 'JPY' -- 日元
    when  '07' then 'GBP' -- 英镑
    when  '08' then 'EUR' -- 欧元
    when  '09' then 'DM' -- 德国马克
    when  '10' then 'SEK' -- 瑞典克朗
    else 
    '@N' -- 其它
    end as  cur_code,-- 币种
    m.n_prm as pre_amt,-- 本期交保费金额
    -9999 as usd_amt,-- 折合美元金额
	/* 现转标识 unpass*/   -- 10: 现金交保险公司; 11: 转账; 12: 现金缴款单(指客户向银行缴纳现金, 凭借银行开具的单据向保险机构办理交费业务); 13: 保险公司业务员代付。网银转账、银行柜面转账、POS刷卡、直接转账给总公司账户等情形, 应标识为转账。填写数字。
    case m.c_pay_mde_cde when 5 then 11 else 10 end as tsf_flag,-- d.c_pay_mde_cde  as tsf_flag,-- 现转标识 --  SELECT C_CDE, C_CNM, 'codeKind' FROM  WEB_BAS_CODELIST PARTITION(pt20190818000000)   WHERE C_PAR_CDE = 'shoufeifangshi' ORDER BY C_CDE ;
    m.acc_name         as acc_name,-- 交费账号名称
    m.acc_no          as acc_no,-- 交费账号
    m.acc_bank	          as acc_bank,-- 交费账户开户机构名称
    m.c_app_no  as receipt_no,-- 作业流水号,唯一标识号
    m.c_edr_no as endorse_no,-- 批单号
    '20191013000000' pt
from x_rpt_fxq_tb_ins_rpol_gpol m
	inner join edw_cust_ply_party partition(pt20191013000000) a on m.c_ply_no=a.c_ply_no and a.c_biz_type in (21, 22)
	inner join ods_cthx_web_bas_edr_rsn   partition(pt20191013000000) e on m.c_edr_rsn_bundle_cde=e.c_rsn_cde and substr(m.c_prod_no,1,2)=e.c_kind_no
	inner join ods_cthx_web_prd_prod partition(pt20191013000000) p on m.c_prod_no=p.c_prod_no
	left join rpt_fxq_tb_company_ms partition (pt20191013000000) co on co.company_code1 = m.c_dpt_cde
where e.c_rsn_cde in ('07') and m.t_next_edr_bgn_tm > now() 
	-- and m.t_edr_bgn_tm between {lastday} and {lastday}

-- 本表数据范围为检查业务期限内，检查对象办理的所有的增加或追加保费、保额业务保单信息    