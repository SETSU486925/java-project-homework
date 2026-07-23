package com.lzj.admin.service;

import com.lzj.admin.pojo.ReturnListGoods;
import com.baomidou.mybatisplus.extension.service.IService;
import com.lzj.admin.query.ReturnListGoodsQuery;

import java.util.Map;

/**
 * <p>
 * 退货单商品表 服务类
 * </p>
 *
 * @author 老李
 */
public interface ReturnListGoodsService extends IService<ReturnListGoods> {

    Map<String, Object> returnListGoodsList(ReturnListGoodsQuery returnListGoodsQuery);
}
