//{$define disp}
program diandeng;
{$mode objfpc}{$H+}

{$ifdef disp}
uses Windows, display;
const m=1000;
const sosN=1024;
{$else}
uses Windows;
const m=100000;
const sosN=131072;
{$endif}

const wb=32;
const mw=(m+wb-1)div wb;

type TVec=array[-2..mw]of LongWord;
     PVec=^TVec;
     TSos=array[0..sosN-1]of byte;

var n:longword;
var i,j:longint;
var x,y,y1,y_,y_1,f,f1,c,c1:TVec;
var k:longint;
var o:boolean;
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


function VecIsZero(const a:TVec):boolean;
var k2:longint;
begin
for k2:=0 to wn-1 do if a[k2]<>0 then begin VecIsZero:=false; exit; end;
VecIsZero:=true;
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
begin
TimeMark('m');
if (not o) or (longint(n)<k) then
  begin
  VecZero(y1); VecZero(y); VecZero(y_1); VecZero(y_);
  VecZero(f1); VecZero(f);
  VecZero(c1); VecZero(c);
  SetBit(f,0,1);
  SetBit(c,0,1);
  k:=0; o:=true;
  end;
for j:=k+1 to n do
  begin
  VecZero(y_2); VecZero(y2); VecZero(f2); VecZero(c2);
  VecShiftL1(v1,y_);
  VecShiftR1(v2,y_);
  VecCopy(y_2,v1);
  VecXorEq(y_2,y_);
  VecXorEq(y_2,v2);
  VecXorEq(y_2,y_1);
  MaskDeg(y_2,j-1);
  VecShiftL2(v1,y);
  VecShiftL1(v2,y);
  VecCopy(y2,v1);
  VecXorEq(y2,v2);
  VecXorEq(y2,y);
  VecShiftL2(v1,y1);
  VecXorEq(y2,v1);
  VecShiftL1(v1,y_);
  VecXorEq(y2,v1);
  VecXorEq(y2,y_);
  VecShiftR1(v1,y_);
  VecXorEq(y2,v1);
  VecShiftL1(v1,y_1);
  VecXorEq(y2,v1);
  VecXorEq(y2,y_1);
  VecXorEq(y2,ones);
  MaskDeg(y2,j-1);
  SetBit(y_2,0,GetBit(y2,0));
  y_2[-2]:=1;
  VecShiftL1(v1,f);
  VecCopy(f2,v1);
  VecXorEq(f2,f1);
  MaskDeg(f2,j);
  VecShiftL1(v1,c);
  VecCopy(c2,v1);
  VecXorEq(c2,c);
  VecXorEq(c2,c1);
  MaskDeg(c2,j);
  VecCopy(y_1,y_); VecCopy(y_,y_2); VecCopy(y1,y); VecCopy(y,y2);
  VecCopy(f1,f); VecCopy(f,f2);
  VecCopy(c1,c); VecCopy(c,c2);
  end;
k:=n;
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

procedure CalcMat2;
var q,g:TVec;
var v,z:TVec;
var g0,g1,g2:TVec;
var i0,r0,jmax,row1,row2,row3,l0,l1,l2,r1,r2,w,wl,wr:longint;
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
r0:=gcd(f,c,g,q);
TimeMark('z');
ApplyPoly(q,y,z,n-1,n-1);
TimeMark('d');
if r0=0 then
  begin
  VecCopy(x,z);
  end
else
begin
VecZero(g0); VecZero(g1); VecZero(g2);
VecZero(v); v[0]:=1; VecNorm(v);
ApplyPoly(g,v,g0,n-1,r0);
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
ApplyPoly(c,x,t,n-1,n);
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
