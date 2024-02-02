package com.example.demo.model;

import java.time.LocalDate;

import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.OneToOne;

@Entity
public class Review {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long review_id;
	
	private LocalDate review_date;
	
    private String user_name; // 사용자 이름 필드 추가

    public String getUser_name() {
        return user_name;
    }

    public void setUser_name(String user_name) {
        this.user_name = user_name;
    }

	
	@OneToOne(fetch = FetchType.EAGER)
	@JoinColumn(name = "loan_id")
	private Loan loan;

	 public Long getLoan_id() {
	        if (loan != null) {
	            return loan.getLoan_id();
	        }
	        return null; // 대출 정보가 없을 경우 null 반환
	    }
	
    public Long getUserId() {
        if (loan != null && loan.getUser() != null) {
            return loan.getUser().getId();
        }
        return null; // 사용자 정보가 없을 경우 null 반환
    }
    
	private int review_score;
	private String review_content;
	
	public Long getReview_id() {
		return review_id;
	}
	
	public void setReview_id(Long review_id) {
		this.review_id = review_id;
	}
	
	public LocalDate getReview_date() {
		return review_date;
	}
	
	public void setReview_date(LocalDate review_date) {
		this.review_date = review_date;
	}
	
	public Loan getLoan() {
		return loan;
	}
	
	public void setLoan(Loan loan) {
		this.loan = loan;
	}
	
	public int getReview_score() {
		return review_score;
	}
	
	public void setReview_score(int review_score) {
		this.review_score = review_score;
	}
	
	public String getReview_content() {
		return review_content;
	}
	
	public void setReview_content(String review_content) {
		this.review_content = review_content;
	}
}
