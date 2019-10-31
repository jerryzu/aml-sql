echo $(date +%F%n%T): [20x_edw_cust_pers_units_info]
mysql -utaipingbi_etl -pTpstic123456 -Dtpedw -hrm-bp19v63q682asdrja.mysql.rds.aliyuncs.com -A < 20x_edw_cust_pers_units_info.sql 
echo $(date +%F%n%T): [41x_rpt_fxq_tb_ins_rpol_gpol]
mysql -utaipingbi_etl -pTpstic123456 -Dtpedw -hrm-bp19v63q682asdrja.mysql.rds.aliyuncs.com -A < 41x_rpt_fxq_tb_ins_rpol_gpol.sql 
echo $(date +%F%n%T): [22edw_cust_pers_info]
mysql -utaipingbi_etl -pTpstic123456 -Dtpedw -hrm-bp19v63q682asdrja.mysql.rds.aliyuncs.com -A < 22edw_cust_pers_info.sql 
echo $(date +%F%n%T): [23edw_cust_units_info]
mysql -utaipingbi_etl -pTpstic123456 -Dtpedw -hrm-bp19v63q682asdrja.mysql.rds.aliyuncs.com -A < 23edw_cust_units_info.sql 
echo $(date +%F%n%T): [21edw_cust_ply_party]
mysql -utaipingbi_etl -pTpstic123456 -Dtpedw -hrm-bp19v63q682asdrja.mysql.rds.aliyuncs.com -A < 21edw_cust_ply_party.sql 
echo $(date +%F%n%T): [31rpt_fxq_tb_amltp_entity]
mysql -utaipingbi_etl -pTpstic123456 -Dtpedw -hrm-bp19v63q682asdrja.mysql.rds.aliyuncs.com -A < 31rpt_fxq_tb_amltp_entity.sql 
echo $(date +%F%n%T): [32rpt_fxq_tb_amltp_score]
mysql -utaipingbi_etl -pTpstic123456 -Dtpedw -hrm-bp19v63q682asdrja.mysql.rds.aliyuncs.com -A < 32rpt_fxq_tb_amltp_score.sql 
echo $(date +%F%n%T): [33rpt_fxq_tb_amltp_risk]
mysql -utaipingbi_etl -pTpstic123456 -Dtpedw -hrm-bp19v63q682asdrja.mysql.rds.aliyuncs.com -A < 33rpt_fxq_tb_amltp_risk.sql 
echo $(date +%F%n%T): [14rpt_fxq_tb_ins_risk_new_ms]
mysql -utaipingbi_etl -pTpstic123456 -Dtpedw -hrm-bp19v63q682asdrja.mysql.rds.aliyuncs.com -A < 14rpt_fxq_tb_ins_risk_new_ms.sql 
echo $(date +%F%n%T): [15rpt_fxq_tb_ins_risk_ms]
mysql -utaipingbi_etl -pTpstic123456 -Dtpedw -hrm-bp19v63q682asdrja.mysql.rds.aliyuncs.com -A < 15rpt_fxq_tb_ins_risk_ms.sql 
echo $(date +%F%n%T): [16rpt_fxq_tb_lar_report_ms]
mysql -utaipingbi_etl -pTpstic123456 -Dtpedw -hrm-bp19v63q682asdrja.mysql.rds.aliyuncs.com -A < 16rpt_fxq_tb_lar_report_ms.sql 
echo $(date +%F%n%T): [17rpt_fxq_tb_sus_report_ms]
mysql -utaipingbi_etl -pTpstic123456 -Dtpedw -hrm-bp19v63q682asdrja.mysql.rds.aliyuncs.com -A < 17rpt_fxq_tb_sus_report_ms.sql 
echo $(date +%F%n%T): [03rpt_fxq_tb_ins_pers_ms]
mysql -utaipingbi_etl -pTpstic123456 -Dtpedw -hrm-bp19v63q682asdrja.mysql.rds.aliyuncs.com -A < 03rpt_fxq_tb_ins_pers_ms.sql
echo $(date +%F%n%T): [04rpt_fxq_tb_ins_units_ms]
mysql -utaipingbi_etl -pTpstic123456 -Dtpedw -hrm-bp19v63q682asdrja.mysql.rds.aliyuncs.com -A < 04rpt_fxq_tb_ins_units_ms.sql 
echo $(date +%F%n%T): [06s_rpt_fxq_tb_ins_rpol_ms]
mysql -utaipingbi_etl -pTpstic123456 -Dtpedw -hrm-bp19v63q682asdrja.mysql.rds.aliyuncs.com -A < 06s_rpt_fxq_tb_ins_rpol_ms.sql 
echo $(date +%F%n%T): [06rpt_fxq_tb_ins_rpol_ms]
mysql -utaipingbi_etl -pTpstic123456 -Dtpedw -hrm-bp19v63q682asdrja.mysql.rds.aliyuncs.com -A < 06rpt_fxq_tb_ins_rpol_ms.sql 
echo $(date +%F%n%T): [07rpt_fxq_tb_ins_gpol_ms]
mysql -utaipingbi_etl -pTpstic123456 -Dtpedw -hrm-bp19v63q682asdrja.mysql.rds.aliyuncs.com -A < 07rpt_fxq_tb_ins_gpol_ms.sql 
echo $(date +%F%n%T): [08rpt_fxq_tb_ins_fav_cst_ms]
mysql -utaipingbi_etl -pTpstic123456 -Dtpedw -hrm-bp19v63q682asdrja.mysql.rds.aliyuncs.com -A < 08rpt_fxq_tb_ins_fav_cst_ms.sql 
echo $(date +%F%n%T): [09rpt_fxq_tb_ins_renewal_ms]
mysql -utaipingbi_etl -pTpstic123456 -Dtpedw -hrm-bp19v63q682asdrja.mysql.rds.aliyuncs.com -A < 09rpt_fxq_tb_ins_renewal_ms.sql 
echo $(date +%F%n%T): [10rpt_fxq_tb_ins_rsur_ms]
mysql -utaipingbi_etl -pTpstic123456 -Dtpedw -hrm-bp19v63q682asdrja.mysql.rds.aliyuncs.com -A < 10rpt_fxq_tb_ins_rsur_ms.sql 
echo $(date +%F%n%T): [12s_rpt_fxq_tb_ins_rcla_ms]
mysql -utaipingbi_etl -pTpstic123456 -Dtpedw -hrm-bp19v63q682asdrja.mysql.rds.aliyuncs.com -A < 12s_rpt_fxq_tb_ins_rcla_ms.sql
echo $(date +%F%n%T): [13rpt_fxq_tb_ins_rchg_ms]
mysql -utaipingbi_etl -pTpstic123456 -Dtpedw -hrm-bp19v63q682asdrja.mysql.rds.aliyuncs.com -A < 13rpt_fxq_tb_ins_rchg_ms.sql 
echo $(date +%F%n%T): [finish]
