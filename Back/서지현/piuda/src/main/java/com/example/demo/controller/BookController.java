package com.example.demo.controller;

import org.springframework.web.bind.annotation.*;
import com.example.demo.mapper.BookMapper;
import com.example.demo.model.Book;

import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/api/books")
public class BookController {
    private final BookMapper bookMapper;

    public BookController(BookMapper bookMapper) {
        this.bookMapper = bookMapper;
    }

    @GetMapping("/search")
    public List<Book> searchBooks(@RequestParam(name = "title", required = false) String title,
    							  @RequestParam(name = "publisher", required = false) String publisher,
                                  @RequestParam(name = "author", required = false) String author) {
        if (title != null) {
            System.out.println("Searching for books with title: " + title);
            return bookMapper.findByBookTitle(title);
        } else if (author != null) {
            System.out.println("Searching for books with author: " + author);
            return bookMapper.findByAuthor(author);
        } 
        else if (publisher != null) {
            System.out.println("Searching for books with publisher: " + publisher);
            return bookMapper.findByPublisher(publisher);
        }else {
            // 둘 다 제공되지 않은 경우, 모든 책을 반환하거나, 빈 리스트를 반환할 수 있습니다.
            return new ArrayList<>();
        }
    }
}