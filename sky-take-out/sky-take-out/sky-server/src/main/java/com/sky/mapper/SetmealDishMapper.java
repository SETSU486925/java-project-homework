package com.sky.mapper;

import com.sky.entity.SetmealDish;
import com.sky.vo.DishItemVO;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;

/**
 * 套餐菜品关系Mapper接口
 */
@Mapper
public interface SetmealDishMapper {

	/**
	 * 根据菜品id查询关联的套餐id
	 * 
	 * @param dishIds 菜品id列表
	 * @return 
	 */
	List<Long> getSetmealIdsByDishIds(List<Long> dishIds);

	/**
	 * 批量插入套餐菜品关系
	 * 
	 * @param setmealDishes 套餐菜品关系列表
	 */
	void insertBatch(List<SetmealDish> setmealDishes);

	/**
	 * 根据套餐id删除关联的菜品
	 * 
	 * @param setmealId 套餐id
	 */
	@Delete("delete from setmeal_dish where setmeal_id = #{setmealId}")
	void deleteBySetmealId(Long setmealId);

	/**
	 * 根据套餐id查询关联的菜品
	 * 
	 * @param setmealId 套餐id
	 * @return 
	 */
	@Select("select * from setmeal_dish where setmeal_id = #{setmealId}")
	List<SetmealDish> getBySetmealId(Long setmealId);
	
	/**
	 * 根据套餐ID查询菜品列表
	 *
	 * @param setmealId 套餐ID
	 * @return List<DishItemVO>
	 */
	List<DishItemVO> getDishItemBySetmealId(Long setmealId);

}