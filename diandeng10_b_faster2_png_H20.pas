//{$define disp}
program diandeng;
{$mode objfpc}{$H+}

{$ifdef disp}
uses display;
const m=1000;
{$else}
uses Windows;
const m=10000;
{$endif}

const wb=32;
const mw=(m+wb-1)div wb;

type TVec=array[-2..mw]of LongWord;
type TMat=array[-2..m]of TVec;

var n:longword;
var i,j:longint;
var y,y0,f,x:TVec;
var y1,y2,y01,y02,f1,f2:TVec;
var lastLN,lastFN:longint;
var matInit:boolean;
{$ifdef disp}
var t:TMat;
{$endif}
var lastTick:DWORD;
var hasLastTick:boolean;
var wn:longint;
var lastMask:LongWord;
var ones:TVec;
var v0,v1,v2,v3:TVec;

{$ifdef disp}
var bb:pbitbuf;
var bp:pbitmap;
{$endif}

procedure VecNorm(var a:TVec);
var k2:longint;
begin
a[-2]:=0; a[-1]:=0;
for k2:=wn to mw do a[k2]:=0;
a[wn-1]:=a[wn-1] and lastMask;
end;

procedure VecZero(var v:TVec);
var k2:longint;
begin
for k2:=-2 to mw do v[k2]:=0;
end;

procedure VecCopy(var a:TVec;const b:TVec);
var k2:longint;
begin
for k2:=-2 to mw do a[k2]:=b[k2];
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
for k2:=wn to mw do dst[k2]:=0;
VecNorm(dst);
end;

procedure VecShiftR1(var dst:TVec;const src:TVec);
var k2:longint;
begin
dst[-2]:=0; dst[-1]:=0;
for k2:=0 to wn-1 do
  dst[k2]:=(src[k2] shr 1) or (src[k2+1] shl 31);
for k2:=wn to mw do dst[k2]:=0;
VecNorm(dst);
end;

procedure VecShiftL2(var dst:TVec;const src:TVec);
var k2:longint;
begin
dst[-2]:=0; dst[-1]:=0;
for k2:=0 to wn-1 do
  dst[k2]:=(src[k2] shl 2) or (src[k2-1] shr 30);
for k2:=wn to mw do dst[k2]:=0;
VecNorm(dst);
end;

procedure VecShiftR2(var dst:TVec;const src:TVec);
var k2:longint;
begin
dst[-2]:=0; dst[-1]:=0;
for k2:=0 to wn-1 do
  dst[k2]:=(src[k2] shr 2) or (src[k2+1] shl 30);
for k2:=wn to mw do dst[k2]:=0;
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

