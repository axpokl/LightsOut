//{$define disp}
program diandeng;
{$mode objfpc}{$H+}

{$ifdef disp}
uses Windows, display;
const m=1000;
{$else}
uses Windows;
const m=100000;
{$endif}

const wb=32;
const mw=(m+wb-1)div wb;

type TVec=array[-2..mw]of LongWord;
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
var wn:longint;
var lastMask:LongWord;
var ones:TVec;
var v0,v1,v2,v3:TVec;

{$ifdef disp}
var bb:pbitbuf;
var bp:pbitmap;
{$endif}

procedure VecNorm(var a:TVec);
begin
a[-2]:=0; a[-1]:=0;
if wn<=mw then a[wn]:=0;
if wn+1<=mw then a[wn+1]:=0;
a[wn-1]:=a[wn-1] and lastMask;
end;

procedure VecZero(var v:TVec);
var k2,hiw:longint;
begin
hiw:=wn+1; if hiw>mw then hiw:=mw;
for k2:=-2 to hiw do v[k2]:=0;
end;

procedure VecCopy(var a:TVec;const b:TVec);
var k2,hiw:longint;
begin
hiw:=wn+1; if hiw>mw then hiw:=mw;
for k2:=-2 to hiw do a[k2]:=b[k2];
VecNorm(a);
end;

procedure VecXorEq(var a:TVec;const b:TVec);
var k2:longint;
begin
for k2:=0 to wn-1 do a[k2]:=a[k2] xor b[k2];
VecNorm(a);
end;

procedure MaskDeg(var a:TVec;deg:longint);
var w:longint;
var rem:longint;
var msk:LongWord;
var k2:longint;
begin
if deg<0 then begin for k2:=0 to wn-1 do a[k2]:=0; VecNorm(a); exit; end;
w:=deg shr 5;
rem:=deg and 31;
msk:=LongWord($FFFFFFFF) shr (31-rem);
for k2:=w+1 to wn-1 do a[k2]:=0;
a[w]:=a[w] and msk;
VecNorm(a);
end;

function GetBit(const v:TVec;idx:longint):LongWord;
var w,b2:longint;
begin
if idx<0 then begin GetBit:=0; exit; end;
w:=idx shr 5;
b2:=idx and 31;
if w<0 then begin GetBit:=0; exit; end;
if w>=wn then begin GetBit:=0; exit; end;
GetBit:=(v[w] shr b2) and 1;
end;

procedure SetBit(var v:TVec;idx:longint;bit:LongWord);
var w,b2:longint;
begin
if idx<0 then exit;
w:=idx shr 5;
b2:=idx and 31;
if w<0 then exit;
if w>=wn then exit;
if bit<>0 then v[w]:=v[w] or (LongWord(1) shl b2)
else v[w]:=v[w] and not(LongWord(1) shl b2);
VecNorm(v);
end;

procedure VecShiftL1(var dst:TVec;const src:TVec);
var k2:longint;
begin
dst[-2]:=0; dst[-1]:=0;
for k2:=0 to wn-1 do
  dst[k2]:=(src[k2] shl 1) or (src[k2-1] shr 31);
if wn<=mw then dst[wn]:=0;
if wn+1<=mw then dst[wn+1]:=0;
VecNorm(dst);
end;

procedure VecShiftR1(var dst:TVec;const src:TVec);
var k2:longint;
begin
dst[-2]:=0; dst[-1]:=0;
for k2:=0 to wn-1 do
  dst[k2]:=(src[k2] shr 1) or (src[k2+1] shl 31);
if wn<=mw then dst[wn]:=0;
if wn+1<=mw then dst[wn+1]:=0;
VecNorm(dst);
end;

procedure VecShiftL2(var dst:TVec;const src:TVec);
var k2:longint;
begin
dst[-2]:=0; dst[-1]:=0;
for k2:=0 to wn-1 do
  dst[k2]:=(src[k2] shl 2) or (src[k2-1] shr 30);
if wn<=mw then dst[wn]:=0;
if wn+1<=mw then dst[wn+1]:=0;
VecNorm(dst);
end;

procedure PrepN;
var bits:longint;
var rem:longint;
var k2:longint;
begin
bits:=longint(n)+1;
wn:=(bits+31) shr 5;
rem:=bits and 31;
if rem=0 then lastMask:=$FFFFFFFF else lastMask:=(LongWord(1) shl rem)-1;
VecZero(ones);
for k2:=0 to wn-2 do ones[k2]:=$FFFFFFFF;
ones[wn-1]:=lastMask;
VecNorm(ones);
end;

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

