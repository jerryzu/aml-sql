# sed -e's/{firstday}/firstday/g;s/{lastday}/lastday/g;s/{lastday}/lastday/g' mysqlscript.sql > mysqlscript.txt

[tpodps@DEV-EDWETL aml]$ more tasks.list 
20x_edw_cust_pers_units_info.sql 
41x_rpt_fxq_tb_ins_rpol_gpol.sql 
22edw_cust_pers_info.sql 
23edw_cust_units_info.sql 
21edw_cust_ply_party.sql 
31rpt_fxq_tb_amltp_entity.sql 
32rpt_fxq_tb_amltp_score.sql 
33rpt_fxq_tb_amltp_risk.sql 
14rpt_fxq_tb_ins_risk_new_ms.sql 
15rpt_fxq_tb_ins_risk_ms.sql 
16rpt_fxq_tb_lar_report_ms.sql 
17rpt_fxq_tb_sus_report_ms.sql 
03rpt_fxq_tb_ins_pers_ms.sql
04rpt_fxq_tb_ins_units_ms.sql 
06s_rpt_fxq_tb_ins_rpol_ms.sql 
06rpt_fxq_tb_ins_rpol_ms.sql 
07rpt_fxq_tb_ins_gpol_ms.sql 
08rpt_fxq_tb_ins_fav_cst_ms.sql 
09rpt_fxq_tb_ins_renewal_ms.sql 
10rpt_fxq_tb_ins_rsur_ms.sql 
12s_rpt_fxq_tb_ins_rcla_ms.sql
13rpt_fxq_tb_ins_rchg_ms.sql

[tpodps@DEV-EDWETL aml]$ more tasks.sh 
#  select @@error_count;
while read task
do
  echo $(date +%F%n%T): [$task] starting.....
  sed -e's/{firstday}/firstday/g;s/{lastday}/lastday/g;s/{workday}/workday/g' ../src/$task > work/$task
  if [ $? -ne 0 ]
  then
    echo $(date +%F%n%T): [$task] error

    #read -p "Please input a number: " n
    #if [ -z $input1 ]
    #then
    #echo -n "无效输入，请重新输入："
    #break 只是退出当前循环还会继续执行函数后面的命令
    #return 退出当前函数还会继续执行主脚本
    #exit 彻底退出脚本

  else
    echo $(date +%F%n%T): [$task] done
  fi
done < tasks.list

echo $(date +%F%n%T): [starting]
while read task
do
  echo $(date +%F%n%T): [$task] starting.....
  mysql -utaipingbi_etl -pTpstic123456 -Dtpedw -hrm-bp19v63q682asdrja.mysql.rds.aliyuncs.com -A < $task
  if [ $? -ne 0 ]
  then
    echo $(date +%F%n%T): [$task] error
  else
    echo $(date +%F%n%T): [$task] done
  fi
done < tasks.list
echo $(date +%F%n%T): [finish]

+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#! /bin/bash
read -p "Enter your name, please: " username
read -p "Enter your email, please: " email
read -p "Are you sure to continue? [y/n] " input
case $input in
        [yY]*)
                echo "Your name is $username"
                echo "Your email is $email"
                ;;
        [nN]*)
                exit
                ;;
        *)
                echo "Just enter y or n, please."
                exit
                ;;
esac