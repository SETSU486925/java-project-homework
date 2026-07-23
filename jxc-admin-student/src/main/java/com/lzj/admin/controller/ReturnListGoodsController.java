package com.lzj.admin.controller;


import com.lzj.admin.query.PurchaseListGoodsQuery;
import com.lzj.admin.query.ReturnListGoodsQuery;

import com.lzj.admin.service.ReturnListGoodsService;
import org.springframework.web.bind.annotation.RequestMapping;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.util.Map;

/**
 * 退货单商品表控制器
 * @author TianTian
 * @date 2022/1/19 23:04
 */
@Controller
@RequestMapping("/returnListGoods")
public class ReturnListGoodsController {

    @Resource
    private ReturnListGoodsService returnListGoodsService;


    @RequestMapping("list")
    @ResponseBody
    public Map<String,Object> returnListGoodsList(ReturnListGoodsQuery returnListGoodsQuery){
        return returnListGoodsService.returnListGoodsList(returnListGoodsQuery);
    }




}
