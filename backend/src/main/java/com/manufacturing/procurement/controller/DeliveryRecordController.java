package com.manufacturing.procurement.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.manufacturing.procurement.common.Result;
import com.manufacturing.procurement.entity.DeliveryRecord;
import com.manufacturing.procurement.entity.PurchaseOrder;
import com.manufacturing.procurement.service.DeliveryRecordService;
import com.manufacturing.procurement.service.PurchaseOrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.time.LocalDateTime;

@RestController
@RequestMapping("/api/delivery/record")
public class DeliveryRecordController {
    @Autowired
    private DeliveryRecordService deliveryRecordService;

    @GetMapping("/list")
    public Result<Page<DeliveryRecord>> list(@RequestParam(defaultValue = "1") Integer current,
                                               @RequestParam(defaultValue = "10") Integer size,
                                               @RequestParam(required = false) Long orderId) {
        Page<DeliveryRecord> page = new Page<>(current, size);
        LambdaQueryWrapper<DeliveryRecord> wrapper = new LambdaQueryWrapper<>();
        if (orderId != null) {
            wrapper.eq(DeliveryRecord::getOrderId, orderId);
        }
        wrapper.orderByDesc(DeliveryRecord::getCreateTime);
        return Result.success(deliveryRecordService.page(page, wrapper));
    }

    @PostMapping
    public Result<Void> save(@RequestBody DeliveryRecord record) {
        if (record.getDeliveryNo() == null || record.getDeliveryNo().isEmpty()) {
            record.setDeliveryNo("DN" + System.currentTimeMillis());
        }
        deliveryRecordService.save(record);
        return Result.success();
    }

    @PutMapping
    public Result<Void> update(@RequestBody DeliveryRecord record) {
        deliveryRecordService.updateById(record);
        return Result.success();
    }

    @DeleteMapping("/{id}")
    public Result<Void> delete(@PathVariable Long id) {
        deliveryRecordService.removeById(id);
        return Result.success();
    }

    @GetMapping("/{id}")
    public Result<DeliveryRecord> getById(@PathVariable Long id) {
        return Result.success(deliveryRecordService.getById(id));
    }

    @Autowired
    private PurchaseOrderService purchaseOrderService;

    @PutMapping("/{id}/receive")
    public Result<Void> receive(@PathVariable Long id) {
        DeliveryRecord record = deliveryRecordService.getById(id);
        record.setStatus(1);
        record.setReceiveTime(LocalDateTime.now());
        deliveryRecordService.updateById(record);

        // 更新采购订单的已收货数量
        if (record.getOrderId() != null) {
            PurchaseOrder order = purchaseOrderService.getById(record.getOrderId());
            if (order != null) {
                order.setReceivedQuantity((order.getReceivedQuantity() != null ? order.getReceivedQuantity() : 0) + 1);
                order.setStatus(4); // 更新为已收货状态
                purchaseOrderService.updateById(order);
            }
        }

        return Result.success();
    }
}
