package com.lzj.admin.controller;

import com.lzj.admin.model.RespBean;
import com.lzj.admin.pojo.Role;
import com.lzj.admin.query.RoleQuery;
import com.lzj.admin.service.RoleService;
import com.lzj.admin.service.impl.RoleServiceimpl;
import io.swagger.annotations.SecurityDefinition;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.annotation.Secured;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/role")
public class RoleController {
    @RequestMapping("toAddGrantPage")
    public String AddGrantPage(Integer roleId,Model model){
        model.addAttribute("roleId",roleId);
        return "/role/grant";
    }
    @Autowired
    private RoleServiceimpl roleServiceimpl;
    @PreAuthorize("hasAnyAuthority('101003')")
    @RequestMapping("index")

    public String index(){
        return "/role/role";
    }
    @RequestMapping("list")
    @ResponseBody
    public Map list(RoleQuery roleQuery){
        return roleServiceimpl.roleList(roleQuery);
    }
    @RequestMapping("addOrUpdateRolePage")
    public String addOrUpdateRole(Integer id, Model model){
    if (id!=null){
        Role temp = this.roleServiceimpl.getById(id);
        model.addAttribute("role",temp);
    }
    return "/role/add_update";
    }
    @RequestMapping("save")
    @ResponseBody
    public RespBean save(Role role){
    roleServiceimpl.saveRole(role);
    return RespBean.success("保存成功");
    }
    @RequestMapping("update")
    @ResponseBody
    public RespBean update(Role role){
    roleServiceimpl.updateRole(role);
    return RespBean.success("修改成功");
    }
    @RequestMapping("delete")
    @ResponseBody
    public RespBean delete(Integer id){
    this.roleServiceimpl.deleteRole(id);
    return RespBean.success("删除成功");
    }

    @RequestMapping("queryAllRoles")
    @ResponseBody
    public List<Map<String, Object>> queryAllRole(Integer userId){
    return this.roleServiceimpl.queryAllRoles(userId);
    }
    @RequestMapping("addGrant")
    @ResponseBody
    public RespBean addGrant(Integer[] mids,Integer roleId){
        this.roleServiceimpl.addRole(mids,roleId);
        return RespBean.success("授权成功");
    }
}
