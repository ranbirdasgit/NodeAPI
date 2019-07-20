-- phpMyAdmin SQL Dump
-- version 4.8.3
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Jul 20, 2019 at 05:05 PM
-- Server version: 10.1.36-MariaDB
-- PHP Version: 5.6.38

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `API`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`Ranbir_D`@`%` PROCEDURE `get_gender_report` (`from_date` VARCHAR(10), `to_date` VARCHAR(10))  BEGIN
SET SESSION group_concat_max_len = 1000000;
create temporary table count_data(
select gender,DateDayAdded from virtu_machine_daily_report where DateDayAdded between from_date and to_date and gender<>'' and TimeSpent>0.5 and 1.994086104*((chest*2)*39.37)+(-14.82946359)>=30);
SET @sql_dynamic = (
		SELECT
			GROUP_CONCAT( DISTINCT
				CONCAT('COUNT( IF(DateDayAdded = '
					, '''',DateDayAdded,''''
					, ', Gender,NULL) ) AS '
					, '`',DateDayAdded,'`'
				)
			)
		FROM count_data
	);
   SET @SQL = CONCAT('SELECT Gender, ', 
			  @sql_dynamic, '
			  
		   FROM count_data
		   GROUP BY gender'
           
	);
  --  select @sql;
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
drop temporary table count_data;
-- WITH ROLLUP
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `apiprofile`
--

CREATE TABLE `apiprofile` (
  `id` int(10) NOT NULL,
  `fname` varchar(10) NOT NULL,
  `lname` varchar(10) NOT NULL,
  `address` varchar(100) NOT NULL,
  `userid` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `apitoken`
--

CREATE TABLE `apitoken` (
  `id` int(10) NOT NULL,
  `userid` varchar(100) NOT NULL,
  `token` text NOT NULL,
  `datetime_added` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `apitoken`
--

INSERT INTO `apitoken` (`id`, `userid`, `token`, `datetime_added`) VALUES
(10, 'ranbir', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjpbeyJpZCI6MSwidXNlcm5hbWUiOiJyYW5iaXIiLCJlbWFpbCI6InJhbmJpcmRhc0BteXdvcmtmb3JjZSxvcmciLCJwYXNzd29yZCI6IiQyYSQxMCRRdzBacE5BLmFVOEZraFI3eUh0c2N1b1R1anZjclg5b1YvZkJMYXJLTmhOcTVaY2hCN3dtaSJ9XSwiaWF0IjoxNTYzNjM0OTE3LCJleHAiOjE1NjM2MzQ5Nzd9.dME0-09UtFfncudS2z78Ayl9OFApNIy0oHqG7rw0P7I', '2019-07-20 15:01:57');

-- --------------------------------------------------------

--
-- Table structure for table `apiuser`
--

CREATE TABLE `apiuser` (
  `id` int(10) NOT NULL,
  `username` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` text NOT NULL,
  `user_type` varchar(20) NOT NULL,
  `status` enum('1','0') NOT NULL,
  `datetime_added` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `apiuser`
--

INSERT INTO `apiuser` (`id`, `username`, `email`, `password`, `user_type`, `status`, `datetime_added`) VALUES
(1, 'ranbir', 'ranbirdas@myworkforce,org', '$2a$10$Qw0ZpNA.aU8FkhR7yHtscuoTujvcrX9oV/fBLarKNhNq5ZchB7wmi', 'admin', '1', '2018-01-25 15:11:36');

-- --------------------------------------------------------

--
-- Table structure for table `cg_overview`
--

CREATE TABLE `cg_overview` (
  `master_vendor_id` tinyint(3) DEFAULT NULL,
  `program` varchar(25) DEFAULT NULL,
  `area` varchar(25) DEFAULT NULL,
  `unit` varchar(50) DEFAULT NULL,
  `month` varchar(25) DEFAULT NULL,
  `locid` varchar(25) DEFAULT NULL,
  `amount` varchar(25) DEFAULT NULL,
  `quantity` varchar(100) DEFAULT NULL,
  `saving` varchar(100) DEFAULT NULL,
  `loc5` varchar(25) DEFAULT NULL,
  `loc4` varchar(25) DEFAULT NULL,
  `diocese_id` int(2) DEFAULT '1',
  `file_name` varchar(500) NOT NULL,
  `file_date` datetime NOT NULL,
  `account_number` varchar(100) DEFAULT NULL,
  `key_id` int(11) NOT NULL,
  `vendor_id` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `cg_overview`
--

INSERT INTO `cg_overview` (`master_vendor_id`, `program`, `area`, `unit`, `month`, `locid`, `amount`, `quantity`, `saving`, `loc5`, `loc4`, `diocese_id`, `file_name`, `file_date`, `account_number`, `key_id`, `vendor_id`) VALUES
(NULL, 'aa', 'aa', '1', '2018-09', 'ssss', '1', '12', 'w', 'ww', 'ww', 1, '', '0000-00-00 00:00:00', NULL, 1, 0);

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE `sessions` (
  `session_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `expires` int(11) UNSIGNED NOT NULL,
  `data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `apiprofile`
--
ALTER TABLE `apiprofile`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `apitoken`
--
ALTER TABLE `apitoken`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `apiuser`
--
ALTER TABLE `apiuser`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `cg_overview`
--
ALTER TABLE `cg_overview`
  ADD PRIMARY KEY (`key_id`),
  ADD KEY `locid` (`locid`),
  ADD KEY `loc4` (`loc4`),
  ADD KEY `loc5` (`loc5`),
  ADD KEY `area` (`area`),
  ADD KEY `month` (`month`),
  ADD KEY `amount` (`amount`),
  ADD KEY `unit` (`unit`),
  ADD KEY `quantity` (`quantity`),
  ADD KEY `saving` (`saving`),
  ADD KEY `comp1` (`program`,`saving`),
  ADD KEY `comp2` (`locid`,`diocese_id`,`month`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`session_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `apiprofile`
--
ALTER TABLE `apiprofile`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `apitoken`
--
ALTER TABLE `apitoken`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `apiuser`
--
ALTER TABLE `apiuser`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `cg_overview`
--
ALTER TABLE `cg_overview`
  MODIFY `key_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