procedure VecXorRange(var a:TVec;const b:TVec;l,r:longint);
var wl,wr,k2:longint;
var ml,mr:LongWord;
begin
if l<0 then l:=0;
if r>longint(n)-1 then r:=longint(n)-1;
if l>r then exit;
wl:=l shr 5; wr:=r shr 5;
ml:=LongWord($FFFFFFFF) shl (l and 31);
if (r and 31)=31 then mr:=$FFFFFFFF else mr:=(LongWord(1) shl ((r and 31)+1))-1;
if wl=wr then
  a[wl]:=a[wl] xor (b[wl] and (ml and mr))
else
  begin
  a[wl]:=a[wl] xor (b[wl] and ml);
  for k2:=wl+1 to wr-1 do a[k2]:=a[k2] xor b[k2];
  a[wr]:=a[wr] xor (b[wr] and mr);
  end;
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

procedure MakeMat();
var y2,y_2,f2,c2:TVec;
var py,py1,py_,py_1,py2,py_2,pf,pf1,pf2,pc,pc1,pc2,pt:PVec;
var hiu:longint;
begin
TimeMark('m');
if (not o) or (longint(n)<k) then
  begin
  VecZero(y1); VecZero(y); VecZero(y_1); VecZero(y_);
  VecZero(f1); VecZero(f);
  VecZero(c1); VecZero(c);
  SetBit(f,0,1);
  k:=0; o:=true; ho:=false;
  end;
py1:=@y1; py:=@y; py_1:=@y_1; py_:=@y_; py2:=@y2; py_2:=@y_2;
pf1:=@f1; pf:=@f; pf2:=@f2; pc1:=@c1; pc:=@c; pc2:=@c2;
for j:=k+1 to n do
  begin
  VecZero(py_2^); VecZero(py2^); VecZero(pf2^); VecZero(pc2^);
  VecShiftL1(v1,py_^);
  VecShiftR1(v2,py_^);
  VecCopy(py_2^,v1);
  VecXorEq(py_2^,py_^);
  VecXorEq(py_2^,v2);
  VecXorEq(py_2^,py_1^);
  MaskDeg(py_2^,j-1);
  VecShiftL2(v1,py^);
  VecShiftL1(v2,py^);
  VecCopy(py2^,v1);
  VecXorEq(py2^,v2);
  VecXorEq(py2^,py^);
  VecShiftL2(v1,py1^);
  VecXorEq(py2^,v1);
  VecShiftL1(v1,py_^);
  VecXorEq(py2^,v1);
  VecXorEq(py2^,py_^);
  VecShiftR1(v1,py_^);
  VecXorEq(py2^,v1);
  VecShiftL1(v1,py_1^);
  VecXorEq(py2^,v1);
  VecXorEq(py2^,py_1^);
  VecXorEq(py2^,ones);
  MaskDeg(py2^,j-1);
  SetBit(py_2^,0,GetBit(py2^,0));
  py_2^[-2]:=1;
  if j=1 then
    begin
    SetBit(pc2^,0,1);
    end
  else
    begin
    hiu:=j div 2;
    VecShiftL1(v1,pc^);
    VecCopy(pf2^,v1);
    VecXorEq(pf2^,pf1^);
    MaskDeg(pf2^,hiu);
    VecCopy(pc2^,pf^);
    VecXorEq(pc2^,pc^);
    VecXorEq(pc2^,pc1^);
    MaskDeg(pc2^,hiu);
    end;
  pt:=py_1; py_1:=py_; py_:=py_2; py_2:=pt;
  pt:=py1; py1:=py; py:=py2; py2:=pt;
  pt:=pf1; pf1:=pf; pf:=pf2; pf2:=pt;
  pt:=pc1; pc1:=pc; pc:=pc2; pc2:=pt;
  if j=longint(n div 2) then
    begin
    VecCopy(hf,pf^);
    VecCopy(hc,pc^);
    VecCopy(hf1,pf1^);
    VecCopy(hc1,pc1^);
    MaskDeg(hf,j div 2);
    MaskDeg(hc,j div 2);
    MaskDeg(hf1,j div 2);
    MaskDeg(hc1,j div 2);
    hk:=j;
    ho:=true;
    end;
  end;
VecCopy(v0,py1^); VecCopy(v1,py^); VecCopy(v2,py_1^); VecCopy(v3,py_^);
VecCopy(y1,v0); VecCopy(y,v1); VecCopy(y_1,v2); VecCopy(y_,v3);
VecCopy(v0,pf1^); VecCopy(v1,pf^); VecCopy(v2,pc1^); VecCopy(v3,pc^);
VecCopy(f1,v0); VecCopy(f,v1); VecCopy(c1,v2); VecCopy(c,v3);
k:=n;
end;

procedure EnsureAB(nn:longword);
var jj,hiu:longint;
var tf,tc:TVec;
begin
if (not ho) or (longint(nn)<hk) then
  begin
  VecZero(hf); VecZero(hc); VecZero(hf1); VecZero(hc1);
  SetBit(hf,0,1);
  hk:=0; ho:=true;
  end;
