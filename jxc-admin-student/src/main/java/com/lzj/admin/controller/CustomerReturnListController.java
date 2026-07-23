package com.lzj.admin.controller;


import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.lzj.admin.model.RespBean;
import com.lzj.admin.pojo.CustomerReturnList;
import com.lzj.admin.pojo.CustomerReturnListGoods;
import com.lzj.admin.pojo.SaleList;
import com.lzj.admin.pojo.SaleListGoods;
import com.lzj.admin.query.CustomerReturnListQuery;
import com.lzj.admin.service.CustomerReturnListService;

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
 * 客户退货单控制器
 * @author TianTian
 * @date 2022/1/19 22:58
 */
@Controller
@RequestMapping("/customerReturn")
public class CustomerReturnListController {


    @Resource
    private CustomerReturnListService customerReturnListService;


    @Resource
    private UserService userService;

    /**
     * 客户退货主页
     * @return
     */
    @RequestMapping("index")
    public String index(Model model){
        model.addAttribute("customerReturnNumber",customerReturnListService.getNextCustomerReturnNumber());
        return "customerReturn/customer_return";
    }

    @RequestMapping("save")
    @ResponseBody
    public RespBean save(CustomerReturnList customerReturnList, String goodsJson, Principal principal){
        String userName = principal.getName();
        customerReturnList.setUserId(userService.findForName(userName).getId());
        Gson gson = new Gson();
        List<CustomerReturnListGoods> slgList = gson.fromJson(goodsJson,new TypeToken<List<CustomerReturnListGoods>>(){}.getType());
        customerReturnListService.saveCustomerReturnList(customerReturnList,slgList);
        return RespBean.success("商品退货入库成功!");
    }


    /**
     * 退货单查询页
     * @return
     */
    @RequestMapping("searchPage")
    public String searchPage(){
        return "customerReturn/customer_return_search";
    }


    /**
     * 退货单列表
     * @param customerReturnListQuery
     * @return
     */
    @RequestMapping("list")
    @ResponseBody
    public Map<String,Object> customerReturnList(CustomerReturnListQuery customerReturnListQuery){
        return customerReturnListService.customerReturnList(customerReturnListQuery);
    }
    /**
     * 删除进货单记录
     * @param id
     * @return
     */
    @RequestMapping("delete")
    @ResponseBody
    public RespBean delete(Integer id){
        customerReturnListService.deleteCustomerReturn(id);
        return RespBean.success("删除成功");
    }




}
