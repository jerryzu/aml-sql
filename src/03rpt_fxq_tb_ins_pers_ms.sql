-- *********************************************************************************
--  文件名称: 03rpt_fxq_tb_ins_pers_ms.sql
--  所属主题: 中国人民银行反洗钱执法检查数据提取接口
--  功能描述: 从保单客户主题,保单相关自然人信息表(edw_cust_pers_info),通过保单三方关系表(edw_cust_ply_party)获取保单有效日期等信息过滤生成反洗钱自然人客户身份信息记录清单
--   表提取数据
--            导入到 (rpt_fxq_tb_ins_pers_ms) 表
--  创建者:祖新合 
--  输入: 
--  edw_cust_pers_info
--  edw_cust_ply_party
--  rpt_fxq_tb_company_ms
--  输出:  rpt_fxq_tb_ins_pers_ms
--  创建日期: 2019/10/30
--  修改日志: 
--  修改日期: 
--  修改人: 
--  修改内容：
--  说明：  取出表六至表十三的所有投保人、被保险人、受益人（受益人适用人身保险业务，财产保险业务无需提取）、实际领款人为自然人时的客户身份信息，如涉及多个系统存储客户身份信息的，应分别从各系统取数，确保提供要素的完整性。

alter table rpt_fxq_tb_ins_pers_ms truncate partition pt{workday}000000;

drop table if exists party;

create temporary table party select distinct c_cst_no from edw_cust_ply_party partition(pt{workday}000000)   
where t_next_edr_udr_tm > str_to_date('{endday}235959','%Y%m%d%H%i%s')	and t_app_tm between str_to_date('{beginday}000000','%Y%m%d%H%i%s') and str_to_date('{endday}235959','%Y%m%d%H%i%s');

INSERT INTO rpt_fxq_tb_ins_pers_ms(
        company_code1,
        company_code2,
        cst_no,
        open_time,
        close_time,
        acc_name,
        cst_sex,
        nation,
        id_type,
        id_no,
        id_deadline,
        occupation_code,
        occupation,
        income,
        contact1,
        contact2,
        contact3,
        address1,
        address2,
        address3,
        company,
        sys_name,
        pt
)
SELECT
	p.c_dpt_cde as company_code1, -- 机构网点代码，内部的机构编码
    co.company_code2	company_code2,
    p.c_cst_no		cst_no,
    date_format(t_open_time,'%Y%m%d')		open_time,
    date_format(t_close_time,'%Y%m%d')		close_time,
    p.c_acc_name		acc_name,
    /* 性别 unpass*/  -- 11: 男; 12: 女。填写数字。
    case c_cst_sex
    when '1' then '11' -- 11:男
    when '2' then '12' -- 12:女
    else 
    null-- 其它
    end	cst_sex,
    /* 国籍（地区） unpass*/ -- 按照GB/T2659-2000世界各国和地区名称代码标准填写。三字符拉丁字母缩写, 如CHN、HKG。
    case 
    when c_country = '1' then 'CHN' -- 居民身份证
    else 
        null-- 其它
    end  		nation,
    case p.c_cert_cls
    when  '120001' then 11 -- 居民身份证
    when  '120002' then 13 -- 护照
    when  '120003' then 12 -- 军人证
    when  '120004' then 13 -- 回乡证
    when  '120005' then 14 -- 港澳居民居住证
    when  '120006' then 14 -- 台湾居民居住证
    when  '120009' then 18 -- 其它
    else 
    18 -- 其它
    end id_type,
    p.c_cert_cde		id_no,
    date_format(t_cert_end_date,'%Y%m%d')		id_deadline,
    /* 职业代码 unpass*/  -- 填写职业代码。
    c_occup_cde		occupation_code,
    c_occup_sub_cde		occupation,
    n_income		income,
    c_mobile		contact1,
    null		contact2,
    null		contact3,
    c_clnt_addr		address1,
    null		address2,
    null		address3,
    c_work_dpt		company,
    null		sys_name,
    '{workday}000000' pt
FROM edw_cust_pers_info partition(pt{workday}000000) p
    inner join party pp on p.c_cst_no = pp.c_cst_no
        left join  rpt_fxq_tb_company_ms partition (pt{workday}000000) co on co.company_code1 = p.c_dpt_cde;
	
-- 受益人（受益人适用人身保险业务，财产保险业务无需提取