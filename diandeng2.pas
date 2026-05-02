program diandeng;
const w=6;h=w;step=100;
var a:array[1..h,1..w]of shortint;
    b:array[0..h+1,0..w+1]of shortint;
    i,j:longint;
    n,r,s,p,q:int64;
    c:array[0..w]of int64;
    f:text;

procedure output;
begin
writeln(f,'##########');
for i:=1 to h do
  begin
  for j:=1 to w do
    if a[i,j]=0 then write(f,'¡¤') else write(f,'¨€');
  writeln(f);
  end;
writeln(f,'##########');
for i:=1 to h do
  begin
  for j:=1 to w do
    if b[i,j]=0 then write(f,'¡¤') else write(f,'¨€');
  writeln(f);
  end;
end;

begin
for i:=0 to w do c[i]:=0;
assign(f,'c:\o.txt');
rewrite(f);
p:=1;
for j:=1 to w do
  p:=p shl 1;
q:=p div step;
writeln('start');
n:=0;
repeat
n:=n+1;
r:=n;
for j:=1 to w do
  begin
  a[1,j]:=r and 1;
  r:=r shr 1;
  end;
s:=0;
for i:=1 to h do
  for j:=1 to w do
    b[i,j]:=0;
i:=1;
for j:=1 to h do
  if a[1,j]=1 then
    begin
    b[i,j-1]:=b[i,j-1] xor 1;
    b[i,j]:=b[i,j] xor 1;
    b[i,j+1]:=b[i,j+1] xor 1;
    b[i+1,j]:=b[i+1,j] xor 1;
    end;
for i:=2 to h do
  for j:=1 to w do
    if b[i-1,j]=0 then
      begin
      b[i-1,j]:=b[i-1,j] xor 1;
      b[i,j-1]:=b[i,j-1] xor 1;
      b[i,j]:=b[i,j] xor 1;
      b[i,j+1]:=b[i,j+1] xor 1;
      b[i+1,j]:=b[i+1,j] xor 1;
      a[i,j]:=1;
      end
    else
      a[i,j]:=0;
i:=h;
for j:=1 to w do
  s:=s+b[i,j];
c[s]:=c[s]+1;
if s=w then output;   {
if (n mod q=0) then write(n div q:10);}
until n>=p;
writeln();
for i:=0 to w do
  writeln(f,(h-1)*w+i:5,c[i]:15);
close(f);
writeln('end');
readln();
end.
