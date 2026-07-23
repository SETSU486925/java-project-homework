package com.lzj.admin.service;

import com.lzj.admin.pojo.OverflowListGoods;
import com.baomidou.mybatisplus.extension.service.IService;
import com.lzj.admin.query.DamageListGoodsQuery;
import com.lzj.admin.query.OverflowListGoodsQuery;

import java.util.Map;

/**
 * 报溢单商品服务类
 * @author TianTian
 * @date 2022/1/21 13:42
 */
public interface OverflowListGoodsService extends IService<OverflowListGoods> {

    Map<String, Object> overflowListGoodsList(OverflowListGoodsQuery overflowListGoodsQuery);
}
