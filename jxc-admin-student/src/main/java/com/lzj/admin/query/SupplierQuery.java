package com.lzj.admin.query;

import lombok.Data;

/**
 * 经销商的查询参数
 * @author TianTian
 * @date 2022/1/18 17:49
 */
@Data
public class SupplierQuery extends BaseQuery{
    private String supplierName;
}