for jj:=hk+1 to nn do
  begin
  VecZero(tf); VecZero(tc);
  if jj=1 then
    SetBit(tc,0,1)
  else
    begin
    hiu:=jj div 2;
    VecShiftL1(v1,hc);
    VecCopy(tf,v1);
    VecXorEq(tf,hf1);
    MaskDeg(tf,hiu);
    VecCopy(tc,hf);
    VecXorEq(tc,hc);
    VecXorEq(tc,hc1);
    MaskDeg(tc,hiu);
    end;
  VecCopy(hf1,hf);
  VecCopy(hc1,hc);
  VecCopy(hf,tf);
  VecCopy(hc,tc);
  end;
hk:=nn;
end;

function HighBit32(x:LongWord):longint;
var k2:longint;
begin
for k2:=31 downto 0 do if (x and (LongWord(1) shl k2))<>0 then begin HighBit32:=k2; exit; end;
HighBit32:=-1;
end;

function TopBit(const v:TVec):longint;
var w,h:longint;
begin
for w:=wn-1 downto 0 do
  if v[w]<>0 then
    begin
    h:=HighBit32(v[w]);
    TopBit:=(w shl 5)+h;
    exit;
    end;
TopBit:=-1;
end;

function TopBitLE(const v:TVec;hi:longint):longint;
var w,h:longint;
var x:LongWord;
begin
if hi<0 then begin TopBitLE:=-1; exit; end;
if hi>longint(n) then hi:=longint(n);
w:=hi shr 5;
if (hi and 31)=31 then x:=v[w]
else x:=v[w] and ((LongWord(1) shl ((hi and 31)+1))-1);
while w>=0 do
  begin
  if x<>0 then
    begin
    h:=HighBit32(x);
    TopBitLE:=(w shl 5)+h;
    exit;
    end;
  dec(w);
  if w>=0 then x:=v[w];
  end;
TopBitLE:=-1;
end;


function LowBit32(x:LongWord):longint;
var k2:longint;
begin
for k2:=0 to 31 do if (x and (LongWord(1) shl k2))<>0 then begin LowBit32:=k2; exit; end;
LowBit32:=-1;
end;

function FirstBitRange(const v:TVec;l,r:longint):longint;
var wl,wr,w:longint;
var x,ml,mr:LongWord;
begin
if l<0 then l:=0;
if r>longint(n)-1 then r:=longint(n)-1;
if l>r then begin FirstBitRange:=-1; exit; end;
wl:=l shr 5; wr:=r shr 5;
ml:=LongWord($FFFFFFFF) shl (l and 31);
if (r and 31)=31 then mr:=$FFFFFFFF else mr:=(LongWord(1) shl ((r and 31)+1))-1;
for w:=wl to wr do
  begin
  x:=v[w];
  if w=wl then x:=x and ml;
  if w=wr then x:=x and mr;
  if x<>0 then begin FirstBitRange:=(w shl 5)+LowBit32(x); exit; end;
  end;
FirstBitRange:=-1;
end;

function LastBitRange(const v:TVec;l,r:longint):longint;
var wl,wr,w,h:longint;
var x,ml,mr:LongWord;
begin
if l<0 then l:=0;
if r>longint(n)-1 then r:=longint(n)-1;
if l>r then begin LastBitRange:=-1; exit; end;
wl:=l shr 5; wr:=r shr 5;
ml:=LongWord($FFFFFFFF) shl (l and 31);
if (r and 31)=31 then mr:=$FFFFFFFF else mr:=(LongWord(1) shl ((r and 31)+1))-1;
for w:=wr downto wl do
  begin
  x:=v[w];
  if w=wl then x:=x and ml;
  if w=wr then x:=x and mr;
  if x<>0 then
    begin
    h:=HighBit32(x);
    LastBitRange:=(w shl 5)+h;
    exit;
    end;
  end;
LastBitRange:=-1;
end;

procedure VecStepRange(var dst:TVec;const src:TVec;l,r,hi:longint);
var l2,r2,wl,wr,w:longint;
var ml,mr:LongWord;
begin
if l<0 then l:=0;
if r>hi then r:=hi;
if l>r then begin VecZero(dst); exit; end;
l2:=l-1; if l2<0 then l2:=0;
r2:=r+1; if r2>hi then r2:=hi;
wl:=l2 shr 5; wr:=r2 shr 5;
if wl-1>=-2 then dst[wl-1]:=0;
if wr+1<=mw then dst[wr+1]:=0;
for w:=wl to wr do
  dst[w]:=(((src[w] shl 1) or (src[w-1] shr 31)) xor ((src[w] shr 1) or (src[w+1] shl 31)));
ml:=LongWord($FFFFFFFF) shl (l2 and 31);
if (r2 and 31)=31 then mr:=$FFFFFFFF else mr:=(LongWord(1) shl ((r2 and 31)+1))-1;
if wl=wr then
  dst[wl]:=dst[wl] and (ml and mr)
