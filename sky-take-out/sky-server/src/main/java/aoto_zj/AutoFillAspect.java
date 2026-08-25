package aoto_zj;




import com.sky.constant.AutoFillConstant;
import com.sky.context.BaseContext;
import com.sky.enumeration.OperationType;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.Before;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.stereotype.Component;
import java.lang.reflect.Method;
import java.time.LocalDateTime;

@Aspect
@Component
@Slf4j
public class AutoFillAspect {

    @Pointcut("execution(* com.sky.mapper.*.*(..)) && @annotation(com.sky.annotation.AutoFill)")
    public void autoFillPointCut(){}
    @Before("autoFillPointCut()")
    public void autoFill(JoinPoint joinPoint){
        log.info("开始公共字段自动填充...");

        //1. 获取被拦截方法上注解的操作类型 INSERT / UPDATE
        MethodSignature signature = (MethodSignature) joinPoint.getSignature();
        AutoFill autoFill = signature.getMethod().getAnnotation(AutoFill.class);
        OperationType value = autoFill.value();

        //2. 获取mapper方法的实体参数对象
        Object[] args = joinPoint.getArgs();
        if(args == null || args.length == 0){
            return;
        }
        Object arg = args[0];

        LocalDateTime now = LocalDateTime.now();
        Long currentId = BaseContext.getCurrentId();

        //3. 判断操作类型，通过反射赋值
        if(value == OperationType.INSERT){
            try {
                //通过反射获取set方法
                Method setCreateTime = arg.getClass().getDeclaredMethod(AutoFillConstant.SET_CREATE_TIME, LocalDateTime.class);
                Method setCreateUser = arg.getClass().getDeclaredMethod(AutoFillConstant.SET_CREATE_USER, Long.class);
                Method setUpdateTime = arg.getClass().getDeclaredMethod(AutoFillConstant.SET_UPDATE_TIME, LocalDateTime.class);
                Method setUpdateUser = arg.getClass().getDeclaredMethod(AutoFillConstant.SET_UPDATE_USER, Long.class);

                //反射调用set方法赋值
                setCreateTime.invoke(arg,now);
                setCreateUser.invoke(arg,currentId);
                setUpdateTime.invoke(arg,now);
                setUpdateUser.invoke(arg,currentId);

            } catch (Exception e) {
                e.printStackTrace();
            }
        }else if (value == OperationType.UPDATE){
 
            try {
                Method setUpdateTime = arg.getClass().getDeclaredMethod(AutoFillConstant.SET_UPDATE_TIME, LocalDateTime.class);
                Method setUpdateUser = arg.getClass().getDeclaredMethod(AutoFillConstant.SET_UPDATE_USER, Long.class);

                setUpdateTime.invoke(arg,now);
                setUpdateUser.invoke(arg,currentId);

            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
