package com.lzj.admin.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.lzj.admin.pojo.Goods;
import com.lzj.admin.query.GoodsQuery;

import java.util.Map;

/**
 * 商品服务
 *
 * @author TianTian
 */
public interface GoodsService extends IService<Goods> {

    /**
     * 商品分页查询
     */
    Map<String,Object> queryGoods(GoodsQuery query);

    /**
     * 新增商品
     */
    void saveGoods(Goods goods);

    /**
     * 修改商品
     */
    void updateGoods(Goods goods);

    /**
     * 删除商品
     */
    void deleteGoods(Integer id);

    /**
     * 根据ID查询
     */
    Goods queryById(Integer id);

}