package com.sky.mapper;

import com.sky.entity.User;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

@Mapper
public interface UserMapper {

    /**
     * 根据openid查询用户
     * @param openid
     * @return
     */
    @Select("select * from user where openid = #{openid}")
    User selectUserInfoByOpenid(String openid);

    /**
     * 插入新用户
     * @param user
     */
    @Insert("insert into user(openid,create_time) values(#{openid},#{createTime})")
    void insert(User user);
}