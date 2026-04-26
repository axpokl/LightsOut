# 点灯游戏（Lights Out）求解器 · 算法说明

> Language: [English](#english-version)

---

## 中文版本

### 目录
- 问题与规则
- 关键观察（按两次抵消、顺序无关）
- 术语与记号（GF(2) 建模）
- 算法总览（对比表）
- 四类基础路线
  - 1) 完全穷举 · `O(2^(n^2))`
  - 2) 首行穷举 · `O(2^n·n^2)`
  - 3) 叠加法（全局高斯消元）· `O(n^6)`
  - 4) 首行叠加法 · `O(n^3)`
- 首行叠加法的关键递推（B/L/Y）
- 优化生成矩阵（十字偶校验约束）
- 解的数量（静默操作、最多 `2^n`）
- 首行求逆 + 反向消元（O(n^2)）
  - H：左右扩散矩阵
  - K/F：扩散基矩阵与解耦矩阵
  - f/c/g/q：核心多项式
  - 可逆：`g=1`
  - 不可逆：`g≠1`，D 矩阵与反向消元
- g(x) 的结构与次数性质
- 复杂度与进一步优化
- 可解性（自反 + 对称 ⇒ 必可解）
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

### 算法总览（对比表）

| 方法 | 核心思路 | 规模 | 时间复杂度 | 空间复杂度 | 备注 |
|---|---|---:|---:|---:|---|
| 完全穷举 | 遍历所有 `n^2` 按钮的 0/1 组合 | `2^(n^2)` | `O(2^(n^2)·n^2)` | `O(n^2)` | 最直观，也最爆炸 |
| 首行穷举 | 只穷举第 1 行，后续行按“压灯”唯一递推 | `2^n` | `O(2^n·n^2)` | `O(n^2)` | 从第 2 行起按法由上一行灯状态决定 |
| 叠加法（全局消元） | 对 `[E / A]` 做 GF(2) 高斯消元，求逆/伪逆/零空间 | `n^2×n^2` | `O(n^6)` | `O(n^4)` | 解释“静默操作=多解”最直观 |
| **首行叠加法** | 把末行灯表示成首行按钮线性组合 + 翻转向量，只解 `n×n` | `n×n` | **`O(n^3)`** | **`O(n^2)`** | 规模从 `n^2` 降为 `n` |
| **首行求逆 + 反向消元** | 多项式/扩散基/欧几里得 + 结构化回代 | n | **`O(n^2)`** | **`O(n)` 工作空间** | 若完整保存输出矩阵，总空间仍为 `O(n^2)` |

---

## 四类基础路线

### 1) 完全穷举 · `O(2^(n^2))`
- 枚举所有按钮向量 `x`（长度 `n^2`），计算 `l = A·x`，检查是否全亮。
- 示例：
  - `n=2`：`2^4=16`
  - `n=3`：`2^9=512`
  - `n=5`：`2^25=33,554,432`
  - `n=6`：`2^36=68,719,476,736`
- 若每次都重新计算整盘灯状态，实际会带上额外的 `O(n^2)` 检查成本。

---

### 2) 首行穷举 · `O(2^n·n^2)`
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

### 3) 叠加法（全局高斯消元）· `O(n^6)`
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

### 4) 首行叠加法 · `O(n^3)`
> 将“首行穷举的逐行递推”与“线性叠加”结合：把最后一行灯写成“首行按钮的线性组合 + 翻转向量”，于是只需求解 `n×n` 系统。

1. 令首行按钮向量为 `X`（长度 `n`）。
2. 递推出末行灯：
   - `L_last = M·X ⊕ Y_last`
   - `M` 是 `n×n` 矩阵，表示“首行按钮 → 末行灯”的线性映射；
   - `Y_last` 是与初始目标有关的翻转向量。
3. 对目标向量 `T`，只需解：
   - `M·X = T ⊕ Y_last`
4. 在 GF(2) 上对 `n×n` 系统消元得到 `X`，再用逐行压灯递推生成整盘按钮。

---

## 首行叠加法的关键递推（B/L/Y）

### 记号
- `B(n,x)`：第 `n` 行、第 `x` 列按钮（0/1）
- `L(n,x)`：第 `n` 行、第 `x` 列灯（0/1）
- `⊕`：叠加（XOR）
- `~`：翻转（NOT），在 GF(2) 中 `~a = a ⊕ 1`

