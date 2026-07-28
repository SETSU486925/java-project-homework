package com.lzj.admin.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.lzj.admin.dto.TreeDto;
import com.lzj.admin.pojo.Menu;

import java.util.List;
import java.util.Map;

public interface MenuService extends IService<Menu> {

    /**
     * 菜单树列表
     */
    Map<String,Object> queryMenuList();

    /**
     * 查询所有菜单树
     */
    List<TreeDto> queryMenuTree();

    /**
     * 新增菜单
     */
    void saveMenu(Menu menu);

    /**
     * 修改菜单
     */
    void updateMenu(Menu menu);

    /**
     * 删除菜单
     */
    void deleteMenu(Integer id);

    /**
     * 根据ID查询
     */
    Menu queryById(Integer id);

}
