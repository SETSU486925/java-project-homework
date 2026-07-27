package com.lzj.admin.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.lzj.admin.mapper.PurchaseListGoodsMapper;
import com.lzj.admin.pojo.PurchaseListGoods;
import com.lzj.admin.query.PurchaseListGoodsQuery;
import com.lzj.admin.service.PurchaseListGoodsService;
import com.lzj.admin.utils.PageResultUtil;
import org.springframework.stereotype.Service;
import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

/**
 * 进货单商品表 实现类
 */
@Service
public class PurchaseListGoodsServiceImpl
        extends ServiceImpl<PurchaseListGoodsMapper, PurchaseListGoods>
        implements PurchaseListGoodsService {

    @Resource
    private PurchaseListGoodsMapper purchaseListGoodsMapper;

    /**
     * 分页查询进货商品
     */
    @Override
    public Map<String, Object> queryPurchaseListGoods(PurchaseListGoodsQuery query) {
        Page<PurchaseListGoods> page = new Page<>(query.getPage(), query.getLimit());
        QueryWrapper<PurchaseListGoods> wrapper = new QueryWrapper<>();

        // 根据采购单ID查询
        if (query.getPurchaseListId() != null) {
            wrapper.eq("purchase_list_id", query.getPurchaseListId());
        }
        // 根据商品名称查询
        if (query.getName() != null && !"".equals(query.getName())) {
            wrapper.like("name", query.getName());
        }
        wrapper.orderByDesc("id");
        IPage<PurchaseListGoods> result = page(page, wrapper);
        return PageResultUtil.setResult(result.getTotal(), result.getRecords());
    }

    /**
     * 根据采购单ID删除商品明细
     */
    @Override
    public void deleteByPurchaseId(Integer purchaseId) {
        purchaseListGoodsMapper.deleteByPurchaseId(purchaseId);
    }

    /**
     * 批量插入进货明细
     */
    @Override
    public void insertBatch(List<PurchaseListGoods> purchaseListGoodsList) {
        purchaseListGoodsMapper.insertBatch(purchaseListGoodsList);
    }

    /**
     * 根据进货单id查询明细
     */
    @Override
    public List<PurchaseListGoods> queryByPurchaseId(Integer purchaseId) {
        return purchaseListGoodsMapper.queryByPurchaseId(purchaseId);
    }
}
