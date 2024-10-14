# Kubernetes 调度与资源管理

*生成时间*: 2024-10-14 15:38:00  
*生成者*: mingelement

## 章节概述
本章节由蚂蚁金服高级技术专家子誉讲解，内容涵盖了Kubernetes调度过程、基础调度能力、高级调度能力以及调度器架构和具体算法。通过详细解析Kubernetes的调度流程、资源管理和关系调度，帮助读者理解如何高效地管理和调度Pod。

## 关键内容

### Kubernetes调度过程
- **调度目标**: 将Pod分配到合适的Node上，满足Pod的资源要求、特殊关系要求、Node限制条件，并合理利用集群资源。
- **调度器架构**:
  - **kube-scheduler**: 负责将Pod分配到合适的Node。
  - **kube-apiserver**: 提供API接口，用于与调度器通信。
  - **kubelet**: 运行在每个Node上的代理，负责管理容器的生命周期。
  - **Controllers**: 控制器管理各种资源对象的状态。
  - **Informer**: 监听API Server的变化并更新缓存。
  - **Schedule Cache**: 缓存调度相关信息。

### Kubernetes基础调度能力
#### 资源调度
- **资源类型**:
  - CPU, Memory, Ephemeral Storage, GPU, FPGA等。
- **QoS (Quality of Service)**:
  - **Guaranteed**: 高优先级，保障资源。
  - **Burstable**: 中优先级，弹性资源。
  - **BestEffort**: 低优先级，尽力而为。
- **Resource Quota**: 限制每个Namespace的资源用量，防止过量使用。

#### 关系调度
- **PodAffinity/PodAntiAffinity**:
  - **PodAffinity**: Pod必须或优先调度到某些Pod所在的节点。
  - **PodAntiAffinity**: Pod禁止或尽量不调度到某些Pod所在的节点。
- **NodeSelector/NodeAffinity**:
  - **NodeSelector**: 必须调度到带了某些标签的Node。
  - **NodeAffinity**: 更灵活的选择Node，支持多种匹配方式（如In, NotIn, Exists, DoesNotExist, Gt, Lt）。
- **Taints/Tolerations**:
  - **Taints**: Node上的限制标记，阻止某些Pod调度上来。
  - **Tolerations**: Pod上的容忍标记，允许Pod调度到有特定Taints的Node上。

### Kubernetes高级调度能力
#### 优先级调度和抢占
- **Priority**:
  - 通过创建`PriorityClass`来定义不同Pod的优先级。
  - `HighestUserDefinablePriority`: 用户可配置的最大优先级限制。
  - `SystemCriticalPriority`: 系统级别优先级。
- **Preemption**:
  - 当高优先级Pod无法调度时，会驱逐低优先级Pod以腾出资源。
  - 抢占策略包括选择打破PDB最少的节点、待抢占Pods中最大优先级最小的节点等。

### 调度器架构简介和具体算法
- **调度器架构**:
  - **Predicates & Priorities**: 过滤器和优先级函数。
  - **Extenders**: 扩展机制，允许外部服务参与调度决策。
  - **Scheduler Framework**: 提供多个扩展点，增强调度器的功能。
- **调度流程**:
  - **Filter阶段**: 通过Predicates筛选出符合要求的节点。
  - **Score阶段**: 通过Priorities给符合条件的节点打分。
  - **SelectHost阶段**: 选择得分最高的节点。
  - **Bind阶段**: 将Pod绑定到选定的节点。

### 资源Quota
- **ResourceQuota**:
  - 限制每个Namespace的资源用量，包括CPU、Memory、Pod数量等。
  - 使用`Scope`来进一步细化限制范围，如Terminating/NotTerminating, BestEffort/NotBestEffort, PriorityClass。

## 主要观点
- Kubernetes调度器通过一系列过滤器和优先级函数来决定将Pod分配到哪个节点。
- 通过合理的资源配置和关系调度，可以确保集群资源的有效利用。
- 优先级调度和抢占机制可以保证高优先级Pod的调度需求。
- 调度器架构提供了丰富的扩展点，可以灵活适应不同的调度需求。

## 结论与启示
- 了解Kubernetes调度器的工作原理和配置方法对于优化集群性能和资源利用率至关重要。
- 通过合理配置资源请求、限制、亲和性规则和Taints/Tolerations，可以提高集群的稳定性和可用性。
- 优先级调度和抢占机制是处理资源紧张情况的有效手段。
- 调度器框架提供了强大的扩展能力，可以根据实际需求进行定制和优化。

## 思考问题
1. Kubernetes调度器如何决定将Pod分配到哪个节点？
2. 如何配置和优化Kubernetes调度器以提高资源利用率？
3. 什么是优先级调度和抢占机制，它们如何工作？
4. 如何使用Taints和Tolerations来控制Pod的调度？

## 重要引用
> "kube-scheduler通过一定的策略来缩小Node的取样规模，举例：配置配置比率10%，集群节点数allNodes=3000，那么numNodesToFind= Max(3000* 10/100, 100)，100是默认最小需要值。"

## 关键术语
- **kube-scheduler**: Kubernetes调度器。
- **kube-apiserver**: 提供API接口，用于与调度器通信。
- **kubelet**: 运行在每个Node上的代理，负责管理容器的生命周期。
- **Predicates**: 过滤器，用于筛选出符合要求的节点。
- **Priorities**: 优先级函数，用于给符合条件的节点打分。
- **PriorityClass**: 定义不同Pod的优先级。
- **Preemption**: 当高优先级Pod无法调度时，驱逐低优先级Pod以腾出资源。
- **PodAffinity/PodAntiAffinity**: Pod间的亲和性和反亲和性规则。
- **NodeSelector/NodeAffinity**: 选择适合Pod的Node。
- **Taints/Tolerations**: Node上的限制标记和Pod上的容忍标记。
- **ResourceQuota**: 限制每个Namespace的资源用量。
- **Scheduler Framework**: 调度器框架，提供多个扩展点以增强调度器的功能。