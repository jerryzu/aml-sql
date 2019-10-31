echo $(date +%F%n%T)
mysql -uroot -pgemini -Dtpedw< 20x_edw_cust_pers_units_info.sql 
echo $(date +%F%n%T)
mysql -uroot -pgemini -Dtpedw< 41x_rpt_fxq_tb_ins_rpol_gpol.sql 
echo $(date +%F%n%T)
mysql -uroot -pgemini -Dtpedw< 22edw_cust_pers_info.sql 
echo $(date +%F%n%T)
mysql -uroot -pgemini -Dtpedw< 23edw_cust_units_info.sql 
echo $(date +%F%n%T)
mysql -uroot -pgemini -Dtpedw< 21edw_cust_ply_party.sql 
echo $(date +%F%n%T)
mysql -uroot -pgemini -Dtpedw< 31rpt_fxq_tb_amltp_entity.sql 
echo $(date +%F%n%T)
mysql -uroot -pgemini -Dtpedw< 32rpt_fxq_tb_amltp_score.sql 
echo $(date +%F%n%T)
mysql -uroot -pgemini -Dtpedw< 33rpt_fxq_tb_amltp_risk.sql 
echo $(date +%F%n%T)
mysql -uroot -pgemini -Dtpedw< 14rpt_fxq_tb_ins_risk_new_ms.sql 
echo $(date +%F%n%T)
mysql -uroot -pgemini -Dtpedw< 15rpt_fxq_tb_ins_risk_ms.sql 
echo $(date +%F%n%T)
mysql -uroot -pgemini -Dtpedw< 16rpt_fxq_tb_lar_report_ms.sql 
echo $(date +%F%n%T)
mysql -uroot -pgemini -Dtpedw< 17rpt_fxq_tb_sus_report_ms.sql 
echo $(date +%F%n%T)
mysql -uroot -pgemini -Dtpedw< 03rpt_fxq_tb_ins_pers_ms.sql
echo $(date +%F%n%T)
mysql -uroot -pgemini -Dtpedw< 04rpt_fxq_tb_ins_units_ms.sql 
echo $(date +%F%n%T)
mysql -uroot -pgemini -Dtpedw< 06s_rpt_fxq_tb_ins_rpol_ms.sql 
echo $(date +%F%n%T)
mysql -uroot -pgemini -Dtpedw< 06rpt_fxq_tb_ins_rpol_ms.sql 
echo $(date +%F%n%T)
mysql -uroot -pgemini -Dtpedw< 07rpt_fxq_tb_ins_gpol_ms.sql 
echo $(date +%F%n%T)
mysql -uroot -pgemini -Dtpedw< 08rpt_fxq_tb_ins_fav_cst_ms.sql 
echo $(date +%F%n%T)
mysql -uroot -pgemini -Dtpedw< 09rpt_fxq_tb_ins_renewal_ms.sql 
echo $(date +%F%n%T)
mysql -uroot -pgemini -Dtpedw< 10rpt_fxq_tb_ins_rsur_ms.sql 
echo $(date +%F%n%T)
mysql -uroot -pgemini -Dtpedw< 12s_rpt_fxq_tb_ins_rcla_ms.sql
echo $(date +%F%n%T)
mysql -uroot -pgemini -Dtpedw< 13rpt_fxq_tb_ins_rchg_ms.sql 
echo $(date +%F%n%T)
