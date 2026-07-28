package com.lzj.admin.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.lzj.admin.pojo.PurchaseList;
import com.lzj.admin.pojo.PurchaseListGoods;
import com.lzj.admin.query.PurchaseListQuery;
import java.util.List;
import java.util.Map;

/**
 * 进货单服务接口
 */

public interface PurchaseListService extends IService<PurchaseList> {
    String getNextPurchaseNumber();
    void savePurchaseList(PurchaseList purchaseList, List<PurchaseListGoods> goodsList, Integer userId);
    Map<String,Object> queryPurchaseList(PurchaseListQuery query);
    void deletePurchaseList(Integer id);
}