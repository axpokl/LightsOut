本文是[上一篇文章](https://zhuanlan.zhihu.com/p/109180698)的续集。

**预告：上篇文章说过的基解[可视化](https://zhida.zhihu.com/search?content_id=112741269&content_type=Article&match_order=1&q=%E5%8F%AF%E8%A7%86%E5%8C%96&zhida_source=entity)在本文末尾，不想看中间推导过程的可以直接拉到最底下看图。**个人觉得这些图都相当地优美，大概这就是数学的魅力吧。

## Chebyshev 多项式的性质

回忆 Chebyshev 多项式的定义：

$$F_0(x)=0,F_1(x)=1,F_n(x)=xF_{n-1}(x)-F_{n-2}(x)(n\ge 2). $$

以上递推式的形式类似于 Fibonacci 数列，事实上 Chebyshev 多项式也有一些类似于 Fibonacci 数列的性质。

**引理18** 若补充定义 $F_{-1}(x)=-1$（这样上述[递推式](https://zhida.zhihu.com/search?content_id=112741269&content_type=Article&match_order=2&q=%E9%80%92%E6%8E%A8%E5%BC%8F&zhida_source=entity)对 $n=1$ 也成立），则对任意非负整数 $n,m$ 都有：

1）$F_{n+m}(x)=F_m(x)F_{n+1}(x)-F_{m-1}(x)F_n(x)$；

2）$\gcd(F_n(x),F_{n+1}(x))=1$；

3）$\gcd(F_n(x),F_{n+m}(x))=\gcd(F_n(x),F_m(x))$；

4）$\gcd(F_n(x),F_m(x))=F_{\gcd(n,m)}(x)$；

5）若 $m\mid n$，则 $F_m(x)\mid F_n(x)$。

证明：

1）对 $m$ 归纳，容易验证 $m=0,1$ 时等式成立。假设 $m=k,k+1$ [时等式](https://zhida.zhihu.com/search?content_id=112741269&content_type=Article&match_order=2&q=%E6%97%B6%E7%AD%89%E5%BC%8F&zhida_source=entity)成立，则由

$$\begin{align} F_{n+k+2}(x)&=xF_{n+k+1}(x)-F_{n+k}(x) \\ &=x(F_{k+1}(x)F_{n+1}(x)-F_k(x)F_n(x))-(F_k(x)F_{n+1}(x)-F_{k-1}(x)F_n(x)) \\ &=(xF_{k+1}(x)F_{n+1}(x)-F_k(x)F_{n+1}(x))-(xF_k(x)F_n(x)-F_{k-1}(x)F_n(x)) \\ &=(xF_{k+1}(x)-F_k(x))F_{n+1}(x)-(xF_k(x)-F_{k-1}(x))F_n(x) \\ &=F_{k+2}(x)F_{n+1}(x)-F_{k+1}(x)F_n(x), \end{align} $$

从而 $m=k+2$ 时等式也成立。

2）可用归纳法证明，或者直接由

$$\begin{align} \gcd(F_{n+1}(x),F_{n+2}(x))&=\gcd(F_{n+1}(x),xF_{n+1}(x)-F_n(x)) \\ &=\gcd(F_{n+1}(x),-F_n(x)) \\ &=\gcd(F_{n+1}(x),F_n(x)) \end{align} $$

重复以上步骤得到 $\gcd(F_n(x),F_{n+1}(x))=\gcd(F_0(x),F_1(x))=\gcd(0,1)=1$。

3）若 $d(x)$ 是 $F_n(x),F_m(x)$ 的公因式，则由（1）立即可得 $d(x)$ 整除 $F_{n+m}(x)$；反过来，若 $d(x)$ 是 $F_n(x),F_{n+m}(x)$ 的公因式，由（1）可得 $d(x)$ 整除 $F_m(x)F_{n+1}(x)$，结合 $\gcd(F_n(x),F_{n+1}(x))=1$ 可以推出 $d(x)$ 整除 $F_m(x)$。以上说明 $F_n(x),F_m(x)$ 的公因式集合与 $F_n(x),F_{n+m}(x)$ 的公因式集合相同，因此二者最大公因式也相等。

4）由（3）直接用[辗转相除](https://zhida.zhihu.com/search?content_id=112741269&content_type=Article&match_order=1&q=%E8%BE%97%E8%BD%AC%E7%9B%B8%E9%99%A4&zhida_source=entity)可得 $\gcd(F_n(x),F_m(x))=\gcd(F_{\gcd(n,m)}(x),F_0(x))$，再结合 $F_0(x)=0$ 以及 $F_k(x)(k\ge 1)$ 是首一多项式可得结论。

对 $n=m=0$ 的特殊情况，通常规定 $\gcd(0,0)=0$（无论 $0$ 作为整数还是作为多项式都是如此），等式显然还是成立的。

5）由（4）立即可得。

**定义19** 对任意[非零多项式](https://zhida.zhihu.com/search?content_id=112741269&content_type=Article&match_order=1&q=%E9%9D%9E%E9%9B%B6%E5%A4%9A%E9%A1%B9%E5%BC%8F&zhida_source=entity) $f(x)$，若存在正整数 $n$ 使得 $f(x)\mid F_n(x)$，则称满足该条件的最小正整数 $n$ 为 $f(x)$ 的**深度**，记为 $\mathrm{dep}(f)$。若不存在这样的正整数 $n$，记 $\mathrm{dep}(f)=\infty$。

由引理 18 的（4）和（5）立即可得：

**推论20** 对任意非负整数 $n$，$f(x)\mid F_n(x)$ 当且仅当 $\mathrm{dep}(f)\mid n$。

这里我们约定 $\infty$ 不整除任何正整数。

## 基解的“基解”

回忆上一篇文章最终得到的定理：

**定理17** 若多项式 $F_{n+1}(x),F_{m+1}(c-x)$ 的最大公因式 $f(x)$ 在域 $F$ 上可以分解为

$$f(x)=g_1(x)^{r_1}\cdots g_q(x)^{r_q}, $$

其中 $g_i(x)$ 是 $F$ 上互不相同的不可约首一多项式，$r_i\ge 1$，记

$$X(n,m,c,\lambda,r')=\sum_{j=0}^{r'-1} (-1)^j(F_{r'-j,a}(\lambda)F_{j+1,b}(c-\lambda))_{1\le a\le n,1\le b\le m}, $$

则方程（1）有一组基解

$$\sum_{j=1}^{d_i}\lambda_{i,j}^eX(n,m,c,\lambda_{i,j},r'),1\le i\le q,0\le e\le d_i-1,1\le r'\le r_i, $$

其中 $\lambda_{i,1},\cdots,\lambda_{i,d_i}$是 $g_i(x)$ 在其分裂域中的所有根；并且方程（1）的解空间维数等于 $f(x)$ 的次数。

注意到式子 $\sum_{j=1}^{d_i}\lambda_{i,j}^eX(n,m,c,\lambda_{i,j},r')$ 只与 $n,m,c,r'$ 以及多项式 $g_i(x)$ 在其分裂域中的所有根 $\lambda_{i,1},\cdots,\lambda_{i,d_i}$有关，换句话说式子 $\sum_{j=1}^{d_i}\lambda_{i,j}^eX(n,m,c,\lambda_{i,j},r')$ 的取值只由参数 $n,m,c,r'$ 以及多项式 $g_i(x)$ 决定，因此我们改记

$$S_e(n,m,c,g_i(x)^{r'})=\sum_{j=1}^{d_i}\lambda_{i,j}^eX(n,m,c,\lambda_{i,j},r'),0\le e\le d_i-1. $$

定理中对 $g_i(x)$ 和 $r'$ 的全部约束条件为：$g_i(x)$ 是 $f(x)$ 的[不可约因子](https://zhida.zhihu.com/search?content_id=112741269&content_type=Article&match_order=1&q=%E4%B8%8D%E5%8F%AF%E7%BA%A6%E5%9B%A0%E5%AD%90&zhida_source=entity)，$r'$ 是不超过 $g_i(x)$ 在 $f(x)$ [分解式](https://zhida.zhihu.com/search?content_id=112741269&content_type=Article&match_order=1&q=%E5%88%86%E8%A7%A3%E5%BC%8F&zhida_source=entity)中次数的任意正整数。这个条件刚好等价于 $g_i(x)^{r'}\mid f(x)$。综上所述，可以将定理 17 改写为更加简练的形式：

**定理17'** 对任意 $n,m,c$，方程（1）有一组基解

$$S_e(n,m,c,g(x)^r),0\le e\le\deg g(x)-1, $$

其中 $g(x),r$ 各自取遍所有不可约多项式和所有正整数，满足条件

$$g(x)^r\mid\gcd(F_{n+1}(x),F_{m+1}(x-c)). $$

（注意上述定理中将 $F_{m+1}(c-x)$ 偷换成了 $F_{m+1}(x-c)$，这是因为二者要么相等要么差一个 -1 倍，可以相互替换，因此换成 $F_{m+1}(x-c)$ 确保是首一多项式）

利用 $g(x)^r\mid F_{m+1}(x-c)$ 当且仅当 $g(x+c)^r\mid F_{m+1}(x)$，再根据推论 20 又可将上述表述改写为

**定理17''** 对任意 $n,m,c$，方程（1）有一组基解

$$S_e(n,m,c,g(x)^r),0\le e\le\deg g(x)-1, $$

其中 $g(x),r$ 各自取遍所有不可约多项式和所有正整数，满足条件

$$\mathrm{dep}(g(x)^r)\mid n+1,\mathrm{dep}(g(x+c)^r)\mid m+1. $$

（别忘了我们约定 $\infty$ 不整除任何正整数，如果深度为 $\infty$ 说明这组解为空集）

现在我们换一个角度看这些基解，不把它们按照 $(n,m)$ 分组，而是把它们按照 $g(x)^r$ 是否相同来分组，定理又可再次重新叙述为

**定理17'''** 对任意 $c\in F$，不可约多项式 $g(x)\in F[x]$，以及正整数 $r$，记

$$n_0=\mathrm{dep}(g(x)^r),m_0=\mathrm{dep}(g(x+c)^r), $$

若 $n_0,m_0\ne\infty$，则称 $kn_0-1$ 行 $lm_0-1$ 列的[矩阵](https://zhida.zhihu.com/search?content_id=112741269&content_type=Article&match_order=1&q=%E7%9F%A9%E9%98%B5&zhida_source=entity)

$$S_e(kn_0-1,lm_0-1,c,g(x)^r),0\le e\le\deg g(x)-1,k\ge 1,l\ge 1 $$

为**标准基**。对任意 $n,m,c$，将所有大小为 $n\times m$ 的标准基组合起来就是方程（1）的一组基解。

若固定 $c$ 值，经过试验容易发现：$g(x)^r$ 相同的一族标准基有非常明显的模式。例如取

$$F=\mathbb{F}_2,c=-1,g(x)=1+x+x^2,r=2, $$

取不同的 $0\le e\le 1,k\ge 1,l\ge 1$ 就可以得到不同的标准基。为了能直观地看到这些解，我们用白色和黑色表示 $\mathbb{F}_2$ 的两个元素 0 和 1，将这些解转化为黑白方格图。分别取 $(k,l)$ 为 $(1,1),(2,3)$，得到的标准基如下图所示：

![](https://pic3.zhimg.com/v2-00d3a3b2b6010fe160b206629e488fd6_r.jpg)

规律很明显：$(k,l)=(2,3)$ 的两个标准基就是由 $(k,l)=(1,1)$ 的两个标准基**通过若干次镜像翻转操作**（上下和左右都翻转，每次翻转都在中间填充一排 0）得到的。实际上这条规律并不准确，当域的特征不为 2 时，每次翻转还要进行**反色**操作，即将 $t$ 替换为 $-t$，只不过在特征为 2 的域中将 $t$ 替换为 $-t$ 等于不变而已。下面是域 $\mathbb{F}_3$ 的一个例子，仍然取 $c=-1$，其中白色、灰色、黑色分别表示 0, 1, 2，可以看到每次镜像翻转都附带一次反色操作。

![](https://pic2.zhimg.com/v2-d4459d45e269e5d0e54e6df70e2c0961_1440w.jpg)

不妨将这种操作简称为镜像反色操作，容易看出镜像反色操作不仅适用于标准基，事实上**任何 $(n-1)\times(m-1)$ 的解都可以通过镜像反色操作得到 $(kn-1)\times(lm-1)$ 的解**（直接运代入[原始方程](https://zhida.zhihu.com/search?content_id=112741269&content_type=Article&match_order=1&q=%E5%8E%9F%E5%A7%8B%E6%96%B9%E7%A8%8B&zhida_source=entity)就能验证）。

回头看定理 17'''，既然已经找到规律，我们只需证标准基 $S_e(kn_0-1,lm_0-1,c,g(x)^r)$ 的确可由标准解 $S_e(n_0-1,m_0-1,c,g(x)^r)$ 通过镜像反色操作得到，这不算很困难。

**引理21** 设 $g(x)$ 是[不可约多项式](https://zhida.zhihu.com/search?content_id=112741269&content_type=Article&match_order=4&q=%E4%B8%8D%E5%8F%AF%E7%BA%A6%E5%A4%9A%E9%A1%B9%E5%BC%8F&zhida_source=entity)，$r$ 是正整数，满足 $g(x)^r\mid F_n(x)$，记 $g(x)$ 在分裂域中所有根为 $\lambda_1,\cdots,\lambda_d$，则有：

（1）对任意 $1\le r'\le r,1\le i\le d$ 有 $F_{r',n}(\lambda_i)=0$；

（2）对任意 $1\le r'\le r,1\le i\le d,s\ge 1,0\le t\le n$ 有

$$F_{r',sn}(\lambda_i)=0,F_{r',sn+t}(\lambda_i)=-F_{r',sn-t}(\lambda_i). $$

证明：

（1）将 $F_n(x)$ 在分裂域中完全分解，其中有因子 $x-\lambda_i$ 且其次数大于等于 $r$，在上一篇文章的定理 13 中已经证明了 $F_{r',n}(\lambda_i)=0$；

（2）利用 $F_{a,b}(x)$ 的递推式（见上一篇文章）用[归纳法](https://zhida.zhihu.com/search?content_id=112741269&content_type=Article&match_order=2&q=%E5%BD%92%E7%BA%B3%E6%B3%95&zhida_source=entity)易证，这里懒得写步骤了……

由此立即可得下面的定理。

**定理22** 设 $g(x)$ 是不可约多项式，$r$ 是正整数，满足 $g(x)^r\mid F_n(x),g(x)^r\mid F_m(x+c)$，记 $g(x)$ 在[分裂域](https://zhida.zhihu.com/search?content_id=112741269&content_type=Article&match_order=5&q=%E5%88%86%E8%A3%82%E5%9F%9F&zhida_source=entity)中所有根为 $\lambda_1,\cdots,\lambda_d$，则有：

（1）$X(kn-1,lm-1,c,\lambda_i,r)(1\le i\le d)$ 是由 $X(n-1,m-1,c,\lambda_i,r)$ 通过镜像反色操作得到的；

（2）$S_e(kn-1,lm-1,c,g(x)^r)(0\le e\le d-1)$ 是由 $S_e(n-1,m-1,c,g(x)^r)$ 通过镜像反色操作得到的。

由此可以看出，我们只需研究定理 17''' 中由 $k=l=1$ 导出的解，而 $k,l$ 取其他值的解都可以由 $k=l=1$ 对应的解通过简单的镜像反色操作得到。

**定义23** 对任意 $c\in F$，不可约多项式 $g(x)\in F[x]$，以及正整数 $r$，记

$$n_0=\mathrm{dep}(g(x)^r),m_0=\mathrm{dep}(g(x+c)^r), $$

若 $n_0,m_0\ne\infty$，则称 $n_0-1$ 行 $m_0-1$ 列的矩阵

$$S_e(n_0-1,m_0-1,c,g(x)^r),0\le e\le\deg g(x)-1 $$

为**单体标准基**，简称单体。（命名“单体”是为了区别于照镜子出现的“多体”）

## c=0 的情况

若取 c=0，直接代入定理 17 立即可得方程（1）的解空间维数等于

$$\begin{align} \deg\gcd(F_{n+1}(x),F_{m+1}(-x))&=\deg\gcd(F_{n+1}(x),F_{m+1}(x)) \\ &=\deg F_{\gcd(n+1,m+1)}(x) \\ &=\gcd(n+1,m+1)-1, \end{align} $$

可见此时解空间维数有非常容易计算的[表达式](https://zhida.zhihu.com/search?content_id=112741269&content_type=Article&match_order=1&q=%E8%A1%A8%E8%BE%BE%E5%BC%8F&zhida_source=entity)。不仅如此，当 c=0 时很容易给出方程（1）的一组基解。首先注意，对任意 $n\times n$ 正方形网格都有 $n$ 个线性无关解，如下图所示：

![域 GF(3) 上 5×5 方格对应的 5 个线性无关解（c=0）](https://pica.zhimg.com/v2-a45370458c9eefc7f771fd53dbfad986_r.jpg)

一般地，对任意 $n\times n$ 正方形方格，我们任取一个数字 $k=1,\cdots,n$，按照如下方式在方格的每个格子里填数：对第 $i$ 行第 $j$ 列的格子，检验条件

$$k+1\le i+j\le 2n-k+1,-(k-1)\le i-j\le k-1 $$

是否同时成立，如果不同时成立则在这个格子里填 0。如果同时成立，则考察 $i-1,j-k$ 的[奇偶性](https://zhida.zhihu.com/search?content_id=112741269&content_type=Article&match_order=1&q=%E5%A5%87%E5%81%B6%E6%80%A7&zhida_source=entity)，若同为偶数则填 1，同为奇数则填 -1，一奇一偶则填 0。

容易验证这样填出来的一组数字确实是方程（1）的解，即我们得到了[方程](https://zhida.zhihu.com/search?content_id=112741269&content_type=Article&match_order=10&q=%E6%96%B9%E7%A8%8B&zhida_source=entity)（1）的 $n$ 个解；又因为数字 $k$ 导出的解的第一行只有第 $k$ 个格子填了 1，剩下 $n-1$ 个格子都是 0，可得这 $n$ 个解线性无关，于是任意 $n\times n$ 正方形网格都有 $n$ 个线性无关解。之前的计算表明 $n\times n$ [正方形网格](https://zhida.zhihu.com/search?content_id=112741269&content_type=Article&match_order=3&q=%E6%AD%A3%E6%96%B9%E5%BD%A2%E7%BD%91%E6%A0%BC&zhida_source=entity)的解空间维数等于 $\gcd(n+1,n+1)-1=n$，因此这就是一组基解了。

对任意 $n\times m$ 方格，记 $d=\gcd(n+1,m+1)-1$，则 $n+1,m+1$ 均为 $d+1$ 的倍数，说明可以把 $d\times d$ 方格的一组基解通过镜像反色操作扩充为 $n\times m$ 方格的一组解，这些解显然仍是线性无关的，解数 $d$ 也等于之前计算出的解空间维数，说明这组解就是 $n\times m$ 方格的基解。

至此得到结论：当 $c=0$ 时，$n\times m$ 方格的解空间维数等于 $\gcd(n+1,m+1)-1$，并且通过以上操作可以构造出含 $\gcd(n+1,m+1)-1$ 个元素的一组基解。

## [幂次法则](https://zhida.zhihu.com/search?content_id=112741269&content_type=Article&match_order=1&q=%E5%B9%82%E6%AC%A1%E6%B3%95%E5%88%99&zhida_source=entity)

我们知道特征为素数 p 的域上有一条特殊的[恒等式](https://zhida.zhihu.com/search?content_id=112741269&content_type=Article&match_order=1&q=%E6%81%92%E7%AD%89%E5%BC%8F&zhida_source=entity) $(x+y)^p=x^p+y^p$ 成立，由此可以得到 Chebyshev 多项式在 p [特征域](https://zhida.zhihu.com/search?content_id=112741269&content_type=Article&match_order=1&q=%E7%89%B9%E5%BE%81%E5%9F%9F&zhida_source=entity)上非常重要的幂次性质。

**引理24** 对任意域 $F$，在[分式域](https://zhida.zhihu.com/search?content_id=112741269&content_type=Article&match_order=1&q=%E5%88%86%E5%BC%8F%E5%9F%9F&zhida_source=entity) $F(x)$ 中添加多项式 $t^2-xt+1$ 的两根 $\alpha,\beta$ 得到[扩域](https://zhida.zhihu.com/search?content_id=112741269&content_type=Article&match_order=1&q=%E6%89%A9%E5%9F%9F&zhida_source=entity) $K$，则在域 $K$ 中成立等式

$$F_n(x)=(\alpha^n-\alpha^{-n})/(\alpha-\alpha^{-1}),n\ge 0， $$

其中 $F_n(x)$ 是域 $F$ 中定义的 Chebyshev 多项式。

这个引理直接用归纳法即可证明。

**命题25** 在特征为素数 $p$ 的域 $F$ 中，对任意非负整数 $k,m$ 有[多项式等式](https://zhida.zhihu.com/search?content_id=112741269&content_type=Article&match_order=1&q=%E5%A4%9A%E9%A1%B9%E5%BC%8F%E7%AD%89%E5%BC%8F&zhida_source=entity)

1）$F_{p^km}(x)=F_{p^k}(x)F_m^{p^k}(x);$

2）若 $p=2$，则 $F_{2^k}(x)=x^{2^k-1}$；若 $p\ne 2$，则 $F_{p^k}(x)=(x^2-4)^{(p^k-1)/2}$。

证明：

1）在引理 24 构造的域 $K$ 中有

$$F_{p^km}(x)=\frac{\alpha^{p^km}-\alpha^{-p^km}}{\alpha-\alpha^{-1}}=\frac{\alpha^{p^k}-\alpha^{-p^k}}{\alpha-\alpha^{-1}}(\frac{\alpha^m-\alpha^{-m}}{\alpha-\alpha^{-1}})^{p^k}=F_{p^k}(x)F_m^{p^k}(x). $$

（这里反复利用了 $(\gamma+\delta)^p=\gamma^p+\delta^p$）

等式两端都是[多项式环](https://zhida.zhihu.com/search?content_id=112741269&content_type=Article&match_order=1&q=%E5%A4%9A%E9%A1%B9%E5%BC%8F%E7%8E%AF&zhida_source=entity) $F[x]$ 中的元素，它们必然是同一个多项式。

2）注意 $x=\alpha+\beta=\alpha+\alpha^{-1}$。若 $p=2$，则有

$$F_{2^k}(x)=\frac{\alpha^{2^k}-\alpha^{-2^k}}{\alpha-\alpha^{-1}}=\frac{(\alpha-\alpha^{-1})^{2^k}}{\alpha-\alpha^{-1}}=(\alpha-\alpha^{-1})^{2^k-1}=(\alpha+\alpha^{-1})^{2^k-1}=x^{2^k-1}; $$

若 $p\ne2$，则有

$$F_{p^k}(x)=\frac{\alpha^{p^k}-\alpha^{-p^k}}{\alpha-\alpha^{-1}}=\frac{(\alpha-\alpha^{-1})^{p^k}}{\alpha-\alpha^{-1}}=(\alpha-\alpha^{-1})^{p^k-1}, $$

再由

$$(\alpha-\alpha^{-1})^2=(\alpha+\alpha^{-1})^2-4=x^2-4 $$

即可推出 $F_{p^k}(x)=(x^2-4)^{(p^k-1)/2}$。

由命题 25 立刻可以得到同一不可约多项式不同次幂对应深度的关系。

**命题26** 在特征为[素数](https://zhida.zhihu.com/search?content_id=112741269&content_type=Article&match_order=3&q=%E7%B4%A0%E6%95%B0&zhida_source=entity) $p$ 的域 $F$ 中，设 $g(x)\ne x\pm 2$ 是不可约多项式，$n=\mathrm{dep}(g(x))$ 且不是无穷大，则必有 $p\not\mid n$。若再设在 $F_n(x)$ 的分解式中 $g(x)$ 的幂次为 $r_0$，则有

$$\begin{align} \mathrm{dep}(g(x)^r)&=n(1\le r\le r_0); \\ \mathrm{dep}(g(x)^r)&=p^kn(p^{k-1}r_0<r\le p^kr_0,k\ge 1). \end{align} $$

证明：若 $p\mid n$，则由 $g(x)\mid F_n(x)$ 以及命题 25，结合 $g(x)\ne x\pm 2$ 立即可得 $g(x)$ 整除 $F_{n/p}(x)$，这与深度的定义矛盾，因此 $p\not\mid n$。

对后一半命题，首先由已知条件可知 $g(x),\cdots,g(x)^{r_0}$ 的深度都等于 $n$，从而 $k=0$ 时命题成立。

接下来用归纳法证明 $\mathrm{dep}(g(x)^r)=p^kn(p^{k-1}r_0<r\le p^kr_0)$。我们假设 $k\ge 1$ 并且归纳假设 $\mathrm{dep}(g(x)^{p^{k-1}r_0})=p^{k-1}n$。注意到

1）首先由 $g(x)^{r_0}\mid F_n(x)$ 以及命题 25 立即可得

$$g(x)^{p^kr_0}\mid F_{p^kn}(x)=F_{p^k}(x)F_n^{p^k}(x), $$

于是 $\mathrm{dep}(g(x)^{p^kr_0})\le p^kn$；

2）假设 $\mathrm{dep}(g(x)^{p^{k-1}r_0+1})=a<p^kn$，由推论 20 可得 $a\mid p^kn$ 以及 $p^{k-1}n\mid a$，从而只能有 $a=p^{k-1}n$。但 $F_{p^{k-1}n}(x)=F_{p^{k-1}}(x)F_n^{p^{k-1}}(x)$ 的不可约因子分解式中 $g(x)$ 的次数应该是 $p^{k-1}r_0$，这与 $\mathrm{dep}(g(x)^{p^{k-1}r_0+1})=a=p^{k-1}n$ 矛盾。

由（1）和（2）完成了归纳法证明，待证命题成立。

以上命题说明对大多数 $g(x)$，只要确定 $g(x)$ 的深度 $n$ 以及 $g(x)$ 在 $F_n(x)$ 分解式中的次数（后面会讲如何确定这个次数），即可完全确定所有 $g(x)^r$ 的深度。当然，对 $g(x)=x\pm 2$ 上述命题不适用，规律略有不同。

**命题26（补充）**

1）在特征为 $2$ 的域 $F$ 中有

$$\mathrm{dep}(x^r)=2^{k+1}(2^k\le r\le 2^{k+1}-1,k\ge 0); $$

2）在特征为素数 $p\ne 2$ 的域 $F$ 中有

$$\mathrm{dep}((x+2)^r)=\mathrm{dep}((x-2)^r)=p^{k+1}(\frac{p^k+1}{2}\le r\le\frac{p^{k+1}-1}{2},k\ge 0). $$

证明：首先求 $F_n(x)$ 在 $\pm2$ 处的值，由递推式可知

$$F_0(\pm2)=0,F_1(\pm2)=1,F_{n+2}(\pm2)=\pm2F_{n+1}(x)-F_n(x), $$

容易推出 $F_n(2)=n,F_n(-2)=(-1)^nn$，因此 $x\pm 2$ 整除 $F_n(x)$ 当且仅当 $F_n(\pm2)=0$ 当且仅当 $p\mid n$，其中 $p$ 是域的特征（注意不管是否有 $p=2$ 这都是成立的，同时别忘了在特征为 $2$ 的域上 $x+2=x-2=x$）。

1）由命题 25 可知对任意非负整数 $k$ 以及正奇数 $m$ 都有

$$F_{2^km}(x)=F_{2^k}(x)F_m^{2^k}(x)=x^{2^k-1}F_m^{2^k}(x), $$

而 $F_m^{2^k}(x)$ 和 $x$ 是[互素多项式](https://zhida.zhihu.com/search?content_id=112741269&content_type=Article&match_order=1&q=%E4%BA%92%E7%B4%A0%E5%A4%9A%E9%A1%B9%E5%BC%8F&zhida_source=entity)，因此 $F_{2^km}(x)$ 的分解式中 $x$ 的次数等于 $2^k-1$，由此可得命题成立。

2）由命题 25 可知对任意非负整数 $k$ 以及不被 $p$ 整除的正整数 $m$ 都有

$$F_{p^km}(x)=F_{p^k}(x)F_m^{p^k}(x)=(x+2)^{(p^k-1)/2}(x-2)^{(p^k-1)/2}F_m^{p^k}(x), $$

而 $F_m^{p^k}(x)$ 和 $x\pm 2$ 都是互素多项式，因此 $F_{p^km}(x)$ 的分解式中 $x+2,x-2$ 的次数都等于 $(p^k-1)/2$，由此可得命题成立。

## [有限域](https://zhida.zhihu.com/search?content_id=112741269&content_type=Article&match_order=1&q=%E6%9C%89%E9%99%90%E5%9F%9F&zhida_source=entity)

从根本上来说，如果要研究特征为素数 p 的域上的方格填数问题，完全可以假设这个域是有限域（进一步说，可以假设这个域是 $\mathbb{F}_p(c)$，并且常数 c 是 $\mathbb{F}_p$ 上某个不可约多项式的根）。这是因为：

1）由上一篇文章的定理 14 可知，如果方格填数问题的方程（1）有非零解，那么 c 一定是 $F_{n+1}(x)$ 的某个根和 $F_{m+1}(x)$ 的某个根之和。设这两个根分别为 $\alpha,\beta$，则 $\mathbb{F}_p\subseteq\mathbb{F}_p(\alpha)(\beta)$ 是[代数扩张](https://zhida.zhihu.com/search?content_id=112741269&content_type=Article&match_order=1&q=%E4%BB%A3%E6%95%B0%E6%89%A9%E5%BC%A0&zhida_source=entity)，从而 $\mathbb{F}_p(\alpha,\beta)$ 是有限域，再由 $c=\alpha+\beta$ 可知 $\mathbb{F}_p(c)$ 是有限域。

换句话说，如果 $\mathbb{F}_p(c)$ 不是有限域，那么方程（1）没有非零解，也就没有研究的必要了。

2）之前提到过，既然方程（1）是域 $\mathbb{F}_p(c)$ 上的方程，只要 $\mathbb{F}_p(c)\subseteq F$，那么域 $\mathbb{F}_p(c)$ 上的一组基解必然也是域 $F$ 上的基解。因此只要在域 $\mathbb{F}_p(c)$ 上研究方程（1）的基解就可以了。

**本节将总是在有限域 $F=\mathbb{F}_p(c)=\mathbb{F}_{p^e}$ 上研究问题，其中 p 是素数，e 是正整数。**首先我们证明：任意不可约多项式的深度都是有限的。

**命题27**

1）若 $p=2$，则对任意 $k\ge 0$ 有

$$F_{2^k-1}(x)F_{2^k+1}(x)=(x^{2^k-1}-1)^2; $$

2）若 $p\ne 2$，则对任意 $k\ge 0$ 有

$$F_{(p^k-1)/2}(x)F_{(p^k+1)/2}(x)=(x^{p^k}-x)/(x^2-4). $$

证明：我们依然在引理 24 构造的域 $K$ 中考虑问题。

1）由引理 24 可得

$$\begin{align} F_{2^k-1}(x)F_{2^k+1}(x)&=\frac{\alpha^{2^k-1}-\alpha^{-(2^k-1)}}{\alpha-\alpha^{-1}}\frac{\alpha^{2^k+1}-\alpha^{-(2^k+1)}}{\alpha-\alpha^{-1}} \\ &=\frac{\alpha^{2^{k+1}}+\alpha^{-2^{k+1}}-\alpha^2-\alpha^{-2}}{(\alpha-\alpha^{-1})^2} \\ &=\frac{(\alpha+\alpha^{-1})^{2^{k+1}}-(\alpha+\alpha^{-1})^2}{(\alpha+\alpha^{-1})^2} \\ &=x^{2^{k+1}-2}-1=(x^{2^k-1}-1)^2. \end{align} $$

2）由引理 24 可得

$$\begin{align} F_{(p^k-1)/2}(x)F_{(p^k+1)/2}(x)&=\frac{\alpha^{(p^k-1)/2}-\alpha^{-(p^k-1)/2}}{\alpha-\alpha^{-1}}\frac{\alpha^{(p^k+1)/2}-\alpha^{-(p^k+1)/2}}{\alpha-\alpha^{-1}} \\ &=\frac{\alpha^{p^k}+\alpha^{-p^k}-\alpha-\alpha^{-1}}{(\alpha-\alpha^{-1})^2} \\ &=\frac{(\alpha+\alpha^{-1})^{p^k}-(\alpha+\alpha^{-1})}{(\alpha+\alpha^{-1})^2-4} \\ &=\frac{x^{p^k}-x}{x^2-4}. \end{align} $$

**命题28** 设 $g(x)$ 是域 $F$ 上的 $k$ 次不可约多项式，则有：

1）若 $g(x)\ne x\pm 2,p=2$，则 $g(x)$ 整除 $F_{2^{ke}-1}(x)$ 或者 $F_{2^{ke}+1}(x)$，但不同时整除二者；

2）若 $g(x)\ne x\pm 2,p\ne 2$，则 $g(x)$ 整除 $F_{(p^{ke}-1)/2}(x)$ 或者 $F_{(p^{ke}+1)/2}(x)$，但不同时整除二者；

3）若 $g(x)=x\pm 2$，则 $g(x)$ 整除 $F_p(x)$。

以上说明 $\mathrm{dep}(g(x))$ 一定是有限值。

证明：已知 $g(x)$ 是域 $\mathbb{F}_{p^e}$ 上的 $k$ 次多项式，由有限域的结论可知 $g(x)\mid x^{p^{ke}}-x$，结合命题 27 即可证明（1）与（2）的前半句；（1）与（2）的后半句只需注意到二者是互素多项式即可得出。最后用命题 26 的补充命题即可证明（3）。

可见在有限域上应用命题 26，不需要考虑 $g(x)$ 的深度为无穷大的情况。下面的命题告诉我们，若记 $n=\mathrm{dep}(g(x))$，则 $F_n(x)$ 的分解式中 $g(x)$ 的幂次为 $r_0$ 很容易确定。

**命题29**

1）若 $p=2$，则对任意奇数 $n$，多项式 $F_n(x)$ 是某个无平方因子多项式的平方；

2）若 $p\ne 2$，则对任意不被 $p$ 整除的正整数 $n$，多项式 $F_n(x)$ 无平方因子。

证明：

1）记 $n=2m+1$，由引理 18 可得

$$F_{2m+1}(x)=F_{m+1}(x)F_{m+1}(x)-F_m(x)F_m(x)=(F_{m+1}(x)+F_m(x))^2, $$

接下来只需要证明 $\Delta_m(x)=F_{m+1}(x)+F_m(x)$ 无平方因子即可。容易证明

$$F'_{2k+1}(x)=0,F'_{2k}(x)=F_{2k}(x)/x, $$

（这只需注意到 $F_{2k+1}(x)$ 只包含偶次项，$F'_{2k}(x)$ 只包含奇次项即可）

因此若 $m$ 是奇数则 $\Delta'_m(x)=F_{m+1}(x)/x$，否则 $\Delta'_m(x)=F_m(x)/x$。无论哪种情况，都有多项式 $\Delta_m(x),\Delta'_m(x)$ 互素，从而 $\Delta_m(x)$ 无平方因子。

2）定义多项式列 $G_n(x)$：

$$G_0(x)=2,G_1(x)=x,G_n(x)=xG_{n-1}(x)-G_{n-2}(x)(n\ge 2), $$

容易证明 $G_n(x)$ 也有与引理 24 类似的[通项公式](https://zhida.zhihu.com/search?content_id=112741269&content_type=Article&match_order=1&q=%E9%80%9A%E9%A1%B9%E5%85%AC%E5%BC%8F&zhida_source=entity) $G_n(x)=\alpha^n+\alpha^{-n}$，从而得到等式

$$G_{n+2}-G_n=(x^2-4)F_{n+1}(x); \\ G_n^2(x)-(x^2-4)F_n^2(x)=4. $$

下面用归纳法证明多项式等式

$$(x^2-4)F'_n(x)=nG_n(x)-xF_n(x). $$

首先验证等式对 $0,1$ 都成立。归纳假设等式对 $n,n+1$ 均成立，对 $n+2$ 利用递推式

$$F'_{n+2}(x)=(xF_{n+1}(x)-F_n(x))'=F_{n+1}(x)+xF'_{n+1}(x)-F'_n(x) $$

可得

$$\begin{align} (x^2-4)F_{n+2}'&=(x^2-4)(F_{n+1}+xF'_{n+1}-F'_n) \\ &=(x^2-4)F_{n+1}+x(x^2-4)F'_{n+1}-(x^2-4)F'_n \\ &=(x^2-4)F_{n+1}+x((n+1)G_{n+1}-xF_{n+1})-(nG_n-xF_n) \\ &=(x^2-4)F_{n+1}+xG_{n+1}+n(xG_{n+1}-G_n)-x(xF_{n+1}-F_n) \\ &=G_{n+2}-G_n+xG_{n+1}+nG_{n+2}-xF_{n+2} \\ &=G_{n+2}+G_{n+2}+nG_{n+2}-xF_{n+2} \\ &=(n+2)G_{n+2}-xF_{n+2}. \end{align} $$

归纳证明完成。若有非常值多项式 $h(x)$ 同时整除 $F_n(x),F_n'(x)$，则由等式可知 $h(x)$ 整除 $nG_n(x)$，从而整除 $G_n(x)$（因为 $n$ 不被 $p$ 整除），再由 $G_n^2(x)-(x^2-4)F_n^2(x)=4$ 可知 $h(x)$ 整除 $4\ne 0$，矛盾。这说明 $F_n(x),F_n'(x)$ 互素，从而 $F_n(x)$ 无平方因子。

命题 29 说明命题 26 中定义的 $r_0$ 是确定的：当 $p=2$ 时 $r_0=2$，当 $p\ne 2$ 时 $r_0=1$，并且这一结论对非有限域也适用（因为命题 29 的证明不需要 $F$ 是有限域）。

## 构造基解的另一种简便方法

（这里直接给结论，不铺垫了）

设 $F$ 是域，$c\in F$ 是常数， $g(x)$ 是 $F$ 上的 $d$ 次不可约多项式，$r$ 是正整数，记

$$n=\mathrm{dep}(g(x)^r),m=\mathrm{dep}(g(x+c)^r), $$

并假设 $n,m\ne\infty$。现在我们来构造 $g(x)^r$ 对应的 $d$ 个基解。

A）定义[特征多项式](https://zhida.zhihu.com/search?content_id=112741269&content_type=Article&match_order=1&q=%E7%89%B9%E5%BE%81%E5%A4%9A%E9%A1%B9%E5%BC%8F&zhida_source=entity)

$$P(z)=z^{dr}g(z+z^{-1})^r=\sum_{i=0}^{2dr}C_iz^i, $$

（容易看出 $P(z)$ 的系数关于中间项对称，并且首项系数和[常数项](https://zhida.zhihu.com/search?content_id=112741269&content_type=Article&match_order=1&q=%E5%B8%B8%E6%95%B0%E9%A1%B9&zhida_source=entity)都等于 1）

定义两端无限延伸的数列 $(a_k)_{k\in\mathbb{Z}}$，其中 $a_1,\cdots,a_{dr}$ 是任意选取的域 $F$ 的元素，$a_0=0$，$a_{-1},\cdots,a_{-dr}$ 分别等于 $-a_1,\cdots,-a_{dr}$。数列的其他项由递推公式

$$\sum_{i=0}^{2dr}C_ia_{k+i}=0,k\in\mathbb{Z} $$

给出（注意 $k=0$ 时递推式恒成立，而 $k\ne 0$ 时刚好可以依次递推确定左端和右端所有项，因此数列 $(a_k)_{k\in\mathbb{Z}}$ 由 $a_1,\cdots,a_{dr}$ 的取值唯一确定）。由于递推公式的系数是对称的，容易证明 $a_{-k}=-a_k$ 对任意整数 $k$ 都成立。

为了方便处理这种形式的递推公式，引入数列 $(a_k)_{k\in\mathbb{Z}}$ 的形式 Laurent 级数：

$$\hat{a}(z)=\sum_{k=-\infty}^{+\infty}a_kz^{-k}, $$

并以自然方式定义形式级数的加减法，以及形式级数与普通多项式的乘法（约定总将普通多项式写在左边，形式级数写在右边），容易验证形式级数加法构成 Abel 群，乘法满足[结合律](https://zhida.zhihu.com/search?content_id=112741269&content_type=Article&match_order=1&q=%E7%BB%93%E5%90%88%E5%BE%8B&zhida_source=entity) $(pq)\hat{a}=p(q\hat{a})=q(p\hat{a})$、[分配律](https://zhida.zhihu.com/search?content_id=112741269&content_type=Article&match_order=1&q=%E5%88%86%E9%85%8D%E5%BE%8B&zhida_source=entity)等性质。之前的递推式可以简写为 $P(z)\hat{a}(z)=0$。

**引理30** 数列 $(a_k)_{k\in\mathbb{Z}}$ 具有周期 $2n$，并且 $a_{kn}=0,a_{kn-l}=-a_{kn+l}$ 对任意整数 $k,l$ 成立。

证明：显然我们需要用到 $n=\mathrm{dep}(g(x)^r)$（可以推出 $g(x)^r\mid F_n(x)$ ）的条件。

首先由条件 $g(x)^r\mid F_n(x)$，代入 $x=z+z^{-1}$ 可得

$$z^{dr}g(z+z^{-1})^r\mid z^{n-1}F_n(z+z^{-1}), $$

（实际上不是直接代入，而是设 $g(x)^rh(x)=F_n(x)$ 再代入，并在等式两端乘以 $z^{n-1}$，然后注意到 $z^{n-dr}h(z+z^{-1})$ 是多项式就可以了）

直接归纳法可证 $F_n(z+z^{-1})=(z^n-z^{-n})/(z-z^{-1})=(z^{2n}-1)/(z^{n-1}(z^2-1))$，从而有

$$P(z)\mid\frac{z^{2n}-1}{z^2-1}. $$

由 $P(z)\hat{a}(z)=0$ 立即可得 $(z^{2n}-1)\hat{a}(z)=0$，从而数列 $(a_k)_{k\in\mathbb{Z}}$ 具有周期 $2n$，再结合 $a_{-k}=-a_k$ 可得 $a_{kn-l}=-a_{-kn+l}=-a_{kn+l}$。

接下来只需要证 $a_n=0$。

1）当域 $F$ 的特征不等于 $2$ 时，由 $a_n=-a_{-n}=-a_n$ 立刻可以得到 $a_n=0$。

2）当域 $F$ 的特征等于 $2$ 时，在递推公式 $\sum_{i=0}^{2dr}C_ia_{k+i}=0$ 中取 $k=n-dr$，由系数的对称性可以消掉两侧所有项，得到 $C_{dr}a_n=0$。注意 $C_{dr}$ 就是 $g(z+z^{-1})^r$ 的常数项，而在特征为 $2$ 的域上 $g(z+z^{-1})^r$ 的常数项等于 $g(z+z^{-1})$ 的常数项等于多项式 $g$ 的常数项，当多项式 $g$ 的常数项不为零时必有 $a_n=0$。

已知多项式 $g$ 不可约，大多数情况下常数项都不为零，除非 $g(x)=x$，此时 $n=\mathrm{dep}(x^r)$ 是偶数，而数列 $(a_k)_{k\in\mathbb{Z}}$ 满足 $(z^2+1)\hat{a}(z)=0$，直接验算可知数列 $(a_k)_{k\in\mathbb{Z}}$ 的偶数项都为零，证明完成。

容易看出，数列 $(a_k)_{k\in\mathbb{Z}}$ 正是由 $a_1,\cdots,a_{n-1}$ 通过**镜像反色操作**铺满数轴上所有整点得到的[无穷数列](https://zhida.zhihu.com/search?content_id=112741269&content_type=Article&match_order=1&q=%E6%97%A0%E7%A9%B7%E6%95%B0%E5%88%97&zhida_source=entity)。我们准备用 $a_1,\cdots,a_{n-1}$ 作为方格填数问题基解的第一列。

B）定义形式级数列

$$\hat{a}^{(0)}(z)=0,\hat{a}^{(1)}(z)=\hat{a}(z),\hat{a}^{(l+2)}(z)=-(z+z^{-1}-c)\hat{a}^{(l+1)}(z)-\hat{a}^{(l)}(z)(l\ge 2). $$

同时规定 $\hat{a}^{(-l)}(z)=-\hat{a}^{(l)}(z)$，这样对任意整数 $l$ 都定义了一个形式级数 $\hat{a}^{(l)}$，并且公式 $\hat{a}^{(l+2)}(z)=-(z+z^{-1}-c)\hat{a}^{(l+1)}(z)-\hat{a}^{(l)}(z)$ 对任意整数 $l$ 成立。每个形式级数 $\hat{a}^{(l)}$ 都对应一个无穷数列 $(a_{k,l})_{k\in\mathbb{Z}}$，从而得到一个铺满平面坐标系所有整点的数阵 $(a_{k,l})_{k,l\in\mathbb{Z}}$，并且**每个格子都满足方格填数性质**（即周围十字区域 5 格之和等于自身的 c 倍）。

容易证明每个形式级数 $\hat{a}^{(l)}$ 对应的数列都满足引理 30 的性质，于是 $a_{0,0},\cdots,a_{0,n}$ 以及 $a_{k,0},a_{k,n}(k\ge 1)$ 都等于零。可以想象一下，这些“零”组成一个开口向右的狭长筒形，现在我们要把这个筒封口了。

**引理31** $\hat{a}^{(m)}(z)=0.$

证明：有没有注意到形式级数 $\hat{a}^{(l)}$ 的递推式与 Chebyshev 多项式的递推式很像？用归纳法可以证明

$$\hat{a}^{(l)}(z)=F_l(-z-z^{-1}+c)\hat{a}(z). $$

特别地，$\hat{a}^{(m)}(z)=F_m(-z-z^{-1}+c)\hat{a}(z)$。另外由已知条件可知 $g(x+c)^r\mid F_m(x)$，代入 $x=z+z^{-1}-c$ 可得

$$z^{dr}g(z+z^{-1})^r\mid z^{m-1}F_m(z+z^{-1}-c), $$

也就是

$$P(z)\mid z^{m-1}F_m(-z-z^{-1}+c). $$

（多项式 $F_m$ 要么只含奇次项要么只含偶次项，给变元加负号不影响整除性质）

由 $P(z)\hat{a}(z)=0$ 可得 $z^{m-1}\hat{a}^{(m)}(z)=z^{m-1}F_m(-z-z^{-1}+c)\hat{a}(z)=0$，从而待证引理成立。

至此我们知道数阵 $(a_{k,l})_{k,l\in\mathbb{Z}}$ 的 $1\le k\le n-1,1\le l\le m-1$ 矩形区域外围被一圈零围绕，同时数阵 $(a_{k,l})_{k,l\in\mathbb{Z}}$ 的每个格子都满足方格填数性质，这说明**该矩形区域就是矩形填数问题的一个解**。至此构造基解的准备工作已经完成。

**定义32** 设 $F$ 是域，$c\in F$ 是常数， $g(x)$ 是 $F$ 上的 $d$ 次不可约首一多项式，$r$ 是正整数，记

$$n=\mathrm{dep}(g(x)^r),m=\mathrm{dep}(g(x+c)^r), $$

并假设 $n,m\ne\infty$。对每个整数 $0\le e\le d-1$，取 $a_{d(r-1)+e+1}=1$，同时 $a_1,\cdots,a_{dr}$ 中其他元素置为 $0$，通过上述步骤定义矩阵 $(a_{k,l})_{1\le k\le n-1,1\le l\le m-1}$，记为

$$\tilde S(F,c,g(x),r,e), $$

称为**第二类单体标准基**。（该记号与定义 23 类似，参数位置略有不同，并且去掉了尺寸参数 $n,m$，因为它们由其余参数唯一确定）

另外，无穷矩阵 $(a_{k,l})_{k,l\in\mathbb{Z}}$ 是 $(a_{k,l})_{1\le k\le n-1,1\le l\le m-1}$ 的“无穷镜像反色”版本，称为**第二类无穷标准基**，记为 $\tilde S_\infty(F,c,g(x),r,e)$。

将定义 32 与定义 23 对比可以发现，二者定义的单体标准基尺寸、数量完全相等。一般地，对任意 $N\times M$ 矩阵的方格填数问题，我们只要找到对应域 $F$ 和常数 $c$ 上所有尺寸合适的单体标准基（“尺寸合适”指能通过镜像反色操作扩充成 $N\times M$ 尺寸），通过镜像反色操作扩充成 $N\times M$ 尺寸，组成一组基就行了。如果使用第二类单体标准基，对任意 $N\times M$ 矩阵的方格填数问题当然也能按照同样的方法找一组第二类单体标准基，再扩充成 $N\times M$ 尺寸组成一组基，至少[基向量](https://zhida.zhihu.com/search?content_id=112741269&content_type=Article&match_order=1&q=%E5%9F%BA%E5%90%91%E9%87%8F&zhida_source=entity)的数量是够的（因为两类单体标准基尺寸、数量完全相等），但是我们没有证明这一组基线性无关！换句话说我们需要证明：

> 任意一组第二类单体标准基扩充成相同尺寸后线性无关。

这句话改用无穷标准基叙述更简单，因为不需要扩充成相同尺寸了：

**引理33** 任意一组第二类无穷标准基线性无关。

证明：任取一组第二类无穷标准基的[线性组合](https://zhida.zhihu.com/search?content_id=112741269&content_type=Article&match_order=1&q=%E7%BA%BF%E6%80%A7%E7%BB%84%E5%90%88&zhida_source=entity)并假设其为 0，即

$$\sum_{i=1}^k\sum_{j=1}^{t_k}c_{ij}\tilde{S}_\infty(F,c,g_i(x),r_{ij},e_{ij})=0. $$

（注意这里把 $g(x)$ 相同的项划分到一类了，因此假设各个 $g_i(x)$ 是互不相同的不可约首一多项式；对同一个 $i$，各个数对 $(r_i,e_i)$ 也互不相同）

证明过程中不需要考虑无穷标准基的所有数，只要考虑第一列。把 $\tilde{S}_\infty(F,c,g_i(x),r_{ij},e_{ij})$ 的第一列对应的形式级数记为 $\hat{b}_{(ij)}(z)$，则等式变成

$$\sum_{i=1}^k\sum_{j=1}^{t_k}c_{ij}\hat{b}_{(ij)}(z)=0. $$

由之前的讨论可知

$$z^{d_ir_{ij}}g_i(z+z^{-1})^{r_{ij}}\hat{b}_{(ij)}(z)=0, $$

其中 $d_i=\deg g_i(x)$。

第一步先证明 $g(x)$ 相同的各个类线性组合均为 0，首先我们记 $\tilde{s}_{(i)}(z)=\sum_{j=1}^{t_k}c_{ij}\hat{b}_{(ij)}(z)$，同时取 $P_i(z)=z^{d_iR_i}g(z+z^{-1})^{R_i}$，其中 $R_i$ 表示 $r_{i,1},\cdots,r_{i,t_i}$ 中的最大值，则有

$$P_i(z)\hat{s}_{(i)}(z)=0,1\le i\le k. $$

首先注意到各个 $P_i(z)$ 两两互素，若不然，不妨设 $P_1(z),P_2(z)$ 不互素，则它们（在某个扩域中）有公共根 $z_0$，又由 $P_1(z),P_2(z)$ 常数项不为零可知 $z_0\ne 0$，于是 $z_0+z_0^{-1}$ 是多项式 $g_1(x)^{R_1},g_2(x)^{R_2}$ 的公共根，这与 $g_1(x),g_2(x)$ 互素矛盾。记 $Q_i(z)=\prod_{j\ne i}P_j(z)$，则有 $\gcd(P_i,Q_i)=1$，从而存在多项式 $p_i,q_i$ 使得 $p_iP_i+q_iQ_i=1$。

由假设条件 $\sum_{i=1}^k\tilde{s}_{(i)}(z)=0$ 两边同时乘以 $Q_i(z)$，下标不为 $i$ 的项都变成零，这样就得到 $Q_i(z)\tilde{s}_{(i)}(z)=0$，从而 $\tilde{s}_{(i)}(z)=(p_i(z)P_i(z)+q_i(z)Q_i(z))\tilde{s}_{(i)}(z)=0$。这样就证明了各个 $\hat{s}_{(i)}(z)$ 都等于 0。

第二步证明各个 $c_{ij}$ 都等于 0。为此只需要证明同一个 $i$ 对应的 $\hat{b}_{(ij)}(z)$ 线性无关。这只需注意到 $\hat{b}_{(ij)}(z)$ 的**最低正整数次非零项的次数**等于 $d_i(r_{ij}-1)+e_{ij}+1$（直接检查第二类标准基的定义即可），而 $e_{ij}$ 的取值为小于 $d_i$ 的正整数。不同的 $j$ 对应不同的 $(r_{ij},e_{ij})$，它们对应的 $d_i(r_{ij}-1)+e_{ij}+1$ 也互不相同，于是形式级数 $\hat{b}_{(ij)}(z)$ 的最低正整数次非零项的次数各不相同。这足以说明同一个 $i$ 对应的 $\hat{b}_{(ij)}(z)$ 线性无关。

至此就证明了：我们定义的第二类单体标准基与原先定义的单体标准基一样，也可以用来生成任意尺寸矩形方格的一组基解。可以看到第二类单体标准基计算的计算比较简单：算出多项式的深度之后，只需设定第一列的 $dr$ 个初始值，往后线性递推就可以了。

## It's show time!

有限域的解都可以用颜色对应的方法可视化，我编程绘制了 2, 3, 4, 5, 7, 8, 9 元域对应的所有宽度高度均不超过 1000 的单体标准基，每张图片对应一个单体标准基（每个有限域对应的所有图片压缩后大概几百个 MB）。具体算法就如同上一小节说的那样：

1.  枚举不可约多项式 $g$（事先用筛法得到不可约多项式的列表），对每个 $g$ 从小到大枚举正整数 $r$。
2.  计算 $n=\mathrm{dep}(g(x)^r),m=\mathrm{dep}(g(x+c)^r)$，如果二者有一个大于 1001 说明尺寸超过上限，直接结束关于多项式 $g$ 的计算，枚举下一个多项式。具体方法是递推计算 $F_k(x)$ 模 $g(x)^r,g(x+c)^r$ 的余式，直到余式为 0 终止，如果算到 1001 还不归零说明尺寸超过上限了。
3.  计算多项式 $$P(z)=z^{dr}g(z+z^{-1})^r=\sum_{i=0}^{2dr}C_iz^i $$  
    以推出第一列的递推公式。
4.  令 $e$ 循环取遍 $[0,d)$ 中所有整数。对每个 $e$，建一个下标范围为 $-dr,\cdots,n-1$ 的[一维数组](https://zhida.zhihu.com/search?content_id=112741269&content_type=Article&match_order=1&q=%E4%B8%80%E7%BB%B4%E6%95%B0%E7%BB%84&zhida_source=entity) $a$，将 $a[-dr],\cdots,a[dr]$ 置为零，再将 $a[d(r-1)+e+1],a[-d(r-1)-e-1]$ 分别置为 $1,-1$，最后使用递推公式  
    $$\sum_{i=0}^{2dr}C_ia[k+i]=0,-dr+1\le k\le n-1-2dr $$  
    计算数组 $a$ 的其余各项。（注意这里的运算都是有限域的运算，与普通的算术运算不同）
5.  建一个大小为 $(n-1)\times(m-1)$ 的[二维数组](https://zhida.zhihu.com/search?content_id=112741269&content_type=Article&match_order=1&q=%E4%BA%8C%E7%BB%B4%E6%95%B0%E7%BB%84&zhida_source=entity) $b$，令 $b[k][1]=a[k](1\le k\le n-1)$，使用递推公式  
    $$c\cdot b[i][j]=b[i-1][j]+b[i+1][j]+b[i][j-1]+b[i][j+1],1\le i\le n-1,1\le j\le m-2 $$  
    计算数组 $b$ 的其余各项（递推式中遇到下标越界的项一律视为零），数组 $b$ 即为单体标准基 $\tilde S(F,c,g(x),r,e)$，转换成图片输出即可。

以上算法最麻烦的是枚举不可约多项式，因为**事先不知道多项式的次数上界**，只能试探着枚举到某个次数的不可约多项式，如果一直都找不到不超过 1000 的单体标准基，就认为以后都找不到了。例如对于二元域的情况（$c=-1$），宽高都不超过 1000 的单体标准基对应多项式的最高次数是 14，要想枚举所有更高次数的不可约多项式，从时间效率看是不现实的。对素数阶域 $\mathbb{F}_p$，宽高都不超过 1000 的单体标准基对应多项式的最高次数如下所示：

$$\begin{array}[b] {}  \hline p &2 & 3 & 5 & 7 \\  \hline d_{max} & 14 & 10 & 7 & 6 \\ \hline \end{array}$$

具体确认方法很简单：用 Mathematica 暴力计算所有 $\gcd(F_n,F_m)$ 并分解因式，看有没有次数超过上表的不可约因式，结果是没有。对非素数阶域，似乎 Mathematica 没有分解因式的包，于是我就没有验证，有可能漏解，不过反正漏一两个解无所谓。

**素数阶域**

本节总假设 $c=-1$，这是为了对应原始的点灯问题（按下开关后，十字位置的 5 个灯同步改变）。

先看最简单的情况：$p=2$，此时最简单的多项式自然是 $x$ 和 $x+1$。因为 $g(x)$ 取这两个多项式得到的单体恰好关于[主对角线](https://zhida.zhihu.com/search?content_id=112741269&content_type=Article&match_order=1&q=%E4%B8%BB%E5%AF%B9%E8%A7%92%E7%BA%BF&zhida_source=entity)对称，只需要考虑其中一种情况 $g(x)=x$。根据命题 26 可以得知

$$\mathrm{dep}(x^r)=2^{\lfloor\log_2r\rfloor+1},\mathrm{dep}((x+1)^r)=3\cdot 2^{\lceil\log_2r\rceil-1}, $$

（$r=1$ 时后一式修正为 $\mathrm{dep}(x+1)=3$）

由此可以知道：$r$ 取相邻两个 $2$ 的幂之间的一串正整数，得到的单体尺寸相同；$r$ 取 $2$ 的幂时得到的单体尺寸与其他 $r$ 值对应的单体尺寸都不同。

![域 GF(2) 上（c=-1）多项式 x^1, ..., x^5 对应的单体](https://pic2.zhimg.com/v2-c6b2ff8de3cf5e9560b2527c8d4874b7_r.jpg)![域 GF(2) 上（c=-1）多项式 x^33, ..., x^63 对应的单体](https://pic4.zhimg.com/v2-181db801ea4588678a9ea79d366ac34d_b.jpg)![域 GF(2) 上（c=-1）多项式 x^8, x^16, x^32, x^64 对应的单体](https://pic4.zhimg.com/v2-1f2444c28ac34c0a4b8cf7fd085448cb_r.jpg)

可见当 $r$ 值比较大时，单体的结构看起来有些“相似性”（但是这种相似性不容易描述）。$r$ 取 $2$ 的幂时对应的单体似乎有**分形**的味道。

接下来看二次多项式 $g(x)=x^2+x+1$，这也是 $\mathbb{F}_2$ 上唯一一个不可约二次多项式。

![域 GF(2) 上（c=-1）多项式 (x^2+x+1)^1, (x^2+x+1)^2 对应的单体](https://pic3.zhimg.com/v2-e74f65fd7db61ac4ae85c9a38c35677a_r.jpg)

（单体默认优先按 $r$ 升序，其次按 $e$ 升序排序；换句话说按第一列第一个非零元素的位置从上到下排序）

以上就是 4×4 方格的所有 4 个基解，这也是 4×4 点灯游戏“只要有解，则不按第一行的开关就能过关”的原因。

当 $r$ 值比较大时，$g(x)^r=(x^2+x+1)^r$ 对应单体的结构变得愈发复杂，出现了一些非常诡异的结构：

![域 GF(2) 上（c=-1）多项式 (x^2+x+1)^33 对应的单体，e=0](https://pic3.zhimg.com/v2-03180771f1a0e966a0fd592d190c45bc_r.jpg)![域 GF(2) 上（c=-1）多项式 (x^2+x+1)^33 对应的单体，e=1](https://picx.zhimg.com/v2-b16c65b8c20dff73b316aefa6ebf6af1_r.jpg)

角落和中间出现了一些周期重复的图样，但总体的布局却显得杂乱无章。不过也不是所有的单体都是这种样子：

![域 GF(2) 上（c=-1）多项式 (x^2+x+1)^64 对应的单体，e=1](https://picx.zhimg.com/v2-a135569d21b7b5bbbdc5d62f1075ac2f_r.jpg)

这就是把多项式 $x^{64}$ 对应的单体复制两份拼接起来得到的图形。

随着不可约多项式 $g(x)$ 次数提高，单体的模式越来越复杂精巧：

![域 GF(2) 上（c=-1）多项式 (x^3+x+1)^1,(x^3+x+1)^2 对应的单体，大小 8×6](https://pic4.zhimg.com/v2-443bd5b60ed7766ba0da5ebb69b6377d_r.jpg)![域 GF(2) 上（c=-1）多项式 (x^4+x+1)^1,(x^4+x+1)^2 对应的单体，大小 16×16](https://pic1.zhimg.com/v2-0596e3250ec6408d8da8b9571eaf0d92_r.jpg)![域 GF(2) 上（c=-1）多项式 (x^5+x^2+1)^1,(x^5+x^2+1)^2 对应的单体，大小 30×10](https://picx.zhimg.com/v2-8652afa81149f8280645c6e031a00005_r.jpg)![域 GF(2) 上（c=-1）多项式 (x^6+x+1)^1,(x^6+x+1)^2 对应的单体，大小 64×64](https://pica.zhimg.com/v2-1b87233669e2c7302da75e8af7b3182e_r.jpg)

前面提到过：宽高均不超过 1000 的单体对应 $g(x)$ 的次数最高能取到 14 次。事实上只有两个 14 次多项式对应宽高均不超过 1000 的单体：

$g_1(x)=x^{14}+x^{13}+x^9+x^5+x^4+x^2+1, \\ g_2(x)=g_1(x+1).$

下图是 $g_1(x)$ 对应的第一个单体：

![域 GF(2) 上（c=-1）多项式 x^14+x^13+x^9+x^5+x^4+x^2+1 对应的单体，e=1，大小 380×564](https://pic2.zhimg.com/v2-ccd94798bf2ef4512142ddf2f0019b7f_r.jpg)

只用简单的递推公式 $g_1(z+z^{-1})$ 就可以生成如此精巧的图案！

对其他有限域，单体图片的“整体感觉”大同小异，花纹样式则千变万化。

> 素数阶域颜色对照表：  
> $\mathbb{F}_3$——白色 0，灰色 1，黑色 2；  
> $\mathbb{F}_5$——白色 0，浅红 1，深红 2，深蓝 3，浅蓝 4；  
> $\mathbb{F}_7$——白色 0，浅红 1，中红 2，深红 3，深蓝 4，中蓝 5，浅蓝 6。

![域 GF(3) 上（c=-1）多项式 (x+2)^121 对应的单体，大小 242×242](https://pic2.zhimg.com/v2-33f39c14701ec794a3b575f62cdfc925_r.jpg)

（是不是很像 Sierpinski 地毯？）

![域 GF(3) 上（c=-1）多项式 x^3+2x+1 对应的单体，大小 12×12](https://picx.zhimg.com/v2-54107bdca8d81b6c5fbf3c70b62ea6f5_r.jpg)![域 GF(3) 上（c=-1）多项式 x^10+2x^8+2x^6+x^4+1 对应的单体，e=1，大小 241×670](https://pic2.zhimg.com/v2-59ea97e7d877015d9b23ddb8555c14b3_r.jpg)![域 GF(5) 上（c=-1）多项式 (x+3)^300 对应的单体，大小 624×624](https://pic1.zhimg.com/v2-6b4f774847c3c9ae4e1ad8df6e1905ca_r.jpg)![域 GF(5) 上（c=-1）多项式 x^3+x+4 对应的单体，大小 30×30](https://pic1.zhimg.com/v2-b8461e8e8b90d9dc87faca7a3a24009e_r.jpg)![域 GF(7) 上（c=-1）多项式 x^49 对应的单体，大小 97×146](https://pic1.zhimg.com/v2-2ae4247cc464af48bd69e510648846c0_r.jpg)

对非素数阶域，c 一般取某个生成元（换句话说，域 $\mathbb{F}_{p^e}$ 上 $c$ 应该取某个系数属于 $\mathbb{F}_p$ 的不可约 $e$ 次多项式的根）。

> 非素数阶域颜色对照表：  
> $\mathbb{F}_4$——c^2+c+1=0，白色 0，黑色 1，浅红 c，深红 c+1；  
> $\mathbb{F}_8$——c^3+c+1=0，白色 0，黑色 1，浅红 c，深红 c+1，浅蓝 c^2，深蓝 c^2+1，浅紫 c^2+c，深紫 c^2+c+1；  
> $\mathbb{F}_9$——c^2+1=0，白色 0，灰色 1，黑色 2，浅红 c，中红 c+1，深红 c+2，浅蓝 c^2，中蓝 c^2+1，深蓝 c^2+2。

![域 GF(4) 上（c^2+c+1=0）多项式 x^128 对应的单体，大小 255×319](https://pic4.zhimg.com/v2-1c4826bd7fcfa04bdea795a75dfdcf7d_r.jpg)![域 GF(4) 上（c^2+c+1=0）多项式 (x^2+x+c)^1, (x^2+x+c)^2 对应的单体，大小 16×16](https://pic3.zhimg.com/v2-d28a97b6b8272ead3d02f01dddf10580_r.jpg)![域 GF(8) 上（c^3+c+1=0）多项式 x^64 对应的单体，大小 127×287](https://pic2.zhimg.com/v2-112167035e08b8a75e1bbe230f0251d1_r.jpg)![域 GF(9) 上（c^2+1=0）多项式 x^3+x+c 对应的单体，大小 27×27](https://picx.zhimg.com/v2-da2447cbbedcc83cba5c8849e7611c15_r.jpg)

## 后记

本文有关 Chebyshev 多项式性质的部分参考了下面两篇论文：

**[\[HMP\]](https://link.zhihu.com/?target=https%3A//bearspace.baylor.edu/Markus_Hunziker/www/HunzikerMachiaveloPark2004.pdf)** *Chebyshev polynomials over finite fields and reversability of σ-automata on square grids*, by Markus Hunziker, António Machiavelo, and Jihun Park.

**[\[Su\]](https://link.zhihu.com/?target=http%3A//citeseerx.ist.psu.edu/viewdoc/summary%3Fdoi%3D10.1.1.27.1593)** *σ-Automata and Chebyshev-Polynomials*, by Klaus Sutner (1996). Theoretical Computer Science, vol. 230, (2000), no. 1-2, pp. 49-73.

这个系列的文章到此告一段落，以上两篇论文还有关于 Chebyshev 多项式的更多性质（这里因为篇幅所限不可能详细介绍），感兴趣的可以看一下。