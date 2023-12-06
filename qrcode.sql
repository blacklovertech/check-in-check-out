-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Dec 06, 2023 at 12:32 PM
-- Server version: 8.0.30
-- PHP Version: 8.1.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `qrcode`
--

-- --------------------------------------------------------

--
-- Table structure for table `checkin_records`
--

CREATE TABLE `checkin_records` (
  `id` int NOT NULL,
  `user_id` int DEFAULT NULL,
  `checkin_time` datetime NOT NULL,
  `checkout_time` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `checkin_records`
--

INSERT INTO `checkin_records` (`id`, `user_id`, `checkin_time`, `checkout_time`) VALUES
(1, 1, '2023-12-07 10:36:22', '2023-12-07 12:10:00'),
(2, 1, '2023-12-07 10:36:40', '2023-12-07 10:40:40'),
(3, 1, '2023-12-06 10:46:48', '2023-12-06 10:46:51'),
(4, 1, '2023-12-06 12:43:49', '2023-12-06 12:55:29'),
(5, 1, '2023-12-06 12:56:26', '2023-12-06 12:57:10'),
(6, 1, '2023-12-06 13:00:54', '2023-12-06 13:01:59'),
(7, 1, '2023-12-06 13:02:10', '2023-12-06 13:03:12'),
(8, 1, '2023-12-06 13:04:19', '2023-12-06 13:04:21'),
(9, 2, '2023-12-06 13:04:44', '2023-12-06 13:07:03'),
(10, 1, '2023-12-06 13:08:58', '2023-12-06 13:09:05'),
(11, 1, '2023-12-06 13:12:23', '2023-12-06 13:12:49'),
(12, 2, '2023-12-06 13:12:57', '2023-12-06 13:34:50'),
(13, 1, '2023-12-06 13:13:52', '2023-12-06 13:25:43'),
(14, 1, '2023-12-06 13:26:38', '2023-12-06 13:26:48'),
(15, 1, '2023-12-06 13:26:52', '2023-12-06 13:27:21'),
(16, 1, '2023-12-06 13:27:37', '2023-12-06 13:31:09'),
(17, 1, '2023-12-06 13:36:33', '2023-12-06 13:36:49'),
(18, 2, '2023-12-06 13:36:56', '2023-12-06 13:38:41'),
(19, 1, '2023-12-06 13:37:10', '2023-12-06 13:38:32'),
(20, 1, '2023-12-06 13:40:02', '2023-12-06 13:40:33'),
(21, 2, '2023-12-06 13:40:39', '2023-12-06 16:03:02'),
(22, 1, '2023-12-06 13:41:02', '2023-12-06 13:41:15'),
(23, 1, '2023-12-06 13:41:19', '2023-12-06 13:50:24'),
(24, 1, '2023-12-06 15:49:24', '2023-12-06 16:05:07'),
(25, 2, '2023-12-06 16:04:52', '2023-12-06 16:05:01'),
(26, 1, '2023-12-06 17:31:26', '2023-12-06 17:33:32'),
(27, 2, '2023-12-06 17:34:33', '2023-12-06 17:35:25'),
(28, 1, '2023-12-06 17:35:16', '2023-12-06 17:35:53'),
(29, 1, '2023-12-06 17:36:20', '2023-12-06 17:36:25');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int NOT NULL,
  `full_name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `mobile` bigint NOT NULL,
  `role` varchar(250) NOT NULL,
  `month` varchar(250) NOT NULL,
  `gender` varchar(250) NOT NULL,
  `uuid_intern` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `full_name`, `email`, `mobile`, `role`, `month`, `gender`, `uuid_intern`) VALUES
(1, 'Janarthanan', 'janasuba2307@gmail.com', 9994714078, 'Admin', 'DEC', 'Male', 'ADMIN_1'),
(2, 'Vignesh', 'retrotech90@gmail.com', 0, 'Admin', 'NIL', 'Male', 'ADMIN_2'),
(107, 'Aakash Shetty', 'aakashberi4809@gmail.com', 8328601314, 'Python Developer,Ml & Ai Developer', 'December', 'Male', 'INTD_23001'),
(108, 'M. Mohamed Adnan', '9921008020@klu.ac.in', 9486775256, 'Python Programmer', 'December', 'Male', 'INTD_23002'),
(109, 'Tarun', 'iamtarun2003@gmail.com', 8778738627, 'Ui/Ux & Designer', 'December', 'Male', 'INTD_23003'),
(110, 'Suhana Fathima S', '9921008099@klu.ac.in', 9361965279, 'IOT & Web Developer', 'December', 'Female', 'INTD_23004'),
(111, 'K.Mugeshwaran', '9921004461@klu.ac.in', 9342624270, 'Network Engineer', 'December', 'Male', 'INTD_23005'),
(112, 'D Darshan', 'ddarshan1312@gmail.com', 7204051765, 'C++/C,Python Programmer', 'December', 'Male', 'INTD_23006'),
(113, 'B M Bharath', 'bharathbm83@gmail.com', 9861208416, 'Flutter,Python', 'December', 'Male', 'INTD_23007'),
(114, 'K ASFAQ AHAMED', 'asfaqahamedmdu@gmail.com', 9585844454, 'App developer,Java Programmer', 'December', 'Male', 'INTD_23008'),
(115, 'Bhavanam Samyuktha', 'samyukthareddybhavanam03@gmail.com', 9398787069, 'App developer,Web Developer', 'December', 'Female', 'INTD_23009'),
(116, 'MUHAMAD NAJMUDEEN R', '9921008021@klu.ac.in', 8825410483, 'Software Tester (Manual & Automation)', 'December', 'Male', 'INTD_23010'),
(117, 'VASUDEVAN M', '99220040383@klu.ac.in', 7397597032, 'IOT Engineer', 'December', 'Male', 'INTD_23011'),
(118, 'Bandaru Sathwika Raj', 'sathwikarajbandaru@gmail.com', 9441950223, 'Ai develoepr,Python Programmer', 'December', 'Female', 'INTD_23012'),
(119, 'THIRUPATHI VENKATESH. S', '9921004723@klu.ac.in', 9025559101, '0UI/UX Designer', 'December', 'Male', 'INTD_23013'),
(120, 'S.SANTHOSHKUMAR', 's.santhoshkumar200329@gamil.com', 7395873535, 'Civil Engineer, AUTOCAD SOFTWARE', 'December', 'Male', 'INTD_23014'),
(121, 'Palle Varshith', '9921004528@klu.ac.in', 7207010295, 'Web Developer', 'December', 'Male', 'INTD_23015'),
(122, 'Dindukurthi Sumanth', 'dsumanth094@gmail.com', 8309665094, 'Web Developer', 'December', 'Male', 'INTD_23016'),
(123, 'Bingi Pranith Ram', 'bingipranithram@gmail.com', 8497964733, 'UI/Ux  Designer ,Web Dev ', 'December', 'Male', 'INTD_23017'),
(124, 'GUDA ABIGNAN REDDY', 'abhignan2003@gmail.com', 8919380958, 'Pentester', 'December', 'Male', 'INTD_23018'),
(125, 'sethumadhavan R', '99220040728@klu.ac.in', 917708402869, 'IOT Engineer', 'December', 'Male', 'INTD_23019'),
(126, 'Md Ashraf ali', 'ashraf5855ali@gmail.com', 8210262286, 'Web Developer, Java Programmer', 'December', 'Male', 'INTD_23020'),
(127, 'ATUKURI JEEVANA KAVYA SAI RUKMINI', '9921004052@klu.ac.in', 7013199737, 'Web Developer, App Developer', 'December', 'Female', 'INTD_23021'),
(128, 'PENMETSA SAI VARDHAN', 'sai.vardhan151103@gmail.com', 9492170279, 'IOT Engineer', 'December', 'Male', 'INTD_23022'),
(129, 'Darasan R', 'shanmugamdarasan@gmail.com', 9361547043, 'Python, Web', 'December', 'Male', 'INTD_23023'),
(130, 'RAJAN KUMAR MISHRA', 'rajanmishra1728@gmail.com', 7050255569, 'Ai & Ml', 'December', 'Male', 'INTD_23024'),
(131, 'T.SANTHOSH', '9921008132@klu.ac.in', 8148983135, 'App & Python Dev', 'January', 'Male', 'INTD_23025'),
(132, 'S.Ahilamuneeswaran', 'ahil2003abc@gmail.com', 6383391783, 'web & pyhton', 'January', 'Male', 'INTD_23026'),
(133, 'Ratna Selvan S', 'selvanratna1@gmail.com', 8248368596, 'App & java', 'January', 'Male', 'INTD_23027'),
(134, 'Sachin Sahadev Singh', '99210041113@klu.ac.in', 9360392224, 'python and database', 'January', 'Male', 'INTD_23028'),
(135, 'Hariprasanna Balasubramanian', 'hariprasanna3411@gmail.com', 8667783091, 'python and java', 'January', 'Male', 'INTD_23029'),
(136, 'Vignesh.C', 'cvignesh112@gmail.com', 9345864606, 'web developer', 'January', 'Male', 'INTD_23030'),
(137, 'Md Shahid Alam', 'mdshahidalam749@gmail.com', 6200839232, 'web & Software engineer', 'December', 'Male', 'INTD_23031'),
(138, 'Madhav kumar', '99210041470@klu.ac.in', 8936845863, 'AI & ML Developer', 'December', 'Male', 'INTD_23032'),
(139, 'sethumadhavan R', 'chandrabosechandrabose9@gmail.com', 917708402869, 'IOT Engineer, IOT Solution Architect', 'December', 'Male', 'INTD_23033'),
(140, 'Raviprasath SP', 'raviprasath1446@gmail.com', 7845067629, '3D desinger', 'January', 'Male', 'INTD_23034'),
(141, 'Nandyala Vivek Reddy', 'ncryptedcat@gmail.com', 6301126906, 'NAY', 'January', 'Male', 'INTD_23035'),
(142, 'Shivam kumar', '99210041709@klu.ac.in', 7361041411, 'Ai & ML', 'December', 'Male', 'INTD_23036'),
(143, 'GUNDRA RAMYA SREE', '99210041768@klu.ac.in', 9573202574, 'Web Developer, Python Programmer', 'December', 'Female', 'INTD_23037'),
(144, 'GUNDRA RAMYA SREE', 'gundra.ramyasree@gmail.com', 9573202574, 'Web Developer, Java Programmer', 'December', 'Female', 'INTD_23038'),
(145, 'INTURI YASHVANTH SAI RAGHAVA REDDY', '9921004270@klu.ac.in', 9347834904, 'Web Developer, Python Programmer', 'December', 'Male', 'INTD_23039'),
(146, 'JANAHAN K', 'janahandarwin4@gmail.com', 8148025618, 'Python and Data Engineering', 'December', 'Male', 'INTD_23040'),
(147, 'Shiva Prasath S B', 'shivaprasath018@gmail.com', 7092165444, 'AI Developer', 'January', 'Male', 'INTD_23041'),
(148, 'Paidimarri Nithish', 'nithishpaidimarri@gmail.com', 6300536214, 'ML & Python Programmer', 'January', 'Male', 'INTD_23042'),
(149, 'NAVEEN S', '99210041892@klu.ac.in', 9345642102, 'Web & Ui', 'January', 'Male', 'INTD_23043'),
(150, 'NAGARAJAN R', '9921004929@klu.ac.in', 9080121569, 'WEB & UI developer', 'January', 'Male', 'INTD_23044'),
(151, 'Harish Raja Selvan S', 'harish14rs@gmail.com', 6379613919, 'Databased and Data Analyst', 'December', 'Male', 'INTD_23045'),
(152, 'NIGILESH J', '9921004815@klu.ac.in', 9345884701, 'Python - Web Developer', 'January', 'Male', 'INTD_23046'),
(153, 'B. Navaneethakrishna', 'bnavaneethakrishna4@gmail.com', 9092726452, 'Web & Python', 'January', 'Male', 'INTD_23047'),
(154, 'Karnatakam Anvitha', '9921004326@klu.ac.in', 9392327783, 'ML & Python', 'January', 'Female', 'INTD_23048'),
(155, 'KARANAM SAI SHARAN', '99210041051@klu.ac.in', 9392160035, 'ML & Python', 'January', 'Male', 'INTD_23049'),
(156, 'Ramsubramanyam V G', '9921004605@klu.ac.in', 9363232566, 'Python and Java', 'January', 'Male', 'INTD_23050'),
(157, 'Harrikisan M', '99210041429@klu.ac.in', 99210041429, 'web & Java - Android Dev', 'January', 'Male', 'INTD_23051'),
(158, 'Venuprasad S A', '9921004769@klu.ac.in', 9677386016, 'Web Dev & UI/UX', 'December', 'Male', 'INTD_23052'),
(159, 'Subhalakshmi', '9921004173@klu.ac.in', 8489647350, 'Python - Data Engineer', 'December', 'Female', 'INTD_23053'),
(160, 'Veera Akilan V', 'veeraakilan007@gmail.com', 9500545131, 'Web Developer', 'December', 'Male', 'INTD_23054'),
(161, 'Kerthiga. K', 'Kerthiga0706@gmail.com', 9345646832, 'Web Develper ,Data Analyst', 'December', 'Female', 'INTD_23055'),
(162, 'Harish Sakthi V', '9921004262@klu.ac.in', 9994624524, 'App Developer ', 'December', 'Male', 'INTD_23056'),
(163, 'Ashwin Ram S M', '9920008002@klu.ac.in', 9976137727, 'Web Developer - C#', 'December', 'Male', 'INTD_23057'),
(164, 'Paulsudhan R', 'paul11032003@gmail.com', 6381665312, 'Web Developer', 'January', 'Male', 'INTD_23058'),
(165, 'GADDAM LIKHITHA', '99210041721@klu.ac.in', 9392857751, 'Python ,Java,Data analyst', 'January', 'Female', 'INTD_23059'),
(166, 'RAYAVARAPU LAKSHMI NARASIMHA DINESH', 'rlndinesh@gmail.com', 6309721006, 'Python Programmer', 'January', 'Male', 'INTD_23060'),
(167, 'Bhandhewar Spandhana', 'spandhanabhandhewar@gmail.com', 9381262005, 'Web Developer in Python', 'January', 'Female', 'INTD_23061');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `checkin_records`
--
ALTER TABLE `checkin_records`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uuid_intern` (`uuid_intern`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `checkin_records`
--
ALTER TABLE `checkin_records`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=168;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `checkin_records`
--
ALTER TABLE `checkin_records`
  ADD CONSTRAINT `checkin_records_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
