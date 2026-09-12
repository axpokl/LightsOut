program diandeng;

{$mode objfpc}{$H+}

{ H78: use six products for three-block non-power-of-two multiplication leaves. }
{ Shared GF(2) formulas and coefficient blocks; B stores 32 coefficients per LongWord. }

const m=2000;

type TVec=array[-2..m]of boolean;
     PVec=^TVec;
     TFCBool=array of boolean;

var n:longword;
var i,j:longint;
var x,y,f,f1,c,c1:TVec;
var hf,hf1,hc,hc1:TVec;
var uKernel8:array[0..255,0..28] of boolean;



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

procedure XorI(var dst:TVec; const src:TVec; hi:longint); inline;
var k2,k4:longint;
begin
k2:=0;
k4:=hi-3;
while k2<=k4 do
  begin
  dst[k2]:=dst[k2] xor src[k2];
  dst[k2+1]:=dst[k2+1] xor src[k2+1];
  dst[k2+2]:=dst[k2+2] xor src[k2+2];
  dst[k2+3]:=dst[k2+3] xor src[k2+3];
  inc(k2,4);
  end;
while k2<=hi do
  begin
  dst[k2]:=dst[k2] xor src[k2];
  inc(k2);
  end;
end;

procedure XorH(var dst:TVec; const src:TVec; hi:longint); inline;
var k2,k4:longint;
begin
k2:=0;
k4:=hi-3;
while k2<=k4 do
  begin
  dst[k2]:=dst[k2] xor src[k2-1] xor src[k2+1];
  dst[k2+1]:=dst[k2+1] xor src[k2] xor src[k2+2];
  dst[k2+2]:=dst[k2+2] xor src[k2+1] xor src[k2+3];
  dst[k2+3]:=dst[k2+3] xor src[k2+2] xor src[k2+4];
  inc(k2,4);
  end;
while k2<=hi do
  begin
  dst[k2]:=dst[k2] xor src[k2-1] xor src[k2+1];
  inc(k2);
  end;
end;

procedure XorIH(var dst:TVec; const src:TVec; hi:longint); inline;
var k2,k4:longint;
begin
k2:=0;
k4:=hi-3;
while k2<=k4 do
  begin
  dst[k2]:=dst[k2] xor src[k2] xor src[k2-1] xor src[k2+1];
  dst[k2+1]:=dst[k2+1] xor src[k2+1] xor src[k2] xor src[k2+2];
  dst[k2+2]:=dst[k2+2] xor src[k2+2] xor src[k2+1] xor src[k2+3];
  dst[k2+3]:=dst[k2+3] xor src[k2+3] xor src[k2+2] xor src[k2+4];
  inc(k2,4);
  end;
while k2<=hi do
  begin
  dst[k2]:=dst[k2] xor src[k2] xor src[k2-1] xor src[k2+1];
  inc(k2);
  end;
end;

procedure AdvanceU(const src:TVec; var dst:TVec; hi:longint); inline;
var k2,k4:longint;
begin
if hi=0 then
  dst[0]:=false
else
  begin
  dst[0]:=src[0] xor src[1];
  if hi>=2 then dst[0]:=dst[0] xor src[2];
  k2:=1;
  k4:=hi-4;
  while k2<=k4 do
    begin
    dst[k2]:=src[k2-2] xor src[k2-1] xor src[k2+1] xor src[k2+2];
    dst[k2+1]:=src[k2-1] xor src[k2] xor src[k2+2] xor src[k2+3];
    dst[k2+2]:=src[k2] xor src[k2+1] xor src[k2+3] xor src[k2+4];
    dst[k2+3]:=src[k2+1] xor src[k2+2] xor src[k2+4] xor src[k2+5];
    inc(k2,4);
    end;
  while k2<=hi-1 do
    begin
    dst[k2]:=src[k2-2] xor src[k2-1] xor src[k2+1] xor src[k2+2];
    inc(k2);
    end;
  dst[hi]:=src[hi] xor src[hi-1];
  if hi>=2 then dst[hi]:=dst[hi] xor src[hi-2];
  end;
end;


procedure AdvanceUXorI(const src:TVec; var dst,next:TVec; hi:longint); inline;
var k2,k4:longint;
begin
if hi=0 then
  begin
  dst[0]:=dst[0] xor src[0];
  next[0]:=false;
  end
else
  begin
  dst[0]:=dst[0] xor src[0];
  next[0]:=src[0] xor src[1];
  if hi>=2 then next[0]:=next[0] xor src[2];
  k2:=1;
  k4:=hi-4;
  while k2<=k4 do
    begin
    dst[k2]:=dst[k2] xor src[k2];
    next[k2]:=src[k2-2] xor src[k2-1] xor src[k2+1] xor src[k2+2];
    dst[k2+1]:=dst[k2+1] xor src[k2+1];
    next[k2+1]:=src[k2-1] xor src[k2] xor src[k2+2] xor src[k2+3];
    dst[k2+2]:=dst[k2+2] xor src[k2+2];
    next[k2+2]:=src[k2] xor src[k2+1] xor src[k2+3] xor src[k2+4];
    dst[k2+3]:=dst[k2+3] xor src[k2+3];
    next[k2+3]:=src[k2+1] xor src[k2+2] xor src[k2+4] xor src[k2+5];
    inc(k2,4);
    end;
  while k2<=hi-1 do
    begin
    dst[k2]:=dst[k2] xor src[k2];
    next[k2]:=src[k2-2] xor src[k2-1] xor src[k2+1] xor src[k2+2];
    inc(k2);
    end;
  dst[hi]:=dst[hi] xor src[hi];
  next[hi]:=src[hi] xor src[hi-1];
  if hi>=2 then next[hi]:=next[hi] xor src[hi-2];
  end;
end;

procedure AdvanceUXorH(const src:TVec; var dst,next:TVec; hi:longint); inline;
var k2,k4:longint;
var h:boolean;
begin
if hi=0 then
  next[0]:=false
else
  begin
  h:=src[1];
  dst[0]:=dst[0] xor h;
  next[0]:=src[0] xor h;
  if hi>=2 then next[0]:=next[0] xor src[2];
  k2:=1;
  k4:=hi-4;
  while k2<=k4 do
    begin
    h:=src[k2-1] xor src[k2+1];
    dst[k2]:=dst[k2] xor h;
    next[k2]:=h xor src[k2-2] xor src[k2+2];
    h:=src[k2] xor src[k2+2];
    dst[k2+1]:=dst[k2+1] xor h;
    next[k2+1]:=h xor src[k2-1] xor src[k2+3];
    h:=src[k2+1] xor src[k2+3];
    dst[k2+2]:=dst[k2+2] xor h;
    next[k2+2]:=h xor src[k2] xor src[k2+4];
    h:=src[k2+2] xor src[k2+4];
    dst[k2+3]:=dst[k2+3] xor h;
    next[k2+3]:=h xor src[k2+1] xor src[k2+5];
    inc(k2,4);
    end;
  while k2<=hi-1 do
    begin
    h:=src[k2-1] xor src[k2+1];
    dst[k2]:=dst[k2] xor h;
    next[k2]:=h xor src[k2-2] xor src[k2+2];
    inc(k2);
    end;
  h:=src[hi-1];
  dst[hi]:=dst[hi] xor h;
  next[hi]:=src[hi] xor h;
  if hi>=2 then next[hi]:=next[hi] xor src[hi-2];
  end;
end;

procedure AdvanceUXorIH(const src:TVec; var dst,next:TVec; hi:longint); inline;
var k2,k4:longint;
var h:boolean;
begin
if hi=0 then
  begin
  dst[0]:=dst[0] xor src[0];
  next[0]:=false;
  end
else
  begin
  h:=src[1];
  dst[0]:=dst[0] xor src[0] xor h;
  next[0]:=src[0] xor h;
  if hi>=2 then next[0]:=next[0] xor src[2];
  k2:=1;
  k4:=hi-4;
  while k2<=k4 do
    begin
    h:=src[k2-1] xor src[k2+1];
    dst[k2]:=dst[k2] xor src[k2] xor h;
    next[k2]:=h xor src[k2-2] xor src[k2+2];
    h:=src[k2] xor src[k2+2];
    dst[k2+1]:=dst[k2+1] xor src[k2+1] xor h;
    next[k2+1]:=h xor src[k2-1] xor src[k2+3];
    h:=src[k2+1] xor src[k2+3];
    dst[k2+2]:=dst[k2+2] xor src[k2+2] xor h;
    next[k2+2]:=h xor src[k2] xor src[k2+4];
    h:=src[k2+2] xor src[k2+4];
    dst[k2+3]:=dst[k2+3] xor src[k2+3] xor h;
    next[k2+3]:=h xor src[k2+1] xor src[k2+5];
    inc(k2,4);
    end;
  while k2<=hi-1 do
    begin
    h:=src[k2-1] xor src[k2+1];
    dst[k2]:=dst[k2] xor src[k2] xor h;
    next[k2]:=h xor src[k2-2] xor src[k2+2];
    inc(k2);
    end;
  h:=src[hi-1];
  dst[hi]:=dst[hi] xor src[hi] xor h;
  next[hi]:=src[hi] xor h;
  if hi>=2 then next[hi]:=next[hi] xor src[hi-2];
  end;
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

procedure BuildYFast(var dy_,dy:TVec; const sy_,sy_1,sy,sy1:TVec; deg:longint); inline;
var ii,half:longint;
begin
dy_[-2]:=false; dy_[-1]:=false; dy[-2]:=false; dy[-1]:=false;
for ii:=0 to deg-1 do
  dy_[ii]:=sy_[ii-1] xor sy_[ii] xor sy_[ii+1] xor sy_1[ii];
dy_[deg]:=sy_[deg-1] xor sy_[deg];
half:=deg div 2;
for ii:=0 to half do
  begin
  dy[ii]:=not(sy[ii-2] xor sy[ii-1] xor sy[ii] xor sy1[ii-2] xor
              dy_[ii] xor sy_1[ii-1]);
  end;
if half+1<=deg then dy[half+1]:=dy[deg-half-1];
dy_[deg+1]:=false;
dy[deg+1]:=false;
end;

procedure ExpandPalindrome(var a:TVec; deg:longint);
var ii:longint;
begin
if deg<0 then exit;
for ii:=(deg div 2)+1 to deg do a[ii]:=a[deg-ii];
a[deg+1]:=false;
end;

procedure DoubleFCDyn(nn:longword; const af,ac,af1,ac1:TFCBool;
                      var nf,nc,nf1,nc1:TFCBool);
var ii,hi0,e0,o0:longint;
begin
hi0:=longint(nn div 2);
SetLength(nf,hi0+1); SetLength(nc,hi0+1);
SetLength(nf1,hi0+1); SetLength(nc1,hi0+1);
if (nn and 1)=0 then
  begin
  for ii:=0 to High(af) do
    begin
    e0:=ii shl 1; o0:=e0+1;
    if e0<=hi0 then
      begin
      nf[e0]:=af[ii] xor af1[ii];
      nc[e0]:=ac[ii] xor ac1[ii];
      nc1[e0]:=af1[ii] xor ac1[ii];
      end;
    if o0<=hi0 then
      begin
      nf[o0]:=ac[ii] xor ac1[ii];
      nf1[o0]:=ac1[ii];
      nc1[o0]:=ac1[ii];
      end;
    end;
  end
else
  begin
  for ii:=0 to High(af) do
    begin
    e0:=ii shl 1; o0:=e0+1;
    if e0<=hi0 then
      begin
      nc[e0]:=af[ii] xor ac[ii];
      nf1[e0]:=af[ii] xor af1[ii];
      nc1[e0]:=ac[ii] xor ac1[ii];
      end;
    if o0<=hi0 then
      begin
      nf[o0]:=ac[ii];
      nc[o0]:=ac[ii];
      nf1[o0]:=ac[ii] xor ac1[ii];
      end;
    end;
  end;
end;

procedure BuildFCDyn(nn:longword; var nf,nc,nf1,nc1:TFCBool);
var af,ac,af1,ac1:TFCBool;
begin
if nn=0 then
  begin
  SetLength(nf,1); SetLength(nc,1);
  SetLength(nf1,1); SetLength(nc1,1);
  nf[0]:=true;
  exit;
  end;
BuildFCDyn(nn div 2,af,ac,af1,ac1);
DoubleFCDyn(nn,af,ac,af1,ac1,nf,nc,nf1,nc1);
end;

procedure CopyFCDyn(var dst:TVec; const src:TFCBool; hi:longint); inline;
var ii:longint;
begin
VecZeroHi(dst,hi+1);
for ii:=0 to High(src) do dst[ii]:=src[ii];
end;

procedure BuildFCPairsFast(nn:longword; var nf,nc,nf1,nc1,hf0,hc0,hf10,hc10:TVec);
var df,dc,df1,dc1,dhf,dhc,dhf1,dhc1:TFCBool;
var hi0,hhi:longint;
begin
BuildFCDyn(nn div 2,dhf,dhc,dhf1,dhc1);
if nn=0 then
  begin
  df:=dhf; dc:=dhc; df1:=dhf1; dc1:=dhc1;
  end
else
  DoubleFCDyn(nn,dhf,dhc,dhf1,dhc1,df,dc,df1,dc1);
hi0:=longint(nn div 2); hhi:=longint((nn div 2) div 2);
CopyFCDyn(nf,df,hi0); CopyFCDyn(nc,dc,hi0);
CopyFCDyn(nf1,df1,hi0); CopyFCDyn(nc1,dc1,hi0);
CopyFCDyn(hf0,dhf,hhi); CopyFCDyn(hc0,dhc,hhi);
CopyFCDyn(hf10,dhf1,hhi); CopyFCDyn(hc10,dhc1,hhi);
end;

procedure DoubleFCVec(nn:longword; const af,ac,af1,ac1:TVec;
                      var nf,nc,nf1,nc1:TVec; srcHi:longint);
var ii,hi0,e0,o0:longint;
begin
hi0:=longint(nn div 2);
if (nn and 1)=0 then
  begin
  for ii:=0 to srcHi do
    begin
    e0:=ii shl 1; o0:=e0+1;
    if e0<=hi0 then
      begin
      nf[e0]:=af[ii] xor af1[ii];
      nc[e0]:=ac[ii] xor ac1[ii];
      nf1[e0]:=false;
      nc1[e0]:=af1[ii] xor ac1[ii];
      end;
    if o0<=hi0 then
      begin
      nf[o0]:=ac[ii] xor ac1[ii];
      nc[o0]:=false;
      nf1[o0]:=ac1[ii];
      nc1[o0]:=ac1[ii];
      end;
    end;
  end
