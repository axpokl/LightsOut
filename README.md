# 点灯游戏（Lights Out）求解器 · 算法说明

> Language: [English](#english-version)

---

## 中文版本

### 目录

- 问题、关键观察与记号
- 算法总览
- 1) 穷举法 · `O(2^(n²)·n²)`
- 2) 首行穷举 · `O(2^n·n²)`
- 3) 叠加法 · `O(n⁶)`
- 4) 首行叠加法 · `O(n³)`
- 5) 首行求逆法 · `O(n²)`
- 6) Karatsuba法 · `O(n^1.585)`
- 7) Toom-Cook法 · `O(n^1.465)`
- 8) FFT法 · `O(n log²n log log n)`
- 9) NTT法 · `O(n log²n)`
- 10) 张量法 · `O(n(log n)^(3/2))`
- 复杂度与实现范围
- 可解性
- 工程实现与验证建议
- 参考文献

---

### 问题与规则

- 棋盘：`n × n`。
- 操作：点击某格按钮，会翻转（亮↔暗）：
  - 自身
  - 上下左右四邻居（边界处只翻转存在的邻居）
- 目标（两种等价说法）：
  - 从**全暗**出发，使灯**全亮**
  - 或从**全亮**出发，使灯**全暗**
- 二值化与运算：
  - 按/不按：`1/0`
  - 亮/暗：`1/0`
  - 所有运算都在 **GF(2)**（即 XOR / 异或）上

---

### 关键观察

1. **同一按钮按两次等同于没按**  
   因为翻转两次回到原状态：`a ⊕ 1 ⊕ 1 = a`。
2. **按按钮的顺序无关**  
   因为 XOR 可交换且可结合：`(a ⊕ b) ⊕ c = a ⊕ (b ⊕ c)`。
3. 因而每个按钮只需考虑二元状态（按/不按），一组按钮状态唯一决定一组灯状态。

---

### 术语与记号（GF(2) 建模）

- 将棋盘拉直编号（仅用于矩阵表达）：
  - 按钮向量：`x ∈ {0,1}^{n^2}`
  - 灯向量：`l ∈ {0,1}^{n^2}`
- 存在 `n^2 × n^2` 的 0/1 矩阵 `A`，其第 `j` 列表示“只按第 `j` 个按钮”时会翻转哪些灯。
- 叠加性在 GF(2) 上对应线性系统：
  - `l = A · x (mod 2)`
- 目标全亮可写为：
  - `A · x = 1 (mod 2)`（`1` 为全 1 向量）
- 满足 `A·x=0` 的按钮图案称为**静默操作**，它不会改变任何灯。

---

### 算法总览

`n` 始终表示棋盘边长。前五种方法介绍基本求解路线，后五种方法通过加速多项式运算，进一步优化首行求逆法。

| 方法 | 核心思路 | 时间复杂度 |
|---|---|---|
| 穷举法 | 枚举整盘按钮组合 | `O(2^(n²)·n²)` |
| 首行穷举 | 枚举首行，逐行确定后续按钮 | `O(2^n·n²)` |
| 叠加法 | 求解完整的 `n²×n²` 线性系统 | `O(n⁶)` |
| 首行叠加法 | 将问题缩减为 `n×n` 首行系统 | `O(n³)` |
| 首行求逆法 | 多项式求逆与结构化回代 | `O(n²)` |
| Karatsuba法 | 四次半长乘法减少为三次 | `O(n^1.585)` |
| Toom-Cook法 | 三段拆分，只做五次乘法 | `O(n^1.465)` |
| FFT法 | 利用快速卷积，并计入扩域或递归开销 | `O(n log²n log log n)` |
| NTT法 | 通过模整数变换精确计算卷积 | `O(n log²n)` |
| 张量法 | 共享变换，预测乘子并精确修复例外 | `O(n(log n)^(3/2))` |

- 低于 `O(n²)` 的复杂度针对首行计算或多项式求解阶段；显式输出整盘仍需 `Θ(n²)` 时间。
- 后五种复杂度取决于乘法模型，以及其余阶段是否完成相应加速。FFT/NTT 需要满足后文的变换条件；张量法一项省略了一个小指数项，严格表达见第十章。
- `1.585` 和 `1.465` 为指数的近似值，精确表达见对应章节。这些方法求一组合法解，不保证点击次数最少。

---

## 1) 穷举法 · `O(2^(n²)·n²)`

- 枚举所有按钮向量 `x`（长度 `n^2`），计算 `l = A·x`，检查是否全亮。
- 示例：
  - `n=2`：`2^4=16`
  - `n=3`：`2^9=512`
  - `n=5`：`2^25=33,554,432`
  - `n=6`：`2^36=68,719,476,736`
- 若每次都重新计算整盘灯状态，实际会带上额外的 `O(n^2)` 检查成本。

---

## 2) 首行穷举 · `O(2^n·n²)`

- 关键现象：
  - 随机选择第 1 行按钮后，第 1 行灯状态确定；
  - 若第 1 行某灯为暗，为避免破坏已处理结果，只能按第 2 行对应列按钮去修正；
  - 从第 2 行开始，每行按钮状态都被上一行灯状态**唯一决定**；
  - 最后检查末行是否全亮，若是即得到一种解。
- 复杂度：
  - 首行有 `2^n` 种；
  - 每种首行递推整盘 `O(n^2)`；
  - 总体 `O(2^n·n^2)`。

---

## 3) 叠加法 · `O(n⁶)`

- 将所有按钮操作写成增广矩阵 `[E | A]`：
  - 左边 `E` 记录按钮组合；
  - 右边 `A` 记录灯翻转效果。
- 在 GF(2) 上做高斯消元：
  - 行交换；
  - 行异或。
- 若 `A` 可逆，则可把右侧化为单位矩阵，左侧同步变为 `A^{-1}`。
- 若 `A` 不可逆，则会出现非零按钮向量 `x` 满足 `A·x=0`，也就是静默操作。
- 复杂度为何是 `O(n^6)`：
  - 矩阵维度是 `n^2`；
  - 消元为立方复杂度；
  - `(n^2)^3 = n^6`。

---

## 4) 首行叠加法 · `O(n³)`

> 将“首行穷举的逐行递推”与“线性叠加”结合：把最后一行灯写成“首行按钮的线性组合 + 翻转向量”，于是只需求解 `n×n` 系统。

1. 令首行按钮向量为 `X`（长度 `n`）。
2. 递推出末行灯：
   - `L_last = M·X ⊕ Y_last`
   - `M` 是 `n×n` 矩阵，表示“首行按钮 → 末行灯”的线性映射；
   - `Y_last` 是与初始目标有关的翻转向量。
3. 对目标向量 `T`，只需解：
   - `M·X = T ⊕ Y_last`
4. 在 GF(2) 上对 `n×n` 系统消元得到 `X`，再用逐行压灯递推生成整盘按钮。

### 首行叠加法的关键递推（B/L/Y）

#### 记号

- `B(n,x)`：第 `n` 行、第 `x` 列按钮（0/1）
- `L(n,x)`：第 `n` 行、第 `x` 列灯（0/1）
- `⊕`：叠加（XOR）
- `~`：翻转（NOT），在 GF(2) 中 `~a = a ⊕ 1`

#### 基本关系

1. 灯可由“上、左、中、右按钮”叠加表示（将“下按钮”留到下一步）：
   - `L(n,x)=B(n-1,x)⊕B(n,x-1)⊕B(n,x)⊕B(n,x+1)`
2. 为修正当前灯，下一行按钮取为当前灯翻转：
   - `B(n+1,x)=~L(n,x)`
3. 使用 `~t=t⊕1`，可以把每步必然出现的翻转单独抽成翻转向量 `Y`。

#### 二阶递推

- 按钮递推：
  - `B(n,x)=1⊕B(n-1,x-1)⊕B(n-1,x)⊕B(n-1,x+1)⊕B(n-2,x)`
- 翻转向量递推（必须保留 `~`）：
  - `Y(n,y)=~(Y(n-1,y-1)⊕Y(n-1,y)⊕Y(n-1,y+1)⊕Y(n-2,y))`

### 优化生成矩阵（十字偶校验约束）

#### 十字偶校验约束

对由 `H` 的多项式生成的映射矩阵 `B=P(H)`，由 `HB=BH` 得：

- `B(x-1,y)⊕B(x+1,y)⊕B(x,y-1)⊕B(x,y+1)=0`

#### 直接收益

- 只要知道矩阵的**第一行**，就能递推出其余各行：
  - `B(x,y)=B(x-1,y-1)⊕B(x-1,y+1)⊕B(x-2,y)`
- 因此生成 `M` 时不必为每个列/每个灯生成完整矩阵：
  - 先求关键的第一行；
  - 再用递推补全。
- 后续 `O(n^2)` 算法也沿用了同一思想：尽量只操作第一行或少量滚动向量，不保存整张矩阵。

---

## 5) 首行求逆法 · `O(n²)`

> 目标：求解首行系统 `B X = Y`（GF(2)）。这里的 `B` 是首行叠加法得到的 `n×n` 矩阵，`Y` 是翻转向量的最后一行。

---

### H：左右扩散矩阵

- 定义：
  - `H(y,x)=1` 当且仅当 `|x-y|=1`
- 作用：
  - 向量乘 `H` 等价于左右扩散叠加；
  - `v*H` 的第 `x` 位为 `v(x-1)⊕v(x+1)`。

---

### K/F：扩散基矩阵与解耦矩阵

- 令 `e₁` 为第一个单位向量，定义扩散基矩阵：
  - `K=[e₁,He₁,...,H^(n-1)e₁]`
  - 每一列由前一列左右扩散得到。
- `K` 为对角线全 1 的上三角矩阵，因而可逆；记 `F=K⁻¹`。
- `b=Kp`、`p=Fb` 将普通向量坐标与多项式坐标互相转换。
- 实现时不必保存完整 `K/F`；它们主要用于说明矩阵问题与多项式问题的对应关系。

### f/c/g/q：核心多项式

- 定义 Fibonacci 型多项式：
  - `f₀(x)=1`
  - `f₁(x)=x`
  - `fₙ(x)=x·fₙ₋₁(x)⊕fₙ₋₂(x)`