### 基本关系
1. 灯可由“上、左、中、右按钮”叠加表示（将“下按钮”留到下一步）：
   - `L(n,x)=B(n-1,x)⊕B(n,x-1)⊕B(n,x)⊕B(n,x+1)`
2. 为修正当前灯，下一行按钮取为当前灯翻转：
   - `B(n+1,x)=~L(n,x)`
3. 使用 `~t=t⊕1`，可以把每步必然出现的翻转单独抽成翻转向量 `Y`。

### 二阶递推
- 按钮递推：
  - `B(n,x)=B(n-1,x-1)⊕B(n-1,x)⊕B(n-1,x+1)⊕B(n-2,x)`
- 灯递推（形式相同）：
  - `L(n,x)=L(n-1,x-1)⊕L(n-1,x)⊕L(n-1,x+1)⊕L(n-2,x)`
- 翻转向量递推（必须保留 `~`）：
  - `Y(n,y)=~(Y(n-1,y-1)⊕Y(n-1,y)⊕Y(n-1,y+1)⊕Y(n-2,y))`

---

## 优化生成矩阵（十字偶校验约束）

### 十字偶校验约束
对相关的按钮/灯映射矩阵，满足：
- `B(x-1,y)⊕B(x+1,y)⊕B(x,y-1)⊕B(x,y+1)=0`

### 直接收益
- 只要知道矩阵的**第一行**，就能递推出其余各行：
  - `B(x,y)=B(x-1,y-1)⊕B(x-1,y+1)⊕B(x-2,y)`
- 因此生成 `M` 时不必为每个列/每个灯生成完整矩阵：
  - 先求关键的第一行；
  - 再用递推补全。
- 后续 `O(n^2)` 算法也沿用了同一思想：尽量只操作第一行或少量滚动向量，不保存整张矩阵。

---

## 解的数量（静默操作、最多 `2^n`）

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
- 多项式表达：
  - `f₀(x)=1`
  - `f₁(x)=x`
  - `fₙ(x)=x·fₙ₋₁(x)⊕fₙ₋₂(x)`
  - `cₙ(x)=fₙ(x+1)`
  - `gₙ(x)=gcd(fₙ(x),cₙ(x))=gcd(fₙ(x),fₙ(x+1))`
  - `r'=deg(gₙ)`
  - 解的数量 `=2^{deg(gₙ)}`

---

## 首行求逆 + 反向消元（O(n^2)）

> 目标：求解首行系统 `B X = Y`（GF(2)）。这里的 `B` 是首行叠加法得到的 `n×n` 矩阵，`Y` 是翻转向量的最后一行。

---

### 1) H：左右扩散矩阵
- 定义：
  - `H(y,x)=1` 当且仅当 `|x-y|=1`
- 作用：
  - 向量乘 `H` 等价于左右扩散叠加；
  - `v*H` 的第 `x` 位为 `v(x-1)⊕v(x+1)`。

---

### 2) K/F：扩散基矩阵与解耦矩阵
- `K` 是 Krylov 扩散基矩阵：
  - `K(n)=H^n(0)`
  - `K(n,x)=K(n-1,x-1)⊕K(n-1,x+1)`
- `F` 是 `K` 的逆：
  - `F=K^{-1}`
  - `F(y,x)=F(y-1,x-1)⊕F(y-2,x)`
- 在推导上，可以用 `b=Kp` 与 `p=Fb` 将矩阵 `B` 表示成某个多项式作用在 `H` 上。
- 在最终实现上，`b`、完整 `K`、完整 `F` 都不是必须常驻的对象。它们主要用于说明从矩阵问题到多项式问题的等价关系。

---

### 3) f/c/g/q：核心多项式
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

### 4) 可逆情况：`g=1`
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

### 5) 不可逆情况：`g≠1`
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

### 6) 构造 D 并反向消元
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
  - 叠加后 `z[i]` 被消去，同时在 `X[i]` 记 1。
- 得到全部解：
  - 前 `r'` 行可由后 `r` 行叠加；
  - 在求解前可任意叠加前 `r'` 行改变 `z`；
  - 共有 `2^{r'}` 种组合，因此产生 `2^{r'}` 个解。
- 对称性：
  - `D[j,i]=D[i,j]`
  - 因此也可从右往左做等价消元。

---

## g(x) 的结构与次数性质

### 基本公式
- 令：
  - `gₙ(x)=gcd(fₙ(x),fₙ(x+1))`
  - `sₘ(x)=fₘ(x)⊕fₘ₋₁(x)`
  - `hₘ(x)=gcd(sₘ(x),sₘ(x+1))`