else
  begin
  dst[wl]:=dst[wl] and ml;
  dst[wr]:=dst[wr] and mr;
  end;
VecNorm(dst);
end;

procedure ApplyPoly(const va,vsrc:TVec; var vdst:TVec; hi,degmax:longint);
var cur0,cur1:TVec;
var pcur,pnxt,pt:PVec;
var d,j2,l,r,l2,r2:longint;
begin
VecZero(cur0); VecZero(cur1); VecZero(vdst);
VecCopy(cur0,vsrc);
MaskDeg(cur0,hi);
d:=TopBitLE(va,degmax);
if d<0 then exit;
l:=FirstBitRange(cur0,0,hi);
if l<0 then exit;
r:=LastBitRange(cur0,l,hi);
pcur:=@cur0;
pnxt:=@cur1;
for j2:=0 to d do
  begin
  if GetBit(va,j2)<>0 then VecXorRange(vdst,pcur^,l,r);
  if j2>=d then break;
  l2:=l-1; if l2<0 then l2:=0;
  r2:=r+1; if r2>hi then r2:=hi;
  VecStepRange(pnxt^,pcur^,l,r,hi);
  l:=FirstBitRange(pnxt^,l2,r2);
  if l<0 then break;
  r:=LastBitRange(pnxt^,l,r2);
  pt:=pcur; pcur:=pnxt; pnxt:=pt;
  end;
VecNorm(vdst);
end;


procedure VecXorShift(var a:TVec;const b:TVec;sh:longint);
var ws,bs:longint;
var x0,x1:LongWord;
var k2:longint;
begin
if sh<0 then exit;
ws:=sh shr 5;
bs:=sh and 31;
if bs=0 then
  begin
  for k2:=wn-1 downto ws do a[k2]:=a[k2] xor b[k2-ws];
  end
else
  begin
  for k2:=wn-1 downto ws do
    begin
    x0:=b[k2-ws] shl bs;
    x1:=0;
    if k2-ws-1>=0 then x1:=b[k2-ws-1] shr (32-bs);
    a[k2]:=a[k2] xor (x0 or x1);
    end;
  end;
VecNorm(a);
end;

procedure VecXorShiftRange(var a:TVec;const b:TVec;sh,r:longint);
var ws,bs,wl,wr,k2:longint;
var x0,x1,ml,mr,msk:LongWord;
begin
if sh<0 then exit;
if r<0 then exit;
if sh>longint(n) then exit;
if r>longint(n)-sh then r:=longint(n)-sh;
ws:=sh shr 5;
bs:=sh and 31;
wl:=sh shr 5;
wr:=(sh+r) shr 5;
ml:=LongWord($FFFFFFFF) shl (sh and 31);
if ((sh+r) and 31)=31 then mr:=$FFFFFFFF else mr:=(LongWord(1) shl (((sh+r) and 31)+1))-1;
for k2:=wl to wr do
  begin
  if bs=0 then
    begin
    x0:=b[k2-ws];
    x1:=0;
    end
  else
    begin
    x0:=b[k2-ws] shl bs;
    x1:=0;
    if k2-ws-1>=0 then x1:=b[k2-ws-1] shr (32-bs);
    end;
  msk:=$FFFFFFFF;
  if k2=wl then msk:=msk and ml;
  if k2=wr then msk:=msk and mr;
  a[k2]:=a[k2] xor ((x0 or x1) and msk);
  end;
VecNorm(a);
end;

function gcd(const vf,vg:TVec; var vd,vr:TVec):longint;
var f0a,g0a,vxa,vya:TVec;
var f0,g0,vx,vy,vt:PVec;
var kf,kg,kvx,kvy,shift,p,top,lim:longint;
begin
f0:=@f0a; g0:=@g0a; vx:=@vxa; vy:=@vya;
VecCopy(f0^,vf); VecCopy(g0^,vg);
kf:=TopBit(f0^);
kg:=TopBit(g0^);
kvx:=-1;
kvy:=0;
VecZero(vx^); VecZero(vy^); SetBit(vy^,0,1);
while true do
  begin
  if kf<kg then begin vt:=f0; f0:=g0; g0:=vt; vt:=vx; vx:=vy; vy:=vt; p:=kf; kf:=kg; kg:=p; p:=kvx; kvx:=kvy; kvy:=p; end;
  if kg<0 then begin VecCopy(vd,f0^); VecCopy(vr,vx^); gcd:=kf; exit; end;
  while kf>=kg do
    begin
    shift:=kf-kg;
    VecXorShift(f0^,g0^,shift);
    kf:=TopBitLE(f0^,kf-1);
    if kvy>=0 then
      begin
      top:=kvx;
      if kvy+shift>longint(n) then top:=longint(n)
      else if kvy+shift>top then top:=kvy+shift;
      lim:=kvy;
      if lim>longint(n)-shift then lim:=longint(n)-shift;
      VecXorShiftRange(vx^,vy^,shift,lim);
      kvx:=TopBitLE(vx^,top);
      end;
    end;
  end;
