//{$define disp}
program diandeng;

{$ifdef disp}
uses display;
{$endif}

const m=1000;

type TMat=array[-1..m,-1..m]of Boolean;

var n:longword;
var l,r,t:TMat;
var i,j,k:longint;

{$ifdef disp}
var bb:pbitbuf;
var s:longword=0;
var b:pbitmap;
{$endif}

procedure PrintMat(mat:TMat);
var i,j:longint;
begin
writeln();
for j:=0 to n-1 do
  begin
  if mat[j,-1] then write('#') else write('.');write(' ');
  for i:=0 to n-1 do
    if mat[j,i] then write('#') else write('.');
  writeln();
  end;
writeln();
end;

{$ifdef disp}
procedure DrawMat(mat:TMat);
begin
while IsNextMsg() do ;
for j:=0 to n-1 do
  for i:=0 to n-1 do
    if mat[j,i] then SetBBPixel(bb,i,j,black) else SetBBPixel(bb,i,j,white);
SetBB(bb);
FreshWin();
end;

procedure PrintMat(s:ansistring;mat:TMAT);
begin
DrawMat(mat);
b:=CreateBMP(n,n);
DrawBMP(_pmain,b,0,0,n,n,0,0,n,n);
SaveBMP(b,'png'+s+'/'+i2s(n)+'.png');
ReleaseBMP(b);
end;
{$endif}

procedure MakeMat();
begin
for i:=0 to n-1 do l[0,i]:=False;
l[-1,0]:=False;
for j:=1 to n do
  for i:=0 to n-1 do
    begin
    l[j,i]:=not(l[j-1,i-1] xor l[j-1,i] xor l[j-1,i+1] xor l[j-2,i]);
    l[j,i]:=l[j,i];
    end;
for i:=0 to n-1 do l[-1,i]:=False;
l[-1,0]:=True;
for j:=0 to n-1 do
  for i:=0 to n-1 do
    begin
    l[j,i]:=(l[j-1,i-1] xor l[j-1,i] xor l[j-1,i+1]);
    if j>0 then l[j,i]:=l[j,i] xor l[j-2,i];
    end;
for i:=0 to n-1 do l[0,i]:=l[n-1,i];
for j:=1 to n-1 do
  for i:=0 to n-1 do
    begin
    l[j,i]:=(l[j-1,i-1] xor l[j-1,i+1]);
    if j>1 then l[j,i]:=l[j,i] xor l[j-2,i];
    end;
for i:=0 to n-1 do begin l[i,-1]:=l[n,i];l[n,i]:=False;end;
for i:=0 to n-1 do for j:=0 to n-1 do r[i,j]:=(i=j);
end;

procedure CalcMat();
var j0:longint;
begin
//writeln();
for k:=0 to n-1 do
  begin
  j0:=-1;
  for j:=n-1 downto k do
    if l[j,k] then j0:=j;
  j:=j0;
  if j>=0 then
    begin
    if j<>k then
      begin
      for i:=-1 to n-1 do
        begin
        l[j,i]:=l[j,i] xor l[k,i];
        l[k,i]:=l[j,i] xor l[k,i];
        l[j,i]:=l[j,i] xor l[k,i];
        r[j,i]:=r[j,i] xor r[k,i];
        r[k,i]:=r[j,i] xor r[k,i];
        r[j,i]:=r[j,i] xor r[k,i];
        end;
//writeln('swap ',j+1,' ',k+1);PrintMat(r);PrintMat(l);
      end;
    for j:=k+1 to n-1 do
      if l[j,k] then
        begin
        for i:=0 to n-1 do //for a-1
          begin
          l[j,i]:=l[j,i] xor l[k,i];
          r[j,i]:=r[j,i] xor r[k,i];
          end;
        l[j,-1]:=l[j,-1] xor l[k,-1];
        r[j,-1]:=r[j,-1] xor r[k,-1];
