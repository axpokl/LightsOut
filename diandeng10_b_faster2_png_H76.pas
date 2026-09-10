//{$define disp}
program diandeng;
{$mode objfpc}{$H+}

{ H76: reuse fixed-factor nibble products in x and skip unused kernel work. }
{ Shared GF(2) formulas and coefficient blocks; B stores 32 coefficients per LongWord. }

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
     PWide=^QWord;
     TWordArray=array of LongWord;
     TQ4=array[0..3] of QWord;
     TQ8=array[0..7] of QWord;
     TQ16=array[0..15] of QWord;
     TQ32=array[0..31] of QWord;
     TQ64=array[0..63] of QWord;
     TMul8Table=array[0..65535] of Word;

var n:longword;
var i:longint;
var x,y,f,f1,c,c1:TVec;
var hf,hf1,hc,hc1:TVec;
var perfFreq,lastCounter:Int64;
var hasLastCounter:boolean;
var warming:boolean;
var wn:longint;
var lastMask:LongWord;
var nMask:LongWord;
var nWord:longint;
var mul8:TMul8Table;
var uKernel8:array[0..255] of LongWord;

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

procedure VecXorRaw(var a:TVec;const b:TVec); inline;
var k2:longint;
begin
for k2:=0 to wn-1 do a[k2]:=a[k2] xor b[k2];
end;

procedure VecXorHTo(var dst:TVec; const src:TVec; hi:longint); inline;
var k2:longint;
var left,cur,right:LongWord;
begin
left:=src[-1]; cur:=src[0];
for k2:=0 to wn-1 do
  begin
  right:=src[k2+1];
  dst[k2]:=dst[k2] xor (cur shl 1) xor (left shr 31) xor
           (cur shr 1) xor (right shl 31);
  left:=cur; cur:=right;
  end;
end;

procedure VecXorIHTo(var dst:TVec; const src:TVec; hi:longint); inline;
var k2:longint;
var left,cur,right:LongWord;
begin
left:=src[-1]; cur:=src[0];
for k2:=0 to wn-1 do
  begin
  right:=src[k2+1];
  dst[k2]:=dst[k2] xor cur xor (cur shl 1) xor (left shr 31) xor
           (cur shr 1) xor (right shl 31);
  left:=cur; cur:=right;
  end;
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

procedure PrepN;
var bits:longint;
var rem:longint;
begin
bits:=longint(n)+1;
wn:=(bits+31) shr 5;
rem:=bits and 31;
if rem=0 then lastMask:=$FFFFFFFF else lastMask:=(LongWord(1) shl rem)-1;
nWord:=(longint(n)-1) shr 5;
rem:=longint(n) and 31;
if rem=0 then nMask:=$FFFFFFFF else nMask:=(LongWord(1) shl rem)-1;
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

function DegMask(deg:longint):LongWord;
var rem:longint;
begin
rem:=deg and 31;
if rem=31 then DegMask:=$FFFFFFFF
else DegMask:=(LongWord(1) shl (rem+1))-1;
end;

procedure VecCopyDeg(var a:TVec; const b:TVec; deg:longint); inline;
var k2,hiw:longint;
begin
a[-2]:=0; a[-1]:=0;
if deg<0 then begin a[0]:=0; exit; end;
hiw:=deg shr 5;
if hiw>mw then hiw:=mw;
for k2:=0 to hiw+1 do if k2<=mw then a[k2]:=b[k2];
if hiw+2<=mw then a[hiw+2]:=0;
end;

function ReverseWord32(x:LongWord):LongWord; inline;
begin
x:=((x and $55555555) shl 1) or ((x shr 1) and $55555555);
x:=((x and $33333333) shl 2) or ((x shr 2) and $33333333);
x:=((x and $0F0F0F0F) shl 4) or ((x shr 4) and $0F0F0F0F);
x:=((x and $00FF00FF) shl 8) or ((x shr 8) and $00FF00FF);
ReverseWord32:=(x shl 16) or (x shr 16);
end;

function ReadVec32Any(const a:TVec; bit0:longint):LongWord;
var w,b:longint;
var r:LongWord;
begin
if bit0>=0 then
  begin
  w:=bit0 shr 5; b:=bit0 and 31;
  if w>mw then begin ReadVec32Any:=0; exit; end;
  r:=a[w] shr b;
  if (b<>0) and (w<mw) then r:=r xor (a[w+1] shl (32-b));
  ReadVec32Any:=r;
  end
else if bit0<=-32 then ReadVec32Any:=0
else ReadVec32Any:=a[0] shl (-bit0);
end;

procedure BuildYFast(var dy_,dy:TVec; const sy_,sy_1,sy,sy1:TVec; deg:longint); inline;
var w,hiw,half,halfw,idx,src:longint;
var mask:LongWord;
begin
hiw:=deg shr 5;
dy_[-2]:=0; dy_[-1]:=0; dy[-2]:=0; dy[-1]:=0;
for w:=0 to hiw do
  dy_[w]:=((sy_[w] shl 1) or (sy_[w-1] shr 31)) xor
          sy_[w] xor
          ((sy_[w] shr 1) or (sy_[w+1] shl 31)) xor
          sy_1[w];
half:=deg div 2;
halfw:=half shr 5;
for w:=0 to halfw do
  dy[w]:=((sy[w] shl 2) or (sy[w-1] shr 30)) xor
         ((sy[w] shl 1) or (sy[w-1] shr 31)) xor
         sy[w] xor
         ((sy1[w] shl 2) or (sy1[w-1] shr 30)) xor
         dy_[w] xor
         ((sy_1[w] shl 1) or (sy_1[w-1] shr 31)) xor
         $FFFFFFFF;
mask:=DegMask(deg);
dy_[hiw]:=dy_[hiw] and mask;
dy[halfw]:=dy[halfw] and DegMask(half);
if half+1<=deg then
  begin
  idx:=half+1; src:=deg-half-1;
  if ((dy[src shr 5] shr (src and 31)) and 1)<>0 then
    dy[idx shr 5]:=dy[idx shr 5] or (LongWord(1) shl (idx and 31))
  else
    dy[idx shr 5]:=dy[idx shr 5] and not(LongWord(1) shl (idx and 31));
  end;
if hiw+1<=mw then dy_[hiw+1]:=0;
end;

procedure ExpandPalindrome(var a:TVec; deg:longint);
var first,bw,hiw,w,off,startP:longint;
var q,lowmask:LongWord;
begin
if deg<0 then exit;
first:=(deg div 2)+1;
bw:=first shr 5;
hiw:=deg shr 5;
for w:=hiw downto bw+1 do
  begin
  startP:=w shl 5;
  a[w]:=ReverseWord32(ReadVec32Any(a,deg-startP-31));
  end;
startP:=bw shl 5;
q:=ReverseWord32(ReadVec32Any(a,deg-startP-31));
off:=first and 31;
if off=0 then lowmask:=0 else lowmask:=(LongWord(1) shl off)-1;
a[bw]:=(a[bw] and lowmask) or (q and not lowmask);
a[hiw]:=a[hiw] and DegMask(deg);
if hiw+1<=mw then a[hiw+1]:=0;
end;

function SpreadBits32(x:LongWord):QWord; inline;
var z0:QWord;
begin
z0:=x;
z0:=(z0 or (z0 shl 16)) and QWord($0000FFFF0000FFFF);
z0:=(z0 or (z0 shl 8)) and QWord($00FF00FF00FF00FF);
z0:=(z0 or (z0 shl 4)) and QWord($0F0F0F0F0F0F0F0F);
z0:=(z0 or (z0 shl 2)) and QWord($3333333333333333);
z0:=(z0 or (z0 shl 1)) and QWord($5555555555555555);
SpreadBits32:=z0;
end;

procedure PutFCDouble(var a:TWordArray; pos:longint; v:QWord); inline;
begin
if pos<=High(a) then a[pos]:=LongWord(v);
if pos+1<=High(a) then a[pos+1]:=LongWord(v shr 32);
end;

procedure DoubleFCDynW(nn:longword; const af,ac,af1,ac1:TWordArray;
                       var nf,nc,nf1,nc1:TWordArray);
var w0,ow,hi0,words:longint;
var saf,sac,saf1,sac1,sef,soc,vf,vc,vf1,vc1:QWord;
var mask0:LongWord;
begin
hi0:=longint(nn div 2);
words:=(hi0 shr 5)+1;
SetLength(nf,words); SetLength(nc,words);
SetLength(nf1,words); SetLength(nc1,words);
for w0:=0 to High(af) do
  begin
  ow:=w0 shl 1;
  saf:=SpreadBits32(af[w0]); sac:=SpreadBits32(ac[w0]);
  saf1:=SpreadBits32(af1[w0]); sac1:=SpreadBits32(ac1[w0]);
  if (nn and 1)=0 then
    begin
    sef:=saf xor saf1; soc:=sac xor sac1;
    vf:=sef xor (soc shl 1);
    vc:=soc;
    vf1:=sac1 shl 1;
    vc1:=(saf1 xor sac1) xor (sac1 shl 1);
    end
  else
    begin
    vf:=sac shl 1;
    vc:=(saf xor sac) xor (sac shl 1);
    vf1:=(saf xor saf1) xor ((sac xor sac1) shl 1);
    vc1:=sac xor sac1;
    end;
  PutFCDouble(nf,ow,vf); PutFCDouble(nc,ow,vc);
  PutFCDouble(nf1,ow,vf1); PutFCDouble(nc1,ow,vc1);
  end;
mask0:=DegMask(hi0);
nf[High(nf)]:=nf[High(nf)] and mask0;
nc[High(nc)]:=nc[High(nc)] and mask0;
nf1[High(nf1)]:=nf1[High(nf1)] and mask0;
nc1[High(nc1)]:=nc1[High(nc1)] and mask0;
end;

procedure BuildFCDynW(nn:longword; var nf,nc,nf1,nc1:TWordArray);
var af,ac,af1,ac1:TWordArray;
begin
if nn=0 then
  begin
  SetLength(nf,1); SetLength(nc,1);
  SetLength(nf1,1); SetLength(nc1,1);
  nf[0]:=1;
  exit;
  end;
BuildFCDynW(nn div 2,af,ac,af1,ac1);
DoubleFCDynW(nn,af,ac,af1,ac1,nf,nc,nf1,nc1);
end;

procedure CopyFCDynW(var dst:TVec; const src:TWordArray; hi:longint); inline;
var w0:longint;
begin
VecZero(dst);
for w0:=0 to High(src) do dst[w0]:=src[w0];
MaskDeg(dst,hi);
end;

procedure BuildFCPairsFastW(nn:longword; var nf,nc,nf1,nc1,hf0,hc0,hf10,hc10:TVec);
var df,dc,df1,dc1,dhf,dhc,dhf1,dhc1:TWordArray;
var hi0,hhi:longint;
begin
BuildFCDynW(nn div 2,dhf,dhc,dhf1,dhc1);
if nn=0 then
  begin
  df:=dhf; dc:=dhc; df1:=dhf1; dc1:=dhc1;
  end
else
  DoubleFCDynW(nn,dhf,dhc,dhf1,dhc1,df,dc,df1,dc1);
hi0:=longint(nn div 2); hhi:=longint((nn div 2) div 2);
CopyFCDynW(nf,df,hi0); CopyFCDynW(nc,dc,hi0);
CopyFCDynW(nf1,df1,hi0); CopyFCDynW(nc1,dc1,hi0);
CopyFCDynW(hf0,dhf,hhi); CopyFCDynW(hc0,dhc,hhi);
CopyFCDynW(hf10,dhf1,hhi); CopyFCDynW(hc10,dhc1,hhi);
end;

procedure DoubleFCVecW(nn:longword; const af,ac,af1,ac1:TVec;
                       var nf,nc,nf1,nc1:TVec; srcHi:longint);
var w0,ow,hi0,srcWords,outWords:longint;
var saf,sac,saf1,sac1,sef,soc,vf,vc,vf1,vc1:QWord;
var mask0:LongWord;
begin
hi0:=longint(nn div 2);
srcWords:=(srcHi shr 5)+1;
outWords:=(hi0 shr 5)+1;
for w0:=0 to srcWords-1 do
  begin
  ow:=w0 shl 1;
  saf:=SpreadBits32(af[w0]); sac:=SpreadBits32(ac[w0]);
  saf1:=SpreadBits32(af1[w0]); sac1:=SpreadBits32(ac1[w0]);
  if (nn and 1)=0 then
    begin
    sef:=saf xor saf1; soc:=sac xor sac1;
    vf:=sef xor (soc shl 1);
    vc:=soc;
    vf1:=sac1 shl 1;
    vc1:=(saf1 xor sac1) xor (sac1 shl 1);
    end
  else
    begin
    vf:=sac shl 1;
    vc:=(saf xor sac) xor (sac shl 1);
    vf1:=(saf xor saf1) xor ((sac xor sac1) shl 1);
    vc1:=sac xor sac1;
    end;
  if ow<outWords then
    begin
    nf[ow]:=LongWord(vf); nc[ow]:=LongWord(vc);
    nf1[ow]:=LongWord(vf1); nc1[ow]:=LongWord(vc1);
    end;
  if ow+1<outWords then
    begin
    nf[ow+1]:=LongWord(vf shr 32); nc[ow+1]:=LongWord(vc shr 32);
    nf1[ow+1]:=LongWord(vf1 shr 32); nc1[ow+1]:=LongWord(vc1 shr 32);
    end;
  end;
mask0:=DegMask(hi0);
nf[outWords-1]:=nf[outWords-1] and mask0;
nc[outWords-1]:=nc[outWords-1] and mask0;
nf1[outWords-1]:=nf1[outWords-1] and mask0;
nc1[outWords-1]:=nc1[outWords-1] and mask0;
nf[-2]:=0; nf[-1]:=0; if outWords<=mw then nf[outWords]:=0;
nc[-2]:=0; nc[-1]:=0; if outWords<=mw then nc[outWords]:=0;
nf1[-2]:=0; nf1[-1]:=0; if outWords<=mw then nf1[outWords]:=0;
nc1[-2]:=0; nc1[-1]:=0; if outWords<=mw then nc1[outWords]:=0;
end;

procedure BuildFCPairsIterW(nn:longword; var nf,nc,nf1,nc1,hf0,hc0,hf10,hc10:TVec);
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
pf^[0]:=1; pc^[0]:=0; pf1^[0]:=0; pc1^[0]:=0;
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
  DoubleFCVecW(targetN,pf^,pc^,pf1^,pc1^,pnf^,pnc^,pnf1^,pnc1^,curHi);
  pt:=pf; pf:=pnf; pnf:=pt;
  pt:=pc; pc:=pnc; pnc:=pt;
  pt:=pf1; pf1:=pnf1; pnf1:=pt;
  pt:=pc1; pc1:=pnc1; pnc1:=pt;
  curN:=targetN;
  curHi:=longint(curN div 2);
  bitMask:=bitMask shr 1;
  end;
DoubleFCVecW(nn,pf^,pc^,pf1^,pc1^,pnf^,pnc^,pnf1^,pnc1^,curHi);
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

procedure ApplyUComboOnesW(const va,vb:TVec; var vdst:TVec; hi,degmax:longint); forward;

procedure ApplyFibonacciOnesW(var dst:TVec; degree:longint); forward;

procedure MakeMat();
begin
if not warming then TimeMark('m');
BuildFCPairsIterW(n,f,c,f1,c1,hf,hc,hf1,hc1);
ApplyFibonacciOnesW(y,longint(n));
end;

function HighBit32(x:LongWord):longint; inline;
begin
if x=0 then HighBit32:=-1 else HighBit32:=BsrDWord(x);
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


