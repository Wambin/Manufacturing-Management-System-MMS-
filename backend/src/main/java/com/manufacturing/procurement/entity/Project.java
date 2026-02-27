package com.manufacturing.procurement.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@TableName("project")
public class Project {
    @TableId(type = IdType.AUTO)
    private Long id;
    private String projectNo;
    private String projectName;
    private String status;
    private String equipmentNo;
    private String projectManager;
    private LocalDate startDate;
    private LocalDate endDate;
    private String description;
    private String equipmentImages;
    private String drawings;
    private String sitePhotos;
    private Long createUserId;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
    @TableLogic
    private Integer deleted;
}
