# Kubernetes 安全之访问控制

*生成时间*: 2024-10-14 16:06:00  
*生成者*: mingelement

## 章节概述
本章节由阿里巴巴技术专家匡大虎（长虑）讲解，内容涵盖了Kubernetes API请求的访问控制、认证、RBAC（基于角色的访问控制）、Security Context的使用以及一些安全策略。通过详细解析Kubernetes的安全机制和实际操作步骤，帮助读者理解如何在Kubernetes集群中配置和管理访问控制。

## 关键内容

### Kubernetes API请求访问控制
- **谁**:
  - 在何种条件下可以对什么资源做什么操作。
- **Kubernetes资源模型**:
  - 包括Pod、Service Account等。
- **API请求处理流程**:
  - **Authentication (认证)**: 请求用户是否为能够访问集群的合法用户。
  - **Authorization (授权)**: 用户是否有权限进行请求中的操作。
  - **Admission Control (准入控制)**: 请求是否安全合规。

### Kubernetes认证
- **用户模型**:
  - Kubernetes没有自身的用户管理能力，通常通过请求凭证设置。
  - 支持的认证方式包括Basic认证、X509证书认证、Bearer Tokens (JSON Web Tokens)、Service Account、OpenID Connect、Webhooks等。

- **X509证书认证**:
  - 每个Kubernetes系统组件在集群创建时都签发了客户端证书。
  - 使用`kubectl certificate approve`命令批准证书签发请求。
  - 生成私钥和CSR（Certificate Signing Request），并通过API创建Kubernetes CSR实例或向管理员提交CSR文件。
  - 基于CSR文件或实例通过集群CA密钥对签发证书。

- **Service Accounts**:
  - 是Kubernetes中唯一能够通过API方式管理的APIServer访问凭证。
  - 通常用于Pod中的业务进程与APIServer的交互。
  - 当一个命名空间创建完成后，会同时在该命名空间下生成名为`default`的一个Service Account和对应的Secret实例。

### Kubernetes RBAC
- **Role**:
  - 在指定命名空间上配置角色权限，定义在指定的Kubernetes命名空间资源上用户可以进行哪些操作。
  - 角色模板中需要指定目标资源的API Group名称，可以通过Kubernetes官方API文档查询。

- **RoleBinding**:
  - 绑定到具体的用户、组或Service Account。
  - 示例：
    ```yaml
    kind: RoleBinding
    apiVersion: rbac.authorization.k8s.io/v1
    metadata:
      name: read-pods
      namespace: test
    subjects:
    - kind: User
      name: test1
      apiGroup: rbac.authorization.k8s.io
    roleRef:
      kind: Role
      name: pod-reader
      apiGroup: rbac.authorization.k8s.io
    ```

- **ClusterRole**:
  - 在集群所有命名空间维度下配置角色权限，定义针对所有命名空间范围内的资源用户可以进行哪些操作。
  - 示例：
    ```yaml
    kind: ClusterRole
    apiVersion: rbac.authorization.k8s.io/v1
    metadata:
      name: secret-reader
    rules:
    - apiGroups: [""]
      resources: ["secrets"]
      verbs: ["get", "watch", "list"]
    ```

- **ClusterRoleBinding**:
  - 绑定到具体的用户、组或Service Account。
  - 示例：
    ```yaml
    kind: ClusterRoleBinding
    apiVersion: rbac.authorization.k8s.io/v1
    metadata:
      name: read-secrets-global
    subjects:
    - kind: User
      name: admin1
      apiGroup: rbac.authorization.k8s.io
    roleRef:
      kind: ClusterRole
      name: secret-reader
      apiGroup: rbac.authorization.k8s.io
    ```

- **默认ClusterRoleBinding**:
  - `system:basic-user`: 未认证用户组的默认角色，不具备任何的操作权限。
  - `cluster-admin`: `system:masters`组默认的集群角色绑定，具备集群所有资源的所有操作权限。
  - 集群系统组件都有默认的ClusterRoleBinding，如`kube-controller-manager`, `kube-scheduler`, `kube-proxy`等。

### Security Context的使用
- **Security Context**:
  - 用于在Pod或Container维度设置安全相关的属性。
  - 主要设置包括：
    - `runAsNonRoot`: 声明容器以非root用户运行。
    - `Capabilities`: 控制容器运行时刻拥有的系统capabilities。
    - `readOnlyRootFilesystem`: 控制容器运行时刻是否有文件系统的写权限。
    - `MustRunAsNonRoot`: 阻止所有以root用户启动的容器。

- **CVE-2019-5736**:
  - 攻击者可以通过特定的容器镜像或者exec操作获取到宿主机runc执行时的文件句柄并修改掉runc的二进制文件，从而获取到宿主机的root执行权限。
  - 通过将容器设置为非root运行模式可以有效阻止该攻击。

### 多租户安全加固
- **RBAC和基于命名空间的软隔离**:
  - 是基本且必要的安全措施。
- **Pod Security Policies (PSP)**:
  - 对Pod的安全参数进行校验，同时加固Pod运行时刻的安全。
- **Resource Quota & Limit Range**:
  - 限制租户的资源使用配额。
- **敏感信息保护**:
  - Secret加密。
- **最小权限原则**:
  - 尽可能缩小Pod内容器的系统权限。
- **NetworkPolicy**:
  - 进行业务应用间东西向网络流量的访问控制。
- **日志记录**:
  - 记录所有操作。
- **监控系统对接**:
  - 实现容器应用维度的监控。

## 主要观点
- Kubernetes提供了多种认证和授权机制来确保集群的安全性。
- RBAC是Kubernetes中实现细粒度访问控制的重要手段。
- Security Context可以帮助增强Pod的安全性。
- 通过合理的安全策略和配置，可以显著提高Kubernetes集群的安全性。

## 结论与启示
- 了解Kubernetes的认证、授权和安全策略对于保障集群的安全至关重要。
- 合理使用RBAC和Security Context可以有效提升集群的安全性和可靠性。
- 定期审查和更新安全配置，确保集群始终处于受控状态。

## 思考问题
1. 为什么需要在Kubernetes中实施访问控制？
2. 如何配置和使用RBAC来实现细粒度的访问控制？
3. Security Context在Pod安全性方面的作用是什么？
4. 如何通过PSP和其他安全策略来加固Kubernetes集群？

## 重要引用
> "RBAC是Kubernetes中实现细粒度访问控制的重要手段。"

## 关键术语
- **Authentication**: 认证。
- **Authorization**: 授权。
- **Admission Control**: 准入控制。
- **RBAC (Role-Based Access Control)**: 基于角色的访问控制。
- **Role**: 角色。
- **RoleBinding**: 角色绑定。
- **ClusterRole**: 集群角色。
- **ClusterRoleBinding**: 集群角色绑定。
- **Service Account**: 服务账户。
- **Security Context**: 安全上下文。
- **Pod Security Policy (PSP)**: Pod安全策略。
- **Resource Quota**: 资源配额。
- **Limit Range**: 限制范围。
- **NetworkPolicy**: 网络策略。