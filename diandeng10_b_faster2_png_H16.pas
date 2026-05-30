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
var l,l0,f,c:TVec;
var ll2,ll1,ll02,ll01,ff2,ff1,cc2,cc1:TVec;
var lastLN,lastFN:longint;
var matInit:boolean;
var d:TMat;
{$ifdef disp}
var t:TMat;
{$endif}
var i,j:longint;
var lastTick:DWORD;
var hasLastTick:boolean;
var wn:longint;
var lastMask:LongWord;
var ones:TVec;
var v0,v1,v2,v3:TVec;
var q,x,y,z,g,vx,vy:TVec;

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
var ln,l0n,fn,cn:TVec;
begin
if (not matInit) or (longint(n)<lastLN) or (longint(n)<lastFN) then
  begin
  VecZero(ll2); VecZero(ll1); VecZero(ll02); VecZero(ll01);
  VecZero(ff2); VecZero(ff1); VecZero(cc2); VecZero(cc1);
  SetBit(ff1,0,1); SetBit(cc1,0,1);
  lastLN:=0; lastFN:=0; matInit:=true;
  end;
for j:=lastLN+1 to n do
  begin
  VecZero(l0n); VecZero(ln);
  VecShiftL1(v1,ll01);
  VecShiftR1(v2,ll01);
  VecCopy(l0n,v1);
  VecXorEq(l0n,ll01);
  VecXorEq(l0n,v2);
  VecXorEq(l0n,ll02);
  MaskDeg(l0n,j-1);
  VecShiftL2(v1,ll1);
  VecShiftL1(v2,ll1);
  VecCopy(ln,v1);
  VecXorEq(ln,v2);
  VecXorEq(ln,ll1);
  VecShiftL2(v1,ll2);
  VecXorEq(ln,v1);
  VecShiftL1(v1,ll01);
  VecXorEq(ln,v1);
  VecXorEq(ln,ll01);
  VecShiftR1(v1,ll01);
  VecXorEq(ln,v1);
  VecShiftL1(v1,ll02);
  VecXorEq(ln,v1);
  VecXorEq(ln,ll02);
  VecXorEq(ln,ones);
  MaskDeg(ln,j-1);
  SetBit(l0n,0,GetBit(ln,0));
  l0n[-2]:=1;
  ll02:=ll01; ll01:=l0n; ll2:=ll1; ll1:=ln;
  end;
lastLN:=n;
for j:=lastFN+1 to n do
  begin
  VecZero(fn);
  if j=0 then SetBit(fn,0,1)
  else
    begin
    VecShiftL1(v1,ff1);
    VecCopy(fn,v1);
    VecXorEq(fn,ff2);
    MaskDeg(fn,j);
    end;
  ff2:=ff1; ff1:=fn;
  end;
for j:=lastFN+1 to n do
  begin
  VecZero(cn);
  if j=0 then SetBit(cn,0,1)
  else
    begin
    VecShiftL1(v1,cc1);
    VecCopy(cn,v1);
    VecXorEq(cn,cc2);
    VecXorEq(cn,cc1);
    MaskDeg(cn,j);
    end;
  cc2:=cc1; cc1:=cn;
  end;
lastFN:=n;
VecCopy(l,ll1); VecCopy(l0,ll01); VecCopy(f,ff1); VecCopy(c,cc1);
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
var i0,r0:longint;
begin
TimeMark('p');
TimeMark('q');
r0:=gcd(f,c,g,q);
TimeMark('y');
VecCopy(y,l); MaskDeg(y,n-1);
TimeMark('z');
VecZero(z); VecNorm(z);
for j:=0 to n-1 do 
  begin
  if GetBit(q,j)<>0 then VecXorEq(z,y);
  VecShiftL1(v1,y);
  VecShiftR1(v2,y);
  VecCopy(y,v1);
  VecXorEq(y,v2);
  MaskDeg(y,n-1);
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
VecZero(d[0]); VecNorm(d[0]);
VecZero(y); SetBit(y,0,1);
for j:=0 to r0 do 
  begin
  if GetBit(g,j)<>0 then VecXorEq(d[0],y);
  VecShiftL1(v1,y);
  VecShiftR1(v2,y);
  VecCopy(y,v1);
  VecXorEq(y,v2);
  MaskDeg(y,n-1);
  end;
MaskDeg(d[0],n-1);
TimeMark('g');
for j:=1 to n-r0-1 do
  begin
  VecShiftL1(v1,d[j-1]);
  VecShiftR1(v2,d[j-1]);
  VecCopy(d[j],v1);
  VecXorEq(d[j],v2);
  VecXorEq(d[j],d[j-2]);
  MaskDeg(d[j],n-1);
  end;
TimeMark('x');
VecZero(x); VecNorm(x);
for i:=n-1 downto r0 do
  if GetBit(z,i)<>0 then
  begin
    i0:=i-r0;
    VecXorEq(z,d[i0]);
    SetBit(x,i0,1);
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
