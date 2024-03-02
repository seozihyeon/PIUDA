package com.example.demo.controller;

import java.time.LocalDate;
import java.time.ZoneId;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.demo.mapper.RecommendBookMapper;
import com.example.demo.model.RecommendBook;
import com.example.demo.service.RecommendBookService;

@RestController
@RequestMapping("/recommendbooks")
public class RecommendBookController {

	private final RecommendBookMapper recommendBookMapper;
	
	@Autowired
    private RecommendBookService recommendBookService;


    public RecommendBookController(RecommendBookMapper recommendBookMapper) {
        this.recommendBookMapper = recommendBookMapper;
    }
    
    public static Date localDateToDate(LocalDate localDate) {
        return Date.from(localDate.atStartOfDay(ZoneId.systemDefault()).toInstant());
    }
    
    
    @GetMapping("/latest")
    public List<RecommendBook> getAllRecommendBooks() {
        return recommendBookMapper.getAllRecommendBooks();
    }
    
    @GetMapping("/filter")
    public List<RecommendBook> getRecommendBooksFilteredByYearAndMonth(@RequestParam int year, @RequestParam int month) {
        List<RecommendBook> recommendBooks = recommendBookMapper.getAllRecommendBooks();
        return recommendBookService.filterByYearAndMonth(recommendBooks, year, month);
    }
}
