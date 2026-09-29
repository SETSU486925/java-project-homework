package com.sky.mapper;

import com.sky.entity.Orders;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 订单数据层接口
 */
@Mapper
public interface OrderMapper {

	/**
	 * 插入订单数据
	 *
	 * @param orders 订单对象
	 */
	void insert(Orders orders);

	/**
	 * 根据id查询订单
	 *
	 * @param id 订单id
	 * @return Orders
	 */
	@Select("select * from orders where id = #{id}")
	Orders getById(Long id);

	/**
	 * 根据订单状态和下单时间查询订单
	 *
	 * @param status    订单状态
	 * @param orderTime 下单时间
	 * @return List<Orders>
	 */
	@Select("select * from orders where status = #{status} and order_time < #{orderTime}")
	List<Orders> getByStatusAndOrdertimeLT(Integer status, LocalDateTime orderTime);

	/**
	 * 更新订单信息
	 *
	 * @param orders 订单对象
	 */
	void update(Orders orders);
	
	/**
	 * 根据订单号查询订单
	 *
	 * @param orderNumber 订单号
	 * @return Orders
	 */
	@Select("select * from orders where order_num = #{orderNumber}")
	Orders getByNumber(String orderNumber);

}
