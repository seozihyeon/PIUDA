package com.example.demo.controller;

import java.time.LocalDate;
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
import com.example.demo.mapper.UserBookingMapper;
import com.example.demo.mapper.UsersMapper;
import com.example.demo.model.Book;
import com.example.demo.model.UserBooking;
import com.example.demo.model.Users;

import java.util.Collections;

@RestController
@RequestMapping("/api/userbooking")
public class UserBookingController {
    private final UsersMapper usersMapper;
    private final BookMapper bookMapper;
    private final UserBookingMapper userBookingMapper;

    public UserBookingController(UsersMapper usersMapper, BookMapper bookMapper, UserBookingMapper userBookingMapper) {
        this.usersMapper = usersMapper;
        this.bookMapper = bookMapper;
        this.userBookingMapper = userBookingMapper;
    }

    @PostMapping("/add")
    public ResponseEntity<?> insertUserBooking(@RequestParam("user_id") Long user_id, @RequestParam("book_id") String book_id) {
        Users user = usersMapper.getUserProfile(user_id);
        Book book = bookMapper.findByBookId(book_id);

        if (user != null && book != null) {
            // 사용자의 현재 예약 개수 확인
            List<UserBooking> currentBookings = userBookingMapper.getUserBookingList(user_id);
            if (currentBookings.size() >= 3) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Cannot reserve more than 3 books");
            }

            LocalDate reserveDate = LocalDate.now(); // 현재 날짜를 예약 날짜로 설정
            int result = userBookingMapper.insertUserBooking(user, book, reserveDate);
            if (result > 0) {
                bookMapper.updateBookReservedStatus(book_id, true);
                return ResponseEntity.ok().body("Book added to user's booking list successfully");
            } else {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Failed to add book to user's booking list");
            }
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("User or book not found");
        }
    }


    @DeleteMapping("/remove/{user_id}/{book_id}")
    public ResponseEntity<?> removeUserBooking(@PathVariable("user_id") Long user_id, @PathVariable("book_id") String book_id) {
        Users user = usersMapper.getUserProfile(user_id);
        Book book = bookMapper.findByBookId(book_id);

        if (user != null && book != null) {
            int result = userBookingMapper.deleteUserBooking(user, book);
            if (result > 0) {
                bookMapper.updateBookReservedStatus(book_id, false);
                return ResponseEntity.ok().body("Book removed from user's booking list successfully");
            } else {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Failed to remove book from user's booking list.");
            }
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("User or book not found");
        }
    }

    @GetMapping("/list/{user_id}")
    public ResponseEntity<List<UserBooking>> getUserBookingList(@PathVariable("user_id") Long user_id) {
        List<UserBooking> userBookingList = userBookingMapper.getUserBookingList(user_id);
        if (!userBookingList.isEmpty()) {
            return ResponseEntity.ok().body(userBookingList);
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(Collections.emptyList());
        }
    }
}