procedure VecStepJ(var dst:TVec; const src:TVec; hi:longint); inline;
var k2:longint;
var left,cur,right:LongWord;
begin
if hi<=0 then begin VecZero(dst); exit; end;
dst[-2]:=0; dst[-1]:=0;
left:=src[-1]; cur:=src[0];
for k2:=0 to wn-1 do
  begin
  right:=src[k2+1];
  dst[k2]:=(cur shl 2) xor (left shr 30) xor
           (cur shr 2) xor (right shl 30) xor
           (cur shl 1) xor (left shr 31) xor
           (cur shr 1) xor (right shl 31);
  left:=cur; cur:=right;
  end;
if (src[0] and 1)<>0 then dst[0]:=dst[0] xor 1;
if (hi>0) and (((src[hi shr 5] shr (hi and 31)) and 1)<>0) then
  dst[hi shr 5]:=dst[hi shr 5] xor (LongWord(1) shl (hi and 31));
if wn<=mw then dst[wn]:=0;
if wn+1<=mw then dst[wn+1]:=0;
dst[nWord]:=dst[nWord] and nMask;
if nWord+1<=mw then dst[nWord+1]:=0;
end;

procedure VecStepJHi(var dst:TVec; const src:TVec; hi:longint); inline;
var k2,hiw,rem:longint;
var left,cur,right,mask:LongWord;
begin
if hi<=0 then begin VecZero(dst); exit; end;
hiw:=hi shr 5;
dst[-2]:=0; dst[-1]:=0;
left:=src[-1]; cur:=src[0];
for k2:=0 to hiw do
  begin
  right:=src[k2+1];
  dst[k2]:=(cur shl 2) xor (left shr 30) xor
           (cur shr 2) xor (right shl 30) xor
           (cur shl 1) xor (left shr 31) xor
           (cur shr 1) xor (right shl 31);
  left:=cur; cur:=right;
  end;
if (src[0] and 1)<>0 then dst[0]:=dst[0] xor 1;
if (((src[hi shr 5] shr (hi and 31)) and 1)<>0) then
  dst[hi shr 5]:=dst[hi shr 5] xor (LongWord(1) shl (hi and 31));
rem:=hi and 31;
if rem=31 then mask:=$FFFFFFFF else mask:=(LongWord(1) shl (rem+1))-1;
dst[hiw]:=dst[hiw] and mask;
if hiw+1<=mw then dst[hiw+1]:=0;
if hiw+2<=mw then dst[hiw+2]:=0;
end;

procedure VecStepJXorTo(var acc,dst:TVec; const src:TVec; hi,mode:longint); inline;
var k2:longint;
var left,cur,right,h:LongWord;
begin
if hi<=0 then begin VecZero(dst); exit; end;
dst[-2]:=0; dst[-1]:=0;
left:=src[-1]; cur:=src[0];
for k2:=0 to wn-1 do
  begin
  right:=src[k2+1];
  h:=(cur shl 1) xor (left shr 31) xor (cur shr 1) xor (right shl 31);
  case mode of
    1: acc[k2]:=acc[k2] xor cur;
    2: acc[k2]:=acc[k2] xor h;
    3: acc[k2]:=acc[k2] xor cur xor h;
    end;
  dst[k2]:=(cur shl 2) xor (left shr 30) xor
           (cur shr 2) xor (right shl 30) xor h;
  left:=cur; cur:=right;
  end;
if (src[0] and 1)<>0 then dst[0]:=dst[0] xor 1;
if (hi>0) and (((src[hi shr 5] shr (hi and 31)) and 1)<>0) then
  dst[hi shr 5]:=dst[hi shr 5] xor (LongWord(1) shl (hi and 31));
if wn<=mw then dst[wn]:=0;
if wn+1<=mw then dst[wn+1]:=0;
dst[nWord]:=dst[nWord] and nMask;
if nWord+1<=mw then dst[nWord+1]:=0;
end;

procedure VecH(var dst:TVec; const src:TVec; hi:longint);
var k2:longint;
var left,cur,right:LongWord;
begin
dst[-2]:=0; dst[-1]:=0;
left:=src[-1]; cur:=src[0];
for k2:=0 to wn-1 do
  begin
  right:=src[k2+1];
  dst[k2]:=(cur shl 1) xor (left shr 31) xor (cur shr 1) xor (right shl 31);
  left:=cur; cur:=right;
  end;
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
  if GetBit(va,j2)<>0 then VecXorRaw(vdst,pcur^);
  if j2>=d then break;
  VecStepJ(pnxt^,pcur^,hi);
  pt:=pcur; pcur:=pnxt; pnxt:=pt;
  end;
MaskDeg(vdst,hi);
end;

procedure ApplyPolyU0(const va:TVec; var vdst:TVec; hi,degmax:longint);
var cur0,cur1:TVec;
var pcur,pnxt,pt:PVec;
var d,j2,k2,curHi,nextHi,curWord:longint;
begin
VecZero(cur0); VecZero(cur1); VecZero(vdst);
d:=TopBitLE(va,degmax);
if d<0 then exit;
cur0[0]:=1;
pcur:=@cur0;
pnxt:=@cur1;
curHi:=0;
for j2:=0 to d do
  begin
  if GetBit(va,j2)<>0 then
    begin
    curWord:=curHi shr 5;
    for k2:=0 to curWord do vdst[k2]:=vdst[k2] xor pcur^[k2];
    end;
  if j2>=d then break;
  nextHi:=curHi+2; if nextHi>hi then nextHi:=hi;
  VecStepJHi(pnxt^,pcur^,nextHi);
  pt:=pcur; pcur:=pnxt; pnxt:=pt;
  curHi:=nextHi;
  end;
MaskDeg(vdst,hi);
end;

function CLMul8(a,b:LongWord):LongWord; inline;
begin
CLMul8:=mul8[(a shl 8) or b];
end;

function CLMul16(a,b:LongWord):LongWord; inline;
var z0,z1,z2:LongWord;
begin
z0:=CLMul8(a and $FF,b and $FF);
z2:=CLMul8(a shr 8,b shr 8);
z1:=CLMul8((a xor (a shr 8)) and $FF,(b xor (b shr 8)) and $FF);
CLMul16:=z0 xor ((z0 xor z1 xor z2) shl 8) xor (z2 shl 16);
end;

function CLMul32(a,b:LongWord):QWord; inline;
var z0,z1,z2:LongWord;
begin
z0:=CLMul16(a and $FFFF,b and $FFFF);
z2:=CLMul16(a shr 16,b shr 16);
z1:=CLMul16((a xor (a shr 16)) and $FFFF,(b xor (b shr 16)) and $FFFF);
CLMul32:=QWord(z0) xor (QWord(z0 xor z1 xor z2) shl 16) xor (QWord(z2) shl 32);
end;

procedure InitMul8;
var a0,b0,k0,r0:longint;
begin
for a0:=0 to 255 do for b0:=0 to 255 do
  begin
  r0:=0;
  for k0:=0 to 7 do if ((b0 shr k0) and 1)<>0 then r0:=r0 xor (a0 shl k0);
  mul8[(a0 shl 8) or b0]:=r0;
  end;
end;

procedure InitUKernel8;
var a0,j0:longint;
var p0,k0:QWord;
begin
for a0:=0 to 255 do
  begin
  p0:=QWord(1) shl 14;
  k0:=0;
  for j0:=0 to 7 do
    begin
    if ((a0 shr j0) and 1)<>0 then k0:=k0 xor p0;
    if j0<7 then p0:=(p0 shl 2) xor (p0 shl 1) xor (p0 shr 1) xor (p0 shr 2);
    end;
  uKernel8[a0]:=LongWord(k0);
  end;
end;

{ H73: convolution core with fused 64-coefficient leaves. }
procedure KarConvW(const a:TWordArray; ao:longint; const b:TWordArray; bo:longint;
                  var r:TWordArray; ro,lenWords,alen,blen:longint;
                  var work:TWordArray; wo:longint);
const cut=8;
var afull,bfull,startB,ai,bi,ri:longint;
var z0,z1,z2:QWord; ax,bx:LongWord;
var i0,j0,lenBits,hWords,gWords,ax0,bx0,z10,rec0:longint;
var a0len,a1len,b0len,b1len,axlen,bxlen,aWords,bWords:longint;
var p0:QWord;
var mid0:LongWord;
begin
lenBits:=lenWords shl 5;
if alen>lenBits then alen:=lenBits;
if blen>lenBits then blen:=lenBits;
if (alen<=0) or (blen<=0) then exit;
if lenWords<=cut then
  begin
  aWords:=(alen+31) shr 5;
  bWords:=(blen+31) shr 5;
  afull:=(alen div 64)*2; bfull:=(blen div 64)*2;
  for i0:=0 to afull div 2-1 do for j0:=0 to bfull div 2-1 do
    begin
    ai:=ao+i0*2; bi:=bo+j0*2; ri:=ro+(i0+j0)*2;
z0:=0; z1:=0; z2:=0;
if (a[ai]<>0) and (b[bi]<>0) then z0:=CLMul32(a[ai],b[bi]);
if (a[ai+1]<>0) and (b[bi+1]<>0) then z2:=CLMul32(a[ai+1],b[bi+1]);
ax:=a[ai] xor a[ai+1]; bx:=b[bi] xor b[bi+1];
if (ax<>0) and (bx<>0) then z1:=CLMul32(ax,bx);
z1:=z1 xor z0 xor z2;
r[ri]:=r[ri] xor LongWord(z0);
r[ri+1]:=r[ri+1] xor LongWord(z0 shr 32) xor LongWord(z1);
r[ri+2]:=r[ri+2] xor LongWord(z2) xor LongWord(z1 shr 32);
r[ri+3]:=r[ri+3] xor LongWord(z2 shr 32);
    end;
  for i0:=0 to aWords-1 do if a[ao+i0]<>0 then
    begin
    if i0<afull then startB:=bfull else startB:=0;
    for j0:=startB to bWords-1 do if b[bo+j0]<>0 then
      begin
      p0:=CLMul32(a[ao+i0],b[bo+j0]);
      r[ro+i0+j0]:=r[ro+i0+j0] xor LongWord(p0);
      r[ro+i0+j0+1]:=r[ro+i0+j0+1] xor LongWord(p0 shr 32);
      end;
    end;
  exit;
  end;
hWords:=(lenWords+1) shr 1;
gWords:=lenWords-hWords;
if alen>(hWords shl 5) then begin a0len:=hWords shl 5; a1len:=alen-(hWords shl 5); end
else begin a0len:=alen; a1len:=0; end;
if blen>(hWords shl 5) then begin b0len:=hWords shl 5; b1len:=blen-(hWords shl 5); end
else begin b0len:=blen; b1len:=0; end;
if (a1len=0) and (b1len=0) then
  begin
  KarConvW(a,ao,b,bo,r,ro,hWords,a0len,b0len,work,wo);
  exit;
  end;
KarConvW(a,ao,b,bo,r,ro,hWords,a0len,b0len,work,wo);
KarConvW(a,ao+hWords,b,bo+hWords,r,ro+(hWords shl 1),gWords,a1len,b1len,work,wo);
ax0:=wo; bx0:=wo+hWords; z10:=wo+(hWords shl 1); rec0:=wo+(hWords shl 2);
for i0:=0 to gWords-1 do
  begin
  work[ax0+i0]:=a[ao+i0] xor a[ao+hWords+i0];
  work[bx0+i0]:=b[bo+i0] xor b[bo+hWords+i0];
  end;
for i0:=gWords to hWords-1 do
  begin
  work[ax0+i0]:=a[ao+i0];
  work[bx0+i0]:=b[bo+i0];
  end;
for i0:=0 to (hWords shl 1)-1 do work[z10+i0]:=0;
axlen:=a0len; if a1len>axlen then axlen:=a1len;
bxlen:=b0len; if b1len>bxlen then bxlen:=b1len;
KarConvW(work,ax0,work,bx0,work,z10,hWords,axlen,bxlen,work,rec0);
{ Share the overlap XOR before writing either middle block. }
for i0:=0 to (gWords shl 1)-hWords-1 do
  begin
  mid0:=r[ro+hWords+i0] xor r[ro+(hWords shl 1)+i0];
  r[ro+hWords+i0]:=mid0 xor r[ro+i0] xor work[z10+i0];
  r[ro+(hWords shl 1)+i0]:=mid0 xor r[ro+hWords*3+i0] xor work[z10+hWords+i0];
  end;
for i0:=(gWords shl 1)-hWords to hWords-1 do
  begin
  mid0:=r[ro+hWords+i0] xor r[ro+(hWords shl 1)+i0];
  r[ro+hWords+i0]:=mid0 xor r[ro+i0] xor work[z10+i0];
  r[ro+(hWords shl 1)+i0]:=mid0 xor work[z10+hWords+i0];
  end;
end;

procedure KarRecW(const a:TWordArray; ao:longint; const b:TWordArray; bo:longint;
                  var r:TWordArray; ro,lenWords,alen,blen:longint;
                  var work:TWordArray; wo:longint);
const cut=8;
var i0,j0,lenBits,hWords,gWords,ax0,bx0,z10,rec0:longint;
var a0len,a1len,b0len,b1len,axlen,bxlen,aWords,bWords:longint;
var p0:QWord;
var mid0:LongWord;
begin
lenBits:=lenWords shl 5;
if alen>lenBits then alen:=lenBits;
if blen>lenBits then blen:=lenBits;
if (alen<=0) or (blen<=0) then exit;
if lenWords<=cut then
  begin
  aWords:=(alen+31) shr 5;
  bWords:=(blen+31) shr 5;
  for i0:=0 to aWords-1 do if a[ao+i0]<>0 then
    for j0:=0 to bWords-1 do if b[bo+j0]<>0 then
      begin
      p0:=CLMul32(a[ao+i0],b[bo+j0]);
      r[ro+i0+j0]:=r[ro+i0+j0] xor LongWord(p0);
      r[ro+i0+j0+1]:=r[ro+i0+j0+1] xor LongWord(p0 shr 32);
      end;
  exit;
  end;
hWords:=(lenWords+1) shr 1;
gWords:=lenWords-hWords;
if alen>(hWords shl 5) then begin a0len:=hWords shl 5; a1len:=alen-(hWords shl 5); end
else begin a0len:=alen; a1len:=0; end;
if blen>(hWords shl 5) then begin b0len:=hWords shl 5; b1len:=blen-(hWords shl 5); end
else begin b0len:=blen; b1len:=0; end;
if (a1len=0) and (b1len=0) then
  begin
  KarRecW(a,ao,b,bo,r,ro,hWords,a0len,b0len,work,wo);
  exit;
  end;
KarRecW(a,ao,b,bo,r,ro,hWords,a0len,b0len,work,wo);
KarRecW(a,ao+hWords,b,bo+hWords,r,ro+(hWords shl 1),gWords,a1len,b1len,work,wo);
ax0:=wo; bx0:=wo+hWords; z10:=wo+(hWords shl 1); rec0:=wo+(hWords shl 2);
for i0:=0 to gWords-1 do
  begin
  work[ax0+i0]:=a[ao+i0] xor a[ao+hWords+i0];
  work[bx0+i0]:=b[bo+i0] xor b[bo+hWords+i0];
  end;
for i0:=gWords to hWords-1 do
  begin
  work[ax0+i0]:=a[ao+i0];
  work[bx0+i0]:=b[bo+i0];
  end;
for i0:=0 to (hWords shl 1)-1 do work[z10+i0]:=0;
axlen:=a0len; if a1len>axlen then axlen:=a1len;
bxlen:=b0len; if b1len>bxlen then bxlen:=b1len;
KarRecW(work,ax0,work,bx0,work,z10,hWords,axlen,bxlen,work,rec0);
{ Share the overlap XOR before writing either middle block. }
for i0:=0 to (gWords shl 1)-hWords-1 do
  begin
  mid0:=r[ro+hWords+i0] xor r[ro+(hWords shl 1)+i0];
  r[ro+hWords+i0]:=mid0 xor r[ro+i0] xor work[z10+i0];
  r[ro+(hWords shl 1)+i0]:=mid0 xor r[ro+hWords*3+i0] xor work[z10+hWords+i0];
  end;
