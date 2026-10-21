package com.sky.mapper;

import com.github.pagehelper.Page;
import com.sky.dto.OrdersPageQueryDTO;
import com.sky.entity.Orders;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@Mapper
public interface OrderMapper {

    Orders getById(Long id);

    @Select("select * from orders where order_num = #{orderNumber}")
    Orders getByNumber(String orderNumber);

    @Select("select count(id) from orders where status = #{status}")
    Integer countStatus(Integer status);

    void update(Orders orders);

    Page<Orders> pageQuery(OrdersPageQueryDTO ordersPageQueryDTO);

    void insert(Orders orders);

    @Select("select * from orders where status = #{status} and order_time < #{orderTime}")
    List<Orders> getByStatusAndOrderTimeLT(Integer status, LocalDateTime orderTime);

    @Select("select count(id) from orders where order_time between #{begin} and #{end}")
    Integer countByMap(Map map);

    @Select("select count(id) from orders where status = #{status} and order_time between #{begin} and #{end}")
    Integer countByStatusAndMap(Map map);

    @Select("select sum(amount) from orders where status = #{status} and order_time between #{begin} and #{end}")
    Double sumByMap(Map map);
}