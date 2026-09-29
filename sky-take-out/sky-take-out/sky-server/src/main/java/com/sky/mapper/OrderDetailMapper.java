package com.sky.mapper;

import com.sky.entity.OrderDetail;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

/**
 * 订单明细数据层接口
 */
@Mapper
public interface OrderDetailMapper {

	/**
	 * 批量插入订单明细数据
	 *
	 * @param orderDetails 订单明细列表
	 */
	void insertBatch(List<OrderDetail> orderDetails);

	/**
	 * 根据订单id查询订单明细
	 *
	 * @param orderId 订单id
	 * @return List<OrderDetail>
	 */
	List<OrderDetail> getByOrderId(Long orderId);
}
