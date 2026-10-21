package com.sky.service;

import com.sky.dto.OrdersPaymentDTO;
import com.sky.dto.OrdersSubmitDTO;
import com.sky.vo.OrderPaymentVO;
import com.sky.vo.OrderSubmitVO;

/**
 * 订单服务层接口
 */
public interface OrderService {

	/**
	 * 用户下单
	 *
	 * @param ordersSubmitDTO 下单DTO
	 * @return OrderSubmitVO
	 */
	OrderSubmitVO submitOrder(OrdersSubmitDTO ordersSubmitDTO);

	/**
	 * 用户催单
	 *
	 * @param id 订单id
	 */
	void reminder(Long id);

	/**
	 * 订单支付
	 * @param ordersPaymentDTO 支付DTO
	 * @return OrderPaymentVO
	 */
	OrderPaymentVO payment(OrdersPaymentDTO ordersPaymentDTO);

}