- 则：
  - `g₂ₘ(x)=hₘ(x)^2`
  - `g₂ₘ₊₁(x)=gₘ(x)^2`，当 `m mod 3 ≠ 2`
  - `g₂ₘ₊₁(x)=(x^2+x)·gₘ(x)^2`，当 `m mod 3 = 2`

### 次数公式
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

### 关于递推生成 g(x)
- 只依靠较小的 `gₙ` 本身，不能闭合递推出较大的 `gₙ`。
- 原因：
  - 奇数分支还需要知道 `m mod 3`；
  - 偶数分支需要额外的 `hₘ` 家族。
- 因此，更合理的方向是维护 `gₙ` 与 `hₙ` 两个家族，形成类似 2-regular / 二进制自动机的递推系统。
- 若只要求输出 `gₙ` 的全部系数，则输出本身已有 `Ω(n)` 下界；若该递推系统闭合，理论目标就是线性输出复杂度 `O(n)`。

---

## 复杂度与进一步优化

### 当前主线
当前求解可以概括为：

1. 递推出当前 `n` 对应的：
   - `f(x)`：模多项式 / 特征多项式；
   - `c(x)=f(x+1)`；
   - `Y`：右端翻转向量。
2. 用扩展欧几里得求：
   - `s(x)f(x)⊕q(x)c(x)=g(x)`
3. 计算：
   - `z=q(H)Y`
4. 若 `g=1`：
   - `X=z`
5. 若 `g≠1`：
   - 构造或滚动生成 `D=g(H)`；
   - 通过反向消元解 `D X=z`。
6. 由第一行解 `X` 递推出整盘按钮矩阵。

---

### 时间复杂度
- 若要输出完整 `n×n` 按钮矩阵，输出本身就有 `n^2` 个格子：
  - 因此总时间复杂度不可能渐近低于 `Ω(n^2)`。
- 当前完整求解主线可做到：
  - `O(n^2)` 时间。
- 真正可能进一步追求 `O(n log n)` 或 `O(n log^2 n)` 的部分，是：
  1. 只求第一行解；
  2. 只判断有无解 / 求解空间维数；
  3. 将内部多项式运算加速，但最终输出整盘时仍回到 `O(n^2)`。

---

### 空间复杂度
- 完整矩阵并非都需要保存。
- 可以省去或滚动计算：
  - `p`：因为 `p(H)=c(H)`，可直接用 `c`；
  - `b`：只用于求 `p`，主链不再需要；
  - `K`：`d0=K*g` 可改为 `d0=g(H)e0`；
  - `f/c/Y/t/D`：只依赖有限前序行时可滚动计算。
- 若最终结果 `t` 流式输出，不常驻内存，则工作空间可做到：
  - `O(n)`
- 若最终仍把整个按钮矩阵 `t` 留在内存中，则总空间仍是：
  - `O(n^2)`

---

### 可继续优化的热点
1. **扩展欧几里得**
   - 当前普通实现为 `O(n^2)`；
   - 可考虑 half-gcd / 分治 extgcd；
   - 若多项式乘法为 `M(n)`，理论上可到 `O(M(n)log n)`；
   - 若配合 FFT 型乘法，可接近 `O(n log^2 n)`。
2. **`ApplyPoly(a,v)=a(H)v`**
   - 统一表示 `z=q(H)Y` 与 `d0=g(H)e0`；
   - 若当前扩散向量已经为 0，则后续永远为 0，可以提前停止；
   - 更进一步可研究卷积 / 快速多项式作用。
3. **奇异分支回代**
   - `D=g(H)` 是带宽不超过 `deg(g)` 的带状矩阵；
   - 回代时只扫有效区间 `[max(0,i-r), min(n-1,i+r)]`；
   - 奇异分支可由整行扫描优化为 `O(nr)`，其中 `r=deg(g)` 或相应带宽参数；
   - 最坏仍为 `O(n^2)`，但很多规模会更快。
4. **商环统一解法**
   - 进一步可把奇异 / 非奇异分支统一到商环求解框架；
   - 这样有机会整体删除显式 `D=g(H)` 与反向叠加法；
   - 这属于较大的数学重构，适合在当前 `O(n^2)` 主线稳定后继续研究。

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

### 图论证明思路
- 把游戏看成带自环无向图：
  - 顶点 = 按钮/灯；
  - 边 = 翻转关系；
  - 自环 = 自反；
  - 无向边 = 对称。
