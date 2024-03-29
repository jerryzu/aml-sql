-- *********************************************************************************
--  文件名称: 02rpt_fxq_tb_ins_rtype_ms.sql
--  所属主题: 中国人民银行反洗钱执法检查数据提取接口
--  功能描述:  
--   保险险种代码对照表
--  由机构部门表(web_org_dpt),通过机构映射表(ods_cthx_web_org_dpt_map)关联产品表产品大类表生成保险险种代码对照表
--            导入到 (rpt_fxq_tb_ins_rtype_ms) 表
--  创建者:祖新合 
--  输入: 
--  ods_cthx_web_org_dpt
--  ods_cthx_web_org_dpt_map
--  ods_cthx_web_prd_prod
--  ods_cthx_web_prd_kindk
--  rpt_fxq_tb_company_ms
--  输出:  
--  rpt_fxq_tb_ins_rtype_ms
--  创建日期: 2019/10/30
--  修改日志: 
--  修改日期: 
--  修改人: 
--  修改内容：
--  说明：  本表数据范围为检查对象所属法人机构全系统提供的所有金融服务（产品）（表六至表十三涉及的保险产品）,每种服务（产品）生成一条完整的记录。

alter table rpt_fxq_tb_ins_rtype_ms truncate partition pt{workday}000000;

INSERT INTO rpt_fxq_tb_ins_rtype_ms (
	head_no, 
	company_code1, 
	ins_type, 
	ins_no, 
	ins_name, 
	pt
)
select distinct co.head_no as head_no, -- 法人机构报告机构编码，央行统一分配
	d.c_dpt_cde as company_code1, -- 机构网点代码，内部的机构编码
	case 
	when k.c_kind_no = '01' then '11'
	when k.c_kind_no = '02' then '11'
	when k.c_kind_no = '03' then '10'
	when k.c_kind_no = '04' then '13'
	when k.c_kind_no = '05' then '15'
	when k.c_kind_no = '06' then '14'
	when k.c_kind_no = '07' then '14'
	when k.c_kind_no = '08' then '11'
	when k.c_kind_no = '09' then '11'
	when k.c_kind_no = '10' then '16'
	when k.c_kind_no = '11' then '12'
	when k.c_kind_no = '12' then '15'
	when k.c_kind_no = '16' then '16'
	else '其他'
	end as ins_type, -- 险种分类 10:车险;11:财产险;12:船货特险;13:责任保险;14:短期健康、意外保险;15:信用保证保险;16:农业保险;17:其他;如某一险种同时属于多累,需要同时列明,中间用";"隔开,如"10;11;12"
	p.c_prod_no as ins_no, -- 险种代码
	p.c_nme_cn as  ins_name, -- 险种名称
    '{workday}000000' pt
from ods_cthx_web_org_dpt partition(pt{workday}000000) d 
	inner join ods_cthx_web_org_dpt_map partition(pt{workday}000000) m on d.c_dpt_cde = m.c_dpt_cde
	left join ods_cthx_web_prd_prod partition(pt{workday}000000) p on m.c_kind_no = p.c_kind_no
	left join ods_cthx_web_prd_kind partition(pt{workday}000000) k on p.c_kind_no = k.c_kind_no
    left join rpt_fxq_tb_company_ms partition (pt{workday}000000) co on d.c_dpt_cde = co.company_code1