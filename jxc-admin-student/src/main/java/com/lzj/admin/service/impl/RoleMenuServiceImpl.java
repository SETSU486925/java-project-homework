package com.lzj.admin.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.lzj.admin.mapper.MenuMapper;
import com.lzj.admin.mapper.RoleMenuMapper;
import com.lzj.admin.pojo.Menu;
import com.lzj.admin.pojo.RoleMenu;
import com.lzj.admin.service.RoleMenuService;
import org.springframework.boot.autoconfigure.rsocket.RSocketProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class RoleMenuServiceImpl extends ServiceImpl<RoleMenuMapper, RoleMenu> implements RoleMenuService {
  @Override
  public List<Integer> queryExRoles(Integer roles) {
    return this.baseMapper.queryExRoles(roles);
  }

  @Override
  public List<String> findAuthoritiesByRoleName(List<String> roleName) {
      if (roleName.isEmpty()) {
          return roleName;
      }
      return this.baseMapper.findAuthoritiesByRoleName(roleName);
  }
}
