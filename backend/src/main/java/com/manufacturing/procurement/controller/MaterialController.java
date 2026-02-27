package com.manufacturing.procurement.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.manufacturing.procurement.common.Result;
import com.manufacturing.procurement.entity.Material;
import com.manufacturing.procurement.service.MaterialService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/material")
public class MaterialController {
    @Autowired
    private MaterialService materialService;

    @GetMapping("/list")
    public Result<Page<Material>> list(@RequestParam(defaultValue = "1") Integer current,
                                         @RequestParam(defaultValue = "10") Integer size,
                                         @RequestParam(required = false) String keyword) {
        Page<Material> page = new Page<>(current, size);
        LambdaQueryWrapper<Material> wrapper = new LambdaQueryWrapper<>();
        if (keyword != null && !keyword.isEmpty()) {
            wrapper.like(Material::getMaterialName, keyword)
                    .or().like(Material::getMaterialCode, keyword);
        }
        wrapper.orderByDesc(Material::getCreateTime);
        return Result.success(materialService.page(page, wrapper));
    }

    @GetMapping("/all")
    public Result<java.util.List<Material>> all() {
        LambdaQueryWrapper<Material> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Material::getStatus, 1)
                .orderByDesc(Material::getCreateTime);
        return Result.success(materialService.list(wrapper));
    }

    @PostMapping
    public Result<Void> save(@RequestBody Material material) {
        materialService.save(material);
        return Result.success();
    }

    @PutMapping
    public Result<Void> update(@RequestBody Material material) {
        materialService.updateById(material);
        return Result.success();
    }

    @DeleteMapping("/{id}")
    public Result<Void> delete(@PathVariable Long id) {
        materialService.removeById(id);
        return Result.success();
    }

    @GetMapping("/{id}")
    public Result<Material> getById(@PathVariable Long id) {
        return Result.success(materialService.getById(id));
    }
}
