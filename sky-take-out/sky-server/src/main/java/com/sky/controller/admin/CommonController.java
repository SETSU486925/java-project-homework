package com.sky.controller.admin;

import com.sky.result.Result;
import com.sky.utils.AliOssUtil;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.util.UUID;

/**
 * 通用接口
 */
@RestController
@Slf4j
@Api(tags = "通用接口")
@RequestMapping("/admin/common")
public class CommonController {

    @Autowired
    private AliOssUtil aliOssUtil;

    @ApiOperation("文件上传接口")
    @PostMapping("/upload")
    public Result<String> upload(MultipartFile file){
        log.info("文件上传资源：{}",file.getOriginalFilename());

        //获取原始文件名
        String originalFilename = file.getOriginalFilename();
        //截取文件名后缀 .jpg .png
        String suffix = originalFilename.substring(originalFilename.lastIndexOf("."));
        //使用UUID生成新文件名，防止文件名重复覆盖
        String imageName = UUID.randomUUID().toString() + suffix;

        try {
            String url = aliOssUtil.upload(file.getBytes(), imageName);
            return Result.success(url);
        } catch (Exception e) {
            log.error("文件上传失败：",e);
            return Result.error("文件上传失败");
        }
    }
}