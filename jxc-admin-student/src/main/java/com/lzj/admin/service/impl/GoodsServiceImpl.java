package com.lzj.admin.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.lzj.admin.mapper.GoodsMapper;
import com.lzj.admin.pojo.Goods;
import com.lzj.admin.query.GoodsQuery;
import com.lzj.admin.service.GoodsService;
import com.lzj.admin.utils.AssertUtil;
import com.lzj.admin.utils.PageResultUtil;
import com.lzj.admin.utils.StringUtil;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Map;

/**
 * 商品Service实现类
 *
 * @author TianTian
 */
@Service
@Transactional
public class GoodsServiceImpl extends ServiceImpl<GoodsMapper, Goods> implements GoodsService {
    @Override
    public Map<String, Object> queryGoods(GoodsQuery query) {

        Page<Goods> page = new Page<>(query.getPage(), query.getLimit());

        QueryWrapper<Goods> wrapper = new QueryWrapper<>();

        // 商品名称
        if (StringUtil.isNotEmpty(query.getGoodsName())) {
            wrapper.like("name", query.getGoodsName());
        }

        // 商品分类
        if (query.getTypeId() != null) {
            wrapper.eq("type_id", query.getTypeId());
        }

        // 库存=0
        if (query.getType() != null && query.getType() == 1) {
            wrapper.eq("inventory_quantity", 0);
        }

        // 库存>0
        if (query.getType() != null && query.getType() == 2) {
            wrapper.gt("inventory_quantity", 0);
        }

        // 未删除
        wrapper.eq("is_del", 0);

        wrapper.orderByDesc("id");

        IPage<Goods> result = page(page, wrapper);

        return PageResultUtil.setResult(result.getTotal(), result.getRecords());
    }

    /**
     * 新增商品
     */
    @Override
    public void saveGoods(Goods goods) {

        AssertUtil.isTrue(goods == null, "商品不能为空");

        AssertUtil.isTrue(StringUtil.isEmpty(goods.getName()), "商品名称不能为空");

        QueryWrapper<Goods> wrapper = new QueryWrapper<>();

        wrapper.eq("code", goods.getCode());

        Goods temp = getOne(wrapper);

        AssertUtil.isTrue(temp != null, "商品编码已存在");

        if (goods.getInventoryQuantity() == null) {
            goods.setInventoryQuantity(0);
        }

        if (goods.getState() == null) {
            goods.setState(0);
        }

        goods.setIsDel(0);

        save(goods);
    }

    /**
     * 修改商品
     */
    @Override
    public void updateGoods(Goods goods) {

        AssertUtil.isTrue(goods == null, "商品不存在");

        AssertUtil.isTrue(goods.getId() == null, "参数错误");

        Goods dbGoods = getById(goods.getId());

        AssertUtil.isTrue(dbGoods == null, "商品不存在");

        QueryWrapper<Goods> wrapper = new QueryWrapper<>();

        wrapper.eq("code", goods.getCode());

        Goods temp = getOne(wrapper);

        if (temp != null && !temp.getId().equals(goods.getId())) {
            AssertUtil.isTrue(true, "商品编码重复");
        }

        updateById(goods);
    }

    /**
     * 删除商品
     */
    @Override
    public void deleteGoods(Integer id) {

        Goods goods = getById(id);

        AssertUtil.isTrue(goods == null, "商品不存在");

        goods.setIsDel(1);

        updateById(goods);
    }

    /**
     * 根据ID查询
     */
    @Override
    public Goods queryById(Integer id) {

        return getById(id);
    }

}
