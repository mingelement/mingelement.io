# Kubernetes网络模型进阶

*生成时间*: 2024-10-14 16:00:00  
*生成者*: mingelement

## 章节概述
本章节由阿里巴巴高级技术专家叶磊讲解，内容涵盖了Kubernetes网络模型的来龙去脉、Pod如何上网、Service的工作原理以及负载均衡的内外部区分。通过详细解析Kubernetes网络模型和相关组件的工作流程，帮助读者理解如何在Kubernetes集群中高效地管理和配置网络。

## 关键内容

### Kubernetes网络模型 来龙去脉
- **早期Docker网络的问题**:
  - Docker使用私网地址（如172.XX）和内部Bridge（Docker0 Bridge），出宿主机采用SNAT借IP，进宿主机用DNAT借端口。
  - 问题在于大量的NAT包导致网络性能下降且难以管理。

- **Kubernetes的新气象**:
  - 每个Pod都有一个独立的IP地址，这个IP是全局唯一的，拒绝任何变造（NAT）。
  - Pod内的容器共享这个IP地址。
  - 实现手段多样，可以是外部路由器添加条目，也可以是Overlay网络穿越。

### Pod究竟如何上网
- **协议层次**:
  - L2层（MAC寻址） -> L3层（IP寻址） -> L4+层（4层协议+端口）。
- **网络拓扑**:
  - 容器空间 -> 宿主机空间 -> 远端。
- **路由方案示例：Flannel-host-gw**:
  - 每个Node独占网段，Gateway放在本地。
  - 网络包的转发过程：
    1. **Pod-netns内出生**: 容器应用产生数据包，根据路由决定目的MAC。
    2 - **mac-桥转发**: 数据包通过veth pair发送到cni0桥，桥根据MAC转发。
    3. **ip-主机路由转发**: 数据包剥离MAC层，进入IP寻址层，查询本地路由表，找到远端Gw-ip并转发。
    4. **IP-远端路由转发**: 数据包到达远端节点，通过eth0进入主机协议栈，查询路由表后发给cni0。
    5. **mac-远端桥转发**: cni0收到数据包后继续推送，最终到达目的容器netns。

### Service究竟怎么工作
- **Service = 内部客户端侧负载均衡**:
  - 一群Pod组成一组功能后端。
  - 定义一个稳定的虚IP作为访问前端，通常还附赠一个DNS域名，客户端无需感知Pod的细节。
  - **Kube-proxy** 是实现核心，通过apiserver监控Pod/Service的变化，反馈到LB配置中。
  - LB的实现机制与目标解耦，可以是用户态进程，也可以是一堆精心设计的规则（如iptables/ipvs）。

- **LVS版Service的实现步骤**:
  1. 绑定VIP到本地（欺骗内核）。
  2. 为虚IP创建一个IPVS的virtual server。
  3. 为IPVS service创建相应的real server。

### 负载均衡还分内部外部
- **ClusterIP**: Node内部使用，将Service承载在一个内部ClusterIP上，只能保证集群内可以触达。
- **NodePort**: 供集群外部调用，将Service承载在Node的静态端口上，集群外的用户可以通过<NodeIP>:<NodePort>的形式调用到Service。
- **LoadBalancer**: 云厂商扩展接口，将Service通过外部云厂商的负载均衡接口承载。
- **ExternalName**: 将Service的服务完全映射到外部的名称（如某域名），这种机制完全依赖于外部DNS解析。

### 思考时间
- **需求分析**:
  - 思考为什么需要这些不同的Service类型。
  - 了解每种Service类型的具体应用场景。

## 主要观点
- Kubernetes网络模型通过每个Pod拥有独立的IP地址，解决了早期Docker网络中的NAT问题。
- Flannel-host-gw是一种简单的路由方案，适用于小规模集群。
- Service提供了多种类型的负载均衡方式，以满足不同场景的需求。
- Kube-proxy是实现Service的关键组件，通过监控和更新配置来实现负载均衡。

## 结论与启示
- 了解Kubernetes网络模型和相关组件的工作原理对于优化网络配置和提高集群性能至关重要。
- 通过合理选择和配置Service类型，可以更好地满足应用的网络需求。
- Kube-proxy和IPVS等工具提供了强大的负载均衡能力，能够支持大规模集群的高效运行。

## 思考问题
1. 为什么Kubernetes中的Pod需要独立的IP地址？
2. 如何实现一个基于IPVS的Service？
3. 不同类型的Service（ClusterIP, NodePort, LoadBalancer, ExternalName）分别适用于哪些场景？
4. Kube-proxy在Service负载均衡中扮演什么角色？

## 重要引用
> "一句话，让一个功能聚集小团伙（Pod）正大光明的拥有自己的身份证——IP。"

## 关键术语
- **Pod**: Kubernetes中最基本的可调度单元。
- **Service**: 提供稳定网络标识的抽象层，用于负载均衡和发现。
- **Kube-proxy**: 实现Service负载均衡的核心组件。
- **ClusterIP**: 仅在集群内部可用的虚拟IP。
- **NodePort**: 在Node上暴露一个静态端口，供集群外部访问。
- **LoadBalancer**: 通过云厂商提供的负载均衡服务暴露Service。
- **ExternalName**: 通过外部DNS名称映射到Service。
- **Flannel-host-gw**: 一种简单的路由方案。
- **IPVS**: 一种高性能的四层负载均衡器。