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

macro.txt
{lastday} lastday
{startday} startday
{firstday} firstday

while read c1 c2
do
  echo $c1+'替换为'+$c2
  sed -i "s/$c1/$c2/g"  input.txt
done < macro.txt

# sed -i.bak "s/{lastday}/20190808/g" demo.sql 
# echo ALTER TABLE edw_cust_pers_info  ADD PARTITION (PARTITION pt20190808000000 VALUES LESS THAN ('20190808999999'));
# echo mysql -utaipingbi_etl -pTpstic123456 -Dtpedw -hrm-bp19v63q682asdrja.mysql.rds.aliyuncs.com -A

# select 
#  partition_name part,  
#  partition_expression expr,  
#  partition_description descr,  
#  table_rows, table_name
#  , concat('alter table ', table_name, ' drop partition   ', partition_name, ';') drop_part
#  , concat('alter table ', table_name, ' add partition  (partition pt', date_format(now(),'%Y%m%d'),'000000 values less than (''', date_format(now(),'%Y%m%d'),'999999'')) ', ';') add_part
#from information_schema.partitions  where 
#  table_schema = schema()  and table_name like 'rpt_fxq%'

#  excel: =CONCATENATE("sed ""s/{lastday}/$lastday/g"" ",C3," > work/",C3)

echo '请输入分区日期?'
read lastday 

export lastday=20190903
ll *.sql | awk '{print "sed \"s/{lastday}/'\$lastday'/g\" " $9 ">z_" $9}'

ll *.sql | awk '{print$9}' | gawk -F"." '{print"sed \"s/{lastday}/'\$lastday'/g\" " $1"."$2">"$1".txt"}'

mysql -utaipingbi_etl -pTpstic123456 -Dtpedw -hrm-bp19v63q682asdrja.mysql.rds.aliyuncs.com -A < edw_cust_pers_info.n.sql
mysql -utaipingbi_etl -pTpstic123456 -Dtpedw -hrm-bp19v63q682asdrja.mysql.rds.aliyuncs.com -A < edw_cust_units_info.n.sql
mysql -utaipingbi_etl -pTpstic123456 -Dtpedw -hrm-bp19v63q682asdrja.mysql.rds.aliyuncs.com -A < edw_cust_ply_partycd .n.sql

echo "first step"
sed "s/{lastday}/$lastday/g" 21edw_cust_ply_party.sql>work/21edw_cust_ply_party.sql
sed "s/{lastday}/$lastday/g" 22edw_cust_pers_info.sql>work/22edw_cust_pers_info.sql
sed "s/{lastday}/$lastday/g" 23edw_cust_units_info.sql>work/23edw_cust_units_info.sql
sed "s/{lastday}/$lastday/g" 24edw_cust_ply_party_applicant.sql>work/24edw_cust_ply_party_applicant.sql
sed "s/{lastday}/$lastday/g" 25edw_cust_ply_party_insured.sql>work/25edw_cust_ply_party_insured.sql
sed "s/{lastday}/$lastday/g" 26edw_cust_ply_party_bnfc.sql>work/26edw_cust_ply_party_bnfc.sql

source work/edw_cust_pers_info.sql;
source work/edw_cust_units_info.sql;
source work/edw_cust_ply_party.sql;
source work/edw_cust_ply_party_applicant.sql;
source work/edw_cust_ply_party_bnfc.sql;
source work/edw_cust_ply_party_insured.sql;

echo "second step"
sed "s/{lastday}/$lastday/g" 31rpt_fxq_tb_amltp_entity.sql>work/31rpt_fxq_tb_amltp_entity.sql
sed "s/{lastday}/$lastday/g" 32rpt_fxq_tb_amltp_score.sql>work/32rpt_fxq_tb_amltp_score.sql
sed "s/{lastday}/$lastday/g" 33rpt_fxq_tb_amltp_risk.sql>work/33rpt_fxq_tb_amltp_risk.sql

source work/31rpt_fxq_tb_amltp_entity.sql;
source work/32rpt_fxq_tb_amltp_score.sql;
source work/33rpt_fxq_tb_amltp_risk.sql;

echo "third step"

sed "s/{lastday}/$lastday/g" 01rpt_fxq_tb_company_ms.sql>work/01rpt_fxq_tb_company_ms.sql
sed "s/{lastday}/$lastday/g" 02rpt_fxq_tb_ins_rtype_ms.sql>work/02rpt_fxq_tb_ins_rtype_ms.sql
sed "s/{lastday}/$lastday/g" 03rpt_fxq_tb_ins_pers_ms.sql>work/03rpt_fxq_tb_ins_pers_ms.sql
sed "s/{lastday}/$lastday/g" 04rpt_fxq_tb_ins_units_ms.sql>work/04rpt_fxq_tb_ins_units_ms.sql
sed "s/{lastday}/$lastday/g" 05rpt_fxq_tb_ins_bo_ms.sql>work/05rpt_fxq_tb_ins_bo_ms.sql

source work/01rpt_fxq_tb_company_ms.sql
source work/02rpt_fxq_tb_ins_rtype_ms.sql

