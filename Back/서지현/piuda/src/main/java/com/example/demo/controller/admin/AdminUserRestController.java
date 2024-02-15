package com.example.demo.controller.admin;

import org.springframework.web.bind.annotation.*;
import com.example.demo.mapper.UsersMapper;
import com.example.demo.model.Users;

import java.util.List;

@RestController
@RequestMapping("/admin/users") // 관리자용 URL 접두사
public class AdminUserRestController {
    private final UsersMapper mapper;

    public AdminUserRestController(UsersMapper mapper) {
        this.mapper = mapper;
    }

    @GetMapping("/list")
    public List<Users> getAllUsers() {
        return mapper.getUserProfileList();
    }

}