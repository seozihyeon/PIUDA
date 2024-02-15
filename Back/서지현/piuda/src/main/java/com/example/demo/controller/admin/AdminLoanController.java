package com.example.demo.controller.admin;

import java.time.LocalDate;
import java.time.ZoneId;
import java.util.Collections;
import java.util.Date;
import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.demo.mapper.BookMapper;
import com.example.demo.mapper.LoanMapper;
import com.example.demo.mapper.UsersMapper;
import com.example.demo.model.Book;
import com.example.demo.model.Loan;
import com.example.demo.model.Users;


@RequestMapping("/admin/loan")
@Controller
public class AdminLoanController {

    private final UsersMapper usersMapper;
    private final BookMapper bookMapper;
    private final LoanMapper loanMapper;

    public AdminLoanController(UsersMapper usersMapper, BookMapper bookMapper, LoanMapper loanMapper) {
        this.usersMapper = usersMapper;
        this.bookMapper = bookMapper;
        this.loanMapper = loanMapper;
    }
	
	@GetMapping("/all")
	public ResponseEntity<List<Loan>> getAllLoans() {
	    List<Loan> allLoans = loanMapper.getAllLoans();
	    if (!allLoans.isEmpty()) {
	        return ResponseEntity.ok().body(allLoans);
	    } else {
	        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(Collections.emptyList());
	    }
	}
	
    @PostMapping("/create")
    public ResponseEntity<String> createLoan(@RequestParam("user_id") Long user_id, @RequestParam("book_id") String book_id) {
        Users user = usersMapper.getUserProfile(user_id);
        Book book = bookMapper.findByBookId(book_id);

        if (user == null || book == null) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("User or Book not found!");
        }

        Date loanDate = new Date();
        LocalDate localLoanDate = loanDate.toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
        LocalDate expectedReturnDate = localLoanDate.plusDays(14);
        Boolean returnStatus = false;

        Loan loan = new Loan();
        loan.setUser(user);
        loan.setBook(book);
        loan.setLoan_date(loanDate);
        loan.setExpect_date(java.sql.Date.valueOf(expectedReturnDate));
        loan.setReturn_status(returnStatus);

        loanMapper.insertLoan(loan);
        bookMapper.updateBorrowedStatus(book_id, true);
        return ResponseEntity.ok("Loan created successfully!");
        
    }
    
    @PutMapping("/return/{loan_id}")
    public ResponseEntity<String> returnLoan(@PathVariable("loan_id") Long loan_id) {
        Loan loan = loanMapper.getLoanById(loan_id);

        if (loan == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Loan not found!");
        }

        if (loan.getReturn_status()) {
            return ResponseEntity.status(HttpStatus.CONFLICT).body("Loan already returned!");
        }

        boolean isReserved = loan.getBook().getReserved();
        // 반납 처리 로직
        Date returnDate = new Date();
        loan.setReturn_date(returnDate);
        loan.setReturn_status(true);
        loanMapper.returnBook(loan);
        bookMapper.updateBorrowedStatus(loan.getBook().getId(), false);

        if (isReserved) {
            // 책이 예약된 경우, 특별한 메시지를 반환합니다.
            return ResponseEntity.ok("반납이 완료되었습니다. 이 책은 예약 도서입니다.");
        }

        return ResponseEntity.ok("반납이 완료되었습니다.");
    }

    
	
	  @GetMapping
	    public String loanManagementPage() {
	        return "loan"; // 'loan.html' 파일을 반환
	    }
	
	
}

