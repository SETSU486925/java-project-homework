package com.lzj.admin.query;

import lombok.Data;

/**
 * 入库商品查询
 *
 * @author TianTian
 * @date 2022/1/19
 */
@Data
public class PurchaseListGoodsQuery extends BaseQuery {

    /**
     * 采购单ID
     */
    private Integer purchaseListId;

    /**
     * 商品名称
     */
    private String name;

}
