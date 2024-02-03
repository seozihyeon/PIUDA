package com.example.demo.model;

import java.time.LocalDate;

import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;

@Entity
public class UserBooking {

	@Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long reserve_id;
	
	private LocalDate reserve_date;
	
	@ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "user_id")
    private Users user;
	
	@ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "book_id")
    private Book book;
	
	public Long getReserve_id() {
		return reserve_id;
	}
	
	public void setReserve_id(Long reserve_id) {
		this.reserve_id = reserve_id;
	}
	public LocalDate getReserve_date() {
		return reserve_date;
	}
	
	public void setReserve_date(LocalDate reserve_date) {
		this.reserve_date = reserve_date;
	}
	
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
	
}