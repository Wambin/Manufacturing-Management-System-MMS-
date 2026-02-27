package com.manufacturing.procurement.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@TableName("purchase_order")
public class PurchaseOrder {
    @TableId(type = IdType.AUTO)
    private Long id;
    private String orderNo;
    private Long planId;
    private Long projectId;
    private Long supplierId;
    private Long requestId;
    private String contractNo;
    private LocalDate purchaseDate;
    private LocalDate deliveryDate;
    private String managerAuditor;
    private String materials;
    private String attachments;
    private Integer totalQuantity;
    private Integer shippedQuantity;
    private Integer receivedQuantity;
    private BigDecimal totalAmount;
    private Integer status;
    private Long createUserId;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
    @TableLogic
    private Integer deleted;
}
