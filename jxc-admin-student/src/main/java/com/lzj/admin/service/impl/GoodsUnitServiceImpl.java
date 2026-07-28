package com.lzj.admin.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.lzj.admin.mapper.GoodsUnitMapper;
import com.lzj.admin.pojo.GoodsUnit;
import com.lzj.admin.service.GoodsUnitService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

/**
 * 商品单位Service实现类
 *
 * @author TianTian
 */
@Service
public class GoodsUnitServiceImpl
        extends ServiceImpl<GoodsUnitMapper, GoodsUnit>
        implements GoodsUnitService {

    @Resource
    private GoodsUnitMapper goodsUnitMapper;

    /**
     * 查询全部商品单位
     */
    @Override
    public List<GoodsUnit> queryAllGoodsUnit() {

        QueryWrapper<GoodsUnit> wrapper = new QueryWrapper<>();

        wrapper.orderByAsc("id");

        return list(wrapper);
    }

}