//writeln('xor1 ',k+1,' ',j+1);PrintMat(r);PrintMat(l);
        end;
    end;
  end;
for i:=n-1 downto 0 do
  if l[i,i] then
    for j:=i-1 downto 0 do
      if l[j,i] then
        begin
        for k:=0 to n-1 do // for a-1
          begin
          l[j,k]:=l[j,k] xor l[i,k];
          r[j,k]:=r[j,k] xor r[i,k];
          end;
        l[j,-1]:=l[j,-1] xor l[i,-1];
        r[j,-1]:=r[j,-1] xor r[i,-1];
//writeln('xor2 ',i+1,' ',j+1);PrintMat(r);PrintMat(l);
        end;
end;

const
  BLOCK_THRESHOLD = 32; // 小块回退阈值，调参可以�?16/64 之类

type
  TBoolRow = array of Boolean;
  TBoolMat = array of TBoolRow;

procedure SwapRows(var mat: TMat; row1, row2, colStart, colEnd: Integer);
var
  i: Integer;
  tmp: Boolean;
begin
  if row1 = row2 then Exit;
  for i := colStart to colEnd do
  begin
    tmp := mat[row1, i];
    mat[row1, i] := mat[row2, i];
    mat[row2, i] := tmp;
  end;
end;

procedure XORRow(var mat: TMat; destRow, srcRow, colStart, colEnd: Integer);
var
  i: Integer;
begin
  for i := colStart to colEnd do
    mat[destRow, i] := mat[destRow, i] xor mat[srcRow, i];
end;

// 基本 Gauss-Jordan 在子块上（完�?rref�?
// 只处�?A �?[rowStart..rowStart+sz-1]×[colStart..colStart+sz-1] 区域�?
// 但行操作作用于整行（包括 r），保持与全局一�?
procedure StandardGaussJordanSubmatrix(var A, R: TMat; rowStart, colStart, sz: Integer);
var
  row, col, pivot, ridx: Integer;
begin
  row := rowStart;
  for col := colStart to colStart + sz - 1 do
  begin
    // �?pivot：从 row 向下找第一�?A[*,col]=1
    pivot := -1;
    for ridx := row to rowStart + sz - 1 do
      if A[ridx, col] then
      begin
        pivot := ridx;
        Break;
      end;
    if pivot = -1 then Continue; // 没有 pivot，跳�?

    // 交换到当前行
    if pivot <> row then
    begin
      SwapRows(A, pivot, row, colStart, colStart + sz - 1);
      SwapRows(R, pivot, row, 0, colStart + sz - 1); // R 是全行范�?
    end;

    // 清除同一列其他行
for ridx := 0 to n-1 do
  if (ridx <> row) and A[ridx, col] then
  begin
    XORRow(A, ridx, row, 0, n-1);
    XORRow(R, ridx, row, 0, n-1);
  end;

    Inc(row);
    if row > rowStart + sz - 1 then Break;
  end;
end;

// 计算 C := A * B over GF(2)，只处理给定子块，结果写�?Cblock（假设已经是清空/适当大小�?
// A: rows a_r..a_r+as-1, cols a_c..
// B: rows b_r.., cols b_c..
// Cblock 所在位置由 caller 安排（这里只返回局�?product�?
procedure GF2MultiplyBlock(var A: TMat; a_r, a_c: Integer; var B: TMat; b_r, b_c: Integer;
  sizeA_row, size_common, sizeB_col: Integer; var C: TBoolMat);
var
  i, j, k: Integer;
begin

  // 分配 C 大小
  SetLength(C, sizeA_row);
  for i := 0 to sizeA_row - 1 do
    SetLength(C[i], sizeB_col);

  // 初始化为 0
  for i := 0 to sizeA_row - 1 do
    for j := 0 to sizeB_col - 1 do
      C[i][j] := False;

  for i := 0 to sizeA_row - 1 do
    for k := 0 to size_common - 1 do
      if A[a_r + i, a_c + k] then
        for j := 0 to sizeB_col - 1 do
          C[i][j] := C[i][j] xor B[b_r + k, b_c + j];
