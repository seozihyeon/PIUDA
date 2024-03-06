package com.example.demo.model;

import java.util.Date;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;

@Entity
public class ReviewCondition {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "condition_id")
    private Long condition_id;

    @OneToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "loan_id") 
    private Loan loan;

    @Column(name = "loss_score")
    private int loss_score;

    @Column(name = "taint_score")
    private int taint_score;

    @Column(name = "condition_op")
    private String condition_op;

    @Column(name = "condition_date", nullable = false)
    @Temporal(TemporalType.DATE)
    private Date condition_date;
    
    

	public Long getCondition_id() {
		return condition_id;
	}

	public void setCondition_id(Long condition_id) {
		this.condition_id = condition_id;
	}

	public Loan getLoan() {
		return loan;
	}

	public void setLoan(Loan loan) {
		this.loan = loan;
	}

	public int getLoss_score() {
		return loss_score;
	}

	public void setLoss_score(int loss_score) {
		this.loss_score = loss_score;
	}

	public int getTaint_score() {
		return taint_score;
	}

	public void setTaint_score(int taint_score) {
		this.taint_score = taint_score;
	}

	public String getCondition_op() {
		return condition_op;
	}

	public void setCondition_op(String condition_op) {
		this.condition_op = condition_op;
	}

	public Date getCondition_date() {
		return condition_date;
	}

	public void setCondition_date(Date condition_date) {
		this.condition_date = condition_date;
	}

	
	private String user_name;

	public String getUser_name() {
		return user_name;
	}

	public void setUser_name(String user_name) {
		this.user_name = user_name;
	}
	
}