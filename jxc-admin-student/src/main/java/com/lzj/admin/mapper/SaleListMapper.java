package com.lzj.admin.mapper;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.lzj.admin.model.CountResultModel;
import com.lzj.admin.pojo.SaleList;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.lzj.admin.query.SaleListQuery;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

/**
 * <p>
 * 销售单表 Mapper 接口
 * </p>
 *
 * @author 老李
 */
public interface SaleListMapper extends BaseMapper<SaleList> {

    String  getNextSaleNumber();

    IPage<SaleList>  saleList(IPage<SaleList> page,@Param("saleListQuery") SaleListQuery saleListQuery);

    Long countSaleTotal(@Param("saleListQuery") SaleListQuery saleListQuery);

    List<CountResultModel> saleListQueryList(@Param("saleListQuery") SaleListQuery saleListQuery);

    List<Map<String, Object>>  countDaySale(@Param("begin") String begin, @Param("end") String end);

}
