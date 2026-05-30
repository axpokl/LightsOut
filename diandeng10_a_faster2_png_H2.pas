{$define disp}
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
var b:pbitmap;
{$endif}

procedure PrintMat(mat:TMat);
var i,j:longint;
begin
writeln();
for j:=0 to n-1 do
  begin
//  if mat[j,-1] then write('#') else write('.');
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
        r[j,i]:=r[j,i] xor r[k,i];
        r[k,i]:=r[j,i] xor r[k,i];
        r[j,i]:=r[j,i] xor r[k,i];
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
        end;
end;

var f,g:array[-2..0,-1..m]of boolean;

procedure fg();
var ni,nt,k:longint;
begin
if f[0,n-1]=false then begin f[0,0]:=true;g[0,0]:=true;nt:=1;end else nt:=n;
for ni:=nt to n do
begin
f[-2]:=f[-1];f[-1]:=f[0];g[-2]:=g[-1];g[-1]:=g[0];
for k:=0 to ni do
begin
f[0,k]:=f[-1,k-1] xor f[-2,k];
g[0,k]:=g[-1,k-1] xor g[-1,k] xor g[-2,k];
end;
end;
end;

function rank():longint;
var fn,gn,cn:array[-1..m]of boolean;
var k,kg,kf,kt:longint;
begin
fg();
fn:=f[0];gn:=g[0];
kg:=n;kf:=n;
repeat
kt:=-1;
for k:=0 to kf do
begin 
if k>=(kf-kg) then fn[k]:=fn[k] xor gn[k-(kf-kg)];
if fn[k] then kt:=k;
end;
if kt=-1 then rank:=kg
else if kt<kg then begin cn:=fn;fn:=gn;gn:=cn;kf:=kg;kg:=kt;end 
else kf:=kt;
until kt=-1;
end;

procedure CalcMat2;
var h,p,q,x,y,c:array[-1..m]of boolean;
var kf,kg,sh,i,j,t:longint;
var done:boolean;
begin
p:=l[0];
for i:=n downto 1 do
  begin
  j:=i-2;
  while j>=0 do begin p[j]:=p[j] xor p[i];j:=j-2;end;
  end;
//extgcd
fg();
h:=f[0];
for i:=0 to m do begin h[i]:=h[i]; p[i]:=p[i]; x[i]:=false; y[i]:=false; end;
y[0]:=true;
kf:=-1; for i:=n downto 0 do if h[i] then begin kf:=i; break; end;
kg:=-1; for i:=n downto 0 do if p[i] then begin kg:=i; break; end;
done:=false;
while not done do
begin
 if kf<0 then begin for i:=0 to n do q[i]:=y[i]; done:=true; end
 else if kg<0 then begin for i:=0 to n do q[i]:=x[i]; done:=true; end
 else
  begin
   if kf<kg then begin for i:=0 to n do begin c[i]:=h[i]; h[i]:=p[i]; p[i]:=c[i]; c[i]:=x[i]; x[i]:=y[i]; y[i]:=c[i]; end; t:=kf; kf:=kg; kg:=t; end;
   sh:=kf-kg;
   for i:=n downto sh do if p[i-sh] then h[i]:=h[i] xor true;
   for i:=n downto sh do if y[i-sh] then x[i]:=x[i] xor true;
   kf:=-1; for i:=n downto 0 do if h[i] then begin kf:=i; break; end;
  end;
end;
//gen_reverse
r[0]:=q;
for i:=1 to n do
  begin
  end;
end;

procedure GeneMat();
begin
for i:=0 to n-1 do
  begin
  t[0,i]:=l[i,-1];
  l[i,-1]:=false;
  end;
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
for n:=1 to 20 do
  begin
  write(n,#9);
  write('m');MakeMat();{$ifdef disp}write('%');PrintMat('_A',l);{$endif}
  write('c');CalcMat2();{$ifdef disp}write('%');PrintMat('_E',l);write('%');PrintMat('_R',r);{$endif}
  write('g');GeneMat();{$ifdef disp}write('%');PrintMat('_T',t);{$endif}
//  write(#9,s,#9,n*n,#9,s/n/n:0:5);
  {$ifdef disp}if not(iswin()) then halt;{$endif}
  writeln();
  end;
end.
