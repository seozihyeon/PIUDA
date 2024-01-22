package com.example.demo.controller;

import java.util.List;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.example.demo.mapper.UsersMapper;
import com.example.demo.model.Users;

@RestController
public class UsersController {
    private UsersMapper mapper;

    public UsersController(UsersMapper mapper) {
        this.mapper = mapper;
    }

    @GetMapping("/user/{user_id}")
    public Users getUserProfile(@PathVariable("user_id") Long user_id) {
        return mapper.getUserProfile(user_id);
    }

    @GetMapping("/user/all")
    public List<Users> getUserProfileList() {
        return mapper.getUserProfileList();
    }

    @PutMapping("/user/{user_id}")
    public void putUserProfile(@PathVariable("user_id") Long user_id, @RequestParam("user_name") String user_name, @RequestParam("user_status") String user_status, @RequestParam("barcode_img") String barcode_img) {
        mapper.insertUserProfile(user_id, user_name, user_status, barcode_img);
    }

    @PostMapping("/user/{user_id}")
    public void postUserProfile(@PathVariable("user_id") Long user_id, @RequestParam("user_name") String user_name, @RequestParam("user_status") String user_status, @RequestParam("barcode_img") String barcode_img) {
        mapper.updateUserProfile(user_id, user_name, user_status, barcode_img);
    }

    @DeleteMapping("/user/{user_id}")
    public void deleteUserProfile(@PathVariable("user_id") Long user_id) {
        mapper.deleteUserProfile(user_id);
    }

    // Login DTO class
    public static class LoginRequest {
        private Long userId;
        private String userName;

        // Getters and Setters
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody LoginRequest loginRequest) {
        boolean isAuthenticated = authenticate(loginRequest.getUserId(), loginRequest.getUserName());

        if (isAuthenticated) {
            // 인증 성공
            return ResponseEntity.ok().body("User authenticated successfully");
        } else {
            // 인증 실패
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Authentication failed");
        }
    }

    // 간단한 인증 로직 예시
    private boolean authenticate(Long userId, String userName) {
        // 여기에 실제 인증 로직을 구현합니다.
        // 예시로, 단순히 userId와 userName이 null이 아니면 인증이 성공했다고 가정합니다.
        return userId != null && userName != null;
    }
}
