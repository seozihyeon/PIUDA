package com.example.demo.controller;

import java.time.LocalDate;
import java.time.ZoneId;
import java.util.Date;
import java.util.List;

import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.demo.mapper.NewBookMapper;
import com.example.demo.model.NewBook;

@RestController
@RequestMapping("/newbooks")
public class NewBookController {

    private final NewBookMapper newBookMapper;

    public NewBookController(NewBookMapper newBookMapper) {
        this.newBookMapper = newBookMapper;
    }
    
    public static Date localDateToDate(LocalDate localDate) {
        return Date.from(localDate.atStartOfDay(ZoneId.systemDefault()).toInstant());
    }

//    @GetMapping("/all")
//    public List<NewBook> getAllNewBooks() {
//        return newBookMapper.getAllNewBooks();
//    }
    
//    @GetMapping("/{library}")
//    public List<NewBook> getNewBooksByLibrary(@PathVariable String library) {
//        return newBookMapper.getNewBooksByLibrary(library);
//    }
    
    @GetMapping("/all")
    public List<NewBook> getAllNewBooks(@RequestParam(value = "startDate", required = false) 
                                         @DateTimeFormat(pattern="yyyy-MM-dd") LocalDate startDate,
                                         @RequestParam(value = "endDate", required = false) 
                                         @DateTimeFormat(pattern="yyyy-MM-dd") LocalDate endDate) {
        // 기본값 설정
    	if (startDate == null) {
    	    startDate = LocalDate.now().minusMonths(1);
    	}

        if (endDate == null) {
            endDate = LocalDate.now(); 
        }

        Date startDateAsDate = localDateToDate(startDate);
        Date endDateAsDate = localDateToDate(endDate);
        
        return newBookMapper.getAllNewBooksBetweenDates(startDateAsDate, endDateAsDate);
    }
    
    
    @GetMapping("/{library}")
    public List<NewBook> getNewBooksByLibraryAndDateRange(
            @PathVariable String library,
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate startDate,
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate endDate) {
        
        // 기본값 설정
        if (startDate == null) {
            startDate = LocalDate.now().minusMonths(1);
        }

        if (endDate == null) {
            endDate = LocalDate.now(); 
        }
        
        Date startDateAsDate = localDateToDate(startDate);
        Date endDateAsDate = localDateToDate(endDate);
        
        // 호출할 매퍼 메소드 추가
        return newBookMapper.getNewBooksByLibraryAndDateRange(library, startDateAsDate, endDateAsDate);
    }
    
    
}