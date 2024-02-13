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
                                                       @RequestParam(name = "pageSize", defaultValue = "10") int pageSize,
                                                       @RequestParam(name = "libraries", required = false) List<String> libraries) {
        try {
            List<Book> books = new ArrayList<>();

            if (title != null) {
                title = bookService.prepareSearchTerm(title); // 검색어 전처리
                System.out.println("Searching for books with title: " + title);
            }

            if (author != null) {
                author = bookService.prepareSearchTerm(author); // 검색어 전처리
                System.out.println("Searching for books with author: " + author);
            }

            if (publisher != null) {
                publisher = bookService.prepareSearchTerm(publisher); // 검색어 전처리
                System.out.println("Searching for books with publisher: " + publisher);
            }

            // 필터링이 적용된 경우에는 해당 필터에 맞는 책 수를 가져옵니다.
            long totalBooks;
            if (libraries != null && !libraries.isEmpty()) {
                totalBooks = bookService.countBooksPaged(title, author, publisher, libraries);
            } else {
                totalBooks = bookService.countBooksPaged(title, author, publisher, null); // libraries가 null이 아닌 경우에만 null을 넘겨야 함
            }

            int totalPages = (int) Math.ceil((double) totalBooks / pageSize);

            logger.info("Total Books: " + totalBooks);
            logger.info("Total Pages: " + totalPages);

            // 응답 헤더에 전체 페이지 수 추가
            HttpHeaders headers = new HttpHeaders();
            headers.add("total-pages", String.valueOf(totalPages));

            // 필터링이 적용된 경우에는 해당 필터에 맞는 책을 가져옵니다.
            if (libraries != null && !libraries.isEmpty()) {
                if (title != null) {
                    books = bookService.findByLibrariesAndTitlePaged(libraries, title, page, pageSize);
                } else if (author != null) {
                    books = bookService.findByLibrariesAndAuthorPaged(libraries, author, page, pageSize);
                } else if (publisher != null) {
                    books = bookService.findByLibrariesAndPublisherPaged(libraries, publisher, page, pageSize);
                }
            } else {
                // 도서관 필터링이 적용되지 않은 경우, 모든 도서관에서 책을 검색합니다.
                if (title != null) {
                    books = bookService.findByBookTitlePaged(title, page, pageSize);
                } else if (author != null) {
                    books = bookService.findByAuthorPaged(author, page, pageSize);
                } else if (publisher != null) {
                    books = bookService.findByPublisherPaged(publisher, page, pageSize);
                }
            }

            // 응답 데이터와 헤더를 포함하여 응답
            return new ResponseEntity<>(books, headers, HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}