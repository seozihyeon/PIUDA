package com.example.demo.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.One;
import org.apache.ibatis.annotations.Result;
import org.apache.ibatis.annotations.Results;
import org.apache.ibatis.annotations.Select;

import com.example.demo.model.Book;
import com.example.demo.model.RecommendBook;

@Mapper
public interface RecommendBookMapper {
	@Select("SELECT * FROM recommendbooks")
    @Results({
        @Result(property = "recommend_id", column = "recommend_id"),
        @Result(property = "book", column = "book_id", 
                javaType = Book.class, 
                one = @One(select = "com.example.demo.mapper.BookMapper.findByBookId"))
    })
	List<RecommendBook> getAllRecommendBooks();
}
