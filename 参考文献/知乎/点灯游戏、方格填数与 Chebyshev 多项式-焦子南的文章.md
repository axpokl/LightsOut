第一篇文章本来想先写个引子，从特殊问题引入一般问题，后来嫌太麻烦就直接开门见山了。

本文内容都是原创的，但是肯定不是第一个发现的……这篇文章只是把我的一些想法整理出来而已。

## 问题

任意域 F 上的方格填数问题：现有 n×m 的方格，需要在每个格子填一个数（这里的数指的是域 F 中的元素），满足：**每个格子的所有相邻格子（可能有 2, 3, 4 个格子）数字之和都等于自身格子中数字的 c 倍**（c 是域 F 的一个常数）**。**

我们的目的是分析出解集满足的一些性质，当然如果（在某些特殊情况下）能显式表示出解集就更好了。

## 特例

**经典的点灯游戏**：n×m 个灯排列成 n 行 m 列，每个灯有亮灭两种状态。每个灯都有一个开关，按下一个灯的开关会改变这个灯自身以及上下左右 4 个灯（如果灯在边角就只有 3 个或 2 个灯）的状态，其余灯保持不变。初始时所有灯都是熄灭状态，要求通过按动开关将所有灯点亮。

可以证明，对任意 n, m 总能将所有灯点亮。一般性的结论参见 Matrix67 的博客：

