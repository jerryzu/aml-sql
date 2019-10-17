-- *********************************************************************************
--  文件名称: 06rpt_fxq_tb_ins_rpol_ms.sql
--  所属主题: 理赔
--  功能描述: 从 ods_cthx_web_ply_base
--  ods_cthx_web_app_insured
--  edw_cust_ply_party_applicant
--  edw_cust_ply_party_insured   
--  edw_cust_ply_party_bnfc
--  rpt_fxq_tb_company_ms
--  ods_cthx_web_fin_prm_due
--  ods_cthx_web_fin_cav_mny 表提取数据
--            导入到 理赔案件表(rpt_fxq_tb_ins_rpol_ms) 表
--  创建者: yhwang
--  输入: ods_cthx_web_ply_base
--  ods_cthx_web_app_insured
--  edw_cust_ply_party_applicant
--  edw_cust_ply_party_insured   
--  edw_cust_ply_party_bnfc
--  rpt_fxq_tb_company_ms
--  ods_cthx_web_fin_prm_due
--  ods_cthx_web_fin_cav_mny 
--  输出: rpt_fxq_tb_ins_rpol_ms 
--  创建日期: 2017/6/7
--  修改日志: 
--  修改日期: 
--  修改人: 
--  修改内容：

alter table rpt_fxq_tb_ins_rpol_ms truncate partition pt{lastday}000000;

