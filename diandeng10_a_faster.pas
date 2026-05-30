{$define disp}
program diandeng;

{$ifdef disp}
uses display;
{$endif}

const m=2000;
var n:longword;
var l,l0,l1:array[-1..m,-1..m]of boolean;
var i,j,k:longint;

{$ifdef disp}
var bb:pbitbuf;
var s:longword;
{$endif}

procedure PrintMat();
var i,j:longint;
begin
writeln();
for j:=-1 to n-1 do
  begin
  if l[j,-1] then write('#') else write('.');
  for i:=0 to n-1 do
    if l[j,i] then write('#') else write('.');
  writeln();
  end;
end;

{$ifdef disp}
procedure DrawMat();
begin
while IsNextMsg() do ;
s:=0;
for j:=0 to n-1 do
  for i:=0 to n-1 do
    begin
    if l[j,i] then SetBBPixel(bb,i,j,black) else SetBBPixel(bb,i,j,white);
    if l[j,i] then s:=s+1;
    end;
SetBB(bb);
FreshWin();
end;
{$endif}

procedure InitMat();
begin
for j:=-1 to n-1 do
  begin
  for i:=-1 to n-1 do
    begin
    l[j,i]:=false;
    l0[j,i]:=false;
    l1[j,i]:=false;
    end;
  end;
l[0,0]:=true;
end;

procedure MakeMat();
begin
for k:=0 to n-1 do
  for j:=-1 to 0 do
    begin
    for i:=0 to n-1 do
      begin
      l1[j,i]:=(l[j,i] xor l[j,i+1]) xor (l[j,i-1] xor l0[j,i]);
      if j=-1 then l1[j,i]:=not l1[j,i];
      if i=(n-1) then l1[j,i]:=l1[j,i];
      end;
    for i:=0 to n-1 do
      begin
      l0[j,i]:=l[j,i];
      l[j,i]:=l1[j,i];
      end;
    end;
for j:=1 to n-1 do
  for i:=0 to n-1 do
    begin
    l[j,i]:=(l[j-1,i+1] xor l[j-1,i-1]);
    if j>1 then l[j,i]:=l[j,i] xor l[j-2,i];
    if i=(n-1) then l[j,i]:=l[j,i];
    end;
for j:=0 to n-1 do if l[-1,j] then l[j,-1]:=true;
for i:=0 to n-1 do l[-1,i]:=false;
end;

procedure CalcMat();
var j0:longint;
begin
for k:=0 to n-1 do
  begin
  j0:=-1;
  for j:=n-1 downto k do
    if l[j,k] then j0:=j;
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
      if l[j,k] then
        begin
        for i:=k to n-1 do
          l[j,i]:=l[j,i] xor l[k,i];
        l[j,-1]:=l[j,-1] xor l[k,-1];
        end;
    end;
  end;
for i:=n-1 downto 0 do
  if l[i,i] then
    for j:=i-1 downto 0 do
      if l[j,i] then
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
    l[j,i]:=not(l[j-1,i-1] xor l[j-1,i] xor l[j-1,i+1] xor l[j-2,i]);
end;

begin
{$ifdef disp}
CreateWin(m,m);
bb:=CreateBB(GetWin());
{$endif}
for n:=1 to m do
  begin
  write(n,#9);
  write('i');InitMat();
  write('m');MakeMat();
  write('c');CalcMat();
  write('g');GeneMat();
  //write('@');PrintMat();
  {$ifdef disp}
  write('%');DrawMat();
  write(#9,s,#9,n*n,#9,s/n/n:0:5);
  {$endif}
  writeln();
  end;
//readln();
end.
