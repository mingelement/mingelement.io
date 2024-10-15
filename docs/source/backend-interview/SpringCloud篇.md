# 这些年背过的面试题——SpringCloud篇

## Why SpringCloud

Spring Cloud 是一系列框架的有序集合，利用 Spring Boot 的开发便利性简化了分布式系统基础设施的开发，如服务发现注册、配置中心、消息总线、负载均衡、断路器、数据监控等。

## SpringBoot

Spring Boot 旨在快速搭建单个微服务，提供了开箱即用的功能，核心思想是“约定大于配置”。

### Spring Boot 解决的问题

- 简化后端框架搭建，减少 Maven 配置和 XML 配置文件。
- 支持将项目编译成可执行的 jar 包，无需部署到外部容器。
- 提供应用监控功能 Actuator。

### Spring Boot 优点

- 自动装配减少了重复性工作。
- 内嵌容器方便部署。
- 应用监控简化了监控实现。

## GateWay / Zuul

Gateway 提供统一的路由方式（反向代理）并基于 Filter 链的方式提供网关基本功能，如鉴权、流量控制、熔断、路径重写、日志监控。

## Eureka / Zookeeper

服务注册中心本质上是为了解耦服务提供者和服务消费者，支持弹性扩缩容特性。

## Feign / Ribbon

Feign 可以与 Eureka 和 Ribbon 组合使用以支持负载均衡，也可以与 Hystrix 组合使用，支持熔断回退。

## Hystrix / Sentinel

Hystrix 提供断路保护器功能，用于防止服务雪崩，提供资源隔离限流、失败回退、断路器和指标监控。

## Config / Nacos

Nacos 是一个服务发现、配置管理和服务管理平台，提供了服务发现与健康检查、动态配置管理、动态 DNS 服务和服。

## Bus / Stream

Spring Cloud Stream 消息驱动组件帮助我们更快速，更⽅便的去构建消息驱动微服务。

## Sleuth / Zipkin

全链路追踪，Spring Cloud Sleuth 可以追踪服务之间的调用，记录服务请求经过哪些服务、服务处理时长等。

## 安全认证

包括 Session、HTTP Basic Authentication、Token 和 JWT 认证。

## 灰度发布

灰度发布能降低发布失败风险，减少影响范围，当发布出现故障时，可以快速回滚，不影响用户。

## 各组件调优

包括对容器进行调优、Hystrix 的信号量隔离模式、配置 Gateway 并发信息、调整 Ribbon 的并发配置和修改 Feign 默认的 HttpURLConnection。