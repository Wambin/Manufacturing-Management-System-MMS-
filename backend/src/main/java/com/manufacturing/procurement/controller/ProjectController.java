package com.manufacturing.procurement.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.manufacturing.procurement.common.Result;
import com.manufacturing.procurement.entity.Project;
import com.manufacturing.procurement.service.ProjectService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/project")
public class ProjectController {
    @Autowired
    private ProjectService projectService;

    @GetMapping("/list")
    public Result<Page<Project>> list(@RequestParam(defaultValue = "1") Integer current,
                                         @RequestParam(defaultValue = "10") Integer size,
                                         @RequestParam(required = false) String keyword) {
        Page<Project> page = new Page<>(current, size);
        LambdaQueryWrapper<Project> wrapper = new LambdaQueryWrapper<>();
        if (keyword != null && !keyword.isEmpty()) {
            wrapper.like(Project::getProjectName, keyword)
                    .or().like(Project::getProjectNo, keyword);
        }
        wrapper.orderByDesc(Project::getCreateTime);
        return Result.success(projectService.page(page, wrapper));
    }

    @GetMapping("/all")
    public Result<java.util.List<Project>> all() {
        LambdaQueryWrapper<Project> wrapper = new LambdaQueryWrapper<>();
        wrapper.orderByDesc(Project::getCreateTime);
        return Result.success(projectService.list(wrapper));
    }

    @PostMapping
    public Result<Void> save(@RequestBody Project project) {
        projectService.save(project);
        return Result.success();
    }

    @PutMapping
    public Result<Void> update(@RequestBody Project project) {
        projectService.updateById(project);
        return Result.success();
    }

    @DeleteMapping("/{id}")
    public Result<Void> delete(@PathVariable Long id) {
        projectService.removeById(id);
        return Result.success();
    }

    @GetMapping("/{id}")
    public Result<Project> getById(@PathVariable Long id) {
        return Result.success(projectService.getById(id));
    }
}
