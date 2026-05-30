{$define disp}
program diandeng;

{$ifdef disp}
uses display;
{$endif}

const m=1000;

type TMat=array[-1..m,-1..m]of Boolean;
type TVec=array[-1..m]of boolean;
type TVeci=array[-1..m]of longint;

var n:longword;
var a,l,r,t,f,e,h:TMat;
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
for j:=1 to n do
  for i:=0 to n-1 do
    l[j,i]:=not(l[j-1,i-1] xor l[j-1,i] xor l[j-1,i+1] xor l[j-2,i]);
for j:=0 to n do if a[j,j]=false then
  if a[0,0]=false then a[0,0]:=true
  else for i:=0 to j do a[j,i]:=a[j-1,i-1] xor a[j-1,i] xor a[j-1,i+1] xor a[j-2,i];
//for i:=0 to n-1 do for j:=0 to n-1 do r[i,j]:=(i=j);
for j:=0 to n do if f[j,j]=false then
  if f[0,0]=false then f[0,0]:=true
  else for i:=0 to j do f[j,i]:=f[j-1,i-1] xor f[j-2,i];
for j:=0 to n do if e[j,j]=false then
  if e[0,0]=false then e[0,0]:=true
  else for i:=0 to j do e[j,i]:=e[j-1,i-1] xor e[j-1,i+1];
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

function gcd(n:longint;vf,vg:TVEC; var vr:TVEC):longint;
var cn:TVEC;
var k,kg,kf,kt,i:longint;
begin
kf:=-1; for k:=n downto 0 do if vf[k] then begin kf:=k; break; end;
kg:=-1; for k:=n downto 0 do if vg[k] then begin kg:=k; break; end;
if kf<0 then begin for i:=0 to n do vr[i]:=vg[i]; gcd:=kg; exit; end;
if kg<0 then begin for i:=0 to n do vr[i]:=vf[i]; gcd:=kf; exit; end;
if kf<kg then begin for i:=0 to n do begin cn[i]:=vf[i]; vf[i]:=vg[i]; vg[i]:=cn[i];end; k:=kf; kf:=kg; kg:=k; end;
repeat
 kt:=-1;
 for k:=0 to kf do
  begin
   if k>=(kf-kg) then vf[k]:=vf[k] xor vg[k-(kf-kg)];
   if vf[k] then kt:=k;
  end;
 if kt=-1 then begin for i:=0 to n do vr[i]:=vg[i]; gcd:=kg; exit; end
 else if kt<kg then begin for i:=0 to n do begin cn[i]:=vf[i]; vf[i]:=vg[i]; vg[i]:=cn[i]; end; kf:=kg; kg:=kt; end
 else kf:=kt;
until false;
end;

procedure rev(vf,vg:TVec;var vr:TVec);
var kf,kg,sh,i,t:longint;
var done:boolean;
var vt,vx,vy:TVec;
begin
for i:=0 to n do begin vx[i]:=false; vy[i]:=false; end;vy[0]:=true;
kf:=-1; for i:=n downto 0 do if vf[i] then begin kf:=i; break; end;
kg:=-1; for i:=n downto 0 do if vg[i] then begin kg:=i; break; end;
done:=false;
while not done do
  begin
  if kf<0 then begin for i:=0 to n do vr[i]:=vy[i]; done:=true; end
  else if kg<0 then begin for i:=0 to n do vr[i]:=vx[i]; done:=true; end
  else
    begin
    if kf<kg then begin for i:=0 to n do begin vt[i]:=vf[i]; vf[i]:=vg[i]; vg[i]:=vt[i]; vt[i]:=vx[i]; vx[i]:=vy[i]; vy[i]:=vt[i]; end; t:=kf; kf:=kg; kg:=t; end;
    sh:=kf-kg;
    for i:=n downto sh do if vg[i-sh] then vf[i]:=vf[i] xor true;
    for i:=n downto sh do if vy[i-sh] then vx[i]:=vx[i] xor true;
    kf:=-1; for i:=n downto 0 do if vf[i] then begin kf:=i; break; end;
    end;
  end;
