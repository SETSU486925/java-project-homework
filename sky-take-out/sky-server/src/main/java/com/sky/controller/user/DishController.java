package com.sky.controller.user;

import com.sky.constant.StatusConstant;
import com.sky.dto.DishDTO;
import com.sky.dto.DishPageQueryDTO;
import com.sky.entity.Dish;
import com.sky.result.PageResult;
import com.sky.result.Result;
import com.sky.service.DishService;
import com.sky.vo.DishVO;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 菜品控制类（用户端）
 */
@RestController("userDishController")
@Slf4j // 日志文件
@Api(tags = "菜品相关接口")
@RequestMapping("/user/dish")
public class DishController {

	@Autowired
	private DishService dishService;

	/**
	 * 新增菜品
	 * 
	 * @param dishDTO
	 * @return
	 */
	@PostMapping
	@ApiOperation("新增菜品")
	@CacheEvict(cacheNames = "dishCache", key = "#dishDTO.categoryId")
	public Result<String> save(@RequestBody DishDTO dishDTO) {
		// 记录日志，方便调试
		log.info("新增菜品：｛｝", dishDTO);

		// 调用service层进行新增菜品
		dishService.saveWithFlavor(dishDTO);

		// 返回成功结果
		return Result.success();
	}

	/**
	 * 菜品分页查询
	 * 
	 * @param dishPageQueryDTO
	 * @return 分页结果
	 */
	@GetMapping("/page")
	@ApiOperation("菜品分页查询")
	public Result<PageResult> page(DishPageQueryDTO dishPageQueryDTO) {
		// 记录日志，方便调试
		log.info("菜品分页查询：{}", dishPageQueryDTO);

		// 调用service层进行分页查询
		PageResult pageResult = dishService.pageQuery(dishPageQueryDTO);

		// 返回成功结果
		return Result.success(pageResult);
	}

	/**
	 * 根据分类id查询菜品（用于套餐添加菜品弹窗）
	 * 
	 */
	@GetMapping("/list")
	@ApiOperation("根据分类id查询菜品")
	@Cacheable(cacheNames = "dishCache", key = "#categoryId")
	public Result<List<DishVO>> list(Long categoryId) {
		// 记录日志，方便调试
		log.info("根据分类id查询菜品：{}", categoryId);

		// 调用service层进行根据id查询菜品
		List<DishVO> list = dishService.list(categoryId);

		// 返回数据
		return Result.success(list);
	}

	/**
	 * 根据id查询菜品（回显修改页面）
	 * 
	 * @param id
	 * @return
	 */
	@GetMapping("/{id}")
	@ApiOperation("根据id查询菜品")
	public Result<DishVO> getById(@PathVariable Long id) {
		// 记录日志，方便调试
		log.info("根据id查询菜品：{}", id);

		// 调用service层进行根据id查询菜品
		DishVO dishVO = dishService.getByIdWithFlavor(id);

		// 返回成功结果
		return Result.success(dishVO);
	}

	/**
	 * 修改菜品
	 * 
	 * @param dishDTO
	 * @return
	 */
	@PutMapping
	@ApiOperation("修改菜品")
	@CacheEvict(cacheNames = "dishCache", allEntries = true)
	public Result update(@RequestBody DishDTO dishDTO) {
		// 记录日志，方便调试
		log.info("修改菜品：{}", dishDTO);

		// 调用service层进行修改菜品
		dishService.updateWithFlavor(dishDTO);

		// 返回成功结果
		return Result.success();
	}

	/**
	 * 菜品起售停售
	 * 
	 * @param status
	 * @param id
	 * @return
	 */
	@PostMapping("/status/{status}")
	@ApiOperation("菜品起售停售")
	@CacheEvict(cacheNames = "dishCache", allEntries = true)
	public Result startOrStop(@PathVariable Integer status, @RequestParam Long id) {
		// 记录日志，方便调试
		log.info("菜品起售停售：{}, {}", status, id);

		// 调用service层进行菜品起售停售
		dishService.startOrStop(status, id);

		// 返回成功结果
		return Result.success();
	}

	/**
	 * 批量删除菜品
	 * 
	 * @param ids
	 * @return
	 */
	@DeleteMapping
	@ApiOperation("批量删除菜品")
	@CacheEvict(cacheNames = "dishCache", allEntries = true)
	public Result delete(@RequestParam List<Long> ids) {
		// 记录日志，方便调试
		log.info("批量删除菜品：{}", ids);

		// 调用service层进行批量删除菜品
		dishService.deleteBatch(ids);

		// 返回成功结果
		return Result.success();
	}
}