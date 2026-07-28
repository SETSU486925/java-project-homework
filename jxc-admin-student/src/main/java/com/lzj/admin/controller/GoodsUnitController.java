package com.lzj.admin.controller;

import com.lzj.admin.pojo.GoodsUnit;
import com.lzj.admin.service.GoodsUnitService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.util.List;

/**
 * 商品单位控制器
 *
 * @author TianTian
 */
@Controller
@RequestMapping("/goodsUnit")
public class GoodsUnitController {

    @Resource
    private GoodsUnitService goodsUnitService;

    /**
     * 查询全部商品单位
     */
    @RequestMapping("/list")
    @ResponseBody
    public List<GoodsUnit> list() {

        return goodsUnitService.queryAllGoodsUnit();

    }

}