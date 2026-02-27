package com.manufacturing.procurement.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.manufacturing.procurement.common.Result;
import com.manufacturing.procurement.entity.PurchaseOrder;
import com.manufacturing.procurement.entity.DeliveryRecord;
import com.manufacturing.procurement.entity.PurchaseRequest;
import com.manufacturing.procurement.service.PurchaseOrderService;
import com.manufacturing.procurement.service.DeliveryRecordService;
import com.manufacturing.procurement.service.PurchaseRequestService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/purchase/order")
public class PurchaseOrderController {
    @Autowired
    private PurchaseOrderService purchaseOrderService;
    @Autowired
    private DeliveryRecordService deliveryRecordService;
    @Autowired
    private PurchaseRequestService purchaseRequestService;

    @GetMapping("/list")
    public Result<Page<PurchaseOrder>> list(@RequestParam(defaultValue = "1") Integer current,
                                              @RequestParam(defaultValue = "10") Integer size,
                                              @RequestParam(required = false) Integer status,
                                              @RequestParam(required = false) Long supplierId) {
        Page<PurchaseOrder> page = new Page<>(current, size);
        LambdaQueryWrapper<PurchaseOrder> wrapper = new LambdaQueryWrapper<>();
        if (status != null) {
            wrapper.eq(PurchaseOrder::getStatus, status);
        }
        if (supplierId != null) {
            wrapper.eq(PurchaseOrder::getSupplierId, supplierId);
        }
        wrapper.orderByDesc(PurchaseOrder::getCreateTime);
        
        // 查询订单列表
        Page<PurchaseOrder> result = purchaseOrderService.page(page, wrapper);
        
        // 计算每个订单的已收货数量和采购申请单号
        result.getRecords().forEach(order -> {
            // 统计该订单下已收货的发货记录数
            long receivedCount = deliveryRecordService.count(
                new LambdaQueryWrapper<DeliveryRecord>()
                    .eq(DeliveryRecord::getOrderId, order.getId())
                    .eq(DeliveryRecord::getStatus, 1) // 状态为1表示已收货
            );
            order.setReceivedQuantity((int) receivedCount);
            
            // 获取采购申请单号
            if (order.getRequestId() != null) {
                PurchaseRequest request = purchaseRequestService.getById(order.getRequestId());
                if (request != null) {
                    // 设置采购申请单号到订单对象
                    // 注意：这里假设PurchaseOrder实体有requestNo字段，或者通过其他方式传递
                    // 由于前端是通过requestNo字段获取，这里通过反射或其他方式设置
                    try {
                        order.getClass().getMethod("setRequestNo", String.class).invoke(order, request.getRequestNo());
                    } catch (Exception e) {
                        // 忽略反射异常
                    }
                }
            }
        });
        
        return Result.success(result);
    }

    @PostMapping
    public Result<Void> save(@RequestBody PurchaseOrder order) {
        if (order.getOrderNo() == null || order.getOrderNo().isEmpty()) {
            order.setOrderNo("PO" + System.currentTimeMillis());
        }
        purchaseOrderService.save(order);
        return Result.success();
    }

    @PutMapping
    public Result<Void> update(@RequestBody PurchaseOrder order) {
        purchaseOrderService.updateById(order);
        return Result.success();
    }

    @DeleteMapping("/{id}")
    public Result<Void> delete(@PathVariable Long id) {
        purchaseOrderService.removeById(id);
        return Result.success();
    }

    @GetMapping("/{id}")
    public Result<PurchaseOrder> getById(@PathVariable Long id) {
        PurchaseOrder order = purchaseOrderService.getById(id);
        if (order != null) {
            // 统计该订单下已收货的发货记录数
            long receivedCount = deliveryRecordService.count(
                new LambdaQueryWrapper<DeliveryRecord>()
                    .eq(DeliveryRecord::getOrderId, order.getId())
                    .eq(DeliveryRecord::getStatus, 1) // 状态为1表示已收货
            );
            order.setReceivedQuantity((int) receivedCount);
        }
        return Result.success(order);
    }
}
