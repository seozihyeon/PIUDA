package com.example.demo.mapper;

import java.time.LocalDate;
import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.One;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Result;
import org.apache.ibatis.annotations.Results;
import org.apache.ibatis.annotations.Select;

import com.example.demo.model.Book;
import com.example.demo.model.UserBooking;
import com.example.demo.model.Users;

@Mapper
public interface UserBookingMapper {
    @Insert("INSERT INTO userbooking (user_id, book_id, reserve_date) VALUES (#{user.id}, #{book.id}, #{reserveDate})")
    int insertUserBooking(@Param("user") Users user, @Param("book") Book book, @Param("reserveDate") LocalDate reserveDate);

    @Delete("DELETE FROM userbooking WHERE user_id = #{user.id} AND book_id = #{book.id}")
    int deleteUserBooking(@Param("user") Users user, @Param("book") Book book);
    
    @Select("SELECT * FROM userbooking WHERE user_id = #{user_id}")
    @Results({
        @Result(property = "user", column = "user_id", javaType = Users.class, one = @One(select = "com.example.demo.mapper.UsersMapper.getUserProfile")),
        @Result(property = "book", column = "book_id", javaType = Book.class, one = @One(select = "com.example.demo.mapper.BookMapper.findByBookId"))
    })
    List<UserBooking> getUserBookingList(@Param("user_id") Long user_id);
    
    @Select("SELECT * FROM userbooking")
    @Results({
        @Result(property = "user", column = "user_id", javaType = Users.class, one = @One(select = "com.example.demo.mapper.UsersMapper.getUserProfile")),
        @Result(property = "book", column = "book_id", javaType = Book.class, one = @One(select = "com.example.demo.mapper.BookMapper.findByBookId"))
    })
    List<UserBooking> getBookingList();
}