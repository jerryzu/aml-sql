#!/bin/bash
read -p "Enter BeginDay[yyyymmdd]: " beginday
read -p "Enter EndDay[yyyymmdd]: " endday
read -p "Are you sure to continue? [y/n] " input

workday=`date +%Y%m%d`
workday=20191013

do_compile() {
  while read task
  do
    echo $(date +%F%n%T): [$task] starting.....
    sed -e "s/{beginday}/$beginday/g;s/{endday}/$endday/g;s/{workday}/$workday/g" ../src/$task > work/$task
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
}

do_task() {
  echo $(date +%F%n%T): [starting]
  while read task
  do
    echo $(date +%F%n%T): [$task] starting.....
    mysql -utaipingbi_etl -pTpstic123456 -Dtpedw -hrm-bp19v63q682asdrja.mysql.rds.aliyuncs.com -A < work/$task
    if [ $? -ne 0 ]
    then
      echo $(date +%F%n%T): [$task] error
    else
      echo $(date +%F%n%T): [$task] done
    fi
  done < tasks.list
  echo $(date +%F%n%T): [finish]
}

case $input in
        [yY]*)
                echo "BeginDay is $beginday"
                echo "EndDay is $endday"
                do_compile;
                do_task;
                ;;
        [nN]*)
                exit
                ;;
        *)
                echo "Just enter y or n, please."
                exit
                ;;
esac

