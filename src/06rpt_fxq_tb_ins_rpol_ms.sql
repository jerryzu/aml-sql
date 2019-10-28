alter table rpt_fxq_tb_ins_rpol_ms truncate partition pt20191013000000;

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
        m.c_dpt_cde as company_codel,-- 机构网点代码
        co.company_code2 as company_code2, -- 金融机构编码，人行科技司制定的14位金融标准化编码  暂时取“监管机构码，机构外部码，列为空”
        m.c_dpt_cde as company_code3,-- 保单归属机构网点代码
        m.c_ply_no as  pol_no,-- 保单号
        m.c_app_no as app_no,-- 投保单号
        case when m.c_edr_type in ('2','3') or m.t_insrnc_bgn_tm > str_to_date('20191013', '%Y%m%d') or m.t_insrnc_end_tm < str_to_date('20191013', '%Y%m%d') then 12 else 11 end as ins_state,-- 保单状态 --edr_type in ('2','3') or  T_INSRNC_END_TM<=date then 终止 else 有效
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
		end as sale_type,-- 销售渠道
        -- 个人代理：为代理人名称；银保通代理点：**银行**分行等
		/* 销售渠道名称 unpass*/   -- 对应Sale_type销售渠道填写。如销售渠道为"个人代理", 则本字段填写为个人代理人名称(如"张**"); 销售渠道为"银保通代理点", 则本字段填写为"**银行**分行, 等。
        (select c_cha_nme from ods_cthx_web_cus_cha partition(pt20191013000000)  v where v.c_cha_cde = m.c_brkr_cde) as sale_name,-- 销售渠道名称
        date_format(m.t_app_tm,'%Y%m%d') as ins_date,-- 投保日期
        date_format(m.t_insrnc_bgn_tm,'%Y%m%d') as eff_date,-- 合同生效日期
        a.c_acc_name as app_name,-- 投保人名称
        a.c_cst_no as app_cst_no,-- 投保人客户号
		/* 投保人证件种类 unpass*/  -- 11: 居民身份证或临时身份证; 12: 军人或武警身份证件; 13: 港澳居民来往内地通行证, 台湾居民来往大陆通行证或其他有效旅行证件; 14、港澳台居民居住证; 15: 外国公民护照; 18: 其他类个人身份证件填写数字。
        case a.c_cert_cls
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
        a.c_cert_cde as app_id_no,-- 投保人证件号码
        i.c_ins_name as ins_name,-- 被保险人名称
        i.c_ins_no as ins_cst_no,-- 被保险人客户号
		/* 被保险人证件号码 unpass*/  -- 个人填写身份证件号码, 单位按表4License字段要求填写。
        i.c_ins_cert_cde as ins_id_no,-- 被保险人证件号码
		/* 被保险人客户类型 unpass*/   -- 11: 个人; 12: 单位客户。填写数字。
		case i.c_ins_clnt_mrk
        when '1' then '11' -- 11:个人
        when '0' then '12' -- 12:单位
        else 
        null-- 其它
        end	as ins_cus_pro,-- 被保险人客户类型 11:个人;12:单位
        case a.c_app_ins_rel 
        -- select concat('when ''', c_cde, ''' then '' '' -- ',  c_cnm) from web_bas_comm_code partition(pt20191013000000) where c_par_cde = '601' order by c_cde 
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
        i.c_bnfc_clnt_mrk as benefit_cus_pro,-- 受益人类型 11:个人;12:单位客户;受益人为法定受益人的一人或若干人时不填写本字段
        i.c_bnfc_name as  benefit_name,-- 受益人名称 受益人为法定受益人的一人或若干人时不填写本字段
        i.c_bnfc_no as  benefit_cst_no,-- 受益人客户号
        i.c_bnfc_cert_cde as benefit_id_no,-- 受益人身份证号码
        m.c_prod_no as ins_no,-- 险种代码 
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
        end as cur_code,-- 币种
        m.n_prm as pre_amt,-- 本期交保费金额
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
        case m.c_pay_mde_cde when 5 then 11 else 10 end as tsf_flag,-- d.c_pay_mde_cde  as tsf_flag,-- 现转标识 --  SELECT C_CDE, C_CNM, 'codeKind' FROM  WEB_BAS_CODELIST PARTITION(pt20190818000000)   WHERE C_PAR_CDE = 'shoufeifangshi' ORDER BY C_CDE ;
    	m.acc_name         as acc_name,-- 交费账号名称
    	m.acc_no          as acc_no,-- 交费账号
    	m.acc_bank	          as acc_bank,-- 交费账户开户机构名称
    	m.c_app_no  as receipt_no,-- 作业流水号,唯一标识号
        '20191013000000'		pt
from x_rpt_fxq_tb_ins_rpol_gpol m
        inner join edw_cust_ply_party   partition(pt20191013000000) a on m.c_ply_no =a.c_ply_no and a.c_per_biztype = 21  -- 10: 收款人, 21: 投保人, 22: 法人投保人, 31:被保人, 32:法人被保人, 33: 团单被保人，41: 受益人, 42: 法人受益人, 43: 团单受益人
        inner join s_rpt_fxq_tb_ins_rpol_ms i on m.c_ply_no =i.c_ply_no --此表为被保人,受益人关系表
        inner join  rpt_fxq_tb_company_ms partition (pt20191013000000) co on co.company_code1 = m.c_dpt_cde
where m.t_next_edr_udr_tm > {endday} 
	and m.t_app_tm between {beginday} and {endday} 


--   3.指定受益人为法定受益人中的一人或若干人时，不填写本表受益人相关字段。  
--   4.单个被保险人涉及多个指定受益人（非法定受益人）的，合并生成一条记录，指定受益人的姓名、身份证件号码用半角隔开。  
--   5.对同一份保单、多个被保险人、每个被保险人涉及多个险种情形，每个险种单独生成一条记录。
-- 检查业务期限（投保日期和生效日期任一满足检查业务期限