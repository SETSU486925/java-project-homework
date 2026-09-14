package com.sky.mapper;

import com.sky.entity.ShoppingCart;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Update;

import java.util.List;

public interface ShoppingCartMapper {

    /**
     * 根据条件查询购物车
     * @param shoppingCart
     * @return
     */
    List<ShoppingCart> selectShoppingCartByUserId(ShoppingCart shoppingCart);

    /**
     * 更新购物车商品数量
     * @param shoppingCart
     */
    @Update("update shopping_cart set number = #{number} where id = #{id}")
    void update(ShoppingCart shoppingCart);

    /**
     * 插入购物车数据
     * @param shoppingCart
     */
    @Insert("insert into shopping_cart (name, user_id, dish_id, setmeal_id, dish_flavor, number, image, create_time) " +
            "values (#{name},#{userId},#{dishId},#{setmealId},#{dishFlavor},#{number},#{image},#{createTime})")
    void insert(ShoppingCart shoppingCart);
}