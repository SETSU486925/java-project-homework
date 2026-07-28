package com.lzj.admin;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.transaction.annotation.EnableTransactionManagement;

/**
 * 进销存系统启动器
 * @author xmc
 * @date 2026/7/23
 */
@SpringBootApplication
@MapperScan(basePackages = {"com.edu.seiryo.**.mapper"})
public class JxcAdminApplication {
 public static void main(String[] args) {
     SpringApplication.run(JxcAdminApplication.class,args);
 }

 @Bean
 public BCryptPasswordEncoder bCryptPasswordEncoder(){
     return new BCryptPasswordEncoder();
 }
}