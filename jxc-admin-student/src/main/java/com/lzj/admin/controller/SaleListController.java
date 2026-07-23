package com.lzj.admin.controller;


import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.lzj.admin.model.RespBean;
import com.lzj.admin.model.SaleCount;
import com.lzj.admin.pojo.PurchaseListGoods;
import com.lzj.admin.pojo.SaleList;
import com.lzj.admin.pojo.SaleListGoods;
import com.lzj.admin.query.PurchaseListQuery;
import com.lzj.admin.query.SaleListQuery;
import com.lzj.admin.service.SaleListGoodsService;
import com.lzj.admin.service.SaleListService;
import com.lzj.admin.service.UserService;
import com.lzj.admin.utils.AssertUtil;
import com.lzj.admin.utils.DateUtil;
import com.lzj.admin.utils.MathUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.security.Principal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 销售单表控制器
 * @author TianTian
 * @date 2022/1/19 23:02
 */
@Controller
@RequestMapping("/sale")
public class SaleListController {

    @Resource
    private SaleListService saleListService;

    @Resource
    private UserService userService;


    /**
     * 销售出库主页
     * @return
     */
    @RequestMapping("index")
    public String index(Model model){
        model.addAttribute("saleNumber",saleListService.getNextSaleNumber());
        return "sale/sale";
    }


    @RequestMapping("save")
    @ResponseBody
    public RespBean save(SaleList saleList, String goodsJson, Principal principal){
        String userName = principal.getName();
        saleList.setUserId(userService.findForName(userName).getId());
        Gson gson = new Gson();
        List<SaleListGoods> slgList = gson.fromJson(goodsJson,new TypeToken<List<SaleListGoods>>(){}.getType());
        saleListService.saveSaleList(saleList,slgList);
        return RespBean.success("商品销售出库成功!");
    }

    /**
     * 销售单查询页
     * @return
     */
    @RequestMapping("searchPage")
    public String searchPage(){
        return "sale/sale_search";
    }

    @RequestMapping("list")
    @ResponseBody
    public Map<String,Object> saleList(SaleListQuery saleListQuery){
        return saleListService.saleList(saleListQuery);
    }
    @RequestMapping("delete")
    @ResponseBody
    public RespBean delete(Integer id){
        saleListService.deletesaleList(id);
        return RespBean.success("删除成功");
    }

    @RequestMapping("countSale")
    @ResponseBody
    public Map<String,Object> countSale(SaleListQuery saleListQuery){
        return saleListService.countSale(saleListQuery);
    }



    @RequestMapping("countSaleByDay")
    @ResponseBody
    public Map<String,Object> countDaySale(String begin,String end){
        Map<String,Object> result =new HashMap<String,Object>();
        List<SaleCount> saleCounts =new ArrayList<SaleCount>();
        /**
         * 2021-03-15  -  2021-03-30
         */
        List<Map<String,Object>> list = saleListService.countDaySale(begin,end);
        /**
         * 根据传入的时间段 生成日期列表
         */
        List<String> datas = DateUtil.getRangeDates(begin,end);
        for (String data : datas) {
            SaleCount saleCount =new SaleCount();
            saleCount.setDate(data);
            boolean flag =true;
            for(Map<String,Object> map:list){
                String dd = map.get("saleDate").toString().substring(0,10);
                if(data.equals(dd)){
                    saleCount.setAmountCost(MathUtil.format2Bit(Float.parseFloat(map.get("amountCost").toString())));
                    saleCount.setAmountSale(MathUtil.format2Bit(Float.parseFloat(map.get("amountSale").toString())));
                    saleCount.setAmountProfit(MathUtil.format2Bit(saleCount.getAmountSale()-saleCount.getAmountCost()));
                    flag =false;
                }
            }
            if(flag){
                saleCount.setAmountProfit(0F);
                saleCount.setAmountSale(0F);
                saleCount.setAmountCost(0F);
            }
            saleCounts.add(saleCount);
        }

        result.put("count",saleCounts.size());
        result.put("data",saleCounts);
        result.put("code",0);
        result.put("msg","");
        return result;
    }


}
