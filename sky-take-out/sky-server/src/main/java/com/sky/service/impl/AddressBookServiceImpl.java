package com.sky.service.impl;

import com.sky.context.BaseContext;
import com.sky.entity.AddressBook;
import com.sky.mapper.AddressBookMapper;
import com.sky.service.AddressBookService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 地址簿服务实现类
 */
@Service
@Slf4j
public class AddressBookServiceImpl implements AddressBookService {

	@Autowired
	private AddressBookMapper addressBookMapper;

	/**
	 * 查询当前登录用户的所有地址信息
	 *
	 * @param userId 用户ID
	 * @return List<AddressBook>
	 */
	@Override
	public List<AddressBook> list(Long userId) {
		return addressBookMapper.list(userId);
	}

	/**
	 * 新增地址
	 *
	 * @param addressBook 地址对象
	 */
	@Override
	public void save(AddressBook addressBook) {
		// 获取当前登录用户ID
		Long userId = BaseContext.getCurrentId();
		addressBook.setUserId(userId);

		// 如果设置为默认地址，需要将其他地址设为非默认
		if (addressBook.getIsDefault() != null && addressBook.getIsDefault() == 1) {
			addressBookMapper.updateIsDefaultByUserId(userId);
		}

		addressBookMapper.insert(addressBook);
	}

	/**
	 * 根据id查询地址
	 *
	 * @param id 地址ID
	 * @return AddressBook
	 */
	@Override
	public AddressBook getById(Long id) {
		return addressBookMapper.getById(id);
	}

	/**
	 * 根据id修改地址
	 *
	 * @param addressBook 地址对象
	 */
	@Override
	public void update(AddressBook addressBook) {
		// 如果设置为默认地址，需要将其他地址设为非默认
		if (addressBook.getIsDefault() != null && addressBook.getIsDefault() == 1) {
			addressBookMapper.updateIsDefaultByUserId(BaseContext.getCurrentId());
		}
		addressBookMapper.update(addressBook);
	}

	/**
	 * 根据id删除地址
	 *
	 * @param id 地址ID
	 */
	@Override
	public void deleteById(Long id) {
		addressBookMapper.deleteById(id);
	}

	/**
	 * 查询当前登录用户的默认地址
	 *
	 * @param userId 用户ID
	 * @return AddressBook
	 */
	@Override
	public AddressBook getDefaultAddress(Long userId) {
		return addressBookMapper.getDefaultAddress(userId);
	}

	/**
	 * 设置默认地址
	 *
	 * @param addressBook 地址对象
	 */
	@Override
	@Transactional
	public void setDefaultAddress(AddressBook addressBook) {
		// 1. 将当前用户的所有地址设为非默认
		addressBookMapper.updateIsDefaultByUserId(BaseContext.getCurrentId());

		// 2. 将当前地址设为默认
		addressBook.setIsDefault(1);
		addressBookMapper.update(addressBook);
	}
}
