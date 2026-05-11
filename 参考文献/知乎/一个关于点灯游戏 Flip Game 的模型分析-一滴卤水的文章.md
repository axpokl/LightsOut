2018 年，axpokl 写下了[关于点灯游戏的分析](https://zhuanlan.zhihu.com/p/53646257)，并在 b 站有相关的。惊叹之余，觉得其中对算法和原理的阐述还是有些模糊，可以用更严谨和清晰的方式表达，所以有了这篇文章。

（本文使用较多 $\LaTeX$，故加载时可能有卡顿，请耐心等待）

## 游戏介绍

点灯游戏，又名[灭灯游戏](https://zhida.zhihu.com/search?content_id=274113657&content_type=Article&match_order=1&q=%E7%81%AD%E7%81%AF%E6%B8%B8%E6%88%8F&zhida_source=entity)（Lights Out），是一个经典谜题。规则为：

1.  棋盘由边长为 $n$ 的正方形格子组成，每个格子有一个灯，要么开要么关。
2.  点击一个格子，会将本格和它的上下左右格的状态翻转：开变为关，关变为开。
3.  如果要翻转的格子超出了棋盘边界，因为那个格子不存在，不需要在不存在的方向应用规则 2。
4.  目标是从全暗状态打开所有灯，或从全亮状态关闭所有灯。

为更好研究，将其规则形式化如下：

**棋盘**

$$\begin{array} \\ \mathbf{A} \in \{0,1\}^{n \times n} \\ \end{array}$$

**[点灯核](https://zhida.zhihu.com/search?content_id=274113657&content_type=Article&match_order=1&q=%E7%82%B9%E7%81%AF%E6%A0%B8&zhida_source=entity)**

$$\mathbf{K}=\begin{pmatrix}     0 & 1 & 0 \\     1 & 1 & 1 \\     0 & 1 & 0     \end{pmatrix}$$

**点灯操作**

$$p(i,j):\mathbf{A} \leftarrow   \mathbf{A}+\mathbf{K}_{i,j}^{n \times n} \pmod{2}$$

$\mathbf{K}_{i,j}$ 表示将点灯核对齐至 $(i,j)$ 处的 $n \times n$ 矩阵，将在边界条件中详细说明。有时点灯操作也称作按钮。

\==——**for more...**——==

所有 $n \times n$ 矩阵与矩阵加在 $\mathbb{Z}_2$ 上构成一个加法群（[阿贝尔群](https://zhida.zhihu.com/search?content_id=274113657&content_type=Article&match_order=1&q=%E9%98%BF%E8%B4%9D%E5%B0%94%E7%BE%A4&zhida_source=entity)），并进一步构成一个[向量空间](https://zhida.zhihu.com/search?content_id=274113657&content_type=Article&match_order=1&q=%E5%90%91%E9%87%8F%E7%A9%BA%E9%97%B4&zhida_source=entity)。若考虑矩阵乘法，则可逆矩阵与矩阵乘构成[一般线性群](https://zhida.zhihu.com/search?content_id=274113657&content_type=Article&match_order=1&q=%E4%B8%80%E8%88%AC%E7%BA%BF%E6%80%A7%E7%BE%A4&zhida_source=entity) $\mathrm{GL}(n, \mathbb{Z}_2)$。

\==—————————==

**边界条件**

$$\begin{array} \\ R(m) : m \in [\max(1,m-1),\min(n,m+1)] \\  \mathbf{K}_{i,j}(k,l) = \begin{cases} \mathbf{K}(k-i+2,l-j+2) & \text{if } R(p) \text{ and } R(q), \\0 & \text{otherwise}. \end{cases} \\ \end{array}$$

目标为将 $\mathbf{A}_0=\mathbf{0} ^{n \times n}$ 变换为 $\mathbf{A}_f=\mathbf{1}^{n \times n}$，或者反过来。后续分析采用 $\mathbf{0} ^{n \times n} \mapsto \mathbf{1} ^{n \times n}$ 的目标。

## 约定

之后所有的运算均在 $\mathbb{Z}_2=\{0,1\}$ 下进行，故条件为 $\pmod{2}$ 时省略标记。

对于符号：

-   形如 $\mathbf{1}$ 的矩阵表示矩阵每个元素的值都是这个数字。
-   对于任意矩阵 $\mathbf{M}$，$\mathbf{M}(i,j)$ 表示矩阵 $(i,j)$ 处的元素，意义与 $a_{ij}$ 等同。
-   对于棋盘 $\mathbf{A}$，$\mathbf{A}(i,j)$ 表示 $(i,j)$ 格的灯。
-   加粗小写字母或小写字母表示向量。
-   所有向量默认都是列向量，加转置表示行向量。
-   上标 $^{m \times n}$ 指示矩阵大小，矩阵大小为 $n \times n$ 时均省略。
-   下标 $_i$ 指示某种计数意义的“第 $i$ 个”
-   映射下标如 $_\phi$ 指示矩阵尺寸等于映射的陪域尺寸

对于固定对象：

-   $[n] =\{1,2,\dots ,n\}, [n]^{2}=[n] \times [n]$
-   $\mathbb{Z}_2 ^{k}=\{\mathbf{M}^{k \times k}|\mathbf{M}(i,j)\in \{0,1\}\}$，默认 $\mathbb{Z}_2=\mathbb{Z}_2 ^{n}$
-   $\sum\limits_{i}=\sum\limits_{i=1}^n,\sum\limits_{i,j}=\sum\limits_{i}\sum\limits_{j}$
-   $\mathbf{I}$ 表示单位阵。

“for more...”与**带\*章节**对算法关系不大，主要是严谨性的证明，可当做选读内容。

## 基本原理

### 复合不变

用 $p^n(i,j)$ 表示对 $\mathbf{A}(i,j)$ 连续进行点灯操作 $n$ 次。有

$$p^2(i,j):\mathbf{A} \leftarrow  \mathbf{A}$$

例如 $p^{2}(1,2)$ 对 $\mathbf{A}^{3 \times3}$ 的操作

$$\begin{pmatrix}   0 & 0 & 0 \\   0 & 0 & 0 \\   1 & 0 & 0 \end{pmatrix}_{\mathbf{A}}  \xrightarrow{p(1,2)} \begin{pmatrix}   1 & 1 & 1 \\   0 & 1 & 0 \\   1 & 0 & 0 \end{pmatrix}_{\mathbf{A}} \xrightarrow{p(1,2)} \begin{pmatrix}   0 & 0 & 0 \\   0 & 0 & 0 \\   1 & 0 & 0 \end{pmatrix}_{\mathbf{A}}$$

**证明**

$$\begin{array} \\ p^2(i,j):\mathbf{A} \leftarrow  \mathbf{A}+\mathbf{K}_{i,j}+\mathbf{K}_{i,j} \\ \mathbf{K}_{i,j}+\mathbf{K}_{i,j}=(1+1)\mathbf{K}_{i,j} = 0 \cdot \mathbf{K}_{i,j}=\mathbf{0} \\ \mathbf{A} \leftarrow  \mathbf{A}+\mathbf{K}_{i,j}+\mathbf{K}_{i,j} \iff  \mathbf{A} \leftarrow  \mathbf{A} \\ p ^{2}(i,j) = I(i,j) \end{array}$$

■

**零操作** $I$ 或 $I(i,j)$ 表示什么也不做。

### 顺序无关

用 $\cdot~\circ~\cdot$ 表示操作复合，$\circ$ 是左结合的。则操作 $p(i,j)$ 和 $p(k,l)$ 满足

$$p(i,j) \circ p(k,l) = p(k,l) \circ p(i,j)$$

例子：

$$\begin{align}&\begin{pmatrix}  0 & 0 & 0 \\  0 & 0 & 0 \\  0 & 0 & 0 \end{pmatrix}_{\mathbf{A}} \xrightarrow{p(2,2)} \begin{pmatrix}  0 & 1 & 0 \\  1 & 1 & 1 \\  0 & 1 & 0 \end{pmatrix}_{\mathbf{A}} \xrightarrow{p(2,3)} \begin{pmatrix}  0 & 1 & 1 \\  1 & 0 & 0 \\  0 & 1 & 1 \end{pmatrix}_{\mathbf{A}} \\ &\begin{pmatrix}  0 & 0 & 0 \\  0 & 0 & 0 \\  0 & 0 & 0 \end{pmatrix}_{\mathbf{A}} \xrightarrow{p(2,3)} \begin{pmatrix}  0 & 0 & 1 \\  0 & 1 & 1 \\  0 & 0 & 1 \end{pmatrix}_{\mathbf{A}} \xrightarrow{p(2,2)} \begin{pmatrix}  0 & 1 & 1 \\  1 & 0 & 0 \\  0 & 1 & 1 \end{pmatrix}_{\mathbf{A}}\end{align}$$

**证明**

$$\begin{array} \\ p(i,j) \circ p(k,l):\mathbf{A} \leftarrow (\mathbf{A} + \mathbf{K}_{i,j}) + \mathbf{K}_{k,l} \\ p(k,l) \circ p(i,j):\mathbf{A} \leftarrow (\mathbf{A} + \mathbf{K}_{k,l}) + \mathbf{K}_{i,j} \end{array}$$

矩阵加法在 $\mathbb{Z}_2$ 上满足交换律：$\mathbf{A} + \mathbf{K}_{i,j} + \mathbf{K}_{k,l} = \mathbf{A} + \mathbf{K}_{k,l} + \mathbf{K}_{i,j}$

故

$$p(i,j) \circ p(k,l) = p(k,l) \circ p(i,j)$$

■

\==——**for more...**——==

定义[点灯序列](https://zhida.zhihu.com/search?content_id=274113657&content_type=Article&match_order=1&q=%E7%82%B9%E7%81%AF%E5%BA%8F%E5%88%97&zhida_source=entity)

$$p((i_1,j_1),(i_2,j_2),\dots (i_n,j_n))=\overset{n}{\underset{k=1}{\bigcirc}}p(i_k,j_k)$$

设 $\mathcal{P}=\{p((i_1,j_1)\dots (i_k,j_k))|i,j \in [n]\}$，关系 $\circ:\mathbb{Z}_2 \to \mathbb{Z}_2$ 有

$$\begin{align} \quad \forall p_a,p_b &\in \mathcal{P}: \\ p_a = p((i_1,j_1),\dots,(i_{k_a},j_{k_a})),p_a &: \mathbf{A} \mapsto \mathbf{A} + \sum_{s=1}^{k_a} \mathbf{K}_{i_{s},j_{s}} \\ p_b = p((i_1,j_1),\dots,(i_{k_b},j_{k_b})),p_b &: \mathbf{A} \mapsto \mathbf{A} + \sum_{m=1}^{k_b} \mathbf{K}_{i_{m},j_{m}} \\ \end{align}$$

设 $p_a\circ p_b:\mathbf{A} \mapsto \mathbf{A}_{ab}$，有

$$\begin{align} \mathbf{A}_{ab} = \left( \mathbf{A} + \sum_{s=1}^{k_a} \mathbf{K}_{i_{s},j_{s}} \right) + \sum_{m=1}^{k_b} \mathbf{K}_{i_{m},j_{m}}= \mathbf{A} + \left( \sum_{s=1}^{k_a} \mathbf{K}_{i_s,j_s} + \sum_{m=1}^{k_b} \mathbf{K}_{i_m,j_m} \right) \end{align}$$

$(\mathbb{Z}_2,+_{\mathbf{K}})$ 是群，所以求和的结果仍然对应一个 $\mathbf{K}_{i',j'}$。则

$$1.\quad \forall p_a, p_b \in \mathcal{P}:p_a \circ p_b \in \mathcal{P}$$

$(\mathbb{Z}_2,+_{\mathbf{M}})$ 是群，满足结合律，故

$$2.\quad \forall p_a,p_b,p_c\in \mathcal{P}:(p_a \circ p_b) \circ p_c=p_a \circ (p_b \circ p_c)$$

容易证明

$$3.\quad \forall p \in \mathcal{P},\exists I \in  \mathcal{P}:Ip=pI=p$$

由于复合不变，$\begin{array} \\ \forall p \in \mathcal{P},p=\overset{n}{\underset{k=1}{\bigcirc}}p(i_k,j_k)\quad \text{then} \\ \begin{align} p \circ p &=\mathbf{A} + \sum_{k} \mathbf{K}_{i_{k},j_{k}}+\sum_{k} \mathbf{K}_{i_{k},j_{k}}  \\ &=\mathbf{A}+\sum_{k} 2\mathbf{K}_{i_{k},j_{k}} \\ &=\mathbf{A}+\sum_{k} \mathbf{0} \\ &=\mathbf{A} \end{align} p \circ p:\mathbf{A} \mapsto \mathbf{A}, \quad \text{so}\\ 4.\quad \forall p \in \mathcal{P}:p \circ p=I=p ^{-1} \circ p \end{array}$

所以 $\mathcal{P}$ 和 $\circ$ 构成群 $(\mathcal{P},\circ )$。同时，$\circ:\mathcal{P} \times \mathbb{Z}_2 \to \mathbb{Z}_2$ 是 $\mathcal{P}$ 在棋盘集上的群作用。

$(\mathcal{P},\circ)$ 的每个元素都是自己的逆元。其满足以下性质，读者可尝试证明：

I. 群阶 $|\mathcal{P}|=2^{n ^{2}}$，元素阶 $|p|=2$，特别有 $|I|=1$。

II. $(\mathcal{P},\circ )$ 为阿贝尔群。

III. $Z(\mathcal{P})=\mathcal{P}$

IV. $n ^{2}$ 个元素 $p((i,j))$ 构成生成集。

V. $\mathcal{P} \cong \mathbb{Z}_2 ^{n ^{2}}$

VI. $\text{Aut}(\mathcal{P}) \cong \text{GL}(n ^{2},\mathbb{Z}_2)$

\==—————————==

## 方案

### 算子化

根据顺序无关可知，对于一个给定棋盘状态 $\mathbf{A}$，其对应一个点灯操作在棋盘上的分布 $\mathbf{P} \in \mathbb{Z}_2$，称为**方案**。其中 $\mathbf{P}$ 的每个元素有$\mathbf{P}(i,j)=\begin{cases} 1 & \text{if } p(i,j), \\ 0 & \text{otherwise}. \end{cases}$

方案 $\mathbf{I}=\mathbf{0}$ 称为**零方案**。

根据 $p(i,j):\mathbf{A} \leftarrow \mathbf{A}+\mathbf{K}_{i,j}$，方案为所有其包含的点灯操作的叠加，那么给定方案 $\mathbf{P}$ 和棋盘 $\mathbf{A}$，即可计算出按方案对棋盘进行点灯操作后的棋盘 $\mathbf{A}'$。换言之，存在关系 $\mathbf{P}:\mathbf{A} \leftarrow \mathbf{A}'$，符合

$$\mathbf{A}' = \mathbf{A} + \sum\limits_{i,j} \mathbf{P}(i,j) \cdot \mathbf{K}_{i,j}$$

\==——**for more...**——==

定义也可写成[卷积形式](https://zhida.zhihu.com/search?content_id=274113657&content_type=Article&match_order=1&q=%E5%8D%B7%E7%A7%AF%E5%BD%A2%E5%BC%8F&zhida_source=entity) $\mathbf{A}' = \mathbf{A} + \mathbf{P} * \mathbf{K}$。$*$ 表示在 $\mathbb{Z}_2$ 上的离散卷积，定义为

$$(\mathbf{P} * \mathbf{K})(x,y) = \sum_{u=-1}^{1} \sum_{v=-1}^{1} \mathbf{K}(u+2, v+2) \cdot \mathbf{P}'(x-u, y-v)$$

其中 $\mathbf{P}'$ 为 $\mathbf{P}$ 的**补零方案**，定义为

$$\mathbf{P}'(x,y) = \begin{cases}\mathbf{P}(x,y) & \text{if } 1 \le x,y \le n, \\ 0 & \text{otherwise}. \end{cases}$$

\==—————————==

为简洁起见，记

$$\mathbf{P}\mathbf{A} = \mathbf{A} + \sum\limits_{i,j} \mathbf{P}(i,j) \cdot \mathbf{K}_{i,j}$$

表示将 $\mathbf{P}$ 应用于 $\mathbf{A}$ 得到新的棋盘。从映射角度，$\mathbf{P}_f:\mathbb{Z}_2 \to \mathbb{Z}_2$ 将 $\mathbf{A}$ 映射为 $\mathbf{A}'$。例如：

$$\begin{pmatrix}  1 & 0 & 0 \\  0 & 1 & 0 \\  0 & 0 & 1 \end{pmatrix}_{\mathbf{P}} \begin{pmatrix}  0 & 0 & 0 \\  0 & 0 & 0 \\  0 & 0 & 0 \end{pmatrix}_{\mathbf{A}} = \begin{pmatrix}  1 & 0 & 0 \\  0 & 1 & 0 \\  0 & 0 & 1 \end{pmatrix}_{\mathbf{A}}$$

于是，游戏目标就变为求使 $\mathbf{P}\mathbf{1}=\mathbf{0}$ 的方案 $\mathbf{P}_f$。

后文也将 $\mathbf{P}\mathbf{1}=\mathbf{A}$ 写作 $\mathbf{P} \to \mathbf{A}$ 或 $\mathbf{A} \to \mathbf{P}$。这种记法不影响运算的线性性，且便于表达“从方案到棋盘”或“从棋盘反推方案”的对应关系。

方案依旧满足复合不变和顺序无关。

\==——**for more...**——==

设 $\mathscr{P}=\{\mathbf{P}|\mathbf{P} \in \mathbb{Z}_2\}$ 与 $\mathbb{Z}_2$ 上的矩阵加法。关系 $+:\mathbb{Z}_2 \to \mathbb{Z}_2$ 有

$$1. \quad \forall \mathbf{P}_a,\mathbf{P}_b \in \mathscr{P}:\mathbf{P}_a+\mathbf{P}_b \in \mathscr{P}$$

$$2. \quad \forall \mathbf{P}_a,\mathbf{P}_b,\mathbf{P}_c \in \mathscr{P}:(\mathbf{P}_a+\mathbf{P}_b)+\mathbf{P}_c=\mathbf{P}_a+(\mathbf{P}_b+\mathbf{P}_c)$$

$$3.\quad \forall \mathbf{P} \in \mathscr{P}:\exists \mathbf{I} \in \mathscr{P},\mathbf{P} +\mathbf{I}=\mathbf{I}+\mathbf{P}=\mathbf{P}$$

$$\begin{array} \\ 4.\quad \forall \mathbf{P} \in \mathscr{P},\exists \mathbf{P} ^{-1} \in \mathscr{P} \\ \forall (i,j) \in \mathbb{Z}_2,\mathbf{P}(i,j)+\mathbf{P} ^{-1}(i,j)=0 \\ \mathbf{P}+ \mathbf{P}^{-1}=\mathbf{P} ^{-1}+\mathbf{P}=\mathbf{I} \end{array}$$

所以 $(\mathscr{P},+)$ 构成群。$+:\mathscr{P} \times \mathbb{Z}_2 \to \mathbb{Z}_2$ 是 $\mathscr{P}$ 在棋盘集上的群作用。

设映射 $\varphi: \mathcal{P} \to \mathscr{P}:p \mapsto \varphi(g)$，群 $(\mathcal{P},\circ)$ 与群 $(\mathscr{P},+)$ 的运算可化归为

$$\mathbf{A}' = \mathbf{A} + \sum\limits_{i,j}\mathbf{P}(i,j) \cdot \mathbf{K}_{i,j}$$

则易证

$$\forall p_a,p_b \in \mathcal{P}:\varphi (p_a \circ p_b)=\varphi(p_a)+\varphi (p_b)$$

$\forall \mathbf{P} \in \mathscr{P}$，设 $\mathbf{P}(i,j)=1$ 的格子集合为 $S = \{(i_1,j_1), \dots, (i_n,j_n)\}$。取 $p \in \mathcal{P},p = p((i_1,j_1),\dots,(i_n,j_n))$，有

$$\varphi(p) = \sum_{s} \mathbf{P}_{i_s,j_s} = \mathbf{P}$$

因此 $\varphi$ 是满射。

设

$$\begin{align} p_1, p_2 &\in \mathcal{P},\varphi(p_1) = \varphi(p_2) \\ p_1 &= p((i_1,j_1),\dots,(i_a,j_a)) \\ p_2 &= p((k_1,l_1),\dots,(k_b,l_b)) \\ \varphi(p_1) &= \sum_{s=1}^a \mathbf{P}_{i_s,j_s} \\ \varphi(p_2) &= \sum_{t=1}^b \mathbf{P}_{k_t,l_t} \\ \end{align}$$

对于每个 $\mathbf{A}(i,j)$，$p_1$ 中点击 $\mathbf{A}(i,j)$ 的次数模 2 等于 $p_2$ 中点击 $\mathbf{A}(i,j)$ 的次数模 2。由于 $\mathcal{P}$ 中操作的复合满足 $p^2(i,j) = I$，所以任何操作的效果只取决于每个格子被点击的次数模 2。

因为 $\varphi(p_1) = \varphi(p_2)$，则 $p_1$ 和 $p_2$ 对每个格子的点击次数模 2 相同，从而它们作为函数 $\mathbb{Z}_2 \to \mathbb{Z}_2$ 相同，$p_1 = p_2$。

因此 $\varphi$ 是单射。

综上，$\varphi$ 为双射，$\mathcal{P} \cong \mathscr{P}$

也意味着 $\mathscr{P}$ 是 $\mathcal{P}$ 的忠实表示。

\==—————————==

### 方案可拆性

由于复合不变与顺序无关，可以将任意方案 $\mathbf{P}$ 表示为一系列方案的叠加：

$$\mathbf{P} = \sum\limits_k  \mathbf{P}_k$$

其中 $\mathbf{P}_k$ 表示任意个满足条件的方案。

### 方案线性性

根据方案可拆性，可得 $\mathbf{P}_1\mathbf{A}+\mathbf{P}_2\mathbf{A}=\mathbf{P}\mathbf{A},\mathbf{P}=\mathbf{P}_1+\mathbf{P}_2$。不妨定义 $\mathbf{P}_1\mathbf{A}+\mathbf{P}_2\mathbf{A}=(\mathbf{P}_1+\mathbf{P}_2)\mathbf{A}$，可归纳得

$$\mathbf{P}\mathbf{A} = \left(\sum\limits_{k}\mathbf{P}_k\right)\mathbf{A} = \sum\limits_k\mathbf{P}_k\mathbf{A}$$

## 算法

### 穷举法

$\mathbf{P}$ 的状态空间 $X_\mathbf{P}$ 的状态数 $|X_\mathbf{P}|=2^{n ^{2}}$，进而只需要遍历 $\mathbf{P}_i \quad(i \in [2 ^{n ^{2}}])$，就可以筛选出 $\mathbf{A}_f$。

穷举法的时间复杂度为 $O(2^{n ^{2}})$，如 axpokl 所说，算上验证则为 $O(2^{n^{2}}n^{2})$，数值较大时计算机难以计算，需要更好的计算方式。

### 首行穷举法

设 $\mathbf{P}$ 的第一行 $\mathbf{P}(1 ,j)$ 已知，则有 $\mathbf{P}(1,j) \to \mathbf{A}(1,j)$。对于棋盘第一行没亮的部分，如 $\mathbf{A}(1,3)$，进行 $p(2,3)$ 即可将其点亮。进而可连续推断 $\mathbf{P}(i,j),\mathbf{A}(i,j),p(i+1,j),\mathbf{P}(i+1,j)$。

归纳得到操作流程

1.  $i=0$
2.  随机取 $\mathbf{P}(1,j) \in \{0,1\} \quad (1 \le j \le n)$
3.  $i \leftarrow i+1$
4.  $\mathbf{P}\mathbf{A}=\mathbf{A}'$ 得到新的 $\mathbf{A}(i,j) \quad (1 \le j \le n)$
5.  $j=1$
    1.  若 $\forall \mathbf{A}(i,j)=0$，令 $\mathbf{P}(i+1,j)=1$
    2.  $j \leftarrow j+1$
    3.  若 $j=n$，结束本层循环，否则跳回第 1 步
6.  若 $i=n$，结束本层循环，否则跳回第 3 步

如此，可保证 $1 \sim n-1$ 行的灯全亮。对于第 $n$ 行，由于没有更下一行供我们修正第 $n$ 行，所以只能检查最后一行的灯是否全亮，即检查是否满足 $\mathbf{A}_i=\mathbf{A}_f$。如果满足，我们就找到了一个 $\mathbf{P}_f$；如果不满足，需要重新取第一行操作。

例如，

$$\begin{align} \begin{pmatrix} 0 & 0 & 0 \\ 0 & 0 & 0 \\ 0 & 0 & 0 \end{pmatrix}_{\mathbf{A}} \xrightarrow{p(1,1),p(1,2)}\begin{pmatrix} 0 & 0 & 1 \\ 1 & 1 & 0 \\ 0 & 0 & 0 \end{pmatrix}_{\mathbf{A}} \xrightarrow{p(2,1),p(2,2)}\begin{pmatrix} 1 & 1 & 1 \\ 1 & 1 & 1 \\ 1 & 0 & 0 \end{pmatrix}_{\mathbf{A}} \end{align}$$

就说明 $p(1,1),p(1,2)$ 不是某种解的第一行。

\==——**for more...**——==

以上操作构成一个无后效性的动态规划：

1.  状态 $S=(\mathbf{P},\mathbf{A})$
2.  初态 $S(\mathbf{P}_0,\mathbf{A}_0)$，$\mathbf{P}(1,j) \in \{0,1\} \quad (1 \le j \le n), \mathbf{P}(i,j)=0 \quad (i >2)$
3.  对 $i=2,\dots ,n-1$，状态转移方程为 $\mathbf{P}(i+1, j) = 1 - \mathbf{A}(i, j)$
4.  终态 $S_f=(\mathbf{P},\mathbf{A})$。

若 $\mathbf{A}(n,:)=\mathbf{0}^{1\times n}$，则 $S_f=(\mathbf{P},\mathbf{A})=(\mathbf{P}_f,\mathbf{A}_f)$。

\==—————————==

首行穷举法的时间复杂度组成：

1.  **第一行可能性**：$2 ^{n}$
2.  **每行递推操作**：对于每个 $\mathbf{P}(i,j)$，计算从第 $2$ 行到第 $n$ 行的操作，每行计算 $n$ 格。一共 $n (n-1)$
3.  **检查最后一行**：$n$

故时间复杂度为 $O(2 ^{n} \cdot n ^{2})$。复杂度仍然是指数级，所以限制依旧很大。

### 叠加法

**单步**

由边界条件可以想到，对于特定位置的灯，只有几个特定的点灯操作可以改变其状态，如 $\mathbf{A}(1,1)$ 仅能被 $p(1,2),p(2,1)$ 改变状态。

考虑 $\mathbf{A}=\{0,1\} ^{3 \times 3}$，那么有

$$\begin{array} \\ \begin{pmatrix}     1 & 0 & 0 \\     0 & 0 & 0 \\     0 & 0 & 0   \end{pmatrix}_\mathbf{P}\mathbf{A}_0 = \begin{pmatrix}     1 & 1 & 0 \\     1 & 0 & 0 \\     0 & 0 & 0   \end{pmatrix}_\mathbf{A} \\ \begin{pmatrix}     0 & 1 & 0 \\     0 & 0 & 0 \\     0 & 0 & 0   \end{pmatrix}_\mathbf{P} \mathbf{A}_0 = \begin{pmatrix}     1 & 1 & 1 \\     0 & 1 & 0 \\     0 & 0 & 0   \end{pmatrix}_\mathbf{A} \\ \dots \end{array}$$

上述式子可以记为

$$\begin{array} \\ \mathbf{P}_{1,1} \mathbf{A}_0 = \mathbf{A}_{P|1,1} \\ \mathbf{P}_{1,2} \mathbf{A}_0 = \mathbf{A}_{P|1,2} \\ \dots \end{array}$$

形如 $\mathbf{P}_{i,j}$ 的方案称为**单步**。单步只包含一个点灯操作。记 $\mathbf{P}_{i,j}\mathbf{0}=\mathbf{A}_{P|i,j}$。根据方案可拆性，方案可表示为单步的线性组合：$\begin{align} \mathbf{P} &= \sum\limits_{(i,j) \in S}\mathbf{P}_{i,j} \\ S =\{(i,j) &\in [n]^{2}|\mathbf{P}(i,j)=1\} \\ \end{align}$

类似地，对于 $\mathbf{A}(i,j)$，有

$$\mathbf{P}(i,j) = \sum\limits_{k}\mathbf{P}_{k}(i,j)$$

这相当于方案可拆性的单格情况：当整体可拆时，每一格自然也是可拆的。

**单翻转**

思考：是否存在 $\mathbf{P}_{A|i,j}$ 使得

$$\begin{align} &\mathbf{P}_{A|i,j} = \sum\limits_k\mathbf{P}_{i,j}, \\ &\mathbf{P}_{A|i,j}\mathbf{A} \iff \mathbf{A} (i,j)+1 \end{align}$$

以 $3 \times3$ 为例，就是

$$\mathbf{P}_{A|1,1}\mathbf{A}_0=\begin{pmatrix}  1 & 0 & 0 \\  0 & 0 & 0 \\  0 & 0 & 0 \end{pmatrix}_{\mathbf{A}}$$

这样的方案称为**单翻转**。

这是一种反转：我们知道 $\mathbf{P}_{i,j} \to \mathbf{A}_{P|i,j}$，就想构造 $\mathbf{A}_{i,j} \to \mathbf{P}_{A|i,j}$。如果对应存在，则可构造

$$\mathbf{P}_f=\sum\limits_{(i,j) \in [n]^{2}} \mathbf{P}_{A|i,j}$$

使

$$\mathbf{P}_f\mathbf{A}_0=\sum\limits_{(i,j) \in [n]^{2}} \mathbf{P}_{A|i,j}\mathbf{A}_0=\mathbf{A}_f$$

设矩阵集 $S_E=\{\mathbf{P}_{i,j}\},S_A=\{\mathbf{A}_{P|i,j}\}$。可以总结出两种基操作：

1.  对于 $\mathbf{P}_{i,j}$ 和 $\mathbf{P}_{k,l}$，令 $\mathbf{P}_{i,j}=\mathbf{P}_{i,j}+\mathbf{P}_{k,l}$
2.  对于 $\mathbf{P}_{i,j}$ 和 $\mathbf{P}_{k,l}$，令 $\mathbf{P}_{i,j}=\mathbf{P}_{k,l},\mathbf{P}_{k,l}=\mathbf{P}_{i,j}$

运用两种基操作，可以构造出

$$\begin{array} \\ \mathbf{P}_{A|3,3}=\begin{pmatrix}     0 & 1 & 1 \\     1 & 0 & 0 \\     1 & 0 & 1   \end{pmatrix}_\mathbf{P} \to \mathbf{A}_{3,3} \\ \mathbf{P}_{A|3,2}=\begin{pmatrix}     1 & 1 & 1 \\     0 & 1 & 0 \\     0 & 0 & 0   \end{pmatrix}_\mathbf{P} \to \mathbf{A}_{3,2} \\ \cdots \end{array}$$

形式化地，有一般方法 $(S_P,S_A) \Rightarrow (S_{PA},S_{Af})$，集合 $S_{PA}$ 和 $S_{Af}$ 的元素满足

$$\mathbf{P}_{A|i,j} \to \mathbf{A}_{i,j}$$

就可求和得到 $\mathbf{P}_f$。

（这块不懂的可以从 [axpokl的视频](https://link.zhihu.com/?target=https%3A//www.bilibili.com/video/BV1XcxNz7EjF/) 4:20 开始看）

**向量化**

对 $\mathbf{A} \in \mathbb{Z}_2$，总是有 $n ^{2}$ 个 $\mathbf{P}_{i,j} \to \mathbf{A}_{P|i,j}$。为了寻求更系统的操作方案以及方便计算，我们可以将方案与棋盘“拉直”成一条，并将所有单步与对应的棋盘放在一起，一次性考虑所有情况。构造映射

$$\begin{array} \\ \phi: \mathbb{Z}_2^{n} \to \mathbb{Z}_2^{n ^{2}} \\ \phi(i,j) = n(i-1)+j \end{array}$$

将方案集和对应的棋盘集向量化

$$\begin{array} \\ \phi (\mathbf{P}_{i,j}(k,l)) = \mathbf{P}_{\phi(i,j)}^{1 \times n ^{2}} (\phi(k,l)) \\ \phi(\{\mathbf{P}_{i,j}\})=\mathbf{P}^{n ^{2} \times n ^{2}}=\mathbf{P}_\phi \\ \phi(\{\mathbf{A}_{P|i,j}\})=\mathbf{A}^{n ^{2}\times n ^{2}}=\mathbf{A}_\phi \end{array}$$

例如，对于 $3 \times3$ 棋盘，拉直表现为

```text
100   010   001       000
000   000   000  ...  000
000P  000P  000P      001P
            ↓
100000000
010000000
001000000
000100000
000010000
000001000
000000100
000000010
000000001P_φ

110   111   011       000
100   010   001  ...  001
000A  000A  000A      011A
           ↓
110100000
111010000
011001000
100110100
010111010
001011001
000100110
000010111
000001011A_φ
```

\==——**for more...**——==

映射 $\phi: \mathbb{Z}_2 \to \mathbb{Z}_2^{n^2}:p \to \phi(p)$ 将棋盘状态矩阵和方案分别向量化。有

1.  线性性

$$\begin{array} \\ \forall \mathbf{M}_1, \mathbf{M}_2 \in \mathbb{Z}_2,\forall c_1, c_2 \in \mathbb{Z}_2: \\ \phi(c_1 \mathbf{M}_1 + c_2 \mathbf{M}_2) = c_1 \phi(\mathbf{M}_1) + c_2 \phi(\mathbf{M}_2) \end{array}$$

由向量化定义，矩阵加法与数乘在 $\mathbb{Z}_2$ 下保持结构。

2\. 单射性。若 $\phi(\mathbf{M}_1) = \phi(\mathbf{M}_2)$，则两个矩阵的每个对应元素相等，故 $\mathbf{M}_1 = \mathbf{M}_2$。

3\. 满射性。$\forall \mathbf{v} \in \mathbb{Z}_2^{n^2}$，可构造矩阵 $\mathbf{M} \in \mathbb{Z}_2$ 使得 $\mathbf{M}(i,j) = \mathbf{v}(n(i-1)+j)$

显然 $\phi(\mathbf{M}) = \mathbf{v}$。

4\. 保结构。$\forall \mathbf{P}_1, \mathbf{P}_2 \in \mathscr{P}$，有

$$\phi(\mathbf{P}_1 + \mathbf{P}_2) = \phi(\mathbf{P}_1) + \phi(\mathbf{P}_2)$$

对应地，$\phi$ 将卷积运算 $\mathbf{P} * \mathbf{K}$ 映射为矩阵乘法 $\mathbf{P}_\phi \mathbf{K}_\phi$，其中 $\mathbf{K}_\phi$ 为核矩阵 $\mathbf{K}$ 对应的线性变换矩阵（托普利兹矩阵）。

综上，$\phi: \mathbb{Z}_2 \to \mathbb{Z}_2^{n ^{2}}$ 是线性映射。设 $\mathscr{P}_\phi =\mathbb{Z}_2^{n ^{2}}$，则 $(\mathscr{P}_\phi ,+)$ 是群且 $\mathscr{P} \cong \mathscr{P}_\phi$。因此，**复合不变**、**顺序无关**、**方案可拆性**、**方案线性性**等基本性质在 $\mathscr{P}_\phi$ 中有类似的版本成立，采用映射后的表示。

\==—————————==

映射后，$\mathbf{P}_{i,j}$ 变成了 $\mathbf{P}_\phi$ 第 $n(i-1)+j$ 个行向量，对应的棋盘 $\mathbf{A}_{P|i,j}$ 变成了 $\mathbf{A}_\phi$ 第 $n(i-1)+j$ 个行向量。在大矩阵下，上文对矩阵集的两种基本操作，变成了对 $\mathbf{P}_\phi$ 进行「倍加」和「交换」两种初等行变换。

化简即从 $\mathbf{P}_\phi=\mathbf{I}_\phi,\mathbf{A}_\phi$ 开始，重复

1.  对 $\mathbf{P}_\phi$ 进行一次初等行变换简化 $\mathbf{P}_\phi \leftarrow \mathbf{P}_{\phi,\text{new}}$
2.  计算 $\mathbf{A}_{\phi}=\mathbf{P}_{\phi,\text{new}} \mathbf{0}_{\phi}$

将 $\mathbf{A}_\phi$ 化为上三角矩阵，再回代变为单位矩阵。写成公式就是

$$[\; \mathbf{I}_\phi \mid \mathbf{A}_\phi \;] \xrightarrow{\text{Gauss‑Jordan}} [\; \mathbf{P}_{\phi f} \mid \mathbf{I}_\phi \;]$$

解方程的过程

$$\begin{align} \mathbf{P}_{\phi f}\mathbf{A}_{\phi}  &= \mathbf{I}_{\phi}  \\ \mathbf{P}_{\phi f}\mathbf{A}_{\phi}\mathbf{A}_{\phi}^{-1}  &= \mathbf{I}_\phi \mathbf{A}_{\phi}^{-1}   \\ \mathbf{P}_{\phi f}  &= \mathbf{A}_{\phi}^{-1}   \end{align}$$

$\phi ^{-1}(\mathbf{P}_{\phi f})$ 表示**单翻转阵集** $\{\mathbf{P}_{A|i,j}\}$，集合中的每个方案分别对应棋盘上的一个格子。将 $\mathbf{P}_{\phi f}$ 的所有行向量加起来，也就是

$$\sum\limits_k\phi ^{-1}(\mathbf{P}_{\phi f}(k,:))=  \sum\limits_{(i,j) \in [n]^{2}} \mathbf{P}_{A|i,j}$$

即可得到 $\mathbf{P}_f$。

为什么消元是解这个方程呢？

我们想要对棋盘每格的单翻转阵。映射后，它们被拉直且按一定顺序排列，也就是 $\mathbf{P}_{\phi f}$。回顾前文，既然单翻转可由单步构造得到，那么每一个单翻转一定由若干个单步组合而成。即对 $n ^{2}$ 个单步中的每一个，单翻转要么包含，要么不包含。

可以用一个矩阵 $\mathbf{X}^{n ^{2} \times n ^{2}}$ 来编码这些信息。$\mathbf{X}(k,:)$ 表示第 $k$ 行对应的单翻转如何选取单步，对于行向量中每个元素，$1$ 表示选，$0$ 表示不选。例如，

```text
101001110       100000000       100000000
000010111       010000000       010000000
101100011       001000000       001000000
001011001       000100000       000100000
010111010       000010000       000010000
100110100       000001000       000001000
110001101       000000100       000000100
111010000       000000010       000000010
011100101X      000000001P_φ    000000001A_φf
```

$\mathbf{X}(:,1)$ 表示选取 $\mathbf{P}_{\phi}$ 的第 $1,3,6,7,8$ 行（也就是 $\mathbf{P}_{1,1}+\mathbf{P}_{1,3}+\mathbf{P}_{2,3}+\mathbf{P}_{3,1}+\mathbf{P}_{3,2}$）可以得到 $\mathbf{A}_{f\phi}(1,:)$（也就是 $\mathbf{A}_{1,1}$）。

归纳知道，$\mathbf{X}$ 满足

$$\mathbf{X}\mathbf{P}_\phi=\mathbf{P}_{\phi f}$$

又因为 $\mathbf{P}_{\phi f}\mathbf{A}_{\phi} = \mathbf{A}_{\phi f}$，所以

$$\begin{align} (\mathbf{X}\mathbf{P}_{\phi})\mathbf{A}_{\phi}=\mathbf{A}_{\phi f} \\ \mathbf{X}\mathbf{P}_{\phi}\mathbf{A}_{\phi}=\mathbf{A}_{\phi f} \end{align}$$

可以知道 $\mathbf{P}_\phi$ 和 $\mathbf{A}_{\phi f}$ 都是 $\mathbf{I}_{\phi}$，所以方程变为

$$\mathbf{X}\mathbf{A}_{\phi}=\mathbf{I}_{\phi}$$

就是消元法解的方程。

叠加法的时间复杂度组成：

1.  **向量化棋盘**：$O(n ^{2} \cdot n ^{2})=O(n ^{4})$
2.  **解方程**：$O((n ^{2})^{3})=O(n ^{6})$
    1.  **消元每步对应**：操作 $\mathbf{A}_\phi$ 后同步更新 $\mathbf{P}_\phi$，单次操作至多计算 $2 \cdot 2n^{2}$ 个元素，复杂度 $O(n ^{2})$
3.  **逐行求和**：$O(n ^{2}\cdot n ^{2})=O(n ^{4})$
4.  **逆映射**：$O(n ^{2})$

故时间复杂度为 $O(n ^{6})$。叠加法将复杂度降低至指数级，显然更优。

### \*静默方案

叠加法中的证明 $[\; \mathbf{I}_\phi \mid \mathbf{A}_\phi \;] \xrightarrow{\text{Gauss‑Jordan}} [\; \mathbf{P}_{\phi f} \mid \mathbf{I}_\phi \;]$ 只可在 $\mathbf{A}_\phi$ 满秩时构造。如果 $r(\mathbf{A}_{\phi f})<n ^{2}$，也就是 $\mathbf{A}_\phi$ 不满秩，怎么办呢？

在更一般的情况下，对 $\mathbf{A}_\phi$ 消元并不能总是得到单位矩阵，而仅能得到行最简形矩阵。此时 $\mathbf{A}_{\phi f}\ne\mathbf{P}_\phi$，证明形式为 $[\; \mathbf{I}_\phi \mid \mathbf{A}_\phi \;] \xrightarrow{\text{Gauss‑Jordan}} [\; \mathbf{P}_{\phi f} \mid \mathbf{A}_{\phi f} \;]$。在不满秩状态下，需要将 $\mathbf{A}_\phi ^{-1}$ 当做伪逆矩阵，则 $\mathbf{P}_{\phi f}=\mathbf{A}_\phi^{-1}$ 仍然成立。

如果 $\mathbf{A}_\phi$ 不满秩，消元后有

$$\begin{array} \\ \mathbf{A}_{\phi f}(k,:) =\mathbf{\mu}_{k} =\mathbf{0}^{1 \times n ^{2} } \\ \phi ^{-1}(\mathbf{\mu}_{k} )=\mathbf{A}_{i,j}=\mathbf{0} \end{array}$$

这意味着 $\mathbf{A}_{\phi f}$ 的第 $k$ 行是冗余方程。对应有

$$\begin{array} \\ \mathbf{P}_{\phi f}(k,:)=\xi_k =\mathbf{A}_\phi ^{-1}(k,:) \\ \phi ^{-1}(\xi _k)=\mathbf{P}' \end{array}$$

在游戏中，这类 $\mathbf{P}'$ 满足 $\mathbf{P}’\mathbf{A}=\mathbf{I}\mathbf{A}=\mathbf{A}$，也即这些方案并不改变棋盘状态，和零方案等效。这类特殊的方案不再是某个灯的单翻转，可称之为**静默方案**，简记为 $\mathbf{P}_I$。

一个 $\mathbf{A}_{\phi f}$ 的零行对应一个静默方案，计算方式为 $\mathbf{P}_{Ik}=\phi ^{-1}(\xi_k)=\mu_k \mathbf{1}_\phi ^{-1}$，也可以通过上文的对应求得。计算 $\mathbf{A}_{\phi f}$ 的全部零行，即可得到 $n ^{2}-r(\mathbf{A}_{\phi f})$ 个 $\mathbf{P}_{Ik}$。

根据鸽巢原理，由于存在静默方案，总有一些灯不存在对应的单翻转，即总有一些 $\mathbf{P}_{A|i,j}$ 不存在。这些不存在的 $\mathbf{P}_{A|i,j}$ 数量等于 $\mathbf{P}_I$ 的个数，也等于 $\mu_k$ 的个数。

对于 $[\mathbf{P}_{\phi f}|\mathbf{A}_{\phi f}]$，$r(\mathbf{A}_{\phi f})<n ^{2}$，$\mu_k$ 有 $n ^{2}-r(\mathbf{A}_{\phi f})$ 个。这个数量也等于 $\mathbf{P}_I$ 的线性无关基数量，即

$$\dim(\ker(\mathbf{A}_\phi))=n ^{2}-r(\mathbf{A}_{\phi f})$$

由于 $\mathbf{A}_{\phi f}$ 是经过高斯-若尔当消元得到的行最简形矩阵，其非零行构成 $\mathbf{A}_\phi$ 行空间的一组基，而 $\mu_k$ 对应的 $\xi_k$ 恰为 $\ker(\mathbf{A}_\phi)$ 的一组基，因此这些 $\mathbf{P}_{Ik}$ 全部线性无关。则任意静默方案 $\mathbf{P}_I$ 可表示为

$$\mathbf{P}_I=\sum\limits_{i=1}^{n ^{2}-r(\mathbf{A}_{\phi f})}c_i\xi_i\quad c_i \in \{0,1\}$$

取 $c_i=0$ 即可得到零方案。

静默方案是方程

$$\mathbf{x} \mathbf{A}_{\phi}=\mathbf{0}^{1 \times n ^{2}}$$

的解。所有解的集合是一个 $n ^{2}-r(\mathbf{A}_{\phi f})$ 维的线性空间，其中对应 $2 ^{n ^{2}-r(\mathbf{A}_{\phi f})}$ 个不同的静默方案，包括零方案。

存在静默方案的棋盘是多解的。将棋盘所有解的集合称为**解空间**，用 $S_f$ 表示。则如果存在静默方案，则棋盘的解空间

$$\mathcal{S}_f = \{ \mathbf{P}_f + \mathbf{P}_I \mid \mathbf{P}_I \in \ker(\mathbf{A}_\phi) \}$$

其中 $\mathbf{P}_f$ 为特解，通过 $[\mathbf{I}_\phi|\mathbf{A}_\phi] \Rightarrow  [\mathbf{P}_{\phi f}|\mathbf{A}_{\phi f}]$ 并将 $\mathbf{P}_{\phi f}$ 的所有行向量叠加并逆映射求得。$\mathbf{P}_f+\mathbf{P}_I$ 为通解，解的数量为 $2 ^{n ^{2}-r(\mathbf{A}_{\phi f})}$。如果不存在静默方案，则棋盘的解空间 $\mathcal{S}_f=\{\mathbf{P}_f\}$。axpokl 的视频中已经给出了计算 $r(\mathbf{A}_{\phi f})$ 的方法。

\==——**for more...**——==

> **静默偶定理** 静默操作总是包含偶数个点灯操作，即静默操作是**偶操作**。

**证明**：

设 $\mathbf{A}_\phi \in \mathbb{Z}_2^{n^2 \times n^2}$ 为所有单步对应棋盘向量化的结果，也就是 叠加法 中的 $\mathbf{A}_\phi$。由 广义可解性 的结论，取一个特解 $\mathbf{p}_f = \phi(\mathbf{P}_f)$ 满足 $\mathbf{p}_f \mathbf{A}_\phi = \mathbf{1}^{1 \times n ^{2}}$。由静默操作定义，对任意静默操作 $\mathbf{p}_I = \phi(\mathbf{P}_I)$，有 $\mathbf{p}_I \mathbf{A}_\phi = \mathbf{0}^{1 \times n ^{2}}$。

可知 $\mathbf{A}_\phi$ 就是棋盘 $\mathbf{A}$ 的邻接矩阵。由于棋盘是方棋盘，易得 $\mathbf{A}_\phi$ 是对称的，即 $\mathbf{A}_\phi^{\top}=\mathbf{A}_\phi$。故 $(\mathbf{p}_f\mathbf{A}_\phi)^{\top}=(\mathbf{1}^{1 \times n^{2}})^{\top}$，$\mathbf{A_\phi}\mathbf{p}_f^{\top}=\mathbf{1}^{n^{2}\times1}$。

计算

$$\mathbf{p}_I \mathbf{1}^{n ^{2} \times 1 }  = \mathbf{p}_I (\mathbf{A}_\phi  \mathbf{p}_f^\top) = (\mathbf{p}_I \mathbf{A}_\phi ) \mathbf{p}_f^\top = \mathbf{0}^{1 \times n^{2} }  \,\mathbf{p}_f^\top = 0.$$

而 $\mathbf{p}_I \mathbf{1}^{n^{2}\times1} = \sum_{i,j} \mathbf{P}_I(i,j)$，故操作中按钮总数为偶数。■

\==—————————==

### 灯向量法

**关联方案**

按钮影响自身周围的灯，同样地，灯也只能被自身和周围的按钮翻转。例如，$\mathbf{A}(1,1)$ 只能被 $\mathbf{P}_{1,1},\mathbf{P}_{1,2},\mathbf{P}_{2,1}$ 翻转。形式化地写作

$$(1,1) \to \{\mathbf{P}_{1,1},\mathbf{P}_{1,2},\mathbf{P}_{2,1}\}$$

归纳地，对 $\mathbf{A}(i,j)$ 有

$$(i,j) \to \{\mathbf{P}_{i,j}\}$$

称 $\{\mathbf{P}_{i,j}\}$ 为 $\mathbf{A}(i,j)$ 的**关联操作集**，包含所有 $\mathbf{A}_{i,j}$ 的**关联单步**。由于操作线性性，不妨设 $\mathbf{A}_{i,j}$ 的**关联方案**为

$$\mathbf{P}_{A (i,j)}=\sum\limits_{(k,l)\in \{\mathbf{P}_{ i,j}\}}\mathbf{P}_{k,l}$$

需要注意 $\mathbf{P}_{A(i,j)} \ne \mathbf{P}_{A|i,j}$，等号成立当且仅当 $\mathbf{A}_{i,j}$ 只有一个关联单步，这种情况在点灯游戏中不存在。

**灯向量**

为了一次处理所有情况，同叠加法，构造映射

$$\begin{array} \\ \phi: \mathbb{Z}_2^{n} \to \mathbb{Z}_2^{n ^{2}} \\ \phi(i,j) = n(i-1)+j \\ \\ \phi (\mathbf{P}_{i,j}(k,l)) = \mathbf{P}_{\phi(i,j)}^{1 \times n ^{2}}(\phi(k,l)) \\ \phi(\{\mathbf{P}_{A(i,j)}\})=\mathbf{P}_\phi \\ \phi(\mathbf{A}_{i,j}(k,l)) = \lambda ^{1 \times n ^{2}}(\phi(k,l)) \end{array}$$

\==——**for more...**——==

此处的映射 $\phi$ 与叠加法中的性质相同。

\==—————————==

其中 $\lambda$ 称为**灯向量**。

因为对应关系同构 $(\mathbf{A}_{i,j} \to \mathbf{P}_{A(i,j)}) \Rightarrow (\lambda(\phi(i,j)) \to \mathbf{P}_{\phi(i,j)})$，$\mathbf{P}_\phi$ 的每个行向量 $\mathbf{P}_{\phi(i,j)}$ 关联 $\mathbf{A}(i,j)$ 的状态，也就是 $\lambda$ 第 $(i,j)$ 个格。$\mathbf{A}_{i,j}$ 的关联方案从初态导出一个棋盘，仅取结果中 $\mathbf{A}(i,j)$ 的状态，其余均舍去。写成公式就是

$$\mathbf{P}_{A(i,j)}\mathbf{A}_0(i,j)=\lambda(n(i-1)+j)$$

$\mathbf{P}_\phi$ 的每个列向量表示第 $n(i-1)+j$ 个按钮可以对哪些格的灯产生影响。例如，

$$\mathbf{P}_\phi =\begin{pmatrix}     1 & 1 & 1 & 0 \\     1 & 1 & 0 & 1 \\     1 & 0 & 1 & 1 \\   0 & 1 & 1 & 1 \\   \end{pmatrix}, \lambda =\begin{pmatrix}     1 \\     1 \\     1 \\   1 \\ \end{pmatrix}$$

第一行表示对棋盘应用

$$\begin{pmatrix}     1 & 1 \\     1 & 0   \end{pmatrix}_{\mathbf{P}}$$

$\mathbf{A}(1,1)$ 将改变状态，第一列表示 $p(1,1)$ 给 $\mathbf{A}(1,1),\mathbf{A}(1,2),\mathbf{A}(2,1)$ 贡献 $1$ **操作计数**。

**奇翻转与偶翻转**

考虑**解向量**$\mathbf{x}^{n ^{2} \times 1}$，$\mathbf{x}(k)=1$ 表示选取 $\mathbf{P}_\phi$ 中第 $k$ 列对应的点灯操作，$0$ 表示不选。$\mathbf{P}\mathbf{x}$ 产出一个向量，可知 $\mathbf{P}\mathbf{x}=\lambda$，$\lambda(k)$ 代表方案的翻转操作在 $\lambda(k)$ 对应灯的操作计数和模 $2$。即

$$\mathbf{P}_\phi (n(i-1)+j)\mathbf{x} \equiv\sum\limits_{j=1}^{n ^{2}}\mathbf{P}_\phi^\top (i,j)\mathbf{x}(j)$$

若 $\mathbf{P}_\phi\mathbf{x} (i)\equiv 0$，称方案对 $\mathbf{A}(i,j)$ **偶翻转**，若 $\mathbf{P}_\phi\mathbf{x} (i)\equiv 1$，称方案对 $\mathbf{A}(i,j)$ **奇翻转**。根据目标，$\mathbf{P}_f$ 需要对每格灯奇翻转。构建方程

$$\begin{cases} \sum\limits_{j}\mathbf{P}_\phi^\top(1,j) \mathbf{x}(j) = 1 \\ \sum\limits_{j}\mathbf{P}_\phi^\top(2,j) \mathbf{x}(j) = 1 \\ \vdots \\ \sum\limits_{j}\mathbf{P}_\phi^\top(n ^{2},j) \mathbf{x}(j) = 1 \end{cases}$$

改写为矩阵形式

$$\begin{array} \\ \mathbf{P}_\phi ^\top\mathbf{x}^\top=\lambda ^\top,\lambda ^\top=\mathbf{1}^{n ^{2} \times 1} \\ (\mathbf{x}\mathbf{P}_\phi ) ^\top=\lambda ^\top \\ \mathbf{x} \mathbf{P}_\phi=\lambda \end{array}$$

对应消元过程为

$$[\; \mathbf{P}_\phi \mid \mathbf{1}^{n^{2}\times 1 }  \;] \xrightarrow{\text{Gauss‑Jordan}} [\; \mathbf{P}_{\phi f} \mid \lambda _f \;]$$

故 $\lambda _f$ 为解向量，有

$$\mathbf{P}_f=\phi ^{-1}(\mathbf{\lambda}_f)$$

\==——**for more...**——==

将表述换为 $\sum\limits_{j=1}^{n ^{2}}\mathbf{x}(j)\mathbf{P}_\phi^\top (i,j)$，同时增广矩阵的解释换为同时右乘 $(\mathbf{P}^\top)^{-1}$，结论同样成立。另外，灯向量法的 $\mathbf{P}_\phi$ 是叠加法中 $\mathbf{P}_\phi$ 的转置。

$\mathbf{P}_{\phi f}$ 不满秩时表现出与叠加法中静默方案类似的行为。此时 $\mathbf{P}_\phi ^{-1}$ 应视为伪逆，方程组存在自由变量，解不唯一。棋盘的解空间维度为 $n ^{2}-r(\mathbf{P}_\phi )$，$\mathbf{P}_{\phi f}$ 中的每个零行对应一个 $\phi (\mathbf{P}_I)$，满足

$$\phi (\mathbf{P}_I)\mathbf{P}_\phi =\mathbf{0}^{1 \times n ^{2}}$$

解空间形式与叠加法中的一致。

灯向量法 $\mathbf{P}_{\phi f}$ ​的不满秩分析与叠加法中 $\mathbf{A}_\phi$ 不满秩的情况类似，可参照静默方案相关部分自行推导和验证。

\==—————————==

灯向量法的时间复杂度组成：

1.  **向量化棋盘**：$O(n ^{2} \cdot n ^{2})=O(n ^{4})$
2.  **解方程**：$O(n ^{6})$
    1.  **消元每步对应**：操作 $\mathbf{P}_\phi$ 后同步更新 $\lambda$，单步至多计算 $2 (n^{2}+1)$ 个元素，复杂度 $O(n ^{2})$
3.  **逐行计数**：$O(n ^{2}\cdot n ^{2})=O(n ^{4})$
4.  **解向量逆映射**：$O(n ^{2})$

故时间复杂度为 $O(n ^{6})$。虽然时间复杂度与叠加法相同，但消元每步对应的常数因子大约是叠加法的一半，也即计算量比叠加法少了约一半。

### 首行叠加法

**反方案**

在开始之前，为简便讨论，定义

$$\neg \mathbf{P}=\mathbf{1}-\mathbf{P}$$

称 $\neg \mathbf{P}$ 为 $\mathbf{P}$ 的**反方案**，简称 $\mathbf{P}$ 的**反**。

以下证明两个重要性质。

> **反半分配定理** 方案线性组合的反等于其中一个方案的反与其余方案的线性组合。

**证明**：

设 $\mathbf{P}_1, \mathbf{P}_2, \dots, \mathbf{P}_n$ 为任意方案，有

$$\begin{array} \\ \neg (\mathbf{P}_1+\mathbf{P}_2)=\mathbf{1}-(\mathbf{P}_1+\mathbf{P}_2)=(\mathbf{1}-\mathbf{P}_1)+\mathbf{P_2}=\neg \mathbf{P}_1+\mathbf{P}_2 \\ \neg (\mathbf{P}_1+\mathbf{P}_2)=\mathbf{1}-(\mathbf{P}_1+\mathbf{P}_2)=(\mathbf{1}-\mathbf{P}_2)+\mathbf{P_1}=\mathbf{P}_1+\neg \mathbf{P}_2 \end{array}$$

令 $\mathbf{P}_1'=\mathbf{P}_1+\mathbf{P}_2,\mathbf{P}_2'=\mathbf{P}_3$，可得类似等式。重复操作，归纳可得定理。■

> **反分配定理** $\neg (\sum\limits_i \mathbf{P}_i)=\sum\limits_i (\neg \mathbf{P}_i) +  (i+1 \mod 2)\mathbf{1}$

**证明**：

设 $\mathbf{P}_1, \mathbf{P}_2, \dots, \mathbf{P}_n$ 为任意方案，有

$$\begin{align} \neg (\mathbf{P}_1+\mathbf{P}_2) &= \mathbf{1}-\mathbf{P}_1-\mathbf{P}_2 \\ &= \mathbf{1}-\mathbf{P}_1+\mathbf{1}-\mathbf{P}_2-\mathbf{1} \\ &= \neg \mathbf{P}_1+\neg \mathbf{P}_2 +\mathbf{1}\\ \neg (\mathbf{P}_1+\mathbf{P}_2+\mathbf{P}_3) &= \mathbf{1}-(\mathbf{P}_1+\mathbf{P}_2+\mathbf{P}_3) \\ &= \mathbf{1}-\mathbf{P}_1+\mathbf{1}-\mathbf{P}_2+\mathbf{1}-\mathbf{P}_3 \\ &= \neg \mathbf{P}_1+\neg \mathbf{P}_2+\neg \mathbf{P}_3+(2)\mathbf{1} \\ &= \neg \mathbf{P}_1+\neg \mathbf{P}_2+\neg \mathbf{P}_3 \end{align}$$

归纳可得，在 $\neg (\sum\limits_i \mathbf{P}_i)$ 中，若 ${i}$ 为偶数，产生奇数个 ${\mathbf{1}}$ ；若 ${i}$ 为奇数，产生偶数个 ${\mathbf{1}}$。形式化可得定理。■

\==——**for more...**——==

反运算还满足以下性质，读者可自行证明：

1.  $\neg (\neg \mathbf{P})=\mathbf{P}$，即运算对合。
2.  $\mathbf{P}+\neg \mathbf{P}=\mathbf{1}$ 对于矩阵加
3.  $(\neg \mathbf{P} ) \odot \mathbf{P}=\mathbf{0}$ 对于 Hadamard 积

\==—————————==

**关联向量**

根据首行穷举法，一行按钮的状态依赖于上一行。那么，能否把叠加法与逐行递推组合起来呢？

在首行穷举法中，点灯方案始终符合 $\mathbf{A}(i,j)+\mathbf{P}(i+1,j)=1$。那么给定 $\mathbf{A}(i,j)$，即可推出 $\mathbf{P}(i+1,j)$。进而，每一行都由更上一行推定，即可建立一个从第一行到最后一行的对应关系，即映射 $\varphi :\mathbf{P}(1,:) \to \mathbf{A}(n,:)$。

按首行穷举法操作，可保证第 $2$ 行到第 $n-1$ 行全亮。由于第一行与最后一行的对应关系，只需要找到特定的第一行，使得最后一行灯全亮，解就可以直接通过递推生成出来。形式化地说，只需要找到满足 $\varphi (\mathbf{P}_f(1,:))=\mathbf{1}^{1 \times n}$ 的 $\mathbf{P}_f(1,:)$，即可推导出整个 $\mathbf{P}_f$。

在首行穷举法中，$\mathbf{A}(i,j)+\mathbf{P}(i+1,j)=1$，可得 $\mathbf{P}(i+1,j)=1-\mathbf{A}(i,j)=\neg\mathbf{A}(i,j)$。$\mathbf{A}(2,1)$ 的关联方案

$$\mathbf{P}_{A(2,1)}=\begin{pmatrix}     1 & 0 & 0 \\     1 & 1 & 0 \\     1 & 0 & 0   \end{pmatrix}$$

根据首行穷举，只需要考虑第 $1$ 行到第 $2$ 行的操作。那么 $\mathbf{A}(2,1)$ 关联 $\mathbf{P}_{A(2,1)}(2,1),\mathbf{P}_{A(2,1)}(2,2),\mathbf{P}_{A(2,1)}(1,1)$，前两者由相关的灯得到，而相关的灯又关联其关联方案的部分。

可以发现，对于 $\mathbf{A}(i,j)$ 的关联矩阵，只需要考虑第 $i$ 行和第 $i-1$ 行。灯关联的方案由操作的关联方案得到，而操作的关联方案又从灯关联的方案得到。

更一般地，定义 $\mu^{1 \times n}$ 为**关联向量**，简称**关联**。 $\mathbf{A}(i,j)$ 的关联向量是 $\mu_{A(i,j)}$，$\mathbf{P}(i,j)$ 的关联向量是 $\mu_{P(i,j)}$。关联向量满足

$$\begin{align} \mu_{P(1,j)} &= \mathbf{P}_{1,j}(1,:) \\ \mu_{A(i,j)} &= \mu_{P(i,j)}+\mu_{P(i,j-1)}+\mu_{P(i,j+1)}+\mu_{P(i-1,j)} \\ \mu_{P(i+1,j)} &= \neg \mu_{A(i,j)} \end{align}$$

超出边界的 $\mu$ 视为 $\mathbf{0}$。

**行递推**

由于 $\mu_{P(i+1,j)}=\neg \mu_{A(i,j)}$，每取一次反，这个按钮的关联方案和灯就差一次翻转。又因为 $\neg (\neg \mathbf{P})=\mathbf{P}$，两次翻转等于没有翻转。所以在递推 $\mu$ 时，需要同步给每个 $\mu$ 记录一个信息，可以称之为**偏置**。偏置在每次取反时加 $1$，表示相应 $\mu$ 和正确翻转状态的关系。偏置为 $1$ 表示 $\mu$ 还需要再翻转一次才是正确状态，偏置为 $0$ 则表示 $\mu$ 就是正确状态。

由于取反带来偏置，$\varphi$ 映射后的影响是递推关系和偏置的叠加。偏置是根据 $\mu_A$ 计算下一行的 $\mu_P$ 带来的，递推关系只有加法，所以递推关系是线性的。进而，可以形式化地写出

$$\varphi (\mathbf{x})=L(\mathbf{x})+\delta$$

其中 $\mathbf{x}$ 是某个关联向量，${L}$ 是线性关系，$\delta$ 是偏置。

我们需要求线性关系和偏置的表达式。有

$$\begin{cases} \varphi (\mu_{P(1,1)})=L(\mu_{P(1,1)})+\delta & \mu_{P(1,1)}=\begin{pmatrix} 1 & 0 & \dots \end{pmatrix}\\ \varphi (\mu_{P(1,2)})=L(\mu_{P(1,2)})+\delta & \mu_{P(1,2)}=\begin{pmatrix} 0 & 1 & \dots \end{pmatrix}\\ \vdots \\ \varphi (\mu_{P(1,n)})=L(\mu_{P(1,n)})+\delta & \mu_{P(1,n)}=\begin{pmatrix} \dots & 0 & 1 \end{pmatrix}\\ \end{cases}$$

写成矩阵形式

$$\varphi (\mathbf{I})=L(\mathbf{\mathbf{I}})+\lambda$$

其中 $\lambda$ 为**偏置列**，$\lambda(k)$ 表示 $\mu_{A(n,k)}$ 的偏置。

由于 $L(x)=\mathbf{M}x^\top$，$\varphi (\mathbf{I})=\mathbf{M}\mathbf{I}^\top+\lambda =\mathbf{M}+\lambda$，所以

$$\mathbf{M}=\varphi(\mathbf{I})-\lambda$$

又有 $\varphi (\mathbf{0})=\mathbf{M}\mathbf{0}^\top+\lambda =\lambda$，所以

$$\varphi (\mathbf{x})=(\varphi (\mathbf{I})-\lambda )\mathbf{x}+\varphi (\mathbf{0})$$

因为 $\varphi(\mathbf{P}_f(1,:))=\mathbf{1}$，

$$\begin{align} \\ (\varphi(\mathbf{I})-\lambda ) \mathbf{P}_f(1,:)^\top+\lambda &= \mathbf{1} \\ (\varphi(\mathbf{I})-\lambda ) \mathbf{P}_f(1,:)^\top &= \mathbf{1}-\lambda \\ (\varphi(\mathbf{I})-\lambda ) \mathbf{P}_f(1,:)^\top &= \neg \lambda  \end{align}$$

\==——**for more...**——==

计算 $\varphi$ 的过程，即首行穷举法中进行的过程，通常称为 chasing light。

考虑 $\mathbf{P}(i+1,j) = 1 - \mathbf{A}(i,j)$。在 $\mathbb{Z}_2$ 中 $-1\equiv 1$，故

$$\mathbf{P}(i+1,j) = \mathbf{A}(i,j) + 1$$

推广到行有

$$\mathbf{P}(i+1,:) = \mathbf{A}(i,:) + \mathbf{1}^{1\times n}$$

考虑 $\mathbf{A}(i+1,:)$，其影响源于 $\mathbf{P}(i,:)$ 和 $\mathbf{P}(i+1,:)$。形式化为

$$\begin{align} \mathbf{A}(i+1, j) = \mathbf{A}_0(i+1, j) &+ \sum\limits_{k} \mathbf{P}(i, k) \cdot \mathbf{K}_{i,k}(i+1, j) \\ &+ \sum\limits_{k} \mathbf{P}(i+1, k) \cdot \mathbf{K}_{i+1,k}(i+1, j) \end{align}$$

点灯核的形状是十字型，只有上下左右和自身有影响。因此 $\mathbf{K}_{i,k}(i+1, j)$ 非零仅当 $k=j$，$\mathbf{K}_{i+1,k}(i+1, j)$ 非零仅当 $k=j$ 或 $k=j\pm 1$。令**补零棋盘**

$$\mathbf{A}'(x,y) = \begin{cases}\mathbf{A}(x,y) & \text{if } 1 \le x,y \le n, \\ 0 & \text{otherwise}. \end{cases}$$

代替棋盘进行运算，运算结果仅取棋盘尺寸的部分，其余均舍去。在补零棋盘中，无需关注边界条件，则总有

$$\begin{align} \mathbf{A}(i+1, j) \equiv \mathbf{A}_0(i+1, j) &+ \mathbf{P}(i, j) + \mathbf{P}(i+1, j)  \\ &+ \mathbf{P}(i+1, j-1) + \mathbf{P}(i+1,j+1)\end{align}$$

代入 $\mathbf{P}(i+1, j) = \neg\mathbf{A}(i, j)$，也就是 $\mathbf{P}(i+1, j) = \mathbf{A}(i, j) + 1$：

$$\begin{align} \mathbf{A}(i+1, j) = \mathbf{A}_0(i+1, j) &+ \mathbf{P}(i, j) + (\mathbf{A}(i, j) + 1) \\ & + (\mathbf{A}(i, j-1) + 1) + (\mathbf{A}(i, j+1) + 1) \\ \equiv \mathbf{A}_0(i+1, j) &+ \mathbf{P}(i, j)+\mathbf{A}(i, j)  \\ &+  \mathbf{A}(i, j-1) + \mathbf{A}(i, j+1) + (3)1 \end{align}$$

其中 $\mathbf{A}_0(i+1,j),\mathbf{P}(i,j),\mathbf{A}(i,:)$ 已知。由于存在常数项 $1$，该递推关系是**仿射**的。由于每一步都是仿射变换，复合后 $\varphi$ 也是仿射映射。即

$$\varphi(\mathbf{x}) = \mathbf{L}\mathbf{x}^\top  + \lambda$$

其中 $\mathbf{L}\mathbf{x}^\top$ 是线性映射，$\lambda=\varphi(\mathbf{0})$ 为常数向量。由线性性，$\mathbf{L}$ 可由标准基下的像确定，即

$$\mathbf{L} = \varphi(\mathbf{I}) - \lambda$$

于是

$$\varphi(\mathbf{P}(1,:)) = \sum_{j} \mathbf{P}(1,j) \bigl(\varphi(\mathbf{I}(j,:))-\lambda\bigr) + \lambda$$

目标为 $\varphi(\mathbf{P}(1,:)) = \mathbf{1}^{1\times n}$，即

$$\sum_{j} \mathbf{P}(1,j) \bigl(\varphi(\mathbf{I}(j,:))-\lambda \bigr) = \mathbf{1} - \lambda$$

矩阵形式

$$\varphi (\mathbf{I}-\lambda )\mathbf{P}(1,:)=\neg \lambda$$

每个 $\mathbf{P}(1,:)$ 唯一确定一个 $\varphi(\mathbf{P}(1,:))$。$\varphi$ 未必是双射，因为可能有多个解。当系数矩阵可逆时，只有一个 $\mathbf{P}_f$，则 $\varphi$ 是双射。若不可逆，则 $\varphi$ 将所有 $\mathbf{P}_f(1,:)$ 映射到 $\mathbf{A}_f(n,:)$，不是双射。

\==—————————==

关联向量的定义揭示了依赖关系。倒过来，即可得出计算 $\varphi (\mathbf{P}(1,:))$ 的方法。按以下步骤循环执行：

1.  $i=1$
2.  $j=1$
    1.  计算 $\mu_{P(i,j)} = \neg \mu_{A(i,j)}$
    2.  $j \leftarrow j+1$
    3.  若 $j=n$，结束本层循环，否则跳回第 1 步
3.  $j=1$
    1.  计算 $\mu_{A(i,j)}=\mu_{P(i,j)}+\mu_{P(i,j-1)}+\mu_{P(i,j+1)}+\mu_{P(i-1,j)}$
    2.  $j \leftarrow j+1$
    3.  若 $j=n$，结束本层循环，否则跳回第 1 步
4.  $i \leftarrow i+1$
5.  若 $i=n$，结束本层循环，否则跳回第 2 步

以 $3 \times3$ 的 $\mu$ 递推举例：

```text
P01=000,0  P02=000,0  P03=000,0
P11=100,0  P12=010,0  P13=001,0
A11=P11+P12=110,0  A12=P11+P12+P13=111,0  A13=P12+P13=011,0
P21=1-A11=110,1  P22=1-A12=111,1  P23=1-A13=011,1
A21=P21+P22+P11=101,0  A22=P22+P21+P23+P12=000,1  A23=101,0
P31=101,1  P32=000,0  P33=101,1
A31=011,0  A32=111,1  A33=110,0
```

最后得到

```text
A31=011,0  A32=111,1  A33=110,0
```

写为矩阵形式

```text
011  0
111  1
110  0
```

方阵是 $\varphi(\mathbf{I})-\lambda$，列向量是 $\neg\lambda$。方阵和列向量构成一个增广矩阵，消元过程为

$$[\; \varphi(\mathbf{I})-\lambda  \mid \neg\lambda \;] \xrightarrow{\text{Gauss}} [\; \mathbf{U} \mid \mathbf{P}_f(1,:) \;]$$

解方程的过程

$$\begin{align} (\varphi(\mathbf{I})-\lambda ) \mathbf{P}_f(1,:)^\top &= \neg \lambda \\ \mathbf{P}_f(1,:)^\top &= \neg \lambda (\varphi (\mathbf{I})-\lambda )^{-1}  \end{align}$$

\==——**for more...**——==

首行叠加法依旧有不满秩的情况，不再赘述。

\==—————————==

首行叠加法的时间复杂度组成：

1.  **计算** $\varphi (\mathbf{I})-\lambda$ 和 $\neg\varphi(\mathbf{0})$：$O(n ^{2} \cdot n)=O(n ^{3})$
2.  **高斯消元**：$O(n ^{3})$
3.  **行递推**：$O(n ^{2})$

故时间复杂度为 $O(n ^{3})$。

### 扩散法

**扩散算子**

在首行叠加法中，我们通过求 $\varphi(\mathbf{I})-\lambda$ 的逆来求解，这是一个 $n \times n$ 的矩阵。实际上，这个矩阵的计算还可以压缩。

$\mu_{P(n,\cdot)}$ 展开来，就是一系列加和。以 $\mu_{A(3,\cdot)}$ 举例，省略取反带来的偏置：

```text
A31 = P31+P32+P21
    ~ (P21+P22+P11)+(P21+P22+P23+P12)+P21
    ~ ((P11+P12)+(P11+P12+P13)+P11)+((P11+P12)+(P11+P12+P13)+(P12+P13)+P12)+(P11+P12)

A32 = P32+P31+P33+P22
    ~ (P22+P21+P23+P12)+(P21+P22+P11)+(P23+P22+P13)+P22
    ~ ((P11+P12+P13)+(P11+P12)+(P12+P13)+P12)+((P11+P12)+(P11+P12+P13)+P11)+((P12+P13)+(P11+P12+P13)+P13)+(P11+P12+P13)

A33 = P33+P32+P23
    ~ (P23+P22+P13)+(P22+P21+P23+P12)+(P12+P13)
    ~ ((P12+P13)+(P11+P12+P13)+P13)+((P11+P12+P13)+(P11+P12)+(P12+P13)+P12)+(P12+P13)
```

能看出，$\mathbf{P}(1,j)$ 对 $\mathbf{A}(n,j)$ 的影响有两个途径：

1.  点灯核的扩散
2.  取反，即向下传递

对于途径 1，在当前行，每次递推，点灯核向左右扩散一格。形式化为算子 ${H}$，满足 $H\mathbf{v}(i)=\mathbf{v}(i-1)+\mathbf{v}(i)+\mathbf{v}(i+1)$，边界外视为 ${0}$。

对于途径 2，取反影响偏置，但不影响线性递推，所以相当于式子后面 $+\mathbf{1}$。

根据关联向量的性质

$$\begin{align} \mu_{P(1,j)} &= \mathbf{P}_{1,j}(1,:) \\ \mu_{A(i,j)} &= \mu_{P(i,j)}+\mu_{P(i,j-1)}+\mu_{P(i,j+1)}+\mu_{P(i-1,j)} \\ \mu_{P(i+1,j)} &= \neg \mu_{A(i,j)} \end{align}$$

给定第一行按钮 $\mathbf{P}(1,:)=\mathbf{p}_1$ 时，第一行灯 $\mathbf{a}_1$ 仅受自身和邻居的影响，所以

$$\mathbf{a}_1=H\mathbf{p}_1$$

由于 $\mu_{P(i+1,j)}=\neg \mu_{A(i,j)}$：

$$\mathbf{p}_2=\mathbf{a}_1+\mathbf{1}$$

继续推导

$$\begin{array} \\ \mathbf{a}_2 = H\mathbf{p}_2+\mathbf{p}_1 \\ \mathbf{p}_3 = \mathbf{a}_2+\mathbf{1} \\ \mathbf{a}_3 = H\mathbf{p}_3+\mathbf{p}_2 \\ \mathbf{p}_4 = \mathbf{a}_3+\mathbf{1} \\ \dots  \end{array}$$

归纳得

$$\begin{array} \\ \mathbf{p}_0=\mathbf{0} \\ \mathbf{a}_i=H\mathbf{p}_i+\mathbf{p}_{i-1} \\ \mathbf{p}_i=\mathbf{a}_{i-1}+\mathbf{1} \\ \end{array}$$

分离线性主部

$$\mathbf{a}_i=L_i(\mathbf{p}_1)+c_i$$

其中 $L_i(\mathbf{p}_1)$ 是只有 $\mathbf{p}_1$ 的算子表达式；$c_i$ 是只有 $\mathbf{1}$ 的算子表达式，是一个常数向量。

比较系数

$$\begin{align} \mathbf{a}_1  &= H\mathbf{p}_1 \iff \mathbf{a}_1 = L_1(\mathbf{p}_1)+c_1 \\ \mathbf{a}_2  &= H\mathbf{p}_2 +\mathbf{p}_1 \\ &= H(L_1(\mathbf{p}_1)+c_1+\mathbf{1})  \\ &\quad + L_0(\mathbf{p}_1) + c_0 \iff \mathbf{a}_2=L_2(\mathbf{p}_1)+c_2 \\ \mathbf{a}_n &= H(\mathbf{a}_{n-1}+\mathbf{1})+(\mathbf{a}_{n-2}+\mathbf{1}) \\ &\quad \iff\mathbf{a}_n=L_n(\mathbf{p}_1)+c_n \end{align}$$

得到递推关系

$$\begin{cases}  L_0=I \\ L_1=H \\ L_i=HL_{i-1}+L_{i-2} \quad (i\ge 2)\\ c_0=0 \\ c_1=0 \\ c_i=Hc_{i-1}+c_{i-2}+H\mathbf{1} \end{cases}$$

$L$ 是一个 $\mathbb{Z}_2$ 的 Fibonacci 递推 $f(H)$ 的结果。${f}$ 定义为

$$\begin{cases}  f_0(x)=1 \\ f_1(x)=x \\ f_n(x)=xf_{n-1}(x)+f_{n-2}(x) & (n \ge 2) \end{cases}$$

\==——**for more...**——==

$c$ 与谢尔宾斯基三角形有关，满足

$$c_i = \sum_\limits{k=0}^{i-2} \binom{i-1}{k}_2\ H^{i-1-k}\mathbf{1}$$

其中 $\binom{i-1}{k}_2$ 是二项式系数模 2，由卢卡斯定理得到。

\==—————————==

进而有

$$\begin{array} \\ \begin{cases}  \varphi (\mathbf{x} )=L_n(\mathbf{p}_1)+c_n \\ \varphi (\mathbf{P}_f(1,:))=\mathbf{1} \end{cases} \\ \Downarrow \\ L_n(\mathbf{p}_1)+c_n=\mathbf{1} \\ L_n(\mathbf{p}_1)=\mathbf{1}-c_n=\neg c_n \end{array}$$

**零化多项式**

$H$ 在标准基下的矩阵表示是 $\mathbf{H}$。$\mathbf{H}$ 是一个三对角矩阵，主对角线和次对角线的元素均为 ${1}$，其余为 ${0}$。记 $\mathbf{H}$ 的特征多项式

$$p_n (x) =\det (x \mathbf{I}-\mathbf{H})$$

按拉普拉斯展开，结合 $\mathbb{Z}_2$ 域上的性质可得

$$\begin{cases} p_0(x)=1 \quad (\det(\mathbf{H}^{0 \times 0})=1) \\ p_1(x)=x+1 \\ p_n(x)=(x+1)\, p_{n-1}(x) + p_{n-2}(x)\quad (n\ge 2) \\ \end{cases}$$

比对可得 $p_n(x)=f_n(x+1)$。代入矩阵时，${1}$ 要变成 $\mathbf{I}$，由 Cayley‑Hamilton 定理

$$\begin{align} p_n(\mathbf{H}) &= \mathbf{0} \\ p_n(\mathbf{H}) &= f_n(\mathbf{H}+\mathbf{I}) \\ f_n(\mathbf{H}+\mathbf{I}) &=\mathbf{0} \end{align}$$

\==——**for more...**——==

在 [axpokl 的文章](https://zhuanlan.zhihu.com/p/53646257)中，使用的算子是 $\mathbf{H}-\mathbf{I}$ 而非 $\mathbf{H}$。此时零化关系是 $f_n(\mathbf{H})=\mathbf{0}$，要求 $f_n(\mathbf{H}+\mathbf{I})$，其余性质依然成立。读者可自行推导验证。

\==—————————==

**拓展欧几里得**

$\varphi (\mathbf{x})=(\varphi (\mathbf{I})-\lambda )\mathbf{x}+\varphi (\mathbf{0})$，比对可得 $f_n(\mathbf{H})=\varphi(\mathbf{I})-\lambda$，$\neg c_n=\neg \varphi(\mathbf{0})$。所以首行叠加法的方程变为

$$f_n(\mathbf{H})\mathbf{p}_1=\neg \varphi (\mathbf{0})$$

我们希望找到 $f^{-1}_n(\mathbf{H})$，使 $f^{-1}_n(\mathbf{H})f_n(\mathbf{H})=\mathbf{I}$。利用 $f_n(\mathbf{H}+\mathbf{I})=\mathbf{0}$，对 $p_n(x)=f_n(x+1)$ 和 $f_n(x)$ 做拓展欧几里得，找到多项式 $a(x),b(x)$ 使得

$$a(x)f_n(x+1)+b(x)f_n(x)=\gcd (f_n(x),f_n(x+1))$$

$\gcd (f_n(x),f_n(x+1))$ 是 $f_n(x)$ 和 $f_n(x+1)$ 的最大公因式。记 $g(x)=\gcd (f_n(x),f_n(x+1))$，令 $x=\mathbf{H}$，则 $f_n(\mathbf{H}+\mathbf{I})=\mathbf{0}$，方程变为

$$b(\mathbf{H})f_n(\mathbf{H})=g(\mathbf{H})$$

方程 $f_n(\mathbf{H})\mathbf{p}_1=\neg \varphi (\mathbf{0})$ 两边左乘 $b(\mathbf{H})$：

$$g(\mathbf{H})\mathbf{p}_1=b(\mathbf{H})\neg \varphi (0)$$

\==——**for more...**——==

$\deg b<\deg f_n$，之后的运算在商环 $\mathbb{F}_2[x]/(f_n(x))$ 中运行。

\==—————————==

如果 $g(x)=1$，则 $f_n(x),f_n(x+1)$ 互质，

$$a(x)f_n(x+1)+b(x)f_n(x)=\gcd (f_n(x),f_n(x+1))$$

代入矩阵得 $g(\mathbf{H})=\mathbf{I}$，回代得 $b(\mathbf{H})f_n(\mathbf{H})=\mathbf{I}$。所以 $b(\mathbf{H})=f^{-1}_n(\mathbf{H})$，方程 $f_n(\mathbf{H})\mathbf{p}_1=\neg \varphi (\mathbf{0})$ 两边左乘 $f_n^{-1}(\mathbf{H})$ 得

$$\mathbf{p}_1=f_n^{-1}(\mathbf{H})\neg\varphi(\mathbf{0})$$

对应算法：

1.  $\mathbf{p}_1=\mathbf{0}$，$b(x)=\sum\limits_{k=0}^{m}\beta_kx^{k}\quad(\beta_k \in \{0,1\})$，$\mathbf{v}=\neg \varphi(\mathbf{0})$
2.  $k=0$
    1.  如果 $\beta_k=1$，$\mathbf{p}_1=\mathbf{p}_1+\mathbf{v}$，否则什么也不做。
    2.  $\mathbf{v} \leftarrow \mathbf{H}\mathbf{v}$
    3.  $k \leftarrow k+1$
    4.  若 $k=m$，结束本层循环，否则跳回第 1 步

得到的 $\mathbf{p}_1=\mathbf{P}_f(1,:)$。

循环中的第 2 步是 $O(n)$，棋盘大小为 $n$，扩散作用两遍，最多不超过 $n^{2}$，所以是 $O(n^{2})$。

扩散法的时间复杂度组成：

1.  **计算** $\neg \varphi(\mathbf{0})$：$O(n^{2})$
2.  **计算** $f_n^{-1}(\mathbf{H})\neg\varphi(\mathbf{0})$：$O(n ^{2})$
3.  **行递推**：$O(n ^{2})$

整体复杂度降到了 $O(n^{2})$。

### \*奇异矩阵

在扩散法中，如果 $g(x)\ne1$，意味着 $f_n(\mathbf{H})=\varphi(\mathbf{I})-\lambda$ 是奇异矩阵。

方程

$$g(\mathbf{H})\mathbf{p}_1=b(\mathbf{H})\neg \varphi (\mathbf{0})$$

中的 $g(\mathbf{H})$ 就没法简单消掉了，但对比原方程 $f_n(\mathbf{H})\mathbf{p}_1=\neg \varphi (\mathbf{0})$，我们还是把 $f_n(\mathbf{H})$ 换成了更好求的 $g(\mathbf{H})$。

首先算 $\mathbf{c}=b(\mathbf{H})\neg \varphi(\mathbf{0})$，算法：

1.  $\mathbf{c}=\mathbf{0}$，$b(x)=\sum\limits_{k=0}^{m}\beta_kx^{k}\quad(\beta_k \in \{0,1\})$，$\mathbf{v}=\neg \varphi(\mathbf{0})$
2.  $k=0$
    1.  如果 $\beta_k=1$，$\mathbf{c}=\mathbf{c}+\mathbf{v}$，否则什么也不做。
    2.  $\mathbf{c} \leftarrow \mathbf{H}\mathbf{c}$
    3.  $k \leftarrow k+1$
    4.  若 $k=m$，结束本层循环，否则跳回第 1 步

接下来解线性系统

$$g(\mathbf{H})\mathbf{p}_1=\mathbf{c}$$

的一个特解 $\mathbf{p}_{1f}$。$\mathbf{H}$ 是带状矩阵，$\mathbf{H}^k$ 仍然是带状矩阵，$g(\mathbf{H})$ 是关于 $\mathbf{H}$ 的多项式，故而 $g(\mathbf{H})$ 是带状矩阵，且带宽 $2m+1 \quad(m<n)$。${g}$ 是 ${f}$ 的最大公因式，${f}$ 是线性的，保持 Toeplitz 结构，故而 ${g}$ 保持 Toeplitz 结构。$\mathbf{H}$ 是 Toeplitz，所以 $g(\mathbf{H})$ 是 Toeplitz。

${n}$ 较小时，可以用带状高斯消元。${n}$ 增大后，可以用 Levinson-Durbin 递归，DST，FFT 等方法求解，整体不超过 $O(n^{2})$。

在线性系统上，$n-\deg g$ 即自由度的数量，也即静默操作的数量。求得特解后，可将特解与所有静默操作结合，即解集 $\{\mathbf{P}_f+\mathbf{P}_I\}$。

对应扩散法的时间复杂度组成：

1.  **计算** $\neg \varphi(\mathbf{0})$：$O(n^{2})$
2.  **计算** $\mathbf{c}=b(\mathbf{H})\neg \varphi(\mathbf{0})$：$O(n^{2})$
3.  **解** $g(\mathbf{H})\mathbf{p}_1=\mathbf{c}$：$O(n ^{2})$
4.  **行递推**：$O(n ^{2})$

整体复杂度还是 $O(n^{2})$。

## 非全暗的初始状态

如果初始状态并非全暗，我们修改算法对应判定条件，再继续计算即可。

## \*广义点灯游戏

### 定义

设一个**棋盘**是一个**有限简单无向图** $L=(V,E)$，其中 $V \subset \mathbb{Z}^{2}$，每个顶点 $v$ 对应一个整数坐标 $(x_v,y_v)$；$E$ 是边集，定义为

$$E=\{uv \mid u,v \in V,|x_u-x_v|+|y_u-y_v|=1\}$$

$V$ 和 $E$ 都不是空集。特别地，如果

$$V=[n]^{2}\text{ and }E=\{(i,j)(k,l) \in V \times V \mid |i-k|+|j-l|=1\}$$

则称 $L$ 为**方棋盘**。

**图案** 是一个映射 $A : V \to \mathbb{Z}_2$，其中 $A(v) = 1$ 表示灯亮，$A(v) = 0$ 表示灯灭。全亮图案 $1^{L}$ 和全灭图案 $0 ^{L}$ 是两个特殊图案，这里选取 $1^{L}$ 作为 $A_0$，目标图案简称**目标**，记作 $A_f$。

记 $\mathcal{A} = \{ A : V \to \mathbb{Z}_2\}$ 为所有图案的集合，称为棋盘 $L$ 的**图空间**，其在逐点加法（模 2）下构成一个 $|V|$ 维向量空间。

**点灯操作**是一个映射 $p: \mathcal{A} \to \mathcal{A}$，定义为

$$\forall v \in V:p(v_{ij})A(v) \equiv \begin{cases} A(v) + 1 & \text{if } v_{ij}v \in E, \\ A(v) & \text{otherwise}.\\ \end{cases}$$

操作复合 $p_1 \circ p_2$ 定义为

$$(p_1 \circ p_2)A(v)=p_2(p_1A(v))$$

扩展后的点灯操作仍然具有复合不变和顺序无关两种性质。

同 顺序无关 for more... 中的定义，记 $\mathcal{P}=\{\overset{n}{\underset{k=1}{\bigcirc}}p(v)|v \in V\}$ 为所有操作复合的集合，称为**方案空间**。方案 $P \in \{0,1\}^{L}$ 满足

$$\begin{align} P(i,j)A&=\begin{cases} p(i,j)A & \text{if } P(i,j)=1, \\ I & \text{otherwise}.\\ \end{cases} \\ PA &= {\underset{\mathbf{P}(i,j)=1}{\bigcirc}}p(i,j)A \end{align}$$

方案还有一种等价定义。若定义棋盘的**邻接矩阵** $M \in \mathbb{Z}_2^{|V| \times |V|}$，其中

$$M(u,v) = \begin{cases} 1 & \text{if } u = v \text{ or } uv \in E, \\ 0 & \text{otherwise}. \end{cases}$$

则方案 $P$ 可定义为满足条件的矩阵：

$$P \cdot a \equiv a + MP$$

方案仍然具备点灯游戏中方案的所有性质。

给定初始图案 $A_0$ 与目标 $A_f$，一个**解**是一个方案 $P_f$，使得

$$P_fA_0=A_f$$

将 $P_fA_0=A_f$ 的解集称为棋盘 ${L}$ 的**解空间**，记为 $\mathcal{S}(L)$。

### 奇翻转集

前面只讨论了方阵的点灯游戏。那么，对任意形状棋盘的点灯游戏，其是否都可解呢？

任意方案的**奇翻转集**定义为

$$F(P)=\{(i,j) \in L \mid P0^{L}(i,j)=1\}$$

**静默操作**$P_I$ 满足

$$P_IA=A$$

由定义，$P_f$ 与 $F(P_f)$ 一一对应，解 $P_f$ 唯一确定其奇翻转集 $F(P_f)$。但一个给定的奇翻转集 $F(P)$ 未必唯一对应一个解 $P_f$。若存在静默方案 $P_I$，则 $P_f + P_I$ 也是解，此时奇翻转集对应一个解空间

$$\{ P_f + P_I \mid P_I \in \ker(M) \},$$

其中 $\ker(M)$ 为静默方案空间，即满足 $P_I A = A$ 的所有方案。所有静默方案的奇翻转集都是 $\emptyset$，故它们不影响奇翻转集的值。解的个数等于静默方案空间的基数 $2^{\dim(\ker(M))}$。

容易证明：

1.  若棋盘有解，则所有解的奇翻转集相同
2.  $F(P_1)=F(P_2) \iff (P_1-P_2)A=A$

### 等价表示

设 $L_1=(V_1,E_1),L_2=(V_2,E_2)$，$P_f$ 是 $L_1$ 的一个解。若

1.  $L_1$ 是 $L_2$ 的子图（$L_1 \subseteq L_2$）
2.  $L_2$ 上存在方案 $P$，使 $\forall v \in V_1:F(P_{f})(v)=F(P)(v)$

则称 $L_2$ 是 $L_1$ 的**等价表示**。容易证明：

1.  任意棋盘 $L$ 有无数个等价表示。
2.  $L$ 是 $L$ 的等价表示。
3.  若 $L_2$ 是 $L_1$ 的等价表示，$L_3$ 是 $L_2$ 的等价表示，则 $L_3$ 是 $L_1$ 的等价表示。

接下来证明一个定理。

> **等价同解定理** 设 $L_2$ 是 $L_1$ 的等价表示。则存在 $A \in \mathcal{A}_2$，线性映射 $\psi:\mathscr{P}_1 \to \mathscr{P}_2$，使 $\psi(\mathcal{S}(0^{L_1}))=\mathcal{S}(A)$。

**证明**：

> **引理 2.1** $\psi$ 是线性映射。

定义映射 $\psi: \mathscr{P}_1 \to \mathscr{P}_2: P_1 ^{L_1} \mapsto P_1 ^{L_2} \oplus P ^{L_2}$，$\oplus$ 表示在 $L_2$ 上对应的点灯操作的逐点加法（模 2），$P ^{L_2}$ 是满足 $F(P_f ^{L_1}) = F(P ^{L_2})$ 的方案。

$L_1 \subseteq L_2$，所以 $V_1 \subseteq V_2$。可以将 $P_1$ 视为在 $L_2$ 上只在 $V_1$ 处有定义（在 $V_2 \setminus V_1$ 处为 $0$）的方案，因此 $\psi(P_1)$ 在 $L_2$ 上良定义。

设 $P_1, P_2 \in \mathscr{P}_1$，$c \in \mathbb{Z}_2$，则在 $L_2$ 上有

$$\psi(P_1 + P_2) = (P_1 + P_2) \oplus P = (P_1 \oplus P) + (P_2 \oplus P) = \psi(P_1) + \psi(P_2)$$

同理 $\psi(cP_1) = c\psi(P_1)$，故 $\psi$ 是线性映射。■

> **引理 2.2** $\psi$ 是单射。

设 $P_1 \in \mathcal{S}(0^{L_1})$，考虑 $\psi(P_1) = P_1 \oplus P$ 在 $L_2$ 上作用于 $1^{L_2}$。令 $A = P 1^{L_2}$，$\forall v \in V_1$ 有

$$\psi(P_1)1^{L_2}(v) = (P_1 \oplus P)1^{L_2}(v) = P_1 1^{L_1}(v) + P 1^{L_2}(v) = 0 + A(v) = A(v)$$

因为 $F(P_f) = F(P)$。

对于 $v \in V_2 \setminus V_1$，$P_1$ 在该点无操作，所以

$$\begin{array} \\ \psi(P_1)1^{L_2}(v) = P 1^{L_2}(v) = A(v) \\ \psi(P_1)1^{L_2} = A \\ \psi(P_1) \in \mathcal{S}(A) \\ \psi(\mathcal{S}(0^{L_1}))\subseteq \mathcal{S}(A) \end{array}$$

若 $\psi(P_1) = \psi(P_2)$，则

$$\begin{array} \\ P_1 \oplus P = P_2 \oplus P \\ P_1 = P_2 \\ \end{array}$$

故 $\psi$ 是单射。■

> **引理 2.3** $\psi(\mathcal{S}(0^{L_1}))\supseteq \mathcal{S}(A)$

设 $P' \in \mathcal{S}(A)$，考虑 $P' \oplus P$，则

$$(P' \oplus P) 1^{L_2} = P' 1^{L_2} + P 1^{L_2} = A + A = 0^{L_2}$$

特别地，在 $V_1$ 上有

$$(P' \oplus P) 1^{L_1} = 0^{L_1}$$

因此 $P' \oplus P \in \mathcal{S}(0^{L_1})$。于是

$$P' = \psi(P' \oplus P) \in \psi(\mathcal{S}(0^{L_1}))$$

故 $\psi(\mathcal{S}(0^{L_1}))\supseteq \mathcal{S}(A)$。■

由上述所有引理，存在 $A = P 1^{L_2} \in \mathcal{A}_2$ 和线性映射 $\psi$ 使得

$$\psi(\mathcal{S}(0^{L_1})) = \mathcal{S}(A)$$

■

### 正规表示

设 $L_1=(V_1,E_1),L_2=(V_2,E_2)$。若

1.  $L_2$ 是 $L_1$ 的等价表示
2.  $L_2$ 是方棋盘

则称 $L_2$ 是 $L_1$ 的**正规表示**。容易证明：

1.  若 $L$ 是方棋盘，则 $L$ 是 $L$ 的正规表示
2.  若 $L_2$ 是 $L_1$ 的正规表示，$L_3$ 是 $L_2$ 的正规表示，则 $L_3$ 是 $L_1$ 的正规表示

下面证明一个定理。

> **正规存在定理** 任意棋盘 $L$ 都至少有一个正规表示。

**证明**：

由于 $L$ 是有限图，设其最小包围矩形大小为 $R \times C$。取 $n > \max(R, C)$ 且 $n \not\equiv 0 \pmod{5}$。将 $L$ 放置于 $n \times n$ 棋盘 $L_n$ 的中心区域，使得 $V \subseteq [n]^2$，且 $L \subseteq L_n$。

由于在 $\mathbb{Z_2}$ 上的标准点灯游戏，其邻接矩阵 $\mathbf{M}_n ^{n ^{2}\times n ^{2}}$ 满足

$$\mathbf{M}_n \text{ 可逆} \iff n \not\equiv 0 \pmod{5}$$

我们已取 $n \not\equiv 0 \pmod{5}$，故 $M_n$ 可逆。

设目标向量 $b \in \{0,1\}^{n^2}$ 满足：$b(v) = \begin{cases} 1, & v \in V, \\ 0, & v \notin V. \end{cases}$

由于 $M_n$ 可逆，存在唯一向量 $\mathbf{x} \in \{0,1\}^{n^2}$ 使得

$$\mathbf{M}_n \mathbf{x} = b$$

$\mathbf{x}$ 给出 $L_n$ 上的一个点灯方案。

对于 $P1 ^{L_n}$，$\forall v \in V$，其翻转次数 $b(v) \equiv 1$，即全部奇翻转。换言之，在 $L$ 上，$P$ 产生的效果与 $L$ 上的解 $P_f$ 一致。根据定义，$L_n$ 是 $L$ 的等价表示，$L_n$ 是方棋盘，故 $L_{n}$ 为 $L$ 的正规表示。■

进而还可以证明正规存在定理的推广：任意棋盘都有无数个正规表示。这里从略。

### 完全 n 分棋盘

设棋盘 $L=(V,E)$。若 $L$ 是连通图，则称 $L$ 为**连通棋盘**（或 $L$ 是**连通**的）。否则，若 $L$ 可被划分为 $n$ 个子图 $L_1,L_2,\dots,L_n$，满足

1.  $\bigcap\limits_{i}V_i=\emptyset,\bigcup\limits_{i}V_i=V$
2.  $\bigcap\limits_{i}E_i=\emptyset,\bigcup\limits_{i}E_i=E$

则称 $L$ 为 $n$ **分棋盘**，$n$ 称为**分度**，$L_i \quad (i \in [n])$ 称为 $L$ 的**子棋盘**。

容易证明：

1.  棋盘 $L$ 是自己的子棋盘
2.  联通棋盘的分度为 $1$
3.  棋盘都是 $n$ 分棋盘，$n \in \mathbb{Z}$

接下来证明两个定理。

> **方案空间划分定理** $n$ 分棋盘的方案空间是所有子棋盘方案空间的直和。

**证明**：

设 $L = (V, E)$ 是一个 $n$ 分棋盘，其子棋盘为 $L_1, L_2, \dots, L_n$。令 $\mathscr{P}_L$ 表示 $L$ 上所有点灯方案的集合，$\mathscr{P}_{L_i}$ 是 $L_i$ 方案空间的忠实表示。则定理等价于 $\mathscr{P}_L$ 与 $\bigoplus_{i} \mathscr{P}_{L_i}$ 之间存在线性同构。

定义映射

$$\Phi: \bigoplus_{i} \mathscr{P}_{L_i} \to \mathscr{P}_L$$

对于任意 $(P_1, P_2, \dots, P_n) \in \bigoplus_{i} \mathscr{P}_{L_i}$，定义 $\Phi(P_1, P_2, \dots, P_n)$ 为 $L$ 上的方案 $P$，使得对于任意顶点 $v \in V_i,i \in [n]$，有

$$P(v) = P_i(v)$$

由于 $L$ 是 $k$ 分棋盘，$V_i$ 互不相交且覆盖 $V$，因此 $P$ 在 $L$ 上良定义。

> **引理 3.1** $\Phi$ 是线性映射

由于方案加法是逐点模 2 加法，显然有

$$\Phi(P_1 + Q_1, \dots, P_n + Q_n) = \Phi(P_1, \dots, P_n) + \Phi(Q_1, \dots, Q_n)$$

且对于标量乘法在 $\mathbb{Z}_2$ 上也满足线性。■

> **引理 3.2** $\Phi$ 是单射

假设 $\Phi(P_1, \dots, P_n) = \Phi(Q_1, \dots, Q_n)$，则对于任意 $v \in V_i$，有 $P_i(v) = Q_i(v)$，因此 $P_i = Q_i$ 对所有 $i$ 成立。故 $\Phi$ 是单射。■

> **引理 3.3** $\Phi$ 是满射

对于任意 $P \in \mathscr{P}_L$，定义 $P_i$ 为 $P$ 在 $V_i$ 上的限制。由于 $V_i$ 之间无边连接，$P_i$ 在 $L_i$ 上的效果与 $P$ 在 $L$ 上相同。因此 $(P_1, \dots, P_k) \in \bigoplus_{i=1}^k \mathscr{P}_{L_i}$，且 $\Phi(P_1, \dots, P_k) = P$。故 $\Phi$ 是满射。■

由引理 3.1 至 3.3，$\Phi$ 是一个线性双射，因此是线性同构，即

$$\mathscr{P}_L \cong \bigoplus_{i=1}^k \mathscr{P}_{L_i}$$

■

同理可得**图空间划分定理**：$n$ 分棋盘的图空间是所有子棋盘图空间的直和。

* * *

> **解空间划分定理** $n$ 分棋盘的解空间是所有子棋盘解空间的直和。

**证明**：

因为子棋盘之间无边连接，其邻接矩阵 $M_L$ 是分块对角的，即

$$M_L = \operatorname{diag}(M_{L_1}, \dots, M_{L_n})$$

且若 $P = (P_1, \dots, P_n)^\top \in \mathscr{P}_L$，$A = (A_1, \dots, A_n)^\top \in \mathcal{A}_L$，则

$$\begin{array} \\ M_L P = (M_{L_1} P_1, \dots, M_{L_n} P_n)^\top \\ P  A = (P_1 \cdot A_1, \dots, P_n \cdot A_n)^\top \end{array}$$

其中 $P_i \cdot A_i = A_i + M_{L_i} P_i$。

取 $A_0 = \mathbf{0}_L = (\mathbf{0}_{L_1}, \dots, \mathbf{0}_{L_n})$，目标 $A_f = \mathbf{1}_L$。方程化为

$$\begin{array} \\ P \cdot \mathbf{0}_L = \mathbf{1}_L \\ \mathbf{0}_L + M_L P = \mathbf{1}_L \\ M_L P = \mathbf{1}_L \\ M_{L_i} P_i = \mathbf{1}_{L_i} \quad i \in [n] \end{array}$$

由方案空间划分定理，存在线性同构

$$\Phi: \bigoplus_{i=1}^n \mathscr{P}_{L_i} \to \mathscr{P}_L$$

且这个同构与上述方程相容。

设 $L$ 的解空间 $\mathcal{S}(L) = \{P \in \mathscr{P}_L \mid M_L P = \mathbf{1}_L\}$，$L_i$ 的解空间 $\mathcal{S}(L_i) = \{P_i \in \mathscr{P}_{L_i} \mid M_{L_i} P_i = \mathbf{1}_{L_i}\}$。因为 $M_L$ 分块对角，方程 $M_L P = \mathbf{1}_L$ 等价于 $n$ 个独立的方程 $M_{L_i} P_i = \mathbf{1}_{L_i}$。于是

$$\mathcal{S}(L) = \{ (P_1, \dots, P_n) \in \bigoplus_{i=1}^n \mathscr{P}_{L_i} \mid  \forall i:M_{L_i} P_i = \mathbf{1}_{L_i}\}$$

正是直和 $\bigoplus_{i=1}^n \mathcal{S}_{L_i}$ 在 $\bigoplus_{i=1}^n \mathscr{P}_{L_i}$ 中的原像。

定义映射

$$\Psi: \mathcal{S}(L) \to \bigoplus_{i=1}^n \mathcal{S}(L_i),\Psi(P) = (P_1, \dots, P_n)$$

$\Psi$ 是 $\Phi^{-1}$ 在解空间上的限制。

-   **线性性**：显然，因为 $\Psi$ 是投影的拼接。
-   **单射**：若 $\Psi(P) = \Psi(Q)$，则 $\forall i \in [n]:P_i = Q_i$，从而 $P = Q$。
-   **满射**：任取 $(Q_1, \dots, Q_n) \in \bigoplus_{i=1}^n \mathcal{S}_{L_i}$，则 $Q = \Phi(Q_1, \dots, Q_n) \in \mathscr{P}_L$ 且满足 $M_L Q = \mathbf{1}_L$，故 $Q \in \mathcal{S}_L$ 且 $\Psi(Q) = (Q_1, \dots, Q_n)$。

因此 $\mathcal{S}(L) \cong \bigoplus_{i=1}^n \mathcal{S}(L_i)$，即解空间是子棋盘解空间的直和。■

* * *

设 $L=(V,E)$ 是 ${n}$ 分棋盘，令 $\forall i \in [n]:E_i=\{uv \in E|u,v \in V_i\}$。若任意子棋盘 $L_i=(V_i,E_i)$ 是连通棋盘，则称 $L$ 为**完全 $n$ 分棋盘**。自然，本节定理也适用于完全 $n$ 分棋盘。

### 陪空间与陪解

设完全 ${n}$ 分棋盘 $L=(V,E)$，其对应子棋盘为 $L_1, L_2, \dots L_n$。由正规存在定理，对 $\forall i,1\le i\le n$，$L_i$ 存在一个正规表示，记为 $L_i'$。记 $L' = \bigcup_i L'_i$，则 $L'$ 是 $L$ 的一个正规表示。

由方案空间划分定理，有

$$\mathcal{P}(L') \cong \bigoplus_{i=1}^{k} \mathcal{P}(L'_i),$$

其中 $k$ 为 $L$ 的分度。称这个直和空间为 $L$ 的**陪空间**，记作 $\mathcal{C}(L)$。其解空间中的每一个元素称为 $L$ 的一个**陪解**。

由解空间划分定理，有

$$\mathcal{S}(L) \cong \bigoplus_{i=1}^{k} \mathcal{S}(L_i).$$

根据正规表示定义，$\mathcal{S}(L_i) \cong \mathcal{S}(L_i')$。因此，$L$ 的每一个解都对应一个陪解，反之亦然。特别地，当 $L$ 本身是方棋盘时，其陪空间就是它自身的方案空间，陪解即通常的解。

### 广义可解性

若 $\mathcal{S}(L) \neq \emptyset$，则称棋盘 $L$ 是**可解**的。

> **引理 4.1** 点灯游戏是可解的。

对于任意 $n \times n$ 方棋盘，由叠加法或灯向量法可知，方程 $\mathbf{P}\mathbf{0}=\mathbf{1}$ 总有解。事实上，无论 $n$ 取值如何，全 ${1}$ 向量始终位于邻接矩阵的列空间中，这可由静默方案的存在性保证（参见\*静默方案）。因此方棋盘总是可解。■

> **引理 4.2** 棋盘 $L$ 的陪空间是可解的。

由正规存在定理，$L$ 的每个连通子棋盘 $L_i$ 存在一个正规表示 $L_i'$，且 $L_i'$ 为方棋盘。由引理 4.1，$L_i'$ 可解，故 $\mathcal{S}(L_i') \neq \emptyset$。根据正规表示的定义，有 $\mathcal{S}(L_i) \cong \mathcal{S}(L_i')$，从而 $\mathcal{S}(L_i) \neq \emptyset$。再由解空间划分定理，$\mathcal{S}(L) \cong \bigoplus_i \mathcal{S}(L_i)$，因此 $\mathcal{S}(L) \neq \emptyset$，即 $L$ 可解。■

> **引理 4.3** 广义点灯游戏是可解的。

任意棋盘 $L$ 可视为完全 $n$ 分棋盘（取 $n=1$ 即自身），由引理 4.2 知 $L$ 可解。■

综上，对于棋盘 $L$，点灯游戏总是可解的，即广义点灯游戏是可解的。

## 参考资料

1.  [axpokl. 〖Manim〗《点灯游戏的O(n³)解法》](https://link.zhihu.com/?target=https%3A//www.bilibili.com/video/BV1XcxNz7EjF/)
2.  [axpokl. 点灯游戏Flip Game的O(n2)算法](https://zhuanlan.zhihu.com/p/53646257)
3.  [Xu, C. 逼零集，点灯游戏和解线性方程组](https://zhuanlan.zhihu.com/p/553780037)
4.  [麻省理工《线性代数》, bilibili](https://link.zhihu.com/?target=https%3A//www.bilibili.com/video/BV1ix411f7Yp/)
5.  [北京大学 丘维声 《高等代数》, bilibili](https://link.zhihu.com/?target=https%3A//www.bilibili.com/video/BV1jR4y1M78W/)
6.  [Pecco. 算法学习笔记(8)：拓展欧几里得](https://zhuanlan.zhihu.com/p/100567253)
7.  [0003\. 抽象代数知识点总结](https://zhuanlan.zhihu.com/p/162709824)
8.  [大PPP. 图论学习笔记](https://zhuanlan.zhihu.com/p/660468990)
9.  [Chen. 点灯游戏、方格填数与 Chebyshev 多项式](https://zhuanlan.zhihu.com/p/109180698)
10.  [granvallen. 点灯游戏与数学之美](https://link.zhihu.com/?target=https%3A//granvallen.github.io/lightoutgame/)
11.  [Verderio, P. (2024). Algumas luminescências sobre o jogo Lights Out](https://link.zhihu.com/?target=http%3A//arxiv.org/abs/2403.17967)
12.  [Anderson, M. & Feil, T. (1998). Turning Lights Out with Linear Algebra. Mathematics Magazine, 71(4), 300-303](https://link.zhihu.com/?target=http%3A//www.math.ksu.edu/math551/math551a.f06/lights_out.pdf)
13.  [Ho, C.-H. (2018). On σ-game and σ⁺-game. Master's thesis, National Taiwan Normal University](https://link.zhihu.com/?target=https%3A//ndltd.ncl.edu.tw/cgi-bin/gs32/gsweb.cgi%3Fo%3Ddnclcdr%26s%3Did%3D%2522106NTNU5479015%2522)
14.  [Lights Out Mathematics](https://link.zhihu.com/?target=https%3A//www.jaapsch.net/puzzles/lomath.htm%23refs)
15.  [Eriksson, H., Eriksson, K. & Sjöstrand, J. (2001). Note on the lamp lighting problem. Advances in Applied Mathematics, 27, 357-366](https://link.zhihu.com/?target=http%3A//arxiv.org/abs/math.CO/0411201)
16.  [Chen, W. Y. C. & Gu, N. S. S. (2005). Loop Deletion for the Lamp Lighting Problem. Preprint](https://link.zhihu.com/?target=http%3A//www.billchen.org/preprint/lamp/lamp.htm)
17.  [Chen, L. & Mazur, K. (2025). A Recursive Approach to a Multi-State Cylindrical Lights Out Game. The PUMP Journal of Undergraduate Research, 8, 225-241](https://link.zhihu.com/?target=https%3A//journals.calstate.edu/pump/article/view/4268)
18.  [POJ 1222. EXTENDED LIGHTS OUT](https://link.zhihu.com/?target=http%3A//poj.org/problem%3Fid%3D1222)
19.  [N. Rai. "A technical survey of sparse linear solvers in electronic design automation." arXiv preprint, arXiv: 2504.11716, September 2024.](https://link.zhihu.com/?target=https%3A//arxiv.org/abs/2504.11716)
20.  [J. Gao, B. Liu, W. Ji, H. Huang. "A systematic literature survey of sparse matrix-vector multiplication." arXiv preprint, arXiv: 2404.06047, April 2024.](https://link.zhihu.com/?target=https%3A//arxiv.org/abs/2404.06047)

> 本文由 [Zhihu on Obsidian](https://zhuanlan.zhihu.com/p/1901622331102696374) 创作并发布