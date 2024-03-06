package com.example.demo.controller;

import java.util.Collections;
import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.demo.mapper.BookMapper;
import com.example.demo.mapper.UserInterestBookMapper;
import com.example.demo.mapper.UsersMapper;
import com.example.demo.model.Book;
import com.example.demo.model.UserInterestBook;
import com.example.demo.model.Users;

@RestController
@RequestMapping("/api/userinterest")
public class UserInterestBookController {
	
    private UsersMapper usersMapper;
    private BookMapper bookMapper;
    private UserInterestBookMapper userInterestBookMapper;

    public UserInterestBookController(UsersMapper usersMapper, BookMapper bookMapper, UserInterestBookMapper userInterestBookMapper) {
        this.usersMapper = usersMapper;
        this.bookMapper = bookMapper;
        this.userInterestBookMapper = userInterestBookMapper;
    }
    

    @PostMapping("/add")
    public ResponseEntity<?> insertUserInterestBook(@RequestParam("user_id") Long user_id, @RequestParam("book_id") String book_id) {
        Users user = usersMapper.getUserProfile(user_id);
        Book book = bookMapper.findByBookId(book_id);

        if (user != null && book != null) {
        	int duplicateCount = userInterestBookMapper.checkDuplicateInterest(user_id, book_id);
            if (duplicateCount > 0) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Book is already in user's interest list");
            }
            
            int result = userInterestBookMapper.insertUserInterestBook(user, book);
            if (result > 0) {
                return ResponseEntity.ok().body("Book added to user's interest list successfully");
            } else {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Failed to add book to user's interest list");
            }
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("User or book not found");
        }
    }

    @DeleteMapping("/remove/{user_id}/{book_id}")
    public ResponseEntity<?> removeUserInterestBook(@PathVariable("user_id") Long user_id, @PathVariable("book_id") String book_id) {
        Users user = usersMapper.getUserProfile(user_id);
        Book book = bookMapper.findByBookId(book_id);

        if (user != null && book != null) {
            int result = userInterestBookMapper.deleteUserInterestBook(user, book);
            if (result > 0) {
                return ResponseEntity.ok().body("Book removed from user's interest list successfully");
            } else {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Failed to remove book from user's interest list");
            }
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("User or book not found");
        }
    }
    
    @GetMapping("/list/{user_id}")
    public ResponseEntity<List<UserInterestBook>> getUserInterestList(@PathVariable("user_id") Long user_id) {
        List<UserInterestBook> userInterestList = userInterestBookMapper.getUserInterestList(user_id);
        if (!userInterestList.isEmpty()) {
            return ResponseEntity.ok().body(userInterestList);
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(Collections.emptyList());
        }
    }
}