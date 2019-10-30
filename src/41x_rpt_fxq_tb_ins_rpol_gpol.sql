-- *********************************************************************************
--  文件名称: 41x_rpt_fxq_tb_ins_rpol_gpol.sql
--  所属主题: 中国人民银行反洗钱执法检查数据提取接口
--  功能描述: ods_cthx_web_fin_prm_due关联ods_cthx_web_fin_cav_mny生成交费信息
--  关联保单表(ods_cthx_web_ply_base)生成含交费信息的保单信息表(含原保单、批改单级)
--   表提取数据
--            导入到 (x_rpt_fxq_tb_ins_rpol_gpol) 表
--  创建者:祖新合 
--  输入: 
--  ods_cthx_web_fin_prm_due
--  ods_cthx_web_fin_cav_mny
--  ods_cthx_web_ply_base
--  输出:  x_rpt_fxq_tb_ins_rpol_gpol
--  创建日期: 2019/10/30
--  修改日志: 
--  修改日期: 
--  修改人: 
--  修改内容：

truncate table  x_rpt_fxq_tb_ins_rpol_gpol;

drop table  if exists pay;
create temporary table pay
select  
        due.c_ply_no
        , due.c_app_no
        , due.c_cav_no
        , due.c_rcpt_no
        , due. c_pay_mde_cde	--  付款方式
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
        , c_pay_mde_cde	--  付款方式
        , acc_name -- 交费账号名称
        , acc_no -- 交费账号
        , acc_bank -- 交费账户开户机构名称
from (select  
                c_ply_no
                , c_app_no
                , c_pay_mde_cde	--  付款方式
                , acc_name -- 交费账号名称
                , acc_no -- 交费账号
                , acc_bank -- 交费账户开户机构名称
                ,if(@u=c_app_no ,@r:=@r+1,@r:=1) as rank
                ,@u:=c_app_no 
        from pay, (select @u:=null, @r:=0) r 
        order by  c_app_no, c_rcpt_no desc,  n_item_no desc   	
) v
where rank = 1;

insert into x_rpt_fxq_tb_ins_rpol_gpol(
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
        ,t_next_edr_udr_tm	--  批改生效起期 Beginning of Successive Edorsement  Effective Time 
        ,t_udr_tm       --   核保日期
        ,c_edr_type	--  批改类型,1 一般批改，2 注销，3退保  4、组合批改  5 满期返还  9 批单撤销
        ,c_edr_no	--  批单号
        ,c_edr_rsn_bundle_cde --  	批改原因或组合代码
        ,c_prm_cur	--  保费币种 Currency of Premium
        ,n_prm	--  保费合计 Premium
        ,n_prm_var	--  保费变化，批单保费上一批单（保单）保费
        ,c_pay_mde_cde	--  付款方式
        ,acc_name	--  缴款人
        ,acc_no	--  存现银行
        ,acc_bank	--  客户银行名称
        ,c_edr_ctnt	--  批文内容
        ,c_grp_mrk -- 保单类型  (biz: 0 个单; 1 团单)11:非团险;12:团险
)
select 
	b.c_dpt_cde
	, b.c_cha_subtype 
	, b.c_brkr_cde-- 销售渠道名称
	, b.c_ply_no -- 保单号
	, b.c_app_no-- 投保单号
	, b.c_prod_no -- 险种代码 
	, b.t_insrnc_bgn_tm -- 合同生效日期
	, b.t_insrnc_end_tm
	, b.t_app_tm  -- 投保日期
	, b.t_edr_app_tm -- 申请日期
	, b.t_edr_bgn_tm -- 变更或批改日期
	, b.t_next_edr_udr_tm
        , b.t_udr_tm  -- 核保日期
	, b.c_edr_type
	, b.c_edr_no -- 批单号
	, b.c_edr_rsn_bundle_cde-- 业务类型 11:退保;12:减保;13:保单部分领取;14:保单贷款;15:其他
	, b.c_prm_cur 
	, b.n_prm -- 本期交保费金额
	, b.n_prm_var -- 测试此条件没有满足记录
        /* 现转标识 unpass*/  -- 10: 现金交保险公司; 11: 转账; 12: 现金缴款单(指客户向银行缴纳现金, 凭借银行开具的单据向保险机构办理交费业务); 13: 保险公司业务员代付。网银转账、银行柜面转账、POS刷卡、直接转账给总公司账户等情形, 应标识为转账。填写数字。
        , p.c_pay_mde_cde	--  付款方式
        , p.acc_name -- 交费账号名称
        , p.acc_no -- 交费账号
        , p.acc_bank -- 交费账户开户机构名称
	, b.c_edr_ctnt -- 变更内容摘要
        , b.c_grp_mrk -- 保单类型  (biz: 0 个单; 1 团单)11:非团险;12:团险
from  ods_cthx_web_ply_base partition(pt20191013000000)  b
     left join pay1 p on b.c_app_no = p.c_app_no    
where b.t_next_edr_udr_tm > now();