else
  begin
  for ii:=0 to srcHi do
    begin
    e0:=ii shl 1; o0:=e0+1;
    if e0<=hi0 then
      begin
      nf[e0]:=false;
      nc[e0]:=af[ii] xor ac[ii];
      nf1[e0]:=af[ii] xor af1[ii];
      nc1[e0]:=ac[ii] xor ac1[ii];
      end;
    if o0<=hi0 then
      begin
      nf[o0]:=ac[ii];
      nc[o0]:=ac[ii];
      nf1[o0]:=ac[ii] xor ac1[ii];
      nc1[o0]:=false;
      end;
    end;
  end;
nf[-2]:=false; nf[-1]:=false; nf[hi0+1]:=false;
nc[-2]:=false; nc[-1]:=false; nc[hi0+1]:=false;
nf1[-2]:=false; nf1[-1]:=false; nf1[hi0+1]:=false;
nc1[-2]:=false; nc1[-1]:=false; nc1[hi0+1]:=false;
end;

procedure BuildFCPairsIter(nn:longword; var nf,nc,nf1,nc1,hf0,hc0,hf10,hc10:TVec);
var pf,pc,pf1,pc1,pnf,pnc,pnf1,pnc1,pt:PVec;
var halfN,curN,targetN,bitMask,t0:longword;
var levels,curHi:longint;
begin
halfN:=nn div 2;
levels:=0; t0:=halfN;
while t0<>0 do
  begin
  inc(levels);
  t0:=t0 shr 1;
  end;
if (levels and 1)=0 then
  begin
  pf:=@hf0; pc:=@hc0; pf1:=@hf10; pc1:=@hc10;
  pnf:=@nf; pnc:=@nc; pnf1:=@nf1; pnc1:=@nc1;
  end
else
  begin
  pf:=@nf; pc:=@nc; pf1:=@nf1; pc1:=@nc1;
  pnf:=@hf0; pnc:=@hc0; pnf1:=@hf10; pnc1:=@hc10;
  end;
pf^[0]:=true; pc^[0]:=false; pf1^[0]:=false; pc1^[0]:=false;
curN:=0; curHi:=0;
if halfN=0 then bitMask:=0
else
  begin
  bitMask:=1;
  while bitMask<=(halfN shr 1) do bitMask:=bitMask shl 1;
  end;
while bitMask<>0 do
  begin
  targetN:=curN shl 1;
  if (halfN and bitMask)<>0 then inc(targetN);
  DoubleFCVec(targetN,pf^,pc^,pf1^,pc1^,pnf^,pnc^,pnf1^,pnc1^,curHi);
  pt:=pf; pf:=pnf; pnf:=pt;
  pt:=pc; pc:=pnc; pnc:=pt;
  pt:=pf1; pf1:=pnf1; pnf1:=pt;
  pt:=pc1; pc1:=pnc1; pnc1:=pt;
  curN:=targetN;
  curHi:=longint(curN div 2);
  bitMask:=bitMask shr 1;
  end;
DoubleFCVec(nn,pf^,pc^,pf1^,pc1^,pnf^,pnc^,pnf1^,pnc1^,curHi);
end;

procedure ApplyUComboOnes(const va,vb:TVec; var vdst:TVec; hi,degmax:longint); forward;

procedure ApplyFibonacciOnes(var dst:TVec; degree:longint); forward;

procedure MakeMat();
begin

BuildFCPairsIter(n,f,c,f1,c1,hf,hc,hf1,hc1);
ApplyFibonacciOnes(y,longint(n));
write('A ');for i:=0 to n div 2 do if f[i] then write(1) else write(0);writeln;
write('B ');for i:=0 to n div 2 do if c[i] then write(1) else write(0);writeln;
end;

type TDynBool=array of boolean;

type TMul16Bool=array[0..15] of boolean;
     TMul32Bool=array[0..31] of boolean;
     TMul64Bool=array[0..63] of boolean;
var mul8Bool:array[0..65535] of TMul16Bool;
procedure InitMul8;
var a0,b0,k0,j0:longint;
begin
FillChar(mul8Bool,SizeOf(mul8Bool),0);
for a0:=0 to 255 do for b0:=0 to 255 do
  for k0:=0 to 7 do if ((b0 shr k0) and 1)<>0 then
    for j0:=0 to 7 do
      mul8Bool[(a0 shl 8) or b0,k0+j0]:=mul8Bool[(a0 shl 8) or b0,k0+j0] xor (((a0 shr j0) and 1)<>0);
end;
procedure CLMul16Bool(a0,a1,b0,b1:longint; out p:TMul32Bool); inline;
var x,y,z,i:longint;
begin
x:=(a0 shl 8) or b0; y:=(a1 shl 8) or b1;
z:=((a0 xor a1) shl 8) or (b0 xor b1);
for i:=0 to 7 do
  begin
  p[i]:=mul8Bool[x,i];
  p[8+i]:=mul8Bool[x,8+i] xor mul8Bool[x,i] xor mul8Bool[z,i] xor mul8Bool[y,i];
  p[16+i]:=mul8Bool[y,i] xor mul8Bool[x,8+i] xor mul8Bool[z,8+i] xor mul8Bool[y,8+i];
  p[24+i]:=mul8Bool[y,8+i];
  end;
end;
procedure CLMul32Bool(const a:array of boolean; ao,alen:longint;
                      const b:array of boolean; bo,blen:longint; out p:TMul64Bool; skipZero:boolean=false);
var av,bv:array[0..3] of longint;
var z0,z1,z2:TMul32Bool; i,j,k:longint;
begin
for i:=0 to 3 do
  begin
  av[i]:=0; bv[i]:=0;
  for j:=0 to 7 do
    begin
    k:=i*8+j;
    if k<alen then av[i]:=av[i] or (ord(a[ao+k]) shl j);
    if k<blen then bv[i]:=bv[i] or (ord(b[bo+k]) shl j);
    end;
  end;
if skipZero and (((av[0] or av[1] or av[2] or av[3])=0) or ((bv[0] or bv[1] or bv[2] or bv[3])=0)) then
  begin FillChar(p,SizeOf(p),0); exit; end;
CLMul16Bool(av[0],av[1],bv[0],bv[1],z0);
CLMul16Bool(av[2],av[3],bv[2],bv[3],z2);
CLMul16Bool(av[0] xor av[2],av[1] xor av[3],bv[0] xor bv[2],bv[1] xor bv[3],z1);
for i:=0 to 15 do
  begin
  p[i]:=z0[i]; p[16+i]:=z0[16+i] xor z0[i] xor z1[i] xor z2[i];
  p[32+i]:=z2[i] xor z0[16+i] xor z1[16+i] xor z2[16+i]; p[48+i]:=z2[16+i];
  end;
end;
procedure MulBaseBool(const a:array of boolean; ao,alen:longint;
                      const b:array of boolean; bo,blen:longint;
                      var r:array of boolean; ro,lim:longint; skipZero:boolean=true);
var i,j,k,na,nb,last:longint; p:TMul64Bool;
begin
for i:=0 to (alen+31) div 32-1 do
  for j:=0 to (blen+31) div 32-1 do
    begin
    last:=lim-(i+j)*32;
    if last<=0 then break;
    if last>64 then last:=64;
    na:=alen-i*32; nb:=blen-j*32;
    CLMul32Bool(a,ao+i*32,na,b,bo+j*32,nb,p,skipZero);
    for k:=0 to last-1 do r[ro+(i+j)*32+k]:=r[ro+(i+j)*32+k] xor p[k];
    end;
end;


procedure MulBasePairBool(const a:TDynBool; ao,alen:longint;
                          const b:TDynBool; bo,blen:longint; const c:TDynBool; co,clen:longint;
                          var r:TDynBool; ro:longint; var s:TDynBool; so,lim:longint);
var i,j,na,nb,nc,last,lb,lc,common:longint;
begin
for i:=0 to (alen+31) div 32-1 do
  begin
  na:=alen-i*32; if na>32 then na:=32;
  lb:=(blen+31) div 32; lc:=(clen+31) div 32;
  last:=(lim+31) div 32-i;
  if lb>last then lb:=last; if lc>last then lc:=last;
  common:=lb; if lc<common then common:=lc;
  for j:=0 to common-1 do
    begin
    nb:=blen-j*32; if nb>32 then nb:=32;
    nc:=clen-j*32; if nc>32 then nc:=32;
    last:=lim-(i+j)*32; if last>64 then last:=64;
    MulBaseBool(a,ao+i*32,na,b,bo+j*32,nb,r,ro+(i+j)*32,last);
    MulBaseBool(a,ao+i*32,na,c,co+j*32,nc,s,so+(i+j)*32,last);
    end;
  for j:=common to lb-1 do
    begin
    nb:=blen-j*32; if nb>32 then nb:=32;
    last:=lim-(i+j)*32; if last>64 then last:=64;
    MulBaseBool(a,ao+i*32,na,b,bo+j*32,nb,r,ro+(i+j)*32,last);
    end;
  for j:=common to lc-1 do
    begin
    nc:=clen-j*32; if nc>32 then nc:=32;
    last:=lim-(i+j)*32; if last>64 then last:=64;
    MulBaseBool(a,ao+i*32,na,c,co+j*32,nc,s,so+(i+j)*32,last);
    end;
  end;
end;

{ H73: fuse a 64-coefficient Karatsuba product inside the fixed leaf. }
procedure KarLeaf64(const a:array of boolean; ao:longint; const b:array of boolean; bo:longint;
                    var r:array of boolean; ro:longint);
var z0,z1,z2:TMul64Bool;
var ax,bx:array[0..31] of boolean;
var i0:longint;
begin
FillChar(z0,SizeOf(z0),0); FillChar(z1,SizeOf(z1),0); FillChar(z2,SizeOf(z2),0);
for i0:=0 to 31 do
  begin ax[i0]:=a[ao+i0] xor a[ao+32+i0]; bx[i0]:=b[bo+i0] xor b[bo+32+i0]; end;
CLMul32Bool(a,ao,32,b,bo,32,z0,true);
CLMul32Bool(a,ao+32,32,b,bo+32,32,z2,true);
CLMul32Bool(ax,0,32,bx,0,32,z1,true);
for i0:=0 to 63 do z1[i0]:=z1[i0] xor z0[i0] xor z2[i0];
for i0:=0 to 31 do
  begin
  r[ro+i0]:=r[ro+i0] xor z0[i0];
  r[ro+32+i0]:=r[ro+32+i0] xor z0[32+i0] xor z1[i0];
  r[ro+64+i0]:=r[ro+64+i0] xor z2[i0] xor z1[32+i0];
  r[ro+96+i0]:=r[ro+96+i0] xor z2[32+i0];
  end;
end;

{ H77: combine four 64-coefficient products into three. }
procedure KarLeaf128(const a:array of boolean; ao:longint; const b:array of boolean; bo:longint;
                     var r:array of boolean; ro:longint);
var z0,z1,z2:array[0..127] of boolean;
var ax,bx:array[0..63] of boolean;
var i0:longint;
begin
FillChar(z0,SizeOf(z0),0); FillChar(z1,SizeOf(z1),0); FillChar(z2,SizeOf(z2),0);
for i0:=0 to 63 do
  begin ax[i0]:=a[ao+i0] xor a[ao+64+i0]; bx[i0]:=b[bo+i0] xor b[bo+64+i0]; end;
KarLeaf64(a,ao,b,bo,z0,0);
KarLeaf64(a,ao+64,b,bo+64,z2,0);
KarLeaf64(ax,0,bx,0,z1,0);
for i0:=0 to 127 do z1[i0]:=z1[i0] xor z0[i0] xor z2[i0];
for i0:=0 to 63 do
  begin
  r[ro+i0]:=r[ro+i0] xor z0[i0];
  r[ro+64+i0]:=r[ro+64+i0] xor z0[64+i0] xor z1[i0];
  r[ro+128+i0]:=r[ro+128+i0] xor z2[i0] xor z1[64+i0];
  r[ro+192+i0]:=r[ro+192+i0] xor z2[64+i0];
  end;
end;

{ H73: convolution core with fused 64-coefficient leaves. }
procedure Mul64Assign(const a:array of boolean; ao:longint; const b:array of boolean; bo:longint;
                    var r:array of boolean; ro:longint);
var z0,z1,z2:TMul64Bool;
var ax,bx:array[0..31] of boolean;
var i0:longint;
begin
for i0:=0 to 31 do
  begin ax[i0]:=a[ao+i0] xor a[ao+32+i0]; bx[i0]:=b[bo+i0] xor b[bo+32+i0]; end;
CLMul32Bool(a,ao,32,b,bo,32,z0,true);
CLMul32Bool(a,ao+32,32,b,bo+32,32,z2,true);
CLMul32Bool(ax,0,32,bx,0,32,z1,true);
for i0:=0 to 63 do z1[i0]:=z1[i0] xor z0[i0] xor z2[i0];
for i0:=0 to 31 do
  begin
  r[ro+i0]:=z0[i0];
  r[ro+32+i0]:=z0[32+i0] xor z1[i0];
  r[ro+64+i0]:=z2[i0] xor z1[32+i0];
  r[ro+96+i0]:=z2[32+i0];
  end;
end;

{ H78: three 64-coefficient blocks use six products. }
procedure KarLeaf192(const a:TDynBool; ao:longint; const b:TDynBool; bo:longint;
                     var r:TDynBool; ro,alen,blen:longint);
var p0,p1,p2,p01,p02,p12:array[0..127] of boolean;
var at,bt,ax,bx:TMul64Bool; w:TMul64Bool;
var i,last,lim:longint;
begin
FillChar(at,SizeOf(at),0); FillChar(bt,SizeOf(bt),0);
for i:=0 to alen-129 do at[i]:=a[ao+128+i];
for i:=0 to blen-129 do bt[i]:=b[bo+128+i];
Mul64Assign(a,ao,b,bo,p0,0); Mul64Assign(a,ao+64,b,bo+64,p1,0);
if (alen<=160) and (blen<=160) then
  begin
  CLMul32Bool(at,0,alen-128,bt,0,blen-128,w,true);
  for i:=0 to 63 do begin p2[i]:=w[i]; p2[i+64]:=false; end;
  end
