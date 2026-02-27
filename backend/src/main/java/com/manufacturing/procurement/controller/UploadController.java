package com.manufacturing.procurement.controller;

import com.manufacturing.procurement.common.Result;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/api/upload")
public class UploadController {

    @Value("${file.upload-path}")
    private String uploadPath;

    @PostMapping
    public Result<Map<String, String>> upload(@RequestParam("file") MultipartFile file) {
        if (file.isEmpty()) {
            return Result.error("文件不能为空");
        }

        String originalFilename = file.getOriginalFilename();
        String extension = originalFilename.substring(originalFilename.lastIndexOf("."));
        String newFileName = UUID.randomUUID().toString() + extension;

        String datePath = new SimpleDateFormat("yyyy/MM/dd").format(new Date());
        String savePath = uploadPath + datePath + "/";

        File dir = new File(savePath);
        if (!dir.exists()) {
            dir.mkdirs();
        }

        try {
            File dest = new File(savePath + newFileName);
            file.transferTo(dest);

            Map<String, String> data = new HashMap<>();
            data.put("fileName", originalFilename);
            data.put("filePath", "/uploads/" + datePath + "/" + newFileName);
            data.put("url", "http://localhost:8080/uploads/" + datePath + "/" + newFileName);
            return Result.success(data);
        } catch (IOException e) {
            e.printStackTrace();
            return Result.error("文件上传失败");
        }
    }
}
