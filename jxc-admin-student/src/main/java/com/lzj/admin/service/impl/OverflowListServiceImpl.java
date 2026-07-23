package com.lzj.admin.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.lzj.admin.pojo.DamageList;
import com.lzj.admin.pojo.Goods;
import com.lzj.admin.pojo.OverflowList;
import com.lzj.admin.mapper.OverflowListMapper;
import com.lzj.admin.pojo.OverflowListGoods;
import com.lzj.admin.query.OverFlowListQuery;
import com.lzj.admin.service.GoodsService;
import com.lzj.admin.service.OverflowListGoodsService;
import com.lzj.admin.service.OverflowListService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.lzj.admin.utils.AssertUtil;
import com.lzj.admin.utils.DateUtil;
import com.lzj.admin.utils.PageResultUtil;
import com.lzj.admin.utils.StringUtil;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import javax.annotation.Resource;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * @author TianTian
 * @date 2022/1/21 13:45
 */
@Service
public class OverflowListServiceImpl extends ServiceImpl<OverflowListMapper, OverflowList> implements OverflowListService {

    @Resource
    private GoodsService goodsService;

    @Resource
    private OverflowListGoodsService overflowListGoodsService;

    @Override
    public String getOverflowNumber() {
        try {
            StringBuffer stringBuffer =new StringBuffer();
            stringBuffer.append("BY");
            stringBuffer.append(DateUtil.getCurrentDateStr());
            String saleNumber = this.baseMapper.getOverflowNumber();
            if(null !=saleNumber){
                stringBuffer.append(StringUtil.formatCode(saleNumber));
            }else{
                stringBuffer.append("0001");
            }
            return stringBuffer.toString();
        } catch (Exception e) {
            e.printStackTrace();
            return "";
        }
    }

    @Override
    public void saveOverflowList(OverflowList overflowList, List<OverflowListGoods> plgList) {
        AssertUtil.isTrue(overflowList.getOverflowDate()==null,"请填写日期");
        SimpleDateFormat formatter= new SimpleDateFormat("yyyy-MM-dd");
        Date date = new Date(System.currentTimeMillis());
        AssertUtil.isTrue(0!= formatter.format(overflowList.getOverflowDate()).compareTo(formatter.format(date)),"请输入今日时间");
        AssertUtil.isTrue(!(this.save(overflowList)),"记录添加失败!");
        OverflowList temp = this.getOne(new QueryWrapper<OverflowList>().eq("overflow_number",overflowList.getOverflowNumber()));
        AssertUtil.isTrue(plgList==null,"请选择商品");
        plgList.forEach(plg->{
            AssertUtil.isTrue(plg.getNum()==null,"选择商品数量");
            plg.setOverflowListId(temp.getId());
            Goods goods = goodsService.getById(plg.getGoodsId());
            goods.setInventoryQuantity(goods.getInventoryQuantity()+plg.getNum());
            goods.setState(2);
            AssertUtil.isTrue(!(goodsService.updateById(goods)),"记录添加失败!");
            AssertUtil.isTrue(!(overflowListGoodsService.save(plg)),"记录添加失败!");
        });
    }

    @Override
    public Map<String, Object> overFlowList(OverFlowListQuery overFlowListQuery) {
        IPage<OverflowList> page = new Page<OverflowList>(overFlowListQuery.getPage(),overFlowListQuery.getLimit());
        page =  this.baseMapper.overFlowList(page,overFlowListQuery);
        return PageResultUtil.setResult(page.getTotal(),page.getRecords());
    }

    @Override
    public void deleteoverflowList(Integer id) {
        /**
         * 1.过溢单商品记录删除
         * 2.过溢单记录删除
         */
        AssertUtil.isTrue(!(overflowListGoodsService.remove(new QueryWrapper<OverflowListGoods>().eq("overflow_list_id",id))),
                "记录删除失败!");
        AssertUtil.isTrue(!(this.removeById(id)),"记录删除失败!");
    }
}
