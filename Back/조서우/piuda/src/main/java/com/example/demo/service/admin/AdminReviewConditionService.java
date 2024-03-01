package com.example.demo.service.admin;

import org.springframework.stereotype.Service;
import com.example.demo.mapper.ReviewConditionMapper;

@Service
public class AdminReviewConditionService {
	
	private final ReviewConditionMapper reviewConditionMapper;
	
	public AdminReviewConditionService(ReviewConditionMapper reviewConditionMapper) {
		this.reviewConditionMapper = reviewConditionMapper;
	}
	
	public void deleteCondition(Long condition_id) {
		reviewConditionMapper.deleteReviewCondition(condition_id);
	}
}
