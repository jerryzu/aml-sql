tb_ins_pers:受益人适用人身保险业务，财产保险业务无需提取
tb_ins_unit：受益人适用人身保险业务，财产保险业务无需提取
tb_ins_bo：受益所有人身份信息记录清单投保人、被保险人或受益人为非自然人的受益所有人信息。每个受益所有人增加一条记录
tb_ins_rpol: 指定受益人为法定受益人中的一人或若干人时不报

05rpt_fxq_tb_ins_bo_ms投保，被保，受益人是非自然人的？？？？？
1.投保人->受益人关系
2.被保人->受益人关系
3.受益人

06rpt_fxq_tb_ins_rpol_ms
1.投保自然人 
    被保险人->受益人关系
        指定受益人为法定受益人中的一人或若干人时，不填写本表受益人相关字段
        单个被保险人涉及多个指定受益人（非法定受益人）的，合并生成一条记录，指定受益人的姓名、身份证件号码用半角隔开
        对同一份保单、多个被保险人、每个被保险人涉及多个险种情形，每个险种单独生成一条记录

07rpt_fxq_tb_ins_gpol_ms
无人员关系处理
1.投保非自然人  
--      以及（2）表九、十一、十二业务中投保人为非自然人的保单信息（如某份保单在检查期内发生了多次涉及表九、十一、十二的业务，只需要数据提取当日的保单信息即可），如同一份保单同时符合（1）和（2）的条件，则分别提取多条记录。  
--   2.本表保单涉及的被保险人、受益人相关信息在表八中单列。
保单数据，与业务数据(表九，十一，十二)[每类业务数据发生了多次只提取当日]

08rpt_fxq_tb_ins_fav_cst_ms
1.投保人->被保险人关系
2.投保人->受益人关系

提取表七涉及的保单对应的被保险人、受益人信息，按被保险人、受益人分别增加记录；如一份保单存在多个被保险人或受益人的，需逐条增加记录。

12rpt_fxq_tb_ins_rcla_ms
1.投保人->被保险人->受益人->理赔申请人->实际领款人的关系

本表数据范围为检查业务期限内，检查对象所有理赔信息，每一笔理赔支付业务生成一条完整的记录，一份赔案涉及多个受益人或实际收款人的，相应生成多条记录。  
--   2.理赔日期为实际资金交易日期。

暂定保单发生业务时间为批改时间t_edr_bgn_tm
保单有效时间为：投保日期和生效日期任一满足检查业务期限
	, a.t_insrnc_bgn_tm -- 合同生效日期
	, a.t_app_tm  -- 投保日期
	, a.t_insrnc_end_tm

	, a.t_edr_app_tm -- 申请日期
	, a.t_edr_bgn_tm -- 变更或批改日期
	, a.t_next_edr_bgn_tm
        , a.t_udr_tm  -- 核保日期


svn cat --username zuxh --password zuxh svn://10.19.0.22/edw/08src/alidata/edwproject/taskfile/sql/cdm_fin_pay_dd.sql > cdm_fin_pay_dd.sql
svn cat --username zuxh --password zuxh svn://10.19.0.22/edw/08src/alidata/edwproject/taskfile/sql/cdm_fin_prm_dd.sql > cdm_fin_prm_dd.sql
svn cat --username zuxh --password zuxh svn://10.19.0.22/edw/08src/alidata/edwproject/taskfile/sql/cdm_fin_clm_dd.sql > cdm_fin_clm_dd.sql
svn cat --username zuxh --password zuxh svn://10.19.0.22/edw/08src/alidata/edwproject/taskfile/sql/adm_stat_financial_exp_ms.sql > adm_stat_financial_exp_ms.sql
ls cdm_fin_pay_dd.sql cdm_fin_prm_dd.sql adm_stat_financial_exp_ms.sql cdm_fin_clm_dd.sql

2.清除本地缓存帐号信息
rm -rf ~/.subversion/auth

alter table ods_cthx_web_clm_accdnt  reorganize partition pt20191024000000 into (partition pt20191013000000 values less than('20191013999999'), partition pt20191024000000 values less than('20191024999999')); 

SELECT @@innodb_buffer_pool_size;
SET GLOBAL innodb_buffer_pool_size=402653184;
 SELECT @@innodb_io_capacity_max;
SET GLOBAL innodb_io_capacity_max=6000;
 SELECT @@innodb_io_capacity;
SET GLOBAL innodb_io_capacity=2000;
