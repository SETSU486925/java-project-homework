package com.sky;

import java.lang.annotation.*;

// 作用在类上
@Target(ElementType.TYPE)
// 运行时保留
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface EnableCaching {

}
