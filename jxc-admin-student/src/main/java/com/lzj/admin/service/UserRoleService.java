package com.lzj.admin.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.lzj.admin.pojo.UserRole;

import java.util.List;

/**
 * 用户角色表服务类
 * @author TianTian
 * @date 2022/1/19 14:00
 */
public interface UserRoleService extends IService<UserRole> {
    public List<String> findRoleByUserName(String userName);
}
