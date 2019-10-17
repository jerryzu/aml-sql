-- *********************************************************************************
--  文件名称: 02rpt_fxq_tb_ins_rtype_ms.sql
--  所属主题: 理赔
--  功能描述: 从 
--   表提取数据
--            导入到 (rpt_fxq_tb_ins_rtype_ms) 表
--  创建者: 
--  输入: 
--  输出:  rpt_fxq_tb_ins_rtype_ms
--  创建日期: 2017/6/7
--  修改日志: 
--  修改日期: 
--  修改人: 
--  修改内容：

alter table rpt_fxq_tb_ins_rtype_ms truncate partition pt{lastday}000000;

INSERT INTO rpt_fxq_tb_ins_rtype_ms (
	head_no, 
	company_code1, 
	ins_type, 
	ins_no, 
	ins_name, 
	pt
)
select distinct co.head_no as head_no, -- 法人机构报告机构编码，央行统一分配
	a.c_dpt_cde as company_code1, -- 机构网点代码，内部的机构编码
	case 
	when d.c_kind_no = '01' then '11'
	when d.c_kind_no = '02' then '11'
	when d.c_kind_no = '03' then '10'
	when d.c_kind_no = '04' then '13'
	when d.c_kind_no = '05' then '15'
	when d.c_kind_no = '06' then '14'
	when d.c_kind_no = '07' then '14'
	when d.c_kind_no = '08' then '11'
	when d.c_kind_no = '09' then '11'
	when d.c_kind_no = '10' then '16'
	when d.c_kind_no = '11' then '12'
	when d.c_kind_no = '12' then '15'
	when d.c_kind_no = '16' then '16'
	else '其他'
	end as ins_type, -- 险种分类 10:车险;11:财产险;12:船货特险;13:责任保险;14:短期健康、意外保险;15:信用保证保险;16:农业保险;17:其他;如某一险种同时属于多累,需要同时列明,中间用";"隔开,如"10;11;12"
	c.c_prod_no as ins_no, -- 险种代码
	c.c_nme_cn as  ins_name, -- 险种名称
    '{lastday}000000' pt
from ods_cthx_web_org_dpt partition(pt{lastday}000000) a 
	inner join ods_cthx_web_org_dpt_map partition(pt{lastday}000000) b on a.c_dpt_cde=b.c_dpt_cde
	left join ods_cthx_web_prd_prod partition(pt{lastday}000000) c on b.c_kind_no=c.c_kind_no
	left join ods_cthx_web_prd_kind partition(pt{lastday}000000) d on c.c_kind_no=d.c_kind_no
    left join  rpt_fxq_tb_company_ms partition (pt{lastday}000000) co on co.company_code1 = a.c_dpt_cde