function TimeMark(ch:char):longword;
var nowTick,delta:DWORD;
begin
  nowTick:=GetTickCount;
  if not hasLastTick then
  begin
    delta:=0;
    hasLastTick:=true;
  end
  else
    delta:=nowTick-lastTick;
  lastTick:=nowTick;
  TimeMark:=delta;
  write(delta,#9,ch);
end;

procedure PrintMat(mat:TMat);
begin
writeln();
for j:=0 to n-1 do
  begin
  for i:=0 to n-1 do
    if GetBit(mat[j],i)<>0 then write('#') else write('.');
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
    if GetBit(mat[j],i)<>0 then SetBBPixel(bb,i,j,black) else SetBBPixel(bb,i,j,white);
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
var y3,y03,f3:TVec;
begin
if (not matInit) or (longint(n)<lastLN) or (longint(n)<lastFN) then
  begin
  VecZero(y2); VecZero(y1); VecZero(y02); VecZero(y01);
  VecZero(f2); VecZero(f1);
  SetBit(f1,0,1);
  lastLN:=0; lastFN:=0; matInit:=true;
  end;
for j:=lastLN+1 to n do
  begin
  VecZero(y03); VecZero(y3);
  VecShiftL1(v1,y01);
  VecShiftR1(v2,y01);
  VecCopy(y03,v1);
  VecXorEq(y03,y01);
  VecXorEq(y03,v2);
  VecXorEq(y03,y02);
  MaskDeg(y03,j-1);
  VecShiftL2(v1,y1);
  VecShiftL1(v2,y1);
  VecCopy(y3,v1);
  VecXorEq(y3,v2);
  VecXorEq(y3,y1);
  VecShiftL2(v1,y2);
  VecXorEq(y3,v1);
  VecShiftL1(v1,y01);
  VecXorEq(y3,v1);
  VecXorEq(y3,y01);
  VecShiftR1(v1,y01);
  VecXorEq(y3,v1);
  VecShiftL1(v1,y02);
  VecXorEq(y3,v1);
  VecXorEq(y3,y02);
  VecXorEq(y3,ones);
  MaskDeg(y3,j-1);
  SetBit(y03,0,GetBit(y3,0));
  y03[-2]:=1;
  y02:=y01; y01:=y03; y2:=y1; y1:=y3;
  end;
lastLN:=n;
for j:=lastFN+1 to n do
  begin
  VecZero(f3);
  if j=0 then SetBit(f3,0,1)
  else
    begin
    VecShiftL1(v1,f1);
    VecCopy(f3,v1);
    VecXorEq(f3,f2);
    MaskDeg(f3,j);
    end;
  f2:=f1; f1:=f3;
  end;
lastFN:=n;
VecCopy(y,y1); VecCopy(y0,y01); VecCopy(f,f1);
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

function gcd(vf,vg:TVec; var vd,vr:TVec):longint;
var vx,vy:TVec;
var kf,kg:longint;
var done:boolean;
begin
VecNorm(vf); VecNorm(vg);
kf:=TopBit(vf);
kg:=TopBit(vg);
done:=false;
VecZero(vx); VecZero(vy); SetBit(vy,0,1);
repeat
if kf<kg then begin v0:=vf; vf:=vg; vg:=v0; v0:=vx; vx:=vy; vy:=v0; j:=kf; kf:=kg; kg:=j; end;
if kg<0 then begin vd:=vf; vr:=vx; gcd:=kf; done:=true; end;
if not(done) then
  begin
  VecXorShift(vf,vg,kf-kg);
  VecXorShift(vx,vy,kf-kg);
  kf:=TopBit(vf);
  kg:=TopBit(vg);
  end;
until done;
end;

procedure CalcMat2;
var c,q,g:TVec;
var v,z:TVec;
var g0,g1,g2:TVec;
var i0,r0,jmax:longint;
begin
VecZero(c);
for i:=0 to n do if GetBit(f,i)<>0 then
  for j:=0 to i do if (j and i)=j then SetBit(c,j,GetBit(c,j) xor 1);
TimeMark('p');
TimeMark('q');
r0:=gcd(f,c,g,q);
TimeMark('y');
VecCopy(v,y); MaskDeg(v,n-1);
TimeMark('z');
VecZero(z); VecNorm(z);
for j:=0 to n-1 do 
  begin
  if GetBit(q,j)<>0 then VecXorEq(z,v);
  VecShiftL1(v1,v);
  VecShiftR1(v2,v);
  VecCopy(v,v1);
  VecXorEq(v,v2);
  MaskDeg(v,n-1);
  end;
if r0=0 then
  begin
  TimeMark('x');
  x:=z;
  VecNorm(x);
  end
else
begin
TimeMark('d');
VecZero(g0); VecZero(g1); VecZero(g2);
VecZero(v); SetBit(v,0,1);
for j:=0 to r0 do 
  begin
  if GetBit(g,j)<>0 then VecXorEq(g0,v);
  VecShiftL1(v1,v);
  VecShiftR1(v2,v);
  VecCopy(v,v1);
  VecXorEq(v,v2);
  MaskDeg(v,n-1);
  end;
MaskDeg(g0,n-1);
if n-r0-1<0 then jmax:=0 else jmax:=n-r0-1;
TimeMark('g');
if jmax=0 then VecCopy(g1,g0)
else if r0<jmax then
  begin
  VecZero(v);
  VecShiftL1(v1,g0);
  VecShiftR1(v2,g0);
  VecCopy(v,v1);
  VecXorEq(v,v2);
  MaskDeg(v,n-1);
  VecZero(g1); VecZero(g2);
  for i:=0 to n-1 do if GetBit(g0,i)<>0 then SetBit(g1,n-1-i,1);
  for i:=0 to n-1 do if GetBit(v,i)<>0 then SetBit(g2,n-1-i,1);
  MaskDeg(g1,n-1); MaskDeg(g2,n-1);
  for j:=1 to r0 do
    begin
    VecShiftL1(v1,g2);
    VecShiftR1(v2,g2);
    VecCopy(g0,v1);
    VecXorEq(g0,v2);
    VecXorEq(g0,g1);
    MaskDeg(g0,n-1);
    g1:=g2;
    g2:=g0;
    end;
  end
else
  begin
  VecCopy(g1,g0);
  for j:=1 to jmax do
    begin
    VecShiftL1(v1,g1);
    VecShiftR1(v2,g1);
    VecCopy(g0,v1);
    VecXorEq(g0,v2);
    VecXorEq(g0,g2);
    MaskDeg(g0,n-1);
    g2:=g1;
    g1:=g0;
    end;
  end;
TimeMark('x');
VecZero(x); VecNorm(x);
if r0<=n-1 then
for i:=n-1 downto r0 do
  begin
  if GetBit(z,i)<>0 then
  begin
    i0:=i-r0;
    VecXorEq(z,g1);
    SetBit(x,i0,1);
  end;
  if i>r0 then
    begin
    VecShiftL1(v1,g2);
    VecShiftR1(v2,g2);
    VecCopy(g0,v1);
    VecXorEq(g0,v2);
    VecXorEq(g0,g1);
    MaskDeg(g0,n-1);
    g1:=g2;
    g2:=g0;
    end;
  end;
end;
TimeMark('t');
end;

function GeneMat():boolean;
var wn0:longint;
var mask0:LongWord;
var k2:longint;
var x2,x1,x0:TVec;
begin
VecZero(x2); VecNorm(x2);
VecCopy(x1,x); MaskDeg(x1,n-1);
{$ifdef disp}
VecCopy(t[0],x1); MaskDeg(t[0],n-1);
{$endif}
for j:=1 to n-1 do
  begin
  VecShiftL1(v1,x1);
  VecShiftR1(v2,x1);
  VecCopy(x0,v1);
  VecXorEq(x0,x1);
  VecXorEq(x0,v2);
  VecXorEq(x0,x2);
  VecXorEq(x0,ones);
  MaskDeg(x0,n-1);
  {$ifdef disp}
  VecCopy(t[j],x0);
  {$endif}
  VecCopy(x2,x1);
  VecCopy(x1,x0);
  end;
VecShiftL1(v1,x1);
VecShiftR1(v2,x1);
VecCopy(v3,v1);
VecXorEq(v3,x1);
VecXorEq(v3,v2);
VecXorEq(v3,x2);
MaskDeg(v3,n-1);
wn0:=(longint(n)+31) shr 5;
if (longint(n) and 31)=0 then mask0:=$FFFFFFFF else mask0:=(LongWord(1) shl (longint(n) and 31))-1;
GeneMat:=true;
for k2:=0 to wn0-2 do GeneMat:=GeneMat and (v3[k2]=$FFFFFFFF);
GeneMat:=GeneMat and ((v3[wn0-1] and mask0)=mask0);
write(GeneMat);
end;

begin
{$ifdef disp}
CreateWin(m,m);
bb:=CreateBB(GetWin());
bp:=CreateBMP(m,m);
{$endif}
{$ifdef disp}
for n:=1 to m do
{$else}
for n:=9000 to m do
{$endif}
  begin
  PrepN;
  write(n,#9);
  TimeMark('m');MakeMat();
  TimeMark('c');CalcMat2();
  TimeMark('g');GeneMat();{$ifdef disp}write('%');PrintMat('_T2',t);{$endif}
  {$ifdef disp}if not(iswin()) then halt;{$endif}
  writeln();
  end;
end.
