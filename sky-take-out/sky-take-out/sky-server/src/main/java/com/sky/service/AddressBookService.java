package com.sky.service;

import com.sky.entity.AddressBook;

import java.util.List;

/**
 * 地址簿服务层接口
 */
public interface AddressBookService {

	/**
	 * 查询当前登录用户的所有地址信息
	 *
	 * @param userId 用户ID
	 * @return List<AddressBook>
	 */
	List<AddressBook> list(Long userId);

	/**
	 * 新增地址
	 *
	 * @param addressBook 地址对象
	 */
	void save(AddressBook addressBook);

	/**
	 * 根据id查询地址
	 *
	 * @param id 地址ID
	 * @return AddressBook
	 */
	AddressBook getById(Long id);

	/**
	 * 根据id修改地址
	 *
	 * @param addressBook 地址对象
	 */
	void update(AddressBook addressBook);

	/**
	 * 根据id删除地址
	 *
	 * @param id 地址ID
	 */
	void deleteById(Long id);

	/**
	 * 查询当前登录用户的默认地址
	 *
	 * @param userId 用户ID
	 * @return AddressBook
	 */
	AddressBook getDefaultAddress(Long userId);

	/**
	 * 设置默认地址
	 *
	 * @param addressBook 地址对象
	 */
	void setDefaultAddress(AddressBook addressBook);
}
