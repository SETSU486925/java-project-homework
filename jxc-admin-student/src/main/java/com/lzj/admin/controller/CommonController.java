package com.lzj.admin.controller;

import com.lzj.admin.model.GoodsModel;
import com.lzj.admin.pojo.Goods;
import com.lzj.admin.query.GoodsQuery;
import com.lzj.admin.service.GoodsService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.util.Map;

/**
 * @author TianTian
 * @date 2022/1/19 14:06
 */
@Controller
@RequestMapping("common")
public class CommonController {
    @Resource
    private GoodsService goodsService;



    /**
     * 添加商品-选择商品页
     * @return
     */
    @RequestMapping("toSelectGoodsPage")
    public String toSelectGoodsPage(){
        return "common/goods";
    }

    /**
     * 添加商品-商品信息添加页(单价、进货数量)
     * @param gid
     * @param model
     * @return
     */
    @RequestMapping("toAddGoodsInfoPage")
    public String toGoodsInfoPage(Integer gid, Model model){
        return "common/goods_add_update";
    }


    /**
     * 修改商品-商品信息修改页(单价、进货数量)
     * @param goodsModel
     * @param model
     * @return
     */
    @RequestMapping("toUpdateGoodsInfoPage")
    public String toUpdateGoodsInfoPage(GoodsModel goodsModel, Model model){
        return "common/goods_add_update";
    }


    /**
     * 当前库存页
     * @return
     */
    @RequestMapping("toGoodsStockPage")
    public String toGoodsStockPage() {
        return "common/stock_search";
    }



    @RequestMapping("stockList")
    @ResponseBody
    public Map<String,Object> stockLick(GoodsQuery goodsQuery){
        return null;
    }


    /**
     * 商品报损|报溢查询页
     * @return
     */
    @RequestMapping("toDamageOverflowSearchPage")
    public String toDamageOverflowSearchPage(){
        return "common/damage_overflow_search";
    }


    /**
     * 库存报警页
     * @return
     */
    @RequestMapping("alarmPage")
    public String alarmPage(){
        return "common/alarm";
    }


    /**
     * 库存报警查询接口
     * @param goodsQuery
     * @return
     */
    @RequestMapping("listAlarm")
    @ResponseBody
    public Map<String,Object> listAlarm(GoodsQuery goodsQuery){
        goodsQuery.setType(3);
        return null;
    }







}
