package com.sky.controller.user;

import com.sky.context.BaseContext;
import com.sky.entity.AddressBook;
import com.sky.result.Result;
import com.sky.service.AddressBookService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 地址簿相关接口（用户端）
 */
@RestController("userAddressBookController")
@RequestMapping("/user/addressBook")
@Slf4j
@Api(tags = "地址簿相关接口")
public class AddressBookController {

	@Autowired
	private AddressBookService addressBookService;

	/**
	 * 查询当前登录用户的所有地址信息
	 *
	 * @return Result<List<AddressBook>>
	 */
	@GetMapping("/list")
	@ApiOperation("查询当前登录用户的所有地址信息")
	public Result<List<AddressBook>> list() {
		Long userId = BaseContext.getCurrentId();
		log.info("查询当前登录用户的所有地址信息：{}", userId);
		List<AddressBook> list = addressBookService.list(userId);
		return Result.success(list);
	}

	/**
	 * 新增地址
	 *
	 * @param addressBook 地址对象
	 * @return Result
	 */
	@PostMapping
	@ApiOperation("新增地址")
	public Result save(@RequestBody AddressBook addressBook) {
		log.info("新增地址：{}", addressBook);
		addressBookService.save(addressBook);
		return Result.success();
	}

	/**
	 * 根据id查询地址
	 *
	 * @param id 地址ID
	 * @return Result<AddressBook>
	 */
	@GetMapping("/{id}")
	@ApiOperation("根据id查询地址")
	public Result<AddressBook> getById(@PathVariable Long id) {
		log.info("根据id查询地址：{}", id);
		AddressBook addressBook = addressBookService.getById(id);
		return Result.success(addressBook);
	}

	/**
	 * 根据id修改地址
	 *
	 * @param addressBook 地址对象
	 * @return Result
	 */
	@PutMapping
	@ApiOperation("根据id修改地址")
	public Result update(@RequestBody AddressBook addressBook) {
		log.info("根据id修改地址：{}", addressBook);
		addressBookService.update(addressBook);
		return Result.success();
	}

	/**
	 * 根据id删除地址
	 *
	 * @param id 地址ID
	 * @return Result
	 */
	@DeleteMapping
	@ApiOperation("根据id删除地址")
	public Result deleteById(@RequestParam Long id) {
		log.info("根据id删除地址：{}", id);
		addressBookService.deleteById(id);
		return Result.success();
	}

	/**
	 * 查询当前登录用户的默认地址
	 *
	 * @return Result<AddressBook>
	 */
	@GetMapping("/default")
	@ApiOperation("查询当前登录用户的默认地址")
	public Result<AddressBook> getDefaultAddress() {
		Long userId = BaseContext.getCurrentId();
		log.info("查询当前登录用户的默认地址：{}", userId);
		AddressBook addressBook = addressBookService.getDefaultAddress(userId);
		return Result.success(addressBook);
	}

	/**
	 * 设置默认地址
	 *
	 * @param addressBook 地址对象
	 * @return Result
	 */
	@PutMapping("/default")
	@ApiOperation("设置默认地址")
	public Result setDefaultAddress(@RequestBody AddressBook addressBook) {
		log.info("设置默认地址：{}", addressBook);
		addressBookService.setDefaultAddress(addressBook);
		return Result.success();
	}
}
