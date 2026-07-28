package com.lzj.admin.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.lzj.admin.dto.TreeDto;
import com.lzj.admin.mapper.MenuMapper;
import com.lzj.admin.pojo.Menu;
import com.lzj.admin.service.MenuService;
import com.lzj.admin.utils.AssertUtil;
import com.lzj.admin.utils.PageResultUtil;
import com.lzj.admin.utils.StringUtil;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class MenuServiceImpl extends ServiceImpl<MenuMapper, Menu> implements MenuService {

    @Resource
    private MenuMapper menuMapper;

    /**
     * 查询菜单列表
     */
    @Override
    public Map<String, Object> queryMenuList() {

        QueryWrapper<Menu> wrapper = new QueryWrapper<>();
        wrapper.eq("is_del", 0);
        wrapper.orderByAsc("grade");
        wrapper.orderByAsc("id");

        List<Menu> list = list(wrapper);

        return PageResultUtil.setResult((long) list.size(), list);
    }

    /**
     * 查询菜单树
     */
    @Override
    public List<TreeDto> queryMenuTree() {

        QueryWrapper<Menu> wrapper = new QueryWrapper<>();
        wrapper.eq("is_del", 0);
        wrapper.orderByAsc("id");

        List<Menu> menuList = list(wrapper);

        List<TreeDto> treeList = new ArrayList<>();

        for (Menu menu : menuList) {

            TreeDto dto = new TreeDto();

            dto.setId(menu.getId());
            dto.setpId(menu.getpId());
            dto.setName(menu.getName());

            treeList.add(dto);

        }

        return treeList;
    }

    /**
     * 新增菜单
     */
    @Override
    public void saveMenu(Menu menu) {

        AssertUtil.isTrue(menu == null, "菜单不能为空");

        AssertUtil.isTrue(StringUtil.isEmpty(menu.getName()),
                "菜单名称不能为空");

        QueryWrapper<Menu> wrapper = new QueryWrapper<>();
        wrapper.eq("name", menu.getName());
        wrapper.eq("is_del", 0);

        Menu temp = getOne(wrapper);

        AssertUtil.isTrue(temp != null, "菜单名称已存在");

        if (menu.getIsDel() == null) {
            menu.setIsDel(0);
        }

        save(menu);
    }

    /**
     * 修改菜单
     */
    @Override
    public void updateMenu(Menu menu) {

        AssertUtil.isTrue(menu == null, "参数错误");

        AssertUtil.isTrue(menu.getId() == null,
                "菜单ID不能为空");

        Menu old = getById(menu.getId());

        AssertUtil.isTrue(old == null,
                "菜单不存在");

        updateById(menu);
    }

    /**
     * 删除菜单
     */
    @Override
    public void deleteMenu(Integer id) {

        Menu menu = getById(id);

        AssertUtil.isTrue(menu == null,
                "菜单不存在");

        menu.setIsDel(1);

        updateById(menu);

    }

    /**
     * 根据ID查询
     */
    @Override
    public Menu queryById(Integer id) {

        return getById(id);

    }

}

