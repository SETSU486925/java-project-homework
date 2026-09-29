package com.sky.service;

import com.sky.dto.SetmealDTO;
import com.sky.dto.SetmealPageQueryDTO;
import com.sky.entity.Setmeal;
import com.sky.result.PageResult;
import com.sky.vo.DishItemVO;
import com.sky.vo.SetmealVO;

import java.util.List;

/**
 * 套餐服务接口
 */
public interface SetmealService {

	/**
	 * 新增套餐（同时保存套餐菜品关系）
	 * 
	 * @param setmealDTO 套餐数据传输对象
	 */
	void saveWithDish(SetmealDTO setmealDTO);

	/**
	 * 套餐分页查询
	 * 
	 * @param setmealPageQueryDTO 分页查询条件
	 * @return 
	 */
	PageResult pageQuery(SetmealPageQueryDTO setmealPageQueryDTO);

	/**
	 * 批量删除套餐 业务规则：起售中的套餐不能删除
	 * 
	 * @param ids 套餐id列表
	 */
	void deleteBatch(List<Long> ids);

	/**
	 * 根据id查询套餐（用于回显修改页面）
	 * 
	 * @param id 套餐id
	 * @return 
	 */
	SetmealVO getByIdWithDish(Long id);

	/**
	 * 修改套餐（同时更新套餐菜品关系）
	 * 
	 * @param setmealDTO 套餐数据传输对象
	 */
	void updateWithDish(SetmealDTO setmealDTO);

	/**
	 * 套餐起售停售
	 * 
	 * @param status 状态 0-停售 1-起售
	 * @param id     套餐id
	 */
	void startOrStop(Integer status, Long id);
	
	/**
	 * 根据条件查询套餐
	 *
	 * @param setmeal 套餐对象
	 * @return List<Setmeal>
	 */
	List<Setmeal> list(Setmeal setmeal);

	/**
	 * 根据套餐ID查询菜品列表
	 *
	 * @param id 套餐ID
	 * @return List<DishItemVO>
	 */
	List<DishItemVO> getDishItemById(Long id);
}