end;

// 递归处理 rref（分�?Schur 补）
// 只在 A �?[r0..r0+sz-1]×[c0..c0+sz-1] 区域中实现局�?rref�?
// 所有行变换同步作用�?R（即你的 r 矩阵�?
procedure RecursiveRREFSubmatrix(var A, R: TMat; r0, c0, sz: Integer);
var
  mid, sz1, sz2: Integer;
  i, j, pivotRow, rr, cc: Integer;
  // 临时用于 Schur �?
  temp: array of array of Boolean;
  Sblock: array of array of Boolean;
  A21: array of array of Boolean;
  A12: array of array of Boolean;
  A22: array of array of Boolean;
  pivotRows1: array of Integer;
  pivotCols1: array of Integer;
  pivotRows2: array of Integer;
  pivotCols2: array of Integer;
  cnt1, cnt2: Integer;
begin
  if sz <= BLOCK_THRESHOLD then
  begin
    StandardGaussJordanSubmatrix(A, R, r0, c0, sz);
    Exit;
  end;

  mid := sz div 2;
  sz1 := mid;
  sz2 := sz - mid;
SetLength(pivotRows1, sz1);
SetLength(pivotCols1, sz1);
SetLength(pivotRows2, sz2);
SetLength(pivotCols2, sz2);
cnt1 := 0; cnt2 := 0;

  // 1. 处理左上 A11
  RecursiveRREFSubmatrix(A, R, r0, c0, sz1);

  // 2. 找出 A11 �?pivot 结构（与标准 rref 一致）
  cnt1 := 0;
  rr := r0;
  for cc := c0 to c0 + sz1 - 1 do
  begin
    pivotRow := -1;
    for i := rr to r0 + sz1 - 1 do
      if A[i, cc] then
      begin
        pivotRow := i;
        Break;
      end;
    if pivotRow = -1 then Continue;
    pivotRows1[cnt1] := pivotRow;
    pivotCols1[cnt1] := cc;
    Inc(cnt1);
    Inc(rr);
    if rr > r0 + sz1 - 1 then Break;
  end;

  // 3. �?A11 �?pivot 清除 A21（下半块左侧）对应列
  for i := 0 to cnt1 - 1 do
  begin
    for j := r0 + sz1 to r0 + sz - 1 do
      if A[j, pivotCols1[i]] then
      begin
        XORRow(A, j, pivotRows1[i], c0, c0 + sz - 1);
        XORRow(R, j, pivotRows1[i], 0, c0 + sz - 1);
      end;
  end;

  // 4. 构�?Schur �?S = A22 + A21 * A12
  // 分配临时数组尺寸
  SetLength(temp, sz2);
  SetLength(Sblock, sz2);
  SetLength(A21, sz2);
  SetLength(A12, sz1);
  SetLength(A22, sz2);
  for i := 0 to sz2 - 1 do
  begin
    SetLength(temp[i], sz2);
    SetLength(Sblock[i], sz2);
    SetLength(A21[i], sz1);
    SetLength(A22[i], sz2);
  end;
  for i := 0 to sz1 - 1 do
    SetLength(A12[i], sz2);

  // 提取 A21, A12, A22 子块
  for i := 0 to sz2 - 1 do
    for j := 0 to sz1 - 1 do
      A21[i][j] := A[r0 + sz1 + i, c0 + j];
  for i := 0 to sz1 - 1 do
    for j := 0 to sz2 - 1 do
      A12[i][j] := A[r0 + i, c0 + sz1 + j];
  for i := 0 to sz2 - 1 do
    for j := 0 to sz2 - 1 do
      A22[i][j] := A[r0 + sz1 + i, c0 + sz1 + j];

  // temp := A21 * A12
  GF2MultiplyBlock(A, r0 + sz1, c0, A, r0, c0 + sz1, sz2, sz1, sz2, temp);

  // Sblock := A22 xor temp
  for i := 0 to sz2 - 1 do
    for j := 0 to sz2 - 1 do
      Sblock[i][j] := A22[i][j] xor temp[i][j];

  // 写回 Sblock �?A22 位置
  for i := 0 to sz2 - 1 do
    for j := 0 to sz2 - 1 do
      A[r0 + sz1 + i, c0 + sz1 + j] := Sblock[i][j];

  // 5. 递归处理右下 Schur 补（�?A22�?
  RecursiveRREFSubmatrix(A, R, r0 + sz1, c0 + sz1, sz2);

  // 6. �?A22 �?pivot 清除上方 A12 中对应列
  cnt2 := 0;
  rr := r0 + sz1;
  for cc := c0 + sz1 to c0 + sz1 + sz2 - 1 do
  begin
    pivotRow := -1;
    for i := rr to r0 + sz1 + sz2 - 1 do
      if A[i, cc] then
      begin
        pivotRow := i;
        Break;
      end;
    if pivotRow = -1 then Continue;
    pivotRows2[cnt2] := pivotRow;
    pivotCols2[cnt2] := cc;
    Inc(cnt2);
    Inc(rr);
    if rr > r0 + sz1 + sz2 - 1 then Break;
  end;

  for i := 0 to cnt2 - 1 do
    for j := r0 to r0 + sz1 - 1 do
      if A[j, pivotCols2[i]] then
      begin
        XORRow(A, j, pivotRows2[i], c0, c0 + sz - 1);
        XORRow(R, j, pivotRows2[i], 0, c0 + sz - 1);
      end;

  // 7. 完整清理该大块，确保 canonical rref（上/下都清除�?
  StandardGaussJordanSubmatrix(A, R, r0, c0, sz);
