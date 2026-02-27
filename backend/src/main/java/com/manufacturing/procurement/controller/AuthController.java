package com.manufacturing.procurement.controller;

import com.manufacturing.procurement.common.Result;
import com.manufacturing.procurement.entity.User;
import com.manufacturing.procurement.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/auth")
public class AuthController {
    @Autowired
    private UserService userService;

    @PostMapping("/login")
    public Result<Map<String, Object>> login(@RequestBody User user) {
        User loginUser = userService.login(user.getUsername(), user.getPassword());
        if (loginUser != null) {
            Map<String, Object> data = new HashMap<>();
            data.put("user", loginUser);
            data.put("token", "token_" + loginUser.getId());
            return Result.success(data);
        }
        return Result.error("用户名或密码错误");
    }
}
