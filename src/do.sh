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

source work/14rpt_fxq_tb_ins_risk_new_ms.sql;
source work/15rpt_fxq_tb_ins_risk_ms.sql;
source work/16rpt_fxq_tb_lar_report_ms.sql;