- 定义：
  - `cₙ(x)=fₙ(x+1)`
- 在较早的推导中，也可写出 `p(x)=f(x)⊕c(x)`。
- 由于 `f(H)=0`，所以：
  - `p(H)=c(H)`
- 因此实际求解时可以省去 `p`，直接使用：
  - `g(x)=gcd(f(x),c(x))`
- 扩展欧几里得给出：
  - `s(x)f(x)⊕q(x)c(x)=g(x)`
- 其中：
  - `g(x)` 决定秩缺陷和解的数量；
  - `q(x)` 用于构造部分解。

---

### 可逆情况：`g=1`

- 若 `g(x)=1`，则存在 `q(x)` 使得：
  - `q(x)c(x)=1 mod f(x)`
- 因为 `c(H)=B`，于是：
  - `X=q(H)Y`
- 计算 `q(H)Y`：
  - 从 `Y` 开始；
  - 反复做左右扩散 `cur <- H cur`；
  - 若 `q` 当前系数为 1，则把 `cur` 异或进答案。
- 共 `n` 次扩散，每次 `O(n)`，因此为 `O(n^2)`。

---

### 不可逆情况：`g≠1`

- 扩展欧几里得得到的是：
  - `q(x)c(x)=g(x) mod f(x)`
- 先计算：
  - `z=q(H)Y`
- 因为原方程是：
  - `c(H)X=Y`
- 所以有：
  - `z=q(H)c(H)X=g(H)X`
- 于是问题变成：
  - `z=D X`
  - `D=g(H)`

---

### 构造 D 并反向消元

- 令：
  - `r'=deg(g)`
  - `r=n-r'`
- `D=g(H)` 具有结构化回代性质：
  1. 后 `r` 行呈带状上三角结构，左侧一段为 0。
  2. 后 `r` 行在 `i=j-r'` 处存在主元 1。
  3. 后 `r` 行线性无关。
  4. 前 `r'` 行都可由后 `r` 行线性叠加得到。
- 反向消元求特解：
  - 只用后 `r` 行消元；
  - 从左到右依次消去 `z[i]`；
  - 若 `z[i]=1`，唯一需要叠加的行是 `j=i+r'`；
  - 叠加后 `z[i]` 被消去，同时在 `X[j]` 记 1。
- 得到全部解：
  - 前 `r'` 行可由后 `r` 行叠加；
  - 先任选前 `r'` 个自由变量，将对应行异或到 `z`，再解其余变量；
  - 共有 `2^{r'}` 种组合，因此产生 `2^{r'}` 个解。
- 对称性：
  - `D[j,i]=D[i,j]`
  - 因此也可从右往左做等价消元。

### 解的数量

- 静默操作：满足 `A·x=0` 的按钮图案（翻转 0 盏灯）。
- 静默空间维度为 `r'` 时：
  - 解的数量 `=2^{r'}`
- 示例：
  - `3×3`：无静默 ⇒ 唯一解
  - `5×5`：`r'=2` ⇒ `4` 种解
  - `4×4`：首行空间全静默 ⇒ `2^4=16` 种解
- 上界：
  - `n×n` 解最多为 `2^n`
  - 对应 OEIS：A075462

### 秩亏、静默操作与商环求解

#### 秩亏的等价表示

- 记 `d_r=deg(g)`、`r=n-d_r`；`d_r` 表示秩亏，避免与 `D` 第一行向量 `d` 混淆。
- 路径矩阵的 `e₁,He₁,...,H^(n-1)e₁` 线性无关，任意首行向量唯一表示为：
  - `v=a(H)e₁`，`deg(a)<n`
- 令 `f=g f₁`、`c=g c₁`，则：
  - `c(H)v=0 ⇔ f|ca ⇔ f₁|a`
  - `a=f₁b`，`deg(b)<d_r`
- 静默操作的整盘各行由首行唯一递推，末端条件正是 `c(H)v=0`，所以：
  - `n-rank(c(H))=n²-rank(A)=d_r`
  - `rank(c(H))=n-d_r`，`rank(A)=n²-d_r`

#### 平移对称与尺寸关系

- `g(t+1)=gcd(c(t),f(t))=g(t)`，因此：
  - `g(t)=G(t²+t)`
  - `deg(g)=2deg(G)`，秩亏必为偶数。
- 将 `n+1=2^k b`，其中 `b` 为奇数；由奇数尺寸递推可得：

| 条件 | 秩亏 |
|---|---|
| `3∤b` | `d_r(n)=2^k d_r(b-1)` |
| `3|b` | `d_r(n)=2^k d_r(b-1)+2(2^k-1)` |
| `n+1=2^k` | `d_r(n)=0`，唯一解 |
| `n+1=3·2^k` | `d_r(n)=2(2^k-1)` |
| `n+1=5·2^k` | `d_r(n)=4·2^k` |

- 若 `a+1|b+1`，则 `fₐ|f_b`、`cₐ|c_b`、`gₐ|g_b`，所以 `d_r(a)≤d_r(b)`。

#### 奇异与非奇异的统一表达

- 将右端向量写成 `Y=b(H)e₁`，未知首行写成 `X=a(H)e₁`，原方程等价于：
  - `ca≡b mod f`
- 可解条件为 `g|b`。令 `b=g b₁`，则：
  - `c₁a≡b₁ mod f₁`
  - `gcd(c₁,f₁)=1`
- 由 `sf⊕qc=g` 得 `sf₁⊕qc₁=1`，故全部解为：
  - `a₀=q b₁ mod f₁`
  - `a=a₀⊕f₁h`，`deg(h)<d_r`
- 该表达不需显式构造 `D`；实际加速还需计入向量与多项式坐标之间的转换成本。

### g(x) 及其次数的递推

#### 基本公式

- 令：
  - `gₙ(x)=gcd(fₙ(x),fₙ(x+1))`
  - `sₘ(x)=fₘ(x)⊕fₘ₋₁(x)`
  - `hₘ(x)=gcd(sₘ(x),sₘ(x+1))`
- 则：
  - `g₂ₘ(x)=hₘ(x)^2`
  - `g₂ₘ₊₁(x)=gₘ(x)^2`，当 `m mod 3 ≠ 2`
  - `g₂ₘ₊₁(x)=(x^2+x)·gₘ(x)^2`，当 `m mod 3 = 2`

#### 次数公式

- 令：
  - `dₙ=deg(gₙ)`
  - `eₘ=deg(hₘ)`
- 则：
  - `d₂ₘ=2eₘ`
  - `d₂ₘ₊₁=2dₘ`，当 `m mod 3 ≠ 2`
  - `d₂ₘ₊₁=2dₘ+2`，当 `m mod 3 = 2`
- 并且：
  1. `dₙ` 总是偶数；
  2. `0≤dₙ≤n`；
  3. `dₙ=n` 当且仅当 `n=0` 或 `n=4`。

---

## 6) Karatsuba法 · `O(n^1.585)`

后面的五种方法保留首行方程，主要加速其中的多项式运算。Karatsuba 首先将乘法降到亚二次，再通过快速除法、Half-GCD 和卷积，将加速传递到求解过程。

### 多项式结构与倍增生成

#### 特征多项式与商环

- 沿用第五章的记号，`deg(fₙ)=n`。
- `fₙ(t)=det(tI-H)`，由三对角行列式展开得到：
  - `fₙ(H)=0`（Cayley–Hamilton 定理）
- 在整数系数下，路径图特征多项式为 `Pₙ(t)=tPₙ₋₁(t)-Pₙ₋₂(t)=Uₙ(t/2)`；模 2 后减法变为加法，得到这里的 `fₙ`。`Uₙ` 为第二类切比雪夫多项式。
- 因为 `H` 的最小多项式也是 `fₙ`，所以：
  - `GF(2)[t]/(fₙ) ≅ GF(2)[H]`
  - `a≡b mod fₙ ⇒ a(H)=b(H)`
- 商环中的元素可以统一用次数小于 `n` 的多项式表示；只有与 `fₙ` 互素的元素才可逆。

#### Frobenius 与 Fibonacci 倍增

- 在 GF(2) 中：
  - `(a⊕b)²=a²⊕b²`
  - `a(t)²=Σ aᵢ t^(2i)`
- 平方只需将系数放到偶数位置，无需一般多项式乘法。
- 对 `m≥1`：

| 项目 | 偶数项 | 奇数项 |
|---|---|---|
| `f` | `f₂ₘ=(fₘ⊕fₘ₋₁)²` | `f₂ₘ₊₁=t fₘ²` |
| `c` | `c₂ₘ=(cₘ⊕cₘ₋₁)²` | `c₂ₘ₊₁=(t+1)cₘ²` |

- `m=0` 的奇数项直接使用 `f₁=t`、`c₁=t+1`。
- 同时维护相邻两项，按 `n` 的二进制位倍增：
  - `T(n)=T(⌈n/2⌉)+O(n)=O(n)`
- 因而直接计算指定尺寸的 `f/c`，不必从尺寸 1 逐项递推到 `n`。

#### 平移不变分解

- 令 `J=H+I`、`u=t²+t`、`U=H²+H`，则：
  - `c(t)=f(t+1)`，`c(H)=f(J)`
  - `u(t+1)=u(t)`
- 任意多项式唯一写成：
  - `f(t)=A_u(u)⊕t B_u(u)`
  - `c(t)=A_u(u)⊕(t+1)B_u(u)`
  - `f⊕c=B_u(u)`
- `f/c` 互为平移，一般并不相等；分解可缩短中间多项式，但本身不改变复杂度指数。

### 卷积与 Karatsuba

- 多项式乘法与 GF(2) 离散卷积相同：
  - `(ab)ₖ=⊕ᵢ aᵢ bₖ₋ᵢ`
- 记长度为 `O(n)` 的多项式乘法成本为 `M(n)`；快速乘除与 GCD 的一般框架参见 [25]。
- 拆成 `a=a₀⊕t^m a₁`、`b=b₀⊕t^m b₁`，计算：
  - `p₀=a₀b₀`，`p₂=a₁b₁`
  - `p₁=(a₀⊕a₁)(b₀⊕b₁)⊕p₀⊕p₂`
  - `ab=p₀⊕t^m p₁⊕t^(2m)p₂`
