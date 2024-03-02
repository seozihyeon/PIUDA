package com.example.demo.mapper;

import java.util.Date;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.One;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Result;
import org.apache.ibatis.annotations.Results;
import org.apache.ibatis.annotations.Select;

import com.example.demo.model.Book;
import com.example.demo.model.NewBook;

@Mapper
public interface NewBookMapper {
	//안씀 테스트
	@Select("SELECT * FROM newbooks")
    @Results({
        @Result(property = "newbook_id", column = "newbook_id"),
        @Result(property = "book", column = "book_id", 
                javaType = Book.class, 
                one = @One(select = "com.example.demo.mapper.BookMapper.findByBookId"))
    })
	List<NewBook> getAllNewBooks();
	
	//안씀 테스트
	@Select("SELECT * FROM newbooks WHERE book_id IN (SELECT book_id FROM books WHERE library = #{library})")
	@Results({
        @Result(property = "newbook_id", column = "newbook_id"),
        @Result(property = "book", column = "book_id", 
                javaType = Book.class, 
                one = @One(select = "com.example.demo.mapper.BookMapper.findByBookId"))
    })
	List<NewBook> getNewBooksByLibrary(String library);
	
	//목록 전체도서관&날짜 필터링 용
	@Select("SELECT * FROM newbooks WHERE newbook_date BETWEEN #{startDate} AND #{endDate}")
	@Results({
	    @Result(property = "newbook_id", column = "newbook_id"),
	    @Result(property = "book", column = "book_id", 
	            javaType = Book.class, 
	            one = @One(select = "com.example.demo.mapper.BookMapper.findByBookId"))
	})
	List<NewBook> getAllNewBooksBetweenDates(@Param("startDate") Date startDate, @Param("endDate") Date endDate);

	
	//목록 선택도서관&날짜 필터링 용
	@Select("SELECT * FROM newbooks WHERE book_id IN (SELECT book_id FROM books WHERE library = #{library}) AND newbook_date BETWEEN #{startDate} AND #{endDate}")
	@Results({
	    @Result(property = "newbook_id", column = "newbook_id"),
	    @Result(property = "book", column = "book_id", 
	            javaType = Book.class, 
	            one = @One(select = "com.example.demo.mapper.BookMapper.findByBookId"))
	})
	List<NewBook> getNewBooksByLibraryAndDateRange(@Param("library") String library, @Param("startDate") Date startDate, @Param("endDate") Date endDate);
	
	
	//메인최신순 용
	@Select("SELECT * FROM newbooks ORDER BY newbook_date DESC")
	@Results({
	    @Result(property = "newbook_id", column = "newbook_id"),
	    @Result(property = "book", column = "book_id", 
	            javaType = Book.class, 
	            one = @One(select = "com.example.demo.mapper.BookMapper.findByBookId"))
	})
    List<NewBook> NewBookOrderedByDateDesc();
	
	
//	@Select("SELECT * FROM newbooks WHERE book_id IN (SELECT book_id FROM books WHERE library = #{library})")
//	@Results({
//	    @Result(property = "newbook_id", column = "newbook_id"),
//	    @Result(property = "book", column = "book_id", 
//	            javaType = Book.class, 
//	            one = @One(select = "com.example.demo.mapper.BookMapper.findByBookId"))
//	})
//    List<NewBook> NewBookFilteredByLibrary(@Param("library") String library);
}
