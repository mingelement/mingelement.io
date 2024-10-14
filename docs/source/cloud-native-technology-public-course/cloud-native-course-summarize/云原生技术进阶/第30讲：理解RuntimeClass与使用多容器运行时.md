# 理解 RuntimeClass 与使用多容器运行时

*生成时间*: 2024-10-14 16:15:00  
*生成者*: mingelement

## 章节概述
本章节主要分享了以下三方面的内容：
1. **RuntimeClass 的需求来源**
2. **RuntimeClass 的功能介绍**
3. **多容器运行时示例**

通过详细解析RuntimeClass的工作原理和实际操作步骤，帮助读者理解如何在Kubernetes集群中配置和管理多容器运行时。

## 关键内容

### 一、RuntimeClass的需求来源
- **容器运行时的演进过程**:
  - **第一阶段 (2014年6月)**: Kubernetes正式开源，Docker是当时唯一的、也是默认的容器运行时。
  - **第二阶段 (Kubernetes v1.3)**: rkt合入Kubernetes主干，成为第二个容器运行时。
  - **第三阶段 (Kubernetes v1.5)**: 推出了CRI (Container Runtime Interface)，实现了运行时和Kubernetes的解耦。典型的实现如containerd中的`cri-plugin`，kata, gVisor等只需要对接containerd即可。

- **多容器运行时的需求**:
  - 集群里有哪些可用的容器运行时？
  - 如何为Pod选择合适的容器运行时？
  - 如何让Pod调度到装有指定容器运行时的节点上？
  - 容器运行时在运行容器时会产生一些业务运行以外的额外开销，这种「额外开销」需要怎么统计？

### 二、RuntimeClass的功能介绍
- **引入RuntimeClass**:
  - 最初以CRD的形式引入（Kubernetes v1.12）。
  - 在v1.14后作为内置集群资源对象`RuntimeClass`被引入。
  - v1.16版本扩充了Scheduling和Overhead的能力。

- **工作流程**:
  - **创建RuntimeClass对象**: 例如创建一个名为`runv`的RuntimeClass对象。
  - **创建Pod并引用RuntimeClass**: Pod通过`spec.runtimeClassName`引用`runv`这个RuntimeClass。
  - **配置Scheduling**: 使Pod能够调度到装有指定容器运行时的节点上。
  - **配置Overhead**: 统计容器运行时产生的额外开销，并影响ResourceQuota和Kubelet Pod驱逐行为。

- **Pod Overhead的使用场景**:
  - **ResourceQuota**: 增加已使用资源的比例，影响Namespace下的Pod调度数量。
  - **Kubelet Pod驱逐**: 增加已使用资源的占比，影响Kubelet对Pod的驱逐决策。

- **注意事项**:
  - Pod Overhead最终会永久注入到Pod内并且不可手动更改。
  - Pod Overhead只能由RuntimeClass admission自动注入，不可手动添加或更改。
  - HPA (Horizontal Pod Autoscaler) 和 VPA (Vertical Pod Autoscaler) 是基于容器级别指标数据做聚合，Pod Overhead不会对它们造成影响。

### 三、多容器运行时示例
- **环境示例**:
  - 两个Pod：一个是`runc`的Pod，另一个是`runv`的Pod。
  - `runc`的请求流程: 
    1. 请求到达kube-apiserver。
    2. kube-apiserver转发请求给kubelet。
    3. kubelet将请求发至`cri-plugin`。
    4. `cri-plugin`查询containerd的配置文件，找到`runc`对应的Handler。
    5. 通过`Shim API runtime v1`请求`containerd-shim`，创建对应的容器。
  - `runv`的请求流程:
    1. 请求到达kube-apiserver。
    2. kube-apiserver转发请求给kubelet。
    3. kubelet将请求发至`cri-plugin`。
    4. `cri-plugin`查询containerd的配置文件，找到`runv`对应的Handler。
    5. 通过`Shim API runtime v2`请求`containerd-shim-kata-v2`，创建Kata Pod。

- **containerd的具体配置**:
  - 默认配置文件位于`/etc/containerd/config.toml`。
  - 核心配置在`plugins.cri.containerd`目录下。
  - `runtimes`配置都有相同的前缀`plugins.cri.containerd.runtimes`，后面有`runc`, `runv`两种RuntimeClass。
  - `default_runtime`配置指定了如果Pod没有指定RuntimeClass，默认使用`runc`容器运行时。

- **示例**:
  - 创建`runc`和`runv`这两个RuntimeClass对象。
  - 使用`kubectl get runtimeclass`查看当前所有可用的容器运行时。
  - 创建Pod时，在`runtimeClassName`字段中分别引用`runc`和`runv`的容器运行时。
  - 通过`kubectl`命令查看各个Pod的运行状态以及使用的容器运行时。

## 主要观点
- **RuntimeClass**解决了多容器运行时混用的问题，提供了统一的管理和配置方式。
- **Scheduling**功能使得Pod可以自动调度到运行了指定容器运行时的节点上。
- **Overhead**功能可以把Pod中业务运行所需的额外开销统计进来，使调度、ResourceQuota和Kubelet Pod驱逐等行为更准确。

## 结论与启示
- 了解RuntimeClass对于管理和配置Kubernetes中的多容器运行时至关重要。
- 选择合适的RuntimeClass可以根据具体需求提高集群的安全性和性能。
- 通过合理配置Scheduling和Overhead，可以更好地管理和优化资源使用。

## 思考问题
1. 为什么需要RuntimeClass？它解决了什么问题？
2. 如何在Kubernetes中配置和使用RuntimeClass？
3. Scheduling和Overhead功能的作用是什么？
4. 如何查看和管理多容器运行时？

## 重要引用
> "RuntimeClass是Kubernetes一种内置的全局域资源，主要用来解决多个容器运行时混用的问题。"

## 关键术语
- **RuntimeClass**: 用于定义不同类型的容器运行时。
- **CRI (Container Runtime Interface)**: 容器运行时接口，解耦Kubernetes与容器运行时。
- **Scheduling**: 使Pod能够调度到装有指定容器运行时的节点上。
- **Overhead**: 统计容器运行时产生的额外开销。
- **ResourceQuota**: 资源配额，限制Namespace内的资源使用量。
- **Kubelet Pod驱逐**: Kubelet根据资源使用情况驱逐Pod的行为。
- **containerd**: 容器运行时守护进程，支持多种容器运行时。