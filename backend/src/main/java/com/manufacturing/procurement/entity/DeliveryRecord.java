package com.manufacturing.procurement.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@TableName("delivery_record")
public class DeliveryRecord {
    @TableId(type = IdType.AUTO)
    private Long id;
    private String deliveryNo;
    private Long orderId;
    private LocalDate deliveryDate;
    private String trackingNo;
    private String vehicleNo;
    private String deliveryAddress;
    private String contactPerson;
    private String contactPhone;
    private String receiverName;
    private String receiverPhone;
    private String receiverAddress;
    private String deliveryNote;
    private String expressPhoto;
    private String packagingPhotos;
    private String productPhotos;
    private String certificate;
    private String remark;
    private Integer status;
    private LocalDateTime receiveTime;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
    @TableLogic
    private Integer deleted;
}