else Mul64Assign(at,0,bt,0,p2,0);
for i:=0 to 63 do begin ax[i]:=a[ao+i] xor a[ao+64+i]; bx[i]:=b[bo+i] xor b[bo+64+i]; end;
Mul64Assign(ax,0,bx,0,p01,0);
for i:=0 to 63 do begin ax[i]:=a[ao+i] xor at[i]; bx[i]:=b[bo+i] xor bt[i]; end;
Mul64Assign(ax,0,bx,0,p02,0);
for i:=0 to 63 do begin ax[i]:=a[ao+64+i] xor at[i]; bx[i]:=b[bo+64+i] xor bt[i]; end;
Mul64Assign(ax,0,bx,0,p12,0);
lim:=alen+blen-1;
for i:=0 to 127 do
  begin
  p01[i]:=p01[i] xor p0[i] xor p1[i];
  p02[i]:=p02[i] xor p0[i] xor p2[i] xor p1[i];
  p12[i]:=p12[i] xor p1[i] xor p2[i];
  end;
for i:=0 to 63 do
  begin
  r[ro+i]:=r[ro+i] xor p0[i];
  r[ro+64+i]:=r[ro+64+i] xor p0[64+i] xor p01[i];
  r[ro+128+i]:=r[ro+128+i] xor p01[64+i] xor p02[i];
  r[ro+192+i]:=r[ro+192+i] xor p02[64+i] xor p12[i];
  end;
last:=lim-256; if last>64 then last:=64;
for i:=0 to last-1 do r[ro+256+i]:=r[ro+256+i] xor p12[64+i] xor p2[i];
for i:=0 to lim-321 do r[ro+320+i]:=r[ro+320+i] xor p2[64+i];
end;

procedure KarConv(const a:TDynBool; ao:longint; const b:TDynBool; bo:longint;
                 var r:TDynBool; ro,lenWords,alen,blen:longint;
                 var work:TDynBool; wo:longint);
const cut=8;
var afull,bfull,a128,b128,startB,tail:longint;
var i0,j0,lenBits,hWords,gWords,h,g,ax0,bx0,z10,rec0:longint;
var a0len,a1len,b0len,b1len,axlen,bxlen:longint;
var mid0:boolean;
begin
lenBits:=lenWords shl 5;
if alen>lenBits then alen:=lenBits;
if blen>lenBits then blen:=lenBits;
if (alen<=0) or (blen<=0) then exit;
if (alen>128) and (blen>128) and (alen<=192) and (blen<=192) then
  begin KarLeaf192(a,ao,b,bo,r,ro,alen,blen); exit; end;
if lenWords<=cut then
  begin
  afull:=(alen div 64)*64; bfull:=(blen div 64)*64;
  a128:=(alen div 128)*128; b128:=(blen div 128)*128;
  for i0:=0 to a128 div 128-1 do for j0:=0 to b128 div 128-1 do
    KarLeaf128(a,ao+i0*128,b,bo+j0*128,r,ro+(i0+j0)*128);
  for i0:=0 to afull div 64-1 do for j0:=0 to bfull div 64-1 do
    if (i0*64>=a128) or (j0*64>=b128) then KarLeaf64(a,ao+i0*64,b,bo+j0*64,r,ro+(i0+j0)*64);
  for i0:=0 to (alen+31) div 32-1 do
    begin
    if i0*32<afull then startB:=bfull else startB:=0;
    tail:=alen-i0*32; if tail>32 then tail:=32;
    if startB<blen then
      MulBaseBool(a,ao+i0*32,tail,b,bo+startB,blen-startB,r,ro+i0*32+startB,alen+blen-i0*32-startB-1);
    end;
  exit;
  end;
hWords:=(lenWords+1) shr 1;
gWords:=lenWords-hWords;
h:=hWords shl 5;
g:=gWords shl 5;
if alen>h then begin a0len:=h; a1len:=alen-h; end
else begin a0len:=alen; a1len:=0; end;
if blen>h then begin b0len:=h; b1len:=blen-h; end
else begin b0len:=blen; b1len:=0; end;
if (a1len=0) and (b1len=0) then
  begin
  KarConv(a,ao,b,bo,r,ro,hWords,a0len,b0len,work,wo);
  exit;
  end;
KarConv(a,ao,b,bo,r,ro,hWords,a0len,b0len,work,wo);
KarConv(a,ao+h,b,bo+h,r,ro+(h shl 1),gWords,a1len,b1len,work,wo);
ax0:=wo; bx0:=wo+h; z10:=wo+(h shl 1); rec0:=wo+(h shl 2);
for i0:=0 to g-1 do
  begin
  work[ax0+i0]:=a[ao+i0] xor a[ao+h+i0];
  work[bx0+i0]:=b[bo+i0] xor b[bo+h+i0];
  end;
for i0:=g to h-1 do
  begin
  work[ax0+i0]:=a[ao+i0];
  work[bx0+i0]:=b[bo+i0];
  end;
for i0:=0 to (h shl 1)-1 do work[z10+i0]:=false;
axlen:=a0len; if a1len>axlen then axlen:=a1len;
bxlen:=b0len; if b1len>bxlen then bxlen:=b1len;
KarConv(work,ax0,work,bx0,work,z10,hWords,axlen,bxlen,work,rec0);
{ Share the overlap XOR before writing either middle block. }
for i0:=0 to (g shl 1)-h-1 do
  begin
  mid0:=r[ro+h+i0] xor r[ro+(h shl 1)+i0];
  r[ro+h+i0]:=mid0 xor r[ro+i0] xor work[z10+i0];
  r[ro+(h shl 1)+i0]:=mid0 xor r[ro+h*3+i0] xor work[z10+h+i0];
  end;
for i0:=(g shl 1)-h to h-1 do
  begin
  mid0:=r[ro+h+i0] xor r[ro+(h shl 1)+i0];
  r[ro+h+i0]:=mid0 xor r[ro+i0] xor work[z10+i0];
  r[ro+(h shl 1)+i0]:=mid0 xor work[z10+h+i0];
  end;
end;

procedure KarRec(const a:TDynBool; ao:longint; const b:TDynBool; bo:longint;
                 var r:TDynBool; ro,lenWords,alen,blen:longint;
                 var work:TDynBool; wo:longint);
const cut=8;
var i0,lenBits,hWords,gWords,h,g,ax0,bx0,z10,rec0:longint;
var a0len,a1len,b0len,b1len,axlen,bxlen:longint;
var mid0:boolean;
begin
lenBits:=lenWords shl 5;
if alen>lenBits then alen:=lenBits;
if blen>lenBits then blen:=lenBits;
if (alen<=0) or (blen<=0) then exit;
if lenWords<=cut then
  begin
  KarConv(a,ao,b,bo,r,ro,lenWords,alen,blen,work,wo);
  exit;
  end;
hWords:=(lenWords+1) shr 1;
gWords:=lenWords-hWords;
h:=hWords shl 5;
g:=gWords shl 5;
if alen>h then begin a0len:=h; a1len:=alen-h; end
else begin a0len:=alen; a1len:=0; end;
if blen>h then begin b0len:=h; b1len:=blen-h; end
else begin b0len:=blen; b1len:=0; end;
if (a1len=0) and (b1len=0) then
  begin
  KarRec(a,ao,b,bo,r,ro,hWords,a0len,b0len,work,wo);
  exit;
  end;
KarRec(a,ao,b,bo,r,ro,hWords,a0len,b0len,work,wo);
KarRec(a,ao+h,b,bo+h,r,ro+(h shl 1),gWords,a1len,b1len,work,wo);
ax0:=wo; bx0:=wo+h; z10:=wo+(h shl 1); rec0:=wo+(h shl 2);
for i0:=0 to g-1 do
  begin
  work[ax0+i0]:=a[ao+i0] xor a[ao+h+i0];
  work[bx0+i0]:=b[bo+i0] xor b[bo+h+i0];
  end;
for i0:=g to h-1 do
  begin
  work[ax0+i0]:=a[ao+i0];
  work[bx0+i0]:=b[bo+i0];
  end;
for i0:=0 to (h shl 1)-1 do work[z10+i0]:=false;
axlen:=a0len; if a1len>axlen then axlen:=a1len;
bxlen:=b0len; if b1len>bxlen then bxlen:=b1len;
KarRec(work,ax0,work,bx0,work,z10,hWords,axlen,bxlen,work,rec0);
{ Share the overlap XOR before writing either middle block. }
for i0:=0 to (g shl 1)-h-1 do
  begin
  mid0:=r[ro+h+i0] xor r[ro+(h shl 1)+i0];
  r[ro+h+i0]:=mid0 xor r[ro+i0] xor work[z10+i0];
  r[ro+(h shl 1)+i0]:=mid0 xor r[ro+h*3+i0] xor work[z10+h+i0];
  end;
for i0:=(g shl 1)-h to h-1 do
  begin
  mid0:=r[ro+h+i0] xor r[ro+(h shl 1)+i0];
  r[ro+h+i0]:=mid0 xor r[ro+i0] xor work[z10+i0];
  r[ro+(h shl 1)+i0]:=mid0 xor work[z10+h+i0];
  end;
end;

procedure KarLow(const a:TDynBool; ao:longint; const b:TDynBool; bo:longint;
                 var r:TDynBool; ro,alen,blen,lim:longint;
                 var work:TDynBool; wo:longint);
const cut=8;
var lenWords,hWords,h,a0len,b0len,k,i0,rec0,top:longint;
begin
if alen>lim then alen:=lim;
if blen>lim then blen:=lim;
if (lim<=0) or (alen<=0) or (blen<=0) then exit;
top:=alen; if blen>top then top:=blen;
if lim>=alen+blen-1 then
  begin
  KarRec(a,ao,b,bo,r,ro,(top+31) shr 5,alen,blen,work,wo);
  exit;
  end;
lenWords:=(lim+31) shr 5;
if lenWords<=cut then
  begin
  MulBaseBool(a,ao,alen,b,bo,blen,r,ro,lim);
  exit;
  end;
hWords:=(lenWords+1) shr 1; h:=hWords shl 5;
a0len:=alen; if a0len>h then a0len:=h;
b0len:=blen; if b0len>h then b0len:=h;
KarRec(a,ao,b,bo,r,ro,hWords,a0len,b0len,work,wo);
k:=lim-h; rec0:=wo+(h shl 1);
if blen>h then
  begin
  FillChar(work[wo],h*2,0);
  KarLow(a,ao,b,bo+h,work,wo,a0len,blen-h,k,work,rec0);
  for i0:=0 to k-1 do r[ro+h+i0]:=r[ro+h+i0] xor work[wo+i0];
  end;
if alen>h then
  begin
  FillChar(work[wo],h*2,0);
  KarLow(a,ao+h,b,bo,work,wo,alen-h,b0len,k,work,rec0);
  for i0:=0 to k-1 do r[ro+h+i0]:=r[ro+h+i0] xor work[wo+i0];
  end;
end;

procedure KarMul(const a,b:TDynBool; var r:TDynBool;
                 lenWords,alen,blen:longint);
var work:TDynBool;
var i0,lenBits:longint;
begin
lenBits:=lenWords shl 5;
SetLength(r,lenBits shl 1);
for i0:=0 to High(r) do r[i0]:=false;
SetLength(work,lenBits*5);
KarConv(a,0,b,0,r,0,lenWords,alen,blen,work,0);
end;

procedure KarRecPair(const a:TDynBool; ao:longint;
                     const b:TDynBool; bo:longint;
                     const c:TDynBool; co:longint;
                     var r:TDynBool; ro:longint;
                     var s:TDynBool; so,lenWords,alen,blen,clen:longint;
                     var work:TDynBool; wo:longint);
const cut=8;
var i0,lenBits,hWords,gWords,h,g,ax0,bx0,cx0,zr0,zs0,rec0:longint;
var a0len,a1len,b0len,b1len,c0len,c1len,axlen,bxlen,cxlen:longint;
var mid0,mid1:boolean;
begin
lenBits:=lenWords shl 5;
if alen>lenBits then alen:=lenBits;
if blen>lenBits then blen:=lenBits;
if clen>lenBits then clen:=lenBits;
if (alen<=0) or ((blen<=0) and (clen<=0)) then exit;
if lenWords<=cut then
  begin
  KarConv(a,ao,b,bo,r,ro,lenWords,alen,blen,work,wo);
  KarConv(a,ao,c,co,s,so,lenWords,alen,clen,work,wo);
  exit;
  end;
hWords:=(lenWords+1) shr 1;
gWords:=lenWords-hWords;
h:=hWords shl 5;
g:=gWords shl 5;
if alen>h then begin a0len:=h; a1len:=alen-h; end
else begin a0len:=alen; a1len:=0; end;
if blen>h then begin b0len:=h; b1len:=blen-h; end
else begin b0len:=blen; b1len:=0; end;
if clen>h then begin c0len:=h; c1len:=clen-h; end
else begin c0len:=clen; c1len:=0; end;
if (a1len=0) and (b1len=0) and (c1len=0) then
  begin
  KarRecPair(a,ao,b,bo,c,co,r,ro,s,so,hWords,a0len,b0len,c0len,work,wo);
  exit;
  end;
KarRecPair(a,ao,b,bo,c,co,r,ro,s,so,hWords,a0len,b0len,c0len,work,wo);
KarRecPair(a,ao+h,b,bo+h,c,co+h,r,ro+(h shl 1),s,so+(h shl 1),gWords,
           a1len,b1len,c1len,work,wo);
ax0:=wo; bx0:=wo+h; cx0:=wo+(h shl 1);
zr0:=wo+h*3; zs0:=wo+h*5;
rec0:=wo+h*7;
for i0:=0 to g-1 do
  begin
  work[ax0+i0]:=a[ao+i0] xor a[ao+h+i0];
  work[bx0+i0]:=b[bo+i0] xor b[bo+h+i0];
  work[cx0+i0]:=c[co+i0] xor c[co+h+i0];
  end;
for i0:=g to h-1 do
  begin
  work[ax0+i0]:=a[ao+i0];
  work[bx0+i0]:=b[bo+i0];
  work[cx0+i0]:=c[co+i0];
  end;
for i0:=0 to (h shl 1)-1 do
  begin
  work[zr0+i0]:=false;
  work[zs0+i0]:=false;
  end;
