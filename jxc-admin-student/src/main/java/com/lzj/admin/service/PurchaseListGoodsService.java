package com.lzj.admin.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.lzj.admin.pojo.PurchaseListGoods;
import com.lzj.admin.query.PurchaseListGoodsQuery;
import java.util.List;
import java.util.Map;

/**
 * 进货单商品 Service接口
 */
public interface PurchaseListGoodsService extends IService<PurchaseListGoods> {

    /**
     * 分页条件查询进货商品明细
     */
    Map<String, Object> queryPurchaseListGoods(PurchaseListGoodsQuery query);

    /**
     * 根据进货单id删除明细
     */
    void deleteByPurchaseId(Integer purchaseId);

    /**
     * 批量新增进货商品
     */
    void insertBatch(List<PurchaseListGoods> purchaseListGoodsList);

    /**
     * 根据进货单id查询所有
     */
    List<PurchaseListGoods> queryByPurchaseId(Integer purchaseId);
}