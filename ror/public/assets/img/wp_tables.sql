-- phpMyAdmin SQL Dump
-- version 3.4.9
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Mar 15, 2013 at 09:15 PM
-- Server version: 5.5.27
-- PHP Version: 5.3.15

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `wp_chuangxin`
--

-- --------------------------------------------------------

--
-- Table structure for table `wp_tables`
--

CREATE TABLE IF NOT EXISTS `wp_tables` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET latin1 DEFAULT NULL,
  `email` varchar(255) CHARACTER SET latin1 DEFAULT NULL,
  `page` varchar(255) CHARACTER SET latin1 DEFAULT NULL,
  `info` text CHARACTER SET latin1,
  `pname` varchar(255) CHARACTER SET latin1 DEFAULT NULL,
  `pinfo` text CHARACTER SET latin1,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=9 ;

--
-- Dumping data for table `wp_tables`
--

INSERT INTO `wp_tables` (`Id`, `name`, `email`, `page`, `info`, `pname`, `pinfo`) VALUES
(1, 'ss', 's', 's', 's', 's', 's'),
(2, '????', '???', 'aada', 'dsdqd', 'dqwdq', 'qwfqfqef'),
(3, '??', 'falcon.lux@gmail.com', 'xiang.lu', 'ssss', 'www', 'wwwwww'),
(4, '??', 'sss', 's', 's', 's', 's'),
(5, '??', 'sq', 's', 's', 's', 's'),
(6, 'äº†', 'asd', 'sa', 'asd', 'asd', 'da'),
(7, '?', 'asd', 'sd', 'sd', 'sd', 'def'),
(8, '???', 'a', 's', 's', 's', 's');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
