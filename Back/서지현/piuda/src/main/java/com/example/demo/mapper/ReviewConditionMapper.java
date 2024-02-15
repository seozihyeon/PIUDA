package com.example.demo.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.One;
import org.apache.ibatis.annotations.Result;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.example.demo.model.Loan;
import com.example.demo.model.ReviewCondition;

@Mapper
public interface ReviewConditionMapper {

	@Insert("INSERT INTO reviewcondition (loan_id, loss_score, taint_score, condition_op, condition_date) " +
            "VALUES (#{loan.loan_id}, #{loss_score}, #{taint_score}, #{condition_op}, #{condition_date})")
    void writeReviewCondition(ReviewCondition reviewCondition);

    @Update("UPDATE reviewcondition SET loss_score = #{loss_score}, taint_score = #{taint_score}, " +
            "condition_op = #{condition_op}, condition_date = #{condition_date} WHERE condition_id = #{condition_id}")
    void updateReviewCondition(ReviewCondition reviewCondition);

    @Delete("DELETE FROM reviewcondition WHERE condition_id = #{condition_id}")
    int deleteReviewCondition(Long condition_id);
    
    @Select("SELECT * FROM reviewcondition WHERE condition_id = #{condition_id}")
    ReviewCondition getReviewConditionById(Long condition_id);
    
    @Select("SELECT * FROM reviewcondition WHERE loan_id = #{loan_id}")
    ReviewCondition getReviewConditionByLoanId(Long loan_id);

    @Select("SELECT * FROM reviewcondition")
    @Result(property = "loan", column = "loan_id", javaType = Loan.class, one = @One(select = "com.example.demo.mapper.LoanMapper.getLoanById"))
    List<ReviewCondition> getAllReviewConditions();
    
    @Select("SELECT rc.*, u.user_name FROM reviewcondition rc " +
            "JOIN loan l ON rc.loan_id = l.loan_id " +
            "JOIN users u ON l.user_id = u.user_id " +
            "JOIN books b ON l.book_id = b.book_id " +
            "WHERE l.book_id = #{book_id}")
    List<ReviewCondition> getReviewConditionsByBookId(String book_id);
    
}