- 四次半长乘法减少为三次：
  - `M(n)=3M(n/2)+O(n)=O(n^log₂3)`

### 形式幂级数求逆与快速除法

- 对 `P(0)=1`，若 `PG≡1 mod t^k`，则精度倍增公式为：
  - `G_new=P G² mod t^(2k)`
  - `P G_new=(PG)²≡1 mod t^(2k)`
- 从 `G=1` 开始，精度按 `1,2,4,...` 增长；在通常的乘法成本正则性假设下，求逆总成本为 `O(M(n))`。
- 设 `a=bq⊕r`，`deg(a)=m`、`deg(b)=s`、`ℓ=m-s+1>0`。定义 `aᴿ=t^m a(1/t)`、`bᴿ=t^s b(1/t)`，则：
  - `qᴿ=aᴿ(bᴿ)⁻¹ mod t^ℓ`
  - `q=t^(ℓ-1)qᴿ(1/t)`
  - `r=a⊕bq`
- 因为 `b` 的最高次系数为 1，反转后的 `bᴿ(0)=1`，可以使用上述求逆；快速除法成本为 `O(M(n))`。

### Half-GCD 与 Bézout 系数

- 一步 Euclid 可写成多项式矩阵变换：
  - `(a,b)E(q)=(b,a⊕qb)`
  - `E(q)=[0,1;1,q]`
- Half-GCD 递归处理高次部分，用累计矩阵批量作用于完整多项式；在递归之间进行精确除法和次数检查，确保变换与完整 Euclid 一致。
- 继续降阶并累计变换，即可同时得到 `g` 和满足 `sf⊕qc=g` 的 `q`。
- 核心递推为：
  - `T(n)≤2T(⌈n/2⌉)+O(M(n))`
- 当 `M(n)=O(n^α)`、`α>1` 时：
  - `T(n)=O(n^α)`，不必额外乘 `log n`。
- 当 `M(n)=O(n(log n)^β)`、`β≥0` 时：
  - 每层成本随子问题规模变化，求和得到 `T(n)=O(n(log n)^(β+1))`。
- `O(M(n)log n)` 是常用统一上界；逐步 Euclid 仅替换除法内核，并不能自动得到 Half-GCD 的分治复杂度。

### Laurent 核、边界反射与快速作用

#### 从扩散到卷积核

- 用形式变量 `s` 记录位置移动，避免与向量 `z=q(H)Y` 混淆：

| 矩阵算子 | 无限直线上的 Laurent 表示 |
|---|---|
| `H` | `s⁻¹+s` |
| `J=H+I` | `s⁻¹+1+s` |
| `U=H²+H` | `s⁻²+s⁻¹+s+s²` |

- 对多项式 `P`，令 `K_P(s)=P(s⁻¹+s)`；其系数是作用 `P(H)` 的移动卷积核。
- 通过整体平移指数，Laurent 乘法转为普通多项式乘法：
  - `W(s)=K_P(s)V(s)`
  - `wᵢ=⊕ⱼ kⱼvᵢ₋ⱼ`
- 采用二分展开，在 `2^k` 位置利用 Frobenius：
  - `(s⁻¹+s)^(2^k)=s^(-2^k)+s^(2^k)`
- 高次部分只需移位异或，核展开满足 `T(n)=2T(n/2)+O(n)=O(n log n)`。

#### 有限棋盘的零边界

- 棋盘位置为 `1,...,n`，零边界位于 `0,n+1`；直接截取无限直线卷积不能代替有限矩阵作用。
- 将越界项沿零边界反射后异或回棋盘。对 `deg(P)<n`，每侧最多需要一次反射；反射扫描成本为 `O(n)`。
- 更高次数可先对 `fₙ` 取模，或用周期 `2(n+1)` 的反射延拓统一处理。
- 因而一般的 `P(H)v` 可通过“核展开—卷积—边界反射”完成：
  - `O(n log n+M(n))`
- 该方法统一用于 `z=q(H)Y`、`d=g(H)e₁` 和首行验证 `c(H)X=Y`；验证时也可先将 `c` 对 `f` 取模。

#### 全 1 目标与翻转向量

- 令 `Sₙ(t)=⊕ᵢ₌₀^(n-1) fᵢ(t)`，则：
  - `tSₙ(t)=fₙ(t)⊕fₙ₋₁(t)⊕1`
  - `Y=Sₙ(J)𝟙`
- 先在多项式环中整除 `t`，再代入 `J`；不要求矩阵 `J` 可逆。
- 构造 `Sₙ(s⁻¹+1+s)` 后，与全 1 源卷积等于连续核系数的区间异或；前缀异或或滑动窗口可在 `O(n)` 时间完成卷积，再用 `O(n)` 反射恢复边界。
- 该通用构造总成本为 `O(n log n)`；其中 `O(n)` 指全 1 卷积与反射，不应据此省略核生成成本。

### Toeplitz 系统与快速反卷积

#### 卷积核与三角系统

- Toeplitz 矩阵满足 `T[i,j]=T[i+1,j+1]`，即每条主对角线方向的元素相同。
- 下三角 Toeplitz 系统可写成：
  - `Zᵢ=⊕ⱼ₌₀^i aᵢ₋ⱼXⱼ`
  - `a(t)X(t)≡Z(t) mod t^r`
- 若 `a₀=1`，则系统可逆：
  - `X(t)=Z(t)a(t)⁻¹ mod t^r`
- 求逆和乘法成本为 `O(M(r))`；上三角情形可反转下标后处理。

#### 在奇异分支中的应用

- `D=g(H)` 具有带状结构，原来的反向消元可缩减到有效带宽；进一步优化时，需利用其主元位置和零边界，将独立方程转化为可逆的三角卷积系统。
- 固定自由变量后，对变换得到的右端做快速反卷积，再恢复首行解；总成本还需包括结构变换和边界处理。
- `g(H)` 在边界处一般不直接是 Toeplitz 矩阵，不能任意截取子块后就按第一列求逆。
- 一般双向卷积截断后的 Toeplitz 系统也不等同于模 `t^r` 的乘法；只有完成三角化并确认常数项可逆后，才可使用上述快速除法。
- 商环路线中的 `c₁a≡b₁ mod f₁` 则提供另一种统一求解方式；两条路线都应验证最终的 `c(H)X=Y`。

### 时间复杂度

- 使用 `M(n)=O(n^log₂3)` 时，Half-GCD 同样为 `O(n^log₂3)≈O(n^1.585)`。
- 若要将该界用于整个首行求解，还需使一般奇异分支及坐标变换达到对应的快速界。

---

## 7) Toom-Cook法 · `O(n^1.465)`

### 三段拆分与五次乘法

- 将两个多项式各拆成三段，每段长度约为 `m=n/3`：
  - `a=a₀+t^m a₁+t^(2m)a₂`
  - `b=b₀+t^m b₁+t^(2m)b₂`
- 把这些分段视为二次多项式 `A(v),B(v)` 的系数。乘积最高为四次，选择五个求值条件，只做五次对应乘法，即可插值恢复五个系数块。
- 最后代回 `v=t^m`，重组完整乘积。递推式为：
  - `M(n)=5M(⌈n/3⌉)+O(n)`
  - `M(n)=O(n^log₃5)≈O(n^1.465)`
- 代入 Half-GCD 后仍保留这一指数，快速除法和卷积沿用第六章的框架。

### 特征 2 下的插值

- 整数版本常用的 `0,1,-1,2` 等求值点，在 GF(2) 中会重合，不能直接套用。
- 一种可行方式是在固定扩域 `GF(4)` 上运算，使用其中四个不同元素，再结合最高次系数（无穷远点求值）。这样仍只需五次乘法，固定扩域使每次系数运算只增加常数开销。
- 实现必须包含正确的求值和插值过程；仅将多项式拆成三段，并不能得到 `1.465` 的指数。

---

## 8) FFT法 · `O(n log²n log log n)`

### 变换、逐点相乘与逆变换

- 卷积可以通过“系数转为变换值—对应位置相乘—逆变换”计算。
- 变换会在不同输出位置之间复用中间结果，避免普通乘法逐对计算系数乘积。
- 用于 GF(2) 精确乘法时，必须正确恢复系数奇偶性。浮点 FFT 需要足够精度，代数变换需要合适的单位根，并计入扩域运算。

### 时间复杂度

- 本章采用计入扩域或递归开销的经典快速多项式乘法界 [25]：
  - `M(n)=O(n log n log log n)`
- 代入 Half-GCD 后得到：
  - `T(n)=O(n log² n log log n)`
- 这里统计的是完整算术构造的成本，并非所有浮点 FFT 都具有同一个复杂度。在已有合适单位根、域运算计常数成本的模型下，乘法也可采用 `O(n log n)` 的界。

---

## 9) NTT法 · `O(n log²n)`

### 精确模整数卷积

- NTT 在有限域或模整数环中使用单位根，变换、逐点相乘和逆变换均采用精确的模运算。
- 选择不小于乘积长度的变换长度 `L`，避免循环卷积回绕。若使用素数模数 `p`，通常需满足 `L|(p-1)`。
- 将二元系数提升为整数计算时，模数或多个 CRT 模数的乘积应大于卷积系数上界。先恢复精确的整数系数，再取奇偶性。

### 时间复杂度与适用范围

- 在有合适单位根、模运算计常数成本的模型下：
  - `M(n)=O(n log n)`
  - Half-GCD 为 `O(n log² n)`。
- GF(2) 本身不支持通常的二次幂长度 NTT，需要选用合适的辅助域或环。
- 固定素数和字宽只支持有限的变换长度；上述界适用于支持范围及相应运算模型。推广到任意规模时，应另计大模数、扩域或多模数的成本。
- 精确运算避免舍入误差，但实际速度还取决于模乘、取模和数据搬运，不能仅凭复杂度判断快慢。

---

## 10) 张量法 · `O(n(log n)^(3/2))`

这里将该理论路线简称为**张量法**。张量用于组织多线性运算及其复杂度分析；具体加速依靠批量共享变换、低次多项式预测和精确修复，而不是直接计算一个更大的张量。

