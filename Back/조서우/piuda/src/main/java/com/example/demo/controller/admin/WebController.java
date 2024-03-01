package com.example.demo.controller.admin;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class WebController {

    @GetMapping("/admin")
    public String admin() {
        return "admin"; // 'admin.html'을 반환
    }
}