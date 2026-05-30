{$define disp}
program diandeng;

{$ifdef disp}
uses display;
{$endif}

const m=2000;

type TMat=array[-2..m,-2..m]of Boolean;
type TVec=array[-2..m]of boolean;

var n:longword;
var i,j:longint;
var y,f,c,x:TVec;
var y1,y2,y01,y02,f1,f2,c1,c2:TVec;
var lastLN,lastFN:longint;
var matInit:boolean;
{$ifdef disp}
var t:TMat;
{$endif}

{$ifdef disp}
var bb:pbitbuf;
var bp:pbitmap;
{$endif}

procedure PrintMat(mat:TMat);
begin
writeln();
for j:=0 to n-1 do
  begin
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
bp:=CreateBMP(n,n);
DrawBMP(_pmain,bp,0,0,n,n,0,0,n,n);
SaveBMP(bp,'png'+s+'/'+i2s(n)+'.png');
ReleaseBMP(bp);
end;
{$endif}

procedure MakeMat();
var y3,y03,f3,c3:TVec;
begin
if (not matInit) or (longint(n)<lastLN) or (longint(n)<lastFN) then
  begin
  for i:=-2 to m do
    begin
    y2[i]:=false; y1[i]:=false; y02[i]:=false; y01[i]:=false;
    f2[i]:=false; f1[i]:=false; c2[i]:=false; c1[i]:=false;
    end;
  f1[0]:=true; c1[0]:=true;
  lastLN:=0; lastFN:=0; matInit:=true;
  end;
for j:=lastLN+1 to n do
  begin
  for i:=-2 to m do begin y03[i]:=false; y3[i]:=false; end;
  for i:=1 to j-1 do y03[i]:=y01[i-1] xor y01[i] xor y01[i+1] xor y02[i];
  for i:=0 to j-1 do y3[i]:=not(y1[i-2] xor y1[i-1] xor y1[i] xor y2[i-2] xor y01[i-1] xor y01[i] xor y01[i+1] xor y02[i-1] xor y02[i]);
  y03[0]:=y3[0];
  y03[-2]:=true;
  y02:=y01; y01:=y03; y2:=y1; y1:=y3;
  end;
lastLN:=n;
for j:=lastFN+1 to n do
  begin
  for i:=-2 to m do f3[i]:=false;
  if j=0 then f3[0]:=true
  else for i:=0 to j do f3[i]:=f1[i-1] xor f2[i];
  f2:=f1; f1:=f3;
  end;
for j:=lastFN+1 to n do
  begin
  for i:=-2 to m do c3[i]:=false;
  if j=0 then c3[0]:=true
  else for i:=0 to j do c3[i]:=c1[i-1] xor c2[i] xor c1[i];
  c2:=c1; c1:=c3;
  end;
lastFN:=n;
y:=y1; f:=f1; c:=c1;
write('f ');for i:=0 to n do if f[i] then write(1) else write(0);writeln;
write('c ');for i:=0 to n-1 do if c[i] then write(1) else write(0);writeln;
end;

function gcd(vf,vg:TVec; var vd,vr:TVec):longint;
var vt,vx,vy:TVec;
var kf,kg:longint;
var done:boolean;
begin
kf:=-1; for i:=n downto 0 do if vf[i] then begin kf:=i; break; end;
kg:=-1; for i:=n downto 0 do if vg[i] then begin kg:=i; break; end;
done:=false;
for i:=0 to n do begin vx[i]:=false; vy[i]:=false; end; vy[0]:=true;
repeat
if kf<kg then begin for i:=0 to n do begin vt[i]:=vf[i]; vf[i]:=vg[i]; vg[i]:=vt[i]; vt[i]:=vx[i]; vx[i]:=vy[i]; vy[i]:=vt[i]; end; j:=kf; kf:=kg; kg:=j; end;
if kg<0 then begin for i:=0 to n do begin vd[i]:=vf[i]; vr[i]:=vx[i]; end; gcd:=kf; done:=true; end;
if not(done) then
  begin
  for i:=n downto (kf-kg) do if vg[i-(kf-kg)] then vf[i]:=vf[i] xor true;
  for i:=n downto (kf-kg) do if vy[i-(kf-kg)] then vx[i]:=vx[i] xor true;
  kf:=-1; for i:=n downto 0 do if vf[i] then begin kf:=i; break; end;
  end;
until done;
end;