end;

function GcdU(const va,vb:TVec; var vg,vu,vv:TVec; hi:longint):longint;
var r0a,r1a,u0a,u1a,v0a,v1a:TVec;
var r0,r1,u0,u1,v0,v1,tt:PVec;
var kr0,kr1,ku0,ku1,kv0,kv1,shift,p,top,lim:longint;
begin
r0:=@r0a; r1:=@r1a; u0:=@u0a; u1:=@u1a; v0:=@v0a; v1:=@v1a;
VecCopy(r0^,va); MaskDeg(r0^,hi);
VecCopy(r1^,vb); MaskDeg(r1^,hi);
VecZero(u0^); VecZero(u1^); VecZero(v0^); VecZero(v1^);
SetBit(u0^,0,1);
SetBit(v1^,0,1);
kr0:=TopBitLE(r0^,hi);
kr1:=TopBitLE(r1^,hi);
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
    VecCopy(vg,r0^); MaskDeg(vg,hi);
    VecCopy(vu,u0^); MaskDeg(vu,hi);
    VecCopy(vv,v0^); MaskDeg(vv,hi);
    GcdU:=kr0;
    exit;
    end;
  while kr0>=kr1 do
    begin
    shift:=kr0-kr1;
    VecXorShiftRange(r0^,r1^,shift,kr1);
    kr0:=TopBitLE(r0^,kr0-1);
    if ku1>=0 then
      begin
      top:=ku0;
      if ku1+shift>top then top:=ku1+shift;
      if top>hi then top:=hi;
      lim:=ku1;
      if lim>hi-shift then lim:=hi-shift;
      VecXorShiftRange(u0^,u1^,shift,lim);
      ku0:=TopBitLE(u0^,top);
      end;
    if kv1>=0 then
      begin
      top:=kv0;
      if kv1+shift>top then top:=kv1+shift;
      if top>hi then top:=hi;
      lim:=kv1;
      if lim>hi-shift then lim:=hi-shift;
      VecXorShiftRange(v0^,v1^,shift,lim);
      kv0:=TopBitLE(v0^,top);
      end;
    end;
  end;
end;

procedure VecStepJ(var dst:TVec; const src:TVec; hi:longint);
var k2:longint;
begin
if hi<=0 then begin VecZero(dst); exit; end;
dst[-2]:=0; dst[-1]:=0;
for k2:=0 to wn-1 do
  dst[k2]:=((src[k2] shl 2) or (src[k2-1] shr 30)) xor
           ((src[k2] shr 2) or (src[k2+1] shl 30)) xor
           ((src[k2] shl 1) or (src[k2-1] shr 31)) xor
           ((src[k2] shr 1) or (src[k2+1] shl 31));
if GetBit(src,0)<>0 then dst[0]:=dst[0] xor 1;
if (hi>0) and (GetBit(src,hi)<>0) then
  dst[hi shr 5]:=dst[hi shr 5] xor (LongWord(1) shl (hi and 31));
if wn<=mw then dst[wn]:=0;
if wn+1<=mw then dst[wn+1]:=0;
MaskDeg(dst,hi);
end;

procedure VecH(var dst:TVec; const src:TVec; hi:longint);
var k2:longint;
begin
dst[-2]:=0; dst[-1]:=0;
for k2:=0 to wn-1 do
  dst[k2]:=((src[k2] shl 1) or (src[k2-1] shr 31)) xor
           ((src[k2] shr 1) or (src[k2+1] shl 31));
if wn<=mw then dst[wn]:=0;
if wn+1<=mw then dst[wn+1]:=0;
MaskDeg(dst,hi);
end;

procedure ApplyPolyU(const va,vsrc:TVec; var vdst:TVec; hi,degmax:longint);
var cur0,cur1:TVec;
var pcur,pnxt,pt:PVec;
var d,j2:longint;
begin
VecZero(cur0); VecZero(cur1); VecZero(vdst);
VecCopy(cur0,vsrc);
MaskDeg(cur0,hi);
d:=TopBitLE(va,degmax);
if d<0 then exit;
pcur:=@cur0;
pnxt:=@cur1;
for j2:=0 to d do
  begin
  if GetBit(va,j2)<>0 then VecXorEq(vdst,pcur^);
  if j2>=d then break;
  VecStepJ(pnxt^,pcur^,hi);
  pt:=pcur; pcur:=pnxt; pnxt:=pt;
  end;
MaskDeg(vdst,hi);
end;

