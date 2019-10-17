/*
CREATE TABLE `rpt_fxq_tb_ply_base_ms` (
  `c_dpt_cde` varchar(30) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '机构代码 Department No',
  `c_cha_subtype` varchar(30) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '渠道子类',
  `c_brkr_cde` varchar(30) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '代理人/经纪人 Agent/Broker No',
  `c_ply_no` varchar(50) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '保单号 Policy No',
  `c_app_no` varchar(50) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '申请单号',
  `c_prod_no` varchar(6) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '产品代码 Product Code',
  `t_insrnc_bgn_tm` datetime DEFAULT NULL COMMENT '保险起期 Policy Effective Date',
  `t_insrnc_end_tm` datetime DEFAULT NULL COMMENT '保险止期 Policy Expire Date',
  `t_app_tm` datetime DEFAULT NULL COMMENT '投保日期 Applying Time',
  `t_edr_app_tm` datetime DEFAULT NULL COMMENT '批改申请日期',
  `t_edr_bgn_tm` datetime DEFAULT NULL COMMENT '批改生效起期',
  `t_next_edr_bgn_tm` datetime DEFAULT NULL COMMENT '批改生效起期 Beginning of Successive Edorsement  Effective Time ',
  `t_udr_tm` datetime DEFAULT NULL COMMENT '核保日期 Underwrite Time',
  `c_edr_type` varchar(30) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '批改类型,1 一般批改，2 注销，3退保  4、组合批改  5 满期返还  9 批单撤销',
  `c_edr_no` varchar(50) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '批单号',
  `c_edr_rsn_bundle_cde` varchar(50) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '批改原因或组合代码',
  `c_prm_cur` varchar(30) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '保费币种 Currency of Premium',
  `n_prm` decimal(20,2) DEFAULT NULL COMMENT '保费合计 Premium',
  `n_prm_var` decimal(20,2) DEFAULT NULL COMMENT '保费变化，批单保费上一批单（保单）保费',
  `acc_name` varchar(100) DEFAULT NULL COMMENT '缴款人',
  `acc_no` varchar(30) DEFAULT NULL COMMENT '存现银行',
  `acc_bank` varchar(100) DEFAULT NULL COMMENT '客户银行名称',
  `c_edr_ctnt` text CHARACTER SET utf8 COLLATE utf8_bin COMMENT '批文内容',
  `c_grp_mrk` varchar(1) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT '0' COMMENT '团单标志( 0 个单; 1 团单) Group Insurance Flag'
) ENGINE=InnoDB DEFAULT CHARSET=utf8
*/

drop table  if exists pay;
create temporary table pay
select  
        due.c_ply_no
        , due.c_app_no
        , due.c_cav_no
        , due.c_rcpt_no
        , mny.n_item_no
        , mny.c_cav_pk_id
        , mny.c_payer_nme         as acc_name -- 交费账号名称
        , mny.c_savecash_bank          as acc_no -- 交费账号
        , mny.c_bank_nme	          as acc_bank -- 交费账户开户机构名称
from ods_cthx_web_fin_prm_due partition(pt20191013000000) due
    	inner join ods_cthx_web_fin_cav_mny partition(pt20191013000000) mny on due.c_cav_no = mny.c_cav_pk_id
order by  due.c_app_no, due.c_rcpt_no desc,  mny.n_item_no desc;   	

drop table  if exists pay1;
create temporary table pay1
select 
        c_ply_no
        , c_app_no
        , acc_name -- 交费账号名称
        , acc_no -- 交费账号
        , acc_bank -- 交费账户开户机构名称
from (select  
                c_ply_no
                , c_app_no
                , acc_name -- 交费账号名称
                , acc_no -- 交费账号
                , acc_bank -- 交费账户开户机构名称
                ,if(@u=c_app_no ,@r:=@r+1,@r:=1) as rank
                ,@u:=c_app_no 
        from pay, (select @u:=null, @r:=0) r 
        order by  c_app_no, c_rcpt_no desc,  n_item_no desc   	
) v
where rank = 1;

truncate table  rpt_fxq_tb_ply_base_ms;
insert into rpt_fxq_tb_ply_base_ms(
        c_dpt_cde	--  机构代码 Department No
        ,c_cha_subtype	--  渠道子类
        ,c_brkr_cde	 --  代理人/经纪人 Agent/Broker No
        ,c_ply_no	--   保单号 Policy No
        ,c_app_no	--  申请单号
        ,c_prod_no	--  产品代码 Product Code
        ,t_insrnc_bgn_tm	--  保险起期 Policy Effective Date
        ,t_insrnc_end_tm	--  保险止期 Policy Expire Date
        ,t_app_tm	--  投保日期 Applying Time
        ,t_edr_app_tm	--  批改申请日期
        ,t_edr_bgn_tm	--  批改生效起期
        ,t_next_edr_bgn_tm	--  批改生效起期 Beginning of Successive Edorsement  Effective Time 
        ,t_udr_tm       --   核保日期
        ,c_edr_type	--  批改类型,1 一般批改，2 注销，3退保  4、组合批改  5 满期返还  9 批单撤销
        ,c_edr_no	--  批单号
        ,c_edr_rsn_bundle_cde --  	批改原因或组合代码
        ,c_prm_cur	--  保费币种 Currency of Premium
        ,n_prm	--  保费合计 Premium
        ,n_prm_var	--  保费变化，批单保费上一批单（保单）保费
        ,acc_name	--  缴款人
        ,acc_no	--  存现银行
        ,acc_bank	--  客户银行名称
        ,c_edr_ctnt	--  批文内容
        ,c_grp_mrk -- 保单类型  (biz: 0 个单; 1 团单)11:非团险;12:团险
)
select 
	a.c_dpt_cde
	, a.c_cha_subtype 
	, a.c_brkr_cde-- 销售渠道名称
	, a.c_ply_no -- 保单号
	, a.c_app_no-- 投保单号
	, a.c_prod_no -- 险种代码 
	, a.t_insrnc_bgn_tm -- 合同生效日期
	, a.t_insrnc_end_tm
	, a.t_app_tm  -- 投保日期
	, a.t_edr_app_tm -- 申请日期
	, a.t_edr_bgn_tm -- 变更或批改日期
	, a.t_next_edr_bgn_tm
        , a.t_udr_tm  -- 核保日期
	, a.c_edr_type
	, a.c_edr_no -- 批单号
	, a.c_edr_rsn_bundle_cde-- 业务类型 11:退保;12:减保;13:保单部分领取;14:保单贷款;15:其他
	, a.c_prm_cur 
	, a.n_prm -- 本期交保费金额
	, a.n_prm_var -- 测试此条件没有满足记录

        , acc_name -- 交费账号名称
        , acc_no -- 交费账号
        , acc_bank -- 交费账户开户机构名称
	, a.c_edr_ctnt -- 变更内容摘要
        , a.c_grp_mrk -- 保单类型  (biz: 0 个单; 1 团单)11:非团险;12:团险
from  ods_cthx_web_ply_base partition(pt20191013000000)  a
     left join pay1 p on a.c_app_no = p.c_app_no    
where a.t_next_edr_bgn_tm > now();