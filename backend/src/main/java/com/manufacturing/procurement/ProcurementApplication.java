package com.manufacturing.procurement;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@MapperScan("com.manufacturing.procurement.mapper")
public class ProcurementApplication {
    public static void main(String[] args) {
        SpringApplication.run(ProcurementApplication.class, args);
    }
}
