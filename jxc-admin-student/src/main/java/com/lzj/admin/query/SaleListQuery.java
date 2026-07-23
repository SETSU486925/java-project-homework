package com.lzj.admin.query;

import lombok.Data;

import java.util.List;

/**
 * 乐字节  踏实教育 用心服务
 *
 * @author 乐字节--老李
 * @version 1.0
 */
@Data
public class SaleListQuery extends BaseQuery{

    private String saleNumber;
    private Integer customerId;
    private Integer state;



    private String startDate;
    private String endDate;
    private String goodsName;
    private Integer typeId;
    private List<Integer> typeIds;

    public Integer index;
}
