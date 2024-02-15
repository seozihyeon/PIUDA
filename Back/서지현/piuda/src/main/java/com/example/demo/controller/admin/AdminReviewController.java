package com.example.demo.controller.admin;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.example.demo.mapper.ReviewMapper;
import com.example.demo.model.Review;
import com.example.demo.service.admin.AdminReviewService;

@RequestMapping("/admin/review")
@Controller
public class AdminReviewController {
	private final ReviewMapper reviewMapper;
    private final AdminReviewService adminReviewService;


    public AdminReviewController(ReviewMapper reviewMapper, AdminReviewService adminReviewService) {
        this.reviewMapper = reviewMapper;
        this.adminReviewService = adminReviewService;
    }
    
    @GetMapping("/all")
    public String userList(Model model) {
        List<Review> reviewList = reviewMapper.getAllReviews();
        model.addAttribute("reviewlist", reviewList);
        return "review"; //
    }
    
    @GetMapping("/delete")
    public String deleteReview(Long review_id) {
		adminReviewService.deleteReview(review_id);
        return "redirect:/admin/review/all";
    }
}
