-- *********************************************************************************
--  文件名称: 17rpt_fxq_tb_sus_report_ms.sql
--  所属主题: 中国人民银行反洗钱执法检查数据提取接口
--  功能描述: 从 
--   表提取数据
--            导入到 (rpt_fxq_tb_sus_report_ms) 表
--  创建者:祖新合 
--  输入: 
--  ods_amltp_t_is_bnif
--  ods_amltp_t_is_iabi
--  ods_amltp_t_sus_contract
--  ods_amltp_t_sus_customer
--  ods_amltp_t_sus_data
--  ods_amltp_t_sus_trans
--  ods_cthx_web_prd_prod
--  输出:  rpt_fxq_tb_sus_report_ms
--  创建日期: 2019/10/30
--  修改日志: 
--  修改日期: 
--  修改人: 
--  修改内容：

alter table rpt_fxq_tb_sus_report_ms truncate partition pt20191013000000;

insert into rpt_fxq_tb_sus_report_ms(
    ricd,
    finc,
    senm,
    setp,
    seid,
    sevc,
    srnm,
    srit,
    srid,
    scnm,
    scit,
    scid,
    stnt,
    detr,
    torp,
    dorp,
    tptr,
    stcb,
    aosp,
    tosc,
    stcr,
    icnm,
    istp,
    isnm,
    isps,
    alnm,
    aitp,
    alid,
    altp,
    istn,
    iitp,
    isid,
    rltp,
    bnnm,
    bitp,
    bnid,
    isog,
    isat,
    isfe,
    ispt,
    ctes,
    tstm,
    trcd,
    ittp,
    crtp,
    crat,
    crdr,
    cstp,
    caoi,
    tcan,
    rotf,
    code,
    itnm,
    bntn,
    mirs,
    otpr,
    stnm,
    ocit,
    odrp,
    oitp,
    orit,
    orxn,
    rpnm,
    sctl,
    rpdt,
    sear,
    seei,
    setn,
    pt
)
select distinct
    'f1008933000019'	as ricd  --  	报告机构编码	人民银行发放的<金融机构代码证>上载明的金融机构代码 如果尚未取得金融机构代码,则经申请后由中国反洗钱监测分析中心分配报告机构编码
    ,'F1008933000019'	as finc  --  	金融机构代码	有金融机构代码的网点应使用金融机构代码,暂时没有该代码的网点可自行编制内部唯一代码,报告机构向反洗钱监测中心报送交易报告前,应先系统中报备其内部网点代码对照表,并在发生变化时及时更新
    ,sc2.real_name  as senm  --  	可疑主体姓名或名称	
    ,sc2.certi_type  as setp  --  	可疑主体身份证件或证明文件类型	需代码转换
    ,sc2.certi_code  as seid  --  	可疑主体证件号	
	/* 可疑主体职业(对私)或行业(对公) unpass*/   -- 1.可疑主体职业按照GB/T6565-2015职业分类与代码填写, 可根据实际情况填写可疑主体职业的"大类"、"中类"或"小类"; 2.可疑主体行业按照GB/T4754-2011国民经济行业分类与代码标准填写, 可根据实际情况填写可疑主体行业的"门类"、"大类"、"中类"或"小类"; 3.对于可疑主体处于失业、无业或离退休等情况, 填写"99999"
    ,null  as sevc --  	可疑主体职业(对私)或行业(对公)	
    ,sc2.crnm  as srnm  --  	可疑主体法定代表人姓名	
	/* 可疑主体法定代表人身份证件类型 unpass*/     -- 按照10.1节身份证件/证明文件代码表填写。
    ,sc2.crit  as srit  --  	可疑主体法定代表人身份证件类型
	/* 可疑主体法定代表人身份证件号码 unpass*/    -- 居民身份证号长度应为15位或者18位。	
    ,sc2.crid  as srid  --  	可疑主体法定代表人身份证件号码	
    ,null  as scnm  --  	可疑主体控股股东或实际控制人名称	
	/* 可疑主体控股股东或实际控制人身份证件或证明文件类型 unpass*/    -- 按照10.1节身份证件/证明文件代码表填写。
    ,null  as scit  --  	可疑主体控股股东或实际控制人身份证件类型	
	/* 可疑主体控股股东或实际控制人身份证件或证明文件号码 unpass*/    -- 1.居民身份证号长度应为15位或者18位; 2.组织机构代码长度应为9位(如为10位则去掉最后一位校验码前的连接符"-")。
    ,null  as scid  --  	可疑主体控股股东或实际控制人身份证件号码	
    ,'CHN'  as stnt  --  	可疑主体国籍	
    ,'01'  as detr  --  	报告紧急程度	01:非特别紧急;02:特别紧急
    ,'1'  as torp  --  	报送次数标志	
    ,'04'  as dorp  --  	报送方向	 01:报告中国反洗钱监测分析中心;02:报告中国反洗钱监测分析中心和人民银行当地分支机构;03:报告中国反洗钱监测分析中心和当地公安机关;04:报告中国反洗钱监测分析中心和人民银行当地分支机构以及当地公安机关;99:报告中国反洗钱监测分析中心和其他机构
    ,'01'  as tptr  --  	可疑交易触发点	01:模型筛选;02:执法部门指令;03:监管部门指令;04:金融机构内部案件;05:社会舆情;06:金融机构从业人员发现的身份/行为等异常情况;99:其它
    ,sd.ssds as stcb  --  	资金交易及客户行为情况	
    ,sd.ssds as aosp  --  	疑点分析	
    ,'1402'  as tosc  --  	疑似涉罪类型	
    ,sd.stcr  as stcr  --  	可疑交易特征代码	截取开头代码
    ,sc.policy_no  as icnm  --  	保险合同号	
    ,sc.istp  as istp  --  	保险种类	01:人寿险;02:财产险;03:再保险;99:其它
    ,pd.c_nme_cn  as isnm  --  	保险名称		
	/* 保险期间 unpass*/    -- 以起始日期+终止日期的形式报送, 格式为"年年年年月月曰日年年年年月月日日"
    ,sc.isps  as isps  --  	保险期间	开始缴纳保险费的日期到终止缴纳保险费日期 以起始日期+终止日期的形式报送格式为年年年年月月日日年年年年月月日日
    ,sc.customer_name  as alnm  --  	投保人名称或姓名	
    ,sc.customer_certi_type  as aitp  --  	投保人身份证件或证明文件类型	
    ,sc.customer_certi_code  as alid  --  	投保人身份证件或证明文件号码	
    ,'05'	altp  --  	投保人类型	
    ,ii.istn  as istn  --  	被保险人名称或姓名	 若为空则取投保人信息
    ,ii.iitp  as iitp  --  	被保险人身份证件或证明文件类型	若为空则取投保人信息 
    ,ii.isid  as isid  --  	被保险人身份证件或证明文件号码	若为空则取投保人信息
    ,ii.rltp  as rltp  --  	投保人与被保险人之间的关系	对被报告保险合同中投保人与被保险人的关系进行描述,如:夫妻;父子等 若为空则默认其他
    ,bf.bnnm  as bnnm  --  	受益人名称或姓名
	/* 受益人身份证件或证明文件类型 unpass*/    -- 按照10.1节身份证件/证明文件代码表填写。
    ,bf.bitp  as bitp  --  	受益人身份证件或证明文件类型	

	/* 受益人身份证件或证明文件号码 unpass*/    -- 1.居民身份证号长度应为15位或者18位; 2.组织机构代码长度应为9位(如为10位则去掉最后一位校验码前的连接符"-")。
    ,bf.bnid  as bnid  --  	受益人身份证件或证明文件号码	
    ,sc.isog  as isog  --  	保险标的	
    ,sc.isat  as isat  --  	保险金额	
    ,sc.isfe  as isfe  --  	保险费	
    ,sc.ispt  as ispt  --  	交费方式	 01:期缴;02:趸缴;99其他
    ,sc.ctes  as ctes  --  	保险合同其他信息	
    ,date_format(sd.insert_time,'%Y%m%d%H%i%S')   as tstm  --  	交易时间	客户与保险公司发生资金收付时间 格式为年年年年月月日日时时分分秒秒
    ,'CHN330104'  as trcd  --  	交易发生地	默认中国杭州江干区
    ,st.trans_type  as ittp  --  	交易类型	01:投保;02:领取;03:退保;99:其他保全项目
    ,st.crtp  as crtp  --  	币种	 需转换,数据库存入为货币符号需转换为对应的三位货币代码
    ,st.amount  as crat  --  	交易金额	
    ,st.crdr  as crdr  --  	资金进出方向	01:收,资金账户转入资金;02:付,资金账户转出资金
    ,st.cstp  as cstp  --  	资金进出方式	01:现金;02:转账;99:其他
    ,'中国银行'	caoi  --  	资金账户开户行	交易的资金进出方式为转账时非保险人一方的银行开户行 默认中国银行
    ,st.caoi  as tcan  --  	银行转账资金账号	交易的资金进出方式为转账时非保险人一方的银行账号
    ,null  as rotf  --  	交易信息备注1	备用字段
    ,null  as code --  	每份可疑交易报告的唯一编号	只有报送才生成
    ,(select count(*) from ods_amltp_t_is_iabi t where t.icid = sc.policy_id)  as itnm  --  	被保险人总人数	请根据单据查询
    ,(select count(*)  from ods_amltp_t_is_bnif t  where t.ibid = ii.ibid)  as bntn  --  	受益人总人数	
    ,(select count(*) from ods_amltp_t_sus_trans t  where t.su_data_id = st.su_data_id)  as stnm  --  	可疑交易总数	
	/* 人工补正标识 unpass?*/    -- 1.对于应答人工补正通知的报文, 填写中国反洗钱监测分析中心下发的人工补正通知文件名; 2.对于其他用途的报文, 填写替代符"@N"
    ,null  as mirs  --  	人工补正标识	1.对于应答人工补正通知的报文,填写中国反洗钱中心下发的人工补正通知文件名,2对于其他用途的报文null
	/* 其他可疑交易报告触发点 unpass?*/    -- 如字段"可疑交易报告触发点(TPTR)"选择为"99", 本字段须填写可疑交易报告的具体触发点, 否则填写替代符"@N"
    ,null  as otpr  --  	其他可疑交易触发点	
	/* 可疑主体控股股东其他身份证件/证明文件类型 unpass*/    -- 如字段"可疑主体控股股东或实际控制人身份证件/证明文件类型(SCIT)"填写了119999、129999、619999或629999, 本字段须填写具体的身份证件/证明文件类型, 否则填写替代符"@N"
    ,null  as ocit  --  	可疑主体控股股东其他身份证件或证明文件	
	/* 其他报送方向 unpass*/    -- 如字段"报送方向(DORP)"选择为"99", 本字段须填写可疑交易报告的具体报送方向, 否则填写替代符"@N"
    ,null  as odrp  --  	其他报送方向	
	/* 其他身份证件/证明文件类型 unpass*/    -- 如下列字段填写了119999、129999、619999或629999, 本字段须填写具体的身份证件/证明文件类型, 否则填写替代符"@N": 1.客户身份证件/证明文件类型(CITP); 2.交易代办人身份证件/证明文件类型(TBIT); 3.交易对手身份证件/证明文件类型(TCIT); 4.可疑主体身份证件/证明文件类型(SETP); 5.投保人身份证件/证明文件类型(AITP); 6.被保险人身份证件/证明文件类型(IITP); 7.受益人身份证件/证明文件类型(BITP)。
    ,null  as oitp  --  	其他身份证件或证明文件类型	
	/* 可疑主体法定代表人其他身份证件/证明文件类型 unpass*/    -- 如字段"可疑主体法定代表人身份证件类型(SRIT)"填写了119999、129999、619999或629999, 本字段须填写具体的身份证件/证明文件类型, 否则填写替代符"@N"。
    ,sc2.crit  as orit  --  	可疑主体法定代表人其他身份证件或证明文件类型	身份证件类型为其他时填写否则null
	/* 初次报送的可疑交易报告报文名称 unpass*/    -- 即银发[2017]99号文中所指的"首次提交可疑交易报告号"。当字段"报送次数标志(TORP)"填写内容不为1时, 需要同时提供与该份报告相关联, 且"报送次数标志"为1的已正确入库的可疑交易报告报文名称(不加扩展名), 否则填写替代符"@N"。
    ,null  as orxn  --  	初次报送的可疑交易报告报文名称	
    ,'scott'  as rpnm  --  	可疑交易报告填报人员	
    ,sc2.tel  as sctl  --  	可疑主体联系电话	
    ,null	rpdt  --  	可疑交易报告报送时间	无法获取,可以获取下载时间 "select creat_date    from t_supkg_record a   where a.file_name like '%IS%' and trunc(a.creat_date) = trunc(sysdate) and file_name =? 报送包名"
    ,sc2.address  as sear  --  	可疑主体住址/经营地址	
    ,null  as seei  --  	可疑主体其他联系方式	无此字段
    ,(select count(*) from ods_amltp_t_sus_customer t  where t.su_data_id = sc2.su_data_id)  as setn  --  	可疑主体总数
    ,'20191013000000' pt	--	分区字段	
from ods_amltp_t_is_bnif  partition(pt20191013000000)  bf
    left join ods_amltp_t_is_iabi	 partition(pt20191013000000)  ii on bf.ibid = ii.ibid    
    left join ods_amltp_t_sus_contract  partition(pt20191013000000)  sc on 	ii.icid = sc.policy_id
    left join ods_amltp_t_sus_customer  partition(pt20191013000000)  sc2 on 	sc.su_data_id = sc2.su_data_id
    left join ods_amltp_t_sus_data  partition(pt20191013000000)  sd on 	sc.su_data_id = sd.su_data_id
    left join ods_amltp_t_sus_trans  partition(pt20191013000000)  st on 	sc.su_data_id = st.su_data_id
    left join ods_cthx_web_prd_prod  partition(pt20191013000000)  pd on sc.product_id = pd.c_prod_no;