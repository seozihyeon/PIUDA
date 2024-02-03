package com.example.demo.controller;

import java.util.Date;
import java.util.List;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.demo.mapper.LoanMapper;
import com.example.demo.mapper.ReviewConditionMapper;
import com.example.demo.model.Loan;
import com.example.demo.model.ReviewCondition;

@RestController
@RequestMapping("/reviewCondition")
public class ReviewConditionController {

	private final ReviewConditionMapper reviewConditionMapper;
    private final LoanMapper loanMapper;

    public ReviewConditionController(LoanMapper loanMapper, ReviewConditionMapper reviewConditionMapper) {
        this.loanMapper = loanMapper;
        this.reviewConditionMapper = reviewConditionMapper;
    }

    
    @PostMapping("/write")
    public ResponseEntity<String> saveReviewCondition(@RequestBody Map<String, Object> requestBody) {
        try {
            Long loan_id = Long.parseLong(requestBody.get("loan_id").toString());
            int loss_score = Integer.parseInt(requestBody.get("loss_score").toString());
            int taint_score = Integer.parseInt(requestBody.get("taint_score").toString());
            String condition_op = requestBody.get("condition_op").toString();

            Loan loan = loanMapper.getLoanById(loan_id);
            if (loan == null) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Invalid loan_id");
            }
            
            //중복확인
            ReviewCondition existingCondition = reviewConditionMapper.getReviewConditionByLoanId(loan_id);
            if (existingCondition != null) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Review condition already exists for the given loan_id");
            }

            Date conditionDate = new Date();
            ReviewCondition reviewCondition = new ReviewCondition();
            reviewCondition.setLoan(loan);
            reviewCondition.setLoss_score(loss_score);
            reviewCondition.setTaint_score(taint_score);
            reviewCondition.setCondition_op(condition_op);
            reviewCondition.setCondition_date(conditionDate);

            reviewConditionMapper.writeReviewCondition(reviewCondition);
            return ResponseEntity.ok("ReviewCondition created successfully!");
        } catch (NumberFormatException | NullPointerException e) {
            // 예외 처리: 숫자로 변환할 수 없거나 값이 없는 경우
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Invalid request format");
        }
    }
    
    @GetMapping("/check/{loan_id}")
    public ResponseEntity<String> checkReviewCondition(@PathVariable Long loan_id) {
        try {
            Loan loan = loanMapper.getLoanById(loan_id);

            if (loan == null) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Invalid loan_id");
            }

            ReviewCondition existingCondition = reviewConditionMapper.getReviewConditionByLoanId(loan_id);
            if (existingCondition != null) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Already exists for the given loan_id");
            } else {
                return ResponseEntity.ok("Review condition does not exist for the given loan_id");
            }
        } catch (Exception e) {
            // Handle exceptions as needed
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error checking review condition");
        }
    }
    
    //수정은 보류
    @PutMapping("/update/{condition_id}")
    public String updateReviewCondition(@PathVariable Long condition_id, @RequestParam("loss_score") int loss_score, @RequestParam("taint_score") int taint_score, @RequestParam String condition_op) {
    	ReviewCondition existingCondition = reviewConditionMapper.getReviewConditionById(condition_id);
        if (existingCondition == null) {
            return "ReviewCondition not found!";
        }

        existingCondition.setLoss_score(loss_score);
        existingCondition.setTaint_score(taint_score);
        existingCondition.setCondition_op(condition_op);

        reviewConditionMapper.updateReviewCondition(existingCondition);
        return "ReviewCondition updated successfully!";
    }

    @DeleteMapping("/delete/{condition_id}")
    public ResponseEntity<?> deleteReviewCondition(@PathVariable Long condition_id) {
        try {
            int deletedRows = reviewConditionMapper.deleteReviewCondition(condition_id);

            if (deletedRows > 0) {
                return ResponseEntity.ok().body("Review condition removed successfully");
            } else {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Failed to remove review condition");
            }
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Internal server error");
        }
    }

    @GetMapping("/list")
    public List<ReviewCondition> getAllReviewConditions() {
        return reviewConditionMapper.getAllReviewConditions();
    }
    
    @GetMapping("/list/{book_id}")
    public List<ReviewCondition> getReviewConditionsByBookId(@PathVariable String book_id) {
        return reviewConditionMapper.getReviewConditionsByBookId(book_id);
    }
}