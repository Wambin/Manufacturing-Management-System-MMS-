package com.manufacturing.procurement.service;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.manufacturing.procurement.entity.PurchaseRequest;
import com.manufacturing.procurement.mapper.PurchaseRequestMapper;
import org.springframework.stereotype.Service;

@Service
public class PurchaseRequestService extends ServiceImpl<PurchaseRequestMapper, PurchaseRequest> {
}