- 截至 2026-11-25，相关最新版本为 2026-11-24 的两篇文献 [26][27]；其上界需要区分运算模型：
  - 有限 Fourier 变换与形式多项式卷积：代数电路中的域运算数量。
  - 整数乘法：固定有限字母表、固定有限条磁带的确定性 Turing 机位操作时间。

### 基本原理

1. **分块与共享变换**：将大变换组织成许多短变换或可交换算子的乘积，复用不同切片间的计算。
2. **低次数预测与精确修复**：在共同频率基下，算子乘积由根单位乘子决定；批量平移后，计数集中在宽度 `O(√(m log m))` 的区间。低次多项式在区间内精确计算乘子，再通过少量线性校验和插值修复例外，最终结果仍是精确的。
3. **递归与原域还原**：递归复用批处理，并将扩域中的计算计回原域，得到任意固定 `ε>0` 下的形式多项式乘法上界 `O_ε(n(log n)^(1/2+ε))`。
4. **磁带模型的额外工作**：整数算法还需处理短轴布局、数据置换、有限精度误差和进位；文献给出一台固定机器的 `n(1+log n)^(1/2+o(1))` 时间上界。

### 对本算法复杂度的含义

- 将形式多项式乘法界代入 Half-GCD，按第 `j` 层的子问题长度求和：
  - `T(n)=O_ε(n Σⱼ₌₀^⌈log₂n⌉ (1+log₂n-j)^(1/2+ε))`
  - `=O_ε(n(log n)^(3/2+ε))`
- 因而“`O(n(log n)^(3/2))`”只能作为省略小指数项的简写；严格写法应保留 `ε`，或在相应的渐近指数意义下写作 `n(log n)^(3/2+o(1))`。
- 文献并未给出这里的 Lights Out Pascal 实现；上述结果是对 Half-GCD 运算成本的推导。电路构造、求值调度、坐标变换及一般奇异分支的成本，仍需分别落实。
- 整数位乘法界不能直接当作同规模 GF(2) 多项式乘法界：直接用整数打包系数通常还需要防进位的间隔位。
- OpenAI 将该集合定位为模型生成的研究手稿，并说明验证程度不一 [28]；本文按文献报告其理论结果，不将其视为本项目已实现或已独立验证的性能。

---

## 复杂度与实现范围

- 以下 `n` 始终表示棋盘边长；表中先统计 GF(2) 系数运算，机器字并行的加速另计。
- 记 `M(n)` 为乘法成本。各阶段应独立核算：

| 阶段 | 基本方法 | 快速方法与时间界 |
|---|---|---|
| `f/c` | 逐项递推 `O(n²)` | Fibonacci 倍增 `O(n)` |
| `Y` | 逐行扩散 `O(n²)` | Laurent 分治、全 1 卷积与反射 `O(n log n)` |
| `q/g` | 普通扩展 Euclid `O(n²)` | Half-GCD；通用上界 `O(M(n)log n)` |
| `z=q(H)Y` | 重复扩散 `O(n²)` | 核展开与卷积 `O(n log n+M(n))` |
| 奇异分支 `X` | 带状消元 `O((n-d_r)d_r)`，另计初始化 | 三角卷积求解本身 `O(M(r))`；另计结构变换，或采用商环路线 |
| 首行验证 | 重复扩散 `O(n²)` | `c(H)X` 的核展开与卷积 `O(n log n+M(n))` |
| 整盘生成与输出 | 逐行递推 | 显式逐格输出 `Θ(n²)` |

- 本表列出可独立推导的通用上界；特殊目标的进一步简化及具体版本的复杂度，应以完整算法与实现为依据。

### 输出与工作空间

- 求首行和输出整盘是两个不同任务。多项式求解可追求亚二次时间，但逐格写出整盘仍需 `Θ(n²)`。
- 首行总复杂度需包含多项式生成、`q/g`、右端作用、一般奇异分支和坐标变换；不能只凭乘法内核的复杂度判断整体。
- 对适当实现，滚动行向量并复用递归缓冲区可维持线性工作空间。保存整盘需要 `O(n²)` 空间；保留的递归矩阵和扩域表示也应计入。
- 固定字宽的 LongWord 打包主要降低常数。若要另列渐近的位并行加速因子，需要明确字运算模型。

---

## 可解性（自反 + 对称 ⇒ 必可解）

### 条件

点灯游戏只要满足：
1. 自反性：按钮 `a` 会翻转灯 `a`
2. 对称性：若 `a` 翻转 `b`，则 `b` 也翻转 `a`

则游戏**一定存在解**，并可推广到任意空间布局与形状，不局限于方阵。

### 线性代数证明

- 设点灯矩阵为 `A`，目标为全 1 向量 `1`。
- 因为 `A` 自反且对称，所以：
  - `A=A^T`
  - 对角线全为 1
- 若 `x` 是任意静默操作，即 `Ax=0`，则：
  - `0=x^T A x`
- 在 GF(2) 中，非对角项成对抵消，而对角项留下：
  - `x^T A x = x^T x = sum(x_i)`
- 因此：
  - `sum(x_i)=0`
- 这说明所有静默操作都与全 1 目标正交。
- 根据 `(Ker A^T)⊥ = Im A`，全 1 目标属于 `A` 的像空间，所以必有解。

---

## 工程实现与验证建议

### 实现建议

1. 统一 GF(2) 运算：行操作只用交换、XOR。
2. 边界越界按 0 处理（无邻居视为不存在）。
3. 主链优先围绕 `f,c,g,q,z,x`，不要保留无用矩阵。
4. 把 `q(H)Y`、`g(H)e0` 等统一为 `ApplyPoly(a,v)`。
5. `f/c/Y/t/D` 尽量用滚动向量实现。
6. 性能优先时，使用 bitset / 机器字存储向量，批量 XOR。

### 验证建议

1. 小规模对拍：`n≤4` 用完全穷举验证首行叠加/反向消元结果。
2. 静默维度检验：统计 `r'=deg(g)`，验证解数是否为 `2^{r'}`。
3. 线性性检验：任取两解 `x1,x2`，检查 `A·(x1⊕x2)=0`（差解应落在静默空间）。
4. 多项式一致性检验：验证 `cₙ(x)=fₙ(x+1)` 与 `gₙ=gcd(fₙ,cₙ)`。
5. 可逆/奇异分支对拍：对 `g=1` 与 `g≠1` 的 n 分别测试，确认 `B X=Y` 成立。

---

## 参考文献

[1] Jaap Scherphuis，《点灯问题游戏的数学原理》  
https://www.jaapsch.net/puzzles/lomath.htm

[2] Granvallen，《点灯游戏与数学之美》  
https://granvallen.github.io/lightoutgame/

[3] axpokl，《点灯游戏 Flip Game 的 O(n³) 求解算法》  
https://zhuanlan.zhihu.com/p/53646257

[4] Chao Xu，《逼零集、点灯游戏与线性方程组》  
https://zhuanlan.zhihu.com/p/553780037

[5] GitHub — axpokl，《点灯问题 O(n²) Pascal 求解与代码实现》  
https://github.com/axpokl/LightOut

[6] GitHub — njpipeorgan，《大规模点灯问题求解器及解法说明》  
https://github.com/njpipeorgan/LightsOut

[7] OEIS，《n×n 全亮点灯问题的解数》  
https://oeis.org/A075462

[8] OEIS，《n×n 点灯问题的秩缺陷》  
https://oeis.org/A159257

[9] OEIS，《n×n 点灯矩阵满秩 / 唯一解的尺寸》  
https://oeis.org/A076436

[10] Andries E. Brouwer，《矩形棋盘上的按钮疯狂与点灯游戏》  
https://aeb.win.tue.nl/ca/madness/madrect.html

[11] Klaus Sutner，《线性元胞自动机与伊甸园》  
https://doi.org/10.1007/BF03023823

[12] Klaus Sutner，《σ-自动机与切比雪夫多项式》  
https://doi.org/10.1016/S0304-3975(97)00242-9

[13] Henrik Eriksson、Kimmo Eriksson、Jonas Sjöstrand，《关于点灯问题的一点注记》  
https://arxiv.org/abs/math/0411201

[14] John Goldwasser、William Klostermeyer、Henry Ware，《网格图中的斐波那契多项式与奇偶支配》  
https://doi.org/10.1007/s003730200020

[15] John L. Goldwasser、William F. Klostermeyer，《网格图中的奇偶支配集》  
https://www.researchgate.net/publication/250342861_Parity_Dominating_Sets_in_Grid_Graphs

[16] Rudolf Fleischer、Jiajin Yu，《点灯游戏综述》  
https://doi.org/10.1007/978-3-642-40273-9_13

[17] Martin Kreh，《点灯游戏及其变体》  
https://doi.org/10.4169/amer.math.monthly.124.10.937

[18] Tamar Elise Wilson，《点灯游戏：矩形棋盘可解性的判定》  
https://ida.mtholyoke.edu/bitstreams/269795c9-18b9-44b5-ba88-1d4a422008da/download

[19] Anil Damle，《克雷洛夫方法》  
https://www.cs.cornell.edu/courses/cs6220/2017fa/CS6220_Lecture8.pdf

[20] Douglas H. Wiedemann，《有限域上稀疏线性方程组的求解》  
https://doi.org/10.1109/TIT.1986.1057137

[21] Erich Kaltofen、B. David Saunders，《关于 Wiedemann 稀疏线性系统求解方法》  
https://users.cs.duke.edu/~elk27/bibliography/91/KaSa91.pdf

[22] 维基百科，《克雷洛夫子空间》  
https://zh.wikipedia.org/wiki/克雷洛夫子空间

[23] 维基百科，《邻接矩阵》  
https://zh.wikipedia.org/wiki/邻接矩阵

[24] 维基百科，《常对角矩阵》  
https://zh.wikipedia.org/wiki/常对角矩阵

[25] Joachim von zur Gathen、Jürgen Gerhard，《Modern Computer Algebra》  
https://www.cambridge.org/core/books/modern-computer-algebra/DB3563D4013401734851CF683D2F03F0

