package com.manufacturing.procurement.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.manufacturing.procurement.common.Result;
import com.manufacturing.procurement.entity.Supplier;
import com.manufacturing.procurement.service.SupplierService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/supplier")
public class SupplierController {
    @Autowired
    private SupplierService supplierService;

    @GetMapping("/list")
    public Result<Page<Supplier>> list(@RequestParam(defaultValue = "1") Integer current,
                                         @RequestParam(defaultValue = "10") Integer size,
                                         @RequestParam(required = false) String name) {
        Page<Supplier> page = new Page<>(current, size);
        LambdaQueryWrapper<Supplier> wrapper = new LambdaQueryWrapper<>();
        if (name != null && !name.isEmpty()) {
            wrapper.like(Supplier::getName, name);
        }
        wrapper.orderByDesc(Supplier::getCreateTime);
        return Result.success(supplierService.page(page, wrapper));
    }

    @GetMapping("/all")
    public Result<Iterable<Supplier>> all() {
        LambdaQueryWrapper<Supplier> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Supplier::getStatus, 1);
        wrapper.orderByAsc(Supplier::getName);
        return Result.success(supplierService.list(wrapper));
    }

    @GetMapping("/{id}")
    public Result<Supplier> get(@PathVariable Long id) {
        Supplier supplier = supplierService.getById(id);
        if (supplier == null) {
            return Result.error("供应商不存在");
        }
        return Result.success(supplier);
    }

    @PostMapping
    public Result<Void> save(@RequestBody Supplier supplier) {
        supplierService.save(supplier);
        return Result.success();
    }

    @PutMapping
    public Result<Void> update(@RequestBody Supplier supplier) {
        supplierService.updateById(supplier);
        return Result.success();
    }

    @DeleteMapping("/{id}")
    public Result<Void> delete(@PathVariable Long id) {
        supplierService.removeById(id);
        return Result.success();
    }
}