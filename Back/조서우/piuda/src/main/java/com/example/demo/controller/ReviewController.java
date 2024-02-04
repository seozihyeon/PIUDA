package com.example.demo.controller;

import java.time.LocalDate;
import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.example.demo.mapper.LoanMapper;
import com.example.demo.mapper.ReviewMapper;
import com.example.demo.mapper.UsersMapper;
import com.example.demo.model.Loan;
import com.example.demo.model.Review;

@RestController
@RequestMapping("/api/review")
public class ReviewController {
    private final LoanMapper loanMapper;
    private final ReviewMapper reviewMapper;
    public ReviewController(LoanMapper loanMapper, ReviewMapper reviewMapper, UsersMapper usersMapper) {
        this.loanMapper = loanMapper;
        this.reviewMapper = reviewMapper;
    }
    
    @GetMapping("/get/isbn/by-loan/{loanId}")
    public ResponseEntity<?> getIsbnByLoanId(@PathVariable("loanId") Long loanId) {
        String isbn = loanMapper.getIsbnByLoanId(loanId);
        if (isbn != null) {
            return ResponseEntity.ok(isbn);
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("ISBN not found for the given loan ID");
        }
    }
    
    @GetMapping("/get/by-isbn/{isbn}")
    public ResponseEntity<?> getReviewsWithUserNameByIsbn(@PathVariable("isbn") String isbn) {
        List<Review> reviews = reviewMapper.getReviewsByIsbn(isbn);

        if (reviews != null && !reviews.isEmpty()) {
            return ResponseEntity.ok(reviews);
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("No reviews found for this ISBN");
        }
    }

    @PostMapping("/add")
    public ResponseEntity<?> insertReview(
        @RequestParam("loan_id") Long loan_id,
        @RequestParam("review_content") String review_content,
        @RequestParam("review_score") int review_score
    ) {
        // 대출 정보 가져오기
        Loan loan = loanMapper.getLoanById(loan_id);
        
        if (loan != null) {
            if (loan.getUser() == null) {
                // User 객체가 null인 경우의 로깅
                System.out.println("User object is null for loan_id: " + loan_id);
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Loan found but user not found");
            }
           Long userId = loan.getUser().getId(); // 사용자 ID 가져오기
            String isbn = loan.getBook().getBook_isbn(); // ISBN 가져오기

            // 중복 리뷰 확인
            int existingReviewsCount = reviewMapper.countReviewsByUserIdAndIsbn(userId, isbn);
            if (existingReviewsCount > 0) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("User has already reviewed this book");
            }

            // 리뷰 객체 생성 및 설정
            Review review = new Review();
            review.setLoan(loan);
            review.setReview_content(review_content);
            review.setReview_score(review_score);
            review.setReview_date(LocalDate.now());

            // 리뷰를 데이터베이스에 저장
            reviewMapper.insertReview(review);

            return ResponseEntity.ok().body("Review added successfully");
        } else {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Failed to add review: Loan not found");
        }
    }

    

    @DeleteMapping("/remove/{review_id}")
    public ResponseEntity<?> removeReview(@PathVariable("review_id") Long review_id) {
        // 리뷰를 삭제하고 삭제 여부를 확인
        int deletedRows = reviewMapper.deleteReview(review_id);

        if (deletedRows > 0) {
            return ResponseEntity.ok().body("Review removed successfully");
        } else {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Failed to remove review");
        }
    }
    
    @GetMapping("/check/review/{userId}/{isbn}")
    public ResponseEntity<?> checkUserReview(
        @PathVariable("userId") Long userId,
        @PathVariable("isbn") String isbn
    ) {
        int reviewCount = reviewMapper.countReviewsByUserIdAndIsbn(userId, isbn);
        return ResponseEntity.ok(reviewCount > 0);
    }

}