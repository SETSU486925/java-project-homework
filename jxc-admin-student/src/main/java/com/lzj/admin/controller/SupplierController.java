package com.lzj.admin.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.lzj.admin.model.RespBean;
import com.lzj.admin.pojo.Supplier;
import com.lzj.admin.query.SupplierQuery;
import com.lzj.admin.service.SupplierService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.rmi.MarshalledObject;
import java.util.List;
import java.util.Map;
@Controller
@RequestMapping("/supplier")
public class SupplierController {
    @Autowired
    private SupplierService supplierService;

    // 跳转供应商页面
    @RequestMapping("index")
    public String index(){
        return "/supplier/supplier";
    }

    // 分页列表接口
    @RequestMapping("list")
    @ResponseBody
    public Map<String,Object> list(SupplierQuery supplierQuery){
        return supplierService.supplierList(supplierQuery);
    }
    /**
     * 新增/修改页面
     */
    @RequestMapping("addOrUpdateSupplierPage")
    public String addOrUpdateSupplierPage(Integer id, Model model){

        if(id!=null){
            model.addAttribute("supplier",
                    supplierService.queryById(id));
        }

        return "/supplier/add_update";
    }

    /**
     * 保存
     */
    @RequestMapping("save")
    @ResponseBody
    public RespBean save(Supplier supplier){

        supplierService.saveSupplier(supplier);

        return RespBean.success("添加成功！");
    }

    /**
     * 修改
     */
    @RequestMapping("update")
    @ResponseBody
    public RespBean update(Supplier supplier){

        supplierService.updateSupplier(supplier);

        return RespBean.success("修改成功！");
    }

    /**
     * 根据ID查询
     */
    @RequestMapping("queryById")
    @ResponseBody
    public Supplier queryById(Integer id){

        return supplierService.queryById(id);
    }

    /**
     * 删除
     */
    @RequestMapping("delete")
    @ResponseBody
    public RespBean delete(Integer[] ids){

        supplierService.deleteSupplier(ids);

        return RespBean.success("删除成功！");
    }
}
