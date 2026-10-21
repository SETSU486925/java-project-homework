package com.sky.controller.user;

import com.sky.constant.JwtClaimsConstant;
import com.sky.dto.UserLoginDTO;
import com.sky.entity.User;
import com.sky.properties.JwtProperties;
import com.sky.result.Result;
import com.sky.service.UserService;
import com.sky.utils.JwtUtil;
import com.sky.vo.UserLoginVO;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

/**
 * 用户相关接口
 */
@RestController("userController")
@RequestMapping("/user/user")
@Slf4j
@Api(tags = "用户相关接口")
public class UserController {

	@Autowired
	private UserService userService;

	@Autowired
	private JwtProperties jwtProperties;

	/**
	 * 微信登录
	 *
	 * @param userLoginDTO 微信登录对象
	 * @return Result<UserLoginVO>
	 */
	@ApiOperation("微信登录")
	@PostMapping("/login")
	public Result<UserLoginVO> userLogin(@RequestBody UserLoginDTO userLoginDTO) {
		log.info("用户传递的数据：{}", userLoginDTO);

		// 调用微信登录服务
		User user = userService.wxLogin(userLoginDTO);

		Map<String, Object> map = new HashMap<>();
		map.put(JwtClaimsConstant.USER_ID, user.getId());
		String token = JwtUtil.createJWT(jwtProperties.getUserSecretKey(), jwtProperties.getUserTtl(), map);

		// 创建返回对象并进行赋值
		UserLoginVO userLoginVO = new UserLoginVO();
		userLoginVO.setToken(token);
		userLoginVO.setId(user.getId());
		userLoginVO.setOpenid(user.getOpenid());

		return Result.success(userLoginVO);
	}
}