source work/03rpt_fxq_tb_ins_pers_ms.sql;
source work/04rpt_fxq_tb_ins_units_ms.sql;
source work/05rpt_fxq_tb_ins_bo_ms.sql;

echo "fourth"
sed "s/{lastday}/$lastday/g" 06rpt_fxq_tb_ins_rpol_ms.sql>work/06rpt_fxq_tb_ins_rpol_ms.sql

echo "inner join slowly"
source work/06rpt_fxq_tb_ins_rpol_ms.sql

sed "s/{lastday}/$lastday/g" 06rpt_fxq_tb_ins_rpol_ms.sql>work/06rpt_fxq_tb_ins_rpol_ms.sql


sed "s/{lastday}/$lastday/g" 07rpt_fxq_tb_ins_gpol_ms.sql>work/07rpt_fxq_tb_ins_gpol_ms.sql

sed "s/{lastday}/$lastday/g" 08rpt_fxq_tb_ins_fav_cst_ms.sql>work/08rpt_fxq_tb_ins_fav_cst_ms.sql
sed "s/{lastday}/$lastday/g" 09rpt_fxq_tb_ins_renewal_ms.sql>work/09rpt_fxq_tb_ins_renewal_ms.sql
sed "s/{lastday}/$lastday/g" 10rpt_fxq_tb_ins_rsur_ms.sql>work/10rpt_fxq_tb_ins_rsur_ms.sql
sed "s/{lastday}/$lastday/g" 11rpt_fxq_tb_ins_rpay_ms.sql>work/11rpt_fxq_tb_ins_rpay_ms.sql
sed "s/{lastday}/$lastday/g" 12rpt_fxq_tb_ins_rcla_ms.sql>work/12rpt_fxq_tb_ins_rcla_ms.sql
sed "s/{lastday}/$lastday/g" 13rpt_fxq_tb_ins_rchg_ms.sql>work/13rpt_fxq_tb_ins_rchg_ms.sql

source work/07rpt_fxq_tb_ins_gpol_ms.sql;
source work/08rpt_fxq_tb_ins_fav_cst_ms.sql;
source work/09rpt_fxq_tb_ins_renewal_ms.sql;
source work/10rpt_fxq_tb_ins_rsur_ms.sql;
source work/11rpt_fxq_tb_ins_rpay_ms.sql;
source work/12rpt_fxq_tb_ins_rcla_ms.sql;
source work/13rpt_fxq_tb_ins_rchg_ms.sql;

sed "s/{lastday}/$lastday/g" 14rpt_fxq_tb_ins_risk_new_ms.sql>work/14rpt_fxq_tb_ins_risk_new_ms.sql
sed "s/{lastday}/$lastday/g" 15rpt_fxq_tb_ins_risk_ms.sql>work/15rpt_fxq_tb_ins_risk_ms.sql
sed "s/{lastday}/$lastday/g" 16rpt_fxq_tb_lar_report_ms.sql>work/16rpt_fxq_tb_lar_report_ms.sql
sed "s/{lastday}/$lastday/g" 17rpt_fxq_tb_sus_report_ms.sql>work/17rpt_fxq_tb_sus_report_ms.sql

sed -e's/{firstday}/firstday/g;s/{lastday}/lastday/g;s/{lastday}/lastday/g' mysqlscript.sql > mysqlscript.txt


source work/14rpt_fxq_tb_ins_risk_new_ms.sql;
source work/15rpt_fxq_tb_ins_risk_ms.sql;
source work/16rpt_fxq_tb_lar_report_ms.sql;

 mysql -uroot -pgemini -Dtpedw< 06rpt_fxq_tb_ins_rpol_ms.sql 

select 
        table_name, ordinal_position, column_name, column_type, column_default, is_nullable, column_comment
from  information_schema.columns
where TABLE_SCHEMA like '%tpedw%' and table_name in('ods_cthx_web_app_grp_member','ods_cthx_web_ply_base','ods_cthx_web_clm_bank','ods_cthx_web_clm_main','ods_cthx_web_clm_rpt','ods_cthx_web_clmnv_endcase','ods_cthx_web_org_dpt','ods_cthx_web_org_dpt_map','ods_cthx_web_ply_applicant','ods_cthx_web_ply_bnfc','ods_cthx_web_app_insured','ods_cthx_web_ply_ent_tgt','ods_cthx_web_prd_kind','ods_cthx_web_prd_prod','ods_cthx_web_cus_cha','ods_amltp_t_sus_customer','ods_amltp_t_lat_data','ods_cthx_web_bas_edr_rsn','ods_cthx_web_fin_cav_doc','ods_amltp_t_sus_trans','ods_amltp_t_dict','ods_amltp_t_sco','ods_amltp_t_ih_tsdt','ods_amltp_t_is_bnif','ods_amltp_t_score','ods_amltp_t_sus_data','ods_amltp_t_is_iabi','ods_amltp_t_lat_customer','ods_amltp_t_sus_contract','ods_cthx_web_fin_cav_mny','ods_cthx_web_fin_prm_due','ods_cthx_web_fin_pay_due','ods_cthx_web_fin_clm_due','ods_cthx_web_clm_accdnt')
        order by table_name, ordinal_position