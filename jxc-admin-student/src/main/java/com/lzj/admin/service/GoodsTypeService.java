package com.lzj.admin.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.lzj.admin.dto.TreeDto;
import com.lzj.admin.pojo.GoodsType;

import java.util.List;
import java.util.Map;

/**
 * 商品类别服务
 *
 * @author TianTian
 */
public interface GoodsTypeService extends IService<GoodsType> {

    /**
     * 分类
     */
    List<TreeDto> queryGoodsTypeTree();

    /**
     * 查询全部分类
     */
    List<GoodsType> queryAllGoodsType();

    /**
     * 分类分页
     */
    Map<String,Object> queryGoodsType();

    /**
     * 新增分类
     */
    void saveGoodsType(GoodsType goodsType);

    /**
     * 修改分类
     */
    void updateGoodsType(GoodsType goodsType);

    /**
     * 删除分类
     */
    void deleteGoodsType(Integer id);

    /**
     * 根据ID查询
     */
    GoodsType queryById(Integer id);

}
