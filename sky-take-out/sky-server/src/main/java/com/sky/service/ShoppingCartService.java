package com.sky.service;

import com.sky.dto.ShoppingCartDTO;
import com.sky.entity.ShoppingCart;

import java.util.List;

/**
 * 购物车服务层接口
 */
public interface ShoppingCartService {

	/**
	 * 添加购物车
	 *
	 * @param shoppingCartDTO 购物车DTO
	 */
	void addShoppingCart(ShoppingCartDTO shoppingCartDTO);

	/**
	 * 减少购物车商品
	 *
	 * @param shoppingCartDTO 购物车DTO
	 */
	void subShoppingCart(ShoppingCartDTO shoppingCartDTO);

	/**
	 * 获取购物车列表
	 *
	 * @return List<ShoppingCart>
	 */
	List<ShoppingCart> showShoppingCart();

	/**
	 * 清空购物车
	 */
	void cleanShoppingCart();
}