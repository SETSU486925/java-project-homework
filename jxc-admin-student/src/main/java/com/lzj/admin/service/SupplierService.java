package com.lzj.admin.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.lzj.admin.pojo.Supplier;
import com.lzj.admin.query.SupplierQuery;

import java.util.Map;

public interface SupplierService extends IService<Supplier> {

    /**
     * 分页查询
     */
    Map<String,Object> supplierList(SupplierQuery supplierQuery);

    /**
     * 新增供应商
     */
    void saveSupplier(Supplier supplier);

    /**
     * 修改供应商
     */
    void updateSupplier(Supplier supplier);

    /**
     * 根据ID查询
     */
    Supplier queryById(Integer id);

    /**
     * 删除供应商
     */
    void deleteSupplier(Integer[] ids);

}