[26] OpenAI，《The logarithmic exponent of finite Fourier transforms》（2026-11-24）  
https://github.com/openai/math/blob/main/preprints/The-logarithmic-exponent-of-finite-Fourier-transforms-November-24-2026/paper.pdf

[27] OpenAI，《The logarithmic exponent of integer multiplication on tapes》（2026-11-24）  
https://github.com/openai/math/blob/main/preprints/The-logarithmic-exponent-of-integer-multiplication-on-tapes-November-24-2026/paper.pdf

[28] OpenAI，数学研究手稿集合与验证说明  
https://github.com/openai/math/blob/main/README.md

---

# Lights Out Solver · Algorithm Notes

> Language: [中文](#中文版本)

---

## English version

### Table of contents

- Problem, observations and notation
- Algorithm overview
- 1) Full brute force · `O(2^(n²)·n²)`
- 2) First-row brute force · `O(2^n·n²)`
- 3) Superposition · `O(n⁶)`
- 4) First-row superposition · `O(n³)`
- 5) First-row inversion · `O(n²)`
- 6) Karatsuba · `O(n^1.585)`
- 7) Toom–Cook · `O(n^1.465)`
- 8) FFT · `O(n log²n log log n)`
- 9) NTT · `O(n log²n)`
- 10) Tensor method · `O(n(log n)^(3/2))`
- Complexity and implementation scope
- Solvability
- Engineering tips and validation
- References

---

### Problem and rules

- Board: `n × n`.
- Operation: pressing a cell toggles (on↔off):
  - itself
  - its four orthogonal neighbors (only existing neighbors on the boundary)
- Goal (two equivalent forms):
  - start from **all-off** and make all lights **on**
  - or start from **all-on** and make all lights **off**
- Binary states and operations:
  - press / not press: `1/0`
  - on / off: `1/0`
  - all operations are over **GF(2)**, namely XOR

---

### Key observations

1. **Pressing the same button twice is the same as not pressing it**  
   because two toggles return to the original state: `a ⊕ 1 ⊕ 1 = a`.
2. **The order of presses does not matter**  
   because XOR is commutative and associative: `(a ⊕ b) ⊕ c = a ⊕ (b ⊕ c)`.
3. Therefore each button only needs a binary state (pressed / not pressed), and one button pattern uniquely determines one light pattern.

---

### Terms and notation (GF(2) model)

- Flatten the board into a one-dimensional index (only for matrix notation):
  - button vector: `x ∈ {0,1}^{n^2}`
  - light vector: `l ∈ {0,1}^{n^2}`
- There is an `n^2 × n^2` 0/1 matrix `A`. Its `j`-th column describes which lights are toggled when only button `j` is pressed.
- Superposition corresponds to a linear system over GF(2):
  - `l = A · x (mod 2)`
- The all-on target can be written as:
  - `A · x = 1 (mod 2)` where `1` is the all-one vector
- A button pattern satisfying `A·x=0` is called a **silent pattern**, because it changes no lights.

---

### Algorithm overview

`n` always denotes the board side length. Methods 1–5 introduce the basic solving routes; methods 6–10 accelerate the polynomial operations in first-row inversion.

| Method | Main idea | Time complexity |
|---|---|---|
| Full brute force | Enumerate every button pattern | `O(2^(n²)·n²)` |
| First-row brute force | Enumerate the first row and determine later rows | `O(2^n·n²)` |
| Superposition | Solve the full `n²×n²` system | `O(n⁶)` |
| First-row superposition | Reduce to an `n×n` first-row system | `O(n³)` |
| First-row inversion | Use polynomial inversion and structured back-substitution | `O(n²)` |
| Karatsuba | Replace four half-length products with three | `O(n^1.585)` |
| Toom–Cook | Split into three parts and use five products | `O(n^1.465)` |
| FFT | Use fast convolution with extension/recursive overhead | `O(n log²n log log n)` |
| NTT | Use exact modular transforms for convolution | `O(n log²n)` |
| Tensor method | Share transforms, predict multipliers and repair exceptions exactly | `O(n(log n)^(3/2))` |

- Bounds below `O(n²)` concern first-row computation or the polynomial solving stage. Explicit full-board output still costs `Θ(n²)`.
- The last five bounds depend on the multiplication model and on accelerating every remaining stage. FFT/NTT require their stated transform assumptions; the tensor-method entry suppresses a small exponent term, made precise in Chapter 10.
- Multiplication exponents `1.585` and `1.465` are decimal approximations; the exact expressions appear below. These methods find a valid solution, without guaranteeing the minimum number of presses.

---

## 1) Full brute force · `O(2^(n²)·n²)`

- Enumerate every button vector `x` (length `n^2`), compute `l = A·x`, and check whether all lights are on.
- Examples:
  - `n=2`: `2^4=16`
  - `n=3`: `2^9=512`
  - `n=5`: `2^25=33,554,432`
  - `n=6`: `2^36=68,719,476,736`
- If the full board state is recomputed every time, there is an additional `O(n^2)` checking cost.

---

## 2) First-row brute force · `O(2^n·n²)`

- Key phenomenon:
  - After choosing the first-row presses, the first-row light state is fixed.
  - If a light in row 1 is off, the only way to fix it without breaking completed work is to press the button directly below it in row 2.
  - From row 2 onward, every row of presses is **uniquely determined** by the previous row’s light state.
  - Finally, check whether the last row is all on; if so, a solution has been found.
- Complexity:
  - there are `2^n` first-row choices;
  - each choice propagates over the whole board in `O(n^2)`;
  - total complexity is `O(2^n·n^2)`.

---

## 3) Superposition · `O(n⁶)`

- Write all button operations as an augmented matrix `[E | A]`:
  - the left block `E` records button combinations;
  - the right block `A` records light toggles.
- Perform Gaussian elimination over GF(2):
  - row swaps;
  - row XORs.
- If `A` is invertible, the right side can be reduced to the identity matrix, and the left side becomes `A^{-1}`.
- If `A` is singular, then there are nonzero button vectors `x` satisfying `A·x=0`, namely silent patterns.
- Why the complexity is `O(n^6)`:
  - the matrix dimension is `n^2`;
  - elimination is cubic;
  - `(n^2)^3 = n^6`.

---

## 4) First-row superposition · `O(n³)`

> Combine row-by-row propagation with linear superposition: express the last-row lights as “a linear combination of first-row presses plus a flip vector”, so only an `n×n` system must be solved.

1. Let the first-row press vector be `X` (length `n`).
2. Recursively express the last-row lights:
   - `L_last = M·X ⊕ Y_last`
   - `M` is an `n×n` matrix mapping “first-row presses → last-row lights”;
   - `Y_last` is the flip vector determined by the initial target.
3. For a target vector `T`, solve:
   - `M·X = T ⊕ Y_last`
4. Solve this `n×n` system over GF(2) to obtain `X`, then generate the full board by the standard row-by-row press-down recursion.

### Key recurrences in first-row superposition (B/L/Y)

#### Notation

- `B(n,x)`: the button at row `n`, column `x` (0/1)
- `L(n,x)`: the light at row `n`, column `x` (0/1)
- `⊕`: XOR (superposition)
- `~`: NOT; over GF(2), `~a = a ⊕ 1`

#### Basic relations

1. A light can be expressed as the XOR of the “up, left, center, right” buttons (the “down” button is handled by the next step):
   - `L(n,x)=B(n-1,x)⊕B(n,x-1)⊕B(n,x)⊕B(n,x+1)`
2. To fix the current light, the next-row press is the flipped current light:
   - `B(n+1,x)=~L(n,x)`
3. Using `~t=t⊕1`, the forced flip at each step can be extracted into a separate flip vector `Y`.

#### Second-order recurrences

- Button recurrence:
  - `B(n,x)=1⊕B(n-1,x-1)⊕B(n-1,x)⊕B(n-1,x+1)⊕B(n-2,x)`
- Flip-vector recurrence (the `~` must remain):
  - `Y(n,y)=~(Y(n-1,y-1)⊕Y(n-1,y)⊕Y(n-1,y+1)⊕Y(n-2,y))`

### Optimized matrix generation (cross even-parity constraint)

#### Cross even-parity constraint

For a mapping matrix `B=P(H)`, commutation `HB=BH` gives:

- `B(x-1,y)⊕B(x+1,y)⊕B(x,y-1)⊕B(x,y+1)=0`

#### Direct benefit

- Knowing **only the first row** of the matrix is enough to reconstruct all other rows:
  - `B(x,y)=B(x-1,y-1)⊕B(x-1,y+1)⊕B(x-2,y)`
- Therefore, when building `M`, it is not necessary to generate a full matrix for every column or every light:
  - compute the key first row;
  - fill the remaining rows by recurrence.
- The later `O(n^2)` algorithm uses the same idea: operate on first rows or a few rolling vectors whenever possible, rather than storing full matrices.

---

## 5) First-row inversion · `O(n²)`

> Goal: solve the first-row system `B X = Y` over GF(2). Here `B` is the `n×n` matrix from first-row superposition, and `Y` is the last row of the flip vector.

---

### H: left-right diffusion matrix

- Definition:
  - `H(y,x)=1` iff `|x-y|=1`
- Action:
  - multiplying a vector by `H` is the same as left-right diffusion and XOR;
  - the `x`-th entry of `v*H` is `v(x-1)⊕v(x+1)`.

---

### K/F: diffusion basis matrix and decoupling matrix

- Let `e₁` be the first unit vector and define:
  - `K=[e₁,He₁,...,H^(n-1)e₁]`
  - Each column is obtained by left-right diffusion of the preceding column.
- `K` is upper triangular with diagonal entries 1, hence invertible; write `F=K⁻¹`.
- `b=Kp` and `p=Fb` convert between ordinary vector coordinates and polynomial coordinates.
- The implementation need not store full `K/F` matrices; they describe the correspondence between the matrix and polynomial formulations.

### f/c/g/q: core polynomials

- Define the Fibonacci-type polynomials:
  - `f₀(x)=1`
  - `f₁(x)=x`
  - `fₙ(x)=x·fₙ₋₁(x)⊕fₙ₋₂(x)`
