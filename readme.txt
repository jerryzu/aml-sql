./src/07rpt_fxq_tb_ins_gpol_ms.sql:169:    inner join ods_cthx_web_ply_ent_tgt partition(pt20191013000000) t

./src/09rpt_fxq_tb_ins_renewal_ms.sql:118:      inner join ods_cthx_web_bas_edr_rsn   partition(pt20191013000000) c on a.c_edr_rsn_bundle_cde=c.c_rsn_cde and substr(a.c_prod_no,1,2)=c.c_kind_no

./src/10rpt_fxq_tb_ins_rsur_ms.sql:100: inner join ods_cthx_web_bas_edr_rsn   partition(pt20191013000000) c on a.c_edr_rsn_bundle_cde=c.c_rsn_cde and substr(a.c_prod_no,1,2)=c.c_kind_no

./src/11rpt_fxq_tb_ins_rpay_ms.sql:96:    inner join ods_cthx_web_fin_prm_due partition(pt20191013000000) due on a.c_ply_no = due.c_ply_no
./src/11rpt_fxq_tb_ins_rpay_ms.sql:97:    inner join ods_cthx_web_fin_cav_mny partition(pt20191013000000) mny on due.c_cav_no = mny.c_cav_pk_id

./src/12rpt_fxq_tb_ins_rcla_ms.sql:122:  inner join ods_cthx_web_clm_main partition(pt20191013000000) cm on a.c_ply_no = cm.c_ply_no
./src/12rpt_fxq_tb_ins_rcla_ms.sql:123:  inner join ods_cthx_web_clmnv_endcase partition(pt20191013000000) u on cm.c_clm_no = u.c_clm_no
./src/12rpt_fxq_tb_ins_rcla_ms.sql:124:  inner join ods_cthx_web_clm_bank partition(pt20191013000000) g on u.c_clm_no=g.c_clm_no
./src/12rpt_fxq_tb_ins_rcla_ms.sql:125:  inner join ods_cthx_web_clm_rpt partition(pt20191013000000) e on g.c_clm_no=e.c_clm_no

./src/13rpt_fxq_tb_ins_rchg_ms.sql:55:  inner join ods_cthx_web_bas_edr_rsn   partition(pt20191013000000) c on a.c_edr_rsn_bundle_cde=c.c