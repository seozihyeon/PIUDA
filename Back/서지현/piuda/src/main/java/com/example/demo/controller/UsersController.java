package com.example.demo.controller;

import java.util.List;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.demo.mapper.UsersMapper;
import com.example.demo.model.Users;
import com.fasterxml.jackson.annotation.JsonProperty;

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
        @JsonProperty("user_id")
        private Long user_id;
        @JsonProperty("user_name")
        private String user_name;

        // Getters and Setters
        public Long getId() {
            return user_id;
        }

        public String getName() {
            return user_name;
        }
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody LoginRequest loginRequest) {
        System.out.println("Received login request: " + loginRequest);
        Users user = mapper.findByUserIdAndUserName(loginRequest.getId(), loginRequest.getName());

        if (user != null) {
            // 사용자가 데이터베이스에 존재하므로 인증 성공
            return ResponseEntity.ok().body("User authenticated successfully");
        } else {
            // 사용자가 데이터베이스에 존재하지 않으므로 인증 실패
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Authentication failed: User not found");
        }
    }
    
    @PostMapping("/logout")
    public ResponseEntity<?> logout() {
        // 로그아웃 관련 로직 수행
        // 예: 토큰 무효화, 세션 삭제 등
        return ResponseEntity.ok().body("Logged out successfully");
    }
    
    @GetMapping("/userstatus/{user_id}")
    public ResponseEntity<String> getUserStatus(@PathVariable("user_id") Long user_id) {
        String userStatus = mapper.getUserStatus(user_id);
        if (userStatus != null) {
            return ResponseEntity.ok().body(userStatus);
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("User not found");
        }
    }
    
    @GetMapping("/b/{user_id}")
    public ResponseEntity<String> getUserBarcode(@PathVariable("user_id") Long user_id) {
        String userBarcode = mapper.getUserBarcode(user_id);
        if (userBarcode != null) {
            return ResponseEntity.ok().body(userBarcode);
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("User not found");
        }
    }
    
    
   
}