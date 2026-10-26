program BlockGaussWithStrassen;

{$APPTYPE CONSOLE}

(*
  演示:
  1) 25×25 不可逆矩阵补至 32×32
  2) 用块状(以8×8为例)做"对角块行消元" + "Strassen 做块更新"
  3) 由于秩<25, 最终只能得到伪逆
  4) 不在 for 循环里修改循环变量, 而用 while/自增方式
*)

const
  N = 32;        // 补足到 2^5 = 32
  BLOCK_SIZE = 8;// 2^3=8, 方便做Strassen
  RealSize = 25;

type
  TMatrix = array[0..N-1,0..N-1] of Byte;

const
  inputData25: array[1..25] of string = (
    '1100010000000000000000000',
    '1110001000000000000000000',
    '0111000100000000000000000',
    '0011100010000000000000000',
    '0001100001000000000000000',
    '1000011000100000000000000',
    '0100011100010000000000000',
    '0010001110001000000000000',
    '0001000111000100000000000',
    '0000100011000010000000000',
    '0000010000110001000000000',
    '0000001000111000100000000',
    '0000000100011100010000000',
    '0000000010001110001000000',
    '0000000001000110000100000',
    '0000000000100001100010000',
    '0000000000010001110001000',
    '0000000000001000111000100',
    '0000000000000100011100010',
    '0000000000000010001100001',
    '0000000000000001000011000',
    '0000000000000000100011100',
    '0000000000000000010001110',
    '0000000000000000001000111',
    '0000000000000000000100011'
  );

var
  A, E: TMatrix;

//=================================================================
// 基础工具
//=================================================================
procedure MatrixZero(var M: TMatrix);
var i,j: Integer;
begin
  for i := 0 to N-1 do
    for j := 0 to N-1 do
      M[i,j] := 0;
end;

procedure MatrixIdentity(var M: TMatrix);
var i,j: Integer;
begin
  for i := 0 to N-1 do
    for j := 0 to N-1 do
      if i=j then M[i,j] := 1 else M[i,j] := 0;
end;

//=================================================================
// Strassen 乘法 (GF(2)): 加法= XOR, 乘法= AND
//=================================================================
procedure StrassenMultiply(const A,B: TMatrix; var C: TMatrix; dim: Integer);
var
  half: Integer;

  A11,A12,A21,A22,
  B11,B12,B21,B22,
  C11,C12,C21,C22,
  M1,M2,M3,M4,M5,M6,M7,
  t1,t2: TMatrix;

  procedure MatZero(var X: TMatrix);
  var i,j: Integer;
  begin
    for i:=0 to N-1 do
      for j:=0 to N-1 do
        X[i,j] := 0;
  end;

  procedure MatrixSplit(const M:TMatrix; var M11,M12,M21,M22:TMatrix; d:Integer; r0,c0:Integer);
  var i,j,hd: Integer;
  begin
    hd := d div 2;
    for i:=0 to hd-1 do
      for j:=0 to hd-1 do
      begin
        M11[i,j] := M[r0+i, c0+j];
        M12[i,j] := M[r0+i, c0+j+hd];
        M21[i,j] := M[r0+i+hd, c0+j];
        M22[i,j] := M[r0+i+hd, c0+j+hd];
      end;
  end;

  procedure MatrixCombine(var M:TMatrix; const M11,M12,M21,M22:TMatrix; d:Integer; r0,c0:Integer);
  var i,j,hd: Integer;
  begin
    hd := d div 2;
    for i:=0 to hd-1 do
      for j:=0 to hd-1 do
      begin
        M[r0+i, c0+j]         := M11[i,j];
        M[r0+i, c0+j+hd]      := M12[i,j];
        M[r0+ i + hd, c0+ j]  := M21[i,j];
        M[r0+ i + hd, c0+ j+hd] := M22[i,j];
      end;
  end;

  procedure MatrixXor(const X,Y: TMatrix; var Z: TMatrix; dd:Integer);
  var i,j: Integer;
  begin
    for i:=0 to dd-1 do
      for j:=0 to dd-1 do
        Z[i,j] := X[i,j] xor Y[i,j];
  end;

