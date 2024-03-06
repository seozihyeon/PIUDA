package com.example.demo.controller.admin;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.example.demo.mapper.ReviewConditionMapper;
import com.example.demo.model.ReviewCondition;
import com.example.demo.service.admin.AdminReviewConditionService;

@RequestMapping("/admin/reviewcondition")
@Controller
public class AdminReviewConditionController {
    private final ReviewConditionMapper reviewConditionMapper;
    private final AdminReviewConditionService adminReviewConditionService;


    public AdminReviewConditionController(ReviewConditionMapper reviewConditionMapper, AdminReviewConditionService adminReviewConditionService) {
        this.reviewConditionMapper = reviewConditionMapper;
        this.adminReviewConditionService = adminReviewConditionService;
    }
    
    @GetMapping("/all")
    public String userList(Model model) {
        List<ReviewCondition> reviewCondidtionList = reviewConditionMapper.getAllReviewConditions();
        model.addAttribute("conditionlist", reviewCondidtionList);
        return "reviewcondition"; //
    }
    
    @GetMapping("/delete")
    public String deleteReviewCondition(Long condition_id) {
		adminReviewConditionService.deleteCondition(condition_id);
        return "redirect:/admin/reviewcondition/all";
    }
}

