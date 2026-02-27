package com.manufacturing.procurement.service;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.manufacturing.procurement.entity.Project;
import com.manufacturing.procurement.mapper.ProjectMapper;
import org.springframework.stereotype.Service;

@Service
public class ProjectService extends ServiceImpl<ProjectMapper, Project> {
}
