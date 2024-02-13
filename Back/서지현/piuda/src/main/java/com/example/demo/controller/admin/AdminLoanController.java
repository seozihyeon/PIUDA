package com.example.demo.controller.admin;

import java.util.Collections;
import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.example.demo.mapper.BookMapper;
import com.example.demo.mapper.LoanMapper;
import com.example.demo.mapper.UsersMapper;
import com.example.demo.model.Loan;


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
	
	  @GetMapping
	    public String loanManagementPage() {
	        return "loan"; // 'loan.html' 파일을 반환
	    }
	
	
}