end;

procedure CalcMat2;
var p,q,x,y,z,c,g:TVec;
var r:TVeci;
var i,j,k:longint;
begin
writeln(n);
write('a ');for i:=0 to n-1 do if a[n,i] then write(1) else write(0);writeln;
write('f ');for i:=0 to n do if f[n,i] then write(1) else write(0);writeln;
for i:=0 to n do p[i]:=false;
for j:=0 to n-1 do if a[n,j] then for i:=0 to n-1 do p[i]:=p[i] xor f[j,i];
write('p ');for i:=0 to n-1 do if p[i] then write(1) else write(0);writeln;
rev(f[n],p,q);
write('q ');for i:=0 to n-1 do if q[i] then write(1) else write(0);writeln;
for i:=0 to n do y[i]:=l[n,i];
write('y ');for i:=0 to n-1 do if y[i] then write(1) else write(0);writeln;
writeln(gcd(n,p,f[n],g));
//这里返回的g其实就是gcd(f(x),f(1+x))
write('g ');for i:=0 to n do if g[i] then write(1) else write(0);writeln;
for i:=0 to n do z[i]:=false;
for j:=0 to n-1 do 
  begin
  if q[j] then for i:=0 to n-1 do z[i]:=z[i] xor y[i];
  for i:=0 to n-1 do c[i]:=y[i-1] xor y[i+1];
  for i:=0 to n-1 do y[i]:=c[i];
  end;
write('z ');for i:=0 to n-1 do if z[i] then write(1) else write(0);writeln;
//这里通过g计算G[:,j]=h，首先计算第一行（e=10000...），然后用十字方法计算接下来的
for i:=0 to n-1 do h[0,i]:=false;
for j:=0 to n-1 do if g[j] then for i:=0 to n-1 do h[0,i]:=h[0,i] xor e[j,i];
write('h ');for i:=0 to n-1 do if h[0,i] then write(1) else write(0);writeln;
for j:=1 to n-1 do for i:=0 to n-1 do h[j,i]:=h[j-1,i-1] xor h[j-1,i+1] xor h[j-2,i];
write('h ');for i:=0 to n-1 do if h[n-1,i] then write(1) else write(0);writeln;
//根据G[:,j]和z计算x，需要把z不断减去G，x则是G的下标，问一下AI则么实现
for j:=0 to n-1 do begin x[j]:=false; r[j]:=-1; for i:=0 to n-1 do if h[i,j] then begin r[j]:=i; break; end; end;
for i:=0 to n-1 do
 if z[i] then
 begin
  k:=-1;
  for j:=i to n-1 do if r[j]=i then begin k:=j; break; end;
  if k<0 then break;
  for j:=0 to n-1 do z[j]:=z[j] xor h[j,k];
  x[k]:=not x[k];
 end;
for i:=0 to n-1 do t[0,i]:=x[i];
write('x ');for i:=0 to n-1 do if x[i] then write(1) else write(0);writeln;
end;

function GeneMat():boolean;
begin
for j:=1 to n-1 do
  for i:=0 to n-1 do
    t[j,i]:=not(t[j-1,i-1] xor t[j-1,i] xor t[j-1,i+1] xor t[j-2,i]);
GeneMat:=true;
for i:=0 to n-1 do GeneMat:=GeneMat and (t[n-1,i-1] xor t[n-1,i] xor t[n-1,i+1] xor t[n-2,i]);
write(GeneMat);
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
  write('m');MakeMat();
  write('c');CalcMat2();{$ifdef disp}write('%');PrintMat('_E',l);write('%');PrintMat('_R',r);{$endif}
  write('g');GeneMat();{$ifdef disp}write('%');PrintMat('_T',t);{$endif}
//  write(#9,s,#9,n*n,#9,s/n/n:0:5);
  {$ifdef disp}if not(iswin()) then halt;{$endif}
  writeln();
  end;
end.
