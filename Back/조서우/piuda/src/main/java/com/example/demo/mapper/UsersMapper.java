package com.example.demo.mapper;


import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.example.demo.model.Users;


@Mapper
public interface UsersMapper {
	@Select("SELECT * FROM Users WHERE user_id=#{user_id}")
	Users getUserProfile(@Param("user_id") Long id);
	
	@Select("SELECT * FROM Users")
	List<Users> getUserProfileList();
	
	@Insert("INSERT INTO Users VALUES(#{user_id}, #{user_name}, #{user_status}, #{barcode_img})")
	int insertUserProfile(@Param("user_id") Long user_id, @Param("user_name") String user_name, @Param("user_status") String user_status, @Param("barcode_img") String barcode_img);

	@Update("UPDATE Users SET user_name=#{user_name}, user_status=#{user_status}, barcode_img=#{barcode_img} WHERE user_id=#{user_id}")
	int updateUserProfile(@Param("user_id") Long user_id, @Param("user_name") String user_name, @Param("user_status") String user_status, @Param("barcode_img") String barcode_img);

	@Delete("DELETE FROM Users WHERE user_id=#{user_id}")
	int deleteUserProfile(@Param("user_id") Long user_id);
	
	@Select("SELECT * FROM users WHERE user_id = #{user_id} AND user_name = #{user_name}")
	Users findByUserIdAndUserName(@Param("user_id") Long userId, @Param("user_name") String userName);
	
	@Select("SELECT user_status FROM users WHERE user_id = #{user_id}")
    String getUserStatus(@Param("user_id") Long user_id);
}