for i0:=(gWords shl 1)-hWords to hWords-1 do
  begin
  mid0:=r[ro+hWords+i0] xor r[ro+(hWords shl 1)+i0];
  r[ro+hWords+i0]:=mid0 xor r[ro+i0] xor work[z10+i0];
  r[ro+(hWords shl 1)+i0]:=mid0 xor work[z10+hWords+i0];
  end;
end;

procedure KarLowW(const a:TWordArray; ao:longint; const b:TWordArray; bo:longint;
                  var r:TWordArray; ro,alen,blen,lim:longint;
                  var work:TWordArray; wo:longint);
const cut=8;
var lenWords,hWords,h,a0len,b0len,k,i0,j0,last,rec0,top:longint;
var aWords,bWords,kWords:longint;
var product:QWord;
var av,bv,maskA,maskB:LongWord;
begin
if alen>lim then alen:=lim;
if blen>lim then blen:=lim;
if (lim<=0) or (alen<=0) or (blen<=0) then exit;
top:=alen; if blen>top then top:=blen;
if lim>=alen+blen-1 then
  begin
  KarRecW(a,ao,b,bo,r,ro,(top+31) shr 5,alen,blen,work,wo);
  exit;
  end;
lenWords:=(lim+31) shr 5;
if lenWords<=cut then
  begin
  aWords:=(alen+31) shr 5; bWords:=(blen+31) shr 5;
  maskA:=LongWord($FFFFFFFF) shr ((-alen) and 31);
  maskB:=LongWord($FFFFFFFF) shr ((-blen) and 31);
  for i0:=0 to aWords-1 do
    begin
    av:=a[ao+i0]; if i0=aWords-1 then av:=av and maskA;
    if av<>0 then
      begin
    last:=lenWords-i0; if bWords<last then last:=bWords;
    for j0:=0 to last-1 do
      begin
      bv:=b[bo+j0]; if j0=bWords-1 then bv:=bv and maskB;
      if bv<>0 then
        begin
      product:=CLMul32(av,bv);
      r[ro+i0+j0]:=r[ro+i0+j0] xor LongWord(product);
      if i0+j0+1<lenWords then
        r[ro+i0+j0+1]:=r[ro+i0+j0+1] xor LongWord(product shr 32);
      end;
    end;
      end;
    end;
  exit;
  end;
hWords:=(lenWords+1) shr 1; h:=hWords shl 5;
a0len:=alen; if a0len>h then a0len:=h;
b0len:=blen; if b0len>h then b0len:=h;
KarRecW(a,ao,b,bo,r,ro,hWords,a0len,b0len,work,wo);
k:=lim-h; kWords:=(k+31) shr 5; rec0:=wo+(hWords shl 1);
if blen>h then
  begin
  FillChar(work[wo],hWords*8,0);
  KarLowW(a,ao,b,bo+hWords,work,wo,a0len,blen-h,k,work,rec0);
  for i0:=0 to kWords-1 do r[ro+hWords+i0]:=r[ro+hWords+i0] xor work[wo+i0];
  end;
if alen>h then
  begin
  FillChar(work[wo],hWords*8,0);
  KarLowW(a,ao+hWords,b,bo,work,wo,alen-h,b0len,k,work,rec0);
  for i0:=0 to kWords-1 do r[ro+hWords+i0]:=r[ro+hWords+i0] xor work[wo+i0];
  end;
end;

procedure KarMulFastW(const a,b:TWordArray; var r:TWordArray;
                      lenWords,alen,blen:longint);
var work:TWordArray;
var i0:longint;
begin
SetLength(r,lenWords shl 1);
for i0:=0 to High(r) do r[i0]:=0;
SetLength(work,lenWords*5);
KarConvW(a,0,b,0,r,0,lenWords,alen,blen,work,0);
end;

procedure KarRecPairW(const a:TWordArray; ao:longint;
                      const b:TWordArray; bo:longint;
                      const c:TWordArray; co:longint;
                      var r:TWordArray; ro:longint;
                      var s:TWordArray; so,lenWords,alen,blen,clen:longint;
                      var work:TWordArray; wo:longint);
const cut=8;
var i0,j0,lenBits,hWords,gWords,ax0,bx0,cx0,zr0,zs0,rec0:longint;
var a0len,a1len,b0len,b1len,c0len,c1len,axlen,bxlen,cxlen,common:longint;
var aWords,bWords,cWords:longint;
var p0:QWord;
var mid0,mid1:LongWord;
begin
lenBits:=lenWords shl 5;
if alen>lenBits then alen:=lenBits;
if blen>lenBits then blen:=lenBits;
if clen>lenBits then clen:=lenBits;
if (alen<=0) or ((blen<=0) and (clen<=0)) then exit;
if lenWords<=cut then
  begin
  aWords:=(alen+31) shr 5;
  bWords:=(blen+31) shr 5;
  cWords:=(clen+31) shr 5;
  common:=bWords; if cWords<common then common:=cWords;
  for i0:=0 to aWords-1 do if a[ao+i0]<>0 then
    begin
    for j0:=0 to common-1 do
      begin
      if b[bo+j0]<>0 then
        begin
        p0:=CLMul32(a[ao+i0],b[bo+j0]);
        r[ro+i0+j0]:=r[ro+i0+j0] xor LongWord(p0);
        r[ro+i0+j0+1]:=r[ro+i0+j0+1] xor LongWord(p0 shr 32);
        end;
      if c[co+j0]<>0 then
        begin
        p0:=CLMul32(a[ao+i0],c[co+j0]);
        s[so+i0+j0]:=s[so+i0+j0] xor LongWord(p0);
        s[so+i0+j0+1]:=s[so+i0+j0+1] xor LongWord(p0 shr 32);
        end;
      end;
    for j0:=common to bWords-1 do if b[bo+j0]<>0 then
      begin
      p0:=CLMul32(a[ao+i0],b[bo+j0]);
      r[ro+i0+j0]:=r[ro+i0+j0] xor LongWord(p0);
      r[ro+i0+j0+1]:=r[ro+i0+j0+1] xor LongWord(p0 shr 32);
      end;
    for j0:=common to cWords-1 do if c[co+j0]<>0 then
      begin
      p0:=CLMul32(a[ao+i0],c[co+j0]);
      s[so+i0+j0]:=s[so+i0+j0] xor LongWord(p0);
      s[so+i0+j0+1]:=s[so+i0+j0+1] xor LongWord(p0 shr 32);
      end;
    end;
  exit;
  end;
hWords:=(lenWords+1) shr 1;
gWords:=lenWords-hWords;
if alen>(hWords shl 5) then begin a0len:=hWords shl 5; a1len:=alen-(hWords shl 5); end
else begin a0len:=alen; a1len:=0; end;
if blen>(hWords shl 5) then begin b0len:=hWords shl 5; b1len:=blen-(hWords shl 5); end
else begin b0len:=blen; b1len:=0; end;
if clen>(hWords shl 5) then begin c0len:=hWords shl 5; c1len:=clen-(hWords shl 5); end
else begin c0len:=clen; c1len:=0; end;
if (a1len=0) and (b1len=0) and (c1len=0) then
  begin
  KarRecPairW(a,ao,b,bo,c,co,r,ro,s,so,hWords,a0len,b0len,c0len,work,wo);
  exit;
  end;
KarRecPairW(a,ao,b,bo,c,co,r,ro,s,so,hWords,a0len,b0len,c0len,work,wo);
KarRecPairW(a,ao+hWords,b,bo+hWords,c,co+hWords,
            r,ro+(hWords shl 1),s,so+(hWords shl 1),gWords,
            a1len,b1len,c1len,work,wo);
ax0:=wo; bx0:=wo+hWords; cx0:=wo+(hWords shl 1);
zr0:=wo+hWords*3; zs0:=wo+hWords*5;
rec0:=wo+hWords*7;
for i0:=0 to gWords-1 do
  begin
  work[ax0+i0]:=a[ao+i0] xor a[ao+hWords+i0];
  work[bx0+i0]:=b[bo+i0] xor b[bo+hWords+i0];
  work[cx0+i0]:=c[co+i0] xor c[co+hWords+i0];
  end;
for i0:=gWords to hWords-1 do
  begin
  work[ax0+i0]:=a[ao+i0];
  work[bx0+i0]:=b[bo+i0];
  work[cx0+i0]:=c[co+i0];
  end;
for i0:=0 to (hWords shl 1)-1 do
  begin
  work[zr0+i0]:=0;
  work[zs0+i0]:=0;
  end;
axlen:=a0len; if a1len>axlen then axlen:=a1len;
bxlen:=b0len; if b1len>bxlen then bxlen:=b1len;
cxlen:=c0len; if c1len>cxlen then cxlen:=c1len;
KarRecPairW(work,ax0,work,bx0,work,cx0,
            work,zr0,work,zs0,hWords,axlen,bxlen,cxlen,work,rec0);
{ Share the overlap XOR before writing either middle block. }
for i0:=0 to (gWords shl 1)-hWords-1 do
  begin
  mid0:=r[ro+hWords+i0] xor r[ro+(hWords shl 1)+i0];
  r[ro+hWords+i0]:=mid0 xor r[ro+i0] xor work[zr0+i0];
  r[ro+(hWords shl 1)+i0]:=mid0 xor r[ro+hWords*3+i0] xor work[zr0+hWords+i0];
  mid1:=s[so+hWords+i0] xor s[so+(hWords shl 1)+i0];
  s[so+hWords+i0]:=mid1 xor s[so+i0] xor work[zs0+i0];
  s[so+(hWords shl 1)+i0]:=mid1 xor s[so+hWords*3+i0] xor work[zs0+hWords+i0];
  end;
for i0:=(gWords shl 1)-hWords to hWords-1 do
  begin
  mid0:=r[ro+hWords+i0] xor r[ro+(hWords shl 1)+i0];
  r[ro+hWords+i0]:=mid0 xor r[ro+i0] xor work[zr0+i0];
  r[ro+(hWords shl 1)+i0]:=mid0 xor work[zr0+hWords+i0];
  mid1:=s[so+hWords+i0] xor s[so+(hWords shl 1)+i0];
  s[so+hWords+i0]:=mid1 xor s[so+i0] xor work[zs0+i0];
  s[so+(hWords shl 1)+i0]:=mid1 xor work[zs0+hWords+i0];
  end;
end;

procedure KarMulPairFastW(const a,b,c:TWordArray; var r,s:TWordArray;
                          lenWords,alen,blen,clen:longint);
var work:TWordArray;
var i0:longint;
begin
SetLength(r,lenWords shl 1);
SetLength(s,lenWords shl 1);
for i0:=0 to High(r) do
  begin
  r[i0]:=0;
  s[i0]:=0;
  end;
SetLength(work,lenWords*10);
KarRecPairW(a,0,b,0,c,0,r,0,s,0,lenWords,alen,blen,clen,work,0);
end;

type
  THBuffer=array[0..m*128+1024] of LongWord;
  PHBuffer=^THBuffer;
  THPolyW=record
    v:PHBuffer; cap:longint;
    d:longint;
  end;
  THMatW=record
    p00,p01,p10,p11:THPolyW;
  end;

{ Fixed recursion leaf: degree <= 2048, identical in A/B. }
const hgcdCutW=2048;
      divCutW=64;

function HPWMask(bits:longint):LongWord; inline;
begin
if bits<=0 then HPWMask:=0
else if bits>=32 then HPWMask:=$FFFFFFFF
else HPWMask:=(LongWord(1) shl bits)-1;
end;

function HPWGet(const a:THPolyW; p:longint):boolean; inline;
begin
if (p<0) or (p>a.d) then HPWGet:=false
else HPWGet:=(a.v^[p shr 5] and (LongWord(1) shl (p and 31)))<>0;
end;

var qPool,qA,qB,qC,qR,qS,qWork:TWordArray;
var qTop,qPeak:longint;

procedure HPWAlloc(out a:THPolyW; count:longint); inline;
begin
a.d:=-1; a.cap:=count;
if count<=0 then begin a.v:=nil; exit; end;
if qTop+count>Length(qPool) then Halt(217);
a.v:=PHBuffer(@qPool[qTop]);
FillChar(a.v^[0],count*SizeOf(LongWord),0);
inc(qTop,count); if qTop>qPeak then qPeak:=qTop;
end;

procedure HPWMoveInto(const src:THPolyW; var dst:THPolyW); inline;
begin
if src.cap>dst.cap then Halt(218);
if src.cap>0 then Move(src.v^[0],dst.v^[0],src.cap*SizeOf(LongWord));
dst.d:=src.d; dst.cap:=src.cap;
end;

procedure HPWZero(out a:THPolyW); inline;
begin
HPWAlloc(a,0); a.d:=-1;
end;

procedure HPWOne(out a:THPolyW); inline;
begin
HPWAlloc(a,1); a.v^[0]:=1; a.d:=0;
end;

procedure HPWNorm(var a:THPolyW);
var w0,k0:longint; z0:LongWord;
begin
w0:=(a.cap-1);
while (w0>=0) and (a.v^[w0]=0) do dec(w0);
if w0<0 then begin a.cap:=0; a.d:=-1; exit; end;
z0:=a.v^[w0]; k0:=HighBit32(z0);
a.d:=(w0 shl 5)+k0;
a.cap:=w0+1;
end;

procedure HPWCopy(const a:THPolyW; out b:THPolyW); inline;
begin b:=a; end;

procedure HPWCopyDeep(const a:THPolyW; out b:THPolyW); inline;
var i0:longint;
begin
HPWAlloc(b,a.cap); b.d:=a.d;
for i0:=0 to (a.cap-1) do b.v^[i0]:=a.v^[i0];
end;

procedure HPWFromVec(const a:TVec; hi:longint; out b:THPolyW);
var i0,degree:longint;
begin
degree:=TopBitLE(a,hi);
if degree<0 then begin HPWZero(b); exit; end;
HPWAlloc(b,(degree+32) shr 5);
b.d:=degree;
for i0:=0 to b.cap-1 do b.v^[i0]:=a[i0];
b.v^[b.cap-1]:=b.v^[b.cap-1] and HPWMask((degree and 31)+1);
end;

procedure HPWToVec(const a:THPolyW; var b:TVec; hi:longint);
var i0,lim,words:longint;
begin
VecZero(b);
lim:=a.d; if lim>hi then lim:=hi;
if lim<0 then exit;
words:=(lim+32) shr 5;
if words>mw+1 then words:=mw+1;
for i0:=0 to words-1 do b[i0]:=a.v^[i0];
MaskDeg(b,hi);
end;

procedure HPWAdd(const a,b:THPolyW; out c:THPolyW);
var i0,words:longint;
begin
words:=a.cap; if b.cap>words then words:=b.cap;
if words=0 then begin HPWZero(c); exit; end;
HPWAlloc(c,words);
for i0:=0 to words-1 do
  begin
  c.v^[i0]:=0;
  if i0<a.cap then c.v^[i0]:=a.v^[i0];
  if i0<b.cap then c.v^[i0]:=c.v^[i0] xor b.v^[i0];
  end;
HPWNorm(c);
end;

procedure HPWTrunc(const a:THPolyW; out c:THPolyW; lim:longint);
var words,i0,rem0:longint;
begin
if lim<=0 then begin HPWZero(c); exit; end;
words:=(lim+31) shr 5;
if words>a.cap then words:=a.cap;
if words=0 then begin HPWZero(c); exit; end;
HPWAlloc(c,words);
for i0:=0 to words-1 do c.v^[i0]:=a.v^[i0];
rem0:=lim and 31;
if (rem0<>0) and (lim<=a.d+1) then c.v^[words-1]:=c.v^[words-1] and HPWMask(rem0);
HPWNorm(c);
end;

