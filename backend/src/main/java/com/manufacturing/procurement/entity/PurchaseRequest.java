package com.manufacturing.procurement.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@TableName("purchase_request")
public class PurchaseRequest {
    @TableId(type = IdType.AUTO)
    private Long id;
    private String requestNo;
    private Long projectId;
    private Long applicantId;
    private LocalDate expectDate;
    private String priority;
    private String description;
    private String materials;
    private String attachments;
    private Integer status;
    private String auditOpinion;
    private Long auditUserId;
    private LocalDateTime auditTime;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
    @TableLogic
    private Integer deleted;
}