- 反设存在最小不可解图。
- 去掉任意一个顶点后，较小图可解，因此可构造“除某点外全翻”的操作。
- 将这些操作叠加，并结合奇偶性与握手引理，可推出矛盾。
- 因此最小不可解图不存在，游戏必可解。

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


---

# Lights Out Solver · Algorithm Notes

> Language: [中文](#中文版本)

---

## English version

### Table of contents
- Problem and rules
- Key observations (press twice cancels, order does not matter)
- Terms and notation (GF(2) model)
- Overview table (comparison)
- Four basic routes
  - 1) Full brute force · `O(2^(n^2))`
  - 2) First-row brute force · `O(2^n·n^2)`
  - 3) Superposition method (global Gaussian elimination) · `O(n^6)`
  - 4) First-row superposition · `O(n^3)`
- Key recurrences in first-row superposition (B/L/Y)
- Optimized matrix generation (cross even-parity constraint)
- Number of solutions (silent patterns, at most `2^n`)
- First-row inversion + reverse elimination (O(n^2))
  - H: left-right diffusion matrix
  - K/F: diffusion basis matrix and decoupling matrix
  - f/c/g/q: core polynomials
  - Invertible case: `g=1`
  - Singular case: `g≠1`, D matrix and reverse elimination
- Structure and degree properties of g(x)
- Complexity and further optimization
- Solvability (reflexive + symmetric ⇒ always solvable)
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

### Overview table (comparison)

| Method | Core idea | Scale | Time complexity | Space complexity | Notes |
|---|---|---:|---:|---:|---|
| Full brute force | Enumerate all `n^2` button 0/1 patterns | `2^(n^2)` | `O(2^(n^2)·n^2)` | `O(n^2)` | most direct and also explodes fastest |
| First-row brute force | Enumerate only row 1; later rows are forced by press-down recursion | `2^n` | `O(2^n·n^2)` | `O(n^2)` | from row 2 onward the presses are determined by the previous row |
| Superposition (global elimination) | Do GF(2) Gaussian elimination on `[E / A]`, obtaining inverse / pseudoinverse / nullspace | `n^2×n^2` | `O(n^6)` | `O(n^4)` | the clearest way to see “silent patterns = multiple solutions” |
| **First-row superposition** | Express the last-row lights as a linear combination of first-row presses plus a flip vector; solve `n×n` | `n×n` | **`O(n^3)`** | **`O(n^2)`** | reduces the scale from `n^2` to `n` |
| **First-row inversion + reverse elimination** | Use polynomials, diffusion bases, Euclid, and structured back-substitution | n | **`O(n^2)`** | **`O(n)` workspace** | if the full output matrix is stored, total space is still `O(n^2)` |

---

## Four basic routes

### 1) Full brute force · `O(2^(n^2))`
- Enumerate every button vector `x` (length `n^2`), compute `l = A·x`, and check whether all lights are on.
- Examples:
  - `n=2`: `2^4=16`
  - `n=3`: `2^9=512`
  - `n=5`: `2^25=33,554,432`
  - `n=6`: `2^36=68,719,476,736`
- If the full board state is recomputed every time, there is an additional `O(n^2)` checking cost.

---

### 2) First-row brute force · `O(2^n·n^2)`
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

### 3) Superposition method (global Gaussian elimination) · `O(n^6)`
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

### 4) First-row superposition · `O(n^3)`
> Combine row-by-row propagation with linear superposition: express the last-row lights as “a linear combination of first-row presses plus a flip vector”, so only an `n×n` system must be solved.

1. Let the first-row press vector be `X` (length `n`).
2. Recursively express the last-row lights:
   - `L_last = M·X ⊕ Y_last`
   - `M` is an `n×n` matrix mapping “first-row presses → last-row lights”;
   - `Y_last` is the flip vector determined by the initial target.
3. For a target vector `T`, solve:
   - `M·X = T ⊕ Y_last`
4. Solve this `n×n` system over GF(2) to obtain `X`, then generate the full board by the standard row-by-row press-down recursion.

---

## Key recurrences in first-row superposition (B/L/Y)

### Notation
- `B(n,x)`: the button at row `n`, column `x` (0/1)
- `L(n,x)`: the light at row `n`, column `x` (0/1)
- `⊕`: XOR (superposition)
- `~`: NOT; over GF(2), `~a = a ⊕ 1`

### Basic relations
1. A light can be expressed as the XOR of the “up, left, center, right” buttons (the “down” button is handled by the next step):
   - `L(n,x)=B(n-1,x)⊕B(n,x-1)⊕B(n,x)⊕B(n,x+1)`
