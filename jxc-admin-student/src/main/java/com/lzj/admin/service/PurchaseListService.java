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

    /**
     * 保存采购单
     * @param purchaseList 进货单主表
     * @param goodsList 进货商品明细集合
     * @param userId 当前登录用户ID
     */
    void savePurchaseList(PurchaseList purchaseList,
                          List<PurchaseListGoods> goodsList,
                          Integer userId);

    /**
     * 分页条件查询采购单
     */
    Map<String,Object> queryPurchaseList(PurchaseListQuery query);

    /**
     * 删除
     */
    void deletePurchaseList(Integer id);

	void savePurchaseList(PurchaseList purchaseList, List<PurchaseListGoods> goodsList, String userName);
}