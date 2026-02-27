package com.manufacturing.procurement.service;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.manufacturing.procurement.entity.PurchaseOrder;
import com.manufacturing.procurement.mapper.PurchaseOrderMapper;
import org.springframework.stereotype.Service;

@Service
public class PurchaseOrderService extends ServiceImpl<PurchaseOrderMapper, PurchaseOrder> {
}
