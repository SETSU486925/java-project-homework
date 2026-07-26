package com.lzj.admin.controller;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.lzj.admin.model.RespBean;
import com.lzj.admin.pojo.PurchaseList;
import com.lzj.admin.pojo.PurchaseListGoods;
import com.lzj.admin.query.PurchaseListQuery;
import com.lzj.admin.service.PurchaseListService;
import com.lzj.admin.service.UserService;
import com.lzj.admin.utils.AssertUtil;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.security.Principal;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/purchase")
public class PurchaseListController {

    @Resource
    private PurchaseListService purchaseListService;

    @Resource
    private UserService userService;

    /**
     * 进货入库页面
     */
    @RequestMapping("/index")
    public String index(Model model){

        // 获取下一张进货单号
        String purchaseNumber = purchaseListService.getNextPurchaseNumber();

        model.addAttribute("purchaseNumber",purchaseNumber);

        return "purchase/purchase";
    }

    /**
     * 进货单查询页面
     */
    @RequestMapping("/searchPage")
    public String searchPage(){

        return "purchase/purchase_search";
    }

    /**
     * 保存进货单
     */
    @RequestMapping("/save")
    @ResponseBody
    public RespBean save(PurchaseList purchaseList,
                         String goodsJson,
                         Principal principal){

        AssertUtil.isTrue(principal==null,"用户未登录");

        List<PurchaseListGoods> goodsList =
                new Gson().fromJson(goodsJson,
                        new TypeToken<List<PurchaseListGoods>>(){}.getType());

        purchaseListService.savePurchaseList(
                purchaseList,
                goodsList,
                principal.getName());

        return RespBean.success("保存成功");
    }

    /**
     * 分页查询进货单
     */
    @RequestMapping("/list")
    @ResponseBody
    public Map<String,Object> list(PurchaseListQuery query){

        return purchaseListService.queryPurchaseList(query);

    }

    /**
     * 删除进货单
     */
    @RequestMapping("/delete")
    @ResponseBody
    public RespBean delete(Integer id){

        AssertUtil.isTrue(id==null,"请选择要删除的数据");

        purchaseListService.deletePurchaseList(id);

        return RespBean.success("删除成功");
    }

}