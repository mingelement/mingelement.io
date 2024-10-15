# 这些年背过的面试题——LeetCode篇

## Python语法

### 常用函数

- `reduce(function, iterable[, initializer])`：累计函数。
- `functools.lru_cache(None)`：装饰器，用于缓存函数结果。
- `tuple(ns)`：可哈希，可用作参数。
- `heapq.heapify(q)`：将列表转换为大根堆。
- `filter(function, iterable)`：过滤函数。
- `divmod(sum(ns), 4)`：返回商和余数。
- `sorted(pss, key = lambda x:[x[0],-x[1]])`：排序函数。

### 字符串操作

- `split(sep=None, maxsplit=-1)`：分割字符串。
- `strip([chars])`：去除首尾字符。
- `join(iterable)`：拼接字符串。
- `replace(old, new[, count])`：替换字符串。
- `count(sub[, start[, end]])`：统计子字符串数量。
- `startswith(prefix[, start[, end]])`：检查是否以prefix开始。
- `endswith(suffix[, start[, end]])`：检查是否以suffix结束。

### 列表操作

- `sort(key=None, reverse=False)`：排序。
- `append(val)`：添加元素。
- `clear()`：清空列表。
- `count(val)`：统计元素数量。
- `pop(val=lst[-1])`：移除元素。
- `remove(val)`：移除特定值。
- `reverse()`：反转列表。
- `insert(i, val)`：插入元素。

### 字典操作

- `defaultdict(lambda : value)`：创建默认字典。
- `pop(key[, default])`：删除键值对。
- `setdefault(key[, default])`：设置默认值。
- `update([other])`：更新字典。
- `get(key[, default])`：获取值。
- `clear()`：清空字典。
- `keys()`：获取键。
- `values()`：获取值。
- `items()`：获取键值对。

### 集合操作

- `set(lambda : value)`：创建集合。
- `add(elem)`：添加元素。
- `update(*others)`：添加多个元素。
- `clear()`：清空集合。
- `discard(elem)`：删除元素。

### 堆操作

- `heapq.heappush(heap,item)`：添加元素。
- `heapq.heappop(heap)`：弹出最小元素。
- `heapq.heapify(x)`：转换为堆。
- `heapq.heappoppush(heap, item)`：弹出并添加元素。
- `heapq.merge(*iterables, key=None, reverse=False)`：合并堆。
- `heapq.nlargest(n, iterable, key=None)`：获取最大n个数。
- `heapq.nsmallest(n, iterable, key=None)`：获取最小n个数。

### 二分查找

- `bisect.bisect_left(ps, T, L=0, R=len(ns))`：查找左边界。
- `bisect.bisect_right(ps, T, L=0, R=len(ns))`：查找右边界。
- `bisect.insort_left(a, x, lo=0, hi=len(a))`：插入左侧。
- `bisect.insort_right(a, x, lo=0, hi=len(a))`：插入右侧。

### 位操作

- `&`：按位与。
- `|`：按位或。
- `^`：按位异或。
- `<<`：左移。
- `>>`：右移。
- `~`：按位取反。

## 背包模板

### 0-1背包问题

- 组合问题模板。
- 完全背包问题。

### 动态规划

- 单串问题。
- 单串加状态问题。

### 回溯模板

- 回溯算法模板。

### 拓扑排序

- 拓扑排序模板。

### 单调栈

- 单调栈模板。

### 二分模板

- 二分查找模板。

### 动态规划模板

- 经典动态规划问题。

### 滑动窗口

- 滑动窗口模板。

### 前缀和

- 前缀和模板。

### 双指针

- 双指针模板。

### 深度优先

- 二叉树遍历模板。

### 广度优先

- 广度优先搜索模板。

### 图论

- Dijkstra最短路径模板。
- Floyd算法模板。