package com.lzj.admin.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.lzj.admin.pojo.Role;
import com.lzj.admin.query.RoleQuery;

import java.util.List;
import java.util.Map;
/**
 * 角色表服务类
 * @author TianTian
 * @date 2022/1/19 13:59
 */
public interface RoleService extends IService<Role> {
    public Map<String, Object> roleList(RoleQuery roleQuery);
    public void saveRole (Role role);
    public void updateRole (Role role);
    public Role findRoleByRoleName(String roleName);
    public void deleteRole(Integer id);
    public List<Map<String, Object>> queryAllRoles(Integer userId);
    public void addRole(Integer[] mids,Integer roleId);

}
