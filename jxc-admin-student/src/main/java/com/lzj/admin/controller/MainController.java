package com.lzj.admin.controller;

import com.lzj.admin.pojo.User;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpSession;

/**
 * Main控制器
 * @author TianTian
 * @date 2022/1/5 20:01
 */
@Controller
public class MainController {
    @RequestMapping("index")
    public String index(){
        return "index";
    }
    @RequestMapping("main")
    public String main(){
        return "main";
    }
    @RequestMapping("welcome")
    public String welcome(){
        return "welcome";
    }




//    /**
//     * @version 退出1.0（被Security取代）
//     * @param session
//     * @return
//     */
//    @RequestMapping("signout")
//    public String signout(HttpSession session) {
//        session.removeAttribute("user");
//        return "redirect:/index";
//    }
}
