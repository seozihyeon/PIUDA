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

public class NewBook {
	@Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long newbook_id;
	
	@OneToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "book_id") 
    private Book book;
	
	@Temporal(TemporalType.DATE)
    private Date newbook_date;

	public Long getNewbook_id() {
		return newbook_id;
	}

	public void setNewbook_id(Long newbook_id) {
		this.newbook_id = newbook_id;
	}

	public Book getBook() {
		return book;
	}

	public void setBook(Book book) {
		this.book = book;
	}

	public Date getNewbook_date() {
		return newbook_date;
	}

	public void setNewbook_date(Date newbook_date) {
		this.newbook_date = newbook_date;
	}
    
	public String getLibrary() {
        return this.book != null ? this.book.getLibrary() : null;
    }
}
