package com.lzj.admin.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.lzj.admin.mapper.SupplierMapper;
import com.lzj.admin.pojo.Supplier;
import com.lzj.admin.query.SupplierQuery;
import com.lzj.admin.service.SupplierService;
import com.lzj.admin.utils.AssertUtil;
import com.lzj.admin.utils.PageResultUtil;
import com.lzj.admin.utils.StringUtil;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * 供应商服务类
 * @author TianTian
 * @date 2022/1/19 14:43
 */

@Override
public void saveSupplier(Supplier supplier) {

    AssertUtil.isTrue(supplier == null, "供应商不能为空");
    AssertUtil.isTrue(StringUtil.isEmpty(supplier.getName()), "供应商名称不能为空");

    QueryWrapper<Supplier> wrapper = new QueryWrapper<>();
    wrapper.eq("name", supplier.getName());

    Supplier temp = getOne(wrapper);

    AssertUtil.isTrue(temp != null, "供应商已存在");

    supplier.setIsDel(0);

    save(supplier);
}

@Override
public void updateSupplier(Supplier supplier) {

    AssertUtil.isTrue(supplier == null, "参数错误");
    AssertUtil.isTrue(supplier.getId() == null, "ID不能为空");

    Supplier dbSupplier = getById(supplier.getId());

    AssertUtil.isTrue(dbSupplier == null, "供应商不存在");

    updateById(supplier);
}

@Override
public Supplier queryById(Integer id) {

    return getById(id);
}

@Override
public void deleteSupplier(Integer[] ids) {

    if (ids == null || ids.length == 0) {
        return;
    }

    for (Integer id : ids) {

        Supplier supplier = getById(id);

        if (supplier != null) {

            supplier.setIsDel(1);

            updateById(supplier);
        }

    }

}