procedure HPWShiftDown(const a:THPolyW; sh:longint; out c:THPolyW);
var top,words,sw,sb,i0:longint; z0:LongWord;
begin
top:=a.d-sh;
if top<0 then begin HPWZero(c); exit; end;
words:=(top+32) shr 5;
HPWAlloc(c,words);
sw:=sh shr 5; sb:=sh and 31;
for i0:=0 to words-1 do
  begin
  if sw+i0<a.cap then z0:=a.v^[sw+i0] shr sb else z0:=0;
  if (sb<>0) and (sw+i0+1<a.cap) then
    z0:=z0 xor (a.v^[sw+i0+1] shl (32-sb));
  c.v^[i0]:=z0;
  end;
HPWNorm(c);
end;

procedure HPWMul(const a,b:THPolyW; out c:THPolyW);
var lenWords,top,words,i0:longint; z:QWord;
begin
if (a.d<0) or (b.d<0) then begin HPWZero(c); exit; end;
if a.d=0 then begin HPWCopy(b,c); exit; end;
if b.d=0 then begin HPWCopy(a,c); exit; end;
if (a.d<32) or (b.d<32) then
  begin
  if a.d>b.d then begin HPWMul(b,a,c); exit; end;
  top:=a.d+b.d; words:=(top+32) shr 5; HPWAlloc(c,words);
  for i0:=0 to words-1 do c.v^[i0]:=0;
  for i0:=0 to (b.cap-1) do
    begin
    z:=CLMul32(a.v^[0],b.v^[i0]); c.v^[i0]:=c.v^[i0] xor LongWord(z);
    if i0+1<words then c.v^[i0+1]:=c.v^[i0+1] xor LongWord(z shr 32);
    end;
  c.d:=top; exit;
  end;
top:=a.d; if b.d>top then top:=b.d;
lenWords:=(top+32) shr 5; if lenWords<1 then lenWords:=1;
FillChar(qA[0],lenWords*4,0); FillChar(qB[0],lenWords*4,0);
for i0:=0 to a.cap-1 do qA[i0]:=a.v^[i0];
for i0:=0 to b.cap-1 do qB[i0]:=b.v^[i0];
FillChar(qR[0],lenWords*8,0);
KarRecW(qA,0,qB,0,qR,0,lenWords,a.d+1,b.d+1,qWork,0);
top:=a.d+b.d; words:=(top+32) shr 5; HPWAlloc(c,words);
for i0:=0 to words-1 do c.v^[i0]:=qR[i0];
HPWNorm(c);
end;

procedure HPWMulPair(const a,b,c:THPolyW; out r,s:THPolyW);
var top,lenWords,words,i0:longint;
begin
if a.d<0 then begin HPWZero(r); HPWZero(s); exit; end;
if (a.d<32) or (b.d<32) or (c.d<32) then
  begin HPWMul(a,b,r); HPWMul(a,c,s); exit; end;
if b.d<0 then begin HPWZero(r); HPWMul(a,c,s); exit; end;
if c.d<0 then begin HPWMul(a,b,r); HPWZero(s); exit; end;
top:=a.d; if b.d>top then top:=b.d; if c.d>top then top:=c.d;
lenWords:=(top+32) shr 5; if lenWords<1 then lenWords:=1;
FillChar(qA[0],lenWords*4,0); FillChar(qB[0],lenWords*4,0); FillChar(qC[0],lenWords*4,0);
for i0:=0 to a.cap-1 do qA[i0]:=a.v^[i0];
for i0:=0 to b.cap-1 do qB[i0]:=b.v^[i0];
for i0:=0 to c.cap-1 do qC[i0]:=c.v^[i0];
FillChar(qR[0],lenWords*8,0); FillChar(qS[0],lenWords*8,0);
KarRecPairW(qA,0,qB,0,qC,0,qR,0,qS,0,lenWords,a.d+1,b.d+1,c.d+1,qWork,0);
top:=a.d+b.d; words:=(top+32) shr 5; HPWAlloc(r,words);
for i0:=0 to words-1 do r.v^[i0]:=qR[i0]; HPWNorm(r);
top:=a.d+c.d; words:=(top+32) shr 5; HPWAlloc(s,words);
for i0:=0 to words-1 do s.v^[i0]:=qS[i0]; HPWNorm(s);
end;

{ Truncated paired products retain the shared-operand work of KarRecPair. }
procedure KarLowPairW(const a:TWordArray; ao:longint;
                     const b:TWordArray; bo:longint; const c:TWordArray; co:longint;
                     var r:TWordArray; ro:longint; var s:TWordArray; so:longint;
                     alen,blen,clen,lim:longint; var work:TWordArray; wo:longint);
var lenWords,hWords,h,step,a0len,b0len,c0len,k,i0,j0,lb,lc,common,top,rec0,s0:longint;
var aWords,bWords,cWords,kWords:longint; product:QWord;
var av,bv,cv,maskA,maskB,maskC:LongWord;
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
  KarRecPairW(a,ao,b,bo,c,co,r,ro,s,so,(top+31) shr 5,alen,blen,clen,work,wo);
  exit;
  end;
lenWords:=(lim+31) shr 5;
if lenWords<=8 then
  begin
  aWords:=(alen+31) shr 5; bWords:=(blen+31) shr 5; cWords:=(clen+31) shr 5;
  maskA:=LongWord($FFFFFFFF) shr ((-alen) and 31);
  maskB:=LongWord($FFFFFFFF) shr ((-blen) and 31);
  maskC:=LongWord($FFFFFFFF) shr ((-clen) and 31);
  for i0:=0 to aWords-1 do
    begin
    av:=a[ao+i0]; if i0=aWords-1 then av:=av and maskA;
    if av<>0 then
      begin
    lb:=lenWords-i0; if bWords<lb then lb:=bWords;
    lc:=lenWords-i0; if cWords<lc then lc:=cWords;
    common:=lb; if lc<common then common:=lc;
    for j0:=0 to common-1 do
      begin
      bv:=b[bo+j0]; if j0=bWords-1 then bv:=bv and maskB;
      if bv<>0 then
        begin
        product:=CLMul32(av,bv);
        r[ro+i0+j0]:=r[ro+i0+j0] xor LongWord(product);
        if i0+j0+1<lenWords then r[ro+i0+j0+1]:=r[ro+i0+j0+1] xor LongWord(product shr 32);
        end;
      cv:=c[co+j0]; if j0=cWords-1 then cv:=cv and maskC;
      if cv<>0 then
        begin
        product:=CLMul32(av,cv);
        s[so+i0+j0]:=s[so+i0+j0] xor LongWord(product);
        if i0+j0+1<lenWords then s[so+i0+j0+1]:=s[so+i0+j0+1] xor LongWord(product shr 32);
        end;
      end;
    for j0:=common to lb-1 do
      begin
      bv:=b[bo+j0]; if j0=bWords-1 then bv:=bv and maskB;
      if bv<>0 then
        begin
        product:=CLMul32(av,bv);
        r[ro+i0+j0]:=r[ro+i0+j0] xor LongWord(product);
        if i0+j0+1<lenWords then r[ro+i0+j0+1]:=r[ro+i0+j0+1] xor LongWord(product shr 32);
        end;
      end;
    for j0:=common to lc-1 do
      begin
      cv:=c[co+j0]; if j0=cWords-1 then cv:=cv and maskC;
      if cv<>0 then
        begin
        product:=CLMul32(av,cv);
        s[so+i0+j0]:=s[so+i0+j0] xor LongWord(product);
        if i0+j0+1<lenWords then s[so+i0+j0+1]:=s[so+i0+j0+1] xor LongWord(product shr 32);
        end;
      end;
    end;
    end;
  exit;
  end;
hWords:=(lenWords+1) shr 1; h:=hWords shl 5; step:=hWords;
a0len:=alen; if a0len>h then a0len:=h;
b0len:=blen; if b0len>h then b0len:=h;
c0len:=clen; if c0len>h then c0len:=h;
KarRecPairW(a,ao,b,bo,c,co,r,ro,s,so,hWords,a0len,b0len,c0len,work,wo);
k:=lim-h; s0:=wo+2*step; rec0:=wo+4*step;
kWords:=(k+31) shr 5;
if (blen>h) or (clen>h) then
  begin
  FillChar(work[wo],(step*4)*4,0);
  KarLowPairW(a,ao,b,bo+step,c,co+step,work,wo,work,s0,a0len,blen-h,clen-h,k,work,rec0);
  for i0:=0 to kWords-1 do
    begin
    r[ro+step+i0]:=r[ro+step+i0] xor work[wo+i0];
    s[so+step+i0]:=s[so+step+i0] xor work[s0+i0];
    end;
  end;
if alen>h then
  begin
  FillChar(work[wo],(step*4)*4,0);
  KarLowPairW(a,ao+step,b,bo,c,co,work,wo,work,s0,alen-h,b0len,c0len,k,work,rec0);
  for i0:=0 to kWords-1 do
    begin
    r[ro+step+i0]:=r[ro+step+i0] xor work[wo+i0];
    s[so+step+i0]:=s[so+step+i0] xor work[s0+i0];
    end;
  end;
end;

procedure HPWMulTrunc(const a,b:THPolyW; out c:THPolyW; lim:longint);
var alen,blen,lenWords,aWords,bWords,i0,j0,last:longint;
var product:QWord; av,bv,maskA,maskB:LongWord;
begin
if (lim<=0) or (a.d<0) or (b.d<0) then begin HPWZero(c); exit; end;
if lim>=a.d+b.d+1 then begin HPWMul(a,b,c); exit; end;
alen:=a.d+1; if alen>lim then alen:=lim;
blen:=b.d+1; if blen>lim then blen:=lim;
lenWords:=(lim+31) shr 5; aWords:=(alen+31) shr 5; bWords:=(blen+31) shr 5;
if (alen<32) or (blen<32) or (lim<=256) then
  begin
  if alen>blen then begin HPWMulTrunc(b,a,c,lim); exit; end;
  HPWAlloc(c,lenWords);
  maskA:=HPWMask(((alen-1) and 31)+1); maskB:=HPWMask(((blen-1) and 31)+1);
  for i0:=0 to aWords-1 do
    begin
    av:=a.v^[i0]; if i0=aWords-1 then av:=av and maskA;
    if av<>0 then
      begin
      last:=lenWords-i0; if last>bWords then last:=bWords;
      for j0:=0 to last-1 do
        begin
        bv:=b.v^[j0]; if j0=bWords-1 then bv:=bv and maskB;
        if bv<>0 then
          begin
          product:=CLMul32(av,bv);
          c.v^[i0+j0]:=c.v^[i0+j0] xor LongWord(product);
          if i0+j0+1<lenWords then c.v^[i0+j0+1]:=c.v^[i0+j0+1] xor LongWord(product shr 32);
          end;
        end;
      end;
    end;
  c.v^[lenWords-1]:=c.v^[lenWords-1] and HPWMask(((lim-1) and 31)+1);
  HPWNorm(c); exit;
  end;
FillChar(qA[0],lenWords*4,0); FillChar(qB[0],lenWords*4,0);
for i0:=0 to aWords-1 do qA[i0]:=a.v^[i0];
for i0:=0 to bWords-1 do qB[i0]:=b.v^[i0];
qA[aWords-1]:=qA[aWords-1] and HPWMask(((alen-1) and 31)+1);
qB[bWords-1]:=qB[bWords-1] and HPWMask(((blen-1) and 31)+1);
FillChar(qR[0],lenWords*8,0);
KarLowW(qA,0,qB,0,qR,0,alen,blen,lim,qWork,0);
HPWAlloc(c,lenWords);
for i0:=0 to lenWords-1 do c.v^[i0]:=qR[i0];
c.v^[lenWords-1]:=c.v^[lenWords-1] and HPWMask(((lim-1) and 31)+1);
HPWNorm(c);
end;

procedure HPWXorShift(var a:THPolyW; const b:THPolyW; sh:longint);
var ws,bs,i0,words:longint; z0:LongWord;
begin
ws:=sh shr 5; bs:=sh and 31; words:=b.cap;
for i0:=0 to words-1 do
  begin
  z0:=b.v^[i0];
  if ws+i0<a.cap then a.v^[ws+i0]:=a.v^[ws+i0] xor (z0 shl bs);
  if (bs<>0) and (ws+i0+1<a.cap) then
    a.v^[ws+i0+1]:=a.v^[ws+i0+1] xor (z0 shr (32-bs));
  end;
end;

procedure HPWDivRemClassic(const a,b:THPolyW; out q,r:THPolyW);
var i0,qd:longint;
begin
if b.d<0 then begin HPWZero(q); HPWCopy(a,r); exit; end;
HPWCopyDeep(a,r); qd:=a.d-b.d;
if qd<0 then begin HPWZero(q); exit; end;
HPWAlloc(q,(qd+32) shr 5);
for i0:=0 to (q.cap-1) do q.v^[i0]:=0;
q.d:=qd;
for i0:=a.d downto b.d do
  if HPWGet(r,i0) then
    begin
    q.v^[(i0-b.d) shr 5]:=q.v^[(i0-b.d) shr 5] or
      (LongWord(1) shl ((i0-b.d) and 31));
    HPWXorShift(r,b,i0-b.d);
    end;
HPWNorm(q); HPWNorm(r);
end;

procedure HPWReverseAt(const a:THPolyW; top,k:longint; out c:THPolyW);
var i,start,w,s:longint; z:LongWord;
begin
if k<=0 then begin HPWZero(c); exit; end;
HPWAlloc(c,(k+31) shr 5);
for i:=0 to (c.cap-1) do
  begin
  start:=top-32*i-31; z:=0;
  if start<0 then
    begin if (start>-32) and (a.cap>0) then z:=a.v^[0] shl (-start); end
  else
    begin
    w:=start shr 5; s:=start and 31;
    if w<a.cap then z:=a.v^[w] shr s;
    if (s<>0) and (w+1<a.cap) then z:=z xor (a.v^[w+1] shl (32-s));
    end;
  c.v^[i]:=ReverseWord32(z);
  end;
if (k and 31)<>0 then c.v^[(c.cap-1)]:=c.v^[(c.cap-1)] and ((LongWord(1) shl (k and 31))-1);
c.d:=k-1; HPWNorm(c);
end;

procedure HPWSquareTrunc(const a:THPolyW; out b:THPolyW; lim:longint);
var i,top:longint;
var z:QWord;
begin
top:=a.d*2; if top>=lim then top:=lim-1;
if (a.d<0) or (top<0) then begin HPWZero(b); exit; end;
HPWAlloc(b,(top+32) shr 5);
for i:=0 to (b.cap-1) do b.v^[i]:=0;
for i:=0 to (top div 2) shr 5 do
  begin
  z:=SpreadBits32(a.v^[i]); b.v^[2*i]:=LongWord(z);
  if 2*i+1<b.cap then b.v^[2*i+1]:=LongWord(z shr 32);
  end;
if (top and 31)<>31 then b.v^[(b.cap-1)]:=b.v^[(b.cap-1)] and ((LongWord(1) shl ((top and 31)+1))-1);
b.d:=top; HPWNorm(b);
end;

{ GF(2): if a*g=1 mod x^k, then a*(a*g^2)=1 mod x^(2k). }
procedure HPWInvSeries(const a:THPolyW; k:longint; out g:THPolyW);
var cur,nk:longint; sq,fa,ng:THPolyW;
begin
if k<=0 then begin HPWZero(g); exit; end;
HPWOne(g); cur:=1;
while cur<k do
  begin
  nk:=cur shl 1; if nk>k then nk:=k;
  HPWSquareTrunc(g,sq,nk); HPWTrunc(a,fa,nk); HPWMulTrunc(fa,sq,ng,nk);
  g:=ng; cur:=nk;
  end;