- Define:
  - `cₙ(x)=fₙ(x+1)`
- In an older derivation, one may also write `p(x)=f(x)⊕c(x)`.
- Since `f(H)=0`, we have:
  - `p(H)=c(H)`
- Therefore, the actual solver can omit `p` and directly use:
  - `g(x)=gcd(f(x),c(x))`
- Extended Euclid gives:
  - `s(x)f(x)⊕q(x)c(x)=g(x)`
- Here:
  - `g(x)` determines the rank defect and the number of solutions;
  - `q(x)` is used to construct a partial solution.

---

### Invertible case: `g=1`

- If `g(x)=1`, then there exists `q(x)` such that:
  - `q(x)c(x)=1 mod f(x)`
- Since `c(H)=B`, we get:
  - `X=q(H)Y`
- To compute `q(H)Y`:
  - start from `Y`;
  - repeatedly do left-right diffusion `cur <- H cur`;
  - if the current coefficient of `q` is 1, XOR `cur` into the answer.
- There are `n` diffusions, each costing `O(n)`, so the total cost is `O(n^2)`.

---

### Singular case: `g≠1`

- Extended Euclid gives:
  - `q(x)c(x)=g(x) mod f(x)`
- First compute:
  - `z=q(H)Y`
- The original equation is:
  - `c(H)X=Y`
- Therefore:
  - `z=q(H)c(H)X=g(H)X`
- The problem becomes:
  - `z=D X`
  - `D=g(H)`

---

### Build D and use reverse elimination

- Let:
  - `r'=deg(g)`
  - `r=n-r'`
- `D=g(H)` has a structured back-substitution form:
  1. The last `r` rows form a banded upper-triangular-like structure with a zero block on the left.
  2. In those last `r` rows, a pivot 1 appears at `i=j-r'`.
  3. Those last `r` rows are linearly independent.
  4. The first `r'` rows are linear combinations of the last `r` rows.
- Reverse elimination for one particular solution:
  - use only the last `r` rows;
  - clear `z[i]` from left to right;
  - if `z[i]=1`, the unique row to XOR is `j=i+r'`;
  - after the XOR, `z[i]` is cleared and `X[j]` is marked as 1.
- To obtain all solutions:
  - the first `r'` rows are combinations of the last `r` rows;
  - choose the first `r'` free variables, XOR their corresponding rows into `z`, then solve for the remaining variables;
  - there are `2^{r'}` combinations, hence `2^{r'}` solutions.
- Symmetry:
  - `D[j,i]=D[i,j]`
  - therefore an equivalent elimination can also be done from right to left.

### Number of solutions

- A silent pattern is a button pattern `x` satisfying `A·x=0` (it toggles zero lights).
- If the silent-space dimension is `r'`, then:
  - number of solutions `=2^{r'}`
- Examples:
  - `3×3`: no silent patterns ⇒ unique solution
  - `5×5`: `r'=2` ⇒ `4` solutions
  - `4×4`: the whole first-row space is silent ⇒ `2^4=16` solutions
- Upper bound:
  - an `n×n` board has at most `2^n` solutions
  - OEIS reference: A075462

### Rank deficiency, silent patterns and quotient-ring solving

#### Equivalent rank deficiencies

- Write `d_r=deg(g)` and `r=n-d_r`; `d_r` denotes rank deficiency, distinct from the first-row vector `d` of `D`.
- For the path matrix, `e₁,He₁,...,H^(n-1)e₁` are linearly independent. Every first-row vector has a unique representation:
  - `v=a(H)e₁`, `deg(a)<n`
- Put `f=g f₁`, `c=g c₁`. Then:
  - `c(H)v=0 ⇔ f|ca ⇔ f₁|a`
  - `a=f₁b`, `deg(b)<d_r`
- A silent board is uniquely determined by its first row, with terminal condition `c(H)v=0`, so:
  - `n-rank(c(H))=n²-rank(A)=d_r`
  - `rank(c(H))=n-d_r`, `rank(A)=n²-d_r`

#### Translation symmetry and size relations

- `g(t+1)=gcd(c(t),f(t))=g(t)`, hence:
  - `g(t)=G(t²+t)`
  - `deg(g)=2deg(G)`, so the deficiency is even.
- Write `n+1=2^k b` with odd `b`. Iterating the odd-size recurrence gives:

| Condition | Rank deficiency |
|---|---|
| `3∤b` | `d_r(n)=2^k d_r(b-1)` |
| `3|b` | `d_r(n)=2^k d_r(b-1)+2(2^k-1)` |
| `n+1=2^k` | `d_r(n)=0`, unique solution |
| `n+1=3·2^k` | `d_r(n)=2(2^k-1)` |
| `n+1=5·2^k` | `d_r(n)=4·2^k` |

- If `a+1|b+1`, then `fₐ|f_b`, `cₐ|c_b`, and `gₐ|g_b`, so `d_r(a)≤d_r(b)`.

#### A unified singular and nonsingular formulation

- Write `Y=b(H)e₁` and `X=a(H)e₁`. The original equation becomes:
  - `ca≡b mod f`
- Solvability is equivalent to `g|b`. With `b=g b₁`:
  - `c₁a≡b₁ mod f₁`
  - `gcd(c₁,f₁)=1`
- The identity `sf⊕qc=g` gives `sf₁⊕qc₁=1`. All solutions are:
  - `a₀=q b₁ mod f₁`
  - `a=a₀⊕f₁h`, `deg(h)<d_r`
- This formulation avoids explicitly building `D`; a fast implementation must also account for conversion between vector and polynomial coordinates.

### Recurrences for g(x) and its degree

#### Basic formulas

- Let:
  - `gₙ(x)=gcd(fₙ(x),fₙ(x+1))`
  - `sₘ(x)=fₘ(x)⊕fₘ₋₁(x)`
  - `hₘ(x)=gcd(sₘ(x),sₘ(x+1))`
- Then:
  - `g₂ₘ(x)=hₘ(x)^2`
  - `g₂ₘ₊₁(x)=gₘ(x)^2`, when `m mod 3 ≠ 2`
  - `g₂ₘ₊₁(x)=(x^2+x)·gₘ(x)^2`, when `m mod 3 = 2`

#### Degree formulas

- Let:
  - `dₙ=deg(gₙ)`
  - `eₘ=deg(hₘ)`
- Then:
  - `d₂ₘ=2eₘ`
  - `d₂ₘ₊₁=2dₘ`, when `m mod 3 ≠ 2`
  - `d₂ₘ₊₁=2dₘ+2`, when `m mod 3 = 2`
- Also:
  1. `dₙ` is always even;
  2. `0≤dₙ≤n`;
  3. `dₙ=n` iff `n=0` or `n=4`.

---

## 6) Karatsuba · `O(n^1.585)`

The remaining methods keep the first-row equation unchanged and accelerate its polynomial operations. Karatsuba supplies the first subquadratic multiplication kernel; fast division, Half-GCD and convolution carry the saving into the solver.

### Polynomial structure and doubling

#### Characteristic polynomial and quotient ring

- With the notation of Chapter 5, `deg(fₙ)=n`.
- `fₙ(t)=det(tI-H)`. Expanding the tridiagonal determinant gives:
  - `fₙ(H)=0` (Cayley–Hamilton theorem)
- Over the integers, the path characteristic polynomial is `Pₙ(t)=tPₙ₋₁(t)-Pₙ₋₂(t)=Uₙ(t/2)`. Reduction modulo 2 gives `fₙ`; `Uₙ` is the Chebyshev polynomial of the second kind.
- The minimal polynomial of `H` is also `fₙ`, hence:
  - `GF(2)[t]/(fₙ) ≅ GF(2)[H]`
  - `a≡b mod fₙ ⇒ a(H)=b(H)`
- Ring elements have representatives of degree below `n`; an element is invertible exactly when it is coprime to `fₙ`.

#### Frobenius and Fibonacci doubling

- Over GF(2):
  - `(a⊕b)²=a²⊕b²`
  - `a(t)²=Σ aᵢ t^(2i)`
- Squaring places coefficients at even indices and requires no general multiplication.
- For `m≥1`:

| Object | Even index | Odd index |
|---|---|---|
| `f` | `f₂ₘ=(fₘ⊕fₘ₋₁)²` | `f₂ₘ₊₁=t fₘ²` |
| `c` | `c₂ₘ=(cₘ⊕cₘ₋₁)²` | `c₂ₘ₊₁=(t+1)cₘ²` |

- At `m=0`, use `f₁=t` and `c₁=t+1` directly.
- Maintain adjacent terms and double along the binary digits of `n`:
  - `T(n)=T(⌈n/2⌉)+O(n)=O(n)`
- Computing `f/c` for one chosen size therefore does not require visiting every preceding board size.

#### Translation-invariant decomposition

- Set `J=H+I`, `u=t²+t`, and `U=H²+H`. Then:
  - `c(t)=f(t+1)`, `c(H)=f(J)`
  - `u(t+1)=u(t)`
- Every polynomial has a unique representation:
  - `f(t)=A_u(u)⊕t B_u(u)`
  - `c(t)=A_u(u)⊕(t+1)B_u(u)`
  - `f⊕c=B_u(u)`
- Translation exchanges `f/c`; they are generally different. The decomposition shortens intermediate polynomials without itself changing the complexity exponent.

### Convolution and Karatsuba

- Polynomial multiplication is discrete convolution over GF(2):
  - `(ab)ₖ=⊕ᵢ aᵢ bₖ₋ᵢ`
- Let `M(n)` denote the cost of multiplying polynomials of length `O(n)`; see [25] for the general framework of fast multiplication, division and GCD.
- Split `a=a₀⊕t^m a₁`, `b=b₀⊕t^m b₁`, and compute:
  - `p₀=a₀b₀`, `p₂=a₁b₁`
  - `p₁=(a₀⊕a₁)(b₀⊕b₁)⊕p₀⊕p₂`
  - `ab=p₀⊕t^m p₁⊕t^(2m)p₂`
- Three half-length products replace four:
  - `M(n)=3M(n/2)+O(n)=O(n^log₂3)`

### Power-series inversion and fast division

