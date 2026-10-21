package com.sky.controller.user;

import com.sky.dto.ShoppingCartDTO;
import com.sky.entity.ShoppingCart;
import com.sky.result.Result;
import com.sky.service.ShoppingCartService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 购物车相关接口（用户端）
 */
@RestController("userShoppingCartController")
@RequestMapping("/user/shoppingCart")
@Slf4j
@Api(tags = "购物车相关接口")
public class ShoppingCartController {

	@Autowired
	private ShoppingCartService shoppingCartService;

	/**
	 * 添加购物车
	 *
	 * @param shoppingCartDTO 购物车DTO
	 * @return Result
	 */
	@PostMapping("/add")
	@ApiOperation("添加购物车")
	public Result add(@RequestBody ShoppingCartDTO shoppingCartDTO) {
		log.info("添加购物车：{}", shoppingCartDTO);
		shoppingCartService.addShoppingCart(shoppingCartDTO);
		return Result.success();
	}

	/**
	 * 减少购物车商品
	 *
	 * @param shoppingCartDTO 购物车DTO
	 * @return Result
	 */
	@PostMapping("/sub")
	@ApiOperation("减少购物车商品")
	public Result sub(@RequestBody ShoppingCartDTO shoppingCartDTO) {
		log.info("减少购物车商品：{}", shoppingCartDTO);
		shoppingCartService.subShoppingCart(shoppingCartDTO);
		return Result.success();
	}

	/**
	 * 获取购物车列表
	 *
	 * @return Result<List<ShoppingCart>>
	 */
	@GetMapping("/list")
	@ApiOperation("获取购物车列表")
	public Result<List<ShoppingCart>> list() {
		log.info("获取购物车列表");
		List<ShoppingCart> list = shoppingCartService.showShoppingCart();
		return Result.success(list);
	}

	/**
	 * 清空购物车
	 *
	 * @return Result
	 */
	@DeleteMapping("/clean")
	@ApiOperation("清空购物车")
	public Result clean() {
		log.info("清空购物车");
		shoppingCartService.cleanShoppingCart();
		return Result.success();
	}
}
