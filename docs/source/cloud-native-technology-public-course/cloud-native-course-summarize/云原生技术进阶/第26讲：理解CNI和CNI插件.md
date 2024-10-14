# 理解 CNI 和 CNI 插件

*生成时间*: 2024-10-14 16:03:00  
*生成者*: mingelement

## 章节概述
本章节由阿里巴巴技术专家溪恒讲解，内容涵盖了CNI（Container Network Interface）的概念、Kubernetes中如何使用CNI插件、选择合适的CNI插件以及如何开发自己的CNI插件。通过详细解析CNI的工作原理和实际操作步骤，帮助读者理解如何在Kubernetes集群中配置和管理网络。

## 关键内容

### CNI 是什么
- **CNI (Container Network Interface)**:
  - 容器网络的API接口。
  - Kubelet通过这个标准的API调用不同的网络插件来配置网络。
  - **CNI插件**: 一系列实现了CNI API接口的网络插件。

### Kubernetes 中如何使用 CNI
1. **配置CNI配置文件**:
   - 通常位于`/etc/cni/net.d/xxnet.conf`。
2. **安装CNI二进制插件**:
   - 通常位于`/opt/cni/bin/xxnet`。
3. **创建Pod**:
   - 在节点上创建Pod。
4. **Kubelet执行CNI插件**:
   - Kubelet根据CNI配置文件执行CNI插件。
5. **配置Pod网络**:
   - Pod的网络配置完成。

- **简化安装**:
  - 大多数CNI插件提供者支持一键安装。
  - 例如，Flannel可以通过Daemonset自动将配置和二进制文件拷贝到Node的配置文件夹中。

### 选择合适的 CNI 插件
- **CNI插件实现模式**:
  - **Overlay**: 靠隧道打通，不依赖底层网络。
  - **路由**: 靠路由打通，部分依赖底层网络。
  - **Underlay**: 靠底层网络能力打通，强依赖底层。

- **选择考虑因素**:
  1. **环境限制**:
     - 不同环境支持的底层能力不同。
  2. **功能需求**:
     - 不同实现支持的功能不同。
  3. **性能需求**:
     - 不同实现的性能损失不同。

- **推荐插件**:
  - **物理机**:
    - 选择Underlay或路由的插件，如Calico-BGP, Flannel-hostgw, SR-IOV等。
  - **虚拟化**:
    - 网络限制多，需要选择支持Overlay的插件，如Flannel-vxlan, Calico-ipip, Weave等。
  - **公有云**:
    - 如果有则选云厂商支持的，如阿里云的Terway。
  - **安全**:
    - 支持NetworkPolicy的插件，如Calico, Weave等。
  - **集群外资源互联互通**:
    - 选择Underlay的网络，如SR-IOV, Calico-BGP等。
  - **服务发现与负载均衡**:
    - 很多Underlay的插件不支持K8s Service服务发现。
  - **Pod创建速度**:
    - Overlay或者路由模式的网络插件创建快；Underlay模式网络插件创建慢。
  - **Pod网络性能**:
    - Overlay性能相对较差；Underlay模式和路由模式网络插件性能好。

### 如何开发自己的 CNI 插件
- **CNI插件实现**:
  - **二进制CNI插件**:
    - 配置Pod的网卡和IP等。
  - **Daemon进程**:
    - 管理Pod之间的网络打通。

- **具体步骤**:
  1. **给Pod插上网线**:
     - 创建“veth”虚拟网卡对。
     - 将一端的网卡挪到Pod中。
     - 给Pod分配集群中唯一的IP地址。
     - 配置Pod的IP和路由。
  2. **给Pod连上网络**:
     - CNI Daemon进程学习到集群所有Pod的IP和其所在节点。
     - 通常通过请求Kubernetes APIServer拿到现有Pod的IP地址和节点。
     - 使每一个Pod的IP在集群中都能被访问到。

## 主要观点
- CNI是Kubernetes中用于配置容器网络的标准接口。
- 通过选择合适的CNI插件，可以满足不同环境和业务需求。
- 开发自己的CNI插件可以帮助解决特定的网络问题，并提高灵活性。

## 结论与启示
- 了解CNI和CNI插件的工作原理对于管理和配置Kubernetes网络至关重要。
- 根据具体的环境和需求选择合适的CNI插件可以提高网络性能和可靠性。
- 开发自定义CNI插件提供了更大的灵活性，但需要深入理解网络配置和Kubernetes架构。

## 思考问题
1. 为什么需要CNI？它解决了什么问题？
2. 如何在Kubernetes中配置和使用CNI插件？
3. 选择CNI插件时需要考虑哪些因素？
4. 如何开发一个简单的CNI插件？

## 重要引用
> "CNI插件：一系列实现了CNI API接口的网络插件。"

## 关键术语
- **CNI (Container Network Interface)**: 容器网络接口。
- **CNI插件**: 实现了CNI API接口的网络插件。
- **Overlay**: 通过隧道技术实现网络隔离。
- **路由**: 通过路由表实现网络通信。
- **Underlay**: 依赖底层网络实现网络通信。
- **veth pair**: 虚拟以太网设备对，用于连接宿主机和容器。
- **NetworkPolicy**: 用于控制Pod间的网络访问策略。
- **Calico**: 一种流行的CNI插件，支持BGP和IP-in-IP。
- **Flannel**: 另一种流行的CNI插件，支持多种后端。
- **Weave**: 提供Overlay网络解决方案的CNI插件。
- **Terway**: 阿里云提供的CNI插件，支持弹性网卡。