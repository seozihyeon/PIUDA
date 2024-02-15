package com.example.demo.controller.admin;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.example.demo.service.BookService;
import com.example.demo.mapper.BookMapper;
import com.example.demo.model.Book;

import java.util.List;

@RestController
@RequestMapping("/admin/books") // 관리자용 URL 접두사
public class AdminBookController {
    private final BookService bookService;
    private final BookMapper bookMapper;
    private static final Logger logger = LoggerFactory.getLogger(AdminBookController.class);

    public AdminBookController(BookService bookService, BookMapper bookMapper) {
        this.bookService = bookService;
        this.bookMapper = bookMapper;
    }

    @GetMapping("/titles")
    public ResponseEntity<List<Book>> getAllBookIdsAndTitles() {
        try {
            List<Book> books = bookMapper.findAllBookIdsAndTitles();
            return new ResponseEntity<>(books, HttpStatus.OK);
        } catch (Exception e) {
            logger.error("Error retrieving book IDs and titles", e);
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
   
    

    // 관리자 전용 추가 기능...
}
