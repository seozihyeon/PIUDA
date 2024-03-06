package com.example.demo.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.mapper.NewBookMapper;
import com.example.demo.model.NewBook;

@Service
public class NewBookService {

	@Autowired
    private NewBookMapper newBookMapper;

    public List<NewBook> getNewBooksOrderedByDateDesc() {
        return newBookMapper.NewBookOrderedByDateDesc();
    }

    //안씀..
//    public List<NewBook> getNewBooksFilteredByLibrary(String library) {
//        return newBookMapper.NewBookFilteredByLibrary(library);
//    }
}
