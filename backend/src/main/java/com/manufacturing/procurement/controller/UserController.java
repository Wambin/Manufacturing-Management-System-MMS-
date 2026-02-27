package com.manufacturing.procurement.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.manufacturing.procurement.common.Result;
import com.manufacturing.procurement.entity.User;
import com.manufacturing.procurement.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/user")
public class UserController {
    @Autowired
    private UserService userService;

    @GetMapping("/list")
    public Result<Page<User>> list(@RequestParam(defaultValue = "1") Integer current,
                                    @RequestParam(defaultValue = "10") Integer size,
                                    @RequestParam(required = false) String keyword) {
        Page<User> page = new Page<>(current, size);
        LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<>();
        if (keyword != null && !keyword.isEmpty()) {
            wrapper.like(User::getUsername, keyword)
                    .or().like(User::getRealName, keyword);
        }
        wrapper.orderByDesc(User::getCreateTime);
        return Result.success(userService.page(page, wrapper));
    }

    @PostMapping
    public Result<Void> save(@RequestBody User user) {
        userService.save(user);
        return Result.success();
    }

    @PutMapping
    public Result<Void> update(@RequestBody User user) {
        userService.updateById(user);
        return Result.success();
    }

    @DeleteMapping("/{id}")
    public Result<Void> delete(@PathVariable Long id) {
        userService.removeById(id);
        return Result.success();
    }

    @GetMapping("/{id}")
    public Result<User> getById(@PathVariable Long id) {
        return Result.success(userService.getById(id));
    }
}