- For `P(0)=1`, if `PG≡1 mod t^k`, precision doubles by:
  - `G_new=P G² mod t^(2k)`
  - `P G_new=(PG)²≡1 mod t^(2k)`
- Start with `G=1` and precisions `1,2,4,...`. Under the usual regularity assumptions on multiplication cost, inversion costs `O(M(n))` in total.
- Let `a=bq⊕r`, `deg(a)=m`, `deg(b)=s`, and `ℓ=m-s+1>0`. Define `aᴿ=t^m a(1/t)` and `bᴿ=t^s b(1/t)`. Then:
  - `qᴿ=aᴿ(bᴿ)⁻¹ mod t^ℓ`
  - `q=t^(ℓ-1)qᴿ(1/t)`
  - `r=a⊕bq`
- The leading coefficient of `b` is 1, so `bᴿ(0)=1`. The inversion applies, giving fast division in `O(M(n))`.

### Half-GCD and Bézout coefficients

- One Euclidean step is a polynomial matrix transformation:
  - `(a,b)E(q)=(b,a⊕qb)`
  - `E(q)=[0,1;1,q]`
- Half-GCD recursively processes leading parts and applies accumulated matrices to the full polynomials. Exact divisions and degree checks between recursive calls ensure agreement with full Euclid.
- Continuing the degree reduction while accumulating transformations produces both `g` and `q` with `sf⊕qc=g`.
- The central recurrence is:
  - `T(n)≤2T(⌈n/2⌉)+O(M(n))`
- If `M(n)=O(n^α)` with `α>1`:
  - `T(n)=O(n^α)`, without an additional `log n` factor.
- If `M(n)=O(n(log n)^β)` with `β≥0`:
  - Summing the varying costs across levels gives `T(n)=O(n(log n)^(β+1))`.
- `O(M(n)log n)` is a convenient general upper bound. Replacing the division kernel in stepwise Euclid alone does not establish the Half-GCD complexity.

### Laurent kernels, boundary reflection and fast application

#### From diffusion to convolution kernels

- Use the formal variable `s` for displacement, distinct from the vector `z=q(H)Y`:

| Matrix operator | Laurent representation on the infinite line |
|---|---|
| `H` | `s⁻¹+s` |
| `J=H+I` | `s⁻¹+1+s` |
| `U=H²+H` | `s⁻²+s⁻¹+s+s²` |

- For a polynomial `P`, set `K_P(s)=P(s⁻¹+s)`. Its coefficients form the displacement kernel for `P(H)`.
- Shifting all exponents converts Laurent multiplication to ordinary polynomial multiplication:
  - `W(s)=K_P(s)V(s)`
  - `wᵢ=⊕ⱼ kⱼvᵢ₋ⱼ`
- Binary expansion uses Frobenius at power-of-two split positions:
  - `(s⁻¹+s)^(2^k)=s^(-2^k)+s^(2^k)`
- The high part needs only shifts and XOR, so kernel construction satisfies `T(n)=2T(n/2)+O(n)=O(n log n)`.

#### Zero boundaries on a finite board

- Board positions are `1,...,n`, with zero boundaries at `0,n+1`. Simply truncating infinite-line convolution does not give the finite matrix action.
- Reflect exterior terms across the zero boundaries and XOR them into the board. For `deg(P)<n`, at most one reflection per side is needed, costing `O(n)`.
- For higher degrees, first reduce modulo `fₙ`, or use reflection extension of period `2(n+1)`.
- General `P(H)v` can therefore be computed by kernel construction, convolution and reflection in:
  - `O(n log n+M(n))`
- This covers `z=q(H)Y`, `d=g(H)e₁`, and first-row verification `c(H)X=Y`; `c` may also be reduced modulo `f` before verification.

#### The all-one target and flip vector

- Set `Sₙ(t)=⊕ᵢ₌₀^(n-1) fᵢ(t)`. Then:
  - `tSₙ(t)=fₙ(t)⊕fₙ₋₁(t)⊕1`
  - `Y=Sₙ(J)𝟙`
- Divide exactly by `t` in the polynomial ring before substituting `J`; no inverse of the matrix `J` is required.
- After constructing `Sₙ(s⁻¹+1+s)`, convolution with the all-one source is a range XOR of consecutive kernel coefficients. Prefix XOR or a sliding window computes it in `O(n)`, followed by `O(n)` boundary reflection.
- This general construction costs `O(n log n)` overall. The linear convolution and reflection costs do not eliminate the cost of constructing the kernel.

### Toeplitz systems and fast deconvolution

#### Convolution kernels and triangular systems

- A Toeplitz matrix satisfies `T[i,j]=T[i+1,j+1]`: its diagonals are constant.
- A lower triangular Toeplitz system has the form:
  - `Zᵢ=⊕ⱼ₌₀^i aᵢ₋ⱼXⱼ`
  - `a(t)X(t)≡Z(t) mod t^r`
- If `a₀=1`, it is invertible:
  - `X(t)=Z(t)a(t)⁻¹ mod t^r`
- Inversion and multiplication cost `O(M(r))`; reverse indices for an upper triangular system.

#### Application to the singular branch

- `D=g(H)` is banded, so reverse elimination can restrict work to its effective bandwidth. Further acceleration must use its pivot positions and zero boundaries to transform the independent equations into an invertible triangular convolution system.
- After fixing free variables, deconvolve the transformed right-hand side and recover the first row. The total cost must also include structural transformations and boundary handling.
- Near the boundaries, `g(H)` is generally not itself Toeplitz; an arbitrary submatrix cannot be inverted as a series using its first column.
- A truncated two-sided Toeplitz convolution is not automatically multiplication modulo `t^r`. Fast division applies only after triangularization and verification that the constant term is invertible.
- The quotient-ring equation `c₁a≡b₁ mod f₁` provides another unified route. Both routes should verify `c(H)X=Y` at the end.

### Time bound

- With `M(n)=O(n^log₂3)`, Half-GCD also costs `O(n^log₂3)≈O(n^1.585)`.
- The same bound applies to the full first-row solver only when its general singular branch and coordinate conversions are accelerated as well.

---

## 7) Toom–Cook · `O(n^1.465)`

### Three-way splitting

- Split each polynomial into three blocks of length about `m=n/3`:
  - `a=a₀+t^m a₁+t^(2m)a₂`
  - `b=b₀+t^m b₁+t^(2m)b₂`
- Regard the blocks as coefficients of quadratics `A(v),B(v)`. Their product has degree at most 4, so five evaluations and products determine its five coefficient blocks by interpolation.
- Recombine the blocks by substituting `v=t^m`. The recurrence is:
  - `M(n)=5M(⌈n/3⌉)+O(n)`
  - `M(n)=O(n^log₃5)≈O(n^1.465)`
- Substitution into Half-GCD preserves this power-law exponent. The fast division and convolution framework from Chapter 6 is reused.

### Interpolation over characteristic two

- Integer formulas using points such as `0,1,-1,2` do not transfer directly to GF(2), where these points coincide.
- One valid approach works over a fixed extension such as `GF(4)`, using its four distinct elements and the leading coefficient (evaluation at infinity). Five products then suffice; the fixed extension adds constant overhead per coefficient operation.
- The implementation must supply exact evaluation and interpolation. Three-way splitting alone does not establish the `1.465` exponent.

---

## 8) FFT · `O(n log²n log log n)`

### Transform, multiply, invert

- Convolution can be computed by converting coefficient lists to transform values, multiplying corresponding values, and applying the inverse transform.
- The transform shares intermediate work across output positions, avoiding the pairwise coefficient products of ordinary multiplication.
- For exact GF(2) multiplication, the representation must recover the coefficient parities correctly. Floating-point FFT requires sufficient precision; algebraic transforms require suitable roots and account for extension arithmetic.

### Time bound

- This chapter uses the classical fast polynomial multiplication bound with extension or recursive overhead [25]:
  - `M(n)=O(n log n log log n)`
- Substitution into Half-GCD gives:
  - `T(n)=O(n log² n log log n)`
- These are costs of the complete arithmetic construction, not a claim that every floating-point FFT has this exact bound. A model with suitable roots and unit-cost operations may instead admit `M(n)=O(n log n)`.

---

## 9) NTT · `O(n log²n)`

### Exact modular convolution

- NTT uses roots of unity in a finite field or modular ring. Its transform, pointwise products and inverse transform use exact modular arithmetic.
- Choose a transform length `L` at least as large as the product length to avoid cyclic wraparound. Over a prime field, a usual requirement is `L|(p-1)`.
- When lifting binary coefficients to integers, ensure the modulus, or the product of CRT moduli, exceeds the largest convolution coefficient. Recover the exact integer coefficients before taking their parities.

### Time bound and supported sizes

- With suitable roots and constant-cost modular operations:
  - `M(n)=O(n log n)`
  - Half-GCD costs `O(n log² n)`.
- GF(2) itself does not support the usual power-of-two NTT; a suitable auxiliary field or ring is needed.
- A fixed prime and word width support only a finite range of transform lengths. The bound applies within that supported range and operation model; arbitrary input sizes require counting larger-modulus, extension or multi-modulus costs.
- Exactness prevents rounding errors, but does not guarantee lower elapsed time: modular products, reductions and data movement affect constants.

---

## 10) Tensor method · `O(n(log n)^(3/2))`

The **tensor method** is a short name for this theoretical approach. Tensors organize multilinear operations and their complexity analysis; the actual speedup comes from sharing transforms across batches, low-degree prediction and exact repair, rather than directly computing a larger tensor.

- As of 2026-11-25, the relevant latest editions are the two manuscripts dated 2026-11-24 [26][27]. Their upper bounds use different models:
  - Finite Fourier transforms and formal polynomial convolution: field operations in algebraic circuits.
  - Integer multiplication: bit-operation time on a deterministic Turing machine with a fixed finite alphabet and a fixed finite number of tapes.

### Basic principle

