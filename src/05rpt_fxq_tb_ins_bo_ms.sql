-- *********************************************************************************
--  文件名称: .sql
--  所属主题: 理赔
--  功能描述: 从 
--   表提取数据
--            导入到 () 表
--  创建者: 
--  输入: 
--  输出:  
--  创建日期: 2017/6/7
--  修改日志: 
--  修改日期: 
--  修改人: 
--  修改内容：

alter table rpt_fxq_tb_ins_bo_ms truncate partition pt{lastday}000000;

INSERT INTO rpt_fxq_tb_ins_bo_ms(
        company_code1,
        company_code2,
        acc_name,
        cst_no,
        license,
        bnf_name,
        bnf_type,
        shareholding_ratio,
        bnf_address,
        id_type5,
        id_no5,
        id_deadline5,
        sys_name,
        pt
)
select 
    u.c_dpt_cde as company_code1, -- 机构网点代码，内部的机构编码
    co.company_code2 as company_code2, -- 金融机构编码，人行科技司制定的14位金融标准化编码  暂时取“监管机构码，机构外部码，列为空”
    u.c_acc_name  as acc_name, -- 客户名称
    u.c_cst_no as cst_no, -- 客户号
	/* 依法设立或经营的执照号码 unpass*/   -- 客户身份证件号码按表4License字段要求填写。
    u.c_buslicence_no as license,-- 营业执照号码
    p.c_acc_name as bnf_name,-- 收益所有人姓名
	/* 判定受益所有人方式 unpass*/  -- 11: 股权或表决权; 12: 人事、财务控制; 13: 高级管理人; 14其他
	'14' as bnf_type,-- 判定受益所有人方式,14其他
	/* 持股数量或表决权占比 unpass*/  -- 单位: ％。填写百分比, 保留2位小数, 如51.66, 不填写"％"符号。Bnftype=11时填写, 不等11时填写"@N"
    null as shareholding_ratio,-- 持股数量或表决权比例
    p.c_clnt_addr as bnf_address,-- 受益所有人住址    
    case  p.c_cert_cls
        when '120001' then 11 -- 居民身份证
        when '120002' then 13 -- 护照
        when '120003' then 12 -- 军人证
        when '120004' then 13 -- 回乡证
        when '120005' then 14 -- 港澳居民居住证
        when '120006' then 14 -- 台湾居民居住证
        when '120009' then 18 -- 其它
    else 
        18 -- 其它
    end as id_type5,-- 受益所有人证件类型    
     p.c_cert_cde as id_no5,-- 受益所有人证件号码
    date_format(t_cert_end_date,'%Y%m%d') id_deadline5,-- 受益所有人证件有效期
    '@N'as sys_name,-- 系统名称,
    '{lastday}000000' pt
from edw_cust_ply_party partition(pt{lastday}000000) a1
    inner join edw_cust_ply_party partition(pt{lastday}000000) a2 on a1.c_ply_no = a2.c_ply_no
    left join  edw_cust_units_info partition(pt{lastday}000000)  u on a1.c_cst_no = u.c_cst_no
    left join edw_cust_pers_info partition(pt{lastday}000000) p on a2.c_cst_no = p.c_cst_no
    left join  rpt_fxq_tb_company_ms partition (pt{lastday}000000) co on co.company_code1 = u.c_dpt_cde
where a1.c_biz_type = 22 -- 10: 收款人, 21: 投保人, 22: 法人投保人, 31:被保人, 32:法人被保人, 33: 团单被保人，41: 受益人, 42: 法人受益人, 43: 团单受益人
   and a1.c_clnt_mrk='0' -- 受益人没有客户类别区分,申请人有客户类别区分
   and a2.c_biz_type = 43 -- 10: 收款人, 21: 投保人, 22: 法人投保人, 31:被保人, 32:法人被保人, 33: 团单被保人，41: 受益人, 42: 法人受益人, 43: 团单受益人
   and a2.c_clnt_mrk='1'