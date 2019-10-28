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
--   1.本表数据范围为：  
--     （1 ）检查业务期限（投保日期和生效日期任一满足检查业务期限）内，检查对象承保的投保人为非自然人的所有保单信息；  
--      以及（2）表九、十一、十二业务中投保人为非自然人的保单信息（如某份保单在检查期内发生了多次涉及表九、十一、十二的业务，只需要数据提取当日的保单信息即可），如同一份保单同时符合（1）和（2）的条件，则分别提取多条记录。  
--   2.本表保单涉及的被保险人、受益人相关信息在表八中单列。

alter table rpt_fxq_tb_ins_gpol_ms truncate partition pt20191013000000;

INSERT INTO rpt_fxq_tb_ins_gpol_ms(
        company_code1,
        company_code2,
        company_code3,
        pol_no,
        app_no,
        ins_state,
        app_type,
        sale_type,
        sale_name,
        ins_date,
        eff_date,
        app_name,
        app_cst_no,
        app_id_type,
        app_id_no,
        state_owned,
        ins_num,
        ins_no,
        cur_code,
        pre_amt,
        usd_amt,
        del_way,
        del_period,
        `limit`,
        subject,
        tsf_flag,
        acc_name,
        acc_no,
        acc_bank,
        receipt_no,
        pt
)
SELECT
    m.c_dpt_cde                             as company_codel,-- 机构网点代码
    co.company_code2 as company_code2, -- 金融机构编码，人行科技司制定的14位金融标准化编码  暂时取“监管机构码，机构外部码，列为空”
    ''                                      as company_code3,-- 保单归属机构网点代码
    m.c_ply_no                              as pol_no,-- 保单号
    m.c_app_no                              as app_no,-- 投保单号
    case when m.c_edr_type in ('2','3') or m.t_insrnc_end_tm < now() then 11 else 12 end as ins_state,-- 保单状态 --edr_type in ('2','3') or  T_INSRNC_END_TM<=date then 终止 else 有效
    case m.c_grp_mrk when 0 then 11 when 1 then 12 end as app_type,-- 保单类型  (biz: 0 个单; 1 团单)11:非团险;12:团险
    case m.c_cha_subtype 
        -- 财产保险销售渠道:11:个人代理;12:保险代理机构或经济机构;13:银邮代理;14:网销(本机构);15:电销;16:农村网点;17:营业网点;18:第三方平台;19:其他;
        when '0A0' then 17	--	营业网点
        when '0B0' then 17	--	营业网点
        when '1A0' then 12	--	保险代理机构或经济机构
        when '2A0' then 11	--	个人代理
        when '3A1' then 12	--	保险代理机构或经济机构
        when '4J1' then 13	--	银邮代理
        when '5A1' then 12	--	保险代理机构或经济机构
        when '6A1' then 15	--	电销
        when '6A2' then 15	--	电销
        when '6B1' then 14	--	网销
        when '6B2' then 14	--	网销
        when '6C0' then 13	--	银邮代理
        when '6D0' then 18	--	第三方平台
        when '7A0' then 17	--	营业网点
    else
                19 -- 其他
    end  as sale_type,-- 销售渠道
    -- 个人代理：为代理人名称；银保通代理点：**银行**分行等
	/* 销售渠道名称 unpass*/   -- 对应Sale_type销售渠道填写。如销售渠道为"个人代理", 则本字段填写为个人代理人名称(如"张**"); 销售渠道为"银保通代理点", 则本字段填写为"**银行**分行"等。
    (select c_cha_nme from ods_cthx_web_cus_cha partition(pt20191013000000) v where v.c_cha_cde = m.c_brkr_cde) as sale_name,-- 销售渠道名称
    date_format(m.t_app_tm,'%Y%m%d')        as ins_date,-- 投保日期
    date_format(m.t_insrnc_bgn_tm,'%Y%m%d') as eff_date,-- 合同生效日期
    a.c_acc_name                            as app_name,-- 投保人名称
    a.c_cst_no                              as app_cst_no,-- 投保人客户号
	/* 投保人证件种类 unpass*/ -- 21: 营业执照(含社会统一信用代码证, 多证合一); 22: 其他填写数字。
    case a.c_cert_cls
    when '100111' then 11 -- 税务登记证
    when '100112' then 13 -- 统一社会信用代码
    when '110001' then 12 -- 组织机构代码
    when '110002' then 13 -- 工商注册号码
    when '110003' then 14 -- 营业执照
    else 18 -- 其它
    end           as app_id_type,-- 投保人证件种类(单位客户)
    a.c_cert_cde as app_id_no,-- 投保人证件号码(单位客户)
	/* 国有属性 unpass*/  -- 11: 国有企业; 12: 集体所有企业; 13: 联营企业; 14: 三资企业; 15: 私营企业; 16: 其他填写数字。
    ''            as state_owned,-- 国有属性(单位客户)
    v.ins_num     as ins_num,-- 被保险人数量
	/* 险种代码 unpass*/   -- 一份团险保单涉及多个险种的, 本字段填写"多个险种"如: tb_ins_rtype定义
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
	end as ins_no,-- 险种代码  case
    case m.c_prm_cur
    when '01' then 'CNY' -- 人民币
    when '02' then 'USD' -- 美元
    when '03' then 'HKD' -- 港币
    when '04' then 'CHF' -- 瑞士法郎
    when '05' then 'FF' -- 法国法郎
    when '06' then 'JPY' -- 日元
    when '07' then 'GBP' -- 英镑
    when '08' then 'EUR' -- 欧元
    when '09' then 'DM' -- 德国马克
    when '10' then 'SEK' -- 瑞典克朗
    else '@N' -- 其它     
    end      as ur_code,-- 币种
    m.n_prm  as pre_amt,-- 本期交保费金额
    -9999    as usd_amt,-- 折合美元金额
    11       as del_way,-- 交费方式 -- 11:趸交;12:期缴;13:不定期缴
    14       as del_period,-- 缴费间隔 -- 11:年缴;12:季缴;13:月缴;14:其他;
    1        as `limit`,-- 交费期数  趸交为1;终身缴费填写9999.填写实际期数.
	/* 保险标的物 ???为啥是地址 unpass */  -- 本字段适用财产保险, 填写具体的保险标的物名称, 如车牌号码; 无法明确指向保险标的统一填写替代符"@N"
    left(t.c_tgt_addr, 100) as subject,-- 保险标的物
	/* 现转标识 unpass*/  -- 10: 现金交保险公司; 11: 转账; 12: 现金缴款单(指客户向银行缴纳现金, 凭借银行开具的单据向保险机构办理交费业务); 13: 保险公司业务员代付。网银转账、银行柜面转账、POS刷卡、直接转账给总公司账户等情形, 应标识为转账。填写数字。
    case m.c_pay_mde_cde when 5 then 11 else 10 end as tsf_flag,-- d.c_pay_mde_cde  as tsf_flag,-- 现转标识 --  SELECT C_CDE, C_CNM, 'codeKind' FROM  WEB_BAS_CODELIST PARTITION(pt20190818000000)   WHERE C_PAR_CDE = 'shoufeifangshi' ORDER BY C_CDE ;
    m.acc_name         as acc_name,-- 交费账号名称
    m.acc_no          as acc_no,-- 交费账号
    m.acc_bank	          as acc_bank,-- 交费账户开户机构名称
    m.c_app_no  as receipt_no,-- 作业流水号,唯一标识号
    '20191013000000'    pt
