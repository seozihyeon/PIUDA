package com.example.demo.controller.admin;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.example.demo.mapper.UsersMapper;
import com.example.demo.model.Users;

import java.util.List;

@RestController
@RequestMapping("/admin/users") // 관리자용 URL 접두사
public class AdminUsersController {
    private final UsersMapper mapper;

    public AdminUsersController(UsersMapper mapper) {
        this.mapper = mapper;
    }

    @GetMapping("/{user_id}")
    public ResponseEntity<Users> getUserProfile(@PathVariable("user_id") Long user_id) {
        Users user = mapper.getUserProfile(user_id);
        if (user != null) {
            return ResponseEntity.ok(user);
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
        }
    }

    @GetMapping("/all")
    public List<Users> getAllUsers() {
        return mapper.getUserProfileList();
    }

    @PutMapping("/{user_id}")
    public ResponseEntity<?> updateUserProfile(@PathVariable("user_id") Long user_id, @RequestBody Users user) {
        int updated = mapper.updateUserProfile(user_id, user.getName(), user.getStatus(), user.getBarcode());
        if (updated > 0) {
            return ResponseEntity.ok().body("User profile updated successfully");
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("User not found");
        }
    }

    @DeleteMapping("/{user_id}")
    public ResponseEntity<?> deleteUserProfile(@PathVariable("user_id") Long user_id) {
        int deleted = mapper.deleteUserProfile(user_id);
        if (deleted > 0) {
            return ResponseEntity.ok().body("User profile deleted successfully");
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("User not found");
        }
    }

    // 다른 필요한 관리자 기능 추가...
}
