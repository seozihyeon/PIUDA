package com.example.demo.model;

import java.util.Date;

import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;

public class RecommendBook {
	@Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long recommend_id;
	
	@OneToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "book_id") 
    private Book book;
	
	private String recommender;
	
	@Temporal(TemporalType.DATE)
    private Date recommend_date;

	public Long getRecommend_id() {
		return recommend_id;
	}

	public void setRecommend_id(Long recommend_id) {
		this.recommend_id = recommend_id;
	}

	public Book getBook() {
		return book;
	}

	public void setBook(Book book) {
		this.book = book;
	}

	public String getRecommender() {
		return recommender;
	}

	public void setRecommender(String recommender) {
		this.recommender = recommender;
	}

	public Date getRecommend_date() {
		return recommend_date;
	}

	public void setRecommend_date(Date recommen_date) {
		this.recommend_date = recommen_date;
	}
	
}
