package com.lzj.admin.config.security;

import com.lzj.admin.config.ClassPathTldsLoader;
import com.lzj.admin.filter.CaptchaCodeFilter;
import com.lzj.admin.pojo.User;
import com.lzj.admin.service.RbacService;
import com.lzj.admin.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringBootConfiguration;
import org.springframework.boot.autoconfigure.condition.ConditionalOnMissingBean;
import org.springframework.context.annotation.Bean;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.builders.WebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.core.authority.AuthorityUtils;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.security.web.authentication.rememberme.JdbcTokenRepositoryImpl;
import org.springframework.security.web.authentication.rememberme.PersistentTokenRepository;

import javax.sql.DataSource;
import java.util.List;
import java.util.stream.Collectors;

/**
 * @author TianTian
 * @date 2022/1/7 15:13
 * 安全框架配置
 */
@SpringBootConfiguration
@EnableGlobalMethodSecurity(prePostEnabled = true)
public class SecurityConfig extends WebSecurityConfigurerAdapter {
    //注入所需的类
    @Autowired
    private UserService userService;

    @Autowired
    private JxcAuthenticationSuccessHandler authenticationSuccessHandler;

    @Autowired
    private JxcAuthenticationFailedHandler authenticationFailedHandler;

    @Autowired
    private JxcLogoutSuccessHandler jxcLogoutSuccessHandler;

    @Autowired
    private DataSource dataSource;
    @Autowired
    private CaptchaCodeFilter captchaCodeFilter;
    @Autowired
    private PersistentTokenRepository persistentTokenRepository;
    @Autowired
    private RbacService rbacService;


    /**
     * 配置静态资源路径
     * @param web
     * @throws Exception
     */
    @Override
    public void configure(WebSecurity web) throws Exception {
        web.ignoring().antMatchers(
                "/images/**",
                "/css/**",
                "/js/**",
                "/lib/**",
                "/error/**"
        );
    }

    /**
     * 安全框架主要设置
     * @param http
     * @throws Exception
     */
    @Override
    protected void configure(HttpSecurity http) throws Exception {

        //禁用csrf
        http.csrf().disable()
                //验证码过滤器
                .addFilterBefore(captchaCodeFilter,UsernamePasswordAuthenticationFilter.class)
                // 允许iframe 页面嵌套
                .headers().frameOptions().disable()
                .and()
                .formLogin()
                .usernameParameter("userName")
                .passwordParameter("password")
                .loginPage("/index")
                .loginProcessingUrl("/login")
                .successHandler(authenticationSuccessHandler)
                .failureHandler(authenticationFailedHandler)
                .and()
                .logout()
                .logoutUrl("/signout")
                .deleteCookies("JSESSIONID")
                .logoutSuccessHandler(jxcLogoutSuccessHandler)
                .and()
                .rememberMe()
                .rememberMeParameter("rememberMe")
                //保存在浏览器端的cookie的名称，如果不设置默认也是remember-me
                .rememberMeCookieName("remember-me-cookie")
                //设置token的有效期，即多长时间内可以免除重复登录，单位是秒。
                .tokenValiditySeconds(7  * 24 * 60 * 60)
                //自定义
                .tokenRepository(persistentTokenRepository())
                .and()
                .authorizeRequests().antMatchers("/index","/login","/image").permitAll()
                .anyRequest().authenticated();
    }

    /**
     * 创建一个Bean 创建密文格式
     * @return 返回密文格式
     */
    @Bean
    public PasswordEncoder encoder(){
        return new BCryptPasswordEncoder();
    }

    /**
     *对所查询到的用户信息进行封装
     * @return 一个用户信息的包装类
     */
    @Bean
    public UserDetailsService userDetailsService(){
        return new UserDetailsService() {
            @Override
            public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
                User userDetails = (User) userService.findForName(username);
                List<String> roleNames = rbacService.findRoleByUserName(username);
                List<String> ai = rbacService.findAuthoritiesByRoleName(roleNames);
                roleNames = roleNames.stream().map(role-> "ROLE_"+role).collect(Collectors.toList());
                ai.addAll(roleNames);
                userDetails.setAuthorities(AuthorityUtils.commaSeparatedStringToAuthorityList(String.join(",",ai)));
                return userDetails;
            }
        };
    }

    /**
     * 进行加密加密
     * @param auth 身份验证管理生成器
     * @throws Exception
     */
    @Override
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {
        auth.userDetailsService(userDetailsService()).passwordEncoder(encoder());
    }

    /**
     *
     * @return
     */
    @Bean
    public PersistentTokenRepository persistentTokenRepository(){
        JdbcTokenRepositoryImpl tokenRepository = new JdbcTokenRepositoryImpl();
        tokenRepository.setDataSource(dataSource);
        return tokenRepository;
    }
    @Bean
    @ConditionalOnMissingBean(ClassPathTldsLoader.class)
    public ClassPathTldsLoader classPathTldsLoader(){
        return new ClassPathTldsLoader();
    }
}