procedure ApplyBezoutU(const vu,vv,vsrc:TVec; var vdst:TVec; hi,degmax:longint);
var cur0,cur1,hcur:TVec;
var pcur,pnxt,pt:PVec;
var d,du,dv,j2:longint;
begin
VecZero(cur0); VecZero(cur1); VecZero(hcur); VecZero(vdst);
VecCopy(cur0,vsrc);
MaskDeg(cur0,hi);
du:=TopBitLE(vu,degmax);
dv:=TopBitLE(vv,degmax);
if du>dv then d:=du else d:=dv;
if d<0 then exit;
pcur:=@cur0;
pnxt:=@cur1;
for j2:=0 to d do
  begin
  if GetBit(vv,j2)<>0 then VecXorEq(vdst,pcur^);
  if GetBit(vu,j2)<>0 then
    begin
    VecH(hcur,pcur^,hi);
    VecXorEq(vdst,hcur);
    end;
  if j2>=d then break;
  VecStepJ(pnxt^,pcur^,hi);
  pt:=pcur; pcur:=pnxt; pnxt:=pt;
  end;
MaskDeg(vdst,hi);
end;

procedure ApplyCU(const va,vb,vsrc:TVec; var vdst:TVec; hi,degmax:longint);
var cur0,cur1,hcur:TVec;
var pcur,pnxt,pt:PVec;
var d,da,db,j2:longint;
begin
VecZero(cur0); VecZero(cur1); VecZero(hcur); VecZero(vdst);
VecCopy(cur0,vsrc);
MaskDeg(cur0,hi);
da:=TopBitLE(va,degmax);
db:=TopBitLE(vb,degmax);
if da>db then d:=da else d:=db;
if d<0 then exit;
pcur:=@cur0;
pnxt:=@cur1;
for j2:=0 to d do
  begin
  if GetBit(va,j2)<>0 then VecXorEq(vdst,pcur^);
  if GetBit(vb,j2)<>0 then
    begin
    VecXorEq(vdst,pcur^);
    VecH(hcur,pcur^,hi);
    VecXorEq(vdst,hcur);
    end;
  if j2>=d then break;
  VecStepJ(pnxt^,pcur^,hi);
  pt:=pcur; pcur:=pnxt; pnxt:=pt;
  end;
MaskDeg(vdst,hi);
end;

function BuildOddGUV(const ma,mb,mg,mu,mv:TVec; var gu,qu,qv:TVec; hi,srcHi:longint; extra:boolean):boolean;
var tu,tv:TVec;
var p,dg,du,dv,s:longint;
begin
VecZero(gu);
VecZero(qu);
VecZero(qv);
VecCopy(tu,mu); MaskDeg(tu,srcHi);
VecCopy(tv,mv); MaskDeg(tv,srcHi);
if (not extra) and ((GetBit(tu,0) xor GetBit(tv,0))<>0) then
  begin
  VecXorEq(tu,mb); MaskDeg(tu,srcHi);
  VecXorEq(tv,ma); MaskDeg(tv,srcHi);
  end;
if (not extra) and ((GetBit(tu,0) xor GetBit(tv,0))<>0) then
  begin
  BuildOddGUV:=false;
  exit;
  end;
dg:=TopBitLE(mg,srcHi);
if dg>=0 then
  for p:=0 to dg do if GetBit(mg,p)<>0 then
    begin
    s:=p shl 1;
    if extra then inc(s);
    if s<=hi then SetBit(gu,s,GetBit(gu,s) xor 1);
    end;
du:=TopBitLE(tu,srcHi);
dv:=TopBitLE(tv,srcHi);
if extra then
  begin
  if du>=0 then
    for p:=0 to du do if GetBit(tu,p)<>0 then
      begin
      s:=p shl 1;
      if s<=hi then SetBit(qu,s,GetBit(qu,s) xor 1);
      if s+1<=hi then
        begin
        SetBit(qu,s+1,GetBit(qu,s+1) xor 1);
        SetBit(qv,s+1,GetBit(qv,s+1) xor 1);
        end;
      end;
  if dv>=0 then
    for p:=0 to dv do if GetBit(tv,p)<>0 then
      begin
      s:=p shl 1;
      if s<=hi then SetBit(qu,s,GetBit(qu,s) xor 1);
      end;
  end
else
  begin
  if du>=0 then
    for p:=0 to du do if GetBit(tu,p)<>0 then
      begin
      s:=p shl 1;
      if s<=hi+1 then SetBit(qu,s,GetBit(qu,s) xor 1);
      if s+1<=hi+1 then SetBit(qu,s+1,GetBit(qu,s+1) xor 1);
      if s<=hi then SetBit(qv,s,GetBit(qv,s) xor 1);
      end;
  if dv>=0 then
    for p:=0 to dv do if GetBit(tv,p)<>0 then
      begin
      s:=p shl 1;
      if s<=hi+1 then SetBit(qu,s,GetBit(qu,s) xor 1);
      end;
  if GetBit(qu,0)<>0 then
    begin
    BuildOddGUV:=false;
    exit;
    end;
  for p:=0 to hi do SetBit(qu,p,GetBit(qu,p+1));
  SetBit(qu,hi+1,0);
  MaskDeg(qu,hi);
  end;
