package com.lzj.admin.query;

import lombok.Data;

/**
 * 乐字节  踏实教育 用心服务
 *
 * @author 乐字节--老李
 * @version 1.0
 */
@Data
public class CustomerReturnListGoodsQuery extends BaseQuery{
    private Integer customerReturnListId;

	public long getLimit() {
		// TODO Auto-generated method stub
		return 0;
	}

	public Object getCustomerReturnListId() {
		// TODO Auto-generated method stub
		return null;
	}

	public long getPage() {
		// TODO Auto-generated method stub
		return 0;
	}
}
