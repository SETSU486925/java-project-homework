package com.lzj.admin.controller;

import com.lzj.admin.dto.TreeDto;
import com.lzj.admin.model.RespBean;
import com.lzj.admin.pojo.Menu;
import com.lzj.admin.service.MenuService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;
import java.util.Map;

/**
 * 菜单控制器
 *
 * @author TianTian
 * @date 2022/1/14
 */
@Controller
@RequestMapping("/menu")
public class MenuController {

    @Autowired
    private MenuService menuService;

    /**
     * 菜单管理首页
     */
    @RequestMapping("/index")
    public String index() {
        return "menu/menu";
    }

    /**
     * 菜单列表
     */
    @RequestMapping("/list")
    @ResponseBody
    public Map<String, Object> list() {
        return menuService.queryMenuList();
    }

    /**
     * 菜单树
     */
    @RequestMapping("/tree")
    @ResponseBody
    public List<TreeDto> tree() {
        return menuService.queryMenuTree();
    }

    /**
     * 新增页面
     */
    @RequestMapping("/addMenuPage")
    public String addMenuPage(Model model) {

        model.addAttribute("treeList", menuService.queryMenuTree());

        return "menu/add_update";
    }

    /**
     * 修改页面
     */
    @RequestMapping("/updateMenuPage")
    public String updateMenuPage(Integer id, Model model) {

        model.addAttribute("menu", menuService.queryById(id));
        model.addAttribute("treeList", menuService.queryMenuTree());

        return "menu/add_update";
    }

    /**
     * 根据ID查询
     */
    @RequestMapping("/queryById")
    @ResponseBody
    public Menu queryById(Integer id) {

        return menuService.queryById(id);

    }

    /**
     * 新增菜单
     */
    @RequestMapping("/save")
    @ResponseBody
    public RespBean save(Menu menu) {

        menuService.saveMenu(menu);

        return RespBean.success("菜单添加成功！");
    }

    /**
     * 修改菜单
     */
    @RequestMapping("/update")
    @ResponseBody
    public RespBean update(Menu menu) {

        menuService.updateMenu(menu);

        return RespBean.success("菜单修改成功！");
    }

    /**
     * 删除菜单
     */
    @RequestMapping("/delete")
    @ResponseBody
    public RespBean delete(Integer id) {

        menuService.deleteMenu(id);

        return RespBean.success("菜单删除成功！");
    }

}