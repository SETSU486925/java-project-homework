package com.sky.mapper;

import com.github.pagehelper.Page;
import com.sky.dto.DishPageQueryDTO;
import com.sky.entity.Dish;
import com.sky.vo.DishVO;
import org.apache.ibatis.annotations.Mapper;
import java.util.List;

@Mapper
public interface DishMapper {
    void insert(Dish dish);
    Page<DishVO> pageQuery(DishPageQueryDTO dishPageQueryDTO);
    Dish getById(Long id);
    void update(Dish dish);
    void deleteByIds(List<Long> ids);
}
