program GaussElimGF2;

{$APPTYPE CONSOLE}

const
  N = 25;
  inputData: array[1..N] of string = (
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
  A, E: array[1..N,1..N] of Integer;
  i, j, k, swapRow: Integer;
  found: Boolean;

begin
  { 1. 初始化 A 矩阵和 E 矩阵 }
  for i := 1 to N do
  begin
    for j := 1 to N do
    begin
      { 将 '0'/'1' 转为 整数 0/1 }
      A[i,j] := Ord(inputData[i][j]) - Ord('0');
    end;
  end;

  { E 设为单位阵 }
  for i := 1 to N do
    for j := 1 to N do
      if i = j then
        E[i,j] := 1
      else
        E[i,j] := 0;

  { 2. 高斯消元 }
  for i := 1 to N do
  begin
    { 若 A[i,i] = 0，则尝试与下面某行交换 }
    if A[i,i] = 0 then
    begin
      found := False;
      for swapRow := i+1 to N do
      begin
        if A[swapRow,i] = 1 then
        begin
          { 交换 A[i] 和 A[swapRow] 行 }
          for k := 1 to N do
          begin
            A[i,k] := A[i,k] xor A[swapRow,k];
            A[swapRow,k] := A[i,k] xor A[swapRow,k];
            A[i,k] := A[i,k] xor A[swapRow,k];
            { E 同步交换 }
            E[i,k] := E[i,k] xor E[swapRow,k];
            E[swapRow,k] := E[i,k] xor E[swapRow,k];
            E[i,k] := E[i,k] xor E[swapRow,k];
          end;
          found := True;
          Break;
        end;
      end;
      { 若仍未找到可以交换的行，则该列主元无法置 1，继续下一列 }
      if not found then
        Continue;
    end;

    { 此时 A[i,i] 一定是 1（除非无法交换），消去其他行 }
    for j := 1 to N do
    begin
      if (j <> i) and (A[j,i] = 1) then
      begin
        { 行 j = 行 j XOR 行 i (A 和 E 同步) }
        for k := 1 to N do
        begin
          A[j,k] := A[j,k] xor A[i,k];
          E[j,k] := E[j,k] xor E[i,k];
        end;
      end;
    end;
  end;

  { 3. 输出结果：此时若 A=I，则 E 就是 A 的逆，否则只得到部分伪逆 }
  Writeln('Matrix E (possible inverse/partial-inverse):');
  for i := 1 to N do
  begin
    for j := 1 to N do
      Write(E[i,j]);
    Writeln;
  end;

  Readln;  { 暂停显示窗口，可根据需要移除 }
end.
