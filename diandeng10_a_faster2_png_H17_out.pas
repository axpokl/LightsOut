{$define disp}
program diandeng;

{$ifdef disp}
uses display;
{$endif}

const m=2000;

type TMat=array[-2..m,-2..m]of Boolean;
type TVec=array[-2..m]of boolean;

var n:longword;
var l,f,c:TVec;
var ll2,ll1,ll02,ll01,ff2,ff1,cc2,cc1:TVec;
var lastLN,lastFN:longint;
var matInit:boolean;
{$ifdef disp}
var t:TMat;
{$endif}
var x:TVec;
var i,j:longint;

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
var ln,l0n,fn,cn:TVec;
begin
if (not matInit) or (longint(n)<lastLN) or (longint(n)<lastFN) then
  begin
  for i:=-2 to m do
    begin
    ll2[i]:=false; ll1[i]:=false; ll02[i]:=false; ll01[i]:=false;
    ff2[i]:=false; ff1[i]:=false; cc2[i]:=false; cc1[i]:=false;
    end;
  ff1[0]:=true; cc1[0]:=true;
  lastLN:=0; lastFN:=0; matInit:=true;
  end;
for j:=lastLN+1 to n do
  begin
  for i:=-2 to m do begin l0n[i]:=false; ln[i]:=false; end;
  for i:=1 to j-1 do l0n[i]:=ll01[i-1] xor ll01[i] xor ll01[i+1] xor ll02[i];
  for i:=0 to j-1 do ln[i]:=not(ll1[i-2] xor ll1[i-1] xor ll1[i] xor ll2[i-2] xor ll01[i-1] xor ll01[i] xor ll01[i+1] xor ll02[i-1] xor ll02[i]);
  l0n[0]:=ln[0];
  l0n[-2]:=true;
  ll02:=ll01; ll01:=l0n; ll2:=ll1; ll1:=ln;
  end;
lastLN:=n;
for j:=lastFN+1 to n do
  begin
  for i:=-2 to m do fn[i]:=false;
  if j=0 then fn[0]:=true
  else for i:=0 to j do fn[i]:=ff1[i-1] xor ff2[i];
  ff2:=ff1; ff1:=fn;
  end;
for j:=lastFN+1 to n do
  begin
  for i:=-2 to m do cn[i]:=false;
  if j=0 then cn[0]:=true
  else for i:=0 to j do cn[i]:=cc1[i-1] xor cc2[i] xor cc1[i];
  cc2:=cc1; cc1:=cn;
  end;
lastFN:=n;
l:=ll1; f:=ff1; c:=cc1;
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
var q,y,z,y0,g,d0,d1,d2:TVec;
var i0,r0,kk,jmax:longint;
begin

r0:=gcd(f,c,g,q);
writeln('gcd',#9,r0,#9);
write('q ');for i:=0 to n-1 do if q[i] then write(1) else write(0);writeln;
write('g ');for i:=0 to n do if g[i] then write(1) else write(0);writeln;
for i:=-1 to n do y[i]:=l[i];
write('y ');for i:=0 to n-1 do if y[i] then write(1) else write(0);writeln;
for i:=0 to n do z[i]:=false;
for j:=0 to n-1 do 
  begin
  if q[j] then for i:=0 to n-1 do z[i]:=z[i] xor y[i];
  for i:=0 to n-1 do y0[i]:=y[i-1] xor y[i+1];
  for i:=0 to n-1 do y[i]:=y0[i];
  end;
if r0=0 then
  for i:=0 to n-1 do x[i]:=z[i]
else
begin
write('z ');for i:=0 to n-1 do if z[i] then write(1) else write(0);writeln;
for i:=-2 to n do begin d0[i]:=false; d1[i]:=false; d2[i]:=false; y[i]:=false; y0[i]:=false; end;
y[0]:=true;
for j:=0 to r0 do 
  begin
  if g[j] then for i:=0 to n-1 do d0[i]:=d0[i] xor y[i];
  for i:=0 to n-1 do y0[i]:=y[i-1] xor y[i+1];
  for i:=-2 to n do y[i]:=y0[i];
  end;
if n-r0-1<0 then jmax:=0 else jmax:=n-r0-1;
writeln('d');
write(0,#9);for i:=0 to n-1 do if d0[i] then write(1) else write(0);writeln;
if jmax=0 then d1:=d0
else
  begin
  d1:=d0;
  for j:=1 to jmax do
    begin
    for i:=-2 to n do d0[i]:=false;
    for i:=0 to n-1 do d0[i]:=d1[i-1] xor d1[i+1] xor d2[i];
    write(j,#9);for i:=0 to n-1 do if d0[i] then write(1) else write(0);writeln;
    d2:=d1;
    d1:=d0;
    end;
  end;
for j:=jmax+1 to n-1 do begin write(j,#9);for i:=0 to n-1 do write(0);writeln; end;
for i:=0 to n-1 do x[i]:=false;
if r0<=n-1 then
for i:=n-1 downto r0 do
  begin
  if z[i] then
  begin
    i0:=i-r0;
write(i,#9,i0,#9);
for kk:=0 to n-1 do if z[kk] then write(1) else write(0);write(#9);
    for j:=0 to n-1 do z[j]:=z[j] xor d1[j];
    x[i0]:=true;
for kk:=0 to n-1 do if d1[kk] then write(1) else write(0);write(#9);
for kk:=0 to n-1 do if z[kk] then write(1) else write(0);write(#9);
for kk:=0 to n-1 do if x[kk] then write(1) else write(0);write(#9);
writeln();
  end;
  if i>r0 then
    begin
    for j:=-2 to n do d0[j]:=false;
    for j:=0 to n-1 do d0[j]:=d1[j] xor d2[j-1] xor d2[j+1];
    d1:=d2;
    d2:=d0;
    end;
  end;
end;

{
for i:=-1 to n do y[i]:=l[i];
write('y ');for i:=0 to n-1 do if y[i] then write(1) else write(0);writeln;

for i:=0 to n-1 do b0[0,i]:=b[n,i];
for j:=1 to n-1 do for i:=0 to n-1 do b0[j,i]:=b0[j-1,i-1] xor b0[j-1,i+1] xor b0[j-2,i];
writeln('b');for j:=0 to n-1 do begin write(j,#9);for i:=0 to n-1 do if b0[j,i] then write(1) else write(0);writeln;end;

for i:=0 to n-1 do begin r[i]:=-1; for j:=0 to n-1 do if b0[j,i] then begin r[i]:=j; break; end; end;
write('r ');for i:=0 to n-1 do write(r[i]);writeln;
for i:=0 to n-1 do x[i]:=false;
for i:=0 to n-1 do
 if y[i] then
 begin
  i0:=-1;
  for j:=0 to n-1 do if r[j]=i then begin i0:=j; break; end;
write(i,#9,i0,#9);
  if i0>=0 then begin
for kk:=0 to n-1 do if y[kk] then write(1) else write(0);write(#9);
  for j:=0 to n-1 do y[j]:=(y[j] or b0[j,i0]) and not (y[j] and b0[j,i0]);
  x[i0]:=not x[i0];
for kk:=0 to n-1 do if b0[kk,i0] then write(1) else write(0);write(#9);
for kk:=0 to n-1 do if y[kk] then write(1) else write(0);write(#9);
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