begin
  if dim=1 then
  begin
    C[0,0] := A[0,0] and B[0,0];
    Exit;
  end;

  half := dim div 2;
  MatZero(A11);MatZero(A12);MatZero(A21);MatZero(A22);
  MatZero(B11);MatZero(B12);MatZero(B21);MatZero(B22);
  MatZero(C11);MatZero(C12);MatZero(C21);MatZero(C22);
  MatZero(M1); MatZero(M2); MatZero(M3); MatZero(M4);
  MatZero(M5); MatZero(M6); MatZero(M7);
  MatZero(t1); MatZero(t2);

  MatrixSplit(A, A11,A12,A21,A22, dim, 0,0);
  MatrixSplit(B, B11,B12,B21,B22, dim, 0,0);

  // M1 = (A11 XOR A22)*(B11 XOR B22)
  MatrixXor(A11,A22,t1,half);
  MatrixXor(B11,B22,t2,half);
  StrassenMultiply(t1,t2,M1,half);

  // M2 = (A21 XOR A22)*B11
  MatrixXor(A21,A22,t1,half);
  StrassenMultiply(t1,B11,M2,half);

  // M3 = A11*(B12 XOR B22)
  MatrixXor(B12,B22,t1,half);
  StrassenMultiply(A11,t1,M3,half);

  // M4 = A22*(B21 XOR B11)
  MatrixXor(B21,B11,t1,half);
  StrassenMultiply(A22,t1,M4,half);

  // M5 = (A11 XOR A12)*B22
  MatrixXor(A11,A12,t1,half);
  StrassenMultiply(t1,B22,M5,half);

  // M6 = (A21 XOR A11)*B11
  MatrixXor(A21,A11,t1,half);
  StrassenMultiply(t1,B11,M6,half);

  // M7 = A12*(B21 XOR B11)
  MatrixXor(B21,B11,t1,half);
  StrassenMultiply(A12,t1,M7,half);

  // C11 = M1 XOR M4 XOR M5 XOR M7
  MatrixXor(M1,M4,t1,half);
  MatrixXor(M5,M7,t2,half);
  MatrixXor(t1,t2,C11,half);

  // C12 = M3 XOR M5
  MatrixXor(M3,M5,C12,half);

  // C21 = M2 XOR M4
  MatrixXor(M2,M4,C21,half);

  // C22 = M1 XOR M2 XOR M3 XOR M6
  MatrixXor(M1,M2,t1,half);
  MatrixXor(M3,M6,t2,half);
  MatrixXor(t1,t2,C22,half);

  MatrixCombine(C, C11,C12,C21,C22, dim, 0,0);
end;

//=================================================================
// 在对角块上做行消元 (用 while 控制行、列)
//=================================================================
procedure EliminateDiagonalBlock(var A,E: TMatrix; blockIndex: Integer);
var
  startRC, i, j, pivotRow, k: Integer;
  found: Boolean;
begin
  startRC := blockIndex * BLOCK_SIZE;  // 0, 8, 16, 24 ...
  // 在该对角块内逐行逐列做行消元
  i := 0;
  j := 0;
  while (i < BLOCK_SIZE) and (j < BLOCK_SIZE) do
  begin
    // 全局行列 => startRC+i, startRC+j
    if A[startRC+i, startRC+j] = 0 then
    begin
      found := False;
      for pivotRow := (startRC + i + 1) to (startRC + BLOCK_SIZE - 1) do
      begin
        if (pivotRow < N) and (A[pivotRow, startRC+j] = 1) then
        begin
          // 交换 pivotRow 与 startRC+i
          for k := 0 to N-1 do
          begin
            A[startRC+i,k] := A[startRC+i,k] xor A[pivotRow,k];
            A[pivotRow,k] := A[startRC+i,k] xor A[pivotRow,k];
            A[startRC+i,k] := A[startRC+i,k] xor A[pivotRow,k];

            E[startRC+i,k] := E[startRC+i,k] xor E[pivotRow,k];
            E[pivotRow,k] := E[startRC+i,k] xor E[pivotRow,k];
            E[startRC+i,k] := E[startRC+i,k] xor E[pivotRow,k];
          end;
          found := True;
          Break;
        end;
      end;
      if not found then
      begin
        Inc(j);
        Continue;
      end;
    end;

    // 此时 A[startRC+i, startRC+j] = 1
    // 对其它行消元(全局)
    // pivotRow = 0..N-1, pivotRow != startRC+i, 若 A[pivotRow, startRC+j]=1则 XOR
    for pivotRow := 0 to N-1 do
    begin
      if (pivotRow <> (startRC+i)) and (A[pivotRow, startRC+j] = 1) then
      begin
        for k := 0 to N-1 do
        begin
          A[pivotRow,k] := A[pivotRow,k] xor A[startRC+i,k];
          E[pivotRow,k] := E[pivotRow,k] xor E[startRC+i,k];
        end;
      end;
    end;
    Inc(i);
    Inc(j);
  end;
