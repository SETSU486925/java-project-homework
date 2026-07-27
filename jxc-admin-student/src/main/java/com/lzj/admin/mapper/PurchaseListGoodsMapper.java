package com.lzj.admin.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.lzj.admin.pojo.PurchaseListGoods;
import org.apache.ibatis.annotations.Param;
import java.util.List;

public interface PurchaseListGoodsMapper extends BaseMapper<PurchaseListGoods> {

    /**
     * 批量插入进货商品
     */
    int insertBatch(@Param("list") List<PurchaseListGoods> list);

    /**
     * 根据进货单id删除明细
     */
    int deleteByPurchaseId(@Param("purchaseId") Integer purchaseId);

    /**
     * 根据进货单id查询明细
     */
    List<PurchaseListGoods> queryByPurchaseId(@Param("purchaseId") Integer purchaseId);
}