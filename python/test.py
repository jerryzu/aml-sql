# coding=utf-8

import sys
import xlwt
import pymysql

# sys.reload(sys)
# 使用pymysql模块链接数据库
conn = pymysql.connect(
    user='taipingbi_etl',
    password='Tpstic123456',
    host='rm-bp19v63q682asdrja.mysql.rds.aliyuncs.com',
    database='tpedw',
    charset='utf8'
)

# 获取游标
cursor = conn.cursor()
# sql语句
sql = "select * from rpt_fxq_tb_company_ms"
# 执行sql
count = cursor.execute(sql)
cursor.scroll(0, mode='relative')
# 此处的result是查询结果
result = cursor.fetchall()
fields = cursor.description

workbook = xlwt.Workbook()
sheet = workbook.add_sheet('sheet', cell_overwrite_ok=True)

for field in range(0, len(fields)):
    if (fields[field][0] <> 'pt'):
        sheet.write(0, field, fields[field][0])
        print fields[field][0]

row = 1
col = 0
for row in range(1, len(result) + 1):
    for col in range(0, len(fields)):
        if (fields[col][0] <> 'pt'):
            sheet.write(row, col, u'%s' % result[row-1][col])

# workbook.save(r'/alidata/workspace/aml/work/wine.xls')
workbook.save(r'c:/Users/jerry/Desktop/wine.xls')