end;

//=================================================================
// 用 Strassen 做块级更新 (示例: 更新"下方块")
//=================================================================
procedure UpdateBelowBlock(var A,E: TMatrix; diagBlockIndex: Integer);
var
  pivotStart, belowStart: Integer;
  pivotMat, belowMat, resultMat: TMatrix;
  i,j: Integer;
begin
  pivotStart := diagBlockIndex * BLOCK_SIZE;
  belowStart := (diagBlockIndex + 1) * BLOCK_SIZE;
  if belowStart >= N then Exit; // 已经没有下方块可更新

  // [示例] 先把 pivotBlock(对角块) & belowBlock 拷到临时矩阵, 做 StrassenMultiply
  // pivotBlock => A[pivotStart..pivotStart+BS-1, pivotStart..pivotStart+BS-1]
  // belowBlock => A[belowStart..belowStart+BS-1, pivotStart..pivotStart+BS-1]
  // 这里演示: resultMat = pivotBlock * belowBlock (GF(2))

  // 1) 清零
  for i := 0 to N-1 do
    for j := 0 to N-1 do
    begin
      pivotMat[i,j] := 0;
      belowMat[i,j] := 0;
      resultMat[i,j] := 0;
    end;

  // 2) 拷贝 pivotBlock
  for i := 0 to BLOCK_SIZE-1 do
    for j := 0 to BLOCK_SIZE-1 do
    begin
      pivotMat[i,j] := A[pivotStart+i, pivotStart+j];
      belowMat[i,j] := A[belowStart+i, pivotStart+j];
    end;

  // 3) StrassenMultiply
  StrassenMultiply(pivotMat, belowMat, resultMat, BLOCK_SIZE);

  // 4) XOR 回去 (演示)
  // 例如: A[belowStart.., pivotStart..] = A[...] XOR resultMat
  for i := 0 to BLOCK_SIZE-1 do
    for j := 0 to BLOCK_SIZE-1 do
    begin
      A[belowStart+i, pivotStart+j] := A[belowStart+i, pivotStart+j] xor resultMat[i,j];
      // 同理, 如果你也想更新 E, 可以做相同处理
    end;
end;

//=================================================================
// 块状高斯消元
//=================================================================
procedure BlockGaussElimStrassen(var A,E: TMatrix);
var
  blockCount, b: Integer;
begin
  blockCount := N div BLOCK_SIZE; // 32/8=4
  // 依次处理对角块
  b := 0;
  while b < blockCount do
  begin
    // 1) 对角块行消元
    EliminateDiagonalBlock(A, E, b);

    // 2) 用 Strassen 对下方块更新 (仅示例下方, 也可更新右侧/右下角)
    UpdateBelowBlock(A, E, b);

    Inc(b);
  end;
end;

//=================================================================
// 主程序
//=================================================================
var
  r,c: Integer;
begin
  // 1) 初始化 A (32x32)
  MatrixZero(A);
  for r := 0 to RealSize-1 do
    for c := 0 to RealSize-1 do
      if inputData25[r+1][c+1] = '1' then
        A[r,c] := 1
      else
        A[r,c] := 0;

  // 2) 初始化 E
  MatrixZero(E);
  MatrixIdentity(E);

  // 3) 块状高斯消元
  BlockGaussElimStrassen(A, E);

  // 4) 输出 E 的左上 25×25
  Writeln('Pseudo-inverse (top-left 25x25):');
  for r := 0 to RealSize-1 do
  begin
    for c := 0 to RealSize-1 do
      Write(E[r,c]);
    Writeln;
  end;

  Readln;
end.
