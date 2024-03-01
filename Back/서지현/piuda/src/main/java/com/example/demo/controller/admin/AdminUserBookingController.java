package com.example.demo.controller.admin;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.demo.mapper.UserBookingMapper;
import com.example.demo.model.UserBooking;
import com.example.demo.service.admin.AdminUserBookingService;

@RequestMapping("/admin/booking")
@Controller
public class AdminUserBookingController {
	private final UserBookingMapper mapper;
	private final AdminUserBookingService adminUserBookingService;

    public AdminUserBookingController(UserBookingMapper mapper, AdminUserBookingService adminUserBookingService) {
        this.mapper = mapper;
        this.adminUserBookingService = adminUserBookingService;
    }

    
    @GetMapping("/all")
    public String bookingList(Model model) {
    	List<UserBooking> bookingList = mapper.getBookingList();
    	
    	model.addAttribute("bookinglist", bookingList);
    	
        return "booking";
    }
    
    
    @PostMapping("/apply")
    public String applyLoan(Long user_id, String book_id, RedirectAttributes redirectAttributes) {
        try {
            adminUserBookingService.applyLoan(user_id, book_id);
            adminUserBookingService.deleteBooking(user_id, book_id);
            redirectAttributes.addFlashAttribute("successMessage", "대출이 성공적으로 처리되었습니다.");
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("errorMessage", "대출에 실패하였습니다.");
        }
        return "redirect:/admin/booking/all";
    }

    @GetMapping("/delete")
    public String deleteReview(Long user_id, String book_id) {
    	adminUserBookingService.deleteBooking(user_id, book_id);
        return "redirect:/admin/booking/all";
    }
}
