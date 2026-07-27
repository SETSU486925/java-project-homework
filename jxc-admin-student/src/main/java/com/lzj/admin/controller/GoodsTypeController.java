package com.lzj.admin.controller;

import com.lzj.admin.dto.TreeDto;
import com.lzj.admin.model.RespBean;
import com.lzj.admin.pojo.GoodsType;
import com.lzj.admin.service.GoodsTypeService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

/**
 * 商品类别控制器
 *
 * @author TianTian
 */
@Controller
@RequestMapping("/goodsType")
public class GoodsTypeController {

    @Resource
    private GoodsTypeService goodsTypeService;

    /**
     * 商品类别页面
     */
    @RequestMapping("/index")
    public String index() {
        return "goodsType/goodsType";
    }

    /**
     * 新增/修改页面
     */
    @RequestMapping("/addOrUpdatePage")
    public String addOrUpdatePage(Integer id, Model model) {

        if (id != null) {
            GoodsType goodsType = goodsTypeService.queryById(id);
            model.addAttribute("goodsType", goodsType);
        }

        return "goodsType/add_update";
    }

    /**
     * 分类树
     */
    @RequestMapping("/tree")
    @ResponseBody
    public List<TreeDto> tree() {
        return goodsTypeService.queryGoodsTypeTree();
    }

    /**
     * 查询全部分类
     */
    @RequestMapping("/list")
    @ResponseBody
    public Map<String, Object> list() {
        return goodsTypeService.queryGoodsType();
    }

    /**
     * 根据ID查询
     */
    @RequestMapping("/queryById")
    @ResponseBody
    public GoodsType queryById(Integer id) {
        return goodsTypeService.queryById(id);
    }

    /**
     * 新增分类
     */
    @PostMapping("/save")
    @ResponseBody
    public RespBean save(GoodsType goodsType) {

        goodsTypeService.saveGoodsType(goodsType);

        return RespBean.success("商品类别添加成功！");
    }

    /**
     * 修改分类
     */
    @PostMapping("/update")
    @ResponseBody
    public RespBean update(GoodsType goodsType) {

        goodsTypeService.updateGoodsType(goodsType);

        return RespBean.success("商品类别修改成功！");
    }

    /**
     * 删除分类
     */
    @PostMapping("/delete")
    @ResponseBody
    public RespBean delete(Integer id) {

        goodsTypeService.deleteGoodsType(id);

        return RespBean.success("商品类别删除成功！");
    }

}
