[jerry@j src]$  mysql -uroot -pgemini -Dtpedw< 20x_edw_cust_pers_units_info.sql 
[jerry@j src]$  mysql -uroot -pgemini -Dtpedw< 41x_rpt_fxq_tb_ins_rpol_gpol.sql 
[jerry@j src]$  mysql -uroot -pgemini -Dtpedw< 22edw_cust_pers_info.sql 
[jerry@j src]$  mysql -uroot -pgemini -Dtpedw< 23edw_cust_units_info.sql 
[jerry@j src]$  mysql -uroot -pgemini -Dtpedw< 21edw_cust_ply_party.sql 
[jerry@j src]$  mysql -uroot -pgemini -Dtpedw< 31rpt_fxq_tb_amltp_entity.sql 
[jerry@j src]$  mysql -uroot -pgemini -Dtpedw< 32rpt_fxq_tb_amltp_score.sql 
[jerry@j src]$  mysql -uroot -pgemini -Dtpedw< 33rpt_fxq_tb_amltp_risk.sql 
[jerry@j src]$  mysql -uroot -pgemini -Dtpedw< 14rpt_fxq_tb_ins_risk_new_ms.sql 
[jerry@j src]$  mysql -uroot -pgemini -Dtpedw< 15rpt_fxq_tb_ins_risk_ms.sql 
[jerry@j src]$  mysql -uroot -pgemini -Dtpedw< 16rpt_fxq_tb_lar_report_ms.sql 
[jerry@j src]$  mysql -uroot -pgemini -Dtpedw< 17rpt_fxq_tb_sus_report_ms.sql 
{beginday}{endday}
[jerry@j src]$  mysql -uroot -pgemini -Dtpedw< 03rpt_fxq_tb_ins_pers_ms.sql --- ?empty
[jerry@j src]$  mysql -uroot -pgemini -Dtpedw< 04rpt_fxq_tb_ins_units_ms.sql 
[jerry@j src]$  mysql -uroot -pgemini -Dtpedw< 06s_rpt_fxq_tb_ins_rpol_ms.sql 
[jerry@j src]$  mysql -uroot -pgemini -Dtpedw< 06rpt_fxq_tb_ins_rpol_ms.sql 
[jerry@j src]$  mysql -uroot -pgemini -Dtpedw< 07rpt_fxq_tb_ins_gpol_ms.sql 
[jerry@j src]$  mysql -uroot -pgemini -Dtpedw< 08rpt_fxq_tb_ins_fav_cst_ms.sql 
[jerry@j src]$  mysql -uroot -pgemini -Dtpedw< 09rpt_fxq_tb_ins_renewal_ms.sql 
[jerry@j src]$  mysql -uroot -pgemini -Dtpedw< 10rpt_fxq_tb_ins_rsur_ms.sql 
[jerry@j src]$  mysql -uroot -pgemini -Dtpedw< 12s_rpt_fxq_tb_ins_rcla_ms.sql ??tpedw.ods_cthx_web_clm_accdnt
[jerry@j src]$  mysql -uroot -pgemini -Dtpedw< 13rpt_fxq_tb_ins_rchg_ms.sql 

## 提取范围内有效保单
rpt_fxq_tb_ins_pers_ms
rpt_fxq_tb_ins_units_ms
	edw_cust_ply_party
		x_edw_cust_per_units_info
			inner join ods_cthx_web_ply_base c_app_no

## 客户主题的有效范围确定t_next_edr_bgn_tm