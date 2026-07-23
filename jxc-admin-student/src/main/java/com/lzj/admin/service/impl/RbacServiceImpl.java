package com.lzj.admin.service.impl;

import com.lzj.admin.service.RbacService;
import com.lzj.admin.service.RoleMenuService;
import com.lzj.admin.service.UserRoleService;
import lombok.AllArgsConstructor;
import org.apache.ibatis.annotations.Select;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class RbacServiceImpl implements RbacService {
    @Autowired
    private UserRoleService userRoleService;
    @Autowired
    private RoleMenuService roleMenuService;

    @Override
    public List<String> findRoleByUserName(String userName) {
        return this.userRoleService.findRoleByUserName(userName);
    }

    @Override
    public List<String> findAuthoritiesByRoleName(List<String> roleName) {
       return this.roleMenuService.findAuthoritiesByRoleName(roleName);
    }
}
