package com.example.demo.controller.admin;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.example.demo.mapper.BookMapper;
import com.example.demo.model.Book;

@RequestMapping("/admin/book")
@Controller
public class AdminBookController {
    private final BookMapper bookMapper;
    private static final Logger logger = LoggerFactory.getLogger(AdminBookController.class);

    public AdminBookController(BookMapper bookMapper) {
        this.bookMapper = bookMapper;
    }
    
    @GetMapping("/all")
    public String bookList(Model model) {
    	List<Book> bookList = bookMapper.getBooksList();
    	
    	model.addAttribute("booklist", bookList);
    	
        return "book"; //
    }
    
    @GetMapping("/titles")
    public ResponseEntity<List<Book>> getAllBookIdsAndTitles() {
        try {
            List<Book> books = bookMapper.findAllBookIdsAndTitles();
            return new ResponseEntity<>(books, HttpStatus.OK);
        } catch (Exception e) {
            logger.error("Error retrieving book IDs and titles", e);
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

}