MaskDeg(gu,hi);
MaskDeg(qu,hi);
MaskDeg(qv,hi);
BuildOddGUV:=true;
end;

procedure CalcMat2;
var gu,qu,qv:TVec;
var sa,sb,hu,su,sv:TVec;
var v,z:TVec;
var g0,g1,g2:TVec;
var i0,r0,rU,jmax,row1,row2,row3,l0,l1,l2,r1,r2,w,wl,wr:longint;
var m2,hiS,rr,du,dv:longint;
var tm,val:LongWord;
var pg0,pg1,pg2,pt:PVec;

function RangeMask(w,l,r:longint):LongWord;
var wl0,wr0:longint;
var ml,mr:LongWord;
begin
if (l>r) or (w<0) or (w>=wn) then begin RangeMask:=0; exit; end;
wl0:=l shr 5;
wr0:=r shr 5;
if (w<wl0) or (w>wr0) then begin RangeMask:=0; exit; end;
if wl0=wr0 then
  begin
  ml:=LongWord($FFFFFFFF) shl (l and 31);
  if (r and 31)=31 then mr:=$FFFFFFFF else mr:=(LongWord(1) shl ((r and 31)+1))-1;
  RangeMask:=ml and mr;
  end
else if w=wl0 then
  RangeMask:=LongWord($FFFFFFFF) shl (l and 31)
else if w=wr0 then
  begin
  if (r and 31)=31 then RangeMask:=$FFFFFFFF else RangeMask:=(LongWord(1) shl ((r and 31)+1))-1;
  end
else
  RangeMask:=$FFFFFFFF;
end;

procedure CropRange(var a:TVec;l,r:longint);
var wl0,wr0,k2:longint;
var ml,mr:LongWord;
begin
if l<0 then l:=0;
if r>longint(n)-1 then r:=longint(n)-1;
if l>r then begin VecZero(a); VecNorm(a); exit; end;
wl0:=l shr 5;
wr0:=r shr 5;
for k2:=0 to wl0-1 do a[k2]:=0;
if wl0=wr0 then
  begin
  ml:=LongWord($FFFFFFFF) shl (l and 31);
  if (r and 31)=31 then mr:=$FFFFFFFF else mr:=(LongWord(1) shl ((r and 31)+1))-1;
  a[wl0]:=a[wl0] and (ml and mr);
  end
else
  begin
  ml:=LongWord($FFFFFFFF) shl (l and 31);
  if (r and 31)=31 then mr:=$FFFFFFFF else mr:=(LongWord(1) shl ((r and 31)+1))-1;
  a[wl0]:=a[wl0] and ml;
  a[wr0]:=a[wr0] and mr;
  end;
for k2:=wr0+1 to wn-1 do a[k2]:=0;
VecNorm(a);
end;

begin
TimeMark('c');
TimeMark('q');
if (n and 1)=0 then
  begin
  m2:=longint(n div 2);
  EnsureAB(m2);
  hiS:=m2 div 2;
  VecZero(gu); VecZero(qu); VecZero(qv);
  VecCopy(sa,hf);
  VecXorEq(sa,hf1);
  MaskDeg(sa,hiS);
  VecCopy(sb,hc);
  VecXorEq(sb,hc1);
  MaskDeg(sb,hiS);
  rr:=GcdU(sa,sb,hu,su,sv,hiS);
  for i:=0 to rr do if GetBit(hu,i)<>0 then SetBit(gu,i shl 1,1);
  du:=TopBitLE(su,hiS);
  for i:=0 to du do if GetBit(su,i)<>0 then
    begin
    SetBit(qu,i shl 1,1);
    if (i shl 1)+1<=longint(n div 2) then SetBit(qv,(i shl 1)+1,GetBit(qv,(i shl 1)+1) xor 1);
    end;
  dv:=TopBitLE(sv,hiS);
  for i:=0 to dv do if GetBit(sv,i)<>0 then SetBit(qv,i shl 1,GetBit(qv,i shl 1) xor 1);
  rU:=rr shl 1;
  end
else
  begin
  m2:=longint(n div 2);
  EnsureAB(m2);
  hiS:=m2 div 2;
  rr:=GcdU(hf,hc,hu,su,sv,hiS);
  if BuildOddGUV(hf,hc,hu,su,sv,gu,qu,qv,longint(n div 2),hiS,(m2 mod 3)=2) then
    rU:=TopBitLE(gu,longint(n div 2))
  else
    rU:=GcdU(f,c,gu,qu,qv,longint(n div 2));
  end;
r0:=rU*2;
TimeMark('z');
ApplyBezoutU(qu,qv,y,z,n-1,longint(n div 2));
TimeMark('d');
if r0=0 then
  begin
  VecCopy(x,z);
  end
