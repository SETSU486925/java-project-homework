package com.lzj.admin.service;

import com.lzj.admin.pojo.SaleListGoods;
import com.baomidou.mybatisplus.extension.service.IService;
import com.lzj.admin.query.saleListGoodsQuery;

import java.util.Map;

/**
 * <p>
 * 销售单商品表 服务类
 * </p>
 *
 * @author 老李
 */
public interface SaleListGoodsService extends IService<SaleListGoods> {

    Integer getSaleTotalByGoodsId(Integer id);

    Map<String, Object> saleListGoodsList(saleListGoodsQuery saleListGoodsQuery);


}
