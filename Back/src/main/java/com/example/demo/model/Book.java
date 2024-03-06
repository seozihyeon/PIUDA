package com.example.demo.model;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;

@Entity
public class Book {
	@Id
    private String book_id; //등록번호
    private String book_title; //제목
    private String author; //저자
    private String publisher; //발행처
    private String book_isbn; //ISBN
    private int book_price; //가격
    private String book_classification; //분류번호
    private String book_media; //매체구분
    private String book_series; //총서명
    private String field_name; //분야
    private String book_ii; //청구기호 
    private String library; //도서관
    private String book_size; //형태사항
    private String location; //자료위치
    private Boolean borrowed; //대출여부
    private Boolean reserved; //예약여부

    public String getId() {
        return book_id;
    }

    public void setId(String book_id) {
        this.book_id = book_id;
    }

    public String getTitle() {
        return book_title;
    }

    public void setTitle(String title) {
        this.book_title = title;
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public String getPublisher() {
        return publisher;
    }

    public void setPublisher(String publisher) {
        this.publisher = publisher;
    }
    
    public String getBook_isbn() {
        return book_isbn;
    }

    public void setBook_isbn(String book_isbn) {
        this.book_isbn = book_isbn;
    }
    
    public int getPrice() {
    	return book_price;
    }
    
    public void setPrice(int book_price) {
    	this.book_price = book_price;
    }
    
    public String getClassification() {
    	return book_classification;
    }
    
    public void setClassification(String book_classification) {
    	this.book_classification = book_classification;
    }
    
    public String getMedia() {
    	return book_media;
    }
    
    public void setMedia(String book_media) {
    	this.book_media = book_media;
    }
    
    public String getSeries() {
    	return book_series;
    }
    
    public void setSeries(String book_series) {
    	this.book_series = book_series;
    }
    
    public String getField_name() {
    	return field_name;
    }
    
    public void setField_name(String field_name) {
    	this.field_name = field_name;
    }
    
    public String getBook_ii() {
    	return book_ii;
    }
    
    public void setBook_ii(String book_ii) {
    	this.book_ii= book_ii;
    }
    
    public String getLibrary() {
    	return library;
    }
    
    public void setLibrary(String library) {
    	this.library = library;
    }
    
    public String getSize() {
    	return book_size;
    }
    
    public void setSize(String book_size) {
    	this.book_size = book_size;
    }
    
    public String getLocation() {
    	return location;
    }
    
    public void setLocation(String location) {
    	this.location = location;
    }
    
    public Boolean getBorrowed() {
    	return borrowed;
    }
    
    public void setBorrowed(Boolean borrowed) {
    	this.borrowed = borrowed;
    }
    
    public Boolean getReserved() {
    	return reserved;
    }
    
    public void setReseved(Boolean reserved) {
    	this.reserved = reserved;
    }
}