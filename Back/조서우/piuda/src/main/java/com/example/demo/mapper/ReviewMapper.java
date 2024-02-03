package com.example.demo.mapper;

import com.example.demo.model.Review;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Options;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import java.util.List;

import org.apache.ibatis.annotations.Delete;

@Mapper
public interface ReviewMapper {
	
	@Select("SELECT r.*, u.user_name, b.book_id, b.book_title, b.publisher, b.book_size, b.book_price, b.book_classification, b.book_isbn, b.book_media, b.book_series " +
	        "FROM review r " +
	        "JOIN loan l ON r.loan_id = l.loan_id " +
	        "JOIN users u ON l.user_id = u.user_id " +
	        "JOIN books b ON l.book_id = b.book_id " +
	        "WHERE b.book_isbn = #{book_isbn}")
	List<Review> getReviewsByIsbn(@Param("book_isbn") String book_isbn);

	

	@Insert("INSERT INTO review (loan_id, review_content, review_score, review_date) " +
	        "VALUES (#{loan.loan_id}, #{review_content}, #{review_score}, #{review_date})")
	@Options(useGeneratedKeys = true, keyProperty = "review_id")
	void insertReview(Review review);



    @Delete("DELETE FROM review WHERE review_id = #{review_id}")
    int deleteReview(@Param("review_id") Long review_id);
    
    @Update("UPDATE review SET review_content = #{review_content} WHERE review_id = #{review_id}")
    int updateReview(Review review);
    
    
}