2. To fix the current light, the next-row press is the flipped current light:
   - `B(n+1,x)=~L(n,x)`
3. Using `~t=t⊕1`, the forced flip at each step can be extracted into a separate flip vector `Y`.

### Second-order recurrences
- Button recurrence:
  - `B(n,x)=B(n-1,x-1)⊕B(n-1,x)⊕B(n-1,x+1)⊕B(n-2,x)`
- Light recurrence (same form):
  - `L(n,x)=L(n-1,x-1)⊕L(n-1,x)⊕L(n-1,x+1)⊕L(n-2,x)`
- Flip-vector recurrence (the `~` must remain):
  - `Y(n,y)=~(Y(n-1,y-1)⊕Y(n-1,y)⊕Y(n-1,y+1)⊕Y(n-2,y))`

---

## Optimized matrix generation (cross even-parity constraint)

### Cross even-parity constraint
For the related button/light mapping matrices, the following relation holds:
- `B(x-1,y)⊕B(x+1,y)⊕B(x,y-1)⊕B(x,y+1)=0`

### Direct benefit
- Knowing **only the first row** of the matrix is enough to reconstruct all other rows:
  - `B(x,y)=B(x-1,y-1)⊕B(x-1,y+1)⊕B(x-2,y)`
- Therefore, when building `M`, it is not necessary to generate a full matrix for every column or every light:
  - compute the key first row;
  - fill the remaining rows by recurrence.
- The later `O(n^2)` algorithm uses the same idea: operate on first rows or a few rolling vectors whenever possible, rather than storing full matrices.

---

## Number of solutions (silent patterns, at most `2^n`)

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
- Polynomial form:
  - `f₀(x)=1`
  - `f₁(x)=x`
  - `fₙ(x)=x·fₙ₋₁(x)⊕fₙ₋₂(x)`
  - `cₙ(x)=fₙ(x+1)`
  - `gₙ(x)=gcd(fₙ(x),cₙ(x))=gcd(fₙ(x),fₙ(x+1))`
  - `r'=deg(gₙ)`
  - number of solutions `=2^{deg(gₙ)}`

---

## First-row inversion + reverse elimination (O(n^2))

> Goal: solve the first-row system `B X = Y` over GF(2). Here `B` is the `n×n` matrix from first-row superposition, and `Y` is the last row of the flip vector.

---

### 1) H: left-right diffusion matrix
- Definition:
  - `H(y,x)=1` iff `|x-y|=1`
- Action:
  - multiplying a vector by `H` is the same as left-right diffusion and XOR;
  - the `x`-th entry of `v*H` is `v(x-1)⊕v(x+1)`.

---

### 2) K/F: diffusion basis matrix and decoupling matrix
- `K` is the Krylov diffusion basis matrix:
  - `K(n)=H^n(0)`
  - `K(n,x)=K(n-1,x-1)⊕K(n-1,x+1)`
- `F` is the inverse of `K`:
  - `F=K^{-1}`
  - `F(y,x)=F(y-1,x-1)⊕F(y-2,x)`
- In the derivation, `b=Kp` and `p=Fb` can be used to express the matrix `B` as a polynomial applied to `H`.
- In the final implementation, `b`, the full `K`, and the full `F` do not need to remain in memory. They mainly explain why the matrix problem is equivalent to a polynomial problem.

---

### 3) f/c/g/q: core polynomials
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

### 4) Invertible case: `g=1`
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

### 5) Singular case: `g≠1`
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

### 6) Build D and use reverse elimination
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
  - after the XOR, `z[i]` is cleared and `X[i]` is marked as 1.
- To obtain all solutions:
  - the first `r'` rows are combinations of the last `r` rows;
  - before solving, any combination of the first `r'` rows may be XORed into `z`;
  - there are `2^{r'}` combinations, hence `2^{r'}` solutions.
- Symmetry:
  - `D[j,i]=D[i,j]`
  - therefore an equivalent elimination can also be done from right to left.

---

## Structure and degree properties of g(x)

### Basic formulas
- Let:
  - `gₙ(x)=gcd(fₙ(x),fₙ(x+1))`
  - `sₘ(x)=fₘ(x)⊕fₘ₋₁(x)`
  - `hₘ(x)=gcd(sₘ(x),sₘ(x+1))`
