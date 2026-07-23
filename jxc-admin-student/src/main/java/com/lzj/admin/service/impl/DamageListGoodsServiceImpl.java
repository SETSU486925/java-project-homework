package com.lzj.admin.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.lzj.admin.pojo.DamageList;
import com.lzj.admin.pojo.DamageListGoods;
import com.lzj.admin.mapper.DamageListGoodsMapper;
import com.lzj.admin.pojo.PurchaseListGoods;
import com.lzj.admin.query.DamageListGoodsQuery;
import com.lzj.admin.service.DamageListGoodsService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.lzj.admin.utils.PageResultUtil;
import org.springframework.stereotype.Service;

import java.util.Map;

/**
 * 报损单商品表
 * @author TianTian
 * @date 2022/1/21 13:58
 */
@Service
public class DamageListGoodsServiceImpl extends ServiceImpl<DamageListGoodsMapper, DamageListGoods> implements DamageListGoodsService {

    @Override
    public Map<String, Object> damageListGoodsList(DamageListGoodsQuery damageListGoodsQuery) {
        IPage<DamageListGoods> page = new Page<DamageListGoods>(damageListGoodsQuery.getPage(),damageListGoodsQuery.getLimit());
        QueryWrapper<DamageListGoods> queryWrapper =new QueryWrapper<DamageListGoods>();
        if(null != damageListGoodsQuery.getDamageListId()){
            queryWrapper.eq("damage_list_id",damageListGoodsQuery.getDamageListId());
        }
        page =  this.baseMapper.selectPage(page,queryWrapper);
        return PageResultUtil.setResult(page.getTotal(),page.getRecords());
    }
}
