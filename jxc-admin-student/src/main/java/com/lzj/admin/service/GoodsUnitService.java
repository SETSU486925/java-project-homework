package com.lzj.admin.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.lzj.admin.pojo.GoodsUnit;

import java.util.List;

/**
 * 商品单位服务
 *
 * @author TianTian
 */
public interface GoodsUnitService extends IService<GoodsUnit> {

    /**
     * 查询全部商品单位
     */
    List<GoodsUnit> queryAllGoodsUnit();

}