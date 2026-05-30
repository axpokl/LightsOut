program diandeng;
uses display;

const m=1000;
var n:longword;
var l,l0,l1:array[-1..m,-2..m]of boolean;
var i,j,k:longint;

procedure PrintMat();
var i,j:longint;
begin
writeln();
for j:=0 to n-1 do
  begin
  if l[j,-1] then write('#') else write(' ');
  for i:=0 to n-1 do
    if l[j,i] then write('#') else write(' ');
  writeln();
  end;
end;

procedure InitMat();
begin
for j:=0 to n-1 do
  begin
  for i:=-1 to n-1 do
    begin
    l[j,i]:=false;
    l0[j,i]:=false;
    l1[j,i]:=false;
    end;
  end;
for j:=0 to n-1 do
  l[j,j]:=true;
end;

procedure MakeMat();
begin
for k:=0 to n-1 do
begin
  for i:=-1 to n-1 do
    begin
    for j:=0 to n-1 do
      begin
      l1[j,i]:=l[j-1,i] xor l[j,i] xor l[j+1,i] xor l0[j,i];
      if j=0 then l1[j,i]:=l1[j,i] xor l[n-1,i];
      if j=n-1 then l1[j,i]:=l1[j,i] xor l[0,i];
      if i=-1 then l1[j,i]:=not(l1[j,i]);
      end;
    for j:=0 to n-1 do
      begin
      l0[j,i]:=l[j,i];
      l[j,i]:=l1[j,i];
      end;
    end;
end;
for i:=0 to n-1 do
  l[i,i]:=not(l[i,i]);
end;

procedure CalcMat();
var j0:longint;
begin
for k:=0 to n-1 do
  begin
  j0:=-1;
  for j:=n-1 downto k do
    if l[j,k]=true then j0:=j;
  j:=j0;
  if j>=0 then
    begin
    if j<>k then
      for i:=-1 to n-1 do
        begin
        l[j,i]:=l[j,i] xor l[k,i];
        l[k,i]:=l[j,i] xor l[k,i];
        l[j,i]:=l[j,i] xor l[k,i];
        end;
    for j:=k+1 to n-1 do
      if l[j,k]=true then
        begin
        for i:=k to n-1 do
          l[j,i]:=l[j,i] xor l[k,i];
        l[j,-1]:=l[j,-1] xor l[k,-1];
        end;
    end;
  end;
for i:=n-1 downto 0 do
  if l[i,i]=true then
    for j:=i-1 downto 0 do
      if l[j,i]=true then
        begin
        l[j,i]:=false;
        l[j,-1]:=l[j,-1] xor l[i,-1];
        end;
end;

procedure GeneMat();
begin
for i:=0 to n-1 do
  begin
  l[0,i]:=l[i,-1];
  l[i,-1]:=false;
  end;
for j:=1 to n-1 do
  for i:=0 to n-1 do
    begin
    l[j,i]:=l[j-1,i-1] xor l[j-1,i] xor l[j-1,i+1] xor l[j-2,i];
    if i=0 then l[j,i]:=l[j,i] xor l[j-1,n-1];
    if i=n-1 then l[j,i]:=l[j,i] xor l[j-1,0];
    if j=1 then l[j,i]:=l[j,i] xor l[n-1,i];
    l[j,i]:=not(l[j,i]);
    end;
end;

begin
for n:=1 to 10 do
  begin
  writeln('Reslut is incorrect!');
  write(n,#9);
  write('i');InitMat();
  write('m');MakeMat();
  write('c');CalcMat();
  write('g');GeneMat();
  write('#');PrintMat();
  writeln('');
  end;
end.