axlen:=a0len; if a1len>axlen then axlen:=a1len;
bxlen:=b0len; if b1len>bxlen then bxlen:=b1len;
cxlen:=c0len; if c1len>cxlen then cxlen:=c1len;
KarRecPair(work,ax0,work,bx0,work,cx0,
           work,zr0,work,zs0,hWords,axlen,bxlen,cxlen,work,rec0);
{ Share the overlap XOR before writing either middle block. }
for i0:=0 to (g shl 1)-h-1 do
  begin
  mid0:=r[ro+h+i0] xor r[ro+(h shl 1)+i0];
  r[ro+h+i0]:=mid0 xor r[ro+i0] xor work[zr0+i0];
  r[ro+(h shl 1)+i0]:=mid0 xor r[ro+h*3+i0] xor work[zr0+h+i0];
  mid1:=s[so+h+i0] xor s[so+(h shl 1)+i0];
  s[so+h+i0]:=mid1 xor s[so+i0] xor work[zs0+i0];
  s[so+(h shl 1)+i0]:=mid1 xor s[so+h*3+i0] xor work[zs0+h+i0];
  end;
for i0:=(g shl 1)-h to h-1 do
  begin
  mid0:=r[ro+h+i0] xor r[ro+(h shl 1)+i0];
  r[ro+h+i0]:=mid0 xor r[ro+i0] xor work[zr0+i0];
  r[ro+(h shl 1)+i0]:=mid0 xor work[zr0+h+i0];
  mid1:=s[so+h+i0] xor s[so+(h shl 1)+i0];
  s[so+h+i0]:=mid1 xor s[so+i0] xor work[zs0+i0];
  s[so+(h shl 1)+i0]:=mid1 xor work[zs0+h+i0];
  end;
end;

procedure KarMulPair(const a,b,c:TDynBool; var r,s:TDynBool;
                     lenWords,alen,blen,clen:longint);
var work:TDynBool;
var i0,lenBits:longint;
begin
lenBits:=lenWords shl 5;
SetLength(r,lenBits shl 1);
SetLength(s,lenBits shl 1);
for i0:=0 to High(r) do
  begin
  r[i0]:=false;
  s[i0]:=false;
  end;
SetLength(work,lenBits*10);
KarRecPair(a,0,b,0,c,0,r,0,s,0,lenWords,alen,blen,clen,work,0);
end;

type
  THBuffer=array[0..m*128+1024] of boolean;
  PHBuffer=^THBuffer;
  THPoly=record
    v:PHBuffer; cap:longint;
    d:longint;
  end;
  THMat=record
    p00,p01,p10,p11:THPoly;
  end;

{ Fixed recursion leaf: degree <= 2048, identical in A/B. }
const hgcdCut=2048;
      divCut=64;

var qPool,qA,qB,qC,qR,qS,qWork:TDynBool;
var qTop,qPeak:longint;

procedure HPAlloc(out a:THPoly; count:longint); inline;
begin
a.d:=-1; a.cap:=count;
if count<=0 then begin a.v:=nil; exit; end;
if qTop+count>Length(qPool) then Halt(217);
a.v:=PHBuffer(@qPool[qTop]);
FillChar(a.v^[0],count*SizeOf(boolean),0);
inc(qTop,count); if qTop>qPeak then qPeak:=qTop;
end;

procedure HPMoveInto(const src:THPoly; var dst:THPoly); inline;
begin
if src.cap>dst.cap then Halt(218);
if src.cap>0 then Move(src.v^[0],dst.v^[0],src.cap*SizeOf(boolean));
dst.d:=src.d; dst.cap:=src.cap;
end;

procedure HPZero(out a:THPoly); inline;
begin
HPAlloc(a,0);
a.d:=-1;
end;

procedure HPOne(out a:THPoly); inline;
begin
HPAlloc(a,1);
a.v^[0]:=true;
a.d:=0;
end;

procedure HPCopy(const a:THPoly; out b:THPoly); inline;
begin
b:=a;
end;

procedure HPCopyDeep(const a:THPoly; out b:THPoly); inline;
var i0:longint;
begin
HPAlloc(b,a.cap); b.d:=a.d;
for i0:=0 to (a.cap-1) do b.v^[i0]:=a.v^[i0];
end;

procedure HPNorm(var a:THPoly);
begin
a.d:=a.cap-1;
while (a.d>=0) and not a.v^[a.d] do dec(a.d);
if a.d<0 then a.cap:=0
else a.cap:=a.d+1;
end;

procedure HPFromVec(const a:TVec; hi:longint; out b:THPoly);
var i0,degree:longint;
begin
degree:=PolyDeg(a,hi);
if degree<0 then begin HPZero(b); exit; end;
HPAlloc(b,degree+1);
b.d:=degree;
for i0:=0 to degree do b.v^[i0]:=a[i0];
end;

procedure HPToVec(const a:THPoly; var b:TVec; hi:longint);
var i0,lim:longint;
begin
VecZeroHi(b,hi);
lim:=a.d;
if lim>hi then lim:=hi;
for i0:=0 to lim do b[i0]:=a.v^[i0];
end;

procedure HPAdd(const a,b:THPoly; out c:THPoly);
var i0,lim:longint;
begin
lim:=a.d;
if b.d>lim then lim:=b.d;
if lim<0 then begin HPZero(c); exit; end;
HPAlloc(c,lim+1);
for i0:=0 to lim do
  begin
  c.v^[i0]:=false;
  if i0<=a.d then c.v^[i0]:=a.v^[i0];
  if i0<=b.d then c.v^[i0]:=c.v^[i0] xor b.v^[i0];
  end;
c.d:=lim;
HPNorm(c);
end;

procedure HPTrunc(const a:THPoly; out c:THPoly; lim:longint);
var i0,top:longint;
begin
top:=a.d;
if top>=lim then top:=lim-1;
if top<0 then begin HPZero(c); exit; end;
HPAlloc(c,top+1);
for i0:=0 to top do c.v^[i0]:=a.v^[i0];
c.d:=top;
HPNorm(c);
end;

procedure HPShiftDown(const a:THPoly; sh:longint; out c:THPoly);
var i0,top:longint;
begin
top:=a.d-sh;
if top<0 then begin HPZero(c); exit; end;
HPAlloc(c,top+1);
for i0:=0 to top do c.v^[i0]:=a.v^[i0+sh];
c.d:=top;
end;

procedure HPMul(const a,b:THPoly; out c:THPoly);
var lenWords,lenBits,i0,top:longint;
begin
if (a.d<0) or (b.d<0) then begin HPZero(c); exit; end;
if a.d=0 then begin HPCopy(b,c); exit; end;
if b.d=0 then begin HPCopy(a,c); exit; end;
if (a.d<32) or (b.d<32) then
  begin
  if a.d>b.d then begin HPMul(b,a,c); exit; end;
  top:=a.d+b.d; HPAlloc(c,top+1);
  for i0:=0 to top do c.v^[i0]:=false;
  MulBaseBool(a.v^,0,a.d+1,b.v^,0,b.d+1,c.v^,0,top+1,false);
  c.d:=top; exit;
  end;
top:=a.d; if b.d>top then top:=b.d;
lenWords:=(top+32) shr 5;
if lenWords<1 then lenWords:=1;
lenBits:=lenWords shl 5;
FillChar(qA[0],lenBits,0); FillChar(qB[0],lenBits,0);
for i0:=0 to a.d do qA[i0]:=a.v^[i0];
for i0:=0 to b.d do qB[i0]:=b.v^[i0];
FillChar(qR[0],lenBits*2,0);
KarRec(qA,0,qB,0,qR,0,lenWords,a.d+1,b.d+1,qWork,0);
top:=a.d+b.d;
HPAlloc(c,top+1);
for i0:=0 to top do c.v^[i0]:=qR[i0];
c.d:=top;
HPNorm(c);
end;

procedure HPMulPair(const a,b,c:THPoly; out r,s:THPoly);
var lenWords,lenBits,top,i0:longint;
begin
if a.d<0 then begin HPZero(r); HPZero(s); exit; end;
if (a.d<32) or (b.d<32) or (c.d<32) then
  begin HPMul(a,b,r); HPMul(a,c,s); exit; end;
if b.d<0 then begin HPZero(r); HPMul(a,c,s); exit; end;
if c.d<0 then begin HPMul(a,b,r); HPZero(s); exit; end;
top:=a.d; if b.d>top then top:=b.d; if c.d>top then top:=c.d;
lenWords:=(top+32) shr 5;
if lenWords<1 then lenWords:=1;
lenBits:=lenWords shl 5;
FillChar(qA[0],lenBits,0); FillChar(qB[0],lenBits,0); FillChar(qC[0],lenBits,0);
for i0:=0 to a.d do qA[i0]:=a.v^[i0];
for i0:=0 to b.d do qB[i0]:=b.v^[i0];
for i0:=0 to c.d do qC[i0]:=c.v^[i0];
FillChar(qR[0],lenBits*2,0); FillChar(qS[0],lenBits*2,0);
KarRecPair(qA,0,qB,0,qC,0,qR,0,qS,0,lenWords,a.d+1,b.d+1,c.d+1,qWork,0);
top:=a.d+b.d; HPAlloc(r,top+1);
for i0:=0 to top do r.v^[i0]:=qR[i0];
r.d:=top; HPNorm(r);
top:=a.d+c.d; HPAlloc(s,top+1);
for i0:=0 to top do s.v^[i0]:=qS[i0];
s.d:=top; HPNorm(s);
end;

{ Truncated paired products retain the shared-operand work of KarRecPair. }
procedure KarLowPair(const a:TDynBool; ao:longint;
                     const b:TDynBool; bo:longint; const c:TDynBool; co:longint;
                     var r:TDynBool; ro:longint; var s:TDynBool; so:longint;
                     alen,blen,clen,lim:longint; var work:TDynBool; wo:longint);
var lenWords,hWords,h,step,a0len,b0len,c0len,k,i0,top,rec0,s0:longint;
begin
if alen>lim then alen:=lim;
if blen>lim then blen:=lim;
if clen>lim then clen:=lim;
if blen<0 then blen:=0;
if clen<0 then clen:=0;
if (lim<=0) or (alen<=0) or ((blen=0) and (clen=0)) then exit;
top:=blen; if clen>top then top:=clen;
if lim>=alen+top-1 then
  begin
  if alen>top then top:=alen;
  KarRecPair(a,ao,b,bo,c,co,r,ro,s,so,(top+31) shr 5,alen,blen,clen,work,wo);
  exit;
  end;
lenWords:=(lim+31) shr 5;
if lenWords<=8 then
  begin
  MulBasePairBool(a,ao,alen,b,bo,blen,c,co,clen,r,ro,s,so,lim);
  exit;
  end;
hWords:=(lenWords+1) shr 1; h:=hWords shl 5; step:=(hWords shl 5);
a0len:=alen; if a0len>h then a0len:=h;
b0len:=blen; if b0len>h then b0len:=h;
c0len:=clen; if c0len>h then c0len:=h;
KarRecPair(a,ao,b,bo,c,co,r,ro,s,so,hWords,a0len,b0len,c0len,work,wo);
k:=lim-h; s0:=wo+2*step; rec0:=wo+4*step;
if (blen>h) or (clen>h) then
  begin
  FillChar(work[wo],(step*4),0);
  KarLowPair(a,ao,b,bo+step,c,co+step,work,wo,work,s0,a0len,blen-h,clen-h,k,work,rec0);
  for i0:=0 to k-1 do
    begin
    r[ro+step+i0]:=r[ro+step+i0] xor work[wo+i0];
    s[so+step+i0]:=s[so+step+i0] xor work[s0+i0];
    end;
  end;
if alen>h then
  begin
  FillChar(work[wo],(step*4),0);
  KarLowPair(a,ao+step,b,bo,c,co,work,wo,work,s0,alen-h,b0len,c0len,k,work,rec0);
  for i0:=0 to k-1 do
    begin
    r[ro+step+i0]:=r[ro+step+i0] xor work[wo+i0];
    s[so+step+i0]:=s[so+step+i0] xor work[s0+i0];
    end;
  end;
end;

procedure HPMulTrunc(const a,b:THPoly; out c:THPoly; lim:longint);
var alen,blen,lenWords,lenBits,i0:longint;
begin
if (lim<=0) or (a.d<0) or (b.d<0) then begin HPZero(c); exit; end;
if lim>=a.d+b.d+1 then begin HPMul(a,b,c); exit; end;
alen:=a.d+1; if alen>lim then alen:=lim;
blen:=b.d+1; if blen>lim then blen:=lim;
if (alen<32) or (blen<32) or (lim<=256) then
  begin
  if alen>blen then begin HPMulTrunc(b,a,c,lim); exit; end;
  HPAlloc(c,lim);
  MulBaseBool(a.v^,0,alen,b.v^,0,blen,c.v^,0,lim);
  c.d:=lim-1; HPNorm(c); exit;
  end;
lenWords:=(lim+31) shr 5; lenBits:=lenWords shl 5;
FillChar(qA[0],lenBits,0); FillChar(qB[0],lenBits,0);
for i0:=0 to alen-1 do qA[i0]:=a.v^[i0];
for i0:=0 to blen-1 do qB[i0]:=b.v^[i0];
FillChar(qR[0],lenBits*2,0);
KarLow(qA,0,qB,0,qR,0,alen,blen,lim,qWork,0);
HPAlloc(c,lim);
for i0:=0 to lim-1 do c.v^[i0]:=qR[i0];
c.d:=lim-1; HPNorm(c);
end;

procedure HPDivRemClassic(const a,b:THPoly; out q,r:THPoly);
var i0,j0,qd:longint;
begin
if b.d<0 then begin HPZero(q); HPCopy(a,r); exit; end;
HPCopyDeep(a,r);
qd:=a.d-b.d;
if qd<0 then begin HPZero(q); exit; end;
HPAlloc(q,qd+1);
for i0:=0 to qd do q.v^[i0]:=false;
q.d:=qd;
for i0:=a.d downto b.d do
  if (i0<=r.d) and r.v^[i0] then
    begin
    q.v^[i0-b.d]:=true;
    for j0:=0 to b.d do r.v^[i0-b.d+j0]:=r.v^[i0-b.d+j0] xor b.v^[j0];
    end;
HPNorm(q); HPNorm(r);
end;

procedure HPSquareTrunc(const a:THPoly; out b:THPoly; lim:longint);
var i,top:longint;

begin
top:=a.d*2; if top>=lim then top:=lim-1;
if (a.d<0) or (top<0) then begin HPZero(b); exit; end;
HPAlloc(b,top+1);
for i:=0 to top do b.v^[i]:=false;
for i:=0 to top div 2 do b.v^[2*i]:=a.v^[i];
b.d:=top; HPNorm(b);
end;

