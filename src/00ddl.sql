CREATE TABLE `rpt_fxq_manual_company_ms` (
  `head_no` varchar(20) DEFAULT NULL COMMENT '法人机构报告机构编码',
  `company_code1` varchar(20) DEFAULT NULL COMMENT '机构网点代码',
  `company_code2` varchar(16) DEFAULT NULL COMMENT '金融机构编码',
  `company_name` varchar(160) DEFAULT NULL COMMENT '机构名称',
  `bord_flag` varchar(2) DEFAULT NULL COMMENT '境内外标识',
  `pt` varchar(15) DEFAULT NULL COMMENT '分区字段'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='机构对照表'
/*!50500 PARTITION BY RANGE  COLUMNS(pt)
(PARTITION pt20190822000000 VALUES LESS THAN ('20190822999999') ENGINE = InnoDB,
 PARTITION pt20191013000000 VALUES LESS THAN ('20191013999999') ENGINE = InnoDB,
 PARTITION future VALUES LESS THAN ('99991231999999') ENGINE = InnoDB) */