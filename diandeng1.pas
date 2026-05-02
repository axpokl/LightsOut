program diandeng;
const l=5;m=l*l;step=100;
var a,b:array[0..l+1,0..l+1]of shortint;
    i,j:longint;
    n,r,s,p,q:int64;
    c:array[0..m]of int64;
    f:text;

procedure output;
begin
writeln(f,'##########');
for i:=1 to l do
  begin
  for j:=1 to l do
    if a[i,j]=0 then write(f,'¡¤') else write(f,'¨€');
  writeln(f);
  end;
writeln(f,'##########');
for i:=1 to l do
  begin
  for j:=1 to l do
    if b[i,j]=0 then write(f,'¡¤') else write(f,'¨€');
  writeln(f);
  end;
end;

begin
for i:=0 to m do c[i]:=0;
assign(f,'c:\o.txt');
rewrite(f);
p:=1;
for i:=1 to l do
  for j:=1 to l do
    p:=p shl 1;
q:=p div step;
writeln('start');
n:=0;
repeat
n:=n+1;
r:=n;
for i:=1 to l do
  for j:=1 to l do
    begin
    a[i,j]:=r and 1;
    r:=r shr 1;
    end;
s:=0;
for i:=1 to l do
  for j:=1 to l do
    begin
    b[i,j]:=a[i,j] xor a[i-1,j] xor a[i+1,j] xor a[i,j-1] xor a[i,j+1];
    s:=s+b[i,j]
    end;
c[s]:=c[s]+1;
if s=2 then output;
if (n mod q=0) then write(n div q:10);
until n>=p;
writeln();
for i:=0 to m do
  writeln(f,i:5,c[i]:15);
close(f);
readln();
end.
