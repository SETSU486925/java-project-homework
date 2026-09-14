package com.sky.service;

import com.sky.dto.ShoppingCartDTO;
import com.sky.pojo.ShoppingCart;
import java.util.List;

public interface ShoppingCartService {

    List<ShoppingCart> showShoppingCart();

    void clearShoppingCart();

    void deleteShoppingCartById(ShoppingCartDTO shoppingCartDTO);
}