end;

procedure HPWDivRemFast(const a,b:THPolyW; out q,r:THPolyW);
var qlen:longint; ra,rb,iv,qr,prod,tmp:THPolyW;
begin
qlen:=a.d-b.d+1;
if (b.d<0) or (qlen<=0) then begin HPWZero(q); HPWCopy(a,r); exit; end;
HPWReverseAt(a,a.d,qlen,ra); HPWReverseAt(b,b.d,b.d+1,rb); HPWInvSeries(rb,qlen,iv);
HPWMulTrunc(ra,iv,qr,qlen);
HPWReverseAt(qr,qlen-1,qlen,q);
HPWMulTrunc(b,q,prod,b.d); HPWAdd(a,prod,tmp); HPWTrunc(tmp,r,b.d);
end;

procedure HPWDivRem(const a,b:THPolyW; out q,r:THPolyW);
begin
if (a.d-b.d+1)>divCutW then HPWDivRemFast(a,b,q,r)
else HPWDivRemClassic(a,b,q,r);
end;

procedure HPWMatIdentity(out a:THMatW);
begin HPWOne(a.p00); HPWZero(a.p01); HPWZero(a.p10); HPWOne(a.p11); end;

procedure HPWMulPairTrunc(const a,b,c:THPolyW; out r,s:THPolyW; lim:longint);
var alen,blen,clen,top,words,units,i0:longint;
begin
if lim<=0 then begin HPWZero(r); HPWZero(s); exit; end;
top:=b.d; if c.d>top then top:=c.d;
if lim>=a.d+top+1 then begin HPWMulPair(a,b,c,r,s); exit; end;
if (a.d<32) or (b.d<32) or (c.d<32) then
  begin HPWMulTrunc(a,b,r,lim); HPWMulTrunc(a,c,s,lim); exit; end;
alen:=a.d+1; if alen>lim then alen:=lim;
blen:=b.d+1; if blen>lim then blen:=lim;
clen:=c.d+1; if clen>lim then clen:=lim;
words:=(lim+31) shr 5; units:=words;
FillChar(qA[0],units*4,0); FillChar(qB[0],units*4,0); FillChar(qC[0],units*4,0);
for i0:=0 to ((alen+31) shr 5)-1 do qA[i0]:=a.v^[i0];
qA[(alen-1) shr 5]:=qA[(alen-1) shr 5] and HPWMask(((alen-1) and 31)+1);
for i0:=0 to ((blen+31) shr 5)-1 do qB[i0]:=b.v^[i0];
qB[(blen-1) shr 5]:=qB[(blen-1) shr 5] and HPWMask(((blen-1) and 31)+1);
for i0:=0 to ((clen+31) shr 5)-1 do qC[i0]:=c.v^[i0];
qC[(clen-1) shr 5]:=qC[(clen-1) shr 5] and HPWMask(((clen-1) and 31)+1);
FillChar(qR[0],(units*2)*4,0); FillChar(qS[0],(units*2)*4,0);
KarLowPairW(qA,0,qB,0,qC,0,qR,0,qS,0,alen,blen,clen,lim,qWork,0);
HPWAlloc(r,words); HPWAlloc(s,words);
for i0:=0 to words-1 do begin r.v^[i0]:=qR[i0]; s.v^[i0]:=qS[i0]; end;
r.v^[words-1]:=r.v^[words-1] and HPWMask(((lim-1) and 31)+1);
s.v^[words-1]:=s.v^[words-1] and HPWMask(((lim-1) and 31)+1);
HPWNorm(r); HPWNorm(s);
end;

procedure HPWMatApply(const a:THMatW; const x,y:THPolyW; out u,v:THPolyW);
var lim:longint;
var t0,t1,t2,t3:THPolyW;
begin
{ Euclidean prefix: deg(u) <= deg(x)-deg(a.p11), and deg(v)<deg(u). }
lim:=x.d+1; if a.p11.d>=0 then dec(lim,a.p11.d);
HPWMulPairTrunc(x,a.p00,a.p10,t0,t1,lim); HPWMulPairTrunc(y,a.p01,a.p11,t2,t3,lim);
HPWAdd(t0,t2,u); HPWAdd(t1,t3,v);
end;

procedure HPWMatMul(const a,b:THMatW; out c:THMatW);
var t0,t1,t2,t3,t4,t5,t6,t7:THPolyW;
begin
HPWMulPair(a.p00,b.p00,b.p01,t0,t1); HPWMulPair(a.p01,b.p10,b.p11,t2,t3);
HPWAdd(t0,t2,c.p00); HPWAdd(t1,t3,c.p01);
HPWMulPair(a.p10,b.p00,b.p01,t4,t5); HPWMulPair(a.p11,b.p10,b.p11,t6,t7);
HPWAdd(t4,t6,c.p10); HPWAdd(t5,t7,c.p11);
end;

procedure HPWMatRightStep(const a:THMatW; const q:THPolyW; out c:THMatW);
var u,v:THPolyW;
begin
HPWMulPair(q,a.p01,a.p11,u,v);
HPWCopy(a.p01,c.p00); HPWCopy(a.p11,c.p10);
HPWAdd(a.p00,u,c.p01); HPWAdd(a.p10,v,c.p11);
end;

{ Leaf elimination uses six fixed buffers, with no allocation per quotient. }
procedure HPWLeaf(const a,b:THPolyW; target:longint; out g:THPolyW; out outmat:THMatW);
type TL=array[0..hgcdCutW div 32+1] of LongWord; PL=^TL;
var ar,br,au,bu,av,bv:TL;
var r0,r1,u0,u1,v0,v1,t:PL;
var d0,d1,du0,du1,dv0,dv1,i,sh,tmp:longint;
procedure XST(var x,y,z:TL; const a,b,c:TL; sh,da,db,dc:longint); inline;
var j,lim,ws,bs,wa,wb,wc:longint;
var ca,cb,cc,na,nb,nc:LongWord;
begin
ws:=sh shr 5; bs:=sh and 31;
wa:=-1; wb:=-1; wc:=-1;
if da>=0 then wa:=da shr 5; if db>=0 then wb:=db shr 5; if dc>=0 then wc:=dc shr 5;
lim:=wa; if wb<lim then lim:=wb; if wc<lim then lim:=wc;
if bs=0 then
  begin
  for j:=0 to lim do
    begin x[ws+j]:=x[ws+j] xor a[j]; y[ws+j]:=y[ws+j] xor b[j]; z[ws+j]:=z[ws+j] xor c[j]; end;
  for j:=lim+1 to wa do x[ws+j]:=x[ws+j] xor a[j];
  for j:=lim+1 to wb do y[ws+j]:=y[ws+j] xor b[j];
  for j:=lim+1 to wc do z[ws+j]:=z[ws+j] xor c[j];
  end
else
  begin
  ca:=0; cb:=0; cc:=0;
  for j:=0 to lim do
    begin
    na:=a[j]; nb:=b[j]; nc:=c[j];
    x[ws+j]:=x[ws+j] xor (na shl bs) xor ca;
    y[ws+j]:=y[ws+j] xor (nb shl bs) xor cb;
    z[ws+j]:=z[ws+j] xor (nc shl bs) xor cc;
    ca:=na shr (32-bs); cb:=nb shr (32-bs); cc:=nc shr (32-bs);
    end;
  for j:=lim+1 to wa do
    begin na:=a[j]; x[ws+j]:=x[ws+j] xor (na shl bs) xor ca; ca:=na shr (32-bs); end;
  for j:=lim+1 to wb do
    begin nb:=b[j]; y[ws+j]:=y[ws+j] xor (nb shl bs) xor cb; cb:=nb shr (32-bs); end;
  for j:=lim+1 to wc do
    begin nc:=c[j]; z[ws+j]:=z[ws+j] xor (nc shl bs) xor cc; cc:=nc shr (32-bs); end;
  if wa>=0 then x[ws+wa+1]:=x[ws+wa+1] xor ca;
  if wb>=0 then y[ws+wb+1]:=y[ws+wb+1] xor cb;
  if wc>=0 then z[ws+wc+1]:=z[ws+wc+1] xor cc;
  end;
end;
{ H70: the same adjacent quotient terms, packed into LongWord. }
{ H71: the same fused traversal and shared word-shift setup. }
procedure XST2(var x,y,z:TL; const a,b,c:TL; sh,da,db,dc:longint); inline;
var j,ws,bs,wa,wb,wc,lim:longint;
var va,vb,vc:QWord; ca,cb,cc:LongWord;
begin
ws:=sh shr 5; bs:=sh and 31;
wa:=-1; wb:=-1; wc:=-1;
if da>=0 then wa:=da shr 5; if db>=0 then wb:=db shr 5; if dc>=0 then wc:=dc shr 5;
lim:=wa; if wb<lim then lim:=wb; if wc<lim then lim:=wc;
ca:=0; cb:=0; cc:=0;
for j:=0 to lim do
  begin
  va:=(QWord(a[j]) shl bs) xor (QWord(a[j]) shl (bs+1));
  vb:=(QWord(b[j]) shl bs) xor (QWord(b[j]) shl (bs+1));
  vc:=(QWord(c[j]) shl bs) xor (QWord(c[j]) shl (bs+1));
  x[ws+j]:=x[ws+j] xor LongWord(va) xor ca; ca:=LongWord(va shr 32);
  y[ws+j]:=y[ws+j] xor LongWord(vb) xor cb; cb:=LongWord(vb shr 32);
  z[ws+j]:=z[ws+j] xor LongWord(vc) xor cc; cc:=LongWord(vc shr 32);
  end;
for j:=lim+1 to wa do
  begin
  va:=(QWord(a[j]) shl bs) xor (QWord(a[j]) shl (bs+1));
  x[ws+j]:=x[ws+j] xor LongWord(va) xor ca; ca:=LongWord(va shr 32);
  end;
for j:=lim+1 to wb do
  begin
  vb:=(QWord(b[j]) shl bs) xor (QWord(b[j]) shl (bs+1));
  y[ws+j]:=y[ws+j] xor LongWord(vb) xor cb; cb:=LongWord(vb shr 32);
  end;
for j:=lim+1 to wc do
  begin
  vc:=(QWord(c[j]) shl bs) xor (QWord(c[j]) shl (bs+1));
  z[ws+j]:=z[ws+j] xor LongWord(vc) xor cc; cc:=LongWord(vc shr 32);
  end;
if wa>=0 then x[ws+wa+1]:=x[ws+wa+1] xor ca;
if wb>=0 then y[ws+wb+1]:=y[ws+wb+1] xor cb;
if wc>=0 then z[ws+wc+1]:=z[ws+wc+1] xor cc;
end;
{ H71: the same two terms, with the full cross-word carry. }
procedure XSG(var x:TL; const a:TL; sh,d:longint); inline;
var j,ws,bs,last:longint; q,v,carry:QWord;
begin
if d<0 then exit;
ws:=sh shr 5; bs:=sh and 31; last:=d shr 5; carry:=0;
{ At bs<31 the two shifted terms fit in a single QWord. }
if bs<31 then
  begin
  for j:=0 to last do
    begin
    v:=(QWord(a[j]) shl bs) xor (QWord(a[j]) shl (bs+2));
    x[ws+j]:=x[ws+j] xor LongWord(v) xor LongWord(carry);
    carry:=v shr 32;
    end;
  x[ws+last+1]:=x[ws+last+1] xor LongWord(carry);
  exit;
  end;
for j:=0 to last do
  begin
  q:=QWord(a[j]) xor (QWord(a[j]) shl 2);
  v:=(q shl bs) xor carry;
  x[ws+j]:=x[ws+j] xor LongWord(v);
  carry:=(q shr (32-bs)) xor (carry shr 32);
  end;
x[ws+last+1]:=x[ws+last+1] xor LongWord(carry);
if (carry shr 32)<>0 then x[ws+last+2]:=x[ws+last+2] xor LongWord(carry shr 32);
end;
procedure Degree(const x:TL; var d:longint); inline;
var j:longint;
begin
if d<0 then exit;
j:=d shr 5; while (j>=0) and (x[j]=0) do dec(j);
if j<0 then d:=-1 else d:=(j shl 5)+HighBit32(x[j]);
end;
procedure ExportPoly(const x:TL; lim:longint; out z:THPolyW);
var j:longint;
begin
HPWAlloc(z,(lim+32) shr 5); for j:=0 to (z.cap-1) do z.v^[j]:=x[j]; z.d:=lim; HPWNorm(z);
end;
begin
ar:=Default(TL); br:=Default(TL);
au:=Default(TL); bu:=Default(TL);
av:=Default(TL); bv:=Default(TL);
for i:=0 to (a.cap-1) do ar[i]:=a.v^[i];
for i:=0 to (b.cap-1) do br[i]:=b.v^[i];
au[0]:=1; bv[0]:=1;
r0:=@ar; r1:=@br; u0:=@au; u1:=@bu; v0:=@av; v1:=@bv;
d0:=a.d; d1:=b.d; du0:=0; du1:=-1; dv0:=-1; dv1:=0;
while (d1>=0) and (d1>=target) do
  begin
  while d0>=d1 do
    begin
    sh:=d0-d1;
    if (sh>0) and (d1>0) and ((((r0^[(d0-1) shr 5] shr ((d0-1) and 31)) xor (r1^[(d1-1) shr 5] shr ((d1-1) and 31))) and 1)<>0) then
      begin
      XST2(r0^,u0^,v0^,r1^,u1^,v1^,sh-1,d1,du1,dv1);
      dec(d0,2);
      end
    else if (sh>1) and (d1>1) and ((((r0^[(d0-2) shr 5] shr ((d0-2) and 31)) xor (r1^[(d1-2) shr 5] shr ((d1-2) and 31))) and 1)<>0) then
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

procedure HPWHalfGCDClassic(const a,b:THPolyW; out m0:THMatW);
var g:THPolyW;
begin HPWLeaf(a,b,(a.d+1) div 2,g,m0); end;

{ Reduce the second remainder below half the first degree. }
procedure HPWHalfGCD(const a,b:THPolyW; out m0:THMatW); forward;
procedure HPWHalfGCDCore(const a,b:THPolyW; out m0:THMatW);
var m,mm:longint; aa,bb,c,d,q,e,aa2,bb2:THPolyW; rmat,smat,umat:THMatW;
begin
if (b.d<0) or (b.d<(a.d+1) div 2) then begin HPWMatIdentity(m0); exit; end;
if a.d<=hgcdCutW then begin HPWHalfGCDClassic(a,b,m0); exit; end;
m:=(a.d+1) div 2; HPWShiftDown(a,m,aa); HPWShiftDown(b,m,bb); HPWHalfGCD(aa,bb,rmat);
HPWMatApply(rmat,a,b,c,d);
if (d.d<0) or (d.d<m) then begin m0:=rmat; exit; end;
HPWDivRem(c,d,q,e); mm:=2*m-d.d;
HPWShiftDown(d,mm,aa2); HPWShiftDown(e,mm,bb2); HPWHalfGCD(aa2,bb2,smat);
HPWMatRightStep(smat,q,umat); HPWMatMul(umat,rmat,m0);
end;

procedure HPWHalfGCD(const a,b:THPolyW; out m0:THMatW);
var saved,span:longint; temp:THMatW;
begin
span:=((((a.d+1) div 2)+33) shr 5);
HPWAlloc(m0.p00,span); HPWAlloc(m0.p01,span);
HPWAlloc(m0.p10,span); HPWAlloc(m0.p11,span);
saved:=qTop;
HPWHalfGCDCore(a,b,temp);
HPWMoveInto(temp.p00,m0.p00); HPWMoveInto(temp.p01,m0.p01);
HPWMoveInto(temp.p10,m0.p10); HPWMoveInto(temp.p11,m0.p11);
qTop:=saved;
end;