- Then:
  - `g₂ₘ(x)=hₘ(x)^2`
  - `g₂ₘ₊₁(x)=gₘ(x)^2`, when `m mod 3 ≠ 2`
  - `g₂ₘ₊₁(x)=(x^2+x)·gₘ(x)^2`, when `m mod 3 = 2`

### Degree formulas
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

### On recursively generating g(x)
- Smaller `gₙ` values alone are not enough to recursively generate larger `gₙ` values in a closed way.
- Reasons:
  - the odd branch also needs `m mod 3`;
  - the even branch needs the additional family `hₘ`.
- Therefore, a more reasonable direction is to maintain both families `gₙ` and `hₙ`, forming a 2-regular / binary-automaton-like recurrence system.
- If the goal is only to output all coefficients of `gₙ`, the output itself already has a lower bound of `Ω(n)`. If such a recurrence system closes, the theoretical target is linear output complexity `O(n)`.

---

## Complexity and further optimization

### Current main line
The current solver can be summarized as follows:

1. Recursively compute the objects for the current `n`:
   - `f(x)`: modulus / characteristic polynomial;
   - `c(x)=f(x+1)`;
   - `Y`: the right-hand flip vector.
2. Use extended Euclid to compute:
   - `s(x)f(x)⊕q(x)c(x)=g(x)`
3. Compute:
   - `z=q(H)Y`
4. If `g=1`:
   - `X=z`
5. If `g≠1`:
   - build or rolling-generate `D=g(H)`;
   - solve `D X=z` by reverse elimination.
6. Generate the full button matrix from the first-row solution `X`.

---

### Time complexity
- If the full `n×n` button matrix must be output, the output itself contains `n^2` cells:
  - therefore the total time complexity cannot be asymptotically below `Ω(n^2)`.
- The current full-solution main line can achieve:
  - `O(n^2)` time.
- Parts where `O(n log n)` or `O(n log^2 n)` may still be meaningful:
  1. only computing the first-row solution;
  2. only deciding solvability / computing the solution-space dimension;
  3. speeding up internal polynomial operations, while the final full-board output still returns to `O(n^2)`.

---

### Space complexity
- Full matrices do not all need to be stored.
- The following can be removed or rolling-computed:
  - `p`: since `p(H)=c(H)`, use `c` directly;
  - `b`: it is only used to compute `p`, and is no longer on the main chain;
  - `K`: `d0=K*g` can be replaced by `d0=g(H)e0`;
  - `f/c/Y/t/D`: when they only depend on a fixed number of previous rows, they can be rolling-computed.
- If the final result `t` is streamed out rather than kept in memory, the workspace can be:
  - `O(n)`
- If the full button matrix `t` is still stored, total space remains:
  - `O(n^2)`

---

### Main hotspots for further optimization
1. **Extended Euclid**
   - a normal implementation costs `O(n^2)`;
   - half-gcd / divide-and-conquer extgcd can be considered;
   - if polynomial multiplication costs `M(n)`, the theoretical bound can become `O(M(n)log n)`;
   - with FFT-style multiplication, this can approach `O(n log^2 n)`.
2. **`ApplyPoly(a,v)=a(H)v`**
   - this unifies `z=q(H)Y` and `d0=g(H)e0`;
   - if the current diffusion vector becomes 0, all later vectors remain 0, so the loop can stop early;
   - further work may use convolution / fast polynomial action.
3. **Singular-branch back-substitution**
   - `D=g(H)` is a banded matrix with bandwidth at most `deg(g)`;
   - during back-substitution, only scan the effective interval `[max(0,i-r), min(n-1,i+r)]`;
   - the singular branch can be improved from full-row scans to `O(nr)`, where `r=deg(g)` or the corresponding bandwidth parameter;
   - the worst case is still `O(n^2)`, but many sizes become faster.
4. **Unified quotient-ring method**
   - a deeper refactor can unify the invertible and singular branches in a quotient-ring framework;
   - this may remove the explicit `D=g(H)` construction and reverse superposition entirely;
   - this is a larger mathematical rewrite and is best attempted after the current `O(n^2)` main line is stable.

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

### Graph-theoretic proof idea
- View the game as an undirected graph with self-loops:
  - vertices = buttons/lights;
  - edges = toggle relations;
  - self-loops = reflexivity;
  - undirected edges = symmetry.
- Assume there is a smallest unsolvable graph.
- Removing any vertex gives a smaller solvable graph, so one can construct operations that toggle every vertex except one.
- XORing these operations and using parity plus the handshake lemma leads to a contradiction.
- Therefore no smallest unsolvable graph exists, and the game is always solvable.

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

