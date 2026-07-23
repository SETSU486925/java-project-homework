package com.lzj.admin.utils;


import com.lzj.admin.exceptions.ParamsException;
/**
 * 断言操作，如果为真，会抛出异常，被全局异常捕捉，调用写好的RespBean向前端抛出msg
 * @author TianTian
 * @date 2022/1/8 15:18
 */
public class AssertUtil {


    public  static void isTrue(Boolean flag,String msg){
        if(flag){
            throw  new ParamsException(msg);
        }
    }


}
