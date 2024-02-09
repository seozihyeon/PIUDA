package com.example.demo.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.example.demo.model.Book;

@Mapper
public interface BookMapper {	    
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
    
    @Select({
        "<script>",
        "SELECT COUNT(*) FROM books WHERE (",
        "<foreach item='library' index='index' collection='libraries' open='' separator=' OR ' close=''>",
        "   library = #{library}",
        "</foreach>",
        ") AND (book_title LIKE CONCAT('%', #{bookTitle}, '%') OR author LIKE CONCAT('%', #{author}, '%') OR publisher LIKE CONCAT('%', #{publisher}, '%'))",
        "</script>"
    })
    long countBooksPagedWithLibraries(@Param("bookTitle") String bookTitle, @Param("author") String author, @Param("publisher") String publisher, @Param("libraries") List<String> libraries);
    
    @Update("UPDATE books SET borrowed = #{borrowed} WHERE book_id = #{book_id}")
    void updateBorrowedStatus(@Param("book_id") String book_id, @Param("borrowed") boolean borrowed);
    
    @Select({
        "<script>",
        "SELECT * FROM books WHERE (",
        "<foreach item='library' index='index' collection='libraries' open='' separator=' OR ' close=''>",
        "   library = #{library}",
        "</foreach>",
        ") AND book_title LIKE CONCAT('%', #{book_title}, '%')",
        "ORDER BY book_id LIMIT #{pageSize} OFFSET #{offset}",
        "</script>"
    })
    List<Book> findByLibrariesAndTitlePaged(@Param("libraries") List<String> libraries, @Param("book_title") String book_title, @Param("pageSize") int pageSize, @Param("offset") int offset);

    
    @Select({
        "<script>",
        "SELECT * FROM books WHERE (",
        "<foreach item='library' index='index' collection='libraries' open='' separator=' OR ' close=''>",
        "   library = #{library}",
        "</foreach>",
        ")   AND author LIKE CONCAT('%', #{author}, '%')",
        "ORDER BY book_id LIMIT #{pageSize} OFFSET #{offset}",
        "</script>"
    })
    List<Book> findByLibrariesAndAuthorPaged(@Param("libraries") List<String> libraries, @Param("author") String author, @Param("pageSize") int pageSize, @Param("offset") int offset);

    @Select({
        "<script>",
        "SELECT * FROM books WHERE (",
        "<foreach item='library' index='index' collection='libraries' open='' separator=' OR ' close=''>",
        "   library = #{library}",
        "</foreach>",
        ")   AND publisher LIKE CONCAT('%', #{publisher}, '%')",
        "ORDER BY book_id LIMIT #{pageSize} OFFSET #{offset}",
        "</script>"
    })
    List<Book> findByLibrariesAndPublisherPaged(@Param("libraries") List<String> libraries, @Param("publisher") String publisher, @Param("pageSize") int pageSize, @Param("offset") int offset);

}