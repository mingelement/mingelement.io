# 这些年背过的面试题——Netty篇

## 核心组件

### 1. 整体结构
- **Core 核心层**：提供底层网络通信的通用抽象和实现，包括事件模型、通用API、支持零拷贝的 ByteBuf 等。
- **Protocol Support 协议支持层**：覆盖主流协议的编解码实现，如 HTTP、Protobuf、WebSocket 等。
- **Transport Service 传输服务层**：提供网络传输能力的定义和实现方法，支持 Socket、HTTP 隧道、虚拟机管道等传输方式。

### 2. 逻辑架构
- **网络通信层**：执行网络 I/O 操作，支持多种网络协议和 I/O 模型的连接操作。
- **事件调度层**：通过 Reactor 线程模型对各类事件进行聚合处理。
- **服务编排层**：负责组装各类服务，是 Netty 的核心处理链，用以实现网络事件的动态编排和有序传播。

## 网络传输

### 1. 五种IO模型的区别
- 阻塞I/O（BIO）
- 同步非阻塞I/O（NIO）
- 多路复用I/O（select和poll）
- 信号驱动I/O（SIGIO）
- 异步I/O（Posix.1的aio系列函数）

### 2. Reactor多线程模型
Netty 的 I/O 模型是基于非阻塞 I/O 实现的，底层依赖的是 NIO 框架的多路复用器 Selector。

### 3. 拆包粘包问题
- TCP 传输协议是面向流的，没有数据包界限。
- Nagle 算法：可以理解为批量发送。

### 4. 自定义协议
Netty 常用编码器类型和解码器类型，以及如何判断 ByteBuf 是否存在完整的报文。

### 5. WriteAndFlush
writeAndFlush 属于出站操作，从 Pipeline 的 Tail 节点开始进行事件传播。

## 内存管理

### 1. 堆外内存
堆外内存不受 JVM 虚拟机管理，直接由操作系统管理。

### 2. 数据载体ByteBuf
Netty 中的 ByteBuf 与 JDK NIO 的 ByteBuffer 的对比。

### 3. 内存分配jemalloc
jemalloc 架构和内存分配策略。

### 4. 零拷贝技术
Netty 中的零拷贝技术，包括堆外内存、CompositeByteBuf 类、Unpooled.wrappedBuffer、ByteBuf.slice 和 FileRegion。

## 高性能数据结构

### 1. FastThreadLocal
FastThreadLocal 与 JDK 原生的 ThreadLocal 的对比。

### 2. HashedTimerWheel
时间轮原理分析和时间轮空推进问题。

### 3. select、poll、epoll的区别
select、poll 和 epoll 的区别和适用场景。