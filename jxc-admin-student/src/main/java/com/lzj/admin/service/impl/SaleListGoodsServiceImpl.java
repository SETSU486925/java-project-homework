package com.lzj.admin.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.lzj.admin.pojo.ReturnListGoods;
import com.lzj.admin.pojo.SaleListGoods;
import com.lzj.admin.mapper.SaleListGoodsMapper;
import com.lzj.admin.query.saleListGoodsQuery;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.lzj.admin.service.SaleListGoodsService;
import com.lzj.admin.utils.AssertUtil;
import com.lzj.admin.utils.PageResultUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Map;

/**
 * 销售单销售表服务器
 * @author TianTian
 * @date 2022/1/19 14:42
 */
@Service
public class SaleListGoodsServiceImpl extends ServiceImpl<SaleListGoodsMapper, SaleListGoods> implements SaleListGoodsService {

    @Override
    public Integer getSaleTotalByGoodsId(Integer id) {
        SaleListGoods saleListGoods = this.getOne(new QueryWrapper<SaleListGoods>().select("sum(num) as num").eq("goods_id",id));
        return null == saleListGoods?0:saleListGoods.getNum();
    }


    @Override
    public Map<String, Object> saleListGoodsList(saleListGoodsQuery saleListGoodsQuery) {
        IPage<SaleListGoods> page = new Page<SaleListGoods>(saleListGoodsQuery.getPage(),saleListGoodsQuery.getLimit());
        QueryWrapper<SaleListGoods> queryWrapper =new QueryWrapper<SaleListGoods>();
        if(null != saleListGoodsQuery.getSaleListId()){
            queryWrapper.eq("sale_list_id",saleListGoodsQuery.getSaleListId());
        }
        page =  this.baseMapper.selectPage(page,queryWrapper);
        return PageResultUtil.setResult(page.getTotal(),page.getRecords());
    }


}
