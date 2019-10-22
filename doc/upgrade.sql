/* 重新定义资金系统标识fund(与底层数据源名称一致), 没有定义数据平台任务*/
alter table tpedw.ods_cthx_t_banktransactions rename to ods_fund_t_banktransactions;

/* 增加字段c_abstract,其它两个字段tpedw没有，edw_pdm_bddj3, edw_pdm在开发环境已经定义， */
alter table tpedw.ods_cthx_web_fin_prm_due add(c_ma_bala_mrk varchar(1) default '0' comment '挂账冲销标识');
alter table tpedw.ods_cthx_web_fin_prm_due add(c_follow_con_cde varchar(200) default null comment '共保人（仅供页面显示使用）');
alter table tpedw.ods_cthx_web_fin_prm_due add(c_abstract varchar(100) default null comment '资金系统对账码');

edw_pdm_bddj3
alter table edw_pdm_bddj3.web_fin_prm_due add(c_ma_bala_mrk varchar2(3) default '0'); comment on column edw_pdm_bddj3.web_fin_prm_due.c_ma_bala_mrk is '挂账冲销标识';
alter table edw_pdm_bddj3.web_fin_prm_due add(c_follow_con_cde varchar2(600) default null); comment on column edw_pdm_bddj3.web_fin_prm_due.c_follow_con_cde is '共保人（仅供页面显示使用）';
alter table edw_pdm_bddj3.web_fin_prm_due add(c_abstract varchar2(300) default null); comment on column edw_pdm_bddj3.web_fin_prm_due.c_abstract is '资金系统对账码';

select *
from user_tab_cols
where table_name like '%web_fin_prm_due%'

edw_pdm
alter table edw_pdm.web_fin_prm_due add(c_ma_bala_mrk varchar2(3) default '0'); comment on column edw_pdm.web_fin_prm_due.c_ma_bala_mrk is '挂账冲销标识';
alter table edw_pdm.web_fin_prm_due add(c_follow_con_cde varchar2(600) default null); comment on column edw_pdm.web_fin_prm_due.c_follow_con_cde is '共保人（仅供页面显示使用）';
alter table edw_pdm.web_fin_prm_due add(c_abstract varchar2(300) default null); comment on column edw_pdm.web_fin_prm_due.c_abstract is '资金系统对账码';
