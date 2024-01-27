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
INSERT INTO `books` VALUES ('9791185014517','몽환화','비채, 2014','428 p. ; 20 cm ;',13800,'833.6','인쇄자료(책자형)',NULL,'문학','AMA000136040','833.6-ㅎ961모','성동구립도서관','성동구립]보존서고1(3층)',0,1,'히가시노 게이고 [지음] ; 민경욱 옮김'),('9788972756194','나미야 잡화점의 기적','현대문학, 2012','455 p. ; 19 cm ;',14800,'833.6','인쇄자료(책자형)',NULL,'문학','AMA000168385','833.6-ㅎ961나=3','성동구립도서관','[성동구립]제1자료열람실(3층)',1,1,'히가시노 게이고 지음 ; 양윤옥 옮김'),('9791190885270','화성 연대기','현대문학, 2020','428 p. ; 21 cm ;',15000,'843.5','인쇄자료(책자형)',NULL,'문학','AMA000175132','843.5-ㅂ958ㅎ','성동구립도서관','[성동구립]제1자료열람실(3층)',1,0,'레이 브래드버리 지음 ; 조호근 옮김'),('9788972756194','나미야 잡화점의 기적','현대문학, 2012','455 p. ; 19 cm ;',14800,'833.6','인쇄자료(책자형)',NULL,'문학','AMA000177035','833.6-ㅎ961나=4','성동구립도서관','[성동구립]제1자료열람실(3층)',1,1,'히가시노 게이고 지음 ; 양윤옥 옮김'),('9791136264473','그녀는 다 계획이 있다 : 히가시노 게이고 장편소설','하빌리스, 2021','379 p. ; 20 cm ;',15800,'833.6','인쇄자료(책자형)',NULL,'문학','AMA000177672','833.6-ㅎ961ㄱ2','성동구립도서관','[성동구립]제1자료열람실(3층)',1,0,'히가시노 게이고 지음 ; 양윤옥 옮김'),('9791167901040','유진과 데이브','현대문학, 2022','204 p. ; 19 cm ;',13000,'813.7','인쇄자료(책자형)',NULL,'문학','AMA000186211','813.7-ㅎ531ㅎ-40','성동구립도서관','[성동구립]제1자료열람실(3층)',1,0,'서수진 지음'),('9788972758945','모스크바의 신사','현대문학, 2018','723 p. ; 21 cm ;',18000,'843','인쇄자료(책자형)',NULL,'문학','AMA000192817','843-ㅌ82ㅁ=2','성동구립도서관','[성동구립]제1자료열람실(3층)',1,1,'에이모 토울스 지음 ; 서창렬 옮김'),('9791167901187','연을 쫓는 아이','현대문학, 2022','560 p. ; 21 cm ;',16000,'843','인쇄자료(책자형)',NULL,'문학','AMB000037434','843-호53ㅇ','무지개도서','[무지개]문헌정보실',1,0,'할레드 호세이니 지음 ; 왕은철 옮김'),('9791192483146','희망의 끈','재인, 2022','468 p. ; 19 cm ;',18800,'833.6','인쇄자료(책자형)',NULL,'문학','AMB000038027','833.6-히11허','무지개도서관','[무지개]문헌정보실',1,0,'히가시노 게이고 지음 ; 김난주 옮김'),('9788925576633','블랙 쇼맨과 환상의 여자','알에이치코리아, 2023','232 p. ; 19 cm ;',18000,'833.6','인쇄자료(책자형)','블랙 쇼맨 시리즈;','문학','AMB000038325','833.6-히11벼','무지개도서관','[무지개]문헌정보실',1,0,'히가시노 게이고 지음 ; 양윤옥 옮김'),('9788997722396','백은의 잭','씨엘북스, 2016','444 p. ; 21 cm ;',12000,'833.6','인쇄자료(책자형)',NULL,'문학','AMC000048107','833.6-ㅎ961ㅂ','금호도서관','[금호]문헌정보실',1,0,'히가시노 게이고 지음 ; 한성례 옮김'),('9788972756194','나미야 잡화점의 기적','현대문학, 2012','455 p. ; 19 cm ;',14800,'833.6','인쇄자료(책자형)',NULL,'문학','AMC000060459','833.6-ㅎ961나=4','금호도서관','[금호]문헌정보실',1,0,'히가시노 게이고 지음 ; 양윤옥 옮김'),('9788972759980','파랑대문','현대문학, 2019','211 p. ; 19 cm ;',11200,'813.7','인쇄자료(책자형)','현대문학 핀 시리즈 소설선=','문학','AMD000057957','813.7-ㅊ588ㅍ','용답도서관','[용답]문헌정보실',1,0,'최윤 지음'),('9788972756194','나미야 잡화점의 기적','현대문학, 2022','455 p. ; 20 cm ;',14500,'833.6','인쇄자료(책자형)',NULL,'문학','AME000034358','833.6-ㅎ961ㄴ2','성수도서관','[성수]문헌정보실',0,1,'히가시노 게이고 지음 ; 양윤옥 옮김'),('9788972756194','나미야 잡화점의 기적:히가시노 게이고 장편소설','현대문학, 2012','455 p. ; 19 cm ;',14800,'833.6','인쇄자료(책자형)',NULL,'문학','AMF000021861','S 833.6-ㅎ961ㄴ','청계도서관','[청계]문헌정보실',1,0,'히가시노 게이고 지음 ; 양윤옥 옮김');
/*!40000 ALTER TABLE `books` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `userinterestbook`
--

LOCK TABLES `userinterestbook` WRITE;
/*!40000 ALTER TABLE `userinterestbook` DISABLE KEYS */;
INSERT INTO `userinterestbook` VALUES (10,2,'AMA000192817'),(11,1,'AMA000168385');
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
INSERT INTO `users` VALUES (1,'서지현','정상','barcode'),(2,'sw','정상','barcode2'),(4,'dfs','sdfs','f');
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

-- Dump completed on 2024-01-28  7:55:37
