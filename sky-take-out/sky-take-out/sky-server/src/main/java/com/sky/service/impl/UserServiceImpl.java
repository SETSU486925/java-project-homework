package com.sky.service.impl;

import com.alibaba.fastjson.JSONObject;
import com.sky.constant.MessageConstant;
import com.sky.dto.UserLoginDTO;
import com.sky.entity.User;
import com.sky.exception.UserLoginException;
import com.sky.mapper.UserMapper;
import com.sky.service.UserService;
import com.sky.utils.HttpClientUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

@Service
@Slf4j
public class UserServiceImpl implements UserService {

    @Value("${sky.wechat.appid}")
    private String appid;
    @Value("${sky.wechat.secret}")
    private String secret;

    //微信接口地址
    private static final String WX_URL = "https://api.weixin.qq.com/sns/jscode2session";

    @Autowired
    private UserMapper userMapper;

    /**
     * 微信登录
     * @param userLoginDTO
     * @return
     */
    @Override
    public User wxLogin(UserLoginDTO userLoginDTO) {
        Map<String,String> map = new HashMap<>();
        map.put("grant_type","authorization_code");
        map.put("appid",appid);
        map.put("secret",secret);
        map.put("js_code",userLoginDTO.getCode());

        String json = HttpClientUtil.doGet(WX_URL, map);
        log.info("微信返回json:{}",json);
        JSONObject jsonObject = JSONObject.parseObject(json);
        String openid = jsonObject.getString("openid");

        if(openid == null){
            throw new UserLoginException(MessageConstant.LOGIN_FAILED);
        }

        User user = userMapper.selectUserInfoByOpenid(openid);

        if(user == null){
            user = new User();
            user.setOpenid(openid);
            user.setCreateTime(LocalDateTime.now());
            userMapper.insert(user);
        }
        return user;
    }
}
