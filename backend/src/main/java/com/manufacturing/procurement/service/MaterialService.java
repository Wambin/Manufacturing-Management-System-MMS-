package com.manufacturing.procurement.service;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.manufacturing.procurement.entity.Material;
import com.manufacturing.procurement.mapper.MaterialMapper;
import org.springframework.stereotype.Service;

@Service
public class MaterialService extends ServiceImpl<MaterialMapper, Material> {
}
