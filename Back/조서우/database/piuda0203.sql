-- MySQL dump 10.13  Distrib 8.0.36, for Win64 (x86_64)
--
-- Host: localhost    Database: piuda
-- ------------------------------------------------------
-- Server version	8.0.36

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `books`
--

DROP TABLE IF EXISTS `books`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `books` (
  `book_isbn` varchar(100) NOT NULL,
  `book_title` varchar(100) NOT NULL,
  `publisher` varchar(100) NOT NULL,
  `book_size` varchar(100) DEFAULT NULL,
  `book_price` int NOT NULL DEFAULT '0',
  `book_classification` varchar(50) NOT NULL,
  `book_media` varchar(50) NOT NULL,
  `book_series` varchar(50) DEFAULT NULL,
  `field_name` varchar(50) NOT NULL,
  `book_id` varchar(100) NOT NULL,
  `book_ii` varchar(100) NOT NULL,
  `library` varchar(50) NOT NULL,
  `location` varchar(100) NOT NULL,
  `borrowed` tinyint(1) NOT NULL DEFAULT '0',
  `reserved` tinyint(1) NOT NULL DEFAULT '0',
  `author` varchar(100) NOT NULL,
  PRIMARY KEY (`book_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `books`
--

LOCK TABLES `books` WRITE;
/*!40000 ALTER TABLE `books` DISABLE KEYS */;
INSERT INTO `books` VALUES ('9791185014517','몽환화','비채, 2014','428 p. ; 20 cm ;',13800,'833.6','인쇄자료(책자형)',NULL,'문학','AMA000136040','833.6-ㅎ961모','성동구립도서관','성동구립]보존서고1(3층)',0,1,'히가시노 게이고 [지음] ; 민경욱 옮김'),('9788972757467','매스커레이드 이브','현대문학, 2015','344 p. ; 19 cm ;',14000,'833.6','인쇄자료(책자형)','매스커레이드 시리즈;','문학','AMA000141390','833.6-ㅎ961무','성동구립도서관','[성동구립]제1자료열람실(3층)',1,0,'히가시노 게이고 지음 ; 양윤옥 옮김'),('9788972753698','용의자 X의 헌신','현대문학, 2015','404 p. ; 20 cm ;',13000,'833.6','인쇄자료(책자형)',NULL,'문학','AMA000144970','833.6-ㅎ961아=4','성동구립도서관','[성동구립]제1자료열람실(3층)',1,0,'히가시노 게이고 지음 ; 양억관 옮김'),('9788972758426','그대 눈동자에 건배 : 히가시노 게이고 소설집','현대문학, 2017','348 p. ; 19 cm ;',14000,'833.6','인쇄자료(책자형)',NULL,'문학','AMA000155963','833.6-ㅎ961규','성동구립도서관','[성동구립]제1자료열람실(3층)',0,1,'히가시노 게이고 지음 ; 양윤옥 옮김'),('9788972756194','나미야 잡화점의 기적','현대문학, 2012','455 p. ; 19 cm ;',14800,'833.6','인쇄자료(책자형)',NULL,'문학','AMA000168385','833.6-ㅎ961나=3','성동구립도서관','[성동구립]제1자료열람실(3층)',1,1,'히가시노 게이고 지음 ; 양윤옥 옮김'),('9791190885270','화성 연대기','현대문학, 2020','428 p. ; 21 cm ;',15000,'843.5','인쇄자료(책자형)',NULL,'문학','AMA000175132','843.5-ㅂ958ㅎ','성동구립도서관','[성동구립]제1자료열람실(3층)',1,0,'레이 브래드버리 지음 ; 조호근 옮김'),('9788972756194','나미야 잡화점의 기적','현대문학, 2012','455 p. ; 19 cm ;',14800,'833.6','인쇄자료(책자형)',NULL,'문학','AMA000177035','833.6-ㅎ961나=4','성동구립도서관','[성동구립]제1자료열람실(3층)',1,1,'히가시노 게이고 지음 ; 양윤옥 옮김'),('9791136264473','그녀는 다 계획이 있다 : 히가시노 게이고 장편소설','하빌리스, 2021','379 p. ; 20 cm ;',15800,'833.6','인쇄자료(책자형)',NULL,'문학','AMA000177672','833.6-ㅎ961ㄱ2','성동구립도서관','[성동구립]제1자료열람실(3층)',1,0,'히가시노 게이고 지음 ; 양윤옥 옮김'),('9788972757573','라플라스의 마녀 : 히가시노 게이고 장편소설','현대문학, 2016','521 p. ; 20 cm ;',14800,'833.6','인쇄자료(책자형)',NULL,'문학','AMA000183784','833.6-ㅎ961라=2','성동구립도서관','[성동구립]제1자료열람실(3층)',1,0,'히가시노 게이고 지음 ; 양윤옥 옮김'),('9788990982674','기린의 날개','재인, 2017','420 p. ; 20 cm ;',16800,'833.6','인쇄자료(책자형)',NULL,'문학','AMA000183798','833.6-ㅎ961구=2 ','성동구립도서관','[성동구립]제1자료열람실(3층)',1,0,'히가시노 게이고 지음 ; 김난주 옮김'),('9791167901040','유진과 데이브','현대문학, 2022','204 p. ; 19 cm ;',13000,'813.7','인쇄자료(책자형)',NULL,'문학','AMA000186211','813.7-ㅎ531ㅎ-40','성동구립도서관','[성동구립]제1자료열람실(3층)',1,0,'서수진 지음'),('9788972758945','모스크바의 신사','현대문학, 2018','723 p. ; 21 cm ;',18000,'843','인쇄자료(책자형)',NULL,'문학','AMA000192817','843-ㅌ82ㅁ=2','성동구립도서관','[성동구립]제1자료열람실(3층)',1,1,'에이모 토울스 지음 ; 서창렬 옮김'),('9791167901187','연을 쫓는 아이','현대문학, 2022','560 p. ; 21 cm ;',16000,'843','인쇄자료(책자형)',NULL,'문학','AMB000037434','843-호53ㅇ','무지개도서','[무지개]문헌정보실',1,0,'할레드 호세이니 지음 ; 왕은철 옮김'),('9791192483146','희망의 끈','재인, 2022','468 p. ; 19 cm ;',18800,'833.6','인쇄자료(책자형)',NULL,'문학','AMB000038027','833.6-히11허','무지개도서관','[무지개]문헌정보실',1,0,'히가시노 게이고 지음 ; 김난주 옮김'),('9788925576633','블랙 쇼맨과 환상의 여자','알에이치코리아, 2023','232 p. ; 19 cm ;',18000,'833.6','인쇄자료(책자형)','블랙 쇼맨 시리즈;','문학','AMB000038325','833.6-히11벼','무지개도서관','[무지개]문헌정보실',1,0,'히가시노 게이고 지음 ; 양윤옥 옮김'),('9788997722396','백은의 잭','씨엘북스, 2016','444 p. ; 21 cm ;',12000,'833.6','인쇄자료(책자형)',NULL,'문학','AMC000048107','833.6-ㅎ961ㅂ','금호도서관','[금호]문헌정보실',1,0,'히가시노 게이고 지음 ; 한성례 옮김'),('9788972756194','나미야 잡화점의 기적','현대문학, 2012','455 p. ; 19 cm ;',14800,'833.6','인쇄자료(책자형)',NULL,'문학','AMC000060459','833.6-ㅎ961나=4','금호도서관','[금호]문헌정보실',1,1,'히가시노 게이고 지음 ; 양윤옥 옮김'),('9788972759980','파랑대문','현대문학, 2019','211 p. ; 19 cm ;',11200,'813.7','인쇄자료(책자형)','현대문학 핀 시리즈 소설선=','문학','AMD000057957','813.7-ㅊ588ㅍ','용답도서관','[용답]문헌정보실',1,0,'최윤 지음'),('9788972756194','나미야 잡화점의 기적','현대문학, 2022','455 p. ; 20 cm ;',14500,'833.6','인쇄자료(책자형)',NULL,'문학','AME000034358','833.6-ㅎ961ㄴ2','성수도서관','[성수]문헌정보실',0,1,'히가시노 게이고 지음 ; 양윤옥 옮김'),('9788972756194','나미야 잡화점의 기적:히가시노 게이고 장편소설','현대문학, 2012','455 p. ; 19 cm ;',14800,'833.6','인쇄자료(책자형)',NULL,'문학','AMF000021861','S 833.6-ㅎ961ㄴ','청계도서관','[청계]문헌정보실',1,1,'히가시노 게이고 지음 ; 양윤옥 옮김');
/*!40000 ALTER TABLE `books` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `event`
--

DROP TABLE IF EXISTS `event`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `event` (
  `event_id` int NOT NULL AUTO_INCREMENT,
  `event_library` varchar(255) DEFAULT NULL,
  `event_name` varchar(255) DEFAULT NULL,
  `event_date` date DEFAULT NULL,
  PRIMARY KEY (`event_id`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `event`
--

LOCK TABLES `event` WRITE;
/*!40000 ALTER TABLE `event` DISABLE KEYS */;
INSERT INTO `event` VALUES (1,'성동구립','휴관일','2024-01-01'),(2,'성동구립','휴관일','2024-01-08'),(3,'성동구립','휴관일','2024-01-15'),(4,'성동구립','휴관일','2024-01-22'),(5,'성동구립','휴관일','2024-01-29'),(6,'성동구립','[메이커 창·취UP] 3D프린팅 입문 -슬기로운 3D프린팅 생활-','2024-01-04'),(7,'성수','2024년 겨울 독서교실 <성수 문학소년소녀>','2024-01-09'),(8,'성동구립','[러닝 메이커스] 꼬마 예술가 어린이 3D펜 명화 그리기','2024-01-10'),(9,'성동구립','[메이커 창·취UP] 3D프린팅 입문 -슬기로운 3D프린팅 생활-','2024-01-11'),(10,'성동구립','[러닝 메이커스] 꼬마 예술가 어린이 3D펜 명화 그리기','2024-01-17'),(11,'성동구립','[메이커 창·취UP] 3D프린팅 입문 -슬기로운 3D프린팅 생활-','2024-01-18'),(12,'성동구립','[러닝 메이커스] 꼬마 예술가 어린이 3D펜 명화 그리기','2024-01-24'),(13,'성동구립','[메이커 창·취UP] 3D프린팅 입문 -슬기로운 3D프린팅 생활-','2024-01-25'),(14,'성동구립','성동구립도서관 1월 영어스토리텔링 수업','2024-01-28'),(15,'성동구립','[러닝 메이커스] 꼬마 예술가 어린이 3D펜 명화 그리기','2024-01-31'),(16,'성동구립','[2월 성인]누구나 할 수 있는 성인 3D펜 공예','2024-02-01'),(17,'성동구립','성동구립도서관 2월 자원봉사 OT','2024-02-03'),(18,'성동구립','[2월 어린이 코딩]시뮬레이터로 아두이노 배우기','2024-02-04'),(19,'성동구립','[2월 어린이]어린이 3D펜 수업','2024-02-07'),(20,'성동구립','[2월 성인]누구나 할 수 있는 성인 3D펜 공예','2024-02-08'),(21,'성동구립','[2월 어린이]어린이 3D펜 수업','2024-02-14'),(22,'성동구립','[2월 성인]누구나 할 수 있는 성인 3D펜 공예','2024-02-15'),(23,'성동구립','휴관일','2024-02-11'),(24,'성동구립','[2월 어린이 코딩]시뮬레이터로 아두이노 배우기','2024-02-11'),(25,'성수','휴관일','2024-01-01'),(26,'성수','휴관일','2024-01-08'),(27,'성수','휴관일','2024-01-15'),(28,'성수','휴관일','2024-01-22'),(29,'성수','휴관일 ','2024-01-29'),(30,'성수','2024년 겨울 독서교실 <성수 문학소년소녀>','2024-01-10'),(31,'성수','2024년 겨울 독서교실 <성수 문학소년소녀>','2024-01-11'),(32,'성수','2024년 겨울 독서교실 <성수 문학소년소녀>','2024-01-12'),(33,'성수','휴관일','2024-02-11'),(34,'성수','휴관일','2024-02-05'),(35,'성수','휴관일','2024-02-12'),(36,'성수','휴관일','2024-02-19'),(37,'성수','휴관일','2024-02-26'),(38,'성수','휴관일','2024-02-10'),(39,'성수','휴관일','2024-02-09');
/*!40000 ALTER TABLE `event` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `loan`
--

DROP TABLE IF EXISTS `loan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `loan` (
  `loan_id` int NOT NULL AUTO_INCREMENT,
  `user_id` bigint DEFAULT NULL,
  `book_id` varchar(100) DEFAULT NULL,
  `loan_date` date NOT NULL,
  `expect_date` date DEFAULT NULL,
  `return_date` date DEFAULT NULL,
  `return_status` tinyint(1) NOT NULL DEFAULT '0',
  `extend_status` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`loan_id`),
  KEY `user_id` (`user_id`),
  KEY `book_id` (`book_id`),
  CONSTRAINT `loan_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `loan_ibfk_2` FOREIGN KEY (`book_id`) REFERENCES `books` (`book_id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `loan`
--

LOCK TABLES `loan` WRITE;
/*!40000 ALTER TABLE `loan` DISABLE KEYS */;
INSERT INTO `loan` VALUES (12,2,'AMA000168385','2024-02-02','2024-02-26',NULL,0,1);
/*!40000 ALTER TABLE `loan` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `review`
--

DROP TABLE IF EXISTS `review`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `review` (
  `review_id` int NOT NULL AUTO_INCREMENT,
  `loan_id` int NOT NULL,
  `review_score` int NOT NULL,
  `review_date` date NOT NULL,
  `review_content` varchar(5000) NOT NULL,
  PRIMARY KEY (`review_id`),
  KEY `loan_id` (`loan_id`),
  CONSTRAINT `review_ibfk_1` FOREIGN KEY (`loan_id`) REFERENCES `loan` (`loan_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `review`
--

LOCK TABLES `review` WRITE;
/*!40000 ALTER TABLE `review` DISABLE KEYS */;
INSERT INTO `review` VALUES (1,12,4,'2024-02-02','ㅎㅎ'),(2,12,4,'2024-02-03','ㅋㅋㅋㅋㅋㅋㅋ');
/*!40000 ALTER TABLE `review` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reviewcondition`
--

DROP TABLE IF EXISTS `reviewcondition`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reviewcondition` (
  `condition_id` int NOT NULL AUTO_INCREMENT,
  `loan_id` int DEFAULT NULL,
  `loss_score` int NOT NULL,
  `taint_score` int NOT NULL,
  `condition_op` text,
  `condition_date` date NOT NULL,
  PRIMARY KEY (`condition_id`),
  KEY `loan_id` (`loan_id`),
  CONSTRAINT `reviewcondition_ibfk_1` FOREIGN KEY (`loan_id`) REFERENCES `loan` (`loan_id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reviewcondition`
--

LOCK TABLES `reviewcondition` WRITE;
/*!40000 ALTER TABLE `reviewcondition` DISABLE KEYS */;
INSERT INTO `reviewcondition` VALUES (14,12,1,3,'','2024-02-04');
/*!40000 ALTER TABLE `reviewcondition` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `userbooking`
--

DROP TABLE IF EXISTS `userbooking`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `userbooking` (
  `reserve_id` int NOT NULL AUTO_INCREMENT,
  `user_id` bigint DEFAULT NULL,
  `book_id` varchar(100) DEFAULT NULL,
  `reserve_date` date DEFAULT NULL,
  PRIMARY KEY (`reserve_id`),
  KEY `user_id` (`user_id`),
  KEY `book_id` (`book_id`),
  CONSTRAINT `userbooking_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `userbooking_ibfk_2` FOREIGN KEY (`book_id`) REFERENCES `books` (`book_id`)
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `userbooking`
--

LOCK TABLES `userbooking` WRITE;
/*!40000 ALTER TABLE `userbooking` DISABLE KEYS */;
INSERT INTO `userbooking` VALUES (40,2,'AMC000060459','2024-02-01'),(41,2,'AMF000021861','2024-02-01');
/*!40000 ALTER TABLE `userbooking` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `userinterestbook`
--

DROP TABLE IF EXISTS `userinterestbook`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `userinterestbook` (
  `interest_id` int NOT NULL AUTO_INCREMENT,
  `user_id` bigint DEFAULT NULL,
  `book_id` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`interest_id`),
  KEY `user_id` (`user_id`),
  KEY `book_id` (`book_id`),
  CONSTRAINT `userinterestbook_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `userinterestbook_ibfk_2` FOREIGN KEY (`book_id`) REFERENCES `books` (`book_id`)
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `userinterestbook`
--

LOCK TABLES `userinterestbook` WRITE;
/*!40000 ALTER TABLE `userinterestbook` DISABLE KEYS */;
INSERT INTO `userinterestbook` VALUES (11,1,'AMA000168385'),(41,2,'AMA000168385');
/*!40000 ALTER TABLE `userinterestbook` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` bigint NOT NULL,
  `user_name` varchar(50) NOT NULL,
  `user_status` varchar(50) NOT NULL DEFAULT '정상',
  `barcode_img` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'서지현','정상','https://piudabucket.s3.ap-southeast-2.amazonaws.com/11103524002214.jpg'),(2,'sw','정상','https://piudabucket.s3.ap-southeast-2.amazonaws.com/11103524002214.jpg'),(4,'dfs','sdfs','f'),(11103524002214,'서지현','정상','https://piudabucket.s3.ap-southeast-2.amazonaws.com/11103524002214.jpg');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-02-04  5:50:44
