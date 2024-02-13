package com.example.demo.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.mapper.BookMapper;
import com.example.demo.model.Book;


@Service
public class BookService{
	
	@Autowired
	private final BookMapper bookMapper;

    public BookService(BookMapper bookMapper) {
        this.bookMapper = bookMapper;
    }
	
	public Book getBookById(String book_id) {
        return bookMapper.findByBookId(book_id);
    }
	 
	public String prepareSearchTerm(String term) {
		
		if (term == null || term.isEmpty()) {
	           return "%";
		}
		String[] words = term.split("\\s+"); // 공백을 기준으로 단어를 분리합니다.
	    StringBuilder searchTerm = new StringBuilder();
	    for (String word : words) {
	        searchTerm.append('%');
	        for (char c : word.toCharArray()) {
	            searchTerm.append(c);
	            searchTerm.append('%');
	        }
	    }
	    return searchTerm.toString();   
	}
	
	
	//
	public List<Book> findByBookTitlePaged(String bookTitle, int page, int pageSize) {
	    int offset = (page - 1) * pageSize;
	    return bookMapper.findByBookTitlePaged(bookTitle, pageSize, offset);
	}
	
	public List<Book> findByAuthorPaged(String author, int page, int pageSize) {
        int offset = (page - 1) * pageSize;
        return bookMapper.findByAuthorPaged(author, pageSize, offset);
    }
	
	public List<Book> findByPublisherPaged(String publisher, int page, int pageSize) {
        int offset = (page - 1) * pageSize;
        return bookMapper.findByPublisherPaged(publisher, pageSize, offset);
    }
	
	public long countBooksPaged(String bookTitle, String author, String publisher, List<String> libraries) {
	    if (libraries != null && !libraries.isEmpty()) {
	        return bookMapper.countBooksPagedWithLibraries(bookTitle, author, publisher, libraries);
	    } else {
	        return bookMapper.countBooksPaged(bookTitle, author, publisher);
	    }
	}
	
	public List<Book> findByLibrariesAndTitlePaged(List<String> libraries, String bookTitle, int page, int pageSize) {
	    int offset = (page - 1) * pageSize;
	    return bookMapper.findByLibrariesAndTitlePaged(libraries, bookTitle, pageSize, offset);
	}

	public List<Book> findByLibrariesAndAuthorPaged(List<String> libraries, String author, int page, int pageSize) {
	    int offset = (page - 1) * pageSize;
	    return bookMapper.findByLibrariesAndAuthorPaged(libraries, author, pageSize, offset);
	}

	public List<Book> findByLibrariesAndPublisherPaged(List<String> libraries, String publisher, int page, int pageSize) {
	    int offset = (page - 1) * pageSize;
	    return bookMapper.findByLibrariesAndPublisherPaged(libraries, publisher, pageSize, offset);
	}
	
}