from  x_rpt_fxq_tb_ins_rpol_gpol m
    inner join edw_cust_ply_party   partition(pt20191013000000) a on m.c_ply_no =a.c_ply_no and a.c_per_biztype = 22 -- 10: 收款人, 21: 投保人, 22: 法人投保人, 31:被保人, 32:法人被保人, 41: 受益人, 42: 法人受益人, 43: 间接受益人, 44: 法人间接受益人
    inner join ods_cthx_web_ply_ent_tgt partition(pt20191013000000) t
        on m.c_ply_no=t.c_ply_no
    inner join ods_cthx_web_prd_prod partition(pt20191013000000) p 
        on m.c_prod_no=p.c_prod_no
    inner join (select pi.c_ply_no, count(1) ins_num
        from  edw_cust_ply_party partition(pt20191013000000) pi 
        -- where pi.c_per_biztype =  32 -- 10: 收款人, 21: 投保人, 22: 法人投保人, 31:被保人, 32:法人被保人, 41: 受益人, 42: 法人受益人, 43: 间接受益人, 44: 法人间接受益人        
		group by pi.c_ply_no
		) v on m.c_ply_no = v.c_ply_no -- error
    inner join  rpt_fxq_tb_company_ms partition (pt20191013000000) co on co.company_code1 = m.c_dpt_cde
where m.t_next_edr_udr_tm > now() 
	-- and m.t_next_edr_udr_tm between {lastday} and {lastday}