{ GF(2): if a*g=1 mod x^k, then a*(a*g^2)=1 mod x^(2k). }
procedure HPInvSeries(const a:THPoly; k:longint; out g:THPoly);
var cur,nk:longint;
var sq,fa,ng:THPoly;
begin
if k<=0 then begin HPZero(g); exit; end;
HPAlloc(g,1); g.v^[0]:=true; g.d:=0;
cur:=1;
while cur<k do
  begin
  nk:=cur shl 1;
  if nk>k then nk:=k;
  HPSquareTrunc(g,sq,nk);
  HPTrunc(a,fa,nk);
  HPMulTrunc(fa,sq,ng,nk);
  g:=ng;
  cur:=nk;
  end;
end;

procedure HPDivRemFast(const a,b:THPoly; out q,r:THPoly);
var qlen,i0:longint;
var ra,rb,iv,qr,prod,tmp:THPoly;
begin
qlen:=a.d-b.d+1;
if (b.d<0) or (qlen<=0) then begin HPZero(q); HPCopy(a,r); exit; end;
HPAlloc(ra,qlen);
for i0:=0 to qlen-1 do ra.v^[i0]:=a.v^[a.d-i0];
ra.d:=qlen-1;
HPAlloc(rb,b.d+1);
for i0:=0 to b.d do rb.v^[i0]:=b.v^[b.d-i0];
rb.d:=b.d;
HPInvSeries(rb,qlen,iv);
HPMulTrunc(ra,iv,qr,qlen);
HPAlloc(q,qlen);
for i0:=0 to qlen-1 do
  if qlen-1-i0<=qr.d then q.v^[i0]:=qr.v^[qlen-1-i0]
  else q.v^[i0]:=false;
q.d:=qlen-1;
HPMulTrunc(b,q,prod,b.d);
HPAdd(a,prod,tmp);
HPTrunc(tmp,r,b.d);
HPNorm(q); HPNorm(r);
end;

procedure HPDivRem(const a,b:THPoly; out q,r:THPoly);
begin
if (a.d-b.d+1)>divCut then HPDivRemFast(a,b,q,r)
else HPDivRemClassic(a,b,q,r);
end;

procedure HPMatIdentity(out a:THMat);
begin
HPOne(a.p00); HPZero(a.p01); HPZero(a.p10); HPOne(a.p11);
end;

procedure HPMulPairTrunc(const a,b,c:THPoly; out r,s:THPoly; lim:longint);
var alen,blen,clen,top,words,units,i0:longint;
begin
if lim<=0 then begin HPZero(r); HPZero(s); exit; end;
top:=b.d; if c.d>top then top:=c.d;
if lim>=a.d+top+1 then begin HPMulPair(a,b,c,r,s); exit; end;
if (a.d<32) or (b.d<32) or (c.d<32) then
  begin HPMulTrunc(a,b,r,lim); HPMulTrunc(a,c,s,lim); exit; end;
alen:=a.d+1; if alen>lim then alen:=lim;
blen:=b.d+1; if blen>lim then blen:=lim;
clen:=c.d+1; if clen>lim then clen:=lim;
words:=(lim+31) shr 5; units:=words shl 5;
FillChar(qA[0],units,0); FillChar(qB[0],units,0); FillChar(qC[0],units,0);
for i0:=0 to alen-1 do qA[i0]:=a.v^[i0];
for i0:=0 to blen-1 do qB[i0]:=b.v^[i0];
for i0:=0 to clen-1 do qC[i0]:=c.v^[i0];
FillChar(qR[0],(units*2),0); FillChar(qS[0],(units*2),0);
KarLowPair(qA,0,qB,0,qC,0,qR,0,qS,0,alen,blen,clen,lim,qWork,0);
HPAlloc(r,lim); HPAlloc(s,lim);
for i0:=0 to lim-1 do begin r.v^[i0]:=qR[i0]; s.v^[i0]:=qS[i0]; end;
r.d:=lim-1; s.d:=lim-1;
HPNorm(r); HPNorm(s);
end;

procedure HPMatApply(const a:THMat; const x,y:THPoly; out u,v:THPoly);
var lim:longint;
var t0,t1,t2,t3:THPoly;
begin
{ Euclidean prefix: deg(u) <= deg(x)-deg(a.p11), and deg(v)<deg(u). }
lim:=x.d+1; if a.p11.d>=0 then dec(lim,a.p11.d);
HPMulPairTrunc(x,a.p00,a.p10,t0,t1,lim);
HPMulPairTrunc(y,a.p01,a.p11,t2,t3,lim);
HPAdd(t0,t2,u); HPAdd(t1,t3,v);
end;

procedure HPMatMul(const a,b:THMat; out c:THMat);
var t0,t1,t2,t3,t4,t5,t6,t7:THPoly;
begin
HPMulPair(a.p00,b.p00,b.p01,t0,t1);
HPMulPair(a.p01,b.p10,b.p11,t2,t3);
HPAdd(t0,t2,c.p00); HPAdd(t1,t3,c.p01);
HPMulPair(a.p10,b.p00,b.p01,t4,t5);
HPMulPair(a.p11,b.p10,b.p11,t6,t7);
HPAdd(t4,t6,c.p10); HPAdd(t5,t7,c.p11);
end;

procedure HPMatRightStep(const a:THMat; const q:THPoly; out c:THMat);
var u,v:THPoly;
begin
HPMulPair(q,a.p01,a.p11,u,v);
HPCopy(a.p01,c.p00); HPCopy(a.p11,c.p10);
HPAdd(a.p00,u,c.p01); HPAdd(a.p10,v,c.p11);
end;

{ Leaf elimination uses six fixed buffers, with no allocation per quotient. }
procedure HPLeaf(const a,b:THPoly; target:longint; out g:THPoly; out outmat:THMat);
type TL=array[0..hgcdCut+1] of boolean; PL=^TL;
var ar,br,au,bu,av,bv:TL;
var r0,r1,u0,u1,v0,v1,t:PL;
var d0,d1,du0,du1,dv0,dv1,i,sh,tmp:longint;
procedure XST(var x,y,z:TL; const a,b,c:TL; sh,da,db,dc:longint); inline;
var j,lim:longint;
begin
lim:=da; if db<lim then lim:=db; if dc<lim then lim:=dc;
j:=0;
while j<=lim-3 do
  begin
  x[j+sh]:=x[j+sh] xor a[j]; y[j+sh]:=y[j+sh] xor b[j]; z[j+sh]:=z[j+sh] xor c[j];
  x[j+sh+1]:=x[j+sh+1] xor a[j+1]; y[j+sh+1]:=y[j+sh+1] xor b[j+1]; z[j+sh+1]:=z[j+sh+1] xor c[j+1];
  x[j+sh+2]:=x[j+sh+2] xor a[j+2]; y[j+sh+2]:=y[j+sh+2] xor b[j+2]; z[j+sh+2]:=z[j+sh+2] xor c[j+2];
  x[j+sh+3]:=x[j+sh+3] xor a[j+3]; y[j+sh+3]:=y[j+sh+3] xor b[j+3]; z[j+sh+3]:=z[j+sh+3] xor c[j+3];
  inc(j,4);
  end;
while j<=lim do
  begin
  x[j+sh]:=x[j+sh] xor a[j]; y[j+sh]:=y[j+sh] xor b[j]; z[j+sh]:=z[j+sh] xor c[j]; inc(j);
  end;
j:=lim+1;
while j<=da-3 do
  begin
  x[j+sh]:=x[j+sh] xor a[j];
  x[j+sh+1]:=x[j+sh+1] xor a[j+1];
  x[j+sh+2]:=x[j+sh+2] xor a[j+2];
  x[j+sh+3]:=x[j+sh+3] xor a[j+3];
  inc(j,4);
  end;
while j<=da do begin x[j+sh]:=x[j+sh] xor a[j]; inc(j); end;
j:=lim+1;
while j<=db-3 do
  begin
  y[j+sh]:=y[j+sh] xor b[j];
  y[j+sh+1]:=y[j+sh+1] xor b[j+1];
  y[j+sh+2]:=y[j+sh+2] xor b[j+2];
  y[j+sh+3]:=y[j+sh+3] xor b[j+3];
  inc(j,4);
  end;
while j<=db do begin y[j+sh]:=y[j+sh] xor b[j]; inc(j); end;
j:=lim+1;
while j<=dc-3 do
  begin
  z[j+sh]:=z[j+sh] xor c[j];
  z[j+sh+1]:=z[j+sh+1] xor c[j+1];
  z[j+sh+2]:=z[j+sh+2] xor c[j+2];
  z[j+sh+3]:=z[j+sh+3] xor c[j+3];
  inc(j,4);
  end;
while j<=dc do begin z[j+sh]:=z[j+sh] xor c[j]; inc(j); end;
end;
{ H70: apply the two adjacent quotient terms in one pass. }
{ H71: share the traversal of the three adjacent-term updates. }
procedure XST2(var x,y,z:TL; const a,b,c:TL; sh,da,db,dc:longint); inline;
var j,lim:longint;
begin
lim:=da; if db<lim then lim:=db; if dc<lim then lim:=dc;
if da>=0 then x[sh]:=x[sh] xor a[0];
if db>=0 then y[sh]:=y[sh] xor b[0];
if dc>=0 then z[sh]:=z[sh] xor c[0];
for j:=1 to lim do
  begin
  x[sh+j]:=x[sh+j] xor a[j] xor a[j-1];
  y[sh+j]:=y[sh+j] xor b[j] xor b[j-1];
  z[sh+j]:=z[sh+j] xor c[j] xor c[j-1];
  end;
if lim<0 then lim:=0;
for j:=lim+1 to da do x[sh+j]:=x[sh+j] xor a[j] xor a[j-1];
for j:=lim+1 to db do y[sh+j]:=y[sh+j] xor b[j] xor b[j-1];
for j:=lim+1 to dc do z[sh+j]:=z[sh+j] xor c[j] xor c[j-1];
if da>=0 then x[sh+da+1]:=x[sh+da+1] xor a[da];
if db>=0 then y[sh+db+1]:=y[sh+db+1] xor b[db];
if dc>=0 then z[sh+dc+1]:=z[sh+dc+1] xor c[dc];
end;
{ H71: combine quotient terms separated by one zero. }
procedure XSG(var x:TL; const a:TL; sh,d:longint); inline;
var j:longint;
begin
if d<0 then exit;
x[sh]:=x[sh] xor a[0];
if d>0 then x[sh+1]:=x[sh+1] xor a[1];
for j:=2 to d do x[sh+j]:=x[sh+j] xor a[j] xor a[j-2];
if d>0 then x[sh+d+1]:=x[sh+d+1] xor a[d-1];
x[sh+d+2]:=x[sh+d+2] xor a[d];
end;
procedure Degree(const x:TL; var d:longint); inline;

begin
while (d>=0) and not x[d] do dec(d);
end;
procedure ExportPoly(const x:TL; lim:longint; out z:THPoly);
var j:longint;
begin
HPAlloc(z,lim+1); for j:=0 to lim do z.v^[j]:=x[j]; z.d:=lim; HPNorm(z);
end;
begin
ar:=Default(TL); br:=Default(TL);
au:=Default(TL); bu:=Default(TL);
av:=Default(TL); bv:=Default(TL);
for i:=0 to a.d do ar[i]:=a.v^[i];
for i:=0 to b.d do br[i]:=b.v^[i];
au[0]:=true; bv[0]:=true;
r0:=@ar; r1:=@br; u0:=@au; u1:=@bu; v0:=@av; v1:=@bv;
d0:=a.d; d1:=b.d; du0:=0; du1:=-1; dv0:=-1; dv1:=0;
while (d1>=0) and (d1>=target) do
  begin
  while d0>=d1 do
    begin
    sh:=d0-d1;
    if (sh>0) and (d1>0) and (r0^[d0-1] xor r1^[d1-1]) then
      begin
      XST2(r0^,u0^,v0^,r1^,u1^,v1^,sh-1,d1,du1,dv1);
      dec(d0,2);
      end
    else if (sh>1) and (d1>1) and (r0^[d0-2] xor r1^[d1-2]) then
      begin
      XSG(r0^,r1^,sh-2,d1); XSG(u0^,u1^,sh-2,du1); XSG(v0^,v1^,sh-2,dv1);
      dec(d0,3);
      end
    else
      begin
      XST(r0^,u0^,v0^,r1^,u1^,v1^,sh,d1,du1,dv1);
      dec(d0);
      end;
    Degree(r0^,d0);
    if (du1>=0) and (du1+sh>du0) then du0:=du1+sh;
    if (dv1>=0) and (dv1+sh>dv0) then dv0:=dv1+sh;
    end;
  t:=r0;r0:=r1;r1:=t; tmp:=d0;d0:=d1;d1:=tmp;
  t:=u0;u0:=u1;u1:=t; tmp:=du0;du0:=du1;du1:=tmp;
  t:=v0;v0:=v1;v1:=t; tmp:=dv0;dv0:=dv1;dv1:=tmp;
  end;
ExportPoly(r0^,d0,g);
ExportPoly(u0^,du0,outmat.p00); ExportPoly(v0^,dv0,outmat.p01);
ExportPoly(u1^,du1,outmat.p10); ExportPoly(v1^,dv1,outmat.p11);
end;

procedure HPHalfGCDClassic(const a,b:THPoly; out m0:THMat);
var g:THPoly;
begin HPLeaf(a,b,(a.d+1) div 2,g,m0); end;

{ Reduce the second remainder below half the first degree. }
procedure HPHalfGCD(const a,b:THPoly; out m0:THMat); forward;
procedure HPHalfGCDCore(const a,b:THPoly; out m0:THMat);
var m,mm:longint;
var aa,bb,c,d,q,e,aa2,bb2:THPoly;
var rmat,smat,umat:THMat;
begin
if (b.d<0) or (b.d<(a.d+1) div 2) then begin HPMatIdentity(m0); exit; end;
if a.d<=hgcdCut then begin HPHalfGCDClassic(a,b,m0); exit; end;
m:=(a.d+1) div 2;
HPShiftDown(a,m,aa); HPShiftDown(b,m,bb);
HPHalfGCD(aa,bb,rmat);
HPMatApply(rmat,a,b,c,d);
if (d.d<0) or (d.d<m) then begin m0:=rmat; exit; end;
HPDivRem(c,d,q,e);
mm:=2*m-d.d;
HPShiftDown(d,mm,aa2); HPShiftDown(e,mm,bb2);
HPHalfGCD(aa2,bb2,smat);
HPMatRightStep(smat,q,umat);
HPMatMul(umat,rmat,m0);
end;

