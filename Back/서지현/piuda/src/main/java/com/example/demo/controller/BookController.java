package com.example.demo.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.example.demo.service.BookService;
import com.example.demo.model.Book;

import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/api/books")
public class BookController {
    private final BookService bookService;
    private static final Logger logger = LoggerFactory.getLogger(BookController.class);


    public BookController(BookService bookService) {
        this.bookService = bookService;
    }

    @GetMapping("/search")
    public ResponseEntity<List<Book>> searchBooksPaged(@RequestParam(name = "title", required = false) String title,
                                                       @RequestParam(name = "publisher", required = false) String publisher,
                                                       @RequestParam(name = "author", required = false) String author,
                                                       @RequestParam(name = "page", defaultValue = "1") int page,
                                                       @RequestParam(name = "pageSize", defaultValue = "10") int pageSize) {
        try {
            List<Book> books = new ArrayList<>();

            if (title != null) {
                System.out.println("Searching for books with title: " + title);
                books = bookService.findByBookTitlePaged(title, page, pageSize);
            } else if (author != null) {
                System.out.println("Searching for books with author: " + author);
                books = bookService.findByAuthorPaged(author, page, pageSize);
            } else if (publisher != null) {
                System.out.println("Searching for books with publisher: " + publisher);
                books = bookService.findByPublisherPaged(publisher, page, pageSize);
            } else {
                // 둘 다 제공되지 않은 경우, 모든 책을 반환하거나, 빈 리스트를 반환할 수 있습니다.
            }

            // 전체 페이지 수 계산
            long totalBooks = bookService.countBooksPaged(title, author, publisher);
            int totalPages = (int) Math.ceil((double) totalBooks / pageSize);

            logger.info("Total Pages: " + totalPages);
            
            // 응답 헤더에 전체 페이지 수 추가
            HttpHeaders headers = new HttpHeaders();
            headers.add("total-pages", String.valueOf(totalPages));

            // 응답 데이터와 헤더를 포함하여 응답
            return new ResponseEntity<>(books, headers, HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    
    
}