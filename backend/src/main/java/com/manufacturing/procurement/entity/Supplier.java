package com.manufacturing.procurement.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("supplier")
public class Supplier {
    @TableId(type = IdType.AUTO)
    private Long id;
    private String name;
    private String contactPerson;
    private String phone;
    private String email;
    private String address;
    private String businessLicense;
    private String idCard;
    private String qualification;
    private Integer status;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
    @TableLogic
    private Integer deleted;
}