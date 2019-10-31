select count(1)
-- m.c_clm_no
-- ,m.c_ply_no
-- ,m.c_app_no
-- ,i.c_cst_no  c_ins_no -- 被保人编码  
-- ,i.c_clnt_mrk c_ins_clnt_mrk
-- ,i.c_ins_app_rel -- 被保险人与投保人之间的关系
from clm_ply_no m  
--  保单人员参于类型: 投保人: [个人:21, 法人:22]; 被保人: [个人:31, 法人:32, 团单被保人:33]; 受益人: [个人:41, 法人:42,团单受益人:43]; 收款人:[11]
--  inner join edw_cust_ply_party  i on m.c_app_no = i.c_app_no and i.c_per_biztype in (31, 32)  -- 156
inner join x_edw_cust_pers_units_info  i on m.c_app_no = i.c_app_no and i.c_per_biztype in (31, 32)  -- 181
where i.c_cert_cls is not null and trim(i.c_cert_cls)  <> '' and i.c_cert_cls REGEXP '[^0-9.]' = 0 and i.c_cert_cde is not null and trim(i.c_cert_cde)  <> '' 

select  count(1)
-- b.c_cst_no  c_bnfc_no -- 受益编码  
-- ,b.c_clnt_mrk c_bnfc_clnt_mrk
-- ,b.c_bnfc_ins_rel -- 受益人与被保险人之间的关系
from clm_ply_no m  
--  保单人员参于类型: 投保人: [个人:21, 法人:22]; 被保人: [个人:31, 法人:32, 团单被保人:33]; 受益人: [个人:41, 法人:42,团单受益人:43]; 收款人:[11]
inner join edw_cust_ply_party  b on m.c_app_no = b.c_app_no and b.c_per_biztype in (41, 42) 


--一个理赔可以被保人多次，多个被保人同时出险
SELECT *
FROM ods_cthx_web_clm_accdnt partition (pt20190131000000)
where c_clm_no in(
 'C000001602201700000009'
 ,'C000006002201800000004'
,'C000006602201700000002'
,'C000006602201700000003'
,'C000006602201800000027')
order by c_clm_no 

-- 同一理赔单领款有多种类型，有
SELECT c_clm_no, count(1) rcx
FROM ods_cthx_web_clm_bank partition (pt20190131000000)
group by c_clm_no
order by rcx desc

SELECT *
FROM ods_cthx_web_clm_bank partition (pt20190131000000)
where c_clm_no = 'C000001605201700000001'


可以修改保单三方关系表，增加投被益关系定义服务理赔，含:软通测试查勘费、软通测试顾问费
select distinct 
        c_payee_type,	c_payee_nme, c_pay_type
 from ods_cthx_web_clm_bank partition(pt20191013000000)

select distinct 
c_payee_type	-- 与被保险人关系
,c_pay_typ	-- 支付类型
,c_amt_typ	-- 赔款金额类型
,c_ply_typ	-- 保单类型
,c_bs_typ	-- 业务类型
,c_card_type	-- 证件类型
,c_pay_type	-- 赔付类型
 from ods_cthx_web_clm_bank partition(pt20191013000000)

-- 结案多次，没有被保人信息
SELECT c_clm_no, count(1) rcx
FROM ods_cthx_web_clmnv_endcase partition (pt20190131000000)
group by c_clm_no
order by rcx desc

可增加出险被保人关系表？

--重复
select c_app_cde, count(1) rc
from  ods_cthx_web_ply_insured partition(pt20191013000000)
group by c_app_cde
order by rc desc

--重复
select c_app_cde, count(1) rc
from  ods_cthx_web_ply_applicant partition(pt20191013000000)
group by c_app_cde
order by rc desc

--重复(全空)
select c_bnfc_cde, count(1) rc
from  ods_cthx_web_ply_bnfc partition(pt20191013000000)
group by c_bnfc_cde
order by rc desc