procedure HPWXGCDLeaf(const a,b:THPolyW; out g,u,v:THPolyW);
var h:THMatW;
begin
HPWLeaf(a,b,0,g,h); u:=h.p00; v:=h.p01;
end;

procedure HPWXGCD(const a,b:THPolyW; out g,u,v:THPolyW); forward;
procedure HPWXGCDCore(const a,b:THPolyW; out g,u,v:THPolyW);
var c,d,q,r,s,t,w,t0,t1,t2,t3:THPolyW; h:THMatW;
begin
if a.d<b.d then begin HPWXGCD(b,a,g,v,u); exit; end;
if b.d<0 then begin HPWCopy(a,g); HPWOne(u); HPWZero(v); exit; end;
if a.d<=hgcdCutW then begin HPWXGCDLeaf(a,b,g,u,v); exit; end;
HPWHalfGCD(a,b,h); HPWMatApply(h,a,b,c,d);
if d.d<0 then begin HPWCopy(c,g); HPWCopy(h.p00,u); HPWCopy(h.p01,v); exit; end;
HPWDivRem(c,d,q,r);
if r.d<0 then begin HPWCopy(d,g); HPWCopy(h.p10,u); HPWCopy(h.p11,v); exit; end;
HPWXGCD(d,r,g,s,t); HPWMul(q,t,t0); HPWAdd(s,t0,w);
HPWMulPair(t,h.p00,h.p01,t0,t1);
HPWMulPair(w,h.p10,h.p11,t2,t3);
HPWAdd(t0,t2,u); HPWAdd(t1,t3,v);
end;

procedure HPWXGCD(const a,b:THPolyW; out g,u,v:THPolyW);
var saved,span:longint; gg,uu,vv:THPolyW;
begin
if a.d<b.d then begin HPWXGCD(b,a,g,v,u); exit; end;
span:=((a.d+33) shr 5);
HPWAlloc(g,span); HPWAlloc(u,span); HPWAlloc(v,span); saved:=qTop;
HPWXGCDCore(a,b,gg,uu,vv);
HPWMoveInto(gg,g); HPWMoveInto(uu,u); HPWMoveInto(vv,v);
qTop:=saved;
end;

function GcdU(const va,vb:TVec; var vg,vu,vv:TVec; hi:longint):longint;
var a,b,g,u,v:THPolyW; size:longint;
begin
size:=(hi*2+96) shr 5;
SetLength(qPool,size*128); qTop:=0; qPeak:=0;
SetLength(qA,size); SetLength(qB,size); SetLength(qC,size);
SetLength(qR,size*2); SetLength(qS,size*2); SetLength(qWork,size*10);
HPWFromVec(va,hi,a); HPWFromVec(vb,hi,b); HPWXGCD(a,b,g,u,v);
HPWToVec(g,vg,hi); HPWToVec(u,vu,hi); HPWToVec(v,vv,hi); GcdU:=g.d;
end;

function LowMask32(bits:longint):LongWord;
begin
if bits<=0 then LowMask32:=0
else if bits>=32 then LowMask32:=$FFFFFFFF
else LowMask32:=(LongWord(1) shl bits)-1;
end;

function Reverse32(x:LongWord):LongWord; inline;
begin
x:=((x and $55555555) shl 1) or ((x shr 1) and $55555555);
x:=((x and $33333333) shl 2) or ((x shr 2) and $33333333);
x:=((x and $0F0F0F0F) shl 4) or ((x shr 4) and $0F0F0F0F);
x:=((x and $00FF00FF) shl 8) or ((x shr 8) and $00FF00FF);
Reverse32:=(x shl 16) or (x shr 16);
end;

procedure ClearDynBits(var a:TWordArray; bit0,len:longint);
var w0,w1,b0,b1,k0:longint;
var mask0:LongWord;
begin
if len<=0 then exit;
w0:=bit0 shr 5; b0:=bit0 and 31;
w1:=(bit0+len-1) shr 5; b1:=(bit0+len-1) and 31;
if w0=w1 then
  begin
  mask0:=LowMask32(len) shl b0;
  a[w0]:=a[w0] and not mask0;
  exit;
  end;
a[w0]:=a[w0] and LowMask32(b0);
for k0:=w0+1 to w1-1 do a[k0]:=0;
a[w1]:=a[w1] and not LowMask32(b1+1);
end;

function ReadDyn32(const a:TWordArray; bit0:longint):LongWord; inline;
var w0,b0:longint;
var r0:LongWord;
begin
w0:=bit0 shr 5; b0:=bit0 and 31;
if (w0<0) or (w0>High(a)) then begin ReadDyn32:=0; exit; end;
r0:=a[w0] shr b0;
if (b0<>0) and (w0<High(a)) then r0:=r0 xor (a[w0+1] shl (32-b0));
ReadDyn32:=r0;
end;

function ReadDyn32Any(const a:TWordArray; bit0:longint):LongWord;
begin
if bit0>=0 then ReadDyn32Any:=ReadDyn32(a,bit0)
else if bit0<=-32 then ReadDyn32Any:=0
else ReadDyn32Any:=a[0] shl (-bit0);
end;

function ReadDyn32Reverse(const a:TWordArray; endBit:longint):LongWord; inline;
begin
ReadDyn32Reverse:=Reverse32(ReadDyn32Any(a,endBit-31));
end;

procedure XorDyn32(var a:TWordArray; bit0:longint; v0:LongWord); inline;
var w0,b0:longint;
begin
if v0=0 then exit;
w0:=bit0 shr 5; b0:=bit0 and 31;
if (w0<0) or (w0>High(a)) then exit;
a[w0]:=a[w0] xor (v0 shl b0);
if (b0<>0) and (w0<High(a)) then a[w0+1]:=a[w0+1] xor (v0 shr (32-b0));
end;

procedure XorDynBits4(var dst:TWordArray; dstBit:longint;
                      const src:TWordArray; srcBit,len,h:longint);
var take:longint;
var q0:LongWord;
begin
while len>0 do
  begin
  if len>32 then take:=32 else take:=len;
  q0:=ReadDyn32(src,srcBit) and LowMask32(take);
  XorDyn32(dst,dstBit,q0);
  XorDyn32(dst,dstBit+h,q0);
  XorDyn32(dst,dstBit+h*3,q0);
  XorDyn32(dst,dstBit+(h shl 2),q0);
  inc(srcBit,take); inc(dstBit,take); dec(len,take);
  end;
end;

procedure XorDynBits4Q(var dst:TWordArray; dstBit:longint;
                       const src:TWordArray; srcBit,len,h:longint);
var sw,d0,d1,d3,d4,k0,full,tail:longint;
var q0,mask0:QWord;
begin
sw:=srcBit shr 5;
d0:=dstBit shr 5;
d1:=(dstBit+h) shr 5;
d3:=(dstBit+h*3) shr 5;
d4:=(dstBit+(h shl 2)) shr 5;
full:=len shr 6;
for k0:=0 to full-1 do
  begin
  q0:=PWide(@src[sw])^;
  PWide(@dst[d0])^:=PWide(@dst[d0])^ xor q0;
  PWide(@dst[d1])^:=PWide(@dst[d1])^ xor q0;
  PWide(@dst[d3])^:=PWide(@dst[d3])^ xor q0;
  PWide(@dst[d4])^:=PWide(@dst[d4])^ xor q0;
  inc(sw,2); inc(d0,2); inc(d1,2); inc(d3,2); inc(d4,2);
  end;
tail:=len and 63;
if tail<>0 then
  begin
  q0:=PWide(@src[sw])^;
  mask0:=(QWord(1) shl tail)-1;
  q0:=q0 and mask0;
  PWide(@dst[d0])^:=PWide(@dst[d0])^ xor q0;
  PWide(@dst[d1])^:=PWide(@dst[d1])^ xor q0;
  PWide(@dst[d3])^:=PWide(@dst[d3])^ xor q0;
  PWide(@dst[d4])^:=PWide(@dst[d4])^ xor q0;
  end;
end;

function CoeffByte(const coeff:TVec; first,degmax:longint):LongWord; inline;
var keep:longint;
begin
if first>degmax then begin CoeffByte:=0; exit; end;
keep:=degmax-first+1;
if keep>8 then keep:=8;
CoeffByte:=((coeff[first shr 5] shr (first and 31)) and $FF) and ((LongWord(1) shl keep)-1);
end;

function UKernel16(a0:LongWord):QWord;
var q0:QWord;
begin
q0:=uKernel8[(a0 shr 8) and $FF];
UKernel16:=(QWord(uKernel8[a0 and $FF]) shl 16) xor
           q0 xor (q0 shl 8) xor (q0 shl 24) xor (q0 shl 32);
end;

function CoeffWord32(const coeff:TVec; first,degmax:longint):LongWord; inline;
var keep:longint;
begin
if first>degmax then begin CoeffWord32:=0; exit; end;
keep:=degmax-first+1;
if keep>32 then keep:=32;
CoeffWord32:=coeff[first shr 5] and LowMask32(keep);
end;

procedure UKernel32(a0:LongWord; var lo,hi:QWord);
var q0,q1:QWord;
begin
q0:=UKernel16(a0 and $FFFF);
q1:=UKernel16(a0 shr 16);
lo:=(q0 shl 32) xor q1 xor (q1 shl 16) xor (q1 shl 48);
hi:=(q0 shr 32) xor (q1 shr 48) xor (q1 shr 16) xor q1;
end;

procedure UKernel64(a0,a1:LongWord; var q:TQ4); inline;
var p0,p1,p2,p3:QWord;
begin
UKernel32(a0,p0,p1);
UKernel32(a1,p2,p3);
q[0]:=p2 xor (p2 shl 32);
q[1]:=p0 xor p3 xor (p2 shr 32) xor (p3 shl 32) xor (p2 shl 32);
q[2]:=p1 xor (p3 shr 32) xor (p2 shr 32) xor (p3 shl 32) xor p2;
q[3]:=(p3 shr 32) xor p3;
end;

procedure UKernel128(a0,a1,a2,a3:LongWord; var q:TQ8);
var p0,p1:TQ4;
var k0:longint;
begin
UKernel64(a0,a1,p0);
UKernel64(a2,a3,p1);
for k0:=0 to 7 do q[k0]:=0;
for k0:=0 to 3 do
  begin
  q[k0]:=q[k0] xor p1[k0];
  q[k0+1]:=q[k0+1] xor p1[k0];
  q[k0+2]:=q[k0+2] xor p0[k0];
  q[k0+3]:=q[k0+3] xor p1[k0];
  q[k0+4]:=q[k0+4] xor p1[k0];
  end;
end;

procedure UKernel256(const coeff:TVec; first,degmax:longint; var q:TQ16);
var p0,p1:TQ8;
var k0:longint;
begin
UKernel128(CoeffWord32(coeff,first,degmax),
           CoeffWord32(coeff,first+32,degmax),
           CoeffWord32(coeff,first+64,degmax),
           CoeffWord32(coeff,first+96,degmax),p0);
UKernel128(CoeffWord32(coeff,first+128,degmax),
           CoeffWord32(coeff,first+160,degmax),
           CoeffWord32(coeff,first+192,degmax),
           CoeffWord32(coeff,first+224,degmax),p1);
for k0:=0 to 15 do q[k0]:=0;
for k0:=0 to 7 do
  begin
  q[k0]:=q[k0] xor p1[k0];
  q[k0+2]:=q[k0+2] xor p1[k0];
  q[k0+4]:=q[k0+4] xor p0[k0];
  q[k0+6]:=q[k0+6] xor p1[k0];
  q[k0+8]:=q[k0+8] xor p1[k0];
  end;
end;

procedure UKernel512(const coeff:TVec; first,degmax:longint; var q:TQ32);
var p0,p1:TQ16;
var k0:longint;
begin
UKernel256(coeff,first,degmax,p0);
UKernel256(coeff,first+256,degmax,p1);
for k0:=0 to 31 do q[k0]:=0;
for k0:=0 to 15 do
  begin
  q[k0]:=q[k0] xor p1[k0];
  q[k0+4]:=q[k0+4] xor p1[k0];
  q[k0+8]:=q[k0+8] xor p0[k0];
  q[k0+12]:=q[k0+12] xor p1[k0];
  q[k0+16]:=q[k0+16] xor p1[k0];
  end;
end;

{ Only words touching the nonnegative Laurent half are needed. }
procedure UKernel1024Upper(const coeff:TVec; first,degmax:longint; var q:TQ64); inline;
var p0,p1:TQ32;
var k0:longint;
begin
UKernel512(coeff,first,degmax,p0);
UKernel512(coeff,first+512,degmax,p1);
q[31]:=p1[31] xor p1[23] xor p0[15] xor p1[7];
for k0:=32 to 39 do q[k0]:=p0[k0-16] xor p1[k0-8] xor p1[k0-24] xor p1[k0-32];
for k0:=40 to 47 do q[k0]:=p0[k0-16] xor p1[k0-24] xor p1[k0-32];
for k0:=48 to 55 do q[k0]:=p1[k0-24] xor p1[k0-32];
for k0:=56 to 63 do q[k0]:=p1[k0-32];
end;

procedure BuildUKernelRec(const coeff:TVec; first,count,degmax:longint;
                          var dst:TWordArray; dstBit:longint;
                          var work:TWordArray; workWord:longint);
var h,childBits,childWords,workBit:longint;
begin
ClearDynBits(dst,dstBit,(count shl 2)-3);
if count=8 then
  begin
  XorDyn32(dst,dstBit,uKernel8[CoeffByte(coeff,first,degmax)]);
  exit;
  end;
h:=count shr 1;
childBits:=(h shl 2)-3;
childWords:=(childBits+31) shr 5;
BuildUKernelRec(coeff,first,h,degmax,dst,dstBit+(h shl 1),work,workWord);
workBit:=workWord shl 5;
BuildUKernelRec(coeff,first+h,h,degmax,work,workBit,work,workWord+childWords);
XorDynBits4(dst,dstBit,work,workBit,childBits,h);
end;

procedure BuildUKernelFastW(const coeff:TVec; degmax:longint;
                            var r:TWordArray; var center:longint);
var count,bits,k0:longint;
var work:TWordArray;
begin
count:=8;
while count<=degmax do count:=count shl 1;
bits:=(count shl 2)-3;
SetLength(r,(bits+31) shr 5);
for k0:=0 to High(r) do r[k0]:=0;
SetLength(work,count div 8+64);
for k0:=0 to High(work) do work[k0]:=0;
BuildUKernelRec(coeff,0,count,degmax,r,0,work,0);
center:=(count shl 1)-2;
end;

{ H69: the same nonnegative-offset recursion, packed into LongWord. }
procedure BuildUComboRecW(const va,vb:TVec; first,count,degmax,mode:longint;
                          var dst:TWordArray; dstBit:longint;
                          var work:TWordArray; workWord:longint);
var h,g,childBits,childWords,workBit,p:longint;
var aa,bb:TQ8;
var sa1:QWord;
var w0,k0:longint; value:LongWord;
begin
if count=128 then
  begin
  UKernel128(CoeffWord32(va,first+0,degmax),CoeffWord32(va,first+32,degmax),CoeffWord32(va,first+64,degmax),CoeffWord32(va,first+96,degmax),aa);
  UKernel128(CoeffWord32(vb,first+0,degmax),CoeffWord32(vb,first+32,degmax),CoeffWord32(vb,first+64,degmax),CoeffWord32(vb,first+96,degmax),bb);
  w0:=dstBit shr 5;
  for k0:=0 to 3 do
    begin
    if mode=0 then
      sa1:=(aa[3+k0] shr 61) xor (aa[4+k0] shl 3) xor (bb[3+k0] shr 62) xor (bb[4+k0] shl 2) xor (aa[3+k0] shr 63) xor (aa[4+k0] shl 1)
    else
      sa1:=(bb[3+k0] shr 61) xor (bb[4+k0] shl 3) xor (aa[3+k0] shr 62) xor (aa[4+k0] shl 2) xor (bb[3+k0] shr 62) xor (bb[4+k0] shl 2) xor (bb[3+k0] shr 63) xor (bb[4+k0] shl 1);
    dst[w0+k0*2]:=LongWord(sa1); dst[w0+k0*2+1]:=LongWord(sa1 shr 32);
    end;
  exit;
  end;
