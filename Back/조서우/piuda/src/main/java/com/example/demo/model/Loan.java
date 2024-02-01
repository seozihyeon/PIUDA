package com.example.demo.model;

import java.util.Date;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;

@Entity	
public class Loan {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "loan_id")
    private Long loan_id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "user_id") 
    private Users user;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "book_id") 
    private Book book;

    @Column(name = "loan_date", nullable = false)
    @Temporal(TemporalType.DATE)
    private Date loan_date;

    @Column(name = "expect_date")
    @Temporal(TemporalType.DATE)
    private Date expect_date;

    @Column(name = "return_date")
    @Temporal(TemporalType.DATE)
    private Date return_date;
    
    @Column(name = "extend_status", nullable = false, columnDefinition = "boolean default false")
    private boolean extend_status;

    @Column(name = "return_status", nullable = false, columnDefinition = "boolean default false")
    private Boolean return_status;

    
    
	public Users getUser() {
		return user;
	}

	public void setUser(Users user) {
		this.user = user;
	}

	public Book getBook() {
		return book;
	}

	public void setBook(Book book) {
		this.book = book;
	}

	public Long getLoan_id() {
		return loan_id;
	}

	public void setLoan_id(Long loan_id) {
		this.loan_id = loan_id;
	}

	public Date getLoan_date() {
		return loan_date;
	}

	public void setLoan_date(Date loan_date) {
		this.loan_date = loan_date;
	}

	public Date getExpect_date() {
		return expect_date;
	}

	public void setExpect_date(Date expect_date) {
		this.expect_date = expect_date;
	}

	public Date getReturn_date() {
		return return_date;
	}

	public void setReturn_date(Date return_date) {
		this.return_date = return_date;
	}
	
	public boolean getExtend_status() {
		return extend_status;
	}

	public void setExtend_status(boolean extend_status) {
		this.extend_status = extend_status;
	}

	public Boolean getReturn_status() {
		return return_status;
	}

	public void setReturn_status(Boolean return_status) {
		this.return_status = return_status;
	}
}