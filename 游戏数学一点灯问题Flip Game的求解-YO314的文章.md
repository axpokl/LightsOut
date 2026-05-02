## 前言

说起这个游戏实际上我早在小时的各种小游戏里就已经见过了，往往是一些解密小游戏中的小插曲，给你一个3\*3的棋盘让你全部点亮。直到第二次在[C++](https://zhida.zhihu.com/search?content_id=272009772&content_type=Article&match_order=1&q=C%2B%2B&zhida_source=entity)课程上遇到，我依旧凭借直觉乱蒙。当时为了解决这个编程问题我还在用 $O(2^{n^2})$ 的穷举方法，果不其然地超时了。后面经同学点拨才发现：由于点两下相当于什么都不做，在[群论](https://zhida.zhihu.com/search?content_id=272009772&content_type=Article&match_order=1&q=%E7%BE%A4%E8%AE%BA&zhida_source=entity)里面相当于说 $a=a^{-1}$ ，这说明所有操作都是可交换的，不分先后。加上两次同样操作抵消，可以假设每个位置至多点一次。

所以一个更常见的算法是穷举第一列的所有点击情况，也就是 $2^n$ 种，当前 $i$ 列全部按完后就按照第 $i$ 列还没点亮的格子确定第 $i+1$ 列的点击情况。以此类推直到最后一列，运气好的话就完成了，不好就重新列举第一列的情形。这种方法当然不是最优的，不过起码不会超时。关于算法的优化可以参考**axpokl**的

[点灯游戏Flip Game的O(n^3)算法](https://zhuanlan.zhihu.com/p/53646257)

不过我们这篇文章的重点不在于算法优化，而是数学上对于这一问题的部分研究，涉及到的只有一些简单的高等代数知识。以下内容只是我学习相关内容后整理出的笔记，并非完全原创。之前就有Sutner等人研究过此类问题。

## 解的存在性

可以假设灯只有两种状态：灭，亮分别记为 $0,1\in \mathbb{F}_2$ 。放在[二元域](https://zhida.zhihu.com/search?content_id=272009772&content_type=Article&match_order=1&q=%E4%BA%8C%E5%85%83%E5%9F%9F&zhida_source=entity)中的运算也是适配的,如果按下其中一个灯,周围的灯数值就 $+1$ 。那么我们要求的就是一种给所有点赋值的方法，解一个 $\mathbb{F}_2$ 中的线性方程组即可。不过 $n\times n$ 这个棋盘的规格限制在研究解存在性问题上实际上是没有必要的，我们抽象一点

假设有 $N$ 个顶点构成的无向图，操作其中一个点会改变其相邻点和自身的状态。我们记其[邻接矩阵](https://zhida.zhihu.com/search?content_id=272009772&content_type=Article&match_order=1&q=%E9%82%BB%E6%8E%A5%E7%9F%A9%E9%98%B5&zhida_source=entity)(显见这是一个对称矩阵) $$A_{ij}=\left\{\begin{array} $1 ,\quad i,j相邻 \\0,\quad else \end{array}\right.$$ 此外定义 $A_{ii}=1$ ，那么我们目标就是求一个 $\bm{x}\in\mathbb{F}_2^N$ 使得 $A\bm{x}=\bm{b}$ 。其中 $\bm{b}=(1,\cdots,1)$ ，这是因为如果我们将 $x_i$ 是否为 $1$ 与是否点第 $i$ 个点等同起来的话 $A\bm{x}=\sum A_ix_i$ 就表示点完这些点之后的总影响。问题还是转换为这个线性方程组是否有解，也就是说是否有 $\bm{b}\in \mathrm{Im}A$ .

为了判断这一点可以用我们在线代里面学的 $(\mathrm{Ker}A^T)^\bot=\mathrm{Im}A$ 。这只对于有内积的线性空间是比较合理的，比如域为实数的情形。不过我们能换种描述方法，利用双线性型，那么这里的正交就可以 $\bm{v}\bot\bm{w}$ 理解为 $B(\bm{v},\bm{w})=0$ 。特别地选取 $B(\bm{v},\bm{w})=\bm{w}^T\bm{v}=\sum v_iw_i$ ，这种情况下我们有

**引理1** 设 $V$ 为域 $\mathbb{F}$ 上的有限维线性空间，那么对于线性算子 $A\in\mathcal{L}(V)$ 有 $(\mathrm{Ker}A^T)^\bot=\mathrm{Im}A$ 。

**证明** 这也即一般域上的[线性代数](https://zhida.zhihu.com/search?content_id=272009772&content_type=Article&match_order=1&q=%E7%BA%BF%E6%80%A7%E4%BB%A3%E6%95%B0&zhida_source=entity)基本定理。根据正交补的定义， $$\mathrm{Ker}A^T=\left\{ \bm{x}:\bm{x}与A的每个列向量均正交\right\}=(\mathrm{Im}A)^\bot$$ 两边同时取正交补即可。

据此我们只需问是否有 $\forall \bm{x},A^T\bm{x}=0,有\bm{b}^T\bm{x}=0$ 。这只是一个简单的计算过程，利用有限域上的特征和费马小定理即可得到

$$0=\bm{x}^TA^T\bm{x}=\sum_{i,j}A_{i,j}x_ix_j=\sum_i x_i^2+2\sum_{i<j}A_{i,j}x_ix_j=\sum_i x_i=\bm{b}^T\bm{x}$$ 于是可以总结出

**定理1** 对于一个有限无向图，如果每个顶点只有两种状态，操作其中一个会改变自身以及相邻点的状态。那么一定能通过有限步操作将所有顶点状态改变为另一种。

这当然覆盖了点灯游戏的情形，因此这类游戏的解一定是存在的。

## 解的个数

一般来说既然已经列出了线性方程组，那么只需要做 $\mathbb{F}_2$ 上的[高斯消元](https://zhida.zhihu.com/search?content_id=272009772&content_type=Article&match_order=1&q=%E9%AB%98%E6%96%AF%E6%B6%88%E5%85%83&zhida_source=entity)就能得到特解，以及解空间维数 $d=N-r(A)$ 。（这里 $N$ 总是代表顶点总个数，对于 $n\times n$ 棋盘， $N=n^2$ ）那么解空间就是特解加上 $d$ 个基的线性组合，由于系数只能取 $0或者1$ ，解的个数为 $2^d$ 。下面为了计算齐次部分解空间维数，考虑 $A\bm{x}=0$ 的方程组，相当于一通操作后什么也不变的状态。

如果只是针对于矩形棋盘这种特殊情况，我们可以按列给出方程组，从而无需看作 $n^2$ 个未知数的线性方程组（这时采用高斯消元法的复杂度已经是 $O(n^6)$ )。对于 $m\times n$ 棋盘，假设第 $i$ 列的点击状态向量为 $X_i$ 。统计全部点击后第 $i$ 列的状态总变化可以得到

$$X_{i-1}+BX_i+X_{i+1}=0,\quad i=1,\cdots,n$$ 其中 $B\in\mathbb{F}_2^{m\times m}$ 为非零元素全 $1$ 的三对角阵。此外第 $0,n+1$ 列不存在，相当于没有点击，从而 $X_0=X_{n+1}=0$ .在 $\mathbb{F}_2^m$ 上由递推方程可得

$$X_i=p_i(B)X_1,\quad i=1.\cdots,n+1$$ 其中

$$p_0(x)=0,p_1(x)=1,\quad p_{i+1}(x)=xp_i(x)+p_{i-1}(x)$$ 这样 $X_1$ 就确定了所有点灯的操作，最终只需保证满足边界条件 $X_{n+1}=p_{n+1}(B)X_1=0$ 。问题的解完全由 $X_1$ 给出，从而由此方程给出。至此已经可以说 $d=\dim \mathrm{Ker}\ p_{n+1}(B)$ ，然而这样还是无法避免去求解空间。如果结合一个隐含条件，直接计算三对角阵 $B-I$ 的特征多项式，其特征多项式关于阶数的递推关系与 $p_i(x)$ 是一致的，所以 $B$ 的特征多项式为 $p_{m+1}(x+1)$ ，由[凯莱哈密顿定理](https://zhida.zhihu.com/search?content_id=272009772&content_type=Article&match_order=1&q=%E5%87%AF%E8%8E%B1%E5%93%88%E5%AF%86%E9%A1%BF%E5%AE%9A%E7%90%86&zhida_source=entity)可得

$$p_{m+1}(B+I)=0$$ 从而如果定义 $d(x):=\gcd(p_{n+1}(x),p_{m+1}(x+1))$ ，则 $X_1$ 为方程的解当且仅当

$$d(B)X_1=0$$ 这种形式方程的解空间维数是好确定的，只需证明

**引理2** 假设 $B$ 为有限维线性空间 $V$ 上的线性算子，其特征多项式与极小多项式均为 $f(x)$ 。则对于任意的 $d(x)\mid f(x)$ 均有 $\dim \mathrm{Ker}\ d(B)=\deg d$ 。

**证明** $B$ 有唯一次数非零的不变因子 $f(x)$ ，从而存在 $\bm{v}\in V$ 使得 $V=\mathrm{span}\left\{ \bm{v},B\bm{v},\cdots,B^{n-1}\bm{v}\right\}$ ，其中 $n=\dim V$ 。从而对于任意的 $\bm{w}\in V$ ，存在唯一次数不超过 $n-1$ 的多项式 $p_{\bm{w}}(x)$ 使得 $\bm{w}=p_{\bm{w}}(B)\bm{v}$ .则 $$\bm{w}\in \mathrm{Ker}\ d(B)\Leftrightarrow d(B)p_{\bm{w}}(B)\bm{v}=0\Leftrightarrow d(B)p_{\bm{w}}(B)=0\Leftrightarrow f(x)\mid d(x)p_{\bm{w}}(x)$$ 这当且仅当 $p_{\bm{w}}(x)d(x)/f(x)\in \mathbb{F}[x]_{\leq \deg d-1}$ ，于是所有满足条件的 $p_{\bm{w}}(x)$ 构成线性空间维数就是 $\deg d$ 。对应的满足条件的 $\bm{w}$ 构成线性空间维数也是 $\deg d$ 。

在这个问题里面，可以计算 $B$ 的行列式因子，注意到 $\det(\lambda I-B)$ 总有 $i(<n)$ 阶上三角阵对角元素全为 $-1$ ，因此 $D_i(x)=1,\forall i<n$ 而 $D_n(x)$ 就是特征多项式，所以 $B$ 满足引理条件。据此我们构造的 $d(x)$ 由于满足整除条件，可以直接得出解空间维数就是 $$d=\deg d(x)=\deg \gcd(p_{n+1}(x),p_{m+1}(x+1))$$

特别地 $m=n$ 时 $d=\deg \gcd(p_{n+1}(x),p_{n+1}(x+1))$ 。有趣的一点是， $d$ 总是偶数，从而解的个数总是 $4$ 的幂次。只需将 $d(x)$ 在分裂域上展开成一次因式，其根 $\alpha$ 的和互异的根 $\alpha+1$ 总是成对出现，并且可以计算重数相等。

**推论1** 若 $n=2^r-1(r\in \mathbb{N}^+)$ ，则$n\times n$ [点灯问题](https://zhida.zhihu.com/search?content_id=272009772&content_type=Article&match_order=1&q=%E7%82%B9%E7%81%AF%E9%97%AE%E9%A2%98&zhida_source=entity)有唯一解。

**证明** 将递推表达式放在 $\mathbb{F}_2[x]$ 分式域的代数闭包 $\overline{\mathbb{F}_2(x)}$ 上看，特征多项式为 $\lambda^2-x\lambda+1=0$ 。所以通解可以表达为 $$p_k(x)=\frac{\alpha^{k}+\beta^{k}}{\alpha+\beta}$$其中 $\alpha+\beta=x,\alpha\beta=1$ 。由于其特征依然为 $2$ ，可以计算得 $$p_{n+1}(x)=\frac{\alpha^{2^r}+\beta^{2^r}}{\alpha+\beta}=(\alpha+\beta)^{2^r-1}=x^{2^r-1}$$ 比对根的分布就知道 $d(x)=1$ 。