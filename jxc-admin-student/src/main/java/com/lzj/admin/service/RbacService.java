package com.lzj.admin.service;

import com.baomidou.mybatisplus.extension.service.IService;

import java.util.List;
/**
 * 权限验证服务类
 * @author TianTian
 * @date 2022/1/19 13:59
 */
public interface RbacService{
    public List<String> findRoleByUserName(String userName);
    public List<String> findAuthoritiesByRoleName(List<String> roleName);}
