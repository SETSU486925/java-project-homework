package com.lzj.admin.service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.IService;
import com.lzj.admin.mapper.RoleMenuMapper;
import com.lzj.admin.pojo.RoleMenu;

import java.util.List;
/**
 * 角色菜单表服务类
 * @author TianTian
 * @date 2022/1/19 13:59
 */
public interface RoleMenuService extends IService<RoleMenu> {
    public List<Integer> queryExRoles(Integer roleid);
    public List<String> findAuthoritiesByRoleName(List<String> roleName);

}
