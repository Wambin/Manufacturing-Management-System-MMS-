package com.manufacturing.procurement.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("material")
public class Material {
    @TableId(type = IdType.AUTO)
    private Long id;
    private String materialCode;
    private String materialName;
    private String materialType;
    private String specification;
    private String material;
    private String unit;
    private BigDecimal weight;
    private String size;
    private String technicalParams;
    private String mainImage;
    private String auxiliaryImages;
    private String drawings;
    private Integer status;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
    @TableLogic
    private Integer deleted;
}
