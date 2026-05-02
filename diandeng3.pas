program diandeng;
var a:array[1..100,1..100]of shortint;
    b:array[0..101,0..101]of shortint;
    i,j,k:longint;
    n,r,s,p:int64;
    c:array[0..101]of int64;
    f:text;
    h,w:integer;
    o:boolean;


procedure output;
begin
append(f);
writeln(f,'#####################');
for i:=1 to h do
  begin
  for j:=1 to w do
    if a[i,j]=0 then write(f,'¡¡') else write(f,'¨€');
  writeln(f);
  end;                  {
writeln(f,'#####################');
for i:=1 to h do
  begin
  for j:=1 to w do
    if b[i,j]=0 then write(f,'¡¡') else write(f,'¨€');
  writeln(f);
  end;                   }
close(f);
end;

begin
for i:=0 to 101 do c[i]:=0;
assign(f,'diandeng.txt');
for k:=1 to 50 do
  begin
  w:=k;
  h:=k;
  o:=true;
p:=1;
for j:=1 to w do
  p:=p shl 1;
writeln('start: ',k);
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
if (s=w) and o then begin output;o:=false;end;
until n>=p;
append(f);
writeln(f,k:5,c[k]:15);
close(f);
end;
writeln('end');
readln();
end.
