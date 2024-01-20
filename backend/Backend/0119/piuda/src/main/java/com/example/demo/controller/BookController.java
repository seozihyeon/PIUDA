package com.example.demo.controller;

import org.springframework.web.bind.annotation.*;
import com.example.demo.mapper.BookMapper;
import com.example.demo.model.Book;

import java.util.List;

@RestController
@RequestMapping("/api/books")
public class BookController {
    private final BookMapper bookMapper;

    public BookController(BookMapper bookMapper) {
        this.bookMapper = bookMapper;
    }

    @GetMapping("/search")
    public List<Book> searchBooksByTitle(@RequestParam String title) {
        System.out.println("Searching for books with title: " + title); // 저자명 받았는지 출력

        return bookMapper.findByBookTitle(title);
    }
}