procedure HPHalfGCD(const a,b:THPoly; out m0:THMat);
var saved,span:longint; temp:THMat;
begin
span:=((a.d+1) div 2)+2;
HPAlloc(m0.p00,span); HPAlloc(m0.p01,span);
HPAlloc(m0.p10,span); HPAlloc(m0.p11,span);
saved:=qTop;
HPHalfGCDCore(a,b,temp);
HPMoveInto(temp.p00,m0.p00); HPMoveInto(temp.p01,m0.p01);
HPMoveInto(temp.p10,m0.p10); HPMoveInto(temp.p11,m0.p11);
qTop:=saved;
end;

procedure HPXGCDLeaf(const a,b:THPoly; out g,u,v:THPoly);
var h:THMat;
begin
HPLeaf(a,b,0,g,h); u:=h.p00; v:=h.p01;
end;

procedure HPXGCD(const a,b:THPoly; out g,u,v:THPoly); forward;
procedure HPXGCDCore(const a,b:THPoly; out g,u,v:THPoly);
var c,d,q,r,s,t,w,t0,t1,t2,t3:THPoly;
var h:THMat;
begin
if a.d<b.d then begin HPXGCD(b,a,g,v,u); exit; end;
if b.d<0 then begin HPCopy(a,g); HPOne(u); HPZero(v); exit; end;
if a.d<=hgcdCut then begin HPXGCDLeaf(a,b,g,u,v); exit; end;
HPHalfGCD(a,b,h);
HPMatApply(h,a,b,c,d);
if d.d<0 then begin HPCopy(c,g); HPCopy(h.p00,u); HPCopy(h.p01,v); exit; end;
HPDivRem(c,d,q,r);
if r.d<0 then begin HPCopy(d,g); HPCopy(h.p10,u); HPCopy(h.p11,v); exit; end;
HPXGCD(d,r,g,s,t);
HPMul(q,t,t0); HPAdd(s,t0,w);
HPMulPair(t,h.p00,h.p01,t0,t1);
HPMulPair(w,h.p10,h.p11,t2,t3);
HPAdd(t0,t2,u); HPAdd(t1,t3,v);
end;

procedure HPXGCD(const a,b:THPoly; out g,u,v:THPoly);
var saved,span:longint; gg,uu,vv:THPoly;
begin
if a.d<b.d then begin HPXGCD(b,a,g,v,u); exit; end;
span:=a.d+2;
HPAlloc(g,span); HPAlloc(u,span); HPAlloc(v,span); saved:=qTop;
HPXGCDCore(a,b,gg,uu,vv);
HPMoveInto(gg,g); HPMoveInto(uu,u); HPMoveInto(vv,v);
qTop:=saved;
end;

function GcdU(const va,vb:TVec; var vg,vu,vv:TVec; hi:longint):longint;
var a,b,g,u,v:THPoly; size:longint;
begin
size:=((hi*2+96) shr 5) shl 5;
SetLength(qPool,size*128); qTop:=0; qPeak:=0;
SetLength(qA,size); SetLength(qB,size); SetLength(qC,size);
SetLength(qR,size*2); SetLength(qS,size*2); SetLength(qWork,size*10);
HPFromVec(va,hi,a); HPFromVec(vb,hi,b);
HPXGCD(a,b,g,u,v);
HPToVec(g,vg,hi); HPToVec(u,vu,hi); HPToVec(v,vv,hi);
GcdU:=g.d;
end;

procedure BuildUKernel(const coeff:TVec; first,count,degmax:longint; var r:TDynBool);
var h,i0,center,subcenter:longint;
var lo,hi:TDynBool;

procedure ToggleShift(shift:longint);
var p:longint;
begin
for p:=0 to High(hi) do if hi[p] then
  r[center+(p-subcenter)+shift]:=not r[center+(p-subcenter)+shift];
end;

begin
if count=1 then
  begin
  SetLength(r,1);
  if first<=degmax then r[0]:=coeff[first];
  exit;
  end;
h:=count shr 1;
BuildUKernel(coeff,first,h,degmax,lo);
BuildUKernel(coeff,first+h,h,degmax,hi);
SetLength(r,(count shl 2)-3);
center:=(count shl 1)-2;
subcenter:=(h shl 1)-2;
for i0:=0 to High(lo) do if lo[i0] then r[center+(i0-subcenter)]:=true;
ToggleShift(-(h shl 1));
ToggleShift(-h);
ToggleShift(h);
ToggleShift(h shl 1);
end;

procedure InitUKernel8;
var a0,j0,p0:longint;
var basis,nextBasis:array[0..28] of boolean;
begin
for a0:=0 to 255 do
  begin
  for p0:=0 to 28 do
    begin
    uKernel8[a0,p0]:=false;
    basis[p0]:=false;
    end;
  basis[14]:=true;
  for j0:=0 to 7 do
    begin
    if ((a0 shr j0) and 1)<>0 then
      for p0:=0 to 28 do if basis[p0] then
        uKernel8[a0,p0]:=not uKernel8[a0,p0];
    if j0<7 then
      begin
      for p0:=0 to 28 do nextBasis[p0]:=false;
      for p0:=0 to 28 do if basis[p0] then
        begin
        if p0>=2 then nextBasis[p0-2]:=not nextBasis[p0-2];
        if p0>=1 then nextBasis[p0-1]:=not nextBasis[p0-1];
        if p0<=27 then nextBasis[p0+1]:=not nextBasis[p0+1];
        if p0<=26 then nextBasis[p0+2]:=not nextBasis[p0+2];
        end;
      for p0:=0 to 28 do basis[p0]:=nextBasis[p0];
      end;
    end;
  end;
end;

procedure ClearBoolRange(var a:TDynBool; p0,len:longint); inline;
var k0:longint;
begin
for k0:=p0 to p0+len-1 do a[k0]:=false;
end;

procedure XorBoolRange4(var dst:TDynBool; dst0:longint;
                        const src:TDynBool; src0,len,h:longint); inline;
var k0:longint;
begin
for k0:=0 to len-1 do if src[src0+k0] then
  begin
  dst[dst0+k0]:=not dst[dst0+k0];
  dst[dst0+h+k0]:=not dst[dst0+h+k0];
  dst[dst0+h*3+k0]:=not dst[dst0+h*3+k0];
  dst[dst0+(h shl 2)+k0]:=not dst[dst0+(h shl 2)+k0];
  end;
end;

procedure BuildUKernelRecFast(const coeff:TVec; first,count,degmax:longint;
                              var dst:TDynBool; dst0:longint;
                              var work:TDynBool; work0:longint);
var h,childBits,j0,p0,a0:longint;
begin
ClearBoolRange(dst,dst0,(count shl 2)-3);
if count=8 then
  begin
  a0:=0;
  for j0:=0 to 7 do if (first+j0<=degmax) and coeff[first+j0] then
    a0:=a0 or (1 shl j0);
  for p0:=0 to 28 do if uKernel8[a0,p0] then
    dst[dst0+p0]:=not dst[dst0+p0];
  exit;
  end;
h:=count shr 1;
childBits:=(h shl 2)-3;
BuildUKernelRecFast(coeff,first,h,degmax,dst,dst0+(h shl 1),work,work0);
BuildUKernelRecFast(coeff,first+h,h,degmax,work,work0,work,work0+childBits);
XorBoolRange4(dst,dst0,work,work0,childBits,h);
end;

procedure BuildUKernelFast(const coeff:TVec; degmax:longint;
                           var r:TDynBool; var center:longint);
var count,bits:longint;
var work:TDynBool;
begin
count:=8;
while count<=degmax do count:=count shl 1;
bits:=(count shl 2)-3;
SetLength(r,bits);
SetLength(work,count shl 2);
BuildUKernelRecFast(coeff,0,count,degmax,r,0,work,0);
center:=(count shl 1)-2;
end;

{ H69: retain only nonnegative Laurent offsets during recursion. }
{ H75: both representations use a 128-coefficient kernel leaf built from 8-coefficient tables. }
type TKernel64Bool=array[0..63] of boolean;
     TKernel128Bool=array[0..127] of boolean;
procedure UKernel16Bool(aa,bb:longint; var q:TKernel64Bool);
var p:longint;
begin
FillChar(q,SizeOf(q),0);
for p:=0 to 28 do
  begin
  q[p+16]:=q[p+16] xor uKernel8[aa,p];
  if uKernel8[bb,p] then
    begin
    q[p]:=not q[p]; q[p+8]:=not q[p+8];
    q[p+24]:=not q[p+24]; q[p+32]:=not q[p+32];
    end;
  end;
end;
procedure UKernel32Bool(const coeff:TVec; first,degmax:longint; var q:TKernel128Bool);
var index:array[0..3] of longint;
var p,j:longint; p0,p1:TKernel64Bool;
begin
for j:=0 to 3 do
  begin
  index[j]:=0;
  for p:=0 to 7 do if (first+j*8+p<=degmax) and coeff[first+j*8+p] then index[j]:=index[j] or (1 shl p);
  end;
UKernel16Bool(index[0],index[1],p0); UKernel16Bool(index[2],index[3],p1);
FillChar(q,SizeOf(q),0);
for p:=0 to 60 do
  begin
  q[p+32]:=q[p+32] xor p0[p];
  if p1[p] then
    begin
    q[p]:=not q[p]; q[p+16]:=not q[p+16];
    q[p+48]:=not q[p+48]; q[p+64]:=not q[p+64];
    end;
  end;
end;

type TKernel256Bool=array[0..255] of boolean;
procedure UKernel64Bool(const coeff:TVec; first,degmax:longint; var q:TKernel256Bool);
var p:longint; p0,p1:TKernel128Bool;
begin
UKernel32Bool(coeff,first,degmax,p0); UKernel32Bool(coeff,first+32,degmax,p1);
FillChar(q,SizeOf(q),0);
for p:=0 to 124 do
  begin
  q[p+64]:=q[p+64] xor p0[p];
  if p1[p] then
    begin
    q[p]:=not q[p]; q[p+32]:=not q[p+32];
    q[p+96]:=not q[p+96]; q[p+128]:=not q[p+128];
    end;
  end;
end;

type TKernel512Bool=array[0..511] of boolean;
procedure UKernel128Bool(const coeff:TVec; first,degmax:longint; var q:TKernel512Bool);
var p:longint; p0,p1:TKernel256Bool;
begin
UKernel64Bool(coeff,first,degmax,p0); UKernel64Bool(coeff,first+64,degmax,p1);
FillChar(q,SizeOf(q),0);
for p:=0 to 252 do
  begin
  q[p+128]:=q[p+128] xor p0[p];
  if p1[p] then
    begin
    q[p]:=not q[p]; q[p+64]:=not q[p+64];
    q[p+192]:=not q[p+192]; q[p+256]:=not q[p+256];
    end;
  end;
end;

procedure BuildUComboRecFast(const va,vb:TVec; first,count,degmax,mode:longint;
                             var dst:TDynBool; dst0:longint;
                             var work:TDynBool; work0:longint);
var h,g,childBits,p0:longint;
var aa,bb:TKernel512Bool;
begin
ClearBoolRange(dst,dst0,count shl 1);
if count=128 then
  begin
  UKernel128Bool(va,first,degmax,aa); UKernel128Bool(vb,first,degmax,bb);
  if mode=0 then
    for p0:=0 to 255 do dst[dst0+p0]:=aa[253+p0] xor bb[254+p0] xor aa[255+p0]
  else
    for p0:=0 to 255 do dst[dst0+p0]:=bb[253+p0] xor aa[254+p0] xor bb[254+p0] xor bb[255+p0];
  exit;
  end;
h:=128;
while (h shl 1)<count do h:=h shl 1;
g:=count-h; childBits:=g shl 1;
BuildUComboRecFast(va,vb,first,h,degmax,mode,dst,dst0,work,work0);
BuildUComboRecFast(va,vb,first+h,g,degmax,mode,work,work0,work,work0+childBits);
if work[work0] then
  begin dst[dst0+h]:=not dst[dst0+h]; dst[dst0+(h shl 1)]:=not dst[dst0+(h shl 1)]; end;
for p0:=1 to childBits-1 do if work[work0+p0] then
  begin
  dst[dst0+h+p0]:=not dst[dst0+h+p0];
  { The two contributions at offset zero cancel in GF(2). }
  if p0<>h then dst[dst0+abs(h-p0)]:=not dst[dst0+abs(h-p0)];
  dst[dst0+(h shl 1)+p0]:=not dst[dst0+(h shl 1)+p0];
  dst[dst0+(h shl 1)-p0]:=not dst[dst0+(h shl 1)-p0];
  end;
end;

procedure BuildUComboHalfKernel(const va,vb:TVec; degmax,mode:longint;
                                var r:TDynBool);
var count:longint;
var work:TDynBool;
begin
count:=((degmax+128) div 128)*128;
if count<128 then count:=128;
SetLength(r,count shl 1); SetLength(work,(count shl 1)+64);
BuildUComboRecFast(va,vb,0,count,degmax,mode,r,0,work,0);
end;

procedure AddHalfCircularKernel(var dst:TDynBool; const src:TDynBool; period,limit:longint);
var base,p,last,first:longint;
begin
base:=0;
while base<=High(src) do
  begin
  last:=High(src)-base; if last>limit then last:=limit;
  for p:=0 to last do dst[p]:=dst[p] xor src[base+p];
  inc(base,period);
  end;
base:=period;
while base<=High(src)+limit do
  begin
  first:=base-High(src); if first<0 then first:=0;
  for p:=first to limit do dst[p]:=dst[p] xor src[base-p];
  inc(base,period);
  end;
end;


procedure AddCircularKernel(var dst:TDynBool; const src:TDynBool; center,shift,period,limit:longint);
var src0,p0,p1,p:longint;
begin
src0:=center-shift;
while src0>0 do dec(src0,period);
while src0+period<=0 do inc(src0,period);
while src0<=High(src) do
  begin
  p0:=0; if src0<0 then p0:=-src0;
  p1:=limit; if src0+p1>High(src) then p1:=High(src)-src0;
  if p0<=p1 then
    begin
    p:=p0;
    while p<=p1-3 do
      begin
      dst[p]:=dst[p] xor src[src0+p];
      dst[p+1]:=dst[p+1] xor src[src0+p+1];
      dst[p+2]:=dst[p+2] xor src[src0+p+2];
      dst[p+3]:=dst[p+3] xor src[src0+p+3];
      inc(p,4);
      end;
    while p<=p1 do
      begin
      dst[p]:=dst[p] xor src[src0+p];
      inc(p);
      end;
    end;
  inc(src0,period);
  end;
