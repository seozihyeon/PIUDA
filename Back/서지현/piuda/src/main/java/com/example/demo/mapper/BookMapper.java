package com.example.demo.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.example.demo.model.Book;

@Mapper
public interface BookMapper {	
    @Select("SELECT * FROM books WHERE book_title LIKE CONCAT('%', #{book_title}, '%')")
    List<Book> findByBookTitle(@Param("book_title") String book_title);
    
    @Select("SELECT * FROM books WHERE author LIKE CONCAT('%', #{author}, '%')")
    List<Book> findByAuthor(@Param("author") String author);
    
    @Select("SELECT * FROM books WHERE publisher LIKE CONCAT('%', #{publisher}, '%')")
    List<Book> findByPublisher(@Param("publisher") String publisher);
    
    @Select("SELECT * FROM books WHERE book_id = #{book_id}")
    Book findByBookId(@Param("book_id") String book_id);
    
    @Update("UPDATE books SET reserved = #{reserved} WHERE book_id = #{book_id}")
    int updateBookReservedStatus(@Param("book_id") String book_id, @Param("reserved") boolean reserved);

    //
    @Select("SELECT * FROM books WHERE book_title LIKE CONCAT('%', #{book_title}, '%') ORDER BY book_id LIMIT #{pageSize} OFFSET #{offset}")
    List<Book> findByBookTitlePaged(@Param("book_title") String book_title, @Param("pageSize") int pageSize, @Param("offset") int offset);
    
    @Select("SELECT * FROM books WHERE author LIKE CONCAT('%', #{author}, '%') ORDER BY book_id LIMIT #{pageSize} OFFSET #{offset}")
    List<Book> findByAuthorPaged(@Param("author") String author, @Param("pageSize") int pageSize, @Param("offset") int offset);
    
    @Select("SELECT * FROM books WHERE publisher LIKE CONCAT('%', #{publisher}, '%') ORDER BY book_id LIMIT #{pageSize} OFFSET #{offset}")
    List<Book> findByPublisherPaged(@Param("publisher") String publisher, @Param("pageSize") int pageSize, @Param("offset") int offset);
    
    @Select("SELECT COUNT(*) FROM books WHERE book_title LIKE CONCAT('%', #{book_title}, '%') OR author LIKE CONCAT('%', #{author}, '%') OR publisher LIKE CONCAT('%', #{publisher}, '%')")
    long countBooksPaged(@Param("book_title") String bookTitle, @Param("author") String author, @Param("publisher") String publisher);
    
    @Update("UPDATE books SET borrowed = #{borrowed} WHERE book_id = #{book_id}")
    void updateBorrowedStatus(@Param("book_id") String book_id, @Param("borrowed") boolean borrowed);
}