program diandeng;
uses display;
const m=1000;
var n:longword;
var l,l0,l1:array[0..m+1,-1..m+1]of boolean;
var i,j,k:longword;

procedure PrintMat();
var i,j:longword;
begin
writeln();
for j:=1 to n do
  begin
  for i:=0 to n do
    if l[j,i] then write('#') else write(' ');
  writeln();
  end;
end;

procedure InitMat();
begin
for j:=1 to n do
  begin
  for i:=0 to n do
    begin
    l[j,i]:=false;
    l0[j,i]:=false;
    l1[j,i]:=false;
    end;
  l[j,j]:=true;
  end;
end;

procedure MakeMat();
begin
for k:=1 to n do
  for i:=0 to n do
    begin
    for j:=1 to n do
      l1[j,i]:=l[j-1,i] xor l[j,i] xor l[j+1,i] xor l0[j,i] xor (i=0);
    for j:=1 to n do
      begin
      l0[j,i]:=l[j,i];
      l[j,i]:=l1[j,i];
      end;
    end;
end;

procedure CalcMat();
var j0:longword;
begin
for k:=1 to n do
  begin
  j0:=0;
  for j:=n downto k do
    if l[j,k]=true then j0:=j;
  j:=j0;
  if j>0 then
    begin
    if j<>k then
      for i:=0 to n do
        begin
        l[j,i]:=l[j,i] xor l[k,i];
        l[k,i]:=l[j,i] xor l[k,i];
        l[j,i]:=l[j,i] xor l[k,i];
        end;
    for j:=k+1 to n do
      if l[j,k]=true then
        begin
        for i:=k to n do
          l[j,i]:=l[j,i] xor l[k,i];
        l[j,0]:=l[j,0] xor l[k,0];
        end;
    end;
  end;
for i:=n downto 1 do
  if l[i,i]=true then
    for j:=i-1 downto 1 do
      if l[j,i]=true then
        begin
        l[j,i]:=false;
        l[j,0]:=l[j,0] xor l[i,0];
        end;
end;

procedure GeneMat();
begin
for i:=1 to n do
  begin
  l[1,i]:=l[i,0];
  l[i,0]:=false;
  end;
for j:=2 to n do
  for i:=1 to n do
    l[j,i]:=not(l[j-1,i-1] xor l[j-1,i] xor l[j-1,i+1] xor l[j-2,i]);
end;

begin
for n:=1 to m do
  begin
  write(n,#9);
  write('i');InitMat();
  write('m');MakeMat();
  write('c');CalcMat();
  write('g');GeneMat();
  //write('#');PrintMat();
  writeln('');
  end;
end.
