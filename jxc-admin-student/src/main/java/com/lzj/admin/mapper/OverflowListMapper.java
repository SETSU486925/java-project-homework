package com.lzj.admin.mapper;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.lzj.admin.pojo.OverflowList;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.lzj.admin.query.OverFlowListQuery;
import org.apache.ibatis.annotations.Param;

/**
 * 报溢单 Mapper接口
 * @author TianTian
 * @date 2022/1/21 14:04
 */
public interface OverflowListMapper extends BaseMapper<OverflowList> {

    String  getOverflowNumber();

    IPage<OverflowList> overFlowList(IPage<OverflowList> page,@Param("overFlowListQuery") OverFlowListQuery overFlowListQuery);
}
