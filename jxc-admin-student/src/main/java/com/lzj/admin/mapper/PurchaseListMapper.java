package com.lzj.admin.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.lzj.admin.pojo.PurchaseList;
import com.lzj.admin.query.PurchaseListQuery;
import org.apache.ibatis.annotations.Param;

/**
 * 进货单 Mapper
 */
public interface PurchaseListMapper extends BaseMapper<PurchaseList> {

    String getMaxPurchaseNumber();
//分页
    IPage<PurchaseList> queryPurchaseList(Page<PurchaseList> page,
                                          @Param("query") PurchaseListQuery query);

}