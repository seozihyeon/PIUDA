package com.example.demo.service.admin;

import org.springframework.stereotype.Service;

import com.example.demo.mapper.ReviewMapper;

@Service
public class AdminReviewService {
	private final ReviewMapper reviewMapper;
	
	public AdminReviewService(ReviewMapper reviewMapper) {
		this.reviewMapper = reviewMapper;
	}
	
	public void deleteReview(Long review_id) {
		reviewMapper.deleteReview(review_id);
	}

}