INSERT INTO rpt_fxq_tb_ins_rpol_ms(
        company_code1,
        company_code2,
        company_code3,
        pol_no,
        app_no,
        ins_state,
        sale_type,
        sale_name,
        ins_date,
        eff_date,
        app_name,
        app_cst_no,
        app_id_type,
        app_id_no,
        ins_name,
        ins_cst_no,
        ins_id_no,
        ins_cus_pro,
        relation,
        legal_type,
        benefit_cus_pro,
        benefit_name,
        benefit_cst_no,
        benefit_id_no,
        ins_no,
        cur_code,
        pre_amt,
        usd_amt,
        prof_type,
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
select 
        a.c_dpt_cde as company_codel,-- 机构网点代码
        co.company_code2 as company_code2, -- 金融机构编码，人行科技司制定的14位金融标准化编码  暂时取“监管机构码，机构外部码，列为空”
        a.c_dpt_cde as company_code3,-- 保单归属机构网点代码
        a.c_ply_no as  pol_no,-- 保单号
        a.c_app_no as app_no,-- 投保单号
        case when a.c_edr_type in ('2','3') or a.t_insrnc_bgn_tm > str_to_date('{lastday}', '%y%m%d') or a.t_insrnc_end_tm < str_to_date('{lastday}', '%y%m%d') ) then 12 else 11 end as ins_state,-- 保单状态 --edr_type in ('2','3') or  T_INSRNC_END_TM<=date then 终止 else 有效
		case a.c_cha_subtype 
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
		end end as sale_type,-- 销售渠道
        -- 个人代理：为代理人名称；银保通代理点：**银行**分行等
		/* 销售渠道名称 unpass*/   -- 对应Sale_type销售渠道填写。如销售渠道为"个人代理", 则本字段填写为个人代理人名称(如"张**"); 销售渠道为"银保通代理点", 则本字段填写为"**银行**分行, 等。
        (select c_cha_nme from ods_cthx_web_cus_cha partition(pt{lastday}000000)  v where v.c_cha_cde = a.c_brkr_cde) as sale_name,-- 销售渠道名称
        date_format(a.t_app_tm,'%Y%m%d') as ins_date,-- 投保日期
        date_format(a.t_insrnc_bgn_tm,'%Y%m%d') as eff_date,-- 合同生效日期
        a1.c_applicant_name as app_name,-- 投保人名称
        a1.c_cst_no as app_cst_no,-- 投保人客户号
		/* 投保人证件种类 unpass*/  -- 11: 居民身份证或临时身份证; 12: 军人或武警身份证件; 13: 港澳居民来往内地通行证, 台湾居民来往大陆通行证或其他有效旅行证件; 14、港澳台居民居住证; 15: 外国公民护照; 18: 其他类个人身份证件填写数字。
        case a1.c_cert_cls
        when  '120001' then 11 -- 居民身份证
        when  '120002' then 13 -- 护照
        when  '120003' then 12 -- 军人证
        when  '120004' then 13 -- 回乡证
        when  '120005' then 14 -- 港澳居民居住证
        when  '120006' then 14 -- 台湾居民居住证
        when  '120009' then 18 -- 其它
        else 
        18 -- 其它
        end as app_id_type,-- 投保人身份证件类型
        a1.c_cert_cde as app_id_no,-- 投保人证件号码
        i.c_insured_name as ins_name,-- 被保险人名称
        i.c_cst_no as ins_cst_no,-- 被保险人客户号
		/* 被保险人证件号码 unpass*/  -- 个人填写身份证件号码, 单位按表4License字段要求填写。
        i.c_cert_cde as ins_id_no,-- 被保险人证件号码
		/* 被保险人客户类型 unpass*/   -- 11: 个人; 12: 单位客户。填写数字。
		case i.c_clnt_mrk
        when '1' then '11' -- 11:个人
        when '0' then '12' -- 12:单位
        else 
        null-- 其它
        end	as ins_cus_pro,-- 被保险人客户类型 11:个人;12:单位
        case id.c_app_relation 
        -- select concat('when ''', c_cde, ''' then '' '' -- ',  c_cnm) from ods_cthx_web_bas_comm_code partition(pt{lastday}000000) where c_par_cde = '601' order by c_cde 
        -- 11: 本人； 12：配偶； 13：父母； 14：子女 15：其他近亲属 16 雇佣或劳务 17：其他  --tb_ins_rpay  tb_ins_rpol
        when '601001' then '12' -- 配偶
        when '601002' then '13' -- 父母
        when '601003' then '14' -- 子女
        when '601004' then '17' -- 兄弟姐妹
        when '601005' then '11' -- 本人
        when '601006' then '17' -- 雇主
        when '601007' then '16' -- 雇员
        when '601008' then '17' -- 祖父母、外祖父母
        when '601009' then '17' -- 祖孙、外祖孙
        when '601010' then '17' -- 监护人
        when '601011' then '17' -- 被监护人
        when '601012' then '17' -- 朋友
        when '601013' then '17' -- 未知
        when '601014' then '17' -- 其他
        else
        '@N' -- 其它
        end as relation,-- 投保人、被保险人之间的关系
		/* 受益人标识 unpass*/  -- 11: 法定受益人; 12: 指定受益人填写数字。
        '' as legal_type,-- 受益人标识  11:法定受益人;12:制定受益人;
		/* 受益人类型 unpass*/  -- 11: 个人; 12: 单位客户受益人标识为法定受益人的一人或若干人时, 不填写本字段, 下同。填写数字。
        '' as benefit_cus_pro,-- 受益人类型 11:个人;12:单位客户;受益人为法定受益人的一人或若干人时不填写本字段
        b.c_bnfc_name as  benefit_name,-- 受益人名称 受益人为法定受益人的一人或若干人时不填写本字段
        b.c_cst_no as  benefit_cst_no,-- 受益人客户号
        b.c_cert_cde as benefit_id_no,-- 受益人身份证号码
        a.c_prod_no as ins_no,-- 险种代码 
        /*SELECT C_PAR_CDE, C_CDE, C_CNM FROM ods_cthx_web_bas_codelist WHERE C_PAR_CDE = 'M03' */
        case a.c_prm_cur 
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
        end as cur_code,-- 币种
        a.n_prm as pre_amt,-- 本期交保费金额
        null as usd_amt,-- 折合美元金额
        /* case c.c_kind_no
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
		end */ 
        12 as  prof_type,-- 业务种类 11:人身保险;12:财产保险;
        11 as del_way,-- 交费方式 -- 11:趸交;12:期缴;13:不定期缴
        14 as del_period,-- 缴费间隔 -- 11:年缴;12:季缴;13:月缴;14:其他;
        1 as `limit`,-- 交费期数  趸交为1;终身缴费填写9999.填写实际期数.
		/* 保险标的物 unpass */  -- 本字段适用财产保险, 填写具体的保险标的物名称, 如车牌号码; 无法明确指向保险标的统一填写替代符"@N"
        '' as subject,-- 保险标的物
        -- 修改成从资金系统取以下数据
		/* 现转标识 unpass*/  -- 10: 现金交保险公司; 11: 转账; 12: 现金缴款单(指客户向银行缴纳现金, 凭借银行开具的单据向保险机构办理交费业务); 13: 保险公司业务员代付。网银转账、银行柜面转账、POS刷卡、直接转账给总公司账户等情形, 应标识为转账。填写数字。
        '' as tsf_flag,-- d.c_pay_mde_cde  as tsf_flag,-- 现转标识 --  SELECT C_CDE, C_CNM, 'codeKind' FROM  ods_cthx_WEB_BAS_CODELIST PARTITION(pt20190818000000)   WHERE C_PAR_CDE = 'shoufeifangshi' ORDER BY C_CDE ;
    	mny.c_payer_nme         as acc_name,-- 交费账号名称
    	mny.c_savecash_bank          as acc_no,-- 交费账号
    	mny.c_bank_nme	          as acc_bank,-- 交费账户开户机构名称
    	a.c_app_no  as receipt_no,-- 作业流水号,唯一标识号
        '{lastday}000000'		pt
from ods_cthx_web_ply_base partition(pt{lastday}000000)  a
        inner join ods_cthx_web_app_insured partition(pt{lastday}000000)  id on a.c_app_no=id.c_app_no
        inner join edw_cust_ply_party_applicant   partition(pt{lastday}000000) a1 on a.c_ply_no =a1.c_ply_no and a1.c_biz_type = 21  -- 10: 收款人, 21: 投保人, 22: 法人投保人, 31:被保人, 32:法人被保人, 33: 团单被保人，41: 受益人, 42: 法人受益人, 43: 团单受益人
        inner join edw_cust_ply_party_insured   partition(pt{lastday}000000) i on a.c_ply_no =i.c_ply_no and i.c_biz_type = 31  -- 10: 收款人, 21: 投保人, 22: 法人投保人, 31:被保人, 32:法人被保人, 33: 团单被保人，41: 受益人, 42: 法人受益人, 43: 团单受益人        
        left join edw_cust_ply_party_bnfc   partition(pt{lastday}000000) b on a.c_ply_no =b.c_ply_no and b.c_biz_type in (41, 43)  -- 10: 收款人, 21: 投保人, 22: 法人投保人, 31:被保人, 32:法人被保人, 33: 团单被保人，41: 受益人, 42: 法人受益人, 43: 团单受益人
        inner join  rpt_fxq_tb_company_ms partition (pt{lastday}000000) co on co.company_code1 = a.c_dpt_cde
    	inner join ods_cthx_web_fin_prm_due partition(pt{lastday}000000) due on a.c_ply_no = due.c_ply_no
    	inner join ods_cthx_web_fin_cav_mny partition(pt{lastday}000000) mny on due.c_cav_no = mny.c_cav_pk_id
where a.t_next_edr_bgn_tm > now() 