package com.sky.mapper;

import com.sky.entity.DishFlavor;
import org.apache.ibatis.annotations.Mapper;
import java.util.List;

@Mapper
public interface DishFlavorMapper {
    void insertBatch(List<DishFlavor> flavorList);
    List<DishFlavor> getByDishId(Long dishId);
    void deleteByDishId(Long dishId);
    void deleteByDishIds(List<Long> dishIds);
}
