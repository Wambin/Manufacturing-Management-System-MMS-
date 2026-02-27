package com.manufacturing.procurement.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.manufacturing.procurement.common.Result;
import com.manufacturing.procurement.entity.PurchaseRequest;
import com.manufacturing.procurement.service.PurchaseRequestService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;

@RestController
@RequestMapping("/api/purchase/request")
public class PurchaseRequestController {
    @Autowired
    private PurchaseRequestService purchaseRequestService;

    @GetMapping("/list")
    public Result<Page<PurchaseRequest>> list(@RequestParam(defaultValue = "1") Integer current,
                                                @RequestParam(defaultValue = "10") Integer size,
                                                @RequestParam(required = false) Integer status) {
        Page<PurchaseRequest> page = new Page<>(current, size);
        LambdaQueryWrapper<PurchaseRequest> wrapper = new LambdaQueryWrapper<>();
        if (status != null) {
            wrapper.eq(PurchaseRequest::getStatus, status);
        }
        wrapper.orderByDesc(PurchaseRequest::getCreateTime);
        return Result.success(purchaseRequestService.page(page, wrapper));
    }

    @PostMapping
    public Result<Void> save(@RequestBody PurchaseRequest request) {
        if (request.getRequestNo() == null || request.getRequestNo().isEmpty()) {
            request.setRequestNo("PR" + System.currentTimeMillis());
        }
        purchaseRequestService.save(request);
        return Result.success();
    }

    @PutMapping
    public Result<Void> update(@RequestBody PurchaseRequest request) {
        purchaseRequestService.updateById(request);
        return Result.success();
    }

    @DeleteMapping("/{id}")
    public Result<Void> delete(@PathVariable Long id) {
        purchaseRequestService.removeById(id);
        return Result.success();
    }

    @GetMapping("/{id}")
    public Result<PurchaseRequest> getById(@PathVariable Long id) {
        return Result.success(purchaseRequestService.getById(id));
    }

    @PutMapping("/{id}/submit")
    public Result<Void> submit(@PathVariable Long id) {
        PurchaseRequest request = purchaseRequestService.getById(id);
        request.setStatus(1);
        purchaseRequestService.updateById(request);
        return Result.success();
    }

    @PutMapping("/{id}/approve")
    public Result<Void> approve(@PathVariable Long id, @RequestParam Long auditUserId, @RequestParam String opinion) {
        PurchaseRequest request = purchaseRequestService.getById(id);
        request.setStatus(2);
        request.setAuditUserId(auditUserId);
        request.setAuditOpinion(opinion);
        request.setAuditTime(LocalDateTime.now());
        purchaseRequestService.updateById(request);
        return Result.success();
    }

    @PutMapping("/{id}/reject")
    public Result<Void> reject(@PathVariable Long id, @RequestParam Long auditUserId, @RequestParam String opinion) {
        PurchaseRequest request = purchaseRequestService.getById(id);
        request.setStatus(3);
        request.setAuditUserId(auditUserId);
        request.setAuditOpinion(opinion);
        request.setAuditTime(LocalDateTime.now());
        purchaseRequestService.updateById(request);
        return Result.success();
    }
}
