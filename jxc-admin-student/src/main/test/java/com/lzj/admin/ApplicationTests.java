package com.lzj.admin;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.IService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.lzj.admin.dto.TreeDto;
import com.lzj.admin.mapper.*;
import com.lzj.admin.pojo.PurchaseList;
import com.lzj.admin.pojo.Role;
import com.lzj.admin.pojo.RoleMenu;
import com.lzj.admin.pojo.User;
import com.lzj.admin.service.PurchaseListService;
import com.lzj.admin.service.RoleMenuService;
import com.lzj.admin.service.RoleService;
import com.lzj.admin.service.impl.PurchaseListServiceImpl;
import com.lzj.admin.service.impl.RoleMenuServiceImpl;
import com.lzj.admin.service.impl.RoleServiceimpl;
import org.junit.jupiter.api.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.context.junit4.SpringRunner;


import java.text.SimpleDateFormat;
import java.util.*;

@RunWith(SpringRunner.class)
@SpringBootTest
class ApplicationTests extends ServiceImpl<RoleMenuMapper, RoleMenu> {

    @Autowired
    private PurchaseListMapper purchaseListMapper;

    @Autowired
    private UserMapper userMapper;
    @Autowired
    private MenuMapper menuMapper;

//    @Test
//    void contextLoads() {
//        List<User> listuser =   userMapper.listuser();
//        System.out.println(listuser);
//    }
//    @Test
//    void contextLoads2() {
//        User admin = userMapper.oneUser("admin");
//        System.out.println(admin);
//    }
//    @Test
//    void updateTest() {
//        User user = new User();
//        user.setId(2);
//        user.setUserName("wuyanzu");
//        int i = userMapper.updateUserInfo(user);
//        System.out.println(i);
//    }
//    @Test
//    void updateUserPasswordByIdTest(){
//        int i = userMapper.updateUserPasswordById(2, "66666");
//        System.out.println(i);
//    }
//
//    @Test
//     void queryExUesrTest() {
//        String s = new String();
//        List<User> admin = userMapper.queryExUser("marry");
//        System.out.println(admin);
//
//    }
//    @Test
//    void inserttest(){
//        User user = new User();
//        user.setIsDel(0);
//        user.setRemarks("sdasdasd");
//        user.setUserName("sadasdksadasd");
//        user.setBz("ddsadasdsad");
//
//        System.out.println(user);
//        userMapper.insertUser(user);
//
//    }
//    @Test
//    void userTest(){
//        int i = userMapper.deleteUser(10);
//    }
//    @Test
//    void RoleTest(){
//        QueryWrapper<Role> roleQueryWrapper = new QueryWrapper<>();
//        QueryWrapper<Role> eq = roleQueryWrapper.eq("name", "管理员");
//        List<Role> roles = baseMapper.selectList(roleQueryWrapper);
//        System.out.println(roles);
//        Role byId = this.getById(2);
//        System.out.println(byId);
//
//    }
//    @Test
//    public void queryTest(){
//        List<Map<String, Object>> maps = this.baseMapper.queryAllRoles(1);
//        System.out.println(maps);
//    }
//    @Test
//    public void queryAllMenuTest() {
//        List<TreeDto> treeDtos = this.menuMapper.queryAllMenu();
//        System.out.println(treeDtos);
//    }
    @Autowired
    private RoleMenuServiceImpl roleMenuService;

    @Autowired
    private PurchaseListService purchaseListService;
    @Test
    public void arrayListTest() {
        List<String> strings = new ArrayList<>();

        List<String> Ai =this.roleMenuService.findAuthoritiesByRoleName(strings);
        for (String i:Ai
             ) {
            System.out.println(i);

        }
        }
        @Autowired
        private PasswordEncoder passwordEncoder;
        @Test
        public void encodeTest(){
            String encode = passwordEncoder.encode("123456");
            boolean matches = passwordEncoder.matches("123456", "$2a$10$hXGeVoEokYspdLD8HNKPL.Ta/E12emjEW/GYJkWd/BZTsA8HWdKzW");
            System.out.println(matches);
//            String s="/"+request.getContextPath()+"MyHome.html";
//            String s2=request.getRequestURL()+"MyHome.html";
        }
        @Test
        public void testt(){
            PurchaseList purchaseList = this.purchaseListMapper.selectById(29);
            System.out.println(purchaseList);
            Date date = new Date("Wed Jan 21 00:00:00 CST 2022");
            purchaseList.setId(99);
            purchaseList.setPurchaseDate(date);
            SimpleDateFormat formatter= new SimpleDateFormat("yyyy-MM-dd");
            Date date1 = new Date(System.currentTimeMillis());
            System.out.println(formatter.format(date));
            int i = formatter.format(purchaseList.getPurchaseDate()).compareTo(formatter.format(date1));
            System.out.println(i);


        }
        @Test
        public void testtt(){
            String nextPurchaseNumber = purchaseListService.getNextPurchaseNumber();
            System.out.println(nextPurchaseNumber);
        }

}
