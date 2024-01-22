package com.example.demo.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import com.example.demo.model.Book;

@Mapper
public interface BookMapper {
    @Select("SELECT * FROM books WHERE book_title LIKE CONCAT('%', #{book_title}, '%')")
    List<Book> findByBookTitle(@Param("book_title") String book_title);
}

