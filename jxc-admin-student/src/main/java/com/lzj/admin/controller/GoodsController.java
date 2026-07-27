package com.lzj.admin.controller;

import com.lzj.admin.model.RespBean;
import com.lzj.admin.pojo.Goods;
import com.lzj.admin.query.GoodsQuery;
import com.lzj.admin.service.GoodsService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import javax.annotation.Resource;
import java.util.Map;

@Controller
@RequestMapping("/goods")
public class GoodsController {

    @Resource
    private GoodsService goodsService;

    @RequestMapping("/index")
    public String index(){
        return "goods/goods";
    }

    @RequestMapping("/addOrUpdatePage")
    public String addOrUpdatePage(Integer id, Model model){
        if(id!=null){
            model.addAttribute("goods",goodsService.queryById(id));
        }
        return "goods/add_update";
    }

    @RequestMapping("/list")
    @ResponseBody
    public Map<String,Object> list(GoodsQuery query){
        return goodsService.queryGoods(query);
    }

    @PostMapping("/save")
    @ResponseBody
    public RespBean save(Goods goods){
        goodsService.saveGoods(goods);
        return RespBean.success("商品添加成功！");
    }

    @PostMapping("/update")
    @ResponseBody
    public RespBean update(Goods goods){
        goodsService.updateGoods(goods);
        return RespBean.success("商品修改成功！");
    }

    @PostMapping("/delete")
    @ResponseBody
    public RespBean delete(Integer id){
        goodsService.deleteGoods(id);
        return RespBean.success("商品删除成功！");
    }

    @RequestMapping("/queryById")
    @ResponseBody
    public Goods queryById(Integer id){
        return goodsService.queryById(id);
    }
}


