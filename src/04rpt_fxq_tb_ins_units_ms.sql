-- *********************************************************************************
--  文件名称:04rpt_fxq_tb_ins_units_ms.sql
--  所属主题: 中国人民银行反洗钱执法检查数据提取接口
--  功能描述: 从保单客户主题,保单相关非自然人信息表(edw_cust_units_info),通过保单三方关系表(edw_cust_ply_party)获取保单有效日期等信息过滤生成反洗钱单位客户身份信息记录清单
--   表提取数据
--            导入到 (rpt_fxq_tb_ins_unit_ms) 表
--  创建者:祖新合 
--  输入: 
--  edw_cust_units_info
--  edw_cust_ply_party
--  rpt_fxq_tb_company_ms
--  输出:  
--  rpt_fxq_tb_ins_unit_ms
--  创建日期: 2019/10/30
--  修改日志: 
--  修改日期: 
--  修改人: 
--  修改内容：
-- 说明：
--   1.取出表六至表十三涉及的所有投保人、被保险人、受益人（受益人适用人身保险业务，财产保险业务无需提取）、实际领款人为单位时的客户身份信息，如涉及多个系统存储客户身份信息的，应分别从各系统取数，确保提供要素的完整性。
--   2.一个单位客户存在多个控股股东或实际控制人的，每个控股股东或实际控制人生成一条记录。

alter table rpt_fxq_tb_ins_unit_ms truncate partition pt{workday}000000;

drop table if exists party;

create temporary table party select distinct c_cst_no from edw_cust_ply_party partition(pt{workday}000000)   
where t_next_edr_udr_tm > str_to_date('{endday}235959','%Y%m%d%H%i%s')	and t_app_tm between str_to_date('{beginday}000000','%Y%m%d%H%i%s') and str_to_date('{endday}235959','%Y%m%d%H%i%s');

INSERT INTO rpt_fxq_tb_ins_unit_ms(
    company_code1,
    company_code2,
    cst_no,
    open_time,
    close_time,
    acc_name,
    address,
    operate,
    set_file,
    license,
    id_deadline,
    org_no,
    tax_no,
    rep_name,
    id_type2,
    id_no2,
    id_deadline2,
    man_name,
    id_type3,
    id_no3,
    id_deadline3,
    ope_name,
    id_type4,
    id_no4,
    id_deadline4,
    industry_code,
    industry,
    reg_amt,
    code,
    sys_name,
    pt
)
SELECT
    u.c_dpt_cde as company_code1, -- 机构网点代码，内部的机构编码
    co.company_code2 as company_code2, -- 金融机构编码，人行科技司制定的14位金融标准化编码  暂时取“监管机构码，机构外部码，列为空”
    u.c_cst_no	        cst_no	,
    date_format(t_open_time,'%Y%m%d')	        open_time	,
    date_format(t_close_time,'%Y%m%d')	        close_time	,
    u.c_acc_name	        acc_name	,
    c_clnt_addr	        address	,
    c_manage_area	        operate	,        
    '21'                           set_file,-- 依法设立的执照名称，21营业执照、22其他
    /* 依法设立或经营的执照号码 unpass*/   -- 对应Set_file的号码, 对于多证合一的机构填写统一社会信用代码。
    c_buslicence_no	        license	,
    date_format(c_buslicence_valid,'%Y%m%d')	        id_deadline	,
    c_organization_no	        org_no	,
    c_cevenue_no	        tax_no	,
    c_legal_nme	        rep_name	,
    /* 法定代表人或负责人身份证件类型 unpass*/   -- 11: 居民身份证或临时身份证; 12: 军人或武警身份证件; 13: 港澳居民来往内地通行证, 台湾居民来往大陆通行证或其他有效旅行证件; 14、港澳台居民居住证; 15: 外国公民护照; 18: 其他类个人身份证件填写数字。		
    case c_legal_certf_cls
    when '120001' then 11 -- 居民身份证
    when '120002' then 13 -- 护照
    when '120003' then 12 -- 军人证
    when '120004' then 13 -- 回乡证
    when '120005' then 14 -- 港澳居民居住证
    when '120006' then 14 -- 台湾居民居住证
    when '120009' then 18 -- 其它
    else 
    18 -- 其它
    end 	        id_type2	,
    c_legal_certf_cde	        id_no2	,
    date_format(t_legal_cert_end_tm,'%Y%m%d')	        id_deadline2	,
    c_actualholding_nme	        man_name	,
    /* 控股股东或者实际控制人身份证件类型 unpass*/   -- 11: 居民身份证或临时身份证; 12: 军人或武警身份证件; 13: 港澳居民来往内地通行证, 台湾居民来往大陆通行证或其他有效旅行证件; 14、港澳台居民居住证; 15: 外国公民护照; 18: 其他类个人身份证件21: 营业执照(含社会统一信用代码证, 多证合一); 22: 其他填写数字。 
    case c_acth_certf_cls
    when '120001' then 11 -- 居民身份证
    when '120002' then 13 -- 护照
    when '120003' then 12 -- 军人证
    when '120004' then 13 -- 回乡证
    when '120005' then 14 -- 港澳居民居住证
    when '120006' then 14 -- 台湾居民居住证
    when '120009' then 18 -- 其它
    else 
    18 -- 其它
    end id_type3	,
    c_acth_certf_cde	        id_no3	,
    date_format(t_acth_certf_end_tm,'%Y%m%d')	        id_deadline3	,
    c_ope_name	        ope_name	,
    /* 授权办理业务人员身份证件类型 unpass*/   -- 11: 居民身份证或临时身份证; 12: 军人或武警身份证件; 13: 港澳居民往来内地身份通行证, 台湾居民来往大陆通行证或其他有效旅行证件; 14、港澳台居民居住证; 15: 外国公民护照; 18: 其他类个人身份证件填写数字。
    case c_ope_certf_cls
    when '120001' then 11 -- 居民身份证
    when '120002' then 13 -- 护照
    when '120003' then 12 -- 军人证
    when '120004' then 13 -- 回乡证
    when '120005' then 14 -- 港澳居民居住证
    when '120006' then 14 -- 台湾居民居住证
    when '120009' then 18 -- 其它
    else 
    18 -- 其它
    end id_type4,
    c_ope_certf_cde	        id_no4	,
    date_format(t_ope_certf_end_tm,'%Y%m%d')	        id_deadline4	,
    /* 行业代码 unpass*/   -- 填写单位客户行业代码。
    c_trd_cde	        industry_code	,
    c_sub_trd_cde	        industry	,
    n_reg_amt	        reg_amt	,
    /* 注册资本金币种 unpass*/   -- 采用国标, 如CNY、USD等; 下同。
    null	        code	,
    null	        sys_name	,
    '{workday}000000' pt
FROM edw_cust_units_info partition(pt{workday}000000) u
    inner join party pp on u.c_cst_no = pp.c_cst_no
    left join  rpt_fxq_tb_company_ms partition (pt{workday}000000) co on co.company_code1 = u.c_dpt_cde;