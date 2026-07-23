package com.lzj.admin.service.impl;

import com.baomidou.mybatisplus.core.conditions.Wrapper;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.lzj.admin.mapper.RoleMapper;
import com.lzj.admin.pojo.Role;
import com.lzj.admin.pojo.RoleMenu;
import com.lzj.admin.pojo.SaleListGoods;
import com.lzj.admin.query.RoleQuery;
import com.lzj.admin.service.MenuService;
import com.lzj.admin.service.RoleMenuService;
import com.lzj.admin.service.RoleService;
import com.lzj.admin.service.SaleListGoodsService;
import com.lzj.admin.utils.AssertUtil;
import com.lzj.admin.utils.PageResultUtil;
import com.lzj.admin.utils.StringUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Base64;
import java.util.List;
import java.util.Map;

@Service
public class RoleServiceimpl extends ServiceImpl<RoleMapper, Role> implements RoleService {

    @Autowired
    private RoleMenuService roleMenuService;
    public Map<String, Object> roleList(RoleQuery roleQuery) {
        IPage<Role> page = new Page<Role>(roleQuery.getPage(),roleQuery.getLimit());
        QueryWrapper<Role> queryWrapper =new QueryWrapper<Role>();
        queryWrapper.eq("is_del",0);
        if(StringUtil.isNotEmpty(roleQuery.getRoleName())){
            queryWrapper.like("name",roleQuery.getRoleName());
        }
        page = this.baseMapper.selectPage(page,queryWrapper);
        return PageResultUtil.setResult(page.getTotal(),page.getRecords());
    }

    @Override
    @Transactional(propagation = Propagation.REQUIRED,rollbackFor = Exception.class)
    public void saveRole(Role role) {
        AssertUtil.isTrue(StringUtil.isEmpty(role.getName()),"用户名为空");
        AssertUtil.isTrue(null!=this.findRoleByRoleName(role.getName()),"用户已存在");
//        role.setIsDel(1);
        AssertUtil.isTrue(!this.save(role),"添加失败");

    }

    @Override
    @Transactional(propagation = Propagation.REQUIRED,rollbackFor = Exception.class)
    public void updateRole(Role role) {
        AssertUtil.isTrue(StringUtil.isEmpty(role.getName()),"用户名为空");
        Role temp = this.findRoleByRoleName(role.getName());
        AssertUtil.isTrue(temp!=null&&!(temp.getId().equals(role.getId())),"用户名存在");
        AssertUtil.isTrue(!this.updateById(role),"修改失败");
    }
    @Override
    public Role findRoleByRoleName(String roleName) {
        return this.baseMapper.selectOne(new QueryWrapper<Role>().eq("is_del",0).eq("name",roleName));
    }

    @Override
    public void deleteRole(Integer id) {
        AssertUtil.isTrue(null==id,"删除失败");
        Role temp = this.getById(id);
        temp.setIsDel(1);
       AssertUtil.isTrue(!this.updateById(temp),"删除失败");

    }

    @Override
    public List<Map<String, Object>> queryAllRoles(Integer userId) {
        return this.baseMapper.queryAllRoles(userId);
    }

    @Override
    public void addRole(Integer[] mids, Integer roleId) {
        AssertUtil.isTrue(roleId==null,"用户为空");
        QueryWrapper<RoleMenu> roleMenuQueryWrapper = new QueryWrapper<>();
        int count = roleMenuService.count(roleMenuQueryWrapper.eq("role_id", roleId));
         if (count>0){
           AssertUtil.isTrue( !this.roleMenuService.remove(roleMenuQueryWrapper.eq("role_id",roleId)),"授权失败");
         }
         if(mids!=null){
             ArrayList<RoleMenu> roleMenus = new ArrayList<>();
             for (Integer i:mids
                  ) {
                 RoleMenu roleMenu = new RoleMenu();
                 roleMenu.setRoleId(roleId);
                 roleMenu.setMenuId(i);
                 roleMenus.add(roleMenu);
             }
             AssertUtil.isTrue(!this.roleMenuService.saveBatch(roleMenus),"授权失败");
         }

    }

}
