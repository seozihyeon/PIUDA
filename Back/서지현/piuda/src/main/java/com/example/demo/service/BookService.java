package com.example.demo.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.mapper.BookMapper;
import com.example.demo.model.Book;


@Service
public class BookService{
	
	@Autowired
    private BookMapper bookMapper;
	
	public Book getBookById(String book_id) {
        // 적절한 메서드로 수정해주세요.
        return bookMapper.findByBookId(book_id);
    }


	 public List<Book> findByBookTitle(String book_title) {
	        String preparedTitle = prepareSearchTerm(book_title);
	        return bookMapper.findByBookTitle(preparedTitle);
	    }

	    public List<Book> findByAuthor(String author) {
	        String preparedAuthor = prepareSearchTerm(author);
	        return bookMapper.findByAuthor(preparedAuthor);
	    }

	    public List<Book> findByPublisher(String publisher) {
	        String preparedPublisher = prepareSearchTerm(publisher);
	        return bookMapper.findByPublisher(preparedPublisher);
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
}