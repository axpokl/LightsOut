//{$define disp}
program diandeng;

{$ifdef disp}
uses Windows, display;
const m=1000;
{$else}
uses Windows;
const m=100000;
{$endif}

type TVec=array[-2..m]of boolean;
     PVec=^TVec;

var n:longword;
var i,j:longint;
var x,y,y1,y_,y_1,f,f1,c,c1:TVec;
var hf,hf1,hc,hc1:TVec;
var k:longint;
var hk:longint;
var o,ho:boolean;
var perfFreq,lastCounter:Int64;
var hasLastCounter:boolean;

{$ifdef disp}
var bb:pbitbuf;
var bp:pbitmap;
{$endif}

function TimeMark(ch:char):Double;
var c:Int64;
var ms:Double;
begin
  QueryPerformanceCounter(c);
  if not hasLastCounter then
  begin
    ms:=0;
    hasLastCounter:=true;
  end
  else
    ms:=(c-lastCounter)*1000.0/perfFreq;
  lastCounter:=c;
  TimeMark:=ms;
  write(ms:8:3,#9,ch);
end;

{$ifdef disp}
procedure SaveMat(s:ansistring);
begin
SetBB(bb);
FreshWin();
bp:=CreateBMP(n,n);
DrawBMP(_pmain,bp,0,0,n,n,0,0,n,n);
SaveBMP(bp,'png'+s+'/'+i2s(n)+'.png');
ReleaseBMP(bp);
end;
{$endif}

procedure VecZeroHi(var a:TVec;hi:longint);
var k2:longint;
begin
if hi<-2 then hi:=-2;
for k2:=-2 to hi do a[k2]:=false;
end;

procedure VecCopyHi(var a:TVec; const b:TVec; hi:longint);
var k2:longint;
begin
if hi<-2 then hi:=-2;
for k2:=-2 to hi do a[k2]:=b[k2];
end;

function PolyDeg(const a:TVec;hi:longint):longint;
begin
while (hi>=0) and not(a[hi]) do dec(hi);
PolyDeg:=hi;
end;

procedure ApplyPoly(const va,vsrc:TVec; var vdst:TVec; hi,degmax:longint);
var cur0,cur1:TVec;
var pcur,pnxt,pt:PVec;
var k2,d,j2,l,r,l2,r2:longint;
begin
for k2:=-2 to hi+1 do begin cur0[k2]:=false; cur1[k2]:=false; vdst[k2]:=false; end;
for k2:=0 to hi do cur0[k2]:=vsrc[k2];
cur0[-1]:=false;
cur0[hi+1]:=false;
d:=PolyDeg(va,degmax);
if d<0 then exit;
l:=0; while (l<=hi) and not(cur0[l]) do inc(l);
if l>hi then exit;
r:=hi; while (r>=l) and not(cur0[r]) do dec(r);
pcur:=@cur0;
pnxt:=@cur1;
for j2:=0 to d do
  begin
  if va[j2] then for k2:=l to r do vdst[k2]:=vdst[k2] xor pcur^[k2];
  if j2>=d then break;
  l2:=l-1; if l2<0 then l2:=0;
  r2:=r+1; if r2>hi then r2:=hi;
  pcur^[l-2]:=false;
  pcur^[l-1]:=false;
  pcur^[r+1]:=false;
  if r+2<=hi+1 then pcur^[r+2]:=false;
  for k2:=l2 to r2 do pnxt^[k2]:=pcur^[k2-1] xor pcur^[k2+1];
  while (l2<=r2) and not(pnxt^[l2]) do inc(l2);
  if l2>r2 then break;
  while not(pnxt^[r2]) do dec(r2);
  pnxt^[l2-2]:=false;
  pnxt^[l2-1]:=false;
  pnxt^[r2+1]:=false;
  if r2+2<=hi+1 then pnxt^[r2+2]:=false;
  pt:=pcur;
  pcur:=pnxt;
  pnxt:=pt;
  l:=l2;
  r:=r2;
  end;
end;

procedure MakeMat();
var old,old1,prev,cur,nxt,newA,newB:boolean;
var hiu:longint;
begin
TimeMark('m');
if (not o) or (longint(n)<k) then
  begin
  VecZeroHi(y1,longint(n)); VecZeroHi(y,longint(n)); VecZeroHi(y_1,longint(n)); VecZeroHi(y_,longint(n));
  VecZeroHi(f1,longint(n)); VecZeroHi(f,longint(n));
  VecZeroHi(c1,longint(n)); VecZeroHi(c,longint(n));
  f[0]:=true;
  k:=0; o:=true; ho:=false;
  end;
for j:=k+1 to n do
  begin
  for i:=j downto 0 do
    begin
    old:=y[i];
    if i<j then y[i]:=not(y[i-2] xor y[i-1] xor y[i] xor y1[i-2] xor y_[i-1] xor y_[i] xor y_[i+1] xor y_1[i-1] xor y_1[i])
    else y[i]:=false;
    y1[i]:=old;
    end;
  old:=y_[-2]; y_1[-2]:=old; y_[-2]:=true;
  old:=y_[-1]; y_1[-1]:=old; y_[-1]:=false;
  prev:=y_[0]; y_1[0]:=prev; y_[0]:=y[0];
  for i:=1 to j-1 do
    begin
    cur:=y_[i];
    nxt:=y_[i+1];
    old1:=y_1[i];
    y_1[i]:=cur;
    y_[i]:=prev xor cur xor nxt xor old1;
    prev:=cur;
    end;
  cur:=y_[j]; y_1[j]:=cur; y_[j]:=false;
  if j=1 then
    begin
    f1[0]:=f[0]; c1[0]:=c[0];
    f[0]:=false; c[0]:=true;
    end
  else
    begin
    hiu:=j div 2;
    for i:=hiu downto 0 do
      begin
      old:=f[i]; old1:=c[i];
      if i=0 then newA:=f1[i] else newA:=f1[i] xor c[i-1];
      newB:=f[i] xor c[i] xor c1[i];
      f[i]:=newA; c[i]:=newB;
      f1[i]:=old; c1[i]:=old1;
      end;
    end;
  if j=longint(n div 2) then
    begin
    VecCopyHi(hf,f,j div 2);
    VecCopyHi(hc,c,j div 2);
    VecCopyHi(hf1,f1,j div 2);
    VecCopyHi(hc1,c1,j div 2);
    hk:=j;
    ho:=true;
    end;
  end;
k:=n;
end;

procedure EnsureAB(nn:longword);
var old,old1,newA,newB:boolean;
var jj,ii,hiu:longint;
begin
if (not ho) or (longint(nn)<hk) then
  begin
  VecZeroHi(hf,longint(nn div 2)); VecZeroHi(hc,longint(nn div 2));
  VecZeroHi(hf1,longint(nn div 2)); VecZeroHi(hc1,longint(nn div 2));
  hf[0]:=true;
  hk:=0; ho:=true;
  end;
for jj:=hk+1 to nn do
  begin
  if jj=1 then
    begin
    hf1[0]:=hf[0]; hc1[0]:=hc[0];
    hf[0]:=false; hc[0]:=true;
    end
  else
    begin
    hiu:=jj div 2;
    for ii:=hiu downto 0 do
      begin
      old:=hf[ii]; old1:=hc[ii];
      if ii=0 then newA:=hf1[ii] else newA:=hf1[ii] xor hc[ii-1];
      newB:=hf[ii] xor hc[ii] xor hc1[ii];
      hf[ii]:=newA; hc[ii]:=newB;
      hf1[ii]:=old; hc1[ii]:=old1;
      end;
    end;
  end;
hk:=nn;
end;

function GcdU(const va,vb:TVec; var vg,vu,vv:TVec; hi:longint):longint;
var r0a,r1a,u0a,u1a,v0a,v1a:TVec;
var r0,r1,u0,u1,v0,v1,tt:PVec;
var kr0,kr1,ku0,ku1,kv0,kv1,shift,p,top,lim:longint;
begin
r0:=@r0a; r1:=@r1a; u0:=@u0a; u1:=@u1a; v0:=@v0a; v1:=@v1a;
for p:=0 to hi do
  begin
  r0^[p]:=va[p]; r1^[p]:=vb[p];
  u0^[p]:=false; u1^[p]:=false;
  v0^[p]:=false; v1^[p]:=false;
  end;
u0^[0]:=true;
v1^[0]:=true;
kr0:=PolyDeg(r0^,hi);
kr1:=PolyDeg(r1^,hi);
ku0:=0; ku1:=-1;
kv0:=-1; kv1:=0;
while true do
  begin
  if kr0<kr1 then
    begin
    tt:=r0; r0:=r1; r1:=tt;
    tt:=u0; u0:=u1; u1:=tt;
    tt:=v0; v0:=v1; v1:=tt;
    p:=kr0; kr0:=kr1; kr1:=p;
    p:=ku0; ku0:=ku1; ku1:=p;
    p:=kv0; kv0:=kv1; kv1:=p;
    end;
  if kr1<0 then
    begin
    VecCopyHi(vg,r0^,hi);
    VecCopyHi(vu,u0^,hi);
    VecCopyHi(vv,v0^,hi);
    GcdU:=kr0;
    exit;
    end;
  while kr0>=kr1 do
    begin
    shift:=kr0-kr1;
    for p:=0 to kr1 do if r1^[p] then r0^[p+shift]:=not r0^[p+shift];
    top:=kr0-1;
    while (top>=0) and not(r0^[top]) do dec(top);
    kr0:=top;
    if ku1>=0 then
      begin
      top:=ku0;
      if ku1+shift>top then top:=ku1+shift;
      if top>hi then top:=hi;
      lim:=ku1;
      if lim>hi-shift then lim:=hi-shift;
      for p:=0 to lim do if u1^[p] then u0^[p+shift]:=not u0^[p+shift];
      while (top>=0) and not(u0^[top]) do dec(top);
      ku0:=top;
      end;
    if kv1>=0 then
      begin
      top:=kv0;
      if kv1+shift>top then top:=kv1+shift;
      if top>hi then top:=hi;
      lim:=kv1;
      if lim>hi-shift then lim:=hi-shift;
      for p:=0 to lim do if v1^[p] then v0^[p+shift]:=not v0^[p+shift];
      while (top>=0) and not(v0^[top]) do dec(top);
      kv0:=top;
      end;
    end;
  end;
end;

procedure ApplyPolyU(const va,vsrc:TVec; var vdst:TVec; hi,degmax:longint);
var cur0,cur1:TVec;
var pcur,pnxt,pt:PVec;
var k2,d,j2:longint;
begin
for k2:=-2 to hi+1 do begin cur0[k2]:=false; cur1[k2]:=false; vdst[k2]:=false; end;
for k2:=0 to hi do cur0[k2]:=vsrc[k2];
d:=PolyDeg(va,degmax);
if d<0 then exit;
pcur:=@cur0;
pnxt:=@cur1;
for j2:=0 to d do
  begin
  if va[j2] then for k2:=0 to hi do vdst[k2]:=vdst[k2] xor pcur^[k2];
  if j2>=d then break;
  pcur^[-2]:=false; pcur^[-1]:=false; pcur^[hi+1]:=false;
  if hi=0 then
    pnxt^[0]:=false
  else
    begin
    pnxt^[0]:=pcur^[0] xor pcur^[1];
    if hi>=2 then pnxt^[0]:=pnxt^[0] xor pcur^[2];
    for k2:=1 to hi-1 do
      pnxt^[k2]:=pcur^[k2-2] xor pcur^[k2-1] xor pcur^[k2+1] xor pcur^[k2+2];
    pnxt^[hi]:=pcur^[hi] xor pcur^[hi-1];
    if hi>=2 then pnxt^[hi]:=pnxt^[hi] xor pcur^[hi-2];
    end;
  pnxt^[-2]:=false; pnxt^[-1]:=false; pnxt^[hi+1]:=false;
  pt:=pcur; pcur:=pnxt; pnxt:=pt;
  end;
end;

procedure ApplyBezoutU(const vu,vv,vsrc:TVec; var vdst:TVec; hi,degmax:longint);
var cur0,cur1:TVec;
var pcur,pnxt,pt:PVec;
var k2,d,du,dv,j2:longint;
begin
for k2:=-2 to hi+1 do begin cur0[k2]:=false; cur1[k2]:=false; vdst[k2]:=false; end;
for k2:=0 to hi do cur0[k2]:=vsrc[k2];
du:=PolyDeg(vu,degmax);
dv:=PolyDeg(vv,degmax);
if du>dv then d:=du else d:=dv;
if d<0 then exit;
pcur:=@cur0;
pnxt:=@cur1;
for j2:=0 to d do
  begin
  pcur^[-2]:=false; pcur^[-1]:=false; pcur^[hi+1]:=false;
  if vv[j2] and vu[j2] then
    for k2:=0 to hi do vdst[k2]:=vdst[k2] xor pcur^[k2] xor pcur^[k2-1] xor pcur^[k2+1]
  else if vv[j2] then
    for k2:=0 to hi do vdst[k2]:=vdst[k2] xor pcur^[k2]
  else if vu[j2] then
    for k2:=0 to hi do vdst[k2]:=vdst[k2] xor pcur^[k2-1] xor pcur^[k2+1];
  if j2>=d then break;
  if hi=0 then
    pnxt^[0]:=false
  else
    begin
    pnxt^[0]:=pcur^[0] xor pcur^[1];
    if hi>=2 then pnxt^[0]:=pnxt^[0] xor pcur^[2];
    for k2:=1 to hi-1 do
      pnxt^[k2]:=pcur^[k2-2] xor pcur^[k2-1] xor pcur^[k2+1] xor pcur^[k2+2];
    pnxt^[hi]:=pcur^[hi] xor pcur^[hi-1];
    if hi>=2 then pnxt^[hi]:=pnxt^[hi] xor pcur^[hi-2];
    end;
  pnxt^[-2]:=false; pnxt^[-1]:=false; pnxt^[hi+1]:=false;
  pt:=pcur; pcur:=pnxt; pnxt:=pt;
  end;
end;

procedure ApplyCU(const va,vb,vsrc:TVec; var vdst:TVec; hi,degmax:longint);
var cur0,cur1:TVec;
var pcur,pnxt,pt:PVec;
var k2,d,da,db,j2:longint;
begin
for k2:=-2 to hi+1 do begin cur0[k2]:=false; cur1[k2]:=false; vdst[k2]:=false; end;
for k2:=0 to hi do cur0[k2]:=vsrc[k2];
da:=PolyDeg(va,degmax);
db:=PolyDeg(vb,degmax);
if da>db then d:=da else d:=db;
if d<0 then exit;
pcur:=@cur0;
pnxt:=@cur1;
for j2:=0 to d do
  begin
  pcur^[-2]:=false; pcur^[-1]:=false; pcur^[hi+1]:=false;
  if va[j2] then for k2:=0 to hi do vdst[k2]:=vdst[k2] xor pcur^[k2];
  if vb[j2] then for k2:=0 to hi do vdst[k2]:=vdst[k2] xor pcur^[k2] xor pcur^[k2-1] xor pcur^[k2+1];
  if j2>=d then break;
  if hi=0 then
    pnxt^[0]:=false
  else
    begin
    pnxt^[0]:=pcur^[0] xor pcur^[1];
    if hi>=2 then pnxt^[0]:=pnxt^[0] xor pcur^[2];
    for k2:=1 to hi-1 do
      pnxt^[k2]:=pcur^[k2-2] xor pcur^[k2-1] xor pcur^[k2+1] xor pcur^[k2+2];
    pnxt^[hi]:=pcur^[hi] xor pcur^[hi-1];
    if hi>=2 then pnxt^[hi]:=pnxt^[hi] xor pcur^[hi-2];
    end;
  pnxt^[-2]:=false; pnxt^[-1]:=false; pnxt^[hi+1]:=false;
  pt:=pcur; pcur:=pnxt; pnxt:=pt;
  end;
end;

procedure CalcMat2;
var gu,qu,qv:TVec;
var sa,sb,hu,su,sv:TVec;
var v,z:TVec;
var g0,g1,g2:TVec;
var pg0,pg1,pg2,pt:PVec;
var i0,r0,rU,jmax,row1,row2,row3,l0,l1,l2,r1,r2:longint;
var m2,hiS,rr,du,dv:longint;
begin
TimeMark('c');
TimeMark('q');
if (n and 1)=0 then
  begin
  m2:=longint(n div 2);
  EnsureAB(m2);
  hiS:=m2 div 2;
  for i:=0 to longint(n div 2) do
    begin
    gu[i]:=false; qu[i]:=false; qv[i]:=false;
    end;
  for i:=0 to hiS do
    begin
    sa[i]:=hf[i] xor hf1[i];
    sb[i]:=hc[i] xor hc1[i];
    end;
  rr:=GcdU(sa,sb,hu,su,sv,hiS);
  for i:=0 to rr do if hu[i] then gu[i shl 1]:=true;
  du:=PolyDeg(su,hiS);
  for i:=0 to du do if su[i] then
    begin
    qu[i shl 1]:=true;
    if (i shl 1)+1<=longint(n div 2) then qv[(i shl 1)+1]:=not qv[(i shl 1)+1];
    end;
  dv:=PolyDeg(sv,hiS);
  for i:=0 to dv do if sv[i] then qv[i shl 1]:=not qv[i shl 1];
  rU:=rr shl 1;
  end
else
  rU:=GcdU(f,c,gu,qu,qv,longint(n div 2));
r0:=rU*2;
TimeMark('z');
ApplyBezoutU(qu,qv,y,z,n-1,longint(n div 2));
TimeMark('d');
if r0=0 then
  begin
  for i:=0 to n-1 do x[i]:=z[i];
  end
else
begin
for i:=-2 to n do begin g0[i]:=false; g1[i]:=false; g2[i]:=false; v[i]:=false; end;
v[0]:=true;
ApplyPolyU(gu,v,g0,n-1,rU);
TimeMark('x');
pg0:=@g0; pg1:=@g1; pg2:=@g2;
if n-r0-1<0 then jmax:=0 else jmax:=n-r0-1;
if jmax=0 then VecCopyHi(pg1^,pg0^,longint(n))
else if r0<jmax then
  begin
  for i:=-2 to n do v[i]:=false;
  for i:=0 to n-1 do v[i]:=pg0^[i-1] xor pg0^[i+1];
  for i:=-2 to n do begin pg1^[i]:=false; pg2^[i]:=false; end;
  for i:=0 to n-1 do begin pg1^[i]:=pg0^[n-1-i]; pg2^[i]:=v[n-1-i]; end;
  for j:=1 to r0 do
    begin
    for i:=-2 to n do pg0^[i]:=false;
    for i:=0 to n-1 do pg0^[i]:=pg1^[i] xor pg2^[i-1] xor pg2^[i+1];
    pt:=pg0; pg0:=pg1; pg1:=pg2; pg2:=pt;
    end;
  end
else
  begin
  VecCopyHi(pg1^,pg0^,longint(n));
  for j:=1 to jmax do
    begin
    for i:=-2 to n do pg0^[i]:=false;
    for i:=0 to n-1 do pg0^[i]:=pg1^[i-1] xor pg1^[i+1] xor pg2^[i];
    pt:=pg0; pg0:=pg2; pg2:=pg1; pg1:=pt;
    end;
  end;
for i:=0 to n-1 do x[i]:=false;
row1:=n-1;
row2:=n-2;
if r0<=n-1 then
for i:=n-1 downto r0 do
  begin
  l1:=row1-(r0 shl 1); if l1<0 then l1:=0; r1:=row1; if r1>longint(n)-1 then r1:=longint(n)-1;
  if z[i] then
    begin
    i0:=i-r0;
    for j:=l1 to r1 do z[j]:=z[j] xor pg1^[j];
    x[i0]:=true;
    end;
  if i>r0 then
    begin
    l2:=row2-(r0 shl 1); if l2<0 then l2:=0; r2:=row2;
    row3:=row2-1;
    l0:=row3-(r0 shl 1); if l0<0 then l0:=0;
    for j:=l0 to row3 do
      pg0^[j]:=(((j>=l1) and (j<=r1)) and pg1^[j]) xor
               (((j-1>=l2) and (j-1<=r2)) and pg2^[j-1]) xor
               (((j+1>=l2) and (j+1<=r2)) and pg2^[j+1]);
    pt:=pg0; pg0:=pg1; pg1:=pg2; pg2:=pt;
    row1:=row2;
    row2:=row3;
    end;
  end;
end;
end;

function GeneMat():boolean;
var t:TVec;
begin
TimeMark('g');
ApplyCU(f,c,x,t,n-1,longint(n div 2));
GeneMat:=true;
for i:=0 to n-1 do GeneMat:=GeneMat and (t[i]=y[i]);
write(GeneMat);
end;

begin
{$ifdef disp}
CreateWin(m,m);
bb:=CreateBB(GetWin());
bp:=CreateBMP(m,m);
{$endif}
QueryPerformanceFrequency(perfFreq);
QueryPerformanceCounter(lastCounter);
hasLastCounter:=false;
{$ifdef disp}
for n:=1 to m do
{$else}
for n:=9900 to 10000 do
{$endif}
  begin
  write(n,#9);
  MakeMat();
  CalcMat2();
  GeneMat();{$ifdef disp}write('%');SaveMat('_T2');{$endif}
  {$ifdef disp}if not(iswin()) then halt;{$endif}
  writeln();
  end;
end.
