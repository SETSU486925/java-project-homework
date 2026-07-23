package com.lzj.admin.query;


import lombok.Data;

/**
 * 基础格式
 * @author TianTian
 * @date 2022/1/12 22:06
 */
@Data
public class BaseQuery {
    private Integer page=1;
    private Integer limit=10;

}
