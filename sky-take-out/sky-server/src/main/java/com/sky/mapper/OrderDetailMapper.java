package com.sky.mapper;

import com.sky.entity.OrderDetail;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface OrderDetailMapper {

    void insertBatch(List<OrderDetail> orderDetails);

    List<OrderDetail> getByOrderId(Long orderId);

    List<Map> getSalesTop10(Map map);
}