end;

{ For an all-one source the four prefix windows cancel to two kernel bits. }
procedure ApplyUComboOnes(const va,vb:TVec; var vdst:TVec; hi,degmax:longint);
var halfLen,period,convWords,convBits,i0:longint;
var combo,ha:TDynBool;
var bit0:boolean;
begin
halfLen:=hi+2;
period:=halfLen shl 1;
convWords:=(halfLen+32) shr 5;
convBits:=convWords shl 5;
BuildUComboHalfKernel(va,vb,degmax,1,combo);
SetLength(ha,convBits);
AddHalfCircularKernel(ha,combo,period,halfLen);
bit0:=ha[0] xor ha[halfLen];
for i0:=0 to hi do
  vdst[i0]:=ha[i0+1] xor ha[halfLen-i0-1] xor bit0;
vdst[-2]:=false; vdst[-1]:=false; vdst[hi+1]:=false;
end;

{ D=A*B, E=A*reverse(B); all additions below are in GF(2). }
{ C[p]=D[p]+D[2L-p]+E[L-p]+E[L+p]+A[0]B[p]+A[L]B[L-p]. }
{ H71: reflected-source convolution through one half-length product. }
{ H71: convert between P(t+t^-1) and its nonnegative Laurent half. }
{ H75: the four 32-coefficient basis stages match ConvertH32 in B. }
procedure ConvertH32Bool(var a:TDynBool; first:longint; inverse:boolean);
var stage,pass,h,base,j:longint;
begin
for pass:=0 to 3 do
  begin
  if inverse then stage:=3-pass else stage:=pass;
  h:=2 shl stage;
  for base:=0 to 32 div (2*h)-1 do
    for j:=1 to h-1 do
      a[first+base*2*h+h-j]:=a[first+base*2*h+h-j] xor a[first+base*2*h+h+j];
  end;
end;

procedure ConvertH(var a:TDynBool; first,count:longint; inverse:boolean);
var h,g,j:longint;
begin
if count=32 then begin ConvertH32Bool(a,first,inverse); exit; end;
h:=32; while (h shl 1)<count do h:=h shl 1;
g:=count-h;
if not inverse then
  begin
  ConvertH(a,first,h,false); ConvertH(a,first+h,g,false);
  end;
for j:=1 to g-1 do a[first+h-j]:=a[first+h-j] xor a[first+h+j];
if inverse then
  begin
  ConvertH(a,first,h,true); ConvertH(a,first+h,g,true);
  end;
end;

procedure ApplySymmetricHalf(const ha,hb:TDynBool; var dst:TVec; L:longint);
var a,b,pa,pb,p0:TDynBool;
var s,m,words,bits,i:longint; value,constantBit,centerBit:boolean;
begin
s:=(L-1) div 2; m:=L div 2;
words:=(s+32) shr 5; bits:=words shl 5;
SetLength(a,bits); SetLength(b,bits); SetLength(pa,bits); SetLength(pb,bits);
for i:=1 to s do begin a[i]:=ha[i] xor ha[L-i]; b[i]:=hb[i]; end;
for i:=0 to s do begin pa[i]:=a[i]; pb[i]:=b[i]; end;
ConvertH(pa,0,bits,true); ConvertH(pb,0,bits,true);
KarMul(pa,pb,p0,words,s+1,s+1);
ConvertH(p0,0,bits shl 1,false);
constantBit:=ha[0] xor ha[L]; centerBit:=hb[m];
for i:=1 to s do
  begin
  value:=p0[i] xor p0[L-i] xor (constantBit and b[i]);
  if (L and 1)=0 then value:=value xor (centerBit and a[m-i]);
  dst[i-1]:=value; dst[L-i-1]:=value;
  end;
if (L and 1)=0 then dst[m-1]:=constantBit and centerBit;
dst[-2]:=false; dst[-1]:=false; dst[L-1]:=false;
end;

{ H74: F(2k)=F(k)^2+F(k-1)^2; F(2k+1)=(1+t+t^-1)*F(k)^2. }
{ H75: S(2k)=J*S(k)^2+F(k-1)^2; S(2k+1)=J*S(k)^2+F(k)^2. }
{ Store nonnegative Laurent offsets; F(-1)=0, F(0)=1, S(0)=0. }
procedure BuildFibonacciHalfKernel(degree:longint; var r:TDynBool; bits:longint; summed:boolean=false);
var a,b,fa,fb,tmp,ss,fs:TDynBool;
var mask,cur,next,p:longint;
var odd:boolean;
begin
SetLength(a,bits); SetLength(b,bits); SetLength(fa,bits); SetLength(fb,bits);
if summed then begin SetLength(ss,bits); SetLength(fs,bits); end;
a[0]:=true; cur:=0; mask:=1;
while mask<=degree div 2 do mask:=mask shl 1;
while mask>0 do
  begin
  odd:=(degree and mask)<>0; next:=cur*2+ord(odd);
  if summed then
    begin
    FillChar(fs[0],next+1,0);
    for p:=0 to cur do
      begin
      if odd then fs[p*2]:=ss[p] xor a[p] else fs[p*2]:=ss[p] xor b[p];
      if p*2+1<=next then fs[p*2+1]:=ss[p] xor ss[p+1];
      end;
    tmp:=ss; ss:=fs; fs:=tmp;
    if mask=1 then begin r:=ss; exit; end;
    end;
  FillChar(fa[0],next+1,0); FillChar(fb[0],next+1,0);
  for p:=0 to cur do
    if odd then
      begin
      fa[p*2]:=a[p]; fb[p*2]:=a[p] xor b[p];
      if p*2+1<=next then fa[p*2+1]:=a[p] xor a[p+1];
      end
    else
      begin
      fa[p*2]:=a[p] xor b[p]; fb[p*2]:=b[p];
      if p*2+1<=next then fb[p*2+1]:=b[p] xor b[p+1];
      end;
  tmp:=a; a:=fa; fa:=tmp; tmp:=b; b:=fb; fb:=tmp; cur:=next; mask:=mask shr 1;
  end;
r:=a;
end;

procedure ApplyFibonacciOnes(var dst:TVec; degree:longint);
var kernel:TDynBool;
var p,bits:longint; bit0:boolean;
begin
bits:=((degree+33) shr 5) shl 5;
BuildFibonacciHalfKernel(degree,kernel,bits,true);
bit0:=kernel[0];
for p:=0 to degree-1 do dst[p]:=kernel[p+1] xor kernel[degree-p] xor bit0;
dst[-2]:=false; dst[-1]:=false; dst[degree]:=false;
end;

{ H74: mode 2 uses F_(hi+1)(H+I); modes 0/1 use the supplied coefficients. }
procedure ApplyFastUCombo(const va,vb,vsrc:TVec; var vdst:TVec; hi,degmax,mode:longint);
var halfLen,period,convWords,convBits,i0,p:longint;
var combo,ha,hb,hbr,prod0:TDynBool;
var bit0:boolean;
var sameSource:boolean;
begin
halfLen:=hi+2;
period:=halfLen shl 1;
convWords:=(halfLen+32) shr 5;
convBits:=convWords shl 5;
SetLength(ha,convBits); SetLength(hb,convBits);
if mode=2 then BuildFibonacciHalfKernel(hi+1,ha,convBits)
else
  begin
  BuildUComboHalfKernel(va,vb,degmax,mode,combo);
  AddHalfCircularKernel(ha,combo,period,halfLen);
  end;
if mode<>0 then SetLength(hbr,convBits);
for p:=1 to halfLen-1 do
  begin
  hb[p]:=vsrc[p-1];
  if mode<>0 then hbr[halfLen-p]:=vsrc[p-1];
  end;
{ Reuse the identical reflected-source product; compare data, not n. }
sameSource:=true;
if mode<>0 then
  for p:=0 to convBits-1 do
    if hb[p]<>hbr[p] then begin sameSource:=false; break; end;
if sameSource then
  begin
  ApplySymmetricHalf(ha,hb,vdst,halfLen);
  exit;
  end;
{ H72: one full product for a non-symmetric source. }
bit0:=ha[halfLen]; ha[halfLen]:=false;
ConvertH(ha,0,convBits,true); ConvertH(hb,0,convBits,true);
KarMul(ha,hb,prod0,convWords,halfLen,halfLen);
ConvertH(prod0,0,convBits shl 1,false);
for i0:=0 to hi do
  begin
  p:=i0+1;
  vdst[i0]:=prod0[p] xor prod0[period-p] xor (bit0 and hbr[p]);
  end;
vdst[-2]:=false; vdst[-1]:=false; vdst[hi+1]:=false;
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
  if va[j2] then XorI(vdst,pcur^,hi);
  if j2>=d then break;
  pcur^[-2]:=false; pcur^[-1]:=false; pcur^[hi+1]:=false;
  AdvanceU(pcur^,pnxt^,hi);
  pnxt^[-2]:=false; pnxt^[-1]:=false; pnxt^[hi+1]:=false;
  pt:=pcur; pcur:=pnxt; pnxt:=pt;
  end;
end;

procedure ApplyPolyU0(const va:TVec; var vdst:TVec; hi,degmax:longint);
var cur0,cur1:TVec;
var pcur,pnxt,pt:PVec;
var k2,d,j2,curHi,nextHi,maxHi:longint;
begin
d:=PolyDeg(va,degmax);
if (d shl 1)<hi then maxHi:=d shl 1 else maxHi:=hi;
for k2:=-2 to maxHi+1 do begin cur0[k2]:=false; cur1[k2]:=false; end;
for k2:=-2 to hi+1 do vdst[k2]:=false;
if d<0 then exit;
cur0[0]:=true;
pcur:=@cur0;
pnxt:=@cur1;
curHi:=0;
for j2:=0 to d do
  begin
  if va[j2] then XorI(vdst,pcur^,curHi);
  if j2>=d then break;
  nextHi:=curHi+2; if nextHi>hi then nextHi:=hi;
  for k2:=curHi+1 to nextHi+1 do pcur^[k2]:=false;
  AdvanceU(pcur^,pnxt^,nextHi);
  pnxt^[-2]:=false; pnxt^[-1]:=false; pnxt^[nextHi+1]:=false;
  pt:=pcur; pcur:=pnxt; pnxt:=pt;
  curHi:=nextHi;
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
  if j2>=d then
    begin
    if vv[j2] and vu[j2] then XorIH(vdst,pcur^,hi)
    else if vv[j2] then XorI(vdst,pcur^,hi)
    else if vu[j2] then XorH(vdst,pcur^,hi);
    break;
    end;
  if vv[j2] and vu[j2] then AdvanceUXorIH(pcur^,vdst,pnxt^,hi)
  else if vv[j2] then AdvanceUXorI(pcur^,vdst,pnxt^,hi)
  else if vu[j2] then AdvanceUXorH(pcur^,vdst,pnxt^,hi)
  else AdvanceU(pcur^,pnxt^,hi);
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
  if j2>=d then
    begin
    if va[j2] and vb[j2] then XorH(vdst,pcur^,hi)
    else if vb[j2] then XorIH(vdst,pcur^,hi)
    else if va[j2] then XorI(vdst,pcur^,hi);
    break;
    end;
  if va[j2] and vb[j2] then AdvanceUXorH(pcur^,vdst,pnxt^,hi)
  else if vb[j2] then AdvanceUXorIH(pcur^,vdst,pnxt^,hi)
  else if va[j2] then AdvanceUXorI(pcur^,vdst,pnxt^,hi)
  else AdvanceU(pcur^,pnxt^,hi);
  pnxt^[-2]:=false; pnxt^[-1]:=false; pnxt^[hi+1]:=false;
  pt:=pcur; pcur:=pnxt; pnxt:=pt;
  end;
end;

function BuildOddGUV(const ma,mb,mg,mu,mv:TVec; var gu,qu,qv:TVec; hi,srcHi:longint; extra:boolean):boolean;
var tu,tv:TVec;
var p,dg,du,dv,s:longint;
begin
VecZeroHi(gu,hi);
VecZeroHi(qu,hi+1);
VecZeroHi(qv,hi);
VecZeroHi(tu,srcHi);
VecZeroHi(tv,srcHi);
for p:=0 to srcHi do begin tu[p]:=mu[p]; tv[p]:=mv[p]; end;
if (not extra) and (tu[0] xor tv[0]) then
  for p:=0 to srcHi do
    begin
    tu[p]:=tu[p] xor mb[p];
    tv[p]:=tv[p] xor ma[p];
    end;
if (not extra) and (tu[0] xor tv[0]) then
  begin
  BuildOddGUV:=false;
  exit;
  end;
dg:=PolyDeg(mg,srcHi);
if dg>=0 then
  for p:=0 to dg do if mg[p] then
    begin
    s:=p shl 1;
    if extra then inc(s);
    if s<=hi then gu[s]:=not gu[s];
    end;
du:=PolyDeg(tu,srcHi);
dv:=PolyDeg(tv,srcHi);
if extra then
  begin
  if du>=0 then
    for p:=0 to du do if tu[p] then
      begin
      s:=p shl 1;
      if s<=hi then qu[s]:=not qu[s];
      if s+1<=hi then begin qu[s+1]:=not qu[s+1]; qv[s+1]:=not qv[s+1]; end;
      end;
  if dv>=0 then
    for p:=0 to dv do if tv[p] then
      begin
      s:=p shl 1;
      if s<=hi then qu[s]:=not qu[s];
      end;
  end
else
  begin
  if du>=0 then
    for p:=0 to du do if tu[p] then
      begin
      s:=p shl 1;
      if s<=hi+1 then qu[s]:=not qu[s];
      if s+1<=hi+1 then qu[s+1]:=not qu[s+1];
      if s<=hi then qv[s]:=not qv[s];
      end;
  if dv>=0 then
    for p:=0 to dv do if tv[p] then
      begin
      s:=p shl 1;
      if s<=hi+1 then qu[s]:=not qu[s];
      end;
  if qu[0] then
    begin
    BuildOddGUV:=false;
    exit;
    end;
  for p:=0 to hi do qu[p]:=qu[p+1];
  qu[hi+1]:=false;
  end;