else
begin
VecZero(g0); VecZero(g1); VecZero(g2);
VecZero(v); v[0]:=1; VecNorm(v);
ApplyPolyU(gu,v,g0,n-1,rU);
TimeMark('x');
MaskDeg(g0,n-1);
pg0:=@g0; pg1:=@g1; pg2:=@g2;
if n-r0-1<0 then jmax:=0 else jmax:=n-r0-1;
if jmax=0 then VecCopy(pg1^,pg0^)
else if r0<jmax then
  begin
  VecZero(v);
  VecShiftL1(v1,pg0^);
  VecShiftR1(v2,pg0^);
  VecCopy(v,v1);
  VecXorEq(v,v2);
  MaskDeg(v,n-1);
  VecZero(pg1^); VecZero(pg2^);
  for i:=0 to n-1 do if ((pg0^[i shr 5] shr (i and 31)) and 1)<>0 then pg1^[(n-1-i) shr 5]:=pg1^[(n-1-i) shr 5] or (LongWord(1) shl ((n-1-i) and 31));
  for i:=0 to n-1 do if ((v[i shr 5] shr (i and 31)) and 1)<>0 then pg2^[(n-1-i) shr 5]:=pg2^[(n-1-i) shr 5] or (LongWord(1) shl ((n-1-i) and 31));
  MaskDeg(pg1^,n-1); MaskDeg(pg2^,n-1);
  for j:=1 to r0 do
    begin
    VecShiftL1(v1,pg2^);
    VecShiftR1(v2,pg2^);
    VecCopy(pg0^,v1);
    VecXorEq(pg0^,v2);
    VecXorEq(pg0^,pg1^);
    MaskDeg(pg0^,n-1);
    pt:=pg0; pg0:=pg1; pg1:=pg2; pg2:=pt;
    end;
  end
else
  begin
  VecCopy(pg1^,pg0^);
  for j:=1 to jmax do
    begin
    VecShiftL1(v1,pg1^);
    VecShiftR1(v2,pg1^);
    VecCopy(pg0^,v1);
    VecXorEq(pg0^,v2);
    VecXorEq(pg0^,pg2^);
    MaskDeg(pg0^,n-1);
    pt:=pg0; pg0:=pg2; pg2:=pg1; pg1:=pt;
    end;
  end;
VecZero(x); VecNorm(x);
row1:=n-1;
row2:=n-2;
l1:=row1-(r0 shl 1); if l1<0 then l1:=0; r1:=row1; if r1>longint(n)-1 then r1:=longint(n)-1;
l2:=row2-(r0 shl 1); if l2<0 then l2:=0; r2:=row2;
CropRange(pg1^,l1,r1);
CropRange(pg2^,l2,r2);
VecZero(pg0^); VecNorm(pg0^);
if r0<=n-1 then
for i:=n-1 downto r0 do
  begin
  if ((z[i shr 5] shr (i and 31)) and 1)<>0 then
  begin
    i0:=i-r0;
    VecXorRange(z,pg1^,l1,r1);
    x[i0 shr 5]:=x[i0 shr 5] or (LongWord(1) shl (i0 and 31));
  end;
  if i>r0 then
    begin
    row3:=row2-1;
    l0:=row3-(r0 shl 1); if l0<0 then l0:=0;
    wl:=l0 shr 5;
    wr:=row3 shr 5;
    for w:=wl to wr do
      begin
      tm:=RangeMask(w,l0,row3);
      val:=pg1^[w] xor (pg2^[w] shl 1) xor (pg2^[w-1] shr 31) xor (pg2^[w] shr 1) xor (pg2^[w+1] shl 31);
      pg0^[w]:=val and tm;
      end;
    if wr+1<wn then pg0^[wr+1]:=0;
    pt:=pg0; pg0:=pg1; pg1:=pg2; pg2:=pt;
    row1:=row2;
    row2:=row3;
    l1:=l2; r1:=r2;
    l2:=l0; r2:=row3;
    end;
  end;
VecNorm(x);
end;
end;

function GeneMat():boolean;
var t:TVec;
var wn0:longint;
var mask0:LongWord;
var k2:longint;
begin
TimeMark('g');
ApplyCU(f,c,x,t,n-1,longint(n div 2));
wn0:=(longint(n)+31) shr 5;
if (longint(n) and 31)=0 then mask0:=$FFFFFFFF else mask0:=(LongWord(1) shl (longint(n) and 31))-1;
GeneMat:=true;
for k2:=0 to wn0-2 do GeneMat:=GeneMat and (t[k2]=y[k2]);
GeneMat:=GeneMat and (((t[wn0-1] xor y[wn0-1]) and mask0)=0);
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
  PrepN;
  write(n,#9);
  MakeMat();
  CalcMat2();
  GeneMat();{$ifdef disp}write('%');SaveMat('_T2');{$endif}
  {$ifdef disp}if not(iswin()) then halt;{$endif}
  writeln();
  end;
end.
