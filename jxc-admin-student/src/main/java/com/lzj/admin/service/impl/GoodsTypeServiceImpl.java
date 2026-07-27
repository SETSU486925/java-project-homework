package com.lzj.admin.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.lzj.admin.dto.TreeDto;
import com.lzj.admin.mapper.GoodsTypeMapper;
import com.lzj.admin.pojo.GoodsType;
import com.lzj.admin.service.GoodsTypeService;
import com.lzj.admin.utils.AssertUtil;
import com.lzj.admin.utils.PageResultUtil;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * 商品类别 Service实现类
 *
 * @author TianTian
 */
@Service
@Transactional
public class GoodsTypeServiceImpl
        extends ServiceImpl<GoodsTypeMapper, GoodsType>
        implements GoodsTypeService {

    @Resource
    private GoodsTypeMapper goodsTypeMapper;

    /**
     * 查询分类树
     */
    @Override
    public List<TreeDto> queryGoodsTypeTree() {

        List<GoodsType> goodsTypes = list();

        List<TreeDto> treeList = new ArrayList<>();

        for (GoodsType goodsType : goodsTypes) {

            TreeDto tree = new TreeDto();

            tree.setId(goodsType.getId());
            tree.setpId(goodsType.getpId());
            tree.setName(goodsType.getName());
            tree.setChecked(false);

            treeList.add(tree);
        }

        return treeList;
    }

    /**
     * 查询全部分类
     */
    @Override
    public List<GoodsType> queryAllGoodsType() {

        QueryWrapper<GoodsType> wrapper = new QueryWrapper<>();

        wrapper.orderByAsc("id");

        return list(wrapper);
    }

    /**
     * 分类列表
     */
    @Override
    public Map<String, Object> queryGoodsType() {

        List<GoodsType> list = queryAllGoodsType();

        return PageResultUtil.setResult((long) list.size(), list);
    }

    /**
     * 新增分类
     */
    @Override
    public void saveGoodsType(GoodsType goodsType) {

        AssertUtil.isTrue(goodsType == null, "商品类别不能为空");

        AssertUtil.isTrue(goodsType.getName() == null
                || "".equals(goodsType.getName().trim()),
                "类别名称不能为空");

        QueryWrapper<GoodsType> wrapper = new QueryWrapper<>();

        wrapper.eq("name", goodsType.getName());

        GoodsType temp = getOne(wrapper);

        AssertUtil.isTrue(temp != null, "类别名称已存在");

        if (goodsType.getpId() == null) {
            goodsType.setpId(0);
        }

        if (goodsType.getState() == null) {
            goodsType.setState(0);
        }

        save(goodsType);
    }

    /**
     * 修改分类
     */
    @Override
    public void updateGoodsType(GoodsType goodsType) {

        AssertUtil.isTrue(goodsType == null, "参数错误");

        AssertUtil.isTrue(goodsType.getId() == null, "ID不能为空");

        GoodsType dbType = getById(goodsType.getId());

        AssertUtil.isTrue(dbType == null, "商品类别不存在");

        QueryWrapper<GoodsType> wrapper = new QueryWrapper<>();

        wrapper.eq("name", goodsType.getName());

        GoodsType temp = getOne(wrapper);

        if (temp != null && !temp.getId().equals(goodsType.getId())) {
            AssertUtil.isTrue(true, "类别名称已存在");
        }

        updateById(goodsType);
    }

    /**
     * 删除分类
     */
    @Override
    public void deleteGoodsType(Integer id) {

        GoodsType goodsType = getById(id);

        AssertUtil.isTrue(goodsType == null, "商品类别不存在");

        removeById(id);
    }

    /**
     * 根据ID查询
     */
    @Override
    public GoodsType queryById(Integer id) {

        return getById(id);
    }

}