[UyHiP趣题：拉灯游戏总有解吗？](https://link.zhihu.com/?target=http%3A//www.matrix67.com/blog/archives/4263)

容易看出，点灯游戏中**改变按动开关的次序不影响最终所有灯的状态**，并且**按动同一个开关两次等于什么也不做**，因此可以假设每个开关要么不按要么按一次。设第 i 行第 j 列的开关按了 $x_{i,j}$ 次，列出[方程组](https://zhida.zhihu.com/search?content_id=112392901&content_type=Article&match_order=1&q=%E6%96%B9%E7%A8%8B%E7%BB%84&zhida_source=entity)

$$x_{i-1,j}+x_{i+1,j}+x_{i,j-1}+x_{i,j+1}+x_{i,j}=1,1\le i\le n,1\le j\le m\mod 2 $$

（如果下标超出范围则删除对应项），这是域 $\mathbb{F}_2$ 上的线性方程组。既然已经证明方程组有一个特解，我们就只需要关心相应的[齐次方程组](https://zhida.zhihu.com/search?content_id=112392901&content_type=Article&match_order=1&q=%E9%BD%90%E6%AC%A1%E6%96%B9%E7%A8%8B%E7%BB%84&zhida_source=entity)

$$x_{i-1,j}+x_{i+1,j}+x_{i,j-1}+x_{i,j+1}+x_{i,j}=0,1\le i\le n,1\le j\le m\mod 2 $$

的解的情况。该齐次方程组的解有时称为“quiet pattern”，含义为按动这些开关之后所有灯状态保持不变。点灯游戏的诸多性质都与这个齐次方程组有关，例如若记该方程组解空间的维数为 $d$，则点灯游戏的可解状态（即“按动某些开关可以使所有灯熄灭”的状态）有 $2^{nm-d}$ 个，每个可解状态都有 $2^d$ 种不同的解法（要求每个开关要么不按要么按一次，并且不考虑按动开关的顺序）。

解 quiet pattern 的问题实际上就是域 $\mathbb{F}_2$ 上 $c=-1$ 的方格填数问题。

**点灯游戏的变种**

1）将点灯游戏的开关灯方式改为“只改变上下左右 4 个灯的状态，不改变自身的状态”

此时解 quiet pattern 的问题仍然是[方格填数](https://zhida.zhihu.com/search?content_id=112392901&content_type=Article&match_order=3&q=%E6%96%B9%E6%A0%BC%E5%A1%AB%E6%95%B0&zhida_source=entity)问题的特例（$c=0$）。后面会看到，$c=0$ 的情况比 $c\ne 0$ 的情况简单得多。

2）将每个灯的状态数由 2 变为任意素数 p，按动开关会使上下左右以及自身 5 个灯的状态按循环顺序改变（例如若 p=3，状态改变顺序为灭灯→亮红灯→亮绿灯→灭灯，则这 5 个灯中熄灭的灯都变成红灯，红灯变成绿灯，绿灯变成熄灭状态，其余灯不变）

将 p 个状态分别记为 $0, 1, \cdots, p-1$，则每按一次开关会使上下左右以及自身 5 个灯的状态加 1（模 p 意义下），类似可知按动开关次序不影响结果，并且每个开关按动 p 次等于什么也不做，因此可以假设每个开关按了不超过 p-1 次。

可以看到此时解 quiet pattern 的问题就是域 $\mathbb{F}_p$ 上 $c=-1$ 的方格填数问题。（如果 p 不是素数，则一般不能简单地转化为某个域上的方格填数问题，我们不考虑这种情况）

**实数域上的方格填数问题**

参考知乎问题 [https://www.zhihu.com/question/373230831](https://www.zhihu.com/question/373230831)，这个问题就是实数域上 $c=1$ 的方格填数问题。后面会看到，实数域上的方格填数问题比一般情况简单。

## 分析

显然这个问题等价于解一个齐次线性方程组：记[矩阵](https://zhida.zhihu.com/search?content_id=112392901&content_type=Article&match_order=1&q=%E7%9F%A9%E9%98%B5&zhida_source=entity)

$$A=\left( \begin{matrix}    0 & 1 & 0 & \cdots & 0 & 0 \\    1 & 0 & 1 & \cdots & 0 & 0 \\    0 & 1 & 0 & \cdots & 0 & 0 \\    \vdots & \vdots & \vdots & \ddots & \vdots & \vdots \\    0 & 0 & 0 & \cdots & 0 & 1 \\    0 & 0 & 0 & \cdots & 1 & 0   \end{matrix} \right)_{m\times m}, B=\left( \begin{matrix}    A & I & 0 & \cdots & 0 & 0 \\    I & A & I & \cdots & 0 & 0 \\    0 & I & A & \cdots & 0 & 0 \\    \vdots & \vdots & \vdots & \ddots & \vdots & \vdots \\    0 & 0 & 0 & \cdots & A & I \\    0 & 0 & 0 & \cdots & I & A   \end{matrix} \right)_{nm\times nm}, $$

则矩阵 $B$ 就是 n×m 方格的[邻接矩阵](https://zhida.zhihu.com/search?content_id=112392901&content_type=Article&match_order=1&q=%E9%82%BB%E6%8E%A5%E7%9F%A9%E9%98%B5&zhida_source=entity)，原问题就等价于解齐次线性方程组 $(B-cI)x=0$，它的解集是 $F^{nm}$ 的一个子空间。问题转化为研究矩阵 $B$ 的[特征值和特征向量](https://zhida.zhihu.com/search?content_id=112392901&content_type=Article&match_order=1&q=%E7%89%B9%E5%BE%81%E5%80%BC%E5%92%8C%E7%89%B9%E5%BE%81%E5%90%91%E9%87%8F&zhida_source=entity)。但这篇文章不打算直接研究矩阵 $B$（因为处理这样的分块矩阵比较麻烦），而是用另一种方法：记

$$M_n=\left( \begin{matrix}    0 & 1 & 0 & \cdots & 0 & 0 \\    1 & 0 & 1 & \cdots & 0 & 0 \\    0 & 1 & 0 & \cdots & 0 & 0 \\    \vdots & \vdots & \vdots & \ddots & \vdots & \vdots \\    0 & 0 & 0 & \cdots & 0 & 1 \\    0 & 0 & 0 & \cdots & 1 & 0   \end{matrix} \right)_{n\times n}, $$

则矩阵 $M_nX$ 相当于将每个格子替换为上下两个格子之和，而矩阵 $XM_m$ 相当于将每个格子替换为左右两个格子之和，于是原问题可用方程

$M_nX+XM_m=cX.\tag{1}$

表示。定义线性变换 $\sigma_{n,m}:F^{n\times m}\rightarrow F^{n\times m}$ 满足 $\sigma_{n,m}(X)=M_nX+XM_m$，则问题转化为研究变换 $\sigma_{n,m}$ 的特征值和特征向量。

## 特征值

先研究一般的[线性变换](https://zhida.zhihu.com/search?content_id=112392901&content_type=Article&match_order=2&q=%E7%BA%BF%E6%80%A7%E5%8F%98%E6%8D%A2&zhida_source=entity) $\sigma(X)=AX+XB^T$。如果矩阵 $A,B$ 都有一组“完整”的特征值，事情会简单得多。

（以下内容部分搬运自[我的回答](https://www.zhihu.com/question/373230831/answer/1030393890)）

**命题1** 若 $A,B$ 分别有特征向量 $u,v$，对应特征值分别为 $\lambda,\mu$，则变换 $\sigma$ 有特征向量 $uv^T$，特征值为 $\lambda+\mu$。

证明：$\sigma(uv^T)=Auv^T+u(Bv)^T=\lambda uv^T+u(\mu v)^T=(\lambda+\mu)uv^T.$

**命题2** 若 $u_1,\cdots,u_s\in F^n$ 和 $v_1,\cdots,v_t\in F^m$ 分别是两组线性无关的向量，则向量组 $(u_iv_j^T)_{1\le i\le s,1\le j\le t}$ 线性无关。

证明：（原回答里的证明不适用于任意域，而且好像把问题搞复杂了……）

假设 $\sum_{i=1}^n\sum_{j=1}^m c_{ij}u_iv_j^T=0$，此式可以改写为[矩阵形式](https://zhida.zhihu.com/search?content_id=112392901&content_type=Article&match_order=1&q=%E7%9F%A9%E9%98%B5%E5%BD%A2%E5%BC%8F&zhida_source=entity)

$$\left( \begin{matrix}    u_1 & \cdots & u_s   \end{matrix} \right) \left( \begin{matrix}    c_{11} & \cdots & c_{1t} \\    \vdots & \ddots & \vdots \\    c_{s1} & \cdots & c_{st}   \end{matrix} \right) \left( \begin{matrix}    v_1 \\    \vdots \\    v_t   \end{matrix} \right)=0, $$

由已知条件可知左端第一个矩阵是 n 阶[可逆矩阵](https://zhida.zhihu.com/search?content_id=112392901&content_type=Article&match_order=1&q=%E5%8F%AF%E9%80%86%E7%9F%A9%E9%98%B5&zhida_source=entity)，第三个矩阵是 m 阶可逆矩阵，依次乘它们的逆矩阵可得 $(c_{ij})=0$，这说明向量组 $(u_iv_j^T)_{1\le i\le s,1\le j\le t}$ 线性无关。

**命题3** 若 $A$ 有一组特征向量 $u_1,\cdots,u_n$ 构成 $\mathbb{R}^n$ 的一组基，相应特征值为 $\lambda_1,\cdots,\lambda_n$，$B$ 有一组特征向量 $v_1,\cdots,v_m$ 构成 $\mathbb{R}^m$ 的一组基，特征值为 $\mu_1,\cdots,\mu_m$，则变换 $\sigma$ 有一组特征向量 $(u_iv_j^T)_{1\le i\le n,1\le j\le m}$ 构成 $\mathbb{R}^{n\times m}$ 的基，$u_iv_j^T$ 对应的特征值为 $\lambda_i+\mu_j$。

证明：直接由命题 1 和 2 可得。

## 矩阵 $M_n$ 的特征向量

通过上述分析可以发现，如果矩阵 $M_n,M_m$ 各有一组“完整”的特征值，解决填数问题就简单很多。定义[多项式列](https://zhida.zhihu.com/search?content_id=112392901&content_type=Article&match_order=1&q=%E5%A4%9A%E9%A1%B9%E5%BC%8F%E5%88%97&zhida_source=entity) $F_n(x)$：

$$F_0(x)=0,F_1(x)=1,F_n(x)=xF_{n-1}(x)-F_{n-2}(x)(n\ge 2). $$

多项式 $F_n(x)$ 称为 Chebyshev 多项式（准确地说，这里定义的多项式与 Chebyshev 多项式略有差别，但是两者可以通过简单的变形互化，这里就不管这些事情了）。

Chebyshev 多项式与矩阵 $M_n$ 以及方程（1）关系密切，例如容易用数学归纳法证明：

**命题4** $\det(xI-M_n)=F_{n+1}(x).$

（可能有人会问为什么不把 $\det(xI-M_n)$ 定义成 $F_n(x)$，这样下标和多项式次数刚好对应，事实上这样以后研究多项式 $F_n(x)$ 的时候比较方便，后面就看出来了）

由[线性代数](https://zhida.zhihu.com/search?content_id=112392901&content_type=Article&match_order=1&q=%E7%BA%BF%E6%80%A7%E4%BB%A3%E6%95%B0&zhida_source=entity)的知识可以知道：若 $\lambda$ 是多项式 $F_{n+1}(x)$ 的一个根，则 $\lambda$ 是矩阵 $M_n$ 的特征值（反之也成立）。事实上因为矩阵 $M_n$ 的形式比较简单，可以直接写出特征向量的[表达式](https://zhida.zhihu.com/search?content_id=112392901&content_type=Article&match_order=1&q=%E8%A1%A8%E8%BE%BE%E5%BC%8F&zhida_source=entity)：

**命题5** 若 $\lambda$ 是多项式 $F_{n+1}(x)$ 的一个根，则 $\lambda$ 是矩阵 $M_n$ 的特征值，对应的[特征子空间](https://zhida.zhihu.com/search?content_id=112392901&content_type=Article&match_order=1&q=%E7%89%B9%E5%BE%81%E5%AD%90%E7%A9%BA%E9%97%B4&zhida_source=entity)维数为 1，特征向量为 $(F_1(\lambda),\cdots,F_n(\lambda))^T$ 的非零常数倍。

证明：设向量 $v=(x_1,\cdots,x_n)^T$ 是矩阵 $M_n$ 的特征值为 $\lambda$ 的特征向量，直接将特征向量的定义式 $M_nv=\lambda v$ 展开即得

$$x_2=\lambda x_1, \\ x_3=\lambda x_2-x_1, \\ x_4=\lambda x_3-x_2, \\ \cdots, \\ x_{n-1}=\lambda x_{n-2}-x_{n-3}, \\ x_n=\lambda x_{n-1}-x_{n-2}, \\ \lambda x_n-x_{n-1}=0. $$

由前 $n-1$ 个式子容易得出 $x_i=x_1F_i(\lambda),i=1,\cdots,n$，再由 $F_{n+1}(\lambda)=0$ 可知最后一式也成立，因此 $v$ 的所有解可以表示为 $v=x_1(F_1(\lambda),\cdots,F_n(\lambda))^T$，命题得证。

至此可以看出，如果多项式 $F_{n+1}(x),F_{m+1}(x)$ 在域 $F$ 上恰好各自有 $n,m$ 个互不相同的根，由命题 3 和命题 5 就可以直接写出变换 $\sigma_{n,m}$ 的一组特征值和特征向量，并且这些特征向量构成全空间的一组基！要问方程（1）的解空间维数，只需检查常数 $c$ 是不是 $\sigma_{n,m}$ 的特征值，出现了几次就可以了，并且把相应的特征向量挑出来就构成了一组基解。这就是下面的命题：

**定理6** 若多项式 $F_{n+1}(x)$ 有 $n$ 个互不相同的根 $\lambda_1,\cdots,\lambda_n$，多项式 $F_{m+1}(x)$ 有 $m$ 个互不相同的根 $\mu_1,\cdots,\mu_m$，则有：

1）变换 $\sigma_{n,m}$ 有一组特征向量 $(F_i(\lambda_k)F_j(\mu_l))_{1\le i\le n,1\le j\le m}$构成 $F^{n\times m}$ 的基，对应的特征值分别为 $\lambda_k+\mu_l$；

2）方程（1）的基解为 $\{(F_i(\lambda_k)F_j(\mu_l))_{1\le i\le n,1\le j\le m}\mid\lambda_k+\mu_l=c\}$，解空间维数等于满足 $\lambda_k+\mu_l=c$ 的 $(k,l)$ 组数。

现在用定理 6 完全解决实数域 $\mathbb{R}$ 上的方格填数问题。之前提到过，实数域上的方格填数问题比一般情况简单，这是因为[实数域](https://zhida.zhihu.com/search?content_id=112392901&content_type=Article&match_order=6&q=%E5%AE%9E%E6%95%B0%E5%9F%9F&zhida_source=entity)上 $F_{n+1}(x)$ 的确有 $n$ 个互不相同的实根。用[数学归纳法](https://zhida.zhihu.com/search?content_id=112392901&content_type=Article&match_order=2&q=%E6%95%B0%E5%AD%A6%E5%BD%92%E7%BA%B3%E6%B3%95&zhida_source=entity)容易证明：

**命题7**

1）设 $n$ 是非负整数，则有 $F_n(2\cos\theta)=\frac{\sin n\theta}{\sin\theta};$

2）在实数域上，多项式 $F_{n+1}(x)$ 有 $n$ 个互不相同的实根 $2\cos\frac{k\pi}{n+1}(1\le k\le n).$

再结合定理 6 和命题 7 即可得到

**命题8（实数域的方格填数游戏）** 记 $\alpha_k=\frac{k\pi}{n+1},\beta_l=\frac{l\pi}{m+1}$，在实数域上有

1）变换 $\sigma_{n,m}$ 有一组特征向量 $(\frac{\sin i\alpha_k\sin j\alpha_l}{\sin\alpha_k\sin\alpha_l})_{1\le i\le n,1\le j\le m}$ 构成 $\mathbb{R}^{n\times m}$ 的基，对应的特征值分别为 $2\cos\alpha_k+2\cos\beta_l$；

2）方程（1）的基解为 $\{(\frac{\sin i\alpha_k\sin j\alpha_l}{\sin\alpha_k\sin\alpha_l})_{1\le i\le n,1\le j\le m}\mid 2\cos\alpha_k+2\cos\beta_l=c\}$，解空间维数等于满足 $2\cos\alpha_k+2\cos\beta_l=c$ 的 $(k,l)$ 组数。

至于当 $c$ 取特定值时怎么解 $2\cos\alpha_k+2\cos\beta_l=c$ 这里就不说了，与本文主题无关，在[我的回答](https://www.zhihu.com/question/373230831/answer/1030393890)里写了 $c=1$ 的解法。）

遗憾的是，假如多项式 $F_{n+1}(x)$ 有重根（此时由命题 5 可知必然凑不齐 $n$ 个线性无关的特征向量），或者根的个数不足 $n$ 个，上面的结论就不能直接用了。这两种情况都很常见，比如当 $n>p$ 时，有限域 $\mathbb{F}_p$ 上的多项式 $F_{n+1}(x)$ 显然找不出 $n$ 个互不相同的根。

## 重根，Jordan 标准形

这一节假设多项式 $F_{n+1}(x)$ 在域 $F$ 上有 $n$ 个根（允许重根），即设

$$F_{n+1}(x)=(x-\lambda_1)^{s_1}\cdots(x-\lambda_k)^{s_k},s_1+\cdots+s_k=n,\lambda_i\ne\lambda_j(i\ne j). $$

由 Hamilton-Caylay 定理可知 $F_{n+1}(M_n)=0$。

**命题9** 存在向量 $v\in F^n$ 使得 $v,M_nv,M_n^2v,\cdots,M_n^{n-1}v$ 线性无关。

证明：取 $v=(1,0,0,\cdots,0)^T$ 就满足条件（容易归纳证明向量 $M_n^iv$ 的第 $i+1$ 个分量为 1，且它右边的所有分量都为 0）。

**命题10** 若 $1\le i\le k,0\le r\le s_i$，则矩阵 $(M_n-\lambda_i I)^r$ 的化[零空间](https://zhida.zhihu.com/search?content_id=112392901&content_type=Article&match_order=1&q=%E9%9B%B6%E7%A9%BA%E9%97%B4&zhida_source=entity)维数为 $r$（或者等价地说，矩阵 $(M_n-\lambda_i I)^r$ 的秩为 $n-r$ ）。

证明：记 $V_{i,r}=\{v\in F^n\mid (M_n-\lambda_iI)^rv=0\}$。考虑 $n-r$ 次首一多项式

$$f(x)=F_{n+1}(x)/(x-\lambda_i)^r, $$

可知 $(x-\lambda_i)^rf(x)=F_{n+1}(x)$，于是 $(M_n-\lambda_i I)^rf(M_n)=0$，这说明对任意 $v\in F^n$ 都有 $f(M_n)v\in V_{i,r}$。

取 $v_0$ 为满足命题 9 条件的向量，记 $v_j=M_n^jv_0$，则 $v_0,\cdots,v_{n-1}$ 线性无关，因此是 $F^n$ 的一组基。注意到向量 $f(M_n)v_j(0\le j<r)$ 将 $f(M_n)$ 展开之后可以自然表示成$v_0,\cdots,v_{n-1}$ 的线性组合，其中 $v_{j+n-r}$ 的系数为 1 而后面 $v_{j+n-r+1},\cdots,v_{n-1}$ 所有项的系数都是 0，因此向量组 $f(M_n)v_j(0\le j<r)$ 线性无关。这说明 $\dim V_{i,r}\ge r$。

另一方面，由命题 5 可知 $\mathrm{rank}(M_n-\lambda_iI)=n-1$，于是由线性代数的定理可知

$$\mathrm{rank}((M_n-\lambda_iI)^r)\ge n-r. $$

综上可知命题成立。

**命题11** 线性空间 $V_{i,s_i}$ 存在一组基 $v_1,v_2,\cdots,v_{s_i}\in F^n$，满足

$$M_nv_1=\lambda_iv_1,M_nv_{j+1}=\lambda_iv_{j+1}+v_j(j=1,\cdots,s_i-1). $$

证明：取 $v_{s_i}\in V_{i,s_i}-V_{i,s_i-1}$，并记 $v_j=(M_n-\lambda_iI)^{s_i-j}v_{s_i},j=1,\cdots,s_i-1$，则有 $v_j\in V_{i,j}-V_{i,j-1}$，于是容易证明 $v_1,v_2,\cdots,v_{s_i}$ 满足命题中的所有等式，再通过正向归纳法可以证明 $v_1,\cdots,v_j$ 是线性空间 $V_{i,j}$ 的一组基，从而命题成立。

命题 11 可以用矩阵形式改写为

$$M_n(v_1,\cdots,v_{s_i})=(v_1,\cdots,v_{s_i})\left( \begin{matrix}    \lambda_i & 1 & 0 & \cdots & 0 & 0 \\    0 & \lambda_i & 1 & \cdots & 0 & 0 \\    0 & 0 & \lambda_i & \cdots & 0 & 0 \\    \vdots & \vdots & \vdots & \ddots & \vdots & \vdots \\    0 & 0 & 0 & \cdots & \lambda_i & 1 \\    0 & 0 & 0 & \cdots & 0 & \lambda_i   \end{matrix} \right), $$

右边出现的矩阵有些像 Jordan 块，不严谨地说，我们实际上证明了“每个特征值对应一个完整的 Jordan 块，而不是两个或多个”。

最后，由线性代数定理（王萼芳/[石生明](https://zhida.zhihu.com/search?content_id=112392901&content_type=Article&match_order=1&q=%E7%9F%B3%E7%94%9F%E6%98%8E&zhida_source=entity)《高等代数》第三版P309，定理12）可得

$$F^n=V_{1,s_1}\oplus\cdots\oplus V_{k,s_k}, $$

结合命题 11 可得

**命题12** 线性空间 $F^n$ 存在一组基 $v_{i,j}(1\le i\le k,1\le j\le s_i)$，满足

$$M_nv_{i,1}=\lambda_iv_{i,1},M_nv_{i,j+1}=\lambda_iv_{i,j+1}+v_{i,j}(i=1,\cdots,k;j=1,\cdots,s_i-1). $$

若将矩阵 $M_n$ 改写为关于这组基的矩阵，则该矩阵是由若干个 Jordan 块组成的[准对角矩阵](https://zhida.zhihu.com/search?content_id=112392901&content_type=Article&match_order=1&q=%E5%87%86%E5%AF%B9%E8%A7%92%E7%9F%A9%E9%98%B5&zhida_source=entity)，特征值 $\lambda_i$ 对应一个大小为 $s_i$ 的 Jordan 块。

## 标准[基向量](https://zhida.zhihu.com/search?content_id=112392901&content_type=Article&match_order=1&q=%E5%9F%BA%E5%90%91%E9%87%8F&zhida_source=entity)

命题 12 给出了一组基向量，矩阵 $M_n$ 在这组基向量下有非常简单的形式，然而命题 12 给出的形式还不够直观。接下来的定理直截了当地给出了一组满足同样性质的基向量。

定义多项式 $F_{i,j}(x)(i\ge 1,j\ge 0)$ 如下：

$$F_{1,j}(x)=F_j(x)(j\ge 0), \\ F_{i,0}(x)=F_{i,1}(x)=0(i\ge 2), \\ F_{i,j}(x)=xF_{i,j-1}(x)-F_{i,j-2}(x)+F_{i-1,j-1}(x)(i\ge 2,j\ge 2). $$

（容易看出当 $j<i$ 时总有 $F_{i,j}(x)=0$；利用归纳法还可以证明

$$F_{i,j}(x)=\sum_{j_1+\cdots+j_i=j}F_{j_1}(x)\cdots F_{j_i}(x), $$

不过这与本文无关）

**定理13** 若记

$$v_j=(F_{j,1}(\lambda_i),\cdots,F_{j,n}(\lambda_i))^T(j=1,\cdots,s_i), $$

则 $v_1,v_2,\cdots,v_{s_i}$是线性空间 $V_{i,s_i}$ 的一组基，且满足

$M_nv_1=\lambda_iv_1,M_nv_{j+1}=\lambda_iv_{j+1}+v_j(j=1,\cdots,s_i-1), \tag{2}$

称为**标准基**。

证明：直接验证需要证明 $F_{j,n+1}(\lambda_i)=0(j=1,\cdots,s_i)$，这并不容易（至少我没想到简单的证法），因此这里采取迂回手段。

由命题 11，先取一组线性空间 $V_{i,s_i}$ 的基 $v_1',\cdots,v'_{s_i}\in F^n$ 满足方程（2），我们的目的是试图对这组基进行变换（保持方程（2）始终成立），使这组基变成定理 13 所述的形式。变换过程如下：

i）向量 $v_1'$ 是特征值为 $\lambda_i$ 的特征向量，由命题 5 可知 $v_1'=c_1(F_{1,1}(\lambda_i),\cdots,F_{1,n}(\lambda_i))^T$，其中 $c_1\ne 0$。首先将所有 $v_j'$ 替换为 $c_1^{-1}v_j'$（替换后的向量仍记为 $v_j'$），方程（2）仍然成立，此时 $v_1'=(F_{1,1}(\lambda_i),\cdots,F_{1,n}(\lambda_i))^T$。

ii）设向量 $v_2'$ 的第一个坐标分量为 $c_2$，将所有 $v_{j+1}'$ 替换为 $v_{j+1}'-c_2v_j'$（注意是同时替换， $j$ 的取值为 $1,\cdots,s_i-1$），方程（2）仍然成立，此时 $v_2'$ 的第一个分量为 0，简单归纳即可证明 $v_2'=(F_{2,1}(\lambda_i),\cdots,F_{2,n}(\lambda_i))^T$。

iii）设向量 $v_3'$ 的第一个坐标分量为 $c_3$，将所有 $v_{j+2}'$ 替换为 $v_{j+2}'-c_3v_j'$（仍然是同时替换， $j$ 的取值为 $1,\cdots,s_i-2$），方程（2）仍然成立，此时 $v_3'$ 的第一个分量为 0，简单归纳即可证明 $v_3'=(F_{3,1}(\lambda_i),\cdots,F_{3,n}(\lambda_i))^T$。

……

以上过程重复进行直至最后一个向量 $v_{s_i}'$ 处理完毕，此时 $v_j=(F_{j,1}(\lambda_i),\cdots,F_{j,n}(\lambda_i))^T$ 对所有 $j=1,\cdots,s_i$ 都成立，定理得证。

（注意到我们实际上证明了 $F_{j,n+1}(\lambda_i)=0(j=1,\cdots,s_i)$，其中 $\lambda_i$ 是 $F_{n+1}(x)$ 的 $s_i$ 重根）

将各个线性空间 $V_{i,s_i}$ 的标准基合并起来就得到满足定理 12 的全空间的一组标准基。

## 基向量组合成方程（1）的基解

假设多项式 $F_{n+1}(x),F_{m+1}(x)$ 在域 $F$ 上可以完全分解为

$$F_{n+1}(x)=(x-\lambda_1)^{s_1}\cdots(x-\lambda_k)^{s_k},s_1+\cdots+s_k=n,\lambda_i\ne\lambda_j(i\ne j), \\ F_{m+1}(x)=(x-\mu_1)^{t_1}\cdots(x-\mu_l)^{t_l},t_1+\cdots+t_l=m,\mu_i\ne\mu_j(i\ne j), $$

则由定理 12，可以在线性空间 $F^n$ 中找到一组基 $u_{i,j}(1\le i\le k,1\le j\le s_i)$ 满足定理 12 所述的条件；类似地，可以在 $F^m$ 中找到一组基 $v_{i,j}(1\le i\le l,1\le j\le t_i)$ 满足定理 12 的条件。再由命题 2 可知，向量组

$$(u_{i_1,j_1}v_{i_2,j_2}^T\mid 1\le i_1\le k,1\le j_1\le s_{i_1},1\le i_2\le l,1\le j_2\le t_{i_2}) $$

线性无关。这个向量组包含 $nm$ 个向量，因此是 $F^{n\times m}$ 的一组基。

下面开始[解方程](https://zhida.zhihu.com/search?content_id=112392901&content_type=Article&match_order=1&q=%E8%A7%A3%E6%96%B9%E7%A8%8B&zhida_source=entity)（1），即 $M_nX+XM_m=cX$。记

$$X=\sum_{i_1=1}^k\sum_{j_1=1}^{s_{i_1}}\sum_{i_2=1}^l\sum_{j_2=1}^{t_{i_2}}c_{i_1,j_1,i_2,j_2}u_{i_1,j_1}v_{i_2,j_2}^T, $$

简单计算可得

$$F_nX+XF_m=\sum_{i_1=1}^k\sum_{j_1=1}^{s_{i_1}}\sum_{i_2=1}^l\sum_{j_2=1}^{t_{i_2}}((\lambda_{i_1}+\mu_{i_2})c_{i_1,j_1,i_2,j_2}+c_{i_1,j_1+1,i_2,j_2}+c_{i_1,j_1,i_2,j_2+1})u_{i_1,j_1}v_{i_2,j_2}^T, $$

（若出现下标越界，对应的 $c_{\cdots}$ 值一律规定为 0，例如 $j_1=s_{i_1}$ 时规定 $c_{i_1,j_1+1,i_2,j_2}=0$ ）

方程两边对照系数可得

$(\lambda_{i_1}+\mu_{i_2})c_{i_1,j_1,i_2,j_2}+c_{i_1,j_1+1,i_2,j_2}+c_{i_1,j_1,i_2,j_2+1}=c\cdot c_{i_1,j_1,i_2,j_2}. \tag{3}$

可以看到每个等式的两端 $c_{\cdots}$ 各项都共享相同的 $i_1$ 和 $i_2$，因此可以固定 $i_1,i_2$ 求解方程组。分两种情况讨论。

1）$\lambda_{i_1}+\mu_{i_2}\ne c.$

考虑取最大的[有序对](https://zhida.zhihu.com/search?content_id=112392901&content_type=Article&match_order=1&q=%E6%9C%89%E5%BA%8F%E5%AF%B9&zhida_source=entity) $(j_1,j_2)$（比较顺序时按字典序，先比较第一分量，若相等再比较第二分量）使得 $c_{i_1,j_1,i_2,j_2}\ne 0$，则有 $c_{i_1,j_1+1,i_2,j_2}=c_{i_1,j_1,i_2,j_2+1}=0$，方程（3）变为

$$(\lambda_{i_1}+\mu_{i_2})c_{i_1,j_1,i_2,j_2}=c\cdot c_{i_1,j_1,i_2,j_2}. $$

即 $c_{i_1,j_1,i_2,j_2}=0$，矛盾。这说明对任意有序对 $(j_1,j_2)$ 都有 $c_{i_1,j_1,i_2,j_2}=0$，换句话说下标对 $(i_1,i_2)$ 没有提供方程（1）的非零解。

2）$\lambda_{i_1}+\mu_{i_2}=c.$

此时方程（3）变为

$$c_{i_1,j_1+1,i_2,j_2}+c_{i_1,j_1,i_2,j_2+1}=0. $$

为了方便理解，可以将 $c_{i_1,j_1,i_2,j_2}$ 填入一个方格表的第 $j_1$ 行第 $j_2$ 列，行数超过 $s_{i_1}$ 或者列数超过 $t_{i_2}$ 的位置都填入 0，则上述方程意味着方格表的左下-右上相邻的两格互为相反数，也就是说每条副对角线的数字都是公比 -1 的[等比数列](https://zhida.zhihu.com/search?content_id=112392901&content_type=Article&match_order=1&q=%E7%AD%89%E6%AF%94%E6%95%B0%E5%88%97&zhida_source=entity)，并且如果副对角线下端没有接触最左边（或者右端没有接触最上边），这条对角线就只能都填 0。

记 $r=\min(s_{i_1},t_{i_2})$，由上式容易看出当 $j_1+j_2>r+1$ 时总有 $c_{i_1,j_1,i_2,j_2}=0$，而当 $2\le j_1+j_2\le r+1$ 时有 $c_{i_1,j_1,i_2,j_2}=(-1)^{j_2-1}c_{i_1,j_1+j_2-1,i_2,1}$，也就是说所有 $c_{i_1,j_1,i_2,j_2}$ 的值由 $c_{i_1,1,i_2,1},\cdots,c_{i_1,r,i_2,1}$ 决定，而 $c_{i_1,1,i_2,1},\cdots,c_{i_1,r,i_2,1}$ 这 $r$ 个数可以任意选取。换句话说，下标对 $(i_1,i_2)$ 提供了方程（1）的 $r$ 个线性无关解，它们分别是

$$\sum_{j=0}^{r'-1} (-1)^ju_{i_1,r'-j}v_{i_2,j+1}^T(r'=1,\cdots,r). $$

整理以上所有结果可得下面的定理。

**定理14** 若多项式 $F_{n+1}(x),F_{m+1}(x)$ 在域 $F$ 上可以完全分解为

$$F_{n+1}(x)=(x-\lambda_1)^{s_1}\cdots(x-\lambda_k)^{s_k},s_1+\cdots+s_k=n,\lambda_i\ne\lambda_j(i\ne j), \\ F_{m+1}(x)=(x-\mu_1)^{t_1}\cdots(x-\mu_l)^{t_l},t_1+\cdots+t_l=m,\mu_i\ne\mu_j(i\ne j), $$

由定理 13，在 $F^n,F^m$ 中各取一组标准基

$$u_{i,j}=(F_{j,1}(\lambda_i),\cdots,F_{j,n}(\lambda_i))^T(1\le i\le k,1\le j\le s_i), \\ v_{i,j}=(F_{j,1}(\mu_i),\cdots,F_{j,m}(\mu_i))^T(1\le i\le l,1\le j\le t_i), $$

则方程（1）的基解为

$$\{\sum_{j=0}^{r'-1} (-1)^ju_{i_1,r'-j}v_{i_2,j+1}^T\mid\lambda_{i_1}+\mu_{i_2}=c;r'=1,\cdots,\min(s_{i_1},t_{i_2})\}, $$

解空间维数等于 $\sum_{\lambda_{i_1}+\mu_{i_2}=c}\min(s_{i_1},t_{i_2})$，它等于 $\deg\gcd(F_{n+1}(x),F_{m+1}(c-x))$，即多项式 $F_{n+1}(x),F_{m+1}(c-x)$ 最大公因式的次数。

（等式 $\sum_{\lambda_{i_1}+\mu_{i_2}=c}\min(s_{i_1},t_{i_2})=\deg\gcd(F_{n+1}(x),F_{m+1}(c-x))$ 的正确性是显然的，因为由

$$F_{n+1}(x)=(x-\lambda_1)^{s_1}\cdots(x-\lambda_k)^{s_k}, \\ F_{m+1}(c-x)=(-1)^m(x-(c-\mu_1))^{t_1}\cdots(x-(c-\mu_l))^{t_l}, $$

可知当 $\lambda_{i_1}=c-\mu_{i_2}$ 时会有公因式 $(x-\lambda_{i_1})^{\min(s_{i_1},t_{i_2})}$）

## 根数不够，[扩域](https://zhida.zhihu.com/search?content_id=112392901&content_type=Article&match_order=1&q=%E6%89%A9%E5%9F%9F&zhida_source=entity)找根

最后我们考虑一般情况：$F_{n+1}(x)$ 可能不能在域 $F$ 上完全分解。这种情况其实很好办，根据域论的定理，可以找到一个域 $K\supseteq F$ 使得 $F_{n+1}(x),F_{m+1}(x)$ 在域 $K$ 上完全分解，然后就能用定理 14 了。由此可得下面的定理。

**定理15** 方程（1）的解空间维数等于 $\deg\gcd(F_{n+1}(x),F_{m+1}(c-x))$。

证明：找一个域 $K\supseteq F$ 使得 $F_{n+1}(x),F_{m+1}(x)$ 在域 $K$ 上完全分解，由定理 14 可知（在域 $K$ 上）方程（1）的解空间维数等于 $\deg\gcd(F_{n+1}(x),F_{m+1}(c-x))$。

注意方程（1）可以写成 $Ax=0$，其中 $A$ 是某个域 $F$ 上的 $nm$ 阶方阵，$x$ 是 $nm$ 维未知向量。这个方程的解空间维数等于 $nm-\mathrm{rank}(A)$，而矩阵 $A$ 的秩等于最大非零子式的阶数，它与在哪个域中计算无关，因此方程（1）在域 $F$ 和域 $K$ 上的解空间维数相等。

另一方面，$F[x]$ 中任意两个多项式在域 $F$ 和域 $K$ 上的最大公因式都相同（因为计算最大公因式可用[辗转相除法](https://zhida.zhihu.com/search?content_id=112392901&content_type=Article&match_order=1&q=%E8%BE%97%E8%BD%AC%E7%9B%B8%E9%99%A4%E6%B3%95&zhida_source=entity)，这与在哪个域中计算无关），因此 $F_{n+1}(x),F_{m+1}(c-x)$ 在域 $F$ 和域 $K$ 上的最大公因式次数相等。

综上可得在域 $F$ 上方程（1）的解空间维数等于 $\deg\gcd(F_{n+1}(x),F_{m+1}(c-x))$，定理成立。

定理 15 给出了方程（1）解空间维数的表示，但并没有告诉我们如何写出一组基解（由定理 14 给出的基解是域 $K$ 上的基解，不一定是域 $F$ 上的基解）。为此我们需要再次细致观察这组基解的形式。

注意到：若记 $f(x)$ 为 $F_{n+1}(x)$ 和 $F_{m+1}(c-x)$ 的最大公因式，由定理 14 可得 $f(x)$ 的每个 $r$ 重根 $\lambda$ 对应方程（1）的一组线性无关解

$$\{\sum_{j=0}^{r'-1} (-1)^j(F_{r'-j,a}(\lambda)F_{j+1,b}(c-\lambda))_{1\le a\le n,1\le b\le m}\mid r'=1,\cdots,r\}, $$

竖线左边的式子不妨用 $X(n,m,c,\lambda,r')$ 表示，则又可将定理 14 关于基解形式的结论重述为：向量组

$$\{X(n,m,c,\lambda,r')\mid\lambda\in K,r'\ge 1,(x-\lambda)^{r'}\ \mathrm{divides}\ f(x)\}, $$

是方程（1）的一组基解，其中

$$X(n,m,c,\lambda,r')=\sum_{j=0}^{r'-1} (-1)^j(F_{r'-j,a}(\lambda)F_{j+1,b}(c-\lambda))_{1\le a\le n,1\le b\le m}. $$

现在将 $f(x)$ 在域 $F$ 上分解因式：$f(x)=g_1(x)^{r_1}\cdots g_q(x)^{r_q}$，其中 $g_i(x)$ 是 $F$ 上互不相同的不可约首一多项式，可以看到在域 $K$ 上每个 $g_i(x)$ 可以继续分解为若干一次式的乘积，因此对应一个属于域 $F$ 的根（如果 $g_i(x)$ 本身是[一次式](https://zhida.zhihu.com/search?content_id=112392901&content_type=Article&match_order=2&q=%E4%B8%80%E6%AC%A1%E5%BC%8F&zhida_source=entity)）或者多个不属于域 $F$ 的根。同时可以证明：

1.  各个 $g_i(x)$ 对应的根互相不重复（若 $g_i(x),g_j(x)$ 两多项式有重复的根，则它们的最大公因式次数至少为 1，无论在哪个域上都是如此，但这与 $g_i(x),g_j(x)$ 是 $F$ 上不相同的不可约首一多项式矛盾）；
2.  各个 $g_i(x)$ 自身没有[重根](https://zhida.zhihu.com/search?content_id=112392901&content_type=Article&match_order=6&q=%E9%87%8D%E6%A0%B9&zhida_source=entity)。证明这一条稍微麻烦一些，看下面的引理：

**引理16** $g_i(x)$ 在 $K$ 上没有重根。

证明：若 $g_i(x)$ 有重根，则 $\gcd(g_i(x),g_i'(x))\ne 1$，由 $g_i(x)$ 不可约可知 $g_i'(x)=0$，这在特征为 0 的域中不可能出现，因此设域 $F$ 的特征为[素数](https://zhida.zhihu.com/search?content_id=112392901&content_type=Article&match_order=3&q=%E7%B4%A0%E6%95%B0&zhida_source=entity) $p$，同时可知 $g_i(x)$ 各个非零项的次数都是 $p$ 的倍数。

注意到 $F_{n+1}(x),F_{m+1}(x)$ 由定义显然是 $\mathbb{F}_p$ 上的多项式，故 $f(x)$ 也是 $\mathbb{F}_p$ 上的多项式。通过多次有限扩张依次将 $f(x)$ 的所有根添加进 $\mathbb{F}_p$，得到的域仍是有限域，设为 $\mathbb{F}_{p^e}$，此时多项式 $f(x)$ 的所有根都在 $\mathbb{F}_{p^e}$ 中，而多项式 $g_i(x)$ 等于若干个 $x-\lambda(\lambda\in\mathbb{F}_{p^e})$ 之积，显然也是 $\mathbb{F}_{p^e}$ 上的多项式。

设 $g_i(x)=x^{pr}+a_{r-1}x^{p(r-1)}+\cdots+a_1x^p+a_0$，则由[恒等式](https://zhida.zhihu.com/search?content_id=112392901&content_type=Article&match_order=1&q=%E6%81%92%E7%AD%89%E5%BC%8F&zhida_source=entity) $\alpha^{p^e}=\alpha(\alpha\in\mathbb{F}_{p^e})$ 以及特征为 $p$ 的域上的恒等式 $(\alpha+\beta)^p=\alpha^p+\beta^p$ 可知

$$\begin{align} g_i(x)&=x^{pr}+a_{r-1}^{p^e}x^{p(r-1)}+\cdots+a_1^{p^e}x^p+a_0^{p^e} \\ &=(x^r+a_{r-1}^{p^{e-1}}x^{r-1}+\cdots+a_1^{p^{e-1}}x+a_0^{p^{e-1}})^p, \end{align} $$

这与 $g_i(x)$ 在 $F$ 上不可约矛盾，因此[引理](https://zhida.zhihu.com/search?content_id=112392901&content_type=Article&match_order=3&q=%E5%BC%95%E7%90%86&zhida_source=entity)成立。

现在我们考察域 $F$ 上的[分解式](https://zhida.zhihu.com/search?content_id=112392901&content_type=Article&match_order=1&q=%E5%88%86%E8%A7%A3%E5%BC%8F&zhida_source=entity) $f(x)=g_1(x)^{r_1}\cdots g_q(x)^{r_q}$，由上述讨论可知[因式](https://zhida.zhihu.com/search?content_id=112392901&content_type=Article&match_order=9&q=%E5%9B%A0%E5%BC%8F&zhida_source=entity) $g_i(x)^{r_i}$ 对应 $d_i=\deg g_i(x)$ 个 $r_i$ 重根，不妨将这些根记为 $\lambda_{i,1},\cdots,\lambda_{i,d_i}$，由此导出方程（1）的一组[线性无关解](https://zhida.zhihu.com/search?content_id=112392901&content_type=Article&match_order=3&q=%E7%BA%BF%E6%80%A7%E6%97%A0%E5%85%B3%E8%A7%A3&zhida_source=entity) $X(n,m,c,\lambda_{i,j},r'),1\le j\le d_i,1\le r'\le r_i$。这些解通常不是域 $F$ 上的解，但是如果考虑

$$\sum_{j=1}^{d_i}\lambda_{i,j}^eX(n,m,c,\lambda_{i,j},r'),0\le e\le d_i-1,1\le r'\le r_i, $$

它们是 $X(n,m,c,\lambda_{i,j},r')$ 的[线性组合](https://zhida.zhihu.com/search?content_id=112392901&content_type=Article&match_order=2&q=%E7%BA%BF%E6%80%A7%E7%BB%84%E5%90%88&zhida_source=entity)，[系数矩阵](https://zhida.zhihu.com/search?content_id=112392901&content_type=Article&match_order=1&q=%E7%B3%BB%E6%95%B0%E7%9F%A9%E9%98%B5&zhida_source=entity)是由若干个 Vandermonde 矩阵组成的准对角矩阵，因而可逆（因为 $\lambda_{i,1},\cdots,\lambda_{i,d_i}$ 互不相等），因此该向量组与 $X(n,m,c,\lambda_{i,j},r')$ 等价，故也是方程（1）的基解。

另一方面，若固定 $n,m,c,r'$，则 $X(n,m,c,\cdot,r')$ 的每一个分量都是 $F$ 上的多项式，因此 $\sum_{j=1}^{d_i}\lambda_{i,j}^eX(n,m,c,\lambda_{i,j},r')$ 的每一项总能展开成若干个 $\sum_{j=1}^{d_i}\lambda_{i,j}^k$ 的线性组合。这是关于 $\lambda_{i,1},\cdots,\lambda_{i,d_i}$ 的对称多项式，它们又是 $g_i(x)$ 的所有根，因此每个 $\sum_{j=1}^{d_i}\lambda_{i,j}^k$ 都是域 $F$ 上的元素，从而 $\sum_{j=1}^{d_i}\lambda_{i,j}^eX(n,m,c,\lambda_{i,j},r')\in F^{n\times m}$。

至此我们终于找到了方程（1）在域 $F$ 上的一组基解，整理可得下面的定理。

**定理17** 若多项式 $F_{n+1}(x),F_{m+1}(c-x)$ 的最大公因式 $f(x)$ 在域 $F$ 上可以分解为

$$f(x)=g_1(x)^{r_1}\cdots g_q(x)^{r_q}, $$

其中 $g_i(x)$ 是 $F$ 上互不相同的不可约首一多项式，$r_i\ge 1$，记

$$X(n,m,c,\lambda,r')=\sum_{j=0}^{r'-1} (-1)^j(F_{r'-j,a}(\lambda)F_{j+1,b}(c-\lambda))_{1\le a\le n,1\le b\le m}, $$

则方程（1）有一组基解

$$\sum_{j=1}^{d_i}\lambda_{i,j}^eX(n,m,c,\lambda_{i,j},r'),1\le i\le q,0\le e\le d_i-1,1\le r'\le r_i, $$

其中 $\lambda_{i,1},\cdots,\lambda_{i,d_i}$是 $g_i(x)$ 在其[分裂域](https://zhida.zhihu.com/search?content_id=112392901&content_type=Article&match_order=1&q=%E5%88%86%E8%A3%82%E5%9F%9F&zhida_source=entity)中的所有根；并且方程（1）的解空间维数等于 $f(x)$ 的次数。

## 后记

定理 15 和定理 17 给出了方程（1）基础解系的一种直接表示——虽然按照这些定理计算基解还不如直接高斯消元快，但这两个定理揭示了矩阵填数游戏与 Chebyshev 多项式的深刻联系，研究 Chebyshev 多项式的一些性质可以反过来让我们更加深入理解矩阵填数游戏。

\*关于高斯消元：直接设第一行所有未知数推出线性方程组再[高斯消元](https://zhida.zhihu.com/search?content_id=112392901&content_type=Article&match_order=3&q=%E9%AB%98%E6%96%AF%E6%B6%88%E5%85%83&zhida_source=entity)，对有限域 $\mathbb{F}_p$（假设 $p$ 足够小，$\mathbb{F}_p$ 上的加减乘除仅消耗常数时间），解 $n\times m(n\le m)$ 方格的[时间复杂度](https://zhida.zhihu.com/search?content_id=112392901&content_type=Article&match_order=1&q=%E6%97%B6%E9%97%B4%E5%A4%8D%E6%9D%82%E5%BA%A6&zhida_source=entity)不会超过 $O(n^2m)$（当 $m$ 远大于 $n$ 时还可用[矩阵乘法](https://zhida.zhihu.com/search?content_id=112392901&content_type=Article&match_order=1&q=%E7%9F%A9%E9%98%B5%E4%B9%98%E6%B3%95&zhida_source=entity)快速幂优化）。这个算法简明易懂，但由于偏离本文主题，就不专门叙述这个算法了，具体参考[这篇文章](https://zhuanlan.zhihu.com/p/53646257)。

如果有下一篇文章的话，应该会有这么几条内容：

1.  Chebyshev 多项式的一些性质，以及相对应的方格填数问题的一些特殊结论（此处会直接引用相关文献的内容）；
2.  c=0 的情况（这种情况[解空间](https://zhida.zhihu.com/search?content_id=112392901&content_type=Article&match_order=13&q=%E8%A7%A3%E7%A9%BA%E9%97%B4&zhida_source=entity)的维数很容易表示，读者不妨把 c=0 代入定理 15 试试；基础解系也有非常简洁的表示）；
3.  利用定理 17 画出域 $\mathbb{F}_2$ 上某些 $n,m$ 的几组基解（毕竟定理 17 的形式是整齐优美的，很想看看画出的基解是什么样）。

最后推荐对点灯游戏感兴趣的读者看一下这个网站：

[https://link.zhihu.com/?target=https%3A//www.jaapsch.net/puzzles/lights.htm](https://link.zhihu.com/?target=https%3A//www.jaapsch.net/puzzles/lights.htm)

介绍了点灯游戏的很多变种以及一些简单的数学结论，并列出了一些研究[点灯游戏](https://zhida.zhihu.com/search?content_id=112392901&content_type=Article&match_order=9&q=%E7%82%B9%E7%81%AF%E6%B8%B8%E6%88%8F&zhida_source=entity)的论文。