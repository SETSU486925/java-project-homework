package com.lzj.admin.controller;


import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.lzj.admin.model.RespBean;
import com.lzj.admin.pojo.DamageList;
import com.lzj.admin.pojo.DamageListGoods;
import com.lzj.admin.pojo.PurchaseListGoods;
import com.lzj.admin.query.DamageListQuery;
import com.lzj.admin.query.SaleListQuery;
import com.lzj.admin.service.DamageListService;
import com.lzj.admin.service.UserService;
import com.lzj.admin.utils.AssertUtil;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.security.Principal;
import java.util.List;
import java.util.Map;

    /**
     * 报损表单控制器
     * @author TianTian
     * @date 2022/1/21 13:36
     */
@Controller
@RequestMapping("/damage")
public class DamageListController {

    @Resource
    private DamageListService damageListService;

    @Resource
    private UserService userService;


    /**
     * 商品报损主页
     * @return
     */
    @RequestMapping("index")
    public String index(Model model){
        model.addAttribute("damageNumber",damageListService.getNextDamageNumber());
        return "damage/damage";
    }

    @RequestMapping("save")
    @ResponseBody
    public RespBean save(DamageList damageList, String goodsJson, Principal principal){
        String userName = principal.getName();
        damageList.setUserId(userService.findForName(userName).getId());
        Gson gson = new Gson();
        List<DamageListGoods> plgList = gson.fromJson(goodsJson,new TypeToken<List<DamageListGoods>>(){}.getType());
        damageListService.saveDamageList(damageList,plgList);
        return RespBean.success("商品报损出库成功!");
    }


    @RequestMapping("list")
    @ResponseBody
    public Map<String,Object> damageList(DamageListQuery damageListQuery){
        return damageListService.damageList(damageListQuery);
    }


    @RequestMapping("delete")
    @ResponseBody
    public RespBean delete(Integer id) {
        damageListService.deletedamageList(id);
        return RespBean.success("删除成功");
    }

}
