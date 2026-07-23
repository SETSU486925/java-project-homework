package com.lzj.admin.service;

import com.lzj.admin.pojo.OverflowList;
import com.baomidou.mybatisplus.extension.service.IService;
import com.lzj.admin.pojo.OverflowListGoods;
import com.lzj.admin.query.OverFlowListQuery;

import java.util.List;
import java.util.Map;

/**
 * 报溢单服务类
 * @author TianTian
 * @date 2022/1/21 13:43
 */
public interface OverflowListService extends IService<OverflowList> {

    String getOverflowNumber();

    void saveOverflowList(OverflowList overflowList, List<OverflowListGoods> plgList);

    Map<String, Object> overFlowList(OverFlowListQuery overFlowListQuery);

    void deleteoverflowList(Integer id);
}
