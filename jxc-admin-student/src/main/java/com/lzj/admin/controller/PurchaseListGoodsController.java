package com.lzj.admin.controller;

import com.lzj.admin.pojo.PurchaseListGoods;
import com.lzj.admin.query.PurchaseListGoodsQuery;
import com.lzj.admin.service.PurchaseListGoodsService;
import com.lzj.admin.utils.PageResultUtil;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

/**
 * 进货单商品明细控制器
 */
@RestController
@RequestMapping("/purchaseListGoods")
@Api(tags = "进货单商品明细模块")
public class PurchaseListGoodsController {

    @Resource
    private PurchaseListGoodsService purchaseListGoodsService;

    /**
     * 分页条件查询进货商品明细
     */
    @GetMapping("list")
    @ApiOperation("分页查询进货商品明细")
    public PageResultUtil queryPurchaseListGoods(PurchaseListGoodsQuery query) {
        Map<String, Object> resultMap = purchaseListGoodsService.queryPurchaseListGoods(query);
        return PageResultUtil.ok(resultMap);
    }

    /**
     * 根据进货单id查询明细列表
     */
    @GetMapping("findByPurchaseId")
    @ApiOperation("根据进货单ID查询明细")
    public PageResultUtil findByPurchaseId(@RequestParam Integer purchaseId) {
        List<PurchaseListGoods> goodsList = purchaseListGoodsService.queryByPurchaseId(purchaseId);
        return PageResultUtil.ok(goodsList);
    }

    /**
     * 根据进货单id删除所有明细
     */
    @PostMapping("deleteByPurchaseId")
    @ApiOperation("根据进货单ID删除明细")
    public PageResultUtil deleteByPurchaseId(@RequestParam Integer purchaseId) {
        purchaseListGoodsService.deleteByPurchaseId(purchaseId);
        return PageResultUtil.ok("删除成功");
    }

    /**
     * 批量新增进货明细
     */
    @PostMapping("batchSave")
    @ApiOperation("批量保存进货商品明细")
    public PageResultUtil batchSave(@RequestBody List<PurchaseListGoods> purchaseListGoodsList) {
        purchaseListGoodsService.insertBatch(purchaseListGoodsList);
        return PageResultUtil.ok("批量保存成功");
    }
}
