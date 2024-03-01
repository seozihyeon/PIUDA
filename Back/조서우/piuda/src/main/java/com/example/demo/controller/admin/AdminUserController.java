package com.example.demo.controller.admin;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.example.demo.mapper.UsersMapper;
import com.example.demo.model.Users;

@RequestMapping("/admin/user")
@Controller
public class AdminUserController {
    private final UsersMapper mapper;

    public AdminUserController(UsersMapper mapper) {
        this.mapper = mapper;
    }
    
    @GetMapping("/all")
    public String userList(Model model) {
    	List<Users> userList = mapper.getUserProfileList();
    	
    	model.addAttribute("userlist", userList);
    	
        return "user";
    }
    
    @GetMapping("/all/list")
    public List<Users> getAllUsers() {
        return mapper.getUserProfileList();
    }
}
