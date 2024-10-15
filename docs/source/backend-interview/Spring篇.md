# 这些年背过的面试题——Spring篇（重点总结）

## 设计思想 & Beans

### 1. IoC 控制反转
- 将对象创建和依赖关系的控制权交给Spring容器管理。

### 2. DI 依赖注入
- 容器将对象依赖的其他对象注入到对象中。

### 3. AOP 动态代理
- 基于动态代理实现面向切面编程，减少系统重复代码，降低模块间耦合。

### 4. Bean生命周期
- 单例对象生命周期与容器相同；多例对象按需创建，长时间不用时被垃圾回收。

### 5. Bean作用域
- 默认为singleton。可通过ThreadLocal保证线程安全。

### 6. 循环依赖
- Spring通过三级缓存解决单例Bean的循环依赖问题。

## Spring注解

### 1. @SpringBoot
- 组合了@Configuration、@EnableAutoConfiguration、@ComponentScan注解。

### 2. @Component
- 通用注解，可标注任意类为Spring组件。

### 3. @Autowired
- 默认按类型装配注入，@Qualifier可以改成名称。

### 4. @SpringMVC
- 包括@Controller、@RequestMapping、@ResponseBody、@PathVariable等注解。

### 5. @SpringMybatis
- 包括@Insert、@Select、@Update、@Delete等注解。

### 6. @Transactional
- 用于声明事务管理，可以指定事务的传播行为等属性。

## SpringMVC原理

1. 请求发送到DispatcherServlet。
2. DispatcherServlet调用HandlerMapping解析请求对应的Handler。
3. HandlerAdapter处理请求并调用真正的处理器。
4. 处理器处理业务后返回ModelAndView。
5. ViewResolver查找实际的View。
6. DispatcherServlet将返回的Model传给View，视图渲染后返回给请求者。

## Spring源码阅读

### 1. Spring中的设计模式
- 包括单例、工厂、代理、观察者、适配器等设计模式。