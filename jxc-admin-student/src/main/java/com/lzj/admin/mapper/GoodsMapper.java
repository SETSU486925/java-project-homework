package com.lzj.admin.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.lzj.admin.pojo.Goods;
import com.lzj.admin.query.GoodsQuery;
import org.apache.ibatis.annotations.Param;

/**
 * 商品Mapper
 */
public interface GoodsMapper extends BaseMapper<Goods> {

    /**
     * 商品分页查询
     *
     * @param page  分页对象
     * @param query 查询条件
     * @return 分页结果
     */
    IPage<Goods> queryGoods(Page<Goods> page,
                            @Param("query") GoodsQuery query);

}