ClearDynBits(dst,dstBit,count shl 1);
h:=128;
while (h shl 1)<count do h:=h shl 1;
g:=count-h; childBits:=g shl 1; childWords:=childBits shr 5;
BuildUComboRecW(va,vb,first,h,degmax,mode,dst,dstBit,work,workWord);
workBit:=workWord shl 5;
BuildUComboRecW(va,vb,first+h,g,degmax,mode,work,workBit,work,workWord+childWords);
for k0:=0 to childWords-1 do
  begin
  value:=work[workWord+k0]; p:=(dstBit shr 5)+k0;
  dst[p+(h shr 5)]:=dst[p+(h shr 5)] xor value;
  dst[p+(h shr 4)]:=dst[p+(h shr 4)] xor value;
  { Exclude the shared centers; the two zero-offset terms cancel. }
  value:=Reverse32(value);
  if k0=0 then value:=value and $7FFFFFFF;
  w0:=(dstBit shr 5)+(h shr 4)-k0-1;
  dst[w0]:=dst[w0] xor (value shl 1);
  dst[w0+1]:=dst[w0+1] xor (value shr 31);
  if k0<(h shr 5) then
    begin
    dec(w0,h shr 5);
    dst[w0]:=dst[w0] xor (value shl 1);
    dst[w0+1]:=dst[w0+1] xor (value shr 31);
    end
  else
    begin
    value:=work[workWord+k0];
    if k0=(h shr 5) then value:=value and $FFFFFFFE;
    w0:=(dstBit shr 5)+k0-(h shr 5);
    dst[w0]:=dst[w0] xor value;
    end;
  end;
end;

procedure BuildUComboHalfKernelW(const va,vb:TVec; degmax,mode:longint;
                                 var r:TWordArray);
var count:longint;
var work:TWordArray;
begin
count:=((degmax+128) div 128)*128;
if count<128 then count:=128;
SetLength(r,count shr 4); SetLength(work,count div 16+64);
BuildUComboRecW(va,vb,0,count,degmax,mode,r,0,work,0);
end;

procedure AddHalfCircularKernelW(var dst:TWordArray; const src:TWordArray; period,limit:longint);
var base,p,last,first,take,top:longint;
var value:LongWord;
begin
top:=(Length(src) shl 5)-1; base:=0;
while base<=top do
  begin
  last:=top-base; if last>limit then last:=limit;
  p:=0;
  while p<=last do
    begin
    take:=last-p+1; if take>32 then take:=32;
    value:=ReadDyn32(src,base+p) and LowMask32(take);
    XorDyn32(dst,p,value); inc(p,take);
    end;
  inc(base,period);
  end;
base:=period;
while base<=top+limit do
  begin
  first:=base-top; if first<0 then first:=0;
  p:=first;
  while p<=limit do
    begin
    take:=limit-p+1; if take>32 then take:=32;
    value:=ReadDyn32Reverse(src,base-p) and LowMask32(take);
    XorDyn32(dst,p,value); inc(p,take);
    end;
  inc(base,period);
  end;
end;

procedure AddCircularKernelW(var dst:TWordArray; const src:TWordArray; center,shift,period,limit:longint);
var src0,p0,p1,take:longint;
var q0:LongWord;
begin
src0:=center-shift;
while src0>0 do dec(src0,period);
while src0+period<=0 do inc(src0,period);
while src0<=(High(src) shl 5)+31 do
  begin
  p0:=0; if src0<0 then p0:=-src0;
  p1:=limit;
  if src0+p1>(High(src) shl 5)+31 then p1:=(High(src) shl 5)+31-src0;
  while p0<=p1 do
    begin
    take:=p1-p0+1; if take>32 then take:=32;
    q0:=ReadDyn32(src,src0+p0) and LowMask32(take);
    XorDyn32(dst,p0,q0);
    inc(p0,take);
    end;
  inc(src0,period);
  end;
end;

function DynBit(const a:TWordArray; p0:longint):LongWord; inline;
begin
DynBit:=(a[p0 shr 5] shr (p0 and 31)) and 1;
end;

{ For an all-one source the four prefix windows cancel to two kernel bits. }
procedure ApplyUComboOnesW(const va,vb:TVec; var vdst:TVec; hi,degmax:longint);
var halfLen,period,convWords,lastWord,keep,p,w0:longint;
var combo,ha:TWordArray;
var bit0,q0:LongWord;
begin
halfLen:=hi+2;
period:=halfLen shl 1;
convWords:=(halfLen+32) shr 5;
BuildUComboHalfKernelW(va,vb,degmax,1,combo);
SetLength(ha,convWords);
AddHalfCircularKernelW(ha,combo,period,halfLen);
lastWord:=halfLen shr 5;
keep:=(halfLen and 31)+1;
if keep<32 then ha[lastWord]:=ha[lastWord] and LowMask32(keep);
lastWord:=hi shr 5;
bit0:=DynBit(ha,0) xor DynBit(ha,halfLen);
for w0:=0 to lastWord do
  begin
  p:=w0 shl 5;
  q0:=ReadDyn32(ha,p+1) xor ReadDyn32Reverse(ha,halfLen-p-1);
  if bit0<>0 then q0:=not q0;
  vdst[w0]:=q0;
  end;
MaskDeg(vdst,hi);
end;

{ D=A*B, E=A*reverse(B); all additions below are in GF(2). }
{ C[p]=D[p]+D[2L-p]+E[L-p]+E[L+p]+A[0]B[p]+A[L]B[L-p]. }
{ H71: the same single-product construction, packed into LongWord. }
{ H71: the same basis conversion, with 32 coefficients per word. }
function ConvertH32(v:LongWord; inverse:boolean):LongWord;
var r:LongWord;
begin
if inverse then
  begin
  v:=v xor ((Reverse32(v) shl 1) and $0000FFFE);
  r:=Reverse32(v); r:=(r shl 16) or (r shr 16);
  v:=v xor ((r shl 1) and $00FE00FE);
  v:=v xor ((v shr 6) and $02020202) xor ((v shr 4) and $04040404) xor ((v shr 2) and $08080808);
  v:=v xor ((v shr 2) and $22222222);
  end
else
  begin
  v:=v xor ((v shr 2) and $22222222);
  v:=v xor ((v shr 6) and $02020202) xor ((v shr 4) and $04040404) xor ((v shr 2) and $08080808);
  r:=Reverse32(v); r:=(r shl 16) or (r shr 16);
  v:=v xor ((r shl 1) and $00FE00FE);
  v:=v xor ((Reverse32(v) shl 1) and $0000FFFE);
  end;
ConvertH32:=v;
end;

procedure ConvertHW(var a:TWordArray; first,count:longint; inverse:boolean);
var h,g,j,w,base:longint; v:LongWord;
begin
if count=32 then
  begin a[first shr 5]:=ConvertH32(a[first shr 5],inverse); exit; end;
h:=32; while (h shl 1)<count do h:=h shl 1;
g:=count-h;
if not inverse then
  begin
  ConvertHW(a,first,h,false); ConvertHW(a,first+h,g,false);
  end;
base:=(first+h) shr 5;
for j:=0 to (g shr 5)-1 do
  begin
  v:=Reverse32(a[base+j]); if j=0 then v:=v and $7FFFFFFF;
  w:=base-j-1;
  a[w]:=a[w] xor (v shl 1); a[w+1]:=a[w+1] xor (v shr 31);
  end;
if inverse then
  begin
  ConvertHW(a,first,h,true); ConvertHW(a,first+h,g,true);
  end;
end;

procedure ApplySymmetricHalfW(const ha,hb:TWordArray; var dst:TVec; L:longint);
var a,b,pa,pb,p0,halfResult:TWordArray;
var s,m,words,w,start,last,keep:longint; value,constantBit,centerBit:LongWord;
begin
s:=(L-1) div 2; m:=L div 2; words:=(s+32) shr 5;
SetLength(a,words); SetLength(b,words); SetLength(pa,words); SetLength(pb,words); SetLength(halfResult,words);
for w:=0 to words-1 do
  begin
  start:=w shl 5;
  a[w]:=ReadDyn32(ha,start) xor ReadDyn32Reverse(ha,L-start);
  b[w]:=ReadDyn32(hb,start);
  end;
a[0]:=a[0] and $FFFFFFFE;
keep:=(s and 31)+1;
a[words-1]:=a[words-1] and LowMask32(keep);
b[words-1]:=b[words-1] and LowMask32(keep);
for w:=0 to words-1 do begin pa[w]:=a[w]; pb[w]:=b[w]; end;
ConvertHW(pa,0,words shl 5,true); ConvertHW(pb,0,words shl 5,true);
KarMulFastW(pa,pb,p0,words,s+1,s+1);
ConvertHW(p0,0,words shl 6,false);
constantBit:=DynBit(ha,0) xor DynBit(ha,L); centerBit:=DynBit(hb,m);
for w:=0 to words-1 do
  begin
  start:=w shl 5;
  value:=ReadDyn32(p0,start) xor ReadDyn32Reverse(p0,L-start);
  if constantBit<>0 then value:=value xor b[w];
  if ((L and 1)=0) and (centerBit<>0) then value:=value xor ReadDyn32Reverse(a,m-start);
  halfResult[w]:=value;
  end;
halfResult[0]:=halfResult[0] and $FFFFFFFE;
halfResult[words-1]:=halfResult[words-1] and LowMask32(keep);
VecZero(dst); last:=(L-2) shr 5;
for w:=0 to last do
  begin
  start:=(w shl 5)+1;
  dst[w]:=ReadDyn32(halfResult,start) xor ReadDyn32Reverse(halfResult,L-start);
  end;
if ((L and 1)=0) and ((constantBit and centerBit)<>0) then
  dst[(m-1) shr 5]:=dst[(m-1) shr 5] xor (LongWord(1) shl ((m-1) and 31));
MaskDeg(dst,L-2);
end;

{ H75: S(2k)=J*S(k)^2+F(k-1)^2; S(2k+1)=J*S(k)^2+F(k)^2. }
procedure BuildFibonacciHalfKernelW(degree:longint; var r:TWordArray; words:longint; summed:boolean=false);
var a,b,fa,fb,tmp,ss,fs:TWordArray;
var mask,cur,next,p,dst:longint;
var odd:boolean; av,bv,an,bn,sn,value:LongWord; az,bz,sz:QWord;
begin
SetLength(a,words); SetLength(b,words); SetLength(fa,words); SetLength(fb,words);
if summed then begin SetLength(ss,words); SetLength(fs,words); end;
a[0]:=1; cur:=0; mask:=1;
while mask<=degree div 2 do mask:=mask shl 1;
while mask>0 do
  begin
  odd:=(degree and mask)<>0; next:=cur*2+ord(odd);
  if summed then
    begin
    FillChar(fs[0],((next+32) shr 5)*4,0);
    for p:=0 to cur shr 5 do
      begin
      sn:=0; if p+1<words then sn:=ss[p+1];
      sz:=SpreadBits32(ss[p]);
      if odd then value:=a[p] else value:=b[p];
      sz:=sz xor (sz shl 1) xor (sz shr 1) xor (QWord(sn and 1) shl 63) xor SpreadBits32(value);
      dst:=p*2; fs[dst]:=LongWord(sz);
      if dst+1<words then fs[dst+1]:=LongWord(sz shr 32);
      end;
    tmp:=ss; ss:=fs; fs:=tmp;
    if mask=1 then begin r:=ss; exit; end;
    end;
  FillChar(fa[0],((next+32) shr 5)*4,0); FillChar(fb[0],((next+32) shr 5)*4,0);
  for p:=0 to cur shr 5 do
    begin
    av:=a[p]; bv:=b[p];
    az:=SpreadBits32(av); bz:=SpreadBits32(bv);
    if odd then
      begin
      an:=0; if p+1<words then an:=a[p+1];
      bz:=az xor bz;
      az:=az xor (az shl 1) xor (az shr 1) xor (QWord(an and 1) shl 63);
      end
    else
      begin
      bn:=0; if p+1<words then bn:=b[p+1];
      az:=az xor bz;
      bz:=bz xor (bz shl 1) xor (bz shr 1) xor (QWord(bn and 1) shl 63);
      end;
    dst:=p*2;
    fa[dst]:=LongWord(az); fb[dst]:=LongWord(bz);
    if dst+1<words then begin fa[dst+1]:=LongWord(az shr 32); fb[dst+1]:=LongWord(bz shr 32); end;
    end;
  tmp:=a; a:=fa; fa:=tmp; tmp:=b; b:=fb; fb:=tmp; cur:=next; mask:=mask shr 1;
  end;
r:=a;
end;

procedure ApplyFibonacciOnesW(var dst:TVec; degree:longint);
var kernel:TWordArray;
var p,words,start:longint; bit0,value:LongWord;
begin
words:=(degree+33) shr 5;
BuildFibonacciHalfKernelW(degree,kernel,words,true);
bit0:=0; if (kernel[0] and 1)<>0 then bit0:=$FFFFFFFF;
VecZero(dst);
for p:=0 to (degree-1) shr 5 do
  begin
  start:=p shl 5;
  value:=ReadDyn32(kernel,start+1) xor ReadDyn32Reverse(kernel,degree-start) xor bit0;
  dst[p]:=value;
  end;
MaskDeg(dst,degree-1);
end;

{ H74: mode 2 uses F_(hi+1)(H+I); modes 0/1 use the supplied coefficients. }
procedure ApplyFastUComboW(const va,vb,vsrc:TVec; var vdst:TVec; hi,degmax,mode:longint);
var halfLen,period,convWords,lastWord:longint;
var w0,keep,srcBits,lastSrcWord,targetBit,startP:longint;
var q0,bit0:LongWord;
var combo,ha,hb,hbr,prod0:TWordArray;
var sameSource:boolean;
begin
halfLen:=hi+2;
period:=halfLen shl 1;
convWords:=(halfLen+32) shr 5;
SetLength(ha,convWords); SetLength(hb,convWords);
if mode=2 then BuildFibonacciHalfKernelW(hi+1,ha,convWords)
else
  begin
  BuildUComboHalfKernelW(va,vb,degmax,mode,combo);
  AddHalfCircularKernelW(ha,combo,period,halfLen);
  end;
if mode<>0 then SetLength(hbr,convWords);
lastWord:=halfLen shr 5;
keep:=(halfLen and 31)+1;
if keep<32 then ha[lastWord]:=ha[lastWord] and LowMask32(keep);
srcBits:=hi+1;
lastSrcWord:=hi shr 5;
for w0:=0 to lastSrcWord do
  begin
  q0:=vsrc[w0];
  if w0=lastSrcWord then q0:=q0 and LowMask32(srcBits-(w0 shl 5));
  hb[w0]:=hb[w0] xor (q0 shl 1);
  if w0+1<convWords then hb[w0+1]:=hb[w0+1] xor (q0 shr 31);
  if mode<>0 then
    begin
    bit0:=Reverse32(q0);
    targetBit:=srcBits-(w0 shl 5)-31;
    if targetBit>=0 then XorDyn32(hbr,targetBit,bit0)
    else if targetBit>-32 then hbr[0]:=hbr[0] xor (bit0 shr (-targetBit));
    end;
  end;
{ Reuse the identical reflected-source product; compare data, not n. }
sameSource:=true;
if mode<>0 then
  for w0:=0 to convWords-1 do
    if hb[w0]<>hbr[w0] then begin sameSource:=false; break; end;
