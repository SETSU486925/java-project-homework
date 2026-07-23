package com.lzj.admin.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.lzj.admin.pojo.DamageListGoods;
import com.lzj.admin.pojo.OverflowListGoods;
import com.lzj.admin.mapper.OverflowListGoodsMapper;
import com.lzj.admin.query.DamageListGoodsQuery;
import com.lzj.admin.query.OverflowListGoodsQuery;
import com.lzj.admin.service.OverflowListGoodsService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.lzj.admin.utils.PageResultUtil;
import org.springframework.stereotype.Service;

import java.util.Map;

/**
 * 报溢单商品表服务类
 * @author TianTian
 * @date 2022/1/21 14:02
 */
@Service
public class OverflowListGoodsServiceImpl extends ServiceImpl<OverflowListGoodsMapper, OverflowListGoods> implements OverflowListGoodsService {

    @Override
    public Map<String, Object> overflowListGoodsList(OverflowListGoodsQuery overflowListGoodsQuery) {
        IPage<OverflowListGoods> page = new Page<OverflowListGoods>(overflowListGoodsQuery.getPage(),overflowListGoodsQuery.getLimit());
        QueryWrapper<OverflowListGoods> queryWrapper =new QueryWrapper<OverflowListGoods>();
        if(null != overflowListGoodsQuery.getOverflowListId()){
            queryWrapper.eq("overflow_list_id",overflowListGoodsQuery.getOverflowListId());
        }
        page =  this.baseMapper.selectPage(page,queryWrapper);
        return PageResultUtil.setResult(page.getTotal(),page.getRecords());
    }
}
