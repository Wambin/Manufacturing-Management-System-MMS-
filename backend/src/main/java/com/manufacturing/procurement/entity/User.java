package com.manufacturing.procurement.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("sys_user")
public class User {
    @TableId(type = IdType.AUTO)
    private Long id;
    private String username;
    private String password;
    private String realName;
    private String role;
    private String avatar;
    private String phone;
    private String email;
    private Integer status;
    private Long supplierId;
    private LocalDateTime lastLoginTime;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
    @TableLogic
    private Integer deleted;
}