end;

// 替代�?CalcMat 的入口，处理整个 0..n-1 范围
procedure CalcMat2(); // 替换原来的实�?
begin
  // 递归�?rref，l 变为 E，r 变为 P（行变换�?
  RecursiveRREFSubmatrix(l, r, 0, 0, n);
end;

procedure GeneMat();
begin
{
for i:=0 to n-1 do
  begin
  t[0,i]:=l[i,-1];
  l[i,-1]:=false;
  end;
}
//printmat(l);printmat(r);printmat(t);
for j:=0 to n-1 do
  begin
  t[0,j]:=false;
  for i:=0 to n-1 do
    begin
    t[0,j]:=t[0,j] xor (l[i,-1] and r[j,i]);
//    writeln(j,' ',i,' ',t[0,j]:6,' ',l[i,-1]:6,' ',r[j,i]:6,' ',l[i,-1] and r[j,i]:6);
    end;
  end;
for i:=0 to n-1 do
  l[i,-1]:=false;
//printmat(l);printmat(r);printmat(t);
for j:=1 to n-1 do
  for i:=0 to n-1 do
    t[j,i]:=not(t[j-1,i-1] xor t[j-1,i] xor t[j-1,i+1] xor t[j-2,i]);
end;

begin
{$ifdef disp}
CreateWin(m,m);
bb:=CreateBB(GetWin());
b:=CreateBMP(m,m);
{$endif}
for n:=1 to m do
  begin
  write(n,#9);
  write('m');MakeMat();{$ifdef disp}write('%');PrintMat('_A',l);{$endif}
  write('c');CalcMat2();{$ifdef disp}write('%');PrintMat('_E',l);write('%');PrintMat('_R',r);{$endif}
  write('g');GeneMat();{$ifdef disp}write('%');PrintMat('_T',t);{$endif}
  {$ifdef disp}write(#9,s,#9,n*n,#9,s/n/n:0:5);{$endif}
  {$ifdef disp}if not(iswin()) then halt;{$endif}
  writeln();
  end;
end.
