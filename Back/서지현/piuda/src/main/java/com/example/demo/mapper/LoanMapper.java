package com.example.demo.mapper;
import org.apache.ibatis.annotations.Result;
import org.apache.ibatis.annotations.Results;

import java.util.List;
import org.apache.ibatis.annotations.One;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Options;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.example.demo.model.Book;
import com.example.demo.model.Loan;
import com.example.demo.model.Users;

@Mapper
public interface LoanMapper {
    @Insert("INSERT INTO loan (user_id, book_id, loan_date, expect_date, return_date, return_status) " +
            "VALUES (#{user.id}, #{book.id}, #{loan_date}, #{expect_date}, #{return_date}, #{return_status})")
    @Options(useGeneratedKeys = true, keyProperty = "loan_id")
    void insertLoan(Loan loan);
    
    
    @Select("SELECT * FROM loan WHERE user_id = #{user_id}")
    @Results({
        @Result(property = "user", column = "user_id", javaType = Users.class, one = @One(select = "com.example.demo.mapper.UsersMapper.getUserProfile")),
        @Result(property = "book", column = "book_id", javaType = Book.class, one = @One(select = "com.example.demo.mapper.BookMapper.findByBookId"))
    })
    List<Loan> getLoansByUserId(@Param("user_id") Long user_id);

    
    @Select("SELECT * FROM loan WHERE loan_id = #{loan_id}")
    Loan getLoanById(@Param("loan_id") Long loan_id);
    
    //반납
    @Update("UPDATE loan SET return_date = #{return_date}, return_status = #{return_status} WHERE loan_id = #{loan_id}")
    void returnBook(Loan loan);
    
    //연장
    @Update("UPDATE loan SET expect_date = #{expect_date, jdbcType=DATE}, extend_status = #{extend_status} WHERE loan_id = #{loan_id, jdbcType=BIGINT}")
    void extendLoan(Loan loan);
    
    @Select("SELECT b.book_isbn FROM loan l JOIN books b ON l.book_id = b.book_id WHERE l.loan_id = #{loan_id}")
    String getIsbnByLoanId(@Param("loan_id") Long loan_id);
    
    @Select("SELECT b.book_isbn " +
            "FROM loan l " +
            "JOIN books b ON l.book_id = b.book_id " +
            "WHERE l.loan_id = #{loan_id}")
    String getBookIsbnByLoanId(@Param("loan_id") Long loan_id);

}