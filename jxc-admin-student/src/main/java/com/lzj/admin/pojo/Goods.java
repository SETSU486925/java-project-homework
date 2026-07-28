package com.lzj.admin.pojo;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import java.io.Serializable;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 商品表
 * @author TianTian
 * @date 2022/1/18 9:55
 */
@Data
@EqualsAndHashCode(callSuper = false)
@TableName("T_GOODS")
@ApiModel(value="Goods对象", description="商品表")
public class Goods implements Serializable {
    private static final long serialVersionUID = 1L;

    @ApiModelProperty(value = "主键")
    @TableId(value = "id", type = IdType.INPUT)
    private Integer id;

    @ApiModelProperty(value = "商品编码")
    private String code;

    @ApiModelProperty(value = "库存数量")
    private Integer inventoryQuantity;

    @ApiModelProperty(value = "库存下限")
    private Integer minNum;

    @ApiModelProperty(value = "商品型号")
    private String model;

    @ApiModelProperty(value = "商品名称")
    private String name;

    @ApiModelProperty(value = "生产厂商")
    private String producer;

    @ApiModelProperty(value = "采购价格")
    private Float purchasingPrice;

    @ApiModelProperty(value = "备注")
    private String remarks;

    @ApiModelProperty(value = "出售价格")
    private Float sellingPrice;

    @ApiModelProperty(value = "商品单位编码")
    private String unit;

    @ApiModelProperty(value = "商品分类ID")
    private Integer typeId;

    @ApiModelProperty(value = "商品状态")
    private Integer state;

    @ApiModelProperty(value = "上次采购价")
    private Float lastPurchasingPrice;

    @ApiModelProperty(value = "是否删除 0未删")
    private Integer isDel;

    // 非数据库字段：页面展示单位名称
    @TableField(exist = false)
    @ApiModelProperty(value = "页面展示单位名")
    private String unitName;

    // 非数据库字段：页面展示分类名称
    @TableField(exist = false)
    @ApiModelProperty(value = "页面展示分类名")
    private String typeName;

    @TableField(exist = false)
    private Integer saleTotal;
}