1. **Blocking and shared transforms**: organize a large transform into short transforms or products of commuting operators, sharing work among independent slices.
2. **Low-degree prediction and exact repair**: in a common frequency basis, products are determined by root-of-unity multipliers. Across a shifted batch, the counts concentrate in a window of width `O(√(m log m))`. A low-degree polynomial is exact on that window; a small number of linear checks and interpolation repairs the exceptions, producing an exact result.
3. **Recursion and descent to the original field**: recursively reuse batches and charge extension-field work back to the base field, yielding formal polynomial multiplication in `O_ε(n(log n)^(1/2+ε))` operations for every fixed `ε>0`.
4. **Additional tape-model work**: integer multiplication also accounts for short-axis layouts, record permutations, finite-precision errors and carries. The manuscript gives one fixed machine taking `n(1+log n)^(1/2+o(1))` time.

### Implication for this solver

- Substitute the formal multiplication bound into Half-GCD and sum over the subproblem sizes at level `j`:
  - `T(n)=O_ε(n Σⱼ₌₀^⌈log₂n⌉ (1+log₂n-j)^(1/2+ε))`
  - `=O_ε(n(log n)^(3/2+ε))`
- Thus `O(n(log n)^(3/2))` is only shorthand suppressing a small exponent term. A strict statement retains `ε`, or uses `n(log n)^(3/2+o(1))` in the corresponding asymptotic-exponent sense.
- These manuscripts do not provide this Lights Out Pascal implementation. The displayed bound is a derivation for Half-GCD operation cost; circuit construction, evaluation scheduling, coordinate conversions and the general singular branch still require separate implementation and analysis.
- The integer bit-multiplication bound is not automatically a same-size GF(2) polynomial bound: direct integer packing usually requires extra spacing to prevent carries between coefficient slots.
- OpenAI describes the collection as model-generated research manuscripts with varying verification status [28]. These theoretical results are reported as such, rather than as implemented or independently verified performance of this project.

---

## Complexity and implementation scope

- Throughout, `n` is the board side length. The tables first count GF(2) coefficient operations; word-level parallelism is accounted for separately.
- Let `M(n)` be multiplication cost. Account for each stage independently:

| Stage | Basic method | Fast method and time bound |
|---|---|---|
| `f/c` | Termwise recurrence, `O(n²)` | Fibonacci doubling, `O(n)` |
| `Y` | Rowwise diffusion, `O(n²)` | Laurent divide and conquer, all-one convolution and reflection, `O(n log n)` |
| `q/g` | Ordinary extended Euclid, `O(n²)` | Half-GCD; general upper bound `O(M(n)log n)` |
| `z=q(H)Y` | Repeated diffusion, `O(n²)` | Kernel construction and convolution, `O(n log n+M(n))` |
| Singular-branch `X` | Banded elimination, `O((n-d_r)d_r)`, plus initialization | Triangular convolution solve itself, `O(M(r))`; add structural conversion, or use the quotient-ring route |
| First-row verification | Repeated diffusion, `O(n²)` | Kernel construction and convolution for `c(H)X`, `O(n log n+M(n))` |
| Full-board generation and output | Rowwise recurrence | Explicit cell-by-cell output, `Θ(n²)` |

- This table records independently derivable general bounds. Further simplifications for special targets and version-specific bounds require a complete algorithm and implementation.

### Output and workspace

- First-row computation and full-board output are different tasks. A fast polynomial solver can produce a first row in subquadratic time, while writing every board cell still takes `Θ(n²)`.
- The first-row bound includes polynomial generation, `q/g`, application to the right-hand side, the general singular branch, and all coordinate conversions. A faster multiplication kernel alone does not establish the total bound.
- Rolling row vectors and reused recursive buffers can keep workspace linear for suitable implementations. Storing the full board costs `O(n²)` space; retained recursion matrices and extension representations must also be counted.
- Fixed-width LongWord packing mainly reduces constants. Any asymptotic word-parallel factor requires an explicit word-operation model.

---

## Solvability (reflexive + symmetric ⇒ always solvable)

### Conditions

A Lights Out game is always solvable if:
1. Reflexive: button `a` toggles light `a`
2. Symmetric: if `a` toggles `b`, then `b` also toggles `a`

This holds for arbitrary spatial layouts and shapes, not just square boards.

### Linear algebra proof

- Let the Lights Out matrix be `A`, and let the target be the all-one vector `1`.
- Since `A` is reflexive and symmetric:
  - `A=A^T`
  - the diagonal entries are all 1
- If `x` is any silent pattern, i.e. `Ax=0`, then:
  - `0=x^T A x`
- Over GF(2), off-diagonal terms cancel in pairs, while diagonal terms remain:
  - `x^T A x = x^T x = sum(x_i)`
- Therefore:
  - `sum(x_i)=0`
- This means every silent pattern is orthogonal to the all-one target.
- By `(Ker A^T)⊥ = Im A`, the all-one target lies in the image of `A`, so a solution exists.

---

## Engineering tips and validation

### Implementation tips

1. Use one consistent GF(2) model: row operations are only swap and XOR.
2. Treat out-of-bound neighbors as 0 (nonexistent).
3. Keep the main chain centered on `f,c,g,q,z,x`; avoid keeping unused matrices.
4. Unify `q(H)Y`, `g(H)e0`, and similar operations as `ApplyPoly(a,v)`.
5. Implement `f/c/Y/t/D` with rolling vectors whenever possible.
6. For performance, store vectors as bitsets / machine words and XOR in batches.

### Validation checklist

1. Small-n cross-check: for `n≤4`, brute force all patterns and compare with first-row superposition / reverse elimination.
2. Silent-dimension check: compute `r'=deg(g)` and verify that the solution count is `2^{r'}`.
3. Linearity check: for any two solutions `x1,x2`, verify `A·(x1⊕x2)=0` (their difference should be silent).
4. Polynomial consistency check: verify `cₙ(x)=fₙ(x+1)` and `gₙ=gcd(fₙ,cₙ)`.
5. Invertible/singular branch cross-check: test n values with `g=1` and `g≠1`, and confirm that `B X=Y` holds.

---

## References

[1] Jaap Scherphuis, “Lights Out Mathematics”  
https://www.jaapsch.net/puzzles/lomath.htm

[2] Granvallen, “Lights Out Game and the Beauty of Mathematics”  
https://granvallen.github.io/lightoutgame/

[3] axpokl, “Flip Game O(n³) Solver”  
https://zhuanlan.zhihu.com/p/53646257

[4] Chao Xu, “Null Set, Lights Out, and Linear Equations”  
https://zhuanlan.zhihu.com/p/553780037

[5] GitHub — axpokl, “Lights Out O(n²) Pascal solver and implementation”  
https://github.com/axpokl/LightOut

[6] GitHub — njpipeorgan, “Large-scale Lights Out solver and notes”  
https://github.com/njpipeorgan/LightsOut

[7] OEIS, “Number of solutions of the all-ones n×n Lights Out puzzle”  
https://oeis.org/A075462

[8] OEIS, “Rank deficiency of the n×n Lights Out matrix”  
https://oeis.org/A159257

[9] OEIS, “Full-rank / uniquely solvable sizes for the n×n Lights Out matrix”  
https://oeis.org/A076436

[10] Andries E. Brouwer, “Button Madness and Lights Out on Rectangles”  
https://aeb.win.tue.nl/ca/madness/madrect.html

[11] Klaus Sutner, “Linear Cellular Automata and the Garden-of-Eden”  
https://doi.org/10.1007/BF03023823

[12] Klaus Sutner, “σ-Automata and Chebyshev-Polynomials”  
https://doi.org/10.1016/S0304-3975(97)00242-9

[13] Henrik Eriksson, Kimmo Eriksson, Jonas Sjöstrand, “Note on the Lamp Lighting Problem”  
https://arxiv.org/abs/math/0411201

[14] John Goldwasser, William Klostermeyer, Henry Ware, “Fibonacci Polynomials and Parity Domination in Grid Graphs”  
https://doi.org/10.1007/s003730200020

[15] John L. Goldwasser, William F. Klostermeyer, “Parity Dominating Sets in Grid Graphs”  
https://www.researchgate.net/publication/250342861_Parity_Dominating_Sets_in_Grid_Graphs

[16] Rudolf Fleischer, Jiajin Yu, “A Survey of the Game ‘Lights Out!’”  
https://doi.org/10.1007/978-3-642-40273-9_13

[17] Martin Kreh, “‘Lights Out’ and Variants”  
https://doi.org/10.4169/amer.math.monthly.124.10.937

[18] Tamar Elise Wilson, “Lights Out: Determining Solvability on Rectangular Boards”  
https://ida.mtholyoke.edu/bitstreams/269795c9-18b9-44b5-ba88-1d4a422008da/download

[19] Anil Damle, “Krylov Methods”  
https://www.cs.cornell.edu/courses/cs6220/2017fa/CS6220_Lecture8.pdf

[20] Douglas H. Wiedemann, “Solving Sparse Linear Equations over Finite Fields”  
https://doi.org/10.1109/TIT.1986.1057137

[21] Erich Kaltofen, B. David Saunders, “On Wiedemann's Method of Solving Sparse Linear Systems”  
https://users.cs.duke.edu/~elk27/bibliography/91/KaSa91.pdf

[22] Wikipedia, “Krylov Subspace”  
https://en.wikipedia.org/wiki/Krylov_subspace

[23] Wikipedia, “Adjacency Matrix”  
https://en.wikipedia.org/wiki/Adjacency_matrix

[24] Wikipedia, “Toeplitz Matrix”  
https://en.wikipedia.org/wiki/Toeplitz_matrix

[25] Joachim von zur Gathen, Jürgen Gerhard, “Modern Computer Algebra”  
https://www.cambridge.org/core/books/modern-computer-algebra/DB3563D4013401734851CF683D2F03F0

[26] OpenAI, “The logarithmic exponent of finite Fourier transforms” (2026-11-24)  
https://github.com/openai/math/blob/main/preprints/The-logarithmic-exponent-of-finite-Fourier-transforms-November-24-2026/paper.pdf

[27] OpenAI, “The logarithmic exponent of integer multiplication on tapes” (2026-11-24)  
https://github.com/openai/math/blob/main/preprints/The-logarithmic-exponent-of-integer-multiplication-on-tapes-November-24-2026/paper.pdf

[28] OpenAI, Mathematical manuscript collection and verification notes  
https://github.com/openai/math/blob/main/README.md

