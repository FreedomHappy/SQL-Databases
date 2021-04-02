
SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for date_group
-- ----------------------------
DROP TABLE IF EXISTS `date_group`;
CREATE TABLE `date_group` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `ei` bigint(20) NOT NULL,
  `day` varchar(25) DEFAULT NULL COMMENT '日期',
  `openPrice` decimal(25,2) DEFAULT NULL COMMENT '开盘价',
  `closePrice` decimal(25,2) DEFAULT NULL COMMENT '收盘价',
  `lowPrice` decimal(25,2) DEFAULT NULL COMMENT '最低价',
  `higPrice` decimal(25,2) DEFAULT NULL COMMENT '最高价',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of date_group
-- ----------------------------
INSERT INTO `date_group` VALUES ('1', '10001', '20161230', '10.00', '20.00', '5.00', '25.00');
INSERT INTO `date_group` VALUES ('2', '10001', '20161231', '11.00', '19.00', '6.00', '26.00');
INSERT INTO `date_group` VALUES ('3', '10001', '20170101', '12.00', '18.00', '7.00', '27.00');
INSERT INTO `date_group` VALUES ('5', '10001', '20170102', '12.00', '18.00', '7.00', '27.00');
INSERT INTO `date_group` VALUES ('6', '10001', '20170203', '13.00', '19.00', '8.00', '21.00');
INSERT INTO `date_group` VALUES ('7', '10001', '20170204', '15.00', '20.00', '9.00', '24.00');
INSERT INTO `date_group` VALUES ('8', '10001', '20170205', '13.00', '12.00', '4.00', '27.00');
INSERT INTO `date_group` VALUES ('9', '10001', '20170206', '12.00', '13.00', '5.00', '25.00');
INSERT INTO `date_group` VALUES ('10', '10001', '20180109', '14.00', '11.00', '6.00', '22.00');
INSERT INTO `date_group` VALUES ('11', '10001', '20180110', '17.00', '18.00', '8.00', '23.00');
INSERT INTO `date_group` VALUES ('12', '10001', '20180111', '19.00', '12.00', '9.00', '22.00');
INSERT INTO `date_group` VALUES ('13', '10001', '20180112', '13.00', '16.00', '2.00', '25.00');
INSERT INTO `date_group` VALUES ('14', '10001', '20180113', '11.00', '17.00', '1.00', '28.00');
INSERT INTO `date_group` VALUES ('15', '10001', '20180114', '10.00', '13.00', '8.00', '24.00');
INSERT INTO `date_group` VALUES ('16', '10002', '20161230', '15.00', '22.00', '5.00', '25.00');
INSERT INTO `date_group` VALUES ('17', '10002', '20161231', '13.00', '19.00', '6.00', '22.00');
INSERT INTO `date_group` VALUES ('18', '10002', '20170101', '12.00', '14.00', '7.00', '23.00');
INSERT INTO `date_group` VALUES ('19', '10002', '20170102', '14.00', '18.00', '7.00', '22.00');
INSERT INTO `date_group` VALUES ('20', '10002', '20170203', '17.00', '12.00', '8.00', '23.00');
INSERT INTO `date_group` VALUES ('21', '10002', '20170204', '19.00', '20.00', '9.00', '22.00');
INSERT INTO `date_group` VALUES ('22', '10002', '20170205', '13.00', '17.00', '4.00', '22.00');
INSERT INTO `date_group` VALUES ('23', '10002', '20170206', '11.00', '13.00', '6.00', '25.00');
INSERT INTO `date_group` VALUES ('24', '10002', '20180109', '10.00', '17.00', '8.00', '28.00');
INSERT INTO `date_group` VALUES ('25', '10002', '20180110', '17.00', '18.00', '7.00', '24.00');
INSERT INTO `date_group` VALUES ('26', '10002', '20180111', '19.00', '25.00', '8.00', '22.00');
INSERT INTO `date_group` VALUES ('27', '10002', '20180112', '13.00', '19.00', '9.00', '25.00');
INSERT INTO `date_group` VALUES ('28', '10002', '20180113', '15.00', '26.00', '4.00', '28.00');
INSERT INTO `date_group` VALUES ('29', '10002', '20180114', '13.00', '16.00', '5.00', '24.00');


select * from date_group;
/* 按年 */
-- 第一种
SELECT a.ei, a.day, DATE_FORMAT(a.day,'%Y') year, SUM(a.openPrice) FROM date_group AS a GROUP BY a.ei, year;
-- 第二种
SELECT a.ei, a.day, YEAR(a.day) year, AVG(a.closePrice) FROM date_group AS a GROUP BY a.ei, year;

/* 按季度 */
-- 注意区分出 年
-- 第一种
SELECT a.ei, a.day, CONCAT(YEAR(a.day),FLOOR((date_format(a.day, '%m')+2)/3)) quarter, SUM(a.openPrice) FROM date_group AS a GROUP BY a.ei, quarter;
-- 第二种
SELECT a.ei, a.day, CONCAT(YEAR(a.day),QUARTER(a.day)) quarter, AVG(a.closePrice) FROM date_group AS a GROUP BY a.ei, quarter;

/* 按月 */
-- 第一种
SELECT a.ei, a.day, date_format(a.day, '%Y%m') month, SUM(a.openPrice) FROM date_group AS a GROUP BY a.ei, month;

-- 第二种
-- month(date)函数 和 %c 差不多，返回的是月的值（如一月为 ‘1’）
SELECT a.ei, a.day, CONCAT(YEAR(a.day),MONTH(a.day)) month, AVG(a.closePrice) FROM date_group AS a GROUP BY a.ei, month;
SELECT a.ei, a.day, date_format(a.day, '%Y%c') month, AVG(a.closePrice) FROM date_group AS a GROUP BY a.ei, month;

/* 按周 */

-- 第一种
-- 以周一为一周起始，所以20170101周日，为2016年最后一周，20170102 为2017年第一周
SELECT a.ei, a.day, date_format(a.day, '%x%v') week, SUM(a.lowPrice) FROM date_group AS a GROUP BY a.ei, week;
SELECT a.ei, a.day, (UNIX_TIMESTAMP(a.day) - (if(date_format(a.day, '%w'), date_format(a.day, '%w') - 1, 6) * 86400) - 316800) / 604800 week, SUM(a.lowPrice) FROM date_group AS a GROUP BY a.ei, week;


-- 第二种
-- 以周日为一周起始，所以20170101位2017年第一周
SELECT a.ei, a.day, date_format(a.day, '%X%V') week, SUM(a.lowPrice) FROM date_group AS a GROUP BY a.ei, week;
SELECT a.ei, a.day, (UNIX_TIMESTAMP(a.day) - date_format(a.day, '%w') * 86400 - 316800) / 604800 week, SUM(a.lowPrice) FROM date_group AS a GROUP BY a.ei, week;


/* 按天 */
select date_format('20161230', '%Y%u') week;

SELECT a.ei, a.day, date_format(a.day, '%x%v') week FROM date_group AS a


CREATE TABLE `date_group1` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `ei` bigint(20) NOT NULL,
  `day` varchar(25) DEFAULT NULL COMMENT '日期',
  `openPrice` decimal(25,2) DEFAULT NULL COMMENT '开盘价',
  `closePrice` decimal(25,2) DEFAULT NULL COMMENT '收盘价',
  `lowPrice` decimal(25,2) DEFAULT NULL COMMENT '最低价',
  `higPrice` decimal(25,2) DEFAULT NULL COMMENT '最高价',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8;

select sum(openPrice) from date_group1;