if sameSource then
  begin
  ApplySymmetricHalfW(ha,hb,vdst,halfLen);
  exit;
  end;
{ H72: the same full-product conversion, 32 coefficients per word. }
bit0:=DynBit(ha,halfLen);
ha[halfLen shr 5]:=ha[halfLen shr 5] and not (LongWord(1) shl (halfLen and 31));
ConvertHW(ha,0,convWords shl 5,true); ConvertHW(hb,0,convWords shl 5,true);
KarMulFastW(ha,hb,prod0,convWords,halfLen,halfLen);
ConvertHW(prod0,0,convWords shl 6,false);
VecZero(vdst);
lastWord:=hi shr 5;
for w0:=0 to lastWord do
  begin
  startP:=(w0 shl 5)+1;
  q0:=ReadDyn32(prod0,startP) xor ReadDyn32Reverse(prod0,period-startP);
  if bit0<>0 then q0:=q0 xor ReadDyn32(hbr,startP);
  vdst[w0]:=q0;
  end;
MaskDeg(vdst,hi);
end;


procedure ApplyBezoutU(const vu,vv,vsrc:TVec; var vdst:TVec; hi,degmax:longint);
var cur0,cur1:TVec;
var pcur,pnxt,pt:PVec;
var d,du,dv,j2:longint;
var bu,bv:boolean;
begin
VecZero(cur0); VecZero(cur1); VecZero(vdst);
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
  bu:=GetBit(vu,j2)<>0;
  bv:=GetBit(vv,j2)<>0;
  if j2>=d then
    begin
    if bu and bv then VecXorIHTo(vdst,pcur^,hi)
    else if bv then VecXorRaw(vdst,pcur^)
    else if bu then VecXorHTo(vdst,pcur^,hi);
    break;
    end;
  if bu and bv then VecStepJXorTo(vdst,pnxt^,pcur^,hi,3)
  else if bv then VecStepJXorTo(vdst,pnxt^,pcur^,hi,1)
  else if bu then VecStepJXorTo(vdst,pnxt^,pcur^,hi,2)
  else VecStepJ(pnxt^,pcur^,hi);
  pt:=pcur; pcur:=pnxt; pnxt:=pt;
  end;
MaskDeg(vdst,hi);
end;

procedure ApplyCU(const va,vb,vsrc:TVec; var vdst:TVec; hi,degmax:longint);
var cur0,cur1:TVec;
var pcur,pnxt,pt:PVec;
var d,da,db,j2:longint;
var ba,bb:boolean;
begin
VecZero(cur0); VecZero(cur1); VecZero(vdst);
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
  ba:=GetBit(va,j2)<>0;
  bb:=GetBit(vb,j2)<>0;
  if j2>=d then
    begin
    if ba and bb then VecXorHTo(vdst,pcur^,hi)
    else if bb then VecXorIHTo(vdst,pcur^,hi)
    else if ba then VecXorRaw(vdst,pcur^);
    break;
    end;
  if ba and bb then VecStepJXorTo(vdst,pnxt^,pcur^,hi,2)
  else if bb then VecStepJXorTo(vdst,pnxt^,pcur^,hi,3)
  else if ba then VecStepJXorTo(vdst,pnxt^,pcur^,hi,1)
  else VecStepJ(pnxt^,pcur^,hi);
  pt:=pcur; pcur:=pnxt; pnxt:=pt;
  end;
MaskDeg(vdst,hi);
end;

{ Degree-bounded scratch operations for the q reduction chain. }
procedure QMaskU(var a:TVec; hi:longint);
var w:longint;
begin
w:=hi shr 5; a[w]:=a[w] and DegMask(hi);
a[-2]:=0; a[-1]:=0; if w+1<=mw then a[w+1]:=0;
end;

procedure QZeroU(var a:TVec; hi:longint); inline;
var p,last:longint;
begin
last:=(hi shr 5)+1; if last>mw then last:=mw;
for p:=-2 to last do a[p]:=0;
end;

procedure QCopyU(var dst:TVec; const src:TVec; hi:longint); inline;
var p:longint;
begin
for p:=0 to hi shr 5 do dst[p]:=src[p];
QMaskU(dst,hi);
end;

function BuildOddGUV(const ma,mb,mg,mu,mv:TVec; var gu,qu,qv:TVec; hi,srcHi:longint; extra:boolean):boolean;
var tu,tv:TVec;
var p,last,outlast:longint; smask:LongWord; a0,b0,g0:QWord;
begin
QZeroU(gu,hi); QZeroU(qu,hi+1); QZeroU(qv,hi);
QCopyU(tu,mu,srcHi); QCopyU(tv,mv,srcHi);
if (not extra) and (((tu[0] xor tv[0]) and 1)<>0) then
  begin
  for p:=0 to srcHi shr 5 do
    begin tu[p]:=tu[p] xor mb[p]; tv[p]:=tv[p] xor ma[p]; end;
  QMaskU(tu,srcHi); QMaskU(tv,srcHi);
  end;
BuildOddGUV:=false;
if (not extra) and (((tu[0] xor tv[0]) and 1)<>0) then exit;
last:=srcHi shr 5; smask:=DegMask(srcHi);
for p:=0 to last do
  begin
  a0:=SpreadBits32(tu[p]); b0:=SpreadBits32(tv[p]);
  if p=last then g0:=SpreadBits32(mg[p] and smask) else g0:=SpreadBits32(mg[p]);
  if extra then g0:=g0 shl 1;
  gu[2*p]:=LongWord(g0); gu[2*p+1]:=LongWord(g0 shr 32);
  b0:=b0 xor a0 xor (a0 shl 1);
  qu[2*p]:=LongWord(b0); qu[2*p+1]:=LongWord(b0 shr 32);
  if extra then a0:=a0 shl 1;
  qv[2*p]:=LongWord(a0); qv[2*p+1]:=LongWord(a0 shr 32);
  end;
if not extra then
  begin
  if (qu[0] and 1)<>0 then exit;
  QMaskU(qu,hi+1); outlast:=hi shr 5;
  for p:=0 to outlast do qu[p]:=(qu[p] shr 1) or (qu[p+1] shl 31);
  end;
QMaskU(gu,hi); QMaskU(qu,hi); QMaskU(qv,hi);
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
var a0,b0:QWord;
procedure Zero3(var a,b,c:TVec; hi:longint); inline;
begin QZeroU(a,hi);QZeroU(b,hi);QZeroU(c,hi); end;
procedure CopyP(var dst:TVec; const src:TVec; hi:longint); inline;
begin QCopyU(dst,src,hi); end;
begin
with qfcWork do
begin
cur:=nn;
while (cur and 1)<>0 do cur:=cur shr 1;
if cur=0 then
  begin
  BuildFCPairsIterW(0,bf,bc,bf1,bc1,af,ac,af1,ac1);
  Zero3(vg,vu,vv,0); vg[0]:=1; vu[0]:=1;
  end
else
  begin
  BuildFCPairsIterW(cur,bf,bc,bf1,bc1,af,ac,af1,ac1);
  h:=longint(cur div 4);
  VecZero(sa);VecZero(sb);
for p:=0 to h shr 5 do begin sa[p]:=af[p] xor af1[p]; sb[p]:=ac[p] xor ac1[p]; end;
MaskDeg(sa,h);MaskDeg(sb,h);
GcdU(sa,sb,tg,tu,tv,h);
Zero3(vg,vu,vv,longint(cur div 2));
for p:=0 to h shr 5 do
  begin
  a0:=SpreadBits32(tg[p]); vg[2*p]:=LongWord(a0); vg[2*p+1]:=LongWord(a0 shr 32);
  a0:=SpreadBits32(tu[p]); vu[2*p]:=LongWord(a0); vu[2*p+1]:=LongWord(a0 shr 32);
  b0:=SpreadBits32(tv[p]) xor (a0 shl 1);
  vv[2*p]:=LongWord(b0); vv[2*p+1]:=LongWord(b0 shr 32);
  end;
QMaskU(vg,longint(cur div 2));QMaskU(vu,longint(cur div 2));QMaskU(vv,longint(cur div 2));
  end;
while cur<nn do
  begin
  h:=longint(cur div 2); next:=cur*2+1;
  DoubleFCVecW(next,bf,bc,bf1,bc1,af,ac,af1,ac1,h);
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
{ H76: the same eight nibble products, represented by packed words. }
type TFixedMulTable=array[0..15] of QWord;
procedure PrepareFixedMul(a:LongWord; var table:TFixedMulTable);
var bit,k,offset:longint; basis:QWord;
begin
table[0]:=0;
for bit:=0 to 3 do
  begin
  basis:=QWord(a) shl bit; offset:=1 shl bit;
  for k:=0 to offset-1 do table[offset+k]:=table[k] xor basis;
  end;
end;
function FixedMul32(const table:TFixedMulTable; a:LongWord):QWord; inline;
begin
FixedMul32:=table[a and $F] xor
            (table[(a shr 4) and $F] shl 4) xor
            (table[(a shr 8) and $F] shl 8) xor
            (table[(a shr 12) and $F] shl 12) xor
            (table[(a shr 16) and $F] shl 16) xor
            (table[(a shr 20) and $F] shl 20) xor
            (table[(a shr 24) and $F] shl 24) xor
            (table[(a shr 28) and $F] shl 28);
end;

procedure SolveXFast(const vg,rhs:TVec; var dst:TVec; degreeU:longint);
var kernel:TWordArray;
var tables:array of TFixedMulTable;
var quotWord:LongWord; product:QWord;
var den,iv,rem,answer:THPolyW;
var d,len,center,dl,blockLen,size,pos,k,j0,lim,off,words:longint;
begin
d:=degreeU*2; len:=longint(n)-d;
VecZero(dst);
if len<=0 then exit;
dl:=d*2+1; if dl>len then dl:=len;
blockLen:=32; while blockLen*8<dl do blockLen:=blockLen shl 1;
size:=(dl+31) shr 5; if size<blockLen shr 5 then size:=blockLen shr 5;
if Length(qPool)<((len+31) shr 5)*2+size*64+128 then
  SetLength(qPool,((len+31) shr 5)*2+size*64+128);
if Length(qA)<size then SetLength(qA,size);
if Length(qB)<size then SetLength(qB,size);
if Length(qC)<size then SetLength(qC,size);
if Length(qR)<size*2 then SetLength(qR,size*2);
if Length(qS)<size*2 then SetLength(qS,size*2);
if Length(qWork)<size*10 then SetLength(qWork,size*10);
qTop:=0;
BuildUKernelFastW(vg,degreeU,kernel,center);
HPWAlloc(den,(dl+31) shr 5);
for j0:=0 to den.cap-1 do den.v^[j0]:=ReadDyn32(kernel,center-d+(j0 shl 5));
den.v^[den.cap-1]:=den.v^[den.cap-1] and HPWMask(((dl-1) and 31)+1);
den.d:=dl-1; HPWNorm(den);
HPWAlloc(rem,(len+31) shr 5);
for j0:=0 to rem.cap-1 do
  rem.v^[j0]:=ReverseWord32(ReadVec32Any(rhs,longint(n)-32-(j0 shl 5)));
rem.v^[rem.cap-1]:=rem.v^[rem.cap-1] and HPWMask(((len-1) and 31)+1);
rem.d:=len-1;
k:=blockLen; if k>len then k:=len;
HPWInvSeries(den,k,iv);
pos:=0;
{ The same fixed 32-coefficient multiplication leaf is fused in A/B. }
if blockLen=32 then
  begin
  SetLength(tables,den.cap+1);
  PrepareFixedMul(iv.v^[0],tables[0]);
  for j0:=0 to den.cap-1 do PrepareFixedMul(den.v^[j0],tables[j0+1]);
  for off:=0 to rem.cap-1 do
    begin
    quotWord:=LongWord(FixedMul32(tables[0],rem.v^[off]));
    lim:=den.cap-1; if lim>=rem.cap-off then lim:=rem.cap-off-1;
    for j0:=0 to lim do
      begin
      product:=FixedMul32(tables[j0+1],quotWord);
      if j0>0 then rem.v^[off+j0]:=rem.v^[off+j0] xor LongWord(product);
      if off+j0+1<rem.cap then rem.v^[off+j0+1]:=rem.v^[off+j0+1] xor LongWord(product shr 32);
      end;
    rem.v^[off]:=quotWord;
    end;
  end
else
begin
words:=blockLen shr 5;
FillChar(qA[0],size*4,0); FillChar(qB[0],size*4,0);
for j0:=0 to iv.cap-1 do qA[j0]:=iv.v^[j0];
for j0:=0 to den.cap-1 do qB[j0]:=den.v^[j0];
while pos<len do
  begin
  k:=len-pos; if k>blockLen then k:=blockLen;
  off:=pos shr 5;
  FillChar(qC[0],words*4,0); FillChar(qR[0],words*8,0);
  for j0:=0 to (k-1) shr 5 do qC[j0]:=rem.v^[off+j0];
  qC[(k-1) shr 5]:=qC[(k-1) shr 5] and HPWMask(((k-1) and 31)+1);
  KarRecW(qC,0,qA,0,qR,0,words,k,iv.d+1,qWork,0);
  if pos+k<len then
    begin
    FillChar(qR[words],(size-words)*4,0); FillChar(qS[0],size*8,0);
    KarRecW(qR,0,qB,0,qS,0,size,k,den.d+1,qWork,0);
    lim:=(k+den.d-1) shr 5; if lim>=rem.cap-off then lim:=rem.cap-off-1;
    for j0:=words to lim do rem.v^[off+j0]:=rem.v^[off+j0] xor qS[j0];
    end;
  for j0:=0 to (k-1) shr 5 do rem.v^[off+j0]:=qR[j0];
  inc(pos,k);
  end;
end;
rem.v^[rem.cap-1]:=rem.v^[rem.cap-1] and HPWMask(((len-1) and 31)+1);
HPWReverseAt(rem,len-1,len,answer);
HPWToVec(answer,dst,len-1);
qTop:=0;
end;

procedure CalcMat2;
var gu,qu,qv:TVec;
var sa,sb,hu,su,sv:TVec;
var z:TVec;
var r0,rU:longint;
var m2,hiS,rr,du,dv:longint;
begin
TimeMark('c');
TimeMark('q');
if (n and 1)=0 then
  begin
  m2:=longint(n div 2);
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
  hiS:=m2 div 2;
  GcdFChain(m2,hu,su,sv);
  if BuildOddGUV(hf,hc,hu,su,sv,gu,qu,qv,longint(n div 2),hiS,(m2 mod 3)=2) then
    rU:=TopBitLE(gu,longint(n div 2))
  else
    rU:=GcdU(f,c,gu,qu,qv,longint(n div 2));
  end;
r0:=rU*2;
TimeMark('z');
ApplyFastUComboW(qu,qv,y,z,n-1,longint(n div 2),0);
TimeMark('d');
if r0=0 then
  begin
  VecCopy(x,z);
  end
else
begin
TimeMark('x');
SolveXFast(gu,z,x,rU);
end;
end;

function GeneMat():boolean;
var t:TVec;
var wn0:longint;
var mask0:LongWord;
var k2:longint;
begin
TimeMark('g');
ApplyFastUComboW(f,c,x,t,n-1,longint(n div 2),2);
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
InitMul8;
InitUKernel8;
warming:=true;
{$ifdef disp}n:=m;{$else}n:=10000;{$endif}
PrepN;
MakeMat();
warming:=false;
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
