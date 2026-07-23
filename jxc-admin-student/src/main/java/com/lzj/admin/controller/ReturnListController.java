package com.lzj.admin.controller;


import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.lzj.admin.model.RespBean;
import com.lzj.admin.pojo.PurchaseList;
import com.lzj.admin.pojo.PurchaseListGoods;
import com.lzj.admin.pojo.ReturnList;
import com.lzj.admin.pojo.ReturnListGoods;
import com.lzj.admin.query.PurchaseListQuery;
import com.lzj.admin.query.ReturnListQuery;

import com.lzj.admin.service.ReturnListService;
import com.lzj.admin.service.UserService;
import com.lzj.admin.utils.AssertUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.jws.WebParam;
import java.security.Principal;
import java.util.List;
import java.util.Map;

/**
 * 退货单表控制器
 * @author TianTian
 * @date 2022/1/19 23:00
 */
@Slf4j
@Controller
@RequestMapping("/return")
public class ReturnListController {

    @Resource
    private ReturnListService returnListService;

    @Resource
    private UserService userService;

    @RequestMapping("index")
    public String index(Model model){
        model.addAttribute("returnNumber",returnListService.getNextReturnNumber());
        return "return/return";
    }


    @RequestMapping("save")
    @ResponseBody
    public RespBean save(ReturnList returnList, String goodsJson, Principal principal){
        String userName = principal.getName();
        returnList.setUserId(userService.findForName(userName).getId());
        Gson gson = new Gson();
        System.out.println(goodsJson);
        List<ReturnListGoods> rlgList = gson.fromJson(goodsJson,new TypeToken<List<ReturnListGoods>>(){}.getType());
        returnListService.saveReturnList(returnList,rlgList);
        return RespBean.success("商品退货出库成功!");
    }

    /**
     * 退货单据查询页
     * @return
     */
    @RequestMapping("searchPage")
    public String searchPage(){
        return "return/return_search";
    }

    @RequestMapping("list")
    @ResponseBody
    public Map<String,Object> returnList(ReturnListQuery returnListQuery){
        return returnListService.returnList(returnListQuery);
    }

    @RequestMapping("delete")
    @ResponseBody
    public RespBean delete(Integer id){
        returnListService.deleteReturnList(id);
        return RespBean.success("删除成功");
    }

}