procedure CalcMat2;
var q,g:TVec;
var v,v0,z:TVec;
var g0,g1,g2:TVec;
var i0,r0,kk,jmax:longint;
begin
r0:=gcd(f,c,g,q);
writeln('gcd',#9,r0,#9);
write('q ');for i:=0 to n-1 do if q[i] then write(1) else write(0);writeln;
write('g ');for i:=0 to n do if g[i] then write(1) else write(0);writeln;
for i:=-1 to n do v[i]:=y[i];
write('y ');for i:=0 to n-1 do if v[i] then write(1) else write(0);writeln;
for i:=0 to n do z[i]:=false;
for j:=0 to n-1 do 
  begin
  if q[j] then for i:=0 to n-1 do z[i]:=z[i] xor v[i];
  for i:=0 to n-1 do v0[i]:=v[i-1] xor v[i+1];
  for i:=0 to n-1 do v[i]:=v0[i];
  end;
if r0=0 then
  for i:=0 to n-1 do x[i]:=z[i]
else
begin
write('z ');for i:=0 to n-1 do if z[i] then write(1) else write(0);writeln;
for i:=-2 to n do begin g0[i]:=false; g1[i]:=false; g2[i]:=false; v[i]:=false; v0[i]:=false; end;
v[0]:=true;
for j:=0 to r0 do 
  begin
  if g[j] then for i:=0 to n-1 do g0[i]:=g0[i] xor v[i];
  for i:=0 to n-1 do v0[i]:=v[i-1] xor v[i+1];
  for i:=-2 to n do v[i]:=v0[i];
  end;
if n-r0-1<0 then jmax:=0 else jmax:=n-r0-1;
writeln('d');
write(0,#9);for i:=0 to n-1 do if g0[i] then write(1) else write(0);writeln;
if jmax=0 then g1:=g0
else if r0<jmax then
  begin
  for i:=-2 to n do v[i]:=false;
  for i:=0 to n-1 do v[i]:=g0[i-1] xor g0[i+1];
  for i:=-2 to n do begin g1[i]:=false; g2[i]:=false; end;
  for i:=0 to n-1 do begin g1[i]:=g0[n-1-i]; g2[i]:=v[n-1-i]; end;
  for j:=1 to r0 do
    begin
    for i:=-2 to n do g0[i]:=false;
    for i:=0 to n-1 do g0[i]:=g1[i] xor g2[i-1] xor g2[i+1];
    g1:=g2;
    g2:=g0;
    end;
  end
else
  begin
  g1:=g0;
  for j:=1 to jmax do
    begin
    for i:=-2 to n do g0[i]:=false;
    for i:=0 to n-1 do g0[i]:=g1[i-1] xor g1[i+1] xor g2[i];
    write(j,#9);for i:=0 to n-1 do if g0[i] then write(1) else write(0);writeln;
    g2:=g1;
    g1:=g0;
    end;
  for j:=jmax+1 to n-1 do begin write(j,#9);for i:=0 to n-1 do write(0);writeln; end;
  end;
for i:=0 to n-1 do x[i]:=false;
if r0<=n-1 then
for i:=n-1 downto r0 do
  begin
  if z[i] then
  begin
    i0:=i-r0;
write(i,#9,i0,#9);
for kk:=0 to n-1 do if z[kk] then write(1) else write(0);write(#9);
    for j:=0 to n-1 do z[j]:=z[j] xor g1[j];
    x[i0]:=true;
for kk:=0 to n-1 do if g1[kk] then write(1) else write(0);write(#9);
for kk:=0 to n-1 do if z[kk] then write(1) else write(0);write(#9);
for kk:=0 to n-1 do if x[kk] then write(1) else write(0);write(#9);
writeln();
  end;
  if i>r0 then
    begin
    for j:=-2 to n do g0[j]:=false;
    for j:=0 to n-1 do g0[j]:=g1[j] xor g2[j-1] xor g2[j+1];
    g1:=g2;
    g2:=g0;
    end;
  end;
end;

{
for i:=-1 to n do v[i]:=y[i];
write('y ');for i:=0 to n-1 do if v[i] then write(1) else write(0);writeln;

for i:=0 to n-1 do b0[0,i]:=b[n,i];
for j:=1 to n-1 do for i:=0 to n-1 do b0[j,i]:=b0[j-1,i-1] xor b0[j-1,i+1] xor b0[j-2,i];
writeln('b');for j:=0 to n-1 do begin write(j,#9);for i:=0 to n-1 do if b0[j,i] then write(1) else write(0);writeln;end;

for i:=0 to n-1 do begin r[i]:=-1; for j:=0 to n-1 do if b0[j,i] then begin r[i]:=j; break; end; end;
write('r ');for i:=0 to n-1 do write(r[i]);writeln;
for i:=0 to n-1 do x[i]:=false;
for i:=0 to n-1 do
 if v[i] then
 begin
  i0:=-1;
  for j:=0 to n-1 do if r[j]=i then begin i0:=j; break; end;
write(i,#9,i0,#9);
  if i0>=0 then begin
for kk:=0 to n-1 do if v[kk] then write(1) else write(0);write(#9);
  for j:=0 to n-1 do y[j]:=(y[j] or b0[j,i0]) and not (y[j] and b0[j,i0]);
  x[i0]:=not x[i0];
for kk:=0 to n-1 do if b0[kk,i0] then write(1) else write(0);write(#9);
for kk:=0 to n-1 do if v[kk] then write(1) else write(0);write(#9);
for kk:=0 to n-1 do if x[kk] then write(1) else write(0);write(#9);
end;
writeln();
 end;
}

write('x ');for i:=0 to n-1 do if x[i] then write(1) else write(0);writeln;
end;

function GeneMat():boolean;
var x2,x1,x0:TVec;
begin
for i:=-2 to n do begin x2[i]:=false; x1[i]:=false; end;
for i:=0 to n-1 do x1[i]:=x[i];
{$ifdef disp}
for i:=0 to n-1 do t[0,i]:=x[i];
{$endif}
for j:=1 to n-1 do
  begin
  for i:=-2 to n do x0[i]:=false;
  for i:=0 to n-1 do x0[i]:=not(x1[i-1] xor x1[i] xor x1[i+1] xor x2[i]);
  {$ifdef disp}
  for i:=0 to n-1 do t[j,i]:=x0[i];
  {$endif}
  for i:=-2 to n do x2[i]:=x1[i];
  for i:=-2 to n do x1[i]:=x0[i];
  end;
GeneMat:=true;
for i:=0 to n-1 do GeneMat:=GeneMat and (x1[i-1] xor x1[i] xor x1[i+1] xor x2[i]);
writeln(GeneMat);
end;

begin
{$ifdef disp}
CreateWin(m,m);
bb:=CreateBB(GetWin());
bp:=CreateBMP(m,m);
{$endif}
for n:=1 to 20 do
  begin
  writeln('#',n);
  MakeMat();
  CalcMat2();
  GeneMat();{$ifdef disp}PrintMat('_T2',t);{$endif}
  {$ifdef disp}if not(iswin()) then halt;{$endif}
  writeln();
  end;
end.
