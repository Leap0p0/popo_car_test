CREATE TABLE `car_test` (
	`name` varchar(50) NOT NULL,
	`in_test` int(11) NOT NULL DEFAULT '0',

	PRIMARY KEY (`name`)
);

INSERT INTO `car_test` VALUES ('car_test', 0);