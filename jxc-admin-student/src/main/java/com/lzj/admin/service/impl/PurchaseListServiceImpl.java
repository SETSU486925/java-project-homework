package com.lzj.admin.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.lzj.admin.mapper.PurchaseListMapper; import
com.lzj.admin.pojo.Goods; import com.lzj.admin.pojo.PurchaseList; import
com.lzj.admin.pojo.PurchaseListGoods; import
com.lzj.admin.query.PurchaseListQuery; import
com.lzj.admin.service.GoodsService; import
com.lzj.admin.service.PurchaseListGoodsService; import
com.lzj.admin.service.PurchaseListService; import
com.lzj.admin.utils.DateUtil; import com.lzj.admin.utils.PageResultUtil;
import com.lzj.admin.utils.StringUtil; import
org.springframework.stereotype.Service; import
org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource; import java.util.List; import
java.util.Map;

@Service @Transactional public class PurchaseListServiceImpl extends
ServiceImpl<PurchaseListMapper, PurchaseList> implements
PurchaseListService {

    @Resource
    private PurchaseListMapper purchaseListMapper;

    @Resource
    private PurchaseListGoodsService purchaseListGoodsService;

    @Resource
    private GoodsService goodsService;

    @Override
    public String getNextPurchaseNumber() {
        try {
            String max = purchaseListMapper.getMaxPurchaseNumber();
            String date = DateUtil.getCurrentDateStr();
            if (StringUtil.isEmpty(max)) {
                return "CG" + date + "0001";
            }
            return "CG" + date + StringUtil.formatCode(max);
        } catch (Exception e) {
            return "CG0001";
        }
    }

    @Override
    public void savePurchaseList(PurchaseList purchaseList,
                                 List<PurchaseListGoods> goodsList,
                                 String userName) {

        if (purchaseList.getPurchaseNumber() == null) {
            purchaseList.setPurchaseNumber(getNextPurchaseNumber());
        }

        save(purchaseList);

        if (goodsList == null) {
            return;
        }

        for (PurchaseListGoods item : goodsList) {

            item.setPurchaseListId(purchaseList.getId());
            purchaseListGoodsService.save(item);

            Goods goods = goodsService.getById(item.getGoodsId());
            if (goods != null) {

                Integer stock = goods.getInventoryQuantity();
                if (stock == null) {
                    stock = 0;
                }

                goods.setInventoryQuantity(stock + item.getNum());
                goods.setLastPurchasingPrice(item.getPrice());
                goods.setPurchasingPrice(item.getPrice());
                goods.setState(2);

                goodsService.updateById(goods);
            }
        }
    }

    @Override
    public Map<String, Object> queryPurchaseList(PurchaseListQuery query) {
        try {
            return (Map<String, Object>) purchaseListMapper.queryPurchaseList(null, query);
        } catch (Exception e) {
            return PageResultUtil.setResult((long) list().size(), list());
        }
    }

    @Override
    public void deletePurchaseList(Integer id) {
        purchaseListGoodsService.removeById(id);
        removeById(id);
    }

	@Override
	public void savePurchaseList(PurchaseList purchaseList, List<PurchaseListGoods> goodsList, Integer userId) {
		// TODO Auto-generated method stub
		
	}

}
