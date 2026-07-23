package com.lzj.admin.controller;


import com.lzj.admin.model.RespBean;
import com.lzj.admin.query.ReturnListGoodsQuery;
import com.lzj.admin.query.saleListGoodsQuery;

import com.lzj.admin.service.SaleListGoodsService;
import org.springframework.web.bind.annotation.RequestMapping;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.util.Map;

/**
 * 销售单表控制器
 * @author TianTian
 * @date 2022/1/19 23:02
 */
@Controller
@RequestMapping("/saleListGoods")
public class SaleListGoodsController {

    @Resource
    private SaleListGoodsService saleListGoodsService;

    @RequestMapping("list")
    @ResponseBody
    public Map<String,Object> saleListGoodsList(saleListGoodsQuery saleListGoodsQuery){
        return saleListGoodsService.saleListGoodsList(saleListGoodsQuery);
    }


}