BuildOddGUV:=true;
end;

{ Repeated Fibonacci reduction.  The irreducible D-family is still
  solved by the H63 half-gcd kernel.  All reconstruction is charged to q. }
{ Reuse a single workspace: no recursion-sized stack of TVec buffers. }
type TQFCWork=record
  af,ac,af1,ac1,bf,bc,bf1,bc1:TVec;
  sa,sb,tg,tu,tv:TVec;
end;
var qfcWork:TQFCWork;

procedure GcdFChain(nn:longword; var vg,vu,vv:TVec);
var cur,next:longword; h,p:longint;

procedure Zero3(var a,b,c:TVec; hi:longint); inline;
begin VecZeroHi(a,hi); VecZeroHi(b,hi); VecZeroHi(c,hi); end;
procedure CopyP(var dst:TVec; const src:TVec; hi:longint); inline;
begin VecCopyHi(dst,src,hi); end;
begin
with qfcWork do
begin
cur:=nn;
while (cur and 1)<>0 do cur:=cur shr 1;
if cur=0 then
  begin
  BuildFCPairsIter(0,bf,bc,bf1,bc1,af,ac,af1,ac1);
  Zero3(vg,vu,vv,0); vg[0]:=true; vu[0]:=true;
  end
else
  begin
  BuildFCPairsIter(cur,bf,bc,bf1,bc1,af,ac,af1,ac1);
  h:=longint(cur div 4);
  for p:=0 to h do begin sa[p]:=af[p] xor af1[p]; sb[p]:=ac[p] xor ac1[p]; end;
GcdU(sa,sb,tg,tu,tv,h);
Zero3(vg,vu,vv,longint(cur div 2));
for p:=0 to h do
  begin
  vg[2*p]:=tg[p]; vu[2*p]:=tu[p];
  vv[2*p]:=tv[p]; vv[2*p+1]:=tu[p];
  end;
  end;
while cur<nn do
  begin
  h:=longint(cur div 2); next:=cur*2+1;
  DoubleFCVec(next,bf,bc,bf1,bc1,af,ac,af1,ac1,h);
  if not BuildOddGUV(bf,bc,vg,vu,vv,tg,tu,tv,longint(next div 2),h,(cur mod 3)=2) then
    GcdU(af,ac,tg,tu,tv,longint(next div 2));
  CopyP(vg,tg,longint(next div 2));CopyP(vu,tu,longint(next div 2));CopyP(vv,tv,longint(next div 2));
  CopyP(bf,af,longint(next div 2));CopyP(bc,ac,longint(next div 2));
  CopyP(bf1,af1,longint(next div 2));CopyP(bc1,ac1,longint(next div 2));
  cur:=next;
  end;
end;
end;

{ H64: rows r..n-1 and columns 0..n-r-1 form a triangular Toeplitz
  system. Reverse the right-hand side and divide by the Laurent kernel.
  The block length follows the divisor length; there is no n-size solver switch. }
{ H76: eight nibble products share one fixed 32-coefficient factor table. }
type TFixedMulTable=array[0..15,0..35] of boolean;
procedure PrepareFixedMul(const a:array of boolean; ao,alen:longint; var table:TFixedMulTable);
var bit,j,k,offset:longint; basis:array[0..35] of boolean;
begin
FillChar(table[0],SizeOf(table[0]),0);
if alen>32 then alen:=32;
for bit:=0 to 3 do
  begin
  for j:=0 to 35 do
    begin
    basis[j]:=false;
    if (j>=bit) and (j-bit<alen) then basis[j]:=a[ao+j-bit];
    end;
  offset:=1 shl bit;
  for k:=0 to offset-1 do for j:=0 to 35 do table[offset+k,j]:=table[k,j] xor basis[j];
  end;
end;
procedure FixedMul32(const table:TFixedMulTable; const a:array of boolean; ao,alen:longint; out r:TMul64Bool);
var v:array[0..7] of longint; i,j,k:longint;
begin
for i:=0 to 7 do
  begin
  v[i]:=0;
  for j:=0 to 3 do
    begin
    k:=i*4+j;
    if k<alen then v[i]:=v[i] or (ord(a[ao+k]) shl j);
    end;
  end;
for j:=0 to 3 do
  begin
  r[0+j]:=table[v[0],0+j];
  r[4+j]:=table[v[0],4+j] xor table[v[1],0+j];
  r[8+j]:=table[v[0],8+j] xor table[v[1],4+j] xor table[v[2],0+j];
  r[12+j]:=table[v[0],12+j] xor table[v[1],8+j] xor table[v[2],4+j] xor table[v[3],0+j];
  r[16+j]:=table[v[0],16+j] xor table[v[1],12+j] xor table[v[2],8+j] xor table[v[3],4+j] xor table[v[4],0+j];
  r[20+j]:=table[v[0],20+j] xor table[v[1],16+j] xor table[v[2],12+j] xor table[v[3],8+j] xor table[v[4],4+j] xor table[v[5],0+j];
  r[24+j]:=table[v[0],24+j] xor table[v[1],20+j] xor table[v[2],16+j] xor table[v[3],12+j] xor table[v[4],8+j] xor table[v[5],4+j] xor table[v[6],0+j];
  r[28+j]:=table[v[0],28+j] xor table[v[1],24+j] xor table[v[2],20+j] xor table[v[3],16+j] xor table[v[4],12+j] xor table[v[5],8+j] xor table[v[6],4+j] xor table[v[7],0+j];
  r[32+j]:=table[v[0],32+j] xor table[v[1],28+j] xor table[v[2],24+j] xor table[v[3],20+j] xor table[v[4],16+j] xor table[v[5],12+j] xor table[v[6],8+j] xor table[v[7],4+j];
  r[36+j]:=table[v[1],32+j] xor table[v[2],28+j] xor table[v[3],24+j] xor table[v[4],20+j] xor table[v[5],16+j] xor table[v[6],12+j] xor table[v[7],8+j];
  r[40+j]:=table[v[2],32+j] xor table[v[3],28+j] xor table[v[4],24+j] xor table[v[5],20+j] xor table[v[6],16+j] xor table[v[7],12+j];
  r[44+j]:=table[v[3],32+j] xor table[v[4],28+j] xor table[v[5],24+j] xor table[v[6],20+j] xor table[v[7],16+j];
  r[48+j]:=table[v[4],32+j] xor table[v[5],28+j] xor table[v[6],24+j] xor table[v[7],20+j];
  r[52+j]:=table[v[5],32+j] xor table[v[6],28+j] xor table[v[7],24+j];
  r[56+j]:=table[v[6],32+j] xor table[v[7],28+j];
  r[60+j]:=table[v[7],32+j];
  end;
end;

procedure SolveXFast(const vg,rhs:TVec; var dst:TVec; degreeU:longint);
var kernel:TDynBool;
var tables:array of TFixedMulTable;
var qblock,product:TMul64Bool;
var den,iv,rem:THPoly;
var d,len,center,dl,blockLen,size,pos,k,j0,j1,lim:longint;
begin
d:=degreeU*2; len:=longint(n)-d;
VecZeroHi(dst,longint(n));
if len<=0 then exit;
dl:=d*2+1; if dl>len then dl:=len;
blockLen:=32; while blockLen*8<dl do blockLen:=blockLen shl 1;
size:=((dl+31) shr 5) shl 5; if size<blockLen then size:=blockLen;
if Length(qPool)<len+size*64+128 then SetLength(qPool,len+size*64+128);
if Length(qA)<size then SetLength(qA,size);
if Length(qB)<size then SetLength(qB,size);
if Length(qC)<size then SetLength(qC,size);
if Length(qR)<size*2 then SetLength(qR,size*2);
if Length(qS)<size*2 then SetLength(qS,size*2);
if Length(qWork)<size*10 then SetLength(qWork,size*10);
qTop:=0;
BuildUKernelFast(vg,degreeU,kernel,center);
HPAlloc(den,dl);
for j0:=0 to dl-1 do den.v^[j0]:=kernel[center-d+j0];
den.d:=dl-1; HPNorm(den);
HPAlloc(rem,len);
for j0:=0 to len-1 do rem.v^[j0]:=rhs[longint(n)-1-j0];
rem.d:=len-1;
k:=blockLen; if k>len then k:=len;
HPInvSeries(den,k,iv);
pos:=0;
{ The same fixed 32-coefficient multiplication leaf is fused in A/B. }
if blockLen=32 then
  begin
  SetLength(tables,(den.d+32) div 32+1);
  PrepareFixedMul(iv.v^,0,iv.d+1,tables[0]);
  for j0:=0 to (den.d+32) div 32-1 do
    PrepareFixedMul(den.v^,j0*32,den.d+1-j0*32,tables[j0+1]);
  while pos<len do
    begin
    k:=len-pos; if k>32 then k:=32;
    FixedMul32(tables[0],rem.v^,pos,k,qblock);
    lim:=(den.d+32) div 32-1;
    if lim>=(len-pos+31) div 32 then lim:=(len-pos+31) div 32-1;
    for j0:=0 to lim do
      begin
      FixedMul32(tables[j0+1],qblock,0,k,product);
      for j1:=0 to 31 do
        begin
        if (j0>0) and (pos+j0*32+j1<len) then
          rem.v^[pos+j0*32+j1]:=rem.v^[pos+j0*32+j1] xor product[j1];
        if pos+j0*32+32+j1<len then
          rem.v^[pos+j0*32+32+j1]:=rem.v^[pos+j0*32+32+j1] xor product[32+j1];
        end;
      end;
    for j0:=0 to k-1 do rem.v^[pos+j0]:=qblock[j0];
    inc(pos,k);
    end;
  end
else
begin
FillChar(qA[0],size,0); FillChar(qB[0],size,0);
for j0:=0 to iv.d do qA[j0]:=iv.v^[j0];
for j0:=0 to den.d do qB[j0]:=den.v^[j0];
while pos<len do
  begin
  k:=len-pos; if k>blockLen then k:=blockLen;
  FillChar(qC[0],blockLen,0); FillChar(qR[0],blockLen*2,0);
  for j0:=0 to k-1 do qC[j0]:=rem.v^[pos+j0];
  KarRec(qC,0,qA,0,qR,0,blockLen shr 5,k,iv.d+1,qWork,0);
  if pos+k<len then
    begin
    FillChar(qR[k],size-k,0); FillChar(qS[0],size*2,0);
    KarRec(qR,0,qB,0,qS,0,size shr 5,k,den.d+1,qWork,0);
    lim:=k+den.d-1; if lim>=len-pos then lim:=len-pos-1;
    for j0:=k to lim do rem.v^[pos+j0]:=rem.v^[pos+j0] xor qS[j0];
    end;
  for j0:=0 to k-1 do rem.v^[pos+j0]:=qR[j0];
  inc(pos,k);
  end;
end;
for j0:=0 to len-1 do dst[len-1-j0]:=rem.v^[j0];
qTop:=0;
end;

{ Preserve the small text-output diagnostics without regenerating columns. }
procedure DumpXDetails(const vg:TVec; d:longint);
var kernel:TDynBool; center,p:longint; bit0:boolean;
begin
BuildUKernelFast(vg,d div 2,kernel,center);
writeln('d');
write(0,#9);
for p:=0 to longint(n)-1 do
  begin
  bit0:=false;
  if p<=d then bit0:=kernel[center+p];
  if p+2<=d then bit0:=bit0 xor kernel[center+p+2];
  if bit0 then write(1) else write(0);
  end;
writeln;
if longint(n)>=2*d+1 then
  begin
  write('K ');for p:=0 to 2*d do if kernel[center-d+p] then write(1) else write(0);writeln;
  write('Q ');for p:=d to longint(n)-d-1 do if x[p] then write(1) else write(0);writeln;
  end;
end;

procedure CalcMat2;
var gu,qu,qv:TVec;
var sa,sb,hu,su,sv:TVec;
var z:TVec;
var r0,rU:longint;
var m2,hiS,rr,du,dv:longint;
begin

if (n and 1)=0 then
  begin
  m2:=longint(n div 2);
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
  begin
  m2:=longint(n div 2);
  hiS:=m2 div 2;
  GcdFChain(m2,hu,su,sv);
  if BuildOddGUV(hf,hc,hu,su,sv,gu,qu,qv,longint(n div 2),hiS,(m2 mod 3)=2) then
    rU:=PolyDeg(gu,longint(n div 2))
  else
    rU:=GcdU(f,c,gu,qu,qv,longint(n div 2));
  end;
r0:=rU*2;
writeln('gcd',#9,r0,#9);
write('U ');for i:=0 to n div 2 do if qu[i] then write(1) else write(0);writeln;
write('V ');for i:=0 to n div 2 do if qv[i] then write(1) else write(0);writeln;
write('G ');for i:=0 to n div 2 do if gu[i] then write(1) else write(0);writeln;
write('y ');for i:=0 to n-1 do if y[i] then write(1) else write(0);writeln;
ApplyFastUCombo(qu,qv,y,z,n-1,longint(n div 2),0);

if r0=0 then
  begin
  for i:=0 to n-1 do x[i]:=z[i];
  end
else
begin
write('z ');for i:=0 to n-1 do if z[i] then write(1) else write(0);writeln;
SolveXFast(gu,z,x,rU);
DumpXDetails(gu,r0);
end;
write('x ');for i:=0 to n-1 do if x[i] then write(1) else write(0);writeln;
end;

function GeneMat():boolean;
var x2,x1,x0:TVec;
begin
for i:=-2 to n do begin x2[i]:=false; x1[i]:=false; end;
for i:=0 to n-1 do x1[i]:=x[i];
for j:=1 to n-1 do
  begin
  for i:=-2 to n do x0[i]:=false;
  for i:=0 to n-1 do x0[i]:=not(x1[i-1] xor x1[i] xor x1[i+1] xor x2[i]);
    for i:=-2 to n do x2[i]:=x1[i];
  for i:=-2 to n do x1[i]:=x0[i];
  end;
GeneMat:=true;
for i:=0 to n-1 do GeneMat:=GeneMat and (x1[i-1] xor x1[i] xor x1[i+1] xor x2[i]);
writeln(GeneMat);
end;

begin
InitMul8;
InitUKernel8;
for n:=1 to 20 do
  begin
  writeln('#',n);
  MakeMat();
  CalcMat2();
  GeneMat();
  writeln();
  end;
end.
