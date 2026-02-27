package com.manufacturing.procurement.service;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.manufacturing.procurement.entity.Supplier;
import com.manufacturing.procurement.mapper.SupplierMapper;
import org.springframework.stereotype.Service;

@Service
public class SupplierService extends ServiceImpl<SupplierMapper, Supplier> {
}