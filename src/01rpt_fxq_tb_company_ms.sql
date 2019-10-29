-- *********************************************************************************
--  文件名称: 01rpt_fxq_tb_company_ms.sql
--  所属主题: 中国人民银行反洗钱执法检查数据提取接口
--  功能描述: 
--   根据机构部门表(web_org_dpt),通过手工映射表(rpt_fxq_manual_company_ms)生成最终机构对照表(rpt_fxq_tb_company_ms)
--  创建者: 
--  输入: 
--  ods_cthx_web_org_dpt
--  rpt_fxq_manual_company_ms
--  输出:  
--  rpt_fxq_tb_company_ms
--  创建日期: 2017/6/7
--  修改日志: 
--  修改日期: 
--  修改人: 
--  修改内容：
--  说明：  本表数据范围为被检查对象所属法人机构及其全系统内所有向客户提供金融服务（产品）的分支机构或部门条线，每个分支机构或部门生成一条完整的记录。

alter table rpt_fxq_tb_company_ms truncate partition pt20191013000000;

insert into rpt_fxq_tb_company_ms (
    head_no, 
    company_code1, 
    company_code2, 
    company_name, 
    bord_flag, 
    pt
) 
select c.head_no as head_no, -- 法人机构报告机构编码，央行统一分配
    d.c_dpt_cde as company_code1, -- 机构网点代码，内部的机构编码
    c.company_code2 as company_code2, -- 金融机构编码，人行科技司制定的14位金融标准化编码  暂时取“监管机构码，机构外部码，列为空”
    d.c_dpt_cnm as company_name, -- 机构名称
    c.bord_flag as  bord_flag, -- 制定经营地点，10境内、11境外 --ref
    '20191013000000' pt
from ods_cthx_web_org_dpt partition(pt20191013000000) d
    inner join  rpt_fxq_manual_company_ms partition(future) c 
		on c.company_code1 = d.c_dpt_cde