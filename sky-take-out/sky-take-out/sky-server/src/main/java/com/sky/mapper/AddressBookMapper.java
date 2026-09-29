package com.sky.mapper;

import com.sky.entity.AddressBook;
import org.apache.ibatis.annotations.*;

import java.util.List;

/**
 * 地址簿数据层接口
 */
@Mapper
public interface AddressBookMapper {

	/**
	 * 查询当前登录用户的所有地址信息
	 *
	 * @param userId 用户ID
	 * @return List<AddressBook>
	 */
	@Select("select * from address_book where user_id = #{userId} order by is_default desc, id desc")
	List<AddressBook> list(Long userId);

	/**
	 * 新增地址
	 *
	 * @param addressBook 地址对象
	 */
	void insert(AddressBook addressBook);

	/**
	 * 根据id查询地址
	 *
	 * @param id 地址ID
	 * @return AddressBook
	 */
	@Select("select * from address_book where id = #{id}")
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
	@Delete("delete from address_book where id = #{id}")
	void deleteById(Long id);

	/**
	 * 查询当前登录用户的默认地址
	 *
	 * @param userId 用户ID
	 * @return AddressBook
	 */
	@Select("select * from address_book where user_id = #{userId} and is_default = 1")
	AddressBook getDefaultAddress(Long userId);

	/**
	 * 将当前用户的所有地址设为非默认
	 *
	 * @param userId 用户ID
	 */
	@Update("update address_book set is_default = 0 where user_id = #{userId}")
	void updateIsDefaultByUserId(Long userId);
}
