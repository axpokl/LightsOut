//{$define disp}
program diandeng;

{$ifdef disp}
uses display;
{$endif}

const m=2000;
var n:longword;
var l,l0,l1:array[-1..m,-2..(m-1) shr 5+1]of longword;
var l_:array[-1..m,-1..m]of boolean;
var i,j,k:longint;

{$ifdef disp}
var bb:pbitbuf;
var s:longword;
{$endif}

procedure PrintMat_();
var i,j:longint;
begin
writeln();
for j:=0 to n-1 do
  begin
  for i:=0 to n-1 do
    if l_[j,i] then write('#') else write('.');
  writeln();
  end;
end;

procedure PrintMat();
var i,j:longint;
begin
writeln();
for j:=0 to n-1 do
  begin
  if l[j,-1]>0 then write('#') else write('.');
  for i:=0 to n-1 do
    if l[j,i shr 5]  and longword(1 shl (i and 31))>0 then write('#') else write('.');
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
    if l_[j,i] then SetBBPixel(bb,i,j,black) else SetBBPixel(bb,i,j,white);
    if l_[j,i] then s:=s+1;
    end;
SetBB(bb);
FreshWin();
end;
{$endif}

procedure InitMat();
begin
for j:=0 to n-1 do
  begin
  for i:=-1 to (n-1) shr 5 do
    begin
    l[j,i]:=0;
    l0[j,i]:=0;
    l1[j,i]:=0;
    end;
  end;
for j:=0 to n-1 do
  l[j,j shr 5]:=l[j,j shr 5] xor longword(1 shl (j and 31));
end;

procedure MakeMat();
var b:boolean;
begin
for k:=0 to n-1 do
  for i:=-1 to 0 do
    begin
    for j:=0 to n-1 do
      begin
      l1[j,i]:=l[j-1,i] xor l[j,i] xor l[j+1,i] xor l0[j,i];
      if i=-1 then l1[j,i]:=l1[j,i] xor 1;
      end;
    for j:=0 to n-1 do
      begin
      l0[j,i]:=l[j,i];
      l[j,i]:=l1[j,i];
      end;
    end;
for i:=1 to n-1 do
  for j:=0 to n-1 do
    begin
    b:=false;
    if l[j-1,(i-1) shr 5] and longword(1 shl ((i-1) and 31))>0 then b:=not(b);
    if l[j+1,(i-1) shr 5] and longword(1 shl ((i-1) and 31))>0 then b:=not(b);
    if i>1 then if l[j,(i-2) shr 5] and longword(1 shl ((i-2) and 31))>0 then b:=not(b);
    if b=true then l[j,i shr 5]:=l[j,i shr 5] or longword(1 shl (i and 31));
    if b=false then l[j,i shr 5]:=l[j,i shr 5] and not(longword(1 shl (i and 31)));
    end;
end;

procedure CalcMat();
var j0:longint;
begin
for k:=0 to n-1 do
  begin
  j0:=-1;
  for j:=n-1 downto k do
    if l[j,k shr 5] and longword(1 shl (k and 31))>0 then j0:=j;
  j:=j0;
  if j>=0 then
    begin
    if j<>k then
      for i:=-1 to (n-1) shr 5 do
        begin
        l[j,i]:=l[j,i] xor l[k,i];
        l[k,i]:=l[j,i] xor l[k,i];
        l[j,i]:=l[j,i] xor l[k,i];
        end;
    for j:=k+1 to n-1 do
      if l[j,k shr 5] and longword(1 shl (k and 31))>0 then
        begin
        for i:=k shr 5 to (n-1) shr 5 do
          l[j,i]:=l[j,i] xor l[k,i];
        l[j,-1]:=l[j,-1] xor l[k,-1];
        end;
    end;
  end;
for i:=n-1 downto 0 do
  if l[i,i shr 5] and longword(1 shl (i and 31))>0 then
    for j:=i-1 downto 0 do
      if l[j,i shr 5] and longword(1 shl (i and 31))>0 then
        begin
        l[j,i shr 5]:=l[j,i shr 5] xor longword(1 shl (i and 31));
        l[j,-1]:=l[j,-1] xor l[i,-1];
        end;
end;

procedure GeneMat();
begin
for i:=0 to n-1 do
  l_[0,i]:=(l[i,-1]=1);
for j:=1 to n-1 do
  for i:=0 to n-1 do
    l_[j,i]:=not(l_[j-1,i-1] xor l_[j-1,i] xor l_[j-1,i+1] xor l_[j-2,i]);
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
  //write('@');PrintMat_();
  {$ifdef disp}
  write('%');DrawMat();
  write(#9,s,#9,n*n,#9,s/n/n:0:5);
  {$endif}
  writeln();
  end;
end.
