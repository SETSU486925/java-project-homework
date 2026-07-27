package com.lzj.admin.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.lzj.admin.dto.TreeDto;
import com.lzj.admin.pojo.GoodsType;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 商品类别 Mapper
 *
 * @author TianTian
 */
public interface GoodsTypeMapper extends BaseMapper<GoodsType> {

    /**
     * 查询商品分类
     */
    List<TreeDto> queryGoodsTypeTree();

    List<GoodsType> queryByParentId(@Param("pId") Integer pId);

}
