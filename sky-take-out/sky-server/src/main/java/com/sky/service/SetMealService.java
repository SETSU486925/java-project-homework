package com.sky.service;

import com.sky.dto.SetmealDTO;
import java.util.List;

public interface SetMealService {

    /**
     * 修改套餐内容
     * @param setmealDTO
     */
    void updateSetMeal(SetmealDTO setmealDTO);

    /**
     * 套餐起售停售
     * @param status
     * @param id
     */
    void startOrStop(Integer status, Long id);

    /**
     * 批量删除套餐
     * @param ids
     */
    void deleteSetMealBatch(List<Long> ids);

    /**
     * 根据分类ID获取套餐信息
     * @param categoryId
     * @return
     */
    List<Setmeal> selectSetMealByCategoryId(Long categoryId);
}
