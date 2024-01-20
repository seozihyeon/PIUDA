package com.example.demo.model;

public class Book {
    private String book_id;
    private String book_title;
    private String author;
    private String publisher; // 추가된 필드
    private String book_isbn;

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
}

