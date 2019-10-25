20x_edw_cust_pers_units_info.sql
41x_rpt_fxq_tb_ins_rpol_gpol.sql
22edw_cust_pers_info.sql
23edw_cust_units_info.sql
21edw_cust_ply_party.sql

31rpt_fxq_tb_amltp_entity.sql
32rpt_fxq_tb_amltp_score.sql
33rpt_fxq_tb_amltp_risk.sql

14rpt_fxq_tb_ins_risk_new_ms.sql
15rpt_fxq_tb_ins_risk_ms.sql
16rpt_fxq_tb_lar_report_ms.sql
17rpt_fxq_tb_sus_report_ms.sql

01rpt_fxq_tb_company_ms.sql
02rpt_fxq_tb_ins_rtype_ms.sql
03rpt_fxq_tb_ins_pers_ms.sql
04rpt_fxq_tb_ins_units_ms.sql
05rpt_fxq_tb_ins_bo_ms(reserves).sql
06rpt_fxq_tb_ins_rpol_ms.sql
06s_rpt_fxq_tb_ins_rpol_ms.sql
07rpt_fxq_tb_ins_gpol_ms.sql
08rpt_fxq_tb_ins_fav_cst_ms.sql
09rpt_fxq_tb_ins_renewal_ms.sql
10rpt_fxq_tb_ins_rsur_ms.sql
11rpt_fxq_tb_ins_rpay_ms(abandoned).sql
12rpt_fxq_tb_ins_rcla_ms.sql
13rpt_fxq_tb_ins_rchg_ms.sql


## 受益人客户类型全为空
## 投保人,被保人关系:个单没有对应数据,团单没有此字段
## 05rpt_fxq_tb_ins_bo_ms(reserves).sql原提取规则不正确??
## 11rpt_fxq_tb_ins_rpay_ms\(abandoned\).sql 不正确,但是人寿险不需要上报
## 12rpt_fxq_tb_ins_rcla_ms.sql 需要确认,因为这里的被保,受益均不从保单取,从理赔取??
## 13rpt_fxq_tb_ins_rchg_ms.sql没有满足条件的记录 m.n_prm_var <> 0 --  测试此条件没有满足记录