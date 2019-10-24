truncate table edw_cust_pers_info;
select * 
from edw_cust_pers_info m 
where not exists(select 1 from x_edw_cust_pers_units_info v
        where v.c_cst_no = m.c_cst_no
    );
    
truncate table edw_cust_units_info;

select * 
from edw_cust_units_info m 
where not exists(select 1 from x_edw_cust_pers_units_info v
        where v.c_cst_no = m.c_cst_no
    )
    
truncate table edw_cust_ply_party;

select * 
from edw_cust_ply_party m 
where not exists(select 1 from x_edw_cust_pers_units_info v
        where v.c_cst_no = m.c_cst_no
    );
truncate table rpt_fxq_tb_ins_pers_ms;

select * 
from rpt_fxq_tb_ins_pers_ms m 
where not exists(select 1 from x_edw_cust_pers_units_info v
        where v.c_cst_no = m.cst_no
    );

truncate table rpt_fxq_tb_ins_unit_ms;

select * 
from rpt_fxq_tb_ins_unit_ms m 
where not exists(select 1 from x_edw_cust_pers_units_info v
        where v.c_cst_no = m.cst_no
    );