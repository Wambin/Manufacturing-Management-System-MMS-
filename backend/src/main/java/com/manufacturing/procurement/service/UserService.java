package com.manufacturing.procurement.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.manufacturing.procurement.entity.User;
import com.manufacturing.procurement.mapper.UserMapper;
import org.springframework.stereotype.Service;

@Service
public class UserService extends ServiceImpl<UserMapper, User> {
    public User login(String username, String password) {
        LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(User::getUsername, username)
                .eq(User::getPassword, password)
                .eq(User::getStatus, 1);
        return getOne(wrapper);
    }
}
