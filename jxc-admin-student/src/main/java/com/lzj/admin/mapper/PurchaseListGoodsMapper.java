package com.lzj.admin.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.lzj.admin.pojo.PurchaseListGoods;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 进货明细 
 */
public interface PurchaseListGoodsMapper extends BaseMapper<PurchaseListGoods> {

    Integer insertBatch(@Param("list") List<PurchaseListGoods> list);
//删
    Integer deleteByPurchaseId(Integer purchaseId);
//查
    List<PurchaseListGoods> queryByPurchaseId(Integer purchaseId);

}
