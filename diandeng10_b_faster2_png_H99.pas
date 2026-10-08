//{$define disp}
program diandeng;
{$mode objfpc}{$H+}

{ H99: preserve the common GF(2) formulas, coefficient blocks and cutoffs.
  B expands the same fixed joint-table construction, inlines its packed
  application, and uses byte tables for reversal and even-bit expansion.
  Timing remains milliseconds with three decimals.
  First-row core: O(n log^2(n) log log(n)) time, O(n) space, as in H98. }

{ H98: the GF(2) algorithm and cutoffs are unchanged. A remains Boolean.
  B locates a 64-bit head degree directly, splits reflected-word boundaries
  outside the Fibonacci loops, reads the retained output half directly,
  and uses fixed packed prefix stages for each binomial factor.
  First-row core: O(n log^2(n) log log(n)) time, O(n) space, as in H97. }

{ H97: combine U-polynomials in a single ordinary-H buffer, then apply
  one Laurent conversion. B reads whole reflected segments directly,
  matching the scalar reflection ranges in A.
  First-row core: O(n log^2(n) log log(n)) time, O(n) space, as in H96. }

{ H96: bound Boolean matrix updates by active row degrees, recover and mirror
  symmetric half-results, and use block zero/copy for plain vector storage.
  Hoist A coefficient-pair boundary checks; B retains the same packed formulas.
  First-row core: O(n log^2(n) log log(n)) time, O(n) space, as in H95. }

{ H83: recursive parity compression with a single shared workspace. }
{ Shared GF(2) formulas and coefficient blocks; B stores 32 coefficients per LongWord. }
{ H95: fold symmetric Fibonacci inputs, share the current summed kernel,
  and retain only the required final state. A uses serial Boolean prefix
  evaluation and pointer swaps; B uses the same formulas in packed words. }

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
var hiw:longint;
begin
hiw:=wn+1; if hiw>mw then hiw:=mw;
FillChar(v[-2],(hiw+3)*SizeOf(LongWord),0);
end;

procedure VecCopy(var a:TVec;const b:TVec);
var hiw:longint;
begin
hiw:=wn+1; if hiw>mw then hiw:=mw;
Move(b[-2],a[-2],(hiw+3)*SizeOf(LongWord));
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

{ H99: the same bit permutation, eight coefficients per table lookup. }
const reverseByte:array[0..255] of byte=(
0,128,64,192,32,160,96,224,16,144,80,208,48,176,112,240,
8,136,72,200,40,168,104,232,24,152,88,216,56,184,120,248,
4,132,68,196,36,164,100,228,20,148,84,212,52,180,116,244,
12,140,76,204,44,172,108,236,28,156,92,220,60,188,124,252,
2,130,66,194,34,162,98,226,18,146,82,210,50,178,114,242,
10,138,74,202,42,170,106,234,26,154,90,218,58,186,122,250,
6,134,70,198,38,166,102,230,22,150,86,214,54,182,118,246,
14,142,78,206,46,174,110,238,30,158,94,222,62,190,126,254,
1,129,65,193,33,161,97,225,17,145,81,209,49,177,113,241,
9,137,73,201,41,169,105,233,25,153,89,217,57,185,121,249,
5,133,69,197,37,165,101,229,21,149,85,213,53,181,117,245,
13,141,77,205,45,173,109,237,29,157,93,221,61,189,125,253,
3,131,67,195,35,163,99,227,19,147,83,211,51,179,115,243,
11,139,75,203,43,171,107,235,27,155,91,219,59,187,123,251,
7,135,71,199,39,167,103,231,23,151,87,215,55,183,119,247,
15,143,79,207,47,175,111,239,31,159,95,223,63,191,127,255);
function ReverseWord32(x:LongWord):LongWord; inline;
begin
ReverseWord32:=(LongWord(reverseByte[(x shr 0) and $FF]) shl 24) or (LongWord(reverseByte[(x shr 8) and $FF]) shl 16) or (LongWord(reverseByte[(x shr 16) and $FF]) shl 8) or (LongWord(reverseByte[(x shr 24) and $FF]) shl 0);
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

{ H99: coefficient i goes to coefficient 2*i, in eight-bit groups. }
const spreadByte:array[0..255] of word=(
0,1,4,5,16,17,20,21,64,65,68,69,80,81,84,85,
256,257,260,261,272,273,276,277,320,321,324,325,336,337,340,341,
1024,1025,1028,1029,1040,1041,1044,1045,1088,1089,1092,1093,1104,1105,1108,1109,
1280,1281,1284,1285,1296,1297,1300,1301,1344,1345,1348,1349,1360,1361,1364,1365,
4096,4097,4100,4101,4112,4113,4116,4117,4160,4161,4164,4165,4176,4177,4180,4181,
4352,4353,4356,4357,4368,4369,4372,4373,4416,4417,4420,4421,4432,4433,4436,4437,
5120,5121,5124,5125,5136,5137,5140,5141,5184,5185,5188,5189,5200,5201,5204,5205,
5376,5377,5380,5381,5392,5393,5396,5397,5440,5441,5444,5445,5456,5457,5460,5461,
16384,16385,16388,16389,16400,16401,16404,16405,16448,16449,16452,16453,16464,16465,16468,16469,
16640,16641,16644,16645,16656,16657,16660,16661,16704,16705,16708,16709,16720,16721,16724,16725,
17408,17409,17412,17413,17424,17425,17428,17429,17472,17473,17476,17477,17488,17489,17492,17493,
17664,17665,17668,17669,17680,17681,17684,17685,17728,17729,17732,17733,17744,17745,17748,17749,
20480,20481,20484,20485,20496,20497,20500,20501,20544,20545,20548,20549,20560,20561,20564,20565,
20736,20737,20740,20741,20752,20753,20756,20757,20800,20801,20804,20805,20816,20817,20820,20821,
21504,21505,21508,21509,21520,21521,21524,21525,21568,21569,21572,21573,21584,21585,21588,21589,
21760,21761,21764,21765,21776,21777,21780,21781,21824,21825,21828,21829,21840,21841,21844,21845);
function SpreadBits32(x:LongWord):QWord; inline;
begin
SpreadBits32:=(QWord(spreadByte[(x shr 0) and $FF]) shl 0) or (QWord(spreadByte[(x shr 8) and $FF]) shl 16) or (QWord(spreadByte[(x shr 16) and $FF]) shl 32) or (QWord(spreadByte[(x shr 24) and $FF]) shl 48);
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

procedure ApplyUComboOnesW(const va,vb:TVec; var vdst:TVec; hi,degmax,mode:longint); forward;

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

{ H77: same 64/128-coefficient Karatsuba formulas as A. }
procedure KarLeaf128W(const a:array of LongWord; ao:longint; const b:array of LongWord; bo:longint;
                      var r:array of LongWord; ro:longint);
var z0,z1,z2,z3,z4,z5,z6,z7,z8,t0,t1,t2,u0,u1,u2:QWord;
var ax,bx,ax0,ax1,bx0,bx1:LongWord;
begin
ax0:=a[ao] xor a[ao+2]; ax1:=a[ao+1] xor a[ao+3];
bx0:=b[bo] xor b[bo+2]; bx1:=b[bo+1] xor b[bo+3];
ax:=a[ao]; bx:=b[bo]; z0:=0;
if (ax<>0) and (bx<>0) then z0:=CLMul32(ax,bx);
ax:=a[ao+1]; bx:=b[bo+1]; z1:=0;
if (ax<>0) and (bx<>0) then z1:=CLMul32(ax,bx);
ax:=a[ao] xor a[ao+1]; bx:=b[bo] xor b[bo+1]; z2:=0;
if (ax<>0) and (bx<>0) then z2:=CLMul32(ax,bx);
ax:=a[ao+2]; bx:=b[bo+2]; z3:=0;
if (ax<>0) and (bx<>0) then z3:=CLMul32(ax,bx);
ax:=a[ao+3]; bx:=b[bo+3]; z4:=0;
if (ax<>0) and (bx<>0) then z4:=CLMul32(ax,bx);
ax:=a[ao+2] xor a[ao+3]; bx:=b[bo+2] xor b[bo+3]; z5:=0;
if (ax<>0) and (bx<>0) then z5:=CLMul32(ax,bx);
ax:=ax0; bx:=bx0; z6:=0;
if (ax<>0) and (bx<>0) then z6:=CLMul32(ax,bx);
ax:=ax1; bx:=bx1; z7:=0;
if (ax<>0) and (bx<>0) then z7:=CLMul32(ax,bx);
ax:=ax0 xor ax1; bx:=bx0 xor bx1; z8:=0;
if (ax<>0) and (bx<>0) then z8:=CLMul32(ax,bx);
t0:=z0 xor z1 xor z2; t1:=z3 xor z4 xor z5; t2:=z6 xor z7 xor z8;
u0:=z6 xor z0 xor z3; u1:=t2 xor t0 xor t1; u2:=z7 xor z1 xor z4;
r[ro]:=r[ro] xor LongWord(z0);
r[ro+1]:=r[ro+1] xor LongWord(z0 shr 32) xor LongWord(t0);
r[ro+2]:=r[ro+2] xor LongWord(z1) xor LongWord(t0 shr 32) xor LongWord(u0);
r[ro+3]:=r[ro+3] xor LongWord(z1 shr 32) xor LongWord(u0 shr 32) xor LongWord(u1);
r[ro+4]:=r[ro+4] xor LongWord(z3) xor LongWord(u1 shr 32) xor LongWord(u2);
r[ro+5]:=r[ro+5] xor LongWord(z3 shr 32) xor LongWord(t1) xor LongWord(u2 shr 32);
r[ro+6]:=r[ro+6] xor LongWord(z4) xor LongWord(t1 shr 32);
r[ro+7]:=r[ro+7] xor LongWord(z4 shr 32);
end;

{ H73: convolution core with fused 64-coefficient leaves. }
{ H78: the same three-block six-product decomposition as A. }
procedure KarLeaf192W(const a:TWordArray; ao:longint; const b:TWordArray; bo:longint;
                      var r:TWordArray; ro,alen,blen:longint);
var p0,p1,p2,p01,p02,p12,h0,h1,h2,h01,h02,h12,c1,c2,c3,d1,d2,d3:QWord;
var aa0,aa1,bb0,bb1,ax,bx,at0,at1,bt0,bt1:LongWord;
var z0,z1,z2:QWord; rr:array[0..5] of QWord;
var i,last:longint;
begin
at0:=a[ao+4]; bt0:=b[bo+4]; at1:=0; bt1:=0;
if alen>160 then at1:=a[ao+5]; if blen>160 then bt1:=b[bo+5];
begin
  aa0:=a[ao]; aa1:=a[ao+1]; bb0:=b[bo]; bb1:=b[bo+1];
  z0:=0; z1:=0; z2:=0;
  if (aa0<>0) and (bb0<>0) then z0:=CLMul32(aa0,bb0);
  if (aa1<>0) and (bb1<>0) then z2:=CLMul32(aa1,bb1);
  ax:=aa0 xor aa1; bx:=bb0 xor bb1;
  if (ax<>0) and (bx<>0) then z1:=CLMul32(ax,bx);
  z1:=z1 xor z0 xor z2;
  p0:=z0 xor (z1 shl 32); h0:=z2 xor (z1 shr 32);
  end;
begin
  aa0:=a[ao+2]; aa1:=a[ao+3]; bb0:=b[bo+2]; bb1:=b[bo+3];
  z0:=0; z1:=0; z2:=0;
  if (aa0<>0) and (bb0<>0) then z0:=CLMul32(aa0,bb0);
  if (aa1<>0) and (bb1<>0) then z2:=CLMul32(aa1,bb1);
  ax:=aa0 xor aa1; bx:=bb0 xor bb1;
  if (ax<>0) and (bx<>0) then z1:=CLMul32(ax,bx);
  z1:=z1 xor z0 xor z2;
  p1:=z0 xor (z1 shl 32); h1:=z2 xor (z1 shr 32);
  end;
if (alen<=160) and (blen<=160) then
  begin p2:=0; h2:=0; if (at0<>0) and (bt0<>0) then p2:=CLMul32(at0,bt0); end
else begin
  aa0:=at0; aa1:=at1; bb0:=bt0; bb1:=bt1;
  z0:=0; z1:=0; z2:=0;
  if (aa0<>0) and (bb0<>0) then z0:=CLMul32(aa0,bb0);
  if (aa1<>0) and (bb1<>0) then z2:=CLMul32(aa1,bb1);
  ax:=aa0 xor aa1; bx:=bb0 xor bb1;
  if (ax<>0) and (bx<>0) then z1:=CLMul32(ax,bx);
  z1:=z1 xor z0 xor z2;
  p2:=z0 xor (z1 shl 32); h2:=z2 xor (z1 shr 32);
  end;
begin
  aa0:=a[ao] xor a[ao+2]; aa1:=a[ao+1] xor a[ao+3]; bb0:=b[bo] xor b[bo+2]; bb1:=b[bo+1] xor b[bo+3];
  z0:=0; z1:=0; z2:=0;
  if (aa0<>0) and (bb0<>0) then z0:=CLMul32(aa0,bb0);
  if (aa1<>0) and (bb1<>0) then z2:=CLMul32(aa1,bb1);
  ax:=aa0 xor aa1; bx:=bb0 xor bb1;
  if (ax<>0) and (bx<>0) then z1:=CLMul32(ax,bx);
  z1:=z1 xor z0 xor z2;
  p01:=z0 xor (z1 shl 32); h01:=z2 xor (z1 shr 32);
  end;
begin
  aa0:=a[ao] xor at0; aa1:=a[ao+1] xor at1; bb0:=b[bo] xor bt0; bb1:=b[bo+1] xor bt1;
  z0:=0; z1:=0; z2:=0;
  if (aa0<>0) and (bb0<>0) then z0:=CLMul32(aa0,bb0);
  if (aa1<>0) and (bb1<>0) then z2:=CLMul32(aa1,bb1);
  ax:=aa0 xor aa1; bx:=bb0 xor bb1;
  if (ax<>0) and (bx<>0) then z1:=CLMul32(ax,bx);
  z1:=z1 xor z0 xor z2;
  p02:=z0 xor (z1 shl 32); h02:=z2 xor (z1 shr 32);
  end;
begin
  aa0:=a[ao+2] xor at0; aa1:=a[ao+3] xor at1; bb0:=b[bo+2] xor bt0; bb1:=b[bo+3] xor bt1;
  z0:=0; z1:=0; z2:=0;
  if (aa0<>0) and (bb0<>0) then z0:=CLMul32(aa0,bb0);
  if (aa1<>0) and (bb1<>0) then z2:=CLMul32(aa1,bb1);
  ax:=aa0 xor aa1; bx:=bb0 xor bb1;
  if (ax<>0) and (bx<>0) then z1:=CLMul32(ax,bx);
  z1:=z1 xor z0 xor z2;
  p12:=z0 xor (z1 shl 32); h12:=z2 xor (z1 shr 32);
  end;
c1:=p01 xor p0 xor p1; d1:=h01 xor h0 xor h1;
c2:=p02 xor p0 xor p2 xor p1; d2:=h02 xor h0 xor h2 xor h1;
c3:=p12 xor p1 xor p2; d3:=h12 xor h1 xor h2;
rr[0]:=p0; rr[1]:=h0 xor c1; rr[2]:=d1 xor c2;
rr[3]:=d2 xor c3; rr[4]:=d3 xor p2; rr[5]:=h2;
last:=(alen+blen+30) shr 5;
for i:=0 to 3 do
  begin
  r[ro+i*2]:=r[ro+i*2] xor LongWord(rr[i]);
  r[ro+i*2+1]:=r[ro+i*2+1] xor LongWord(rr[i] shr 32);
  end;
r[ro+8]:=r[ro+8] xor LongWord(rr[4]);
if last>9 then r[ro+9]:=r[ro+9] xor LongWord(rr[4] shr 32);
if last>10 then r[ro+10]:=r[ro+10] xor LongWord(rr[5]);
if last>11 then r[ro+11]:=r[ro+11] xor LongWord(rr[5] shr 32);
end;

{ H80: the same input sums, fourteen products and output XORs as A. }
procedure KarLeaf160W(const a:TWordArray; ao:longint; const b:TWordArray; bo:longint;
                      var r:TWordArray; ro,alen,blen:longint);
var e0,e2,e1,f0,f1,f2,f01,f02,f12,g0,g1,g01,g02,g12:QWord;
var ax,bx,ax0,bx0,ax1,bx1:LongWord;
var t0,t1,t2,t3,t4:QWord;
begin
ax:=a[ao+0]; bx:=b[bo+0];
e0:=0; if (ax<>0) and (bx<>0) then e0:=CLMul32(ax,bx);
ax:=a[ao+1]; bx:=b[bo+1];
e2:=0; if (ax<>0) and (bx<>0) then e2:=CLMul32(ax,bx);
ax:=a[ao+0] xor a[ao+1]; bx:=b[bo+0] xor b[bo+1];
e1:=0; if (ax<>0) and (bx<>0) then e1:=CLMul32(ax,bx);
ax:=a[ao+2]; bx:=b[bo+2];
f0:=0; if (ax<>0) and (bx<>0) then f0:=CLMul32(ax,bx);
ax:=a[ao+3]; bx:=b[bo+3];
f1:=0; if (ax<>0) and (bx<>0) then f1:=CLMul32(ax,bx);
ax:=a[ao+4]; bx:=b[bo+4];
f2:=0; if (ax<>0) and (bx<>0) then f2:=CLMul32(ax,bx);
ax:=a[ao+2] xor a[ao+3]; bx:=b[bo+2] xor b[bo+3];
f01:=0; if (ax<>0) and (bx<>0) then f01:=CLMul32(ax,bx);
ax:=a[ao+2] xor a[ao+4]; bx:=b[bo+2] xor b[bo+4];
f02:=0; if (ax<>0) and (bx<>0) then f02:=CLMul32(ax,bx);
ax:=a[ao+3] xor a[ao+4]; bx:=b[bo+3] xor b[bo+4];
f12:=0; if (ax<>0) and (bx<>0) then f12:=CLMul32(ax,bx);
ax0:=a[ao+0] xor a[ao+2]; bx0:=b[bo+0] xor b[bo+2];
g0:=0; if (ax0<>0) and (bx0<>0) then g0:=CLMul32(ax0,bx0);
ax1:=a[ao+1] xor a[ao+3]; bx1:=b[bo+1] xor b[bo+3];
g1:=0; if (ax1<>0) and (bx1<>0) then g1:=CLMul32(ax1,bx1);
ax:=ax0 xor ax1; bx:=bx0 xor bx1;
g01:=0; if (ax<>0) and (bx<>0) then g01:=CLMul32(ax,bx);
ax:=ax0 xor a[ao+4]; bx:=bx0 xor b[bo+4];
g02:=0; if (ax<>0) and (bx<>0) then g02:=CLMul32(ax,bx);
ax:=ax1 xor a[ao+4]; bx:=bx1 xor b[bo+4];
g12:=0; if (ax<>0) and (bx<>0) then g12:=CLMul32(ax,bx);
t0:=e0 xor e2;
t1:=e1 xor t0;
t2:=f0 xor g0;
t3:=f01 xor g1;
t4:=f02 xor f1;
g02:=e2 xor g0 xor g02 xor g1 xor t4;
g12:=f0 xor f12 xor g12 xor t3;
g01:=f1 xor g01 xor t1 xor t2 xor t3;
g0:=t0 xor t2;
e1:=t1;
f02:=f0 xor f2 xor t4;
f12:=f1 xor f12 xor f2;
r[ro+0]:=r[ro+0] xor LongWord(e0);
r[ro+1]:=r[ro+1] xor LongWord(e0 shr 32) xor LongWord(e1);
r[ro+2]:=r[ro+2] xor LongWord(e1 shr 32) xor LongWord(g0);
r[ro+3]:=r[ro+3] xor LongWord(g0 shr 32) xor LongWord(g01);
r[ro+4]:=r[ro+4] xor LongWord(g01 shr 32) xor LongWord(g02);
r[ro+5]:=r[ro+5] xor LongWord(g02 shr 32) xor LongWord(g12);
r[ro+6]:=r[ro+6] xor LongWord(g12 shr 32) xor LongWord(f02);
r[ro+7]:=r[ro+7] xor LongWord(f02 shr 32) xor LongWord(f12);
r[ro+8]:=r[ro+8] xor LongWord(f12 shr 32) xor LongWord(f2);
if alen+blen-1>288 then r[ro+9]:=r[ro+9] xor LongWord(f2 shr 32);
end;

{ H81: the same removal of whole zero 32-coefficient blocks as A. }
function KarTrimTopW(const a:TWordArray; first,count:longint):longint; inline;
var base:longint; value:LongWord;
begin
while count>0 do
  begin
  base:=(count-1) shr 5;
  value:=a[first+base] and (LongWord($FFFFFFFF) shr ((-count) and 31));
  if value<>0 then begin KarTrimTopW:=count; exit; end;
  count:=base shl 5;
  end;
KarTrimTopW:=0;
end;

{ H93: common cutoff measured in logical coefficients, not packed words. }
const toomCut=6144;

procedure KarConvW(const a:TWordArray; ao:longint; const b:TWordArray; bo:longint;
                 var r:TWordArray; ro,lenWords,alen,blen:longint;
                 var work:TWordArray; wo:longint); forward;

{ H94: exact radix-three transforms in GF(2)[t]/(t^(2M)+t^M+1).
  N=32*c*3^e (c=1 or 2), K=3^floor(e/2), M=N/K; all shifts are word aligned.
  Ring multiplication recurses to 2K products modulo t^(2M)+t^M+1.
  No floating point arithmetic or integer packing is used by A.
  With fixed leaves, R(N)<=2K*R(N/K)+O(N*log(K)); hence
  M(N)=O(N*log(N)*log(log(N))), and half-gcd adds one logarithm.
  Large low products use this full transform to avoid another log. }
const fftCut=131072;

procedure FFTShiftW(const a:TWordArray; ao:longint;
                     var d:TWordArray; shift,m:longint);
var pos,dst,cnt,i,power:longint;
begin
{ Rotate the two M-coefficient halves; multiplication by t^M maps
  (low,high) to (high,low+high), so no zero fill is necessary. }
power:=shift div m; dst:=shift mod m; pos:=0;
while pos<m do
  begin
  cnt:=m-dst; if cnt>m-pos then cnt:=m-pos;
  case power of
    0:begin
      Move(a[ao+pos],d[dst],cnt*4);
      Move(a[ao+m+pos],d[m+dst],cnt*4);
      end;
    1:for i:=0 to cnt-1 do
      begin
      d[dst+i]:=a[ao+m+pos+i];
      d[m+dst+i]:=a[ao+pos+i] xor a[ao+m+pos+i];
      end;
    2:for i:=0 to cnt-1 do
      begin
      d[dst+i]:=a[ao+pos+i] xor a[ao+m+pos+i];
      d[m+dst+i]:=a[ao+pos+i];
      end;
    end;
  inc(pos,cnt); dst:=0; inc(power); if power=3 then power:=0;
  end;
end;

procedure FFTTransformW(var a:TWordArray; k,m:longint; inverse:boolean);
var v,w:TWordArray;
var i,j,h,rev,digit,step,third,block0,p0,p1,p2,q,root:longint;
var u0,u1,v0,v1,w0,w1,s0,s1,tmp:LongWord;
begin
SetLength(v,m*2); SetLength(w,m*2);
{ In-place ternary digit reversal. }
for i:=0 to k-1 do
  begin
  rev:=0; digit:=i; h:=k;
  while h>1 do begin rev:=rev*3+digit mod 3; digit:=digit div 3; h:=h div 3; end;
  if i<rev then for j:=0 to m*2-1 do
    begin tmp:=a[i*m*2+j]; a[i*m*2+j]:=a[rev*m*2+j]; a[rev*m*2+j]:=tmp; end;
  end;
step:=3;
while step<=k do
  begin
  third:=step div 3; root:=m*3 div step; block0:=0;
  while block0<k do
    begin
    for j:=0 to third-1 do
      begin
      p0:=(block0+j)*m*2; p1:=p0+third*m*2; p2:=p1+third*m*2;
      q:=j*root; if inverse and (q<>0) then q:=m*3-q;
      FFTShiftW(a,p1,v,q,m);
      q:=q*2; if q>=m*3 then dec(q,m*3);
      FFTShiftW(a,p2,w,q,m);
      if inverse then begin h:=p1; p1:=p2; p2:=h; end;
      { psi=t^M: psi*(a+b*psi)=b+(a+b)*psi. }
      for i:=0 to m-1 do
        begin
        u0:=a[p0+i]; u1:=a[p0+m+i];
        v0:=v[i]; v1:=v[m+i]; w0:=w[i]; w1:=w[m+i];
        s0:=v0 xor w0; s1:=v1 xor w1;
        a[p0+i]:=u0 xor s0; a[p0+m+i]:=u1 xor s1;
        a[p1+i]:=u0 xor w0 xor s1; a[p1+m+i]:=u1 xor w1 xor s0 xor s1;
        a[p2+i]:=u0 xor v0 xor s1; a[p2+m+i]:=u1 xor v1 xor s0 xor s1;
        end;
      end;
    inc(block0,step);
    end;
  step:=step*3;
  end;
end;

{ Inputs occupy 2*count elements; N=count*32=32*c*3^e (c=1 or 2).
  Returns a*b modulo t^(2N)+t^N+1. Of the 3K Fourier points,
  only the 2K indices not divisible by three are needed. }
procedure FFTRingW(const a:TWordArray; ao:longint;
                    const b:TWordArray; bo:longint; var r:TWordArray; count:longint);
var aa,bb,p0,p1,pc,work:TWordArray;
var e,k,m,i,j,base,off0,off1,al,bl:longint;
begin
SetLength(r,count*2); FillChar(r[0],count*2*4,0);
if count*2*32<=fftCut then
  begin
  { Three half-size products, with reduction fused into recombination. }
  SetLength(aa,count); SetLength(bb,count);
  SetLength(p0,count*2); SetLength(p1,count*2); SetLength(pc,count*2);
  SetLength(work,count*5);
  for i:=0 to count-1 do
    begin aa[i]:=a[ao+i] xor a[ao+count+i]; bb[i]:=b[bo+i] xor b[bo+count+i]; end;
  al:=KarTrimTopW(a,ao,count*32); bl:=KarTrimTopW(b,bo,count*32);
  KarConvW(a,ao,b,bo,p0,0,count*32 div 32,al,bl,work,0);
  al:=KarTrimTopW(a,ao+count,count*32); bl:=KarTrimTopW(b,bo+count,count*32);
  KarConvW(a,ao+count,b,bo+count,p1,0,count*32 div 32,al,bl,work,0);
  al:=KarTrimTopW(aa,0,count*32); bl:=KarTrimTopW(bb,0,count*32);
  KarConvW(aa,0,bb,0,pc,0,count*32 div 32,al,bl,work,0);
  for i:=0 to count-1 do
    begin
    r[i]:=p0[i] xor p1[i] xor pc[count+i] xor p0[count+i];
    r[count+i]:=p1[count+i] xor pc[i] xor p0[i] xor pc[count+i];
    end;
  exit;
  end;
e:=0; i:=count*32 div 32;
while (i mod 3)=0 do begin inc(e); i:=i div 3; end;
k:=1; for i:=1 to e div 2 do k:=k*3;
m:=count div k;
SetLength(aa,count*6); SetLength(bb,count*6);
for i:=0 to k*2-1 do
  begin
  Move(a[ao+i*m],aa[i*m*2],m*4);
  Move(b[bo+i*m],bb[i*m*2],m*4);
  end;
FFTTransformW(aa,k*3,m,false); FFTTransformW(bb,k*3,m,false);
for i:=0 to k*3-1 do
  begin
  base:=i*m*2;
  if i mod 3=0 then FillChar(aa[base],m*2*4,0)
  else
    begin
    FFTRingW(aa,base,bb,base,pc,m);
    Move(pc[0],aa[base],m*2*4);
    end;
  end;
FFTTransformW(aa,k*3,m,true);
{ 3K is odd: inverse scale=1. Missing frequencies only change the
  multiple of X^(2K)+X^K+1, which the final reduction discards. }
for i:=0 to k*3-1 do
  begin
  base:=i*m*2; off0:=i*m; off1:=off0+m; if off1=count*3 then off1:=0;
  if off0<count*2 then
    for j:=0 to m-1 do r[off0+j]:=r[off0+j] xor aa[base+j]
  else
    for j:=0 to m-1 do
      begin
      r[off0-count*2+j]:=r[off0-count*2+j] xor aa[base+j];
      r[off0-count+j]:=r[off0-count+j] xor aa[base+j];
      end;
  if off1<count*2 then
    for j:=0 to m-1 do r[off1+j]:=r[off1+j] xor aa[base+m+j]
  else
    for j:=0 to m-1 do
      begin
      r[off1-count*2+j]:=r[off1-count*2+j] xor aa[base+m+j];
      r[off1-count+j]:=r[off1-count+j] xor aa[base+m+j];
      end;
  end;
end;

{ XOR the requested low coefficients of an ordinary product into r. }
procedure FFTProductW(const a:TWordArray; ao:longint;
                       const b:TWordArray; bo:longint; var r:TWordArray;
                       ro,alen,blen,lim:longint);
var aa,bb,cc:TWordArray;
var count,i,used:longint;
begin
if (alen<=0) or (blen<=0) or (lim<=0) then exit;
used:=alen+blen-1; if lim<used then used:=lim;
count:=32; while count*2<alen+blen-1 do count:=count*3;
if (count>=96) and ((count div 3)*4>=alen+blen-1) then count:=(count div 3)*2;
count:=count div 32;
SetLength(aa,count*2); SetLength(bb,count*2);
Move(a[ao],aa[0],((alen+31) shr 5)*4); Move(b[bo],bb[0],((blen+31) shr 5)*4);
aa[(alen-1) shr 5]:=aa[(alen-1) shr 5] and (LongWord($FFFFFFFF) shr ((-alen) and 31));
bb[(blen-1) shr 5]:=bb[(blen-1) shr 5] and (LongWord($FFFFFFFF) shr ((-blen) and 31));
FFTRingW(aa,0,bb,0,cc,count);
for i:=0 to (used shr 5)-1 do r[ro+i]:=r[ro+i] xor cc[i];
if (used and 31)<>0 then r[ro+(used shr 5)]:=r[ro+(used shr 5)] xor
  (cc[used shr 5] and (LongWord($FFFFFFFF) shr ((-used) and 31)));
end;

{ H93: the same five evaluations and exact divisions, packed in LongWord. }
procedure Toom3W(const a:TWordArray; ao:longint; const b:TWordArray; bo:longint;
                  var r:TWordArray; ro,alen,blen:longint);
var aa,bb,e1,et,eu,f1,ft,fu,p0,p1,pt,pu,p4,w:TWordArray;
var k,l,i,top,lim,a0,a2,b0,b2:longint;
var c2,c3,prev2,prev3,old3,st,st1,s1,v4:LongWord;
begin
top:=alen;if blen>top then top:=blen;
k:=(top+95) div 96;l:=k+1;
SetLength(aa,k*3);SetLength(bb,k*3);
for i:=0 to (alen+31) shr 5-1 do aa[i]:=a[ao+i];
for i:=0 to (blen+31) shr 5-1 do bb[i]:=b[bo+i];
if (alen and 31)<>0 then aa[alen shr 5]:=aa[alen shr 5] and (LongWord($FFFFFFFF) shr ((-alen) and 31));
if (blen and 31)<>0 then bb[blen shr 5]:=bb[blen shr 5] and (LongWord($FFFFFFFF) shr ((-blen) and 31));
SetLength(e1,l);SetLength(et,l);SetLength(eu,l);
SetLength(f1,l);SetLength(ft,l);SetLength(fu,l);
for i:=0 to k-1 do
  begin
  e1[i]:=aa[i] xor aa[k+i] xor aa[k*2+i];f1[i]:=bb[i] xor bb[k+i] xor bb[k*2+i];
  et[i]:=et[i] xor aa[i] xor (aa[k+i] shl 1) xor (aa[k*2+i] shl 2);
  et[i+1]:=(aa[k+i] shr 31) xor (aa[k*2+i] shr 30);
  ft[i]:=ft[i] xor bb[i] xor (bb[k+i] shl 1) xor (bb[k*2+i] shl 2);
  ft[i+1]:=(bb[k+i] shr 31) xor (bb[k*2+i] shr 30);
  eu[i]:=et[i] xor aa[k+i] xor aa[k*2+i];fu[i]:=ft[i] xor bb[k+i] xor bb[k*2+i];
  end;
eu[k]:=et[k];fu[k]:=ft[k];
SetLength(p0,l*2);SetLength(p1,l*2);SetLength(pt,l*2);SetLength(pu,l*2);SetLength(p4,l*2);
SetLength(w,l*5);
a0:=alen;if a0>k*32 then a0:=k*32;b0:=blen;if b0>k*32 then b0:=k*32;
a2:=alen-k*64;b2:=blen-k*64;
KarConvW(aa,0,bb,0,p0,0,k,a0,b0,w,0);
KarConvW(aa,k*2,bb,k*2,p4,0,k,a2,b2,w,0);
KarConvW(e1,0,f1,0,p1,0,k,k*32,k*32,w,0);
KarConvW(et,0,ft,0,pt,0,l,k*32+2,k*32+2,w,0);
KarConvW(eu,0,fu,0,pu,0,l,k*32+2,k*32+2,w,0);
for i:=l*2-1 downto 0 do
  begin
  s1:=p1[i] xor p0[i] xor p4[i];v4:=p4[i] shl 4;if i>0 then v4:=v4 xor (p4[i-1] shr 28);
  st:=pt[i] xor p0[i] xor v4;st1:=pu[i] xor p0[i] xor p4[i] xor v4;
  p1[i]:=s1;pt[i]:=st;pu[i]:=st xor st1 xor s1;
  end;
{ The same c3 and c2 divisions as A; each prefix packs 32 recurrence steps. }
prev2:=0;prev3:=0;lim:=(alen+blen+30) shr 5;
for i:=0 to k*2-1 do
  begin
  old3:=prev3;c3:=(pu[i] shr 1) xor (pu[i+1] shl 31);
  c3:=c3 xor (c3 shl 1);c3:=c3 xor (c3 shl 2);c3:=c3 xor (c3 shl 4);c3:=c3 xor (c3 shl 8);c3:=c3 xor (c3 shl 16);
  if prev3<>0 then c3:=not c3;prev3:=c3 shr 31;
  c2:=(pt[i] shr 1) xor (pt[i+1] shl 31) xor p1[i];
  c2:=c2 xor (c2 shl 1);c2:=c2 xor (c2 shl 2);c2:=c2 xor (c2 shl 4);c2:=c2 xor (c2 shl 8);c2:=c2 xor (c2 shl 16);
  if prev2<>0 then c2:=not c2;prev2:=c2 shr 31;c2:=c2 xor c3 xor (c3 shl 1) xor old3;
  if i<lim then r[ro+i]:=r[ro+i] xor p0[i];
  if k+i<lim then r[ro+k+i]:=r[ro+k+i] xor p1[i] xor c2 xor c3;
  if 2*k+i<lim then r[ro+2*k+i]:=r[ro+2*k+i] xor c2;
  if 3*k+i<lim then r[ro+3*k+i]:=r[ro+3*k+i] xor c3;
  if 4*k+i<lim then r[ro+4*k+i]:=r[ro+4*k+i] xor p4[i];
  end;
end;

procedure KarConvW(const a:TWordArray; ao:longint; const b:TWordArray; bo:longint;
                  var r:TWordArray; ro,lenWords,alen,blen:longint;
                  var work:TWordArray; wo:longint);
const cut=8;
var afull,bfull,a128,b128,startB,ai,bi,ri:longint;
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
if (alen>128) and (blen>128) and (alen<=160) and (blen<=160) then
  begin KarLeaf160W(a,ao,b,bo,r,ro,alen,blen); exit; end;
if (alen>128) and (blen>128) and (alen<=192) and (blen<=192) then
  begin KarLeaf192W(a,ao,b,bo,r,ro,alen,blen); exit; end;
if (alen>toomCut) or (blen>toomCut) then
  begin
  if (alen>fftCut) or (blen>fftCut) then FFTProductW(a,ao,b,bo,r,ro,alen,blen,alen+blen-1)
  else Toom3W(a,ao,b,bo,r,ro,alen,blen);
  exit;
  end;
if lenWords<=cut then
  begin
  aWords:=(alen+31) shr 5;
  bWords:=(blen+31) shr 5;
  afull:=(alen div 64)*2; bfull:=(blen div 64)*2;
  a128:=(alen div 128)*4; b128:=(blen div 128)*4;
  for i0:=0 to a128 div 4-1 do for j0:=0 to b128 div 4-1 do
    KarLeaf128W(a,ao+i0*4,b,bo+j0*4,r,ro+(i0+j0)*4);
  for i0:=0 to afull div 2-1 do for j0:=0 to bfull div 2-1 do
    if (i0*2>=a128) or (j0*2>=b128) then begin
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
var i0,lenBits,hWords,gWords,ax0,bx0,z10,rec0:longint;
var a0len,a1len,b0len,b1len,axlen,bxlen:longint;
var mid0:LongWord;
begin
lenBits:=lenWords shl 5;
if alen>lenBits then alen:=lenBits;
if blen>lenBits then blen:=lenBits;
if (alen<=0) or (blen<=0) then exit;
alen:=KarTrimTopW(a,ao,alen); blen:=KarTrimTopW(b,bo,blen);
if (alen<=0) or (blen<=0) then exit;
if lenWords>cut then
  begin
  lenBits:=alen; if blen>lenBits then lenBits:=blen;
  lenWords:=(lenBits+31) shr 5;
  end;
if (alen>toomCut) or (blen>toomCut) then
  begin
  if (alen>fftCut) or (blen>fftCut) then FFTProductW(a,ao,b,bo,r,ro,alen,blen,alen+blen-1)
  else Toom3W(a,ao,b,bo,r,ro,alen,blen);
  exit;
  end;
if lenWords<=cut then
  begin
  KarConvW(a,ao,b,bo,r,ro,lenWords,alen,blen,work,wo);
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
if (alen>fftCut) or (blen>fftCut) then
  begin
  FFTProductW(a,ao,b,bo,r,ro,alen,blen,lim);
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

function KarParityW(const a,b:TWordArray; var r:TWordArray; lenWords,alen,blen:longint):boolean; forward;

procedure KarMulFastW(const a,b:TWordArray; var r:TWordArray;
                      lenWords,alen,blen:longint);
var work:TWordArray;
var i0:longint;
begin
if lenWords>8 then if KarParityW(a,b,r,lenWords,alen,blen) then exit;
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
var i0,lenBits,hWords,gWords,ax0,bx0,cx0,zr0,zs0,rec0:longint;
var a0len,a1len,b0len,b1len,c0len,c1len,axlen,bxlen,cxlen:longint;
var mid0,mid1:LongWord;
begin
lenBits:=lenWords shl 5;
if alen>lenBits then alen:=lenBits;
if blen>lenBits then blen:=lenBits;
if clen>lenBits then clen:=lenBits;
if (alen<=0) or ((blen<=0) and (clen<=0)) then exit;
alen:=KarTrimTopW(a,ao,alen); blen:=KarTrimTopW(b,bo,blen);
clen:=KarTrimTopW(c,co,clen);
if (alen<=0) or ((blen<=0) and (clen<=0)) then exit;
if lenWords>cut then
  begin
  lenBits:=alen; if blen>lenBits then lenBits:=blen;
  if clen>lenBits then lenBits:=clen;
  lenWords:=(lenBits+31) shr 5;
  end;
if (alen>toomCut) or (blen>toomCut) or (clen>toomCut) then
  begin
  KarRecW(a,ao,b,bo,r,ro,lenWords,alen,blen,work,wo);
  KarRecW(a,ao,c,co,s,so,lenWords,alen,clen,work,wo);
  exit;
  end;
if lenWords<=cut then
  begin
  KarConvW(a,ao,b,bo,r,ro,lenWords,alen,blen,work,wo);
  KarConvW(a,ao,c,co,s,so,lenWords,alen,clen,work,wo);
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

function CompactEven32(value:LongWord):LongWord; inline;
begin
value:=value and $55555555;
value:=(value or (value shr 1)) and $33333333;
value:=(value or (value shr 2)) and $0F0F0F0F;
value:=(value or (value shr 4)) and $00FF00FF;
CompactEven32:=(value or (value shr 8)) and $0000FFFF;
end;

{ H83: the same parity factorization and two half-length products as A. }
{ H83 revision: recursively reuse one workspace for parity compression. }
procedure KarParityRecW(const a:TWordArray; ao:longint; const b:TWordArray; bo:longint;
                     var r:TWordArray; ro,lenWords,alen,blen:longint;
                     var work:TWordArray; wo:longint); forward;

function KarParityStepW(const a:TWordArray; ao:longint; const b:TWordArray; bo:longint;
                     var r:TWordArray; ro,lenWords,alen,blen:longint;
                     var work:TWordArray; wo:longint):boolean;
var i,halfWords,halfA,halfB,kind,aWords,bWords,shift:longint;
var evenOnly,oddOnly,paired,constantBit:boolean;
var value,ev,od,diff:LongWord;
var product,carry,resultWord:QWord;
begin
KarParityStepW:=false; evenOnly:=true; oddOnly:=true; paired:=true;
aWords:=(alen+31) shr 5; bWords:=(blen+31) shr 5;
for i:=0 to aWords-1 do
  begin
  value:=a[ao+i]; if i=aWords-1 then value:=value and (LongWord($FFFFFFFF) shr ((-alen) and 31));
  ev:=value and $55555555; od:=(value shr 1) and $55555555;
  if od<>0 then evenOnly:=false;
  if ev<>0 then oddOnly:=false;
  diff:=ev xor od; if i=0 then diff:=diff and not LongWord(1);
  if diff<>0 then paired:=false;
  if not (evenOnly or oddOnly or paired) then exit;
  end;
kind:=0; if not evenOnly then if oddOnly then kind:=1 else kind:=2;
halfWords:=(lenWords+1) shr 1;
halfA:=(alen+1) shr 1; if kind<>0 then halfA:=alen shr 1;
halfB:=(blen+1) shr 1;
if wo<0 then begin SetLength(work,halfWords*17); wo:=0; end
else FillChar(work[wo],halfWords*3*4,0);
shift:=0; if kind<>0 then shift:=1;
for i:=0 to aWords-1 do
  begin
  value:=a[ao+i]; if i=aWords-1 then value:=value and (LongWord($FFFFFFFF) shr ((-alen) and 31));
  work[wo+(i shr 1)]:=work[wo+(i shr 1)] or (CompactEven32(value shr shift) shl ((i and 1)*16));
  end;
for i:=0 to bWords-1 do
  begin
  value:=b[bo+i]; if i=bWords-1 then value:=value and (LongWord($FFFFFFFF) shr ((-blen) and 31));
  work[wo+halfWords+(i shr 1)]:=work[wo+halfWords+(i shr 1)] or (CompactEven32(value) shl ((i and 1)*16));
  work[wo+halfWords*2+(i shr 1)]:=work[wo+halfWords*2+(i shr 1)] or (CompactEven32(value shr 1) shl ((i and 1)*16));
  end;
KarParityRecW(work,wo,work,wo+halfWords,work,wo+halfWords*3,
             halfWords,halfA,halfB,work,wo+halfWords*7);
KarParityRecW(work,wo,work,wo+halfWords*2,work,wo+halfWords*5,
             halfWords,halfA,blen shr 1,work,wo+halfWords*7);
carry:=0;
for i:=0 to lenWords-1 do
  begin
  product:=SpreadBits32(work[wo+halfWords*3+i]) xor (SpreadBits32(work[wo+halfWords*5+i]) shl 1);
  resultWord:=product;
  if kind=1 then resultWord:=(product shl 1) xor carry;
  if kind=2 then resultWord:=product xor (product shl 1) xor carry;
  carry:=product shr 63;
  r[ro+2*i]:=LongWord(resultWord); r[ro+2*i+1]:=LongWord(resultWord shr 32);
  end;
constantBit:=false; if kind=2 then constantBit:=((a[ao+0] xor (a[ao+0] shr 1)) and 1)<>0;
if constantBit then for i:=0 to bWords-1 do
  begin
  value:=b[bo+i]; if i=bWords-1 then value:=value and (LongWord($FFFFFFFF) shr ((-blen) and 31));
  r[ro+i]:=r[ro+i] xor value;
  end;
KarParityStepW:=true;
end;

procedure KarParityRecW(const a:TWordArray; ao:longint; const b:TWordArray; bo:longint;
                     var r:TWordArray; ro,lenWords,alen,blen:longint;
                     var work:TWordArray; wo:longint);
begin
if lenWords>8 then if KarParityStepW(a,ao,b,bo,r,ro,lenWords,alen,blen,work,wo) then exit;
FillChar(r[ro],lenWords shl 3,0);
KarConvW(a,ao,b,bo,r,ro,lenWords,alen,blen,work,wo);
end;

function KarParityW(const a,b:TWordArray; var r:TWordArray; lenWords,alen,blen:longint):boolean;
var work:TWordArray;
begin
SetLength(r,lenWords shl 1);
KarParityW:=KarParityStepW(a,0,b,0,r,0,lenWords,alen,blen,work,-1);
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

{ H86: fixed recursion leaf of degree <= 4096, identical in A/B. }
const hgcdCutW=4096;
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
if (alen>fftCut) or (blen>fftCut) or (clen>fftCut) then
  begin
  FFTProductW(a,ao,b,bo,r,ro,alen,blen,lim);
  FFTProductW(a,ao,c,co,s,so,alen,clen,lim);
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
{ H84: the same 32-coefficient window and degree <= 15 matrix, bit packed. }
function BlockStep:boolean;
var a0,a1,at,m00,m01,m10,m11,mt:LongWord;
var index:array[0..11] of LongWord;
var lo,e0,e1,sh,tmp,c00,c01,c10,c11:longint;
function Head(const x:TL):LongWord; inline;
var ws,bs:longint;
begin
ws:=lo shr 5; bs:=lo and 31;
Head:=LongWord((QWord(x[ws]) or (QWord(x[ws+1]) shl 32)) shr bs) ;
end;
procedure ApplyPair(var x,y:TL; var dx,dy:longint);
var i,lim:longint; cx,cy,xx,yy,l,h,m,xl,xh,yl,yh:LongWord;
begin
lim:=dx; if dy>lim then lim:=dy;
lim:=(lim+32) shr 5; cx:=0; cy:=0;
for i:=0 to lim-1 do
  begin
  xx:=x[i]; yy:=y[i];
  l:=mul8[index[0] or ((xx shr 0) and $FF)] xor mul8[index[1] or ((yy shr 0) and $FF)];
  h:=mul8[index[2] or ((xx shr 8) and $FF)] xor mul8[index[3] or ((yy shr 8) and $FF)];
  m:=mul8[index[4] or (((xx shr 0) xor (xx shr 8)) and $FF)] xor
     mul8[index[5] or (((yy shr 0) xor (yy shr 8)) and $FF)];
  xl:=l xor ((m xor l xor h) shl 8) xor (h shl 16);
  l:=mul8[index[0] or ((xx shr 16) and $FF)] xor mul8[index[1] or ((yy shr 16) and $FF)];
  h:=mul8[index[2] or ((xx shr 24) and $FF)] xor mul8[index[3] or ((yy shr 24) and $FF)];
  m:=mul8[index[4] or (((xx shr 16) xor (xx shr 24)) and $FF)] xor
     mul8[index[5] or (((yy shr 16) xor (yy shr 24)) and $FF)];
  xh:=l xor ((m xor l xor h) shl 8) xor (h shl 16);
  l:=mul8[index[6] or ((xx shr 0) and $FF)] xor mul8[index[7] or ((yy shr 0) and $FF)];
  h:=mul8[index[8] or ((xx shr 8) and $FF)] xor mul8[index[9] or ((yy shr 8) and $FF)];
  m:=mul8[index[10] or (((xx shr 0) xor (xx shr 8)) and $FF)] xor
     mul8[index[11] or (((yy shr 0) xor (yy shr 8)) and $FF)];
  yl:=l xor ((m xor l xor h) shl 8) xor (h shl 16);
  l:=mul8[index[6] or ((xx shr 16) and $FF)] xor mul8[index[7] or ((yy shr 16) and $FF)];
  h:=mul8[index[8] or ((xx shr 24) and $FF)] xor mul8[index[9] or ((yy shr 24) and $FF)];
  m:=mul8[index[10] or (((xx shr 16) xor (xx shr 24)) and $FF)] xor
     mul8[index[11] or (((yy shr 16) xor (yy shr 24)) and $FF)];
  yh:=l xor ((m xor l xor h) shl 8) xor (h shl 16);
  x[i]:=xl xor (xh shl 16) xor cx; y[i]:=yl xor (yh shl 16) xor cy;
  cx:=xh shr 16; cy:=yh shr 16;
  end;
x[lim]:=cx; y[lim]:=cy;
dx:=lim*32+15; dy:=dx; Degree(x,dx); Degree(y,dy);
end;
begin
BlockStep:=false;
if (d0<63) or (d1>d0) or (d1<d0-15) or (d1<target+16) then exit;
lo:=d0-31; a0:=Head(r0^); a1:=Head(r1^);
m00:=1; m01:=0; m10:=0; m11:=1; e0:=31; e1:=d1-lo;
while e1>=16 do
  begin
  while e0>=e1 do
    begin
    sh:=e0-e1; a0:=a0 xor (a1 shl sh);
    m00:=m00 xor (m10 shl sh); m01:=m01 xor (m11 shl sh);
    if a0=0 then e0:=-1 else e0:=HighBit32(a0);
    end;
  at:=a0; a0:=a1; a1:=at; tmp:=e0; e0:=e1; e1:=tmp;
  mt:=m00; m00:=m10; m10:=mt; mt:=m01; m01:=m11; m11:=mt;
  end;
c00:=m00; c01:=m01; c10:=m10; c11:=m11;
index[0]:=(c00 and $FF) shl 8;
index[1]:=(c01 and $FF) shl 8;
index[2]:=c00 and $FF00;
index[3]:=c01 and $FF00;
index[4]:=((c00 xor (c00 shr 8)) and $FF) shl 8;
index[5]:=((c01 xor (c01 shr 8)) and $FF) shl 8;
index[6]:=(c10 and $FF) shl 8;
index[7]:=(c11 and $FF) shl 8;
index[8]:=c10 and $FF00;
index[9]:=c11 and $FF00;
index[10]:=((c10 xor (c10 shr 8)) and $FF) shl 8;
index[11]:=((c11 xor (c11 shr 8)) and $FF) shl 8;

ApplyPair(r0^,r1^,d0,d1); ApplyPair(u0^,u1^,du0,du1); ApplyPair(v0^,v1^,dv0,dv1);
BlockStep:=true;
end;
{ H85: a 64-coefficient window batches a degree <= 31 matrix. }
function BlockStep64:boolean;
var a0,a1,at:QWord; m00,m01,m10,m11,mt:LongWord;
var lo,e0,e1,sh,tmp:longint;
var tx,ty:array[0..63] of QWord;
var jx,jy:QWord;
function Head(const x:TL):QWord; inline;
var ws,bs:longint;
begin
ws:=lo shr 5; bs:=lo and 31;
Head:=(QWord(x[ws]) or (QWord(x[ws+1]) shl 32)) shr bs;
if bs<>0 then Head:=Head or (QWord(x[ws+2]) shl (64-bs));
end;
{ H91: cache each LongWord input while applying the same 3+3 joint table. }
procedure ApplyPair32(var x,y:TL; var dx,dy:longint); inline;
var i,lim:longint; index:array[0..10] of longint;
var xx,yy:QWord; cx,cy,vx,vy:LongWord;
begin
cx:=0; cy:=0;
lim:=dx; if dy>lim then lim:=dy; lim:=(lim+32) shr 5;
for i:=0 to lim-1 do
  begin
  vx:=x[i]; vy:=y[i];
  index[0]:=((vx shr 0) and 7) or (((vy shr 0) and 7) shl 3);
  index[1]:=((vx shr 3) and 7) or (((vy shr 3) and 7) shl 3);
  index[2]:=((vx shr 6) and 7) or (((vy shr 6) and 7) shl 3);
  index[3]:=((vx shr 9) and 7) or (((vy shr 9) and 7) shl 3);
  index[4]:=((vx shr 12) and 7) or (((vy shr 12) and 7) shl 3);
  index[5]:=((vx shr 15) and 7) or (((vy shr 15) and 7) shl 3);
  index[6]:=((vx shr 18) and 7) or (((vy shr 18) and 7) shl 3);
  index[7]:=((vx shr 21) and 7) or (((vy shr 21) and 7) shl 3);
  index[8]:=((vx shr 24) and 7) or (((vy shr 24) and 7) shl 3);
  index[9]:=((vx shr 27) and 7) or (((vy shr 27) and 7) shl 3);
  index[10]:=((vx shr 30) and 3) or (((vy shr 30) and 3) shl 3);
  xx:=(tx[index[0]] shl 0) xor (tx[index[1]] shl 3) xor (tx[index[2]] shl 6) xor (tx[index[3]] shl 9) xor (tx[index[4]] shl 12) xor (tx[index[5]] shl 15) xor (tx[index[6]] shl 18) xor (tx[index[7]] shl 21) xor (tx[index[8]] shl 24) xor (tx[index[9]] shl 27) xor (tx[index[10]] shl 30);
  x[i]:=LongWord(xx) xor cx; cx:=LongWord(xx shr 32);
  yy:=(ty[index[0]] shl 0) xor (ty[index[1]] shl 3) xor (ty[index[2]] shl 6) xor (ty[index[3]] shl 9) xor (ty[index[4]] shl 12) xor (ty[index[5]] shl 15) xor (ty[index[6]] shl 18) xor (ty[index[7]] shl 21) xor (ty[index[8]] shl 24) xor (ty[index[9]] shl 27) xor (ty[index[10]] shl 30);
  y[i]:=LongWord(yy) xor cy; cy:=LongWord(yy shr 32);
  end;
x[lim]:=cx; y[lim]:=cy;
dx:=lim*32+31; dy:=dx; Degree(x,dx); Degree(y,dy);
end;
begin
BlockStep64:=false;
if (d0<127) or (d1>d0) or (d1<d0-31) or (d1<target+32) then exit;
lo:=d0-63; a0:=Head(r0^); a1:=Head(r1^);
m00:=1; m01:=0; m10:=0; m11:=1; e0:=63; e1:=d1-lo;
while e1>=32 do
  begin
  while e0>=e1 do
    begin
    sh:=e0-e1; a0:=a0 xor (a1 shl sh);
    m00:=m00 xor (m10 shl sh); m01:=m01 xor (m11 shl sh);
    if (a0 shr 32)<>0 then e0:=32+HighBit32(LongWord(a0 shr 32))
    else e0:=HighBit32(LongWord(a0));
    end;
  at:=a0; a0:=a1; a1:=at; tmp:=e0; e0:=e1; e1:=tmp;
  mt:=m00; m00:=m10; m10:=mt; mt:=m01; m01:=m11; m11:=mt;
  end;
{ H99: the same six binary table extensions, with fixed indices. }
tx[0]:=0; ty[0]:=0;
jx:=QWord(m00) shl 0; jy:=QWord(m10) shl 0;
tx[1]:=tx[0] xor jx; ty[1]:=ty[0] xor jy;
jx:=QWord(m00) shl 1; jy:=QWord(m10) shl 1;
tx[2]:=tx[0] xor jx; ty[2]:=ty[0] xor jy;
tx[3]:=tx[1] xor jx; ty[3]:=ty[1] xor jy;
jx:=QWord(m00) shl 2; jy:=QWord(m10) shl 2;
tx[4]:=tx[0] xor jx; ty[4]:=ty[0] xor jy;
tx[5]:=tx[1] xor jx; ty[5]:=ty[1] xor jy;
tx[6]:=tx[2] xor jx; ty[6]:=ty[2] xor jy;
tx[7]:=tx[3] xor jx; ty[7]:=ty[3] xor jy;
jx:=QWord(m01) shl 0; jy:=QWord(m11) shl 0;
tx[8]:=tx[0] xor jx; ty[8]:=ty[0] xor jy;
tx[9]:=tx[1] xor jx; ty[9]:=ty[1] xor jy;
tx[10]:=tx[2] xor jx; ty[10]:=ty[2] xor jy;
tx[11]:=tx[3] xor jx; ty[11]:=ty[3] xor jy;
tx[12]:=tx[4] xor jx; ty[12]:=ty[4] xor jy;
tx[13]:=tx[5] xor jx; ty[13]:=ty[5] xor jy;
tx[14]:=tx[6] xor jx; ty[14]:=ty[6] xor jy;
tx[15]:=tx[7] xor jx; ty[15]:=ty[7] xor jy;
jx:=QWord(m01) shl 1; jy:=QWord(m11) shl 1;
tx[16]:=tx[0] xor jx; ty[16]:=ty[0] xor jy;
tx[17]:=tx[1] xor jx; ty[17]:=ty[1] xor jy;
tx[18]:=tx[2] xor jx; ty[18]:=ty[2] xor jy;
tx[19]:=tx[3] xor jx; ty[19]:=ty[3] xor jy;
tx[20]:=tx[4] xor jx; ty[20]:=ty[4] xor jy;
tx[21]:=tx[5] xor jx; ty[21]:=ty[5] xor jy;
tx[22]:=tx[6] xor jx; ty[22]:=ty[6] xor jy;
tx[23]:=tx[7] xor jx; ty[23]:=ty[7] xor jy;
tx[24]:=tx[8] xor jx; ty[24]:=ty[8] xor jy;
tx[25]:=tx[9] xor jx; ty[25]:=ty[9] xor jy;
tx[26]:=tx[10] xor jx; ty[26]:=ty[10] xor jy;
tx[27]:=tx[11] xor jx; ty[27]:=ty[11] xor jy;
tx[28]:=tx[12] xor jx; ty[28]:=ty[12] xor jy;
tx[29]:=tx[13] xor jx; ty[29]:=ty[13] xor jy;
tx[30]:=tx[14] xor jx; ty[30]:=ty[14] xor jy;
tx[31]:=tx[15] xor jx; ty[31]:=ty[15] xor jy;
jx:=QWord(m01) shl 2; jy:=QWord(m11) shl 2;
tx[32]:=tx[0] xor jx; ty[32]:=ty[0] xor jy;
tx[33]:=tx[1] xor jx; ty[33]:=ty[1] xor jy;
tx[34]:=tx[2] xor jx; ty[34]:=ty[2] xor jy;
tx[35]:=tx[3] xor jx; ty[35]:=ty[3] xor jy;
tx[36]:=tx[4] xor jx; ty[36]:=ty[4] xor jy;
tx[37]:=tx[5] xor jx; ty[37]:=ty[5] xor jy;
tx[38]:=tx[6] xor jx; ty[38]:=ty[6] xor jy;
tx[39]:=tx[7] xor jx; ty[39]:=ty[7] xor jy;
tx[40]:=tx[8] xor jx; ty[40]:=ty[8] xor jy;
tx[41]:=tx[9] xor jx; ty[41]:=ty[9] xor jy;
tx[42]:=tx[10] xor jx; ty[42]:=ty[10] xor jy;
tx[43]:=tx[11] xor jx; ty[43]:=ty[11] xor jy;
tx[44]:=tx[12] xor jx; ty[44]:=ty[12] xor jy;
tx[45]:=tx[13] xor jx; ty[45]:=ty[13] xor jy;
tx[46]:=tx[14] xor jx; ty[46]:=ty[14] xor jy;
tx[47]:=tx[15] xor jx; ty[47]:=ty[15] xor jy;
tx[48]:=tx[16] xor jx; ty[48]:=ty[16] xor jy;
tx[49]:=tx[17] xor jx; ty[49]:=ty[17] xor jy;
tx[50]:=tx[18] xor jx; ty[50]:=ty[18] xor jy;
tx[51]:=tx[19] xor jx; ty[51]:=ty[19] xor jy;
tx[52]:=tx[20] xor jx; ty[52]:=ty[20] xor jy;
tx[53]:=tx[21] xor jx; ty[53]:=ty[21] xor jy;
tx[54]:=tx[22] xor jx; ty[54]:=ty[22] xor jy;
tx[55]:=tx[23] xor jx; ty[55]:=ty[23] xor jy;
tx[56]:=tx[24] xor jx; ty[56]:=ty[24] xor jy;
tx[57]:=tx[25] xor jx; ty[57]:=ty[25] xor jy;
tx[58]:=tx[26] xor jx; ty[58]:=ty[26] xor jy;
tx[59]:=tx[27] xor jx; ty[59]:=ty[27] xor jy;
tx[60]:=tx[28] xor jx; ty[60]:=ty[28] xor jy;
tx[61]:=tx[29] xor jx; ty[61]:=ty[29] xor jy;
tx[62]:=tx[30] xor jx; ty[62]:=ty[30] xor jy;
tx[63]:=tx[31] xor jx; ty[63]:=ty[31] xor jy;
ApplyPair32(r0^,r1^,d0,d1); ApplyPair32(u0^,u1^,du0,du1); ApplyPair32(v0^,v1^,dv0,dv1);
BlockStep64:=true;
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
  if BlockStep64 then continue;
  if BlockStep then continue;
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

{ H91: reuse bounded scratch capacity; each used polynomial is initialized. }
function GcdU(const va,vb:TVec; var vg,vu,vv:TVec; hi:longint):longint;
var a,b,g,u,v:THPolyW; size:longint;
begin
size:=(hi*2+96) shr 5;
if (Length(qPool)<size*128) or (Length(qPool)>(size*128)*4) then SetLength(qPool,size*128); qTop:=0; qPeak:=0;
if (Length(qA)<size) or (Length(qA)>(size)*4) then SetLength(qA,size); if (Length(qB)<size) or (Length(qB)>(size)*4) then SetLength(qB,size); if (Length(qC)<size) or (Length(qC)>(size)*4) then SetLength(qC,size);
if (Length(qR)<size*2) or (Length(qR)>(size*2)*4) then SetLength(qR,size*2); if (Length(qS)<size*2) or (Length(qS)>(size*2)*4) then SetLength(qS,size*2); if (Length(qWork)<size*10) or (Length(qWork)>(size*10)*4) then SetLength(qWork,size*10);
HPWFromVec(va,hi,a); HPWFromVec(vb,hi,b); HPWXGCD(a,b,g,u,v);
HPWToVec(g,vg,hi); HPWToVec(u,vu,hi); HPWToVec(v,vv,hi); GcdU:=g.d;
end;

function LowMask32(bits:longint):LongWord; inline;
begin
if bits<=0 then LowMask32:=0
else if bits>=32 then LowMask32:=$FFFFFFFF
else LowMask32:=(LongWord(1) shl bits)-1;
end;

function Reverse32(x:LongWord):LongWord; inline;
begin
Reverse32:=(LongWord(reverseByte[(x shr 0) and $FF]) shl 24) or (LongWord(reverseByte[(x shr 8) and $FF]) shl 16) or (LongWord(reverseByte[(x shr 16) and $FF]) shl 8) or (LongWord(reverseByte[(x shr 24) and $FF]) shl 0);
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

{ H97: the same fused H-polynomial expansion; the five Boolean
  substitution stages of each leaf run in parallel in a QWord. }
procedure ConvertHW(var a:TWordArray; first,count:longint; inverse:boolean); forward;
function ExpandU32H(value:LongWord):QWord; inline;
var v:QWord;
begin
v:=SpreadBits32(value);
v:=v xor ((v shr 1) and QWord($6666666666666666));
v:=v xor ((v shr 2) and QWord($3C3C3C3C3C3C3C3C));
v:=v xor ((v shr 4) and QWord($0FF00FF00FF00FF0));
v:=v xor ((v shr 8) and QWord($00FFFF0000FFFF00));
v:=v xor ((v shr 16) and QWord($0000FFFFFFFF0000));
ExpandU32H:=v;
end;
procedure ExpandUComboHW(const va,vb:TVec; first,count,degmax,mode:longint;
                         var r:TWordArray; dst0:longint);
var h,g,p,base:longint; a,b,value:QWord; mask:LongWord;
begin
if count=32 then
  begin
  if first<=degmax then
    begin
    mask:=LowMask32(degmax-first+1);
    a:=ExpandU32H(va[first shr 5] and mask); b:=ExpandU32H(vb[first shr 5] and mask);
    end
  else begin a:=0; b:=0; end;
  if mode=0 then value:=(a shl 1) xor b else value:=a xor b xor (b shl 1);
  r[dst0 shr 5]:=LongWord(value); r[(dst0 shr 5)+1]:=LongWord(value shr 32);
  exit;
  end;
h:=32; while (h shl 1)<count do h:=h shl 1;
g:=count-h;
ExpandUComboHW(va,vb,first,h,degmax,mode,r,dst0);
ExpandUComboHW(va,vb,first+h,g,degmax,mode,r,dst0+h*2);
base:=(dst0+h) shr 5;
for p:=0 to (g shr 4)-1 do r[base+p]:=r[base+p] xor r[base+(h shr 5)+p];
end;
procedure BuildUComboHalfKernelW(const va,vb:TVec; degmax,mode:longint;
                                 var r:TWordArray);
var count:longint;
begin
count:=((degmax+32) div 32)*32; if count<32 then count:=32;
SetLength(r,count shr 4);
ExpandUComboHW(va,vb,0,count,degmax,mode,r,0);
ConvertHW(r,0,count*2,false);
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
procedure ApplyUComboOnesW(const va,vb:TVec; var vdst:TVec; hi,degmax,mode:longint);
var halfLen,period,convWords,lastWord,keep,p,w0:longint;
var combo,ha:TWordArray;
var bit0,q0:LongWord;
begin
halfLen:=hi+2;
period:=halfLen shl 1;
convWords:=(halfLen+32) shr 5;
BuildUComboHalfKernelW(va,vb,degmax,mode,combo);
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

{ H95: share the current solve's summed kernel between mak and z. }
var currentSumKernel:TWordArray; currentSumDegree:longint=-1;
procedure ApplyFibonacciOnesW(var dst:TVec; degree:longint);
var kernel:TWordArray;
var p,words,start:longint; bit0,value:LongWord;
begin
words:=(degree+33) shr 5;
BuildFibonacciHalfKernelW(degree,kernel,words,true);
currentSumKernel:=kernel; currentSumDegree:=degree;
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

{ H87: J=I+H, F_(-1)=0, F_0=1, S_d=sum(F_i,0<=i<d).
  Apply F_d(J) or S_d(J) by binary doubling on the reflected cycle.
  F_(2k)=F_k^2+F_(k-1)^2; F_(2k+1)=J*F_k^2.
  For cyclic shift R, J^(2^j)=I+R^(2^j)+R^(-2^j).
  Store one reflected half; the unfolded-cycle endpoints stay zero. }
{ H89: the same Fibonacci shifts; B reads interior word pairs directly,
  retaining reflected-cycle reads only for boundary words. }
procedure ApplyFibonacciFastW(const src:TVec; var dst:TVec; hi,degree:longint; summed:boolean=false);
var a,b,t,tmp,ss,ts:TWordArray;
var half,period,words,mask,shift,p,take,outHi:longint;
var value,last,seed,carry0,carry1:LongWord;
var recover,folded:boolean;
var wordShift,bitShift,innerFirst,innerLast:longint;
procedure MirrorResult;
var p,keep:longint; value:LongWord;
begin
if not folded then exit;
for p:=(outHi+1) shr 5 to hi shr 5 do
  begin
  keep:=outHi+1-p*32; if keep<0 then keep:=0;
  value:=Reverse32(ReadVec32Any(dst,hi-p*32-31));
  dst[p]:=(dst[p] and LowMask32(keep)) or (value and not LowMask32(keep));
  end;
end;
function FirstSum:LongWord;
var kernel:TWordArray; p:longint; seed:LongWord;
begin
seed:=0;
if (currentSumDegree=degree) and ((Length(currentSumKernel) shl 5)>=hi+3) then kernel:=currentSumKernel
else BuildFibonacciHalfKernelW(degree,kernel,(hi+35) shr 5,true);
for p:=0 to hi shr 5 do
  seed:=seed xor (src[p] and (ReadDyn32(kernel,p*32) xor ReadDyn32(kernel,p*32+2)) and LowMask32(hi-p*32+1));
seed:=seed xor (seed shr 16); seed:=seed xor (seed shr 8);
seed:=seed xor (seed shr 4); seed:=seed xor (seed shr 2); seed:=(seed xor (seed shr 1)) and 1;
FirstSum:=seed;
end;
function ReadCycle(const v:TWordArray; pos:longint):LongWord;
var done,take:longint; value,part:LongWord;
begin
if folded then
  begin
  { H97: a whole word inside one reflected segment needs no split loop.
    A already selects these same direct/reflected ranges before its bit loops. }
  if pos+31<=half then begin ReadCycle:=ReadDyn32(v,pos); exit; end;
  if (pos>half) and (pos+31<period) then
    begin ReadCycle:=Reverse32(ReadDyn32(v,period-pos-31)); exit; end;
  done:=0; value:=0;
  while done<32 do
    begin
    if pos<=half then
      begin
      take:=half-pos+1; if take>32-done then take:=32-done;
      part:=ReadDyn32(v,pos) and LowMask32(take);
      end
    else
      begin
      take:=period-pos; if take>32-done then take:=32-done;
      part:=Reverse32(ReadDyn32Any(v,period-pos-take+1)) shr (32-take);
      end;
    value:=value or (part shl done);
    inc(done,take); inc(pos,take); if pos=period then pos:=0;
    end;
  ReadCycle:=value; exit;
  end;
if pos<half then
  begin
  ReadCycle:=ReadDyn32(v,pos);
  if pos+31>half then ReadCycle:=ReadCycle xor Reverse32(ReadDyn32Any(v,period-pos-31));
  end
else
  begin
  ReadCycle:=Reverse32(ReadDyn32Any(v,period-pos-31));
  if pos+31>=period then ReadCycle:=ReadCycle xor ReadDyn32Any(v,pos-period);
  end;
end;
function ReadBoundaryPair(const v:TWordArray; p:longint):LongWord; inline;
var left,right:longint;
begin
  left:=p*32-shift; if left<0 then inc(left,period);
  right:=p*32+shift; if right>=period then dec(right,period);
  ReadBoundaryPair:=ReadCycle(v,left) xor ReadCycle(v,right);
end;
begin
recover:=summed and (degree<=hi+1);
if recover then
  begin
  summed:=false;
  seed:=FirstSum;
  end;
{ H95: reflection-symmetric input has period hi+2, not 2*(hi+2).
  Keep one reflected half of that shorter cycle; use the same test in A/B. }
folded:=true;
for p:=0 to (hi div 2) shr 5 do
  if ((src[p] xor Reverse32(ReadVec32Any(src,hi-p*32-31))) and LowMask32(hi div 2-p*32+1))<>0 then
    begin folded:=false; break; end;
half:=hi+2; period:=half*2;
if folded then begin period:=half; half:=period div 2; end; words:=(half+32) shr 5;
SetLength(a,words+1); SetLength(b,words+1); SetLength(t,words+1);
if summed then begin SetLength(ss,words+1); SetLength(ts,words+1); end;
p:=0;
while (p<=hi) and (p<half) do
  begin
  take:=half-p; if take>hi-p+1 then take:=hi-p+1; if take>32 then take:=32;
  value:=src[p shr 5] and LowMask32(take);
  XorDyn32(a,p+1,value);
  inc(p,take);
  end;
last:=LowMask32(half+1-(words-1)*32);
mask:=1; while mask<=degree div 2 do mask:=mask shl 1;
while mask>0 do
  begin
  shift:=mask mod period; if shift>half then shift:=period-shift;
  wordShift:=shift shr 5; bitShift:=shift and 31;
  { H98: the same reflection ranges as A; interior words need no boundary test. }
  innerFirst:=(shift+31) shr 5; innerLast:=((half-shift+1) shr 5)-1;
  if innerLast<innerFirst then innerLast:=innerFirst-1;
  if summed then
    begin
    { S_(2k)=J*S_k^2+F_(k-1)^2; S_(2k+1)=J*S_k^2+F_k^2. }
    if (degree and mask)<>0 then
    begin
    for p:=0 to innerFirst-1 do begin
      ts[p]:=ss[p] xor ReadBoundaryPair(ss,p) xor a[p];
      end;
    if bitShift=0 then
      for p:=innerFirst to innerLast do begin
      ts[p]:=ss[p] xor (ss[p-wordShift] xor ss[p+wordShift]) xor a[p];
      end
    else
      for p:=innerFirst to innerLast do begin
      ts[p]:=ss[p] xor ((ss[p-wordShift-1] shr (32-bitShift)) xor (ss[p-wordShift] shl bitShift) xor (ss[p+wordShift] shr bitShift) xor (ss[p+wordShift+1] shl (32-bitShift))) xor a[p];
      end;
    for p:=innerLast+1 to words-1 do begin
      ts[p]:=ss[p] xor ReadBoundaryPair(ss,p) xor a[p];
      end;
    end
    else
    begin
    for p:=0 to innerFirst-1 do begin
      ts[p]:=ss[p] xor ReadBoundaryPair(ss,p) xor b[p];
      end;
    if bitShift=0 then
      for p:=innerFirst to innerLast do begin
      ts[p]:=ss[p] xor (ss[p-wordShift] xor ss[p+wordShift]) xor b[p];
      end
    else
      for p:=innerFirst to innerLast do begin
      ts[p]:=ss[p] xor ((ss[p-wordShift-1] shr (32-bitShift)) xor (ss[p-wordShift] shl bitShift) xor (ss[p+wordShift] shr bitShift) xor (ss[p+wordShift+1] shl (32-bitShift))) xor b[p];
      end;
    for p:=innerLast+1 to words-1 do begin
      ts[p]:=ss[p] xor ReadBoundaryPair(ss,p) xor b[p];
      end;
    end;
    ts[words-1]:=ts[words-1] and last;
    tmp:=ss; ss:=ts; ts:=tmp;
    if mask=1 then break;
    end;
  { H95: the final bit needs only F_d, or F_d+F_(d-1) for recovery. }
  if mask=1 then
    begin
    if recover then
      begin
      if (degree and 1)=0 then begin tmp:=a; a:=b; b:=tmp; end;
    begin
    for p:=0 to innerFirst-1 do t[p]:=ReadBoundaryPair(a,p) xor b[p];
    if bitShift=0 then
      for p:=innerFirst to innerLast do t[p]:=(a[p-wordShift] xor a[p+wordShift]) xor b[p]
    else
      for p:=innerFirst to innerLast do t[p]:=((a[p-wordShift-1] shr (32-bitShift)) xor (a[p-wordShift] shl bitShift) xor (a[p+wordShift] shr bitShift) xor (a[p+wordShift+1] shl (32-bitShift))) xor b[p];
    for p:=innerLast+1 to words-1 do t[p]:=ReadBoundaryPair(a,p) xor b[p];
    end;
    t[words-1]:=t[words-1] and last;
      tmp:=a; a:=t; t:=tmp;
      end
    else if (degree and 1)=0 then
      begin for p:=0 to words-1 do a[p]:=a[p] xor b[p]; end
    else
      begin
    begin
    for p:=0 to innerFirst-1 do t[p]:=ReadBoundaryPair(a,p) xor a[p];
    if bitShift=0 then
      for p:=innerFirst to innerLast do t[p]:=(a[p-wordShift] xor a[p+wordShift]) xor a[p]
    else
      for p:=innerFirst to innerLast do t[p]:=((a[p-wordShift-1] shr (32-bitShift)) xor (a[p-wordShift] shl bitShift) xor (a[p+wordShift] shr bitShift) xor (a[p+wordShift+1] shl (32-bitShift))) xor a[p];
    for p:=innerLast+1 to words-1 do t[p]:=ReadBoundaryPair(a,p) xor a[p];
    end;
    t[words-1]:=t[words-1] and last;
      tmp:=a; a:=t; t:=tmp;
      end;
    break;
    end;
  if (degree and mask)<>0 then
    begin
    begin
    for p:=0 to innerFirst-1 do begin
      t[p]:=a[p] xor ReadBoundaryPair(a,p); b[p]:=a[p] xor b[p];
      end;
    if bitShift=0 then
      for p:=innerFirst to innerLast do begin
      t[p]:=a[p] xor (a[p-wordShift] xor a[p+wordShift]); b[p]:=a[p] xor b[p];
      end
    else
      for p:=innerFirst to innerLast do begin
      t[p]:=a[p] xor ((a[p-wordShift-1] shr (32-bitShift)) xor (a[p-wordShift] shl bitShift) xor (a[p+wordShift] shr bitShift) xor (a[p+wordShift+1] shl (32-bitShift))); b[p]:=a[p] xor b[p];
      end;
    for p:=innerLast+1 to words-1 do begin
      t[p]:=a[p] xor ReadBoundaryPair(a,p); b[p]:=a[p] xor b[p];
      end;
    end;
    t[words-1]:=t[words-1] and last;
    tmp:=a; a:=t; t:=tmp;
    end
  else
    begin
    begin
    for p:=0 to innerFirst-1 do begin
      t[p]:=b[p] xor ReadBoundaryPair(b,p); a[p]:=a[p] xor b[p];
      end;
    if bitShift=0 then
      for p:=innerFirst to innerLast do begin
      t[p]:=b[p] xor (b[p-wordShift] xor b[p+wordShift]); a[p]:=a[p] xor b[p];
      end
    else
      for p:=innerFirst to innerLast do begin
      t[p]:=b[p] xor ((b[p-wordShift-1] shr (32-bitShift)) xor (b[p-wordShift] shl bitShift) xor (b[p+wordShift] shr bitShift) xor (b[p+wordShift+1] shl (32-bitShift))); a[p]:=a[p] xor b[p];
      end;
    for p:=innerLast+1 to words-1 do begin
      t[p]:=b[p] xor ReadBoundaryPair(b,p); a[p]:=a[p] xor b[p];
      end;
    end;
    t[words-1]:=t[words-1] and last;
    tmp:=b; b:=t; t:=tmp;
    end;
  mask:=mask shr 1;
  end;
{ H96: recover one symmetric half and mirror it. }
outHi:=hi; if folded then outHi:=hi div 2;
if recover then
  begin
  { H92: the same seed and 32-coefficient prefix for J*S_d. }
  carry0:=seed; carry1:=0;
  for p:=0 to outHi shr 5 do
    begin
    value:=ReadDyn32(a,p*32+1) xor src[p];
    value:=value xor carry0 xor carry1 xor (carry0 shl 1);
    value:=value xor (value shl 1);
    value:=value xor (value shl 3); value:=value xor (value shl 6);
    value:=value xor (value shl 12); value:=value xor (value shl 24);
    dst[p]:=(value shl 1) or carry0;
    carry0:=value shr 31; carry1:=(value shr 30) and 1;
    end;
  MirrorResult;
  MaskDeg(dst,hi);
  exit;
  end;
if summed then a:=ss;
VecZero(dst);
for p:=0 to outHi shr 5 do
  dst[p]:=ReadDyn32(a,p*32+1);
MirrorResult;
MaskDeg(dst,hi);
end;

{ H87: mode 2 uses Fibonacci shifts; modes 0/1 use the supplied coefficients. }
procedure ApplyFastUComboW(const va,vb,vsrc:TVec; var vdst:TVec; hi,degmax,mode:longint);
var halfLen,period,convWords,lastWord:longint;
var w0,keep,srcBits,lastSrcWord,targetBit,startP:longint;
var q0,bit0:LongWord;
var combo,ha,hb,hbr,prod0:TWordArray;
var sameSource:boolean;
begin
if mode=2 then begin ApplyFibonacciFastW(vsrc,vdst,hi,hi+1); exit; end;
halfLen:=hi+2;
period:=halfLen shl 1;
convWords:=(halfLen+32) shr 5;
SetLength(ha,convWords); SetLength(hb,convWords);
BuildUComboHalfKernelW(va,vb,degmax,mode,combo);
AddHalfCircularKernelW(ha,combo,period,halfLen);
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

{ H88: detect g(U)=U^a*(U+1)^b from all its coefficients.
  U=t^(-2)*(1+t)*(1+t^3), U+1=t^(-2)*(1+t^5)/(1+t).
  The reciprocal kernel is (1+t)^(b-a)/((1+t^3)^a*(1+t^5)^b).
  Frobenius reduces each power to binomial shifts; no n-based table. }
function TrySolveXShift(const vg,rhs:TVec; var dst:TVec; degreeU,len:longint):boolean;
var rem:TVec;
var p,aa,bb,k,shift:longint;
{ H98: fixed shift stages and a register carry implement the same prefix
  XOR as A. Whole-word offsets are computed once per binomial factor. }
procedure DivideBinomial(gap:longint);
var j,ws,bs,last:longint; v,carry:LongWord;
begin
if gap>=len then exit;
last:=(len-1) shr 5;
if gap<32 then
  begin
  carry:=0;
  if gap>=16 then
    for j:=0 to last do
      begin
      v:=rem[j] xor carry;
      v:=v xor (v shl gap);
      rem[j]:=v; carry:=v shr (32-gap);
      end
  else if gap>=8 then
    for j:=0 to last do
      begin
      v:=rem[j] xor carry;
      v:=v xor (v shl gap);
      v:=v xor (v shl (gap shl 1));
      rem[j]:=v; carry:=v shr (32-gap);
      end
  else if gap>=4 then
    for j:=0 to last do
      begin
      v:=rem[j] xor carry;
      v:=v xor (v shl gap);
      v:=v xor (v shl (gap shl 1));
      v:=v xor (v shl (gap shl 2));
      rem[j]:=v; carry:=v shr (32-gap);
      end
  else if gap>=2 then
    for j:=0 to last do
      begin
      v:=rem[j] xor carry;
      v:=v xor (v shl gap);
      v:=v xor (v shl (gap shl 1));
      v:=v xor (v shl (gap shl 2));
      v:=v xor (v shl (gap shl 3));
      rem[j]:=v; carry:=v shr (32-gap);
      end
  else if gap>=1 then
    for j:=0 to last do
      begin
      v:=rem[j] xor carry;
      v:=v xor (v shl gap);
      v:=v xor (v shl (gap shl 1));
      v:=v xor (v shl (gap shl 2));
      v:=v xor (v shl (gap shl 3));
      v:=v xor (v shl (gap shl 4));
      rem[j]:=v; carry:=v shr (32-gap);
      end;
  end
else
  begin
  ws:=gap shr 5; bs:=gap and 31;
  if bs=0 then
    for j:=ws to last do rem[j]:=rem[j] xor rem[j-ws]
  else
    begin
    rem[ws]:=rem[ws] xor (rem[0] shl bs);
    for j:=ws+1 to last do
      rem[j]:=rem[j] xor (rem[j-ws] shl bs) xor (rem[j-ws-1] shr (32-bs));
    end;
  end;
end;
procedure MultiplyBinomial(gap:longint);
var j,ws,bs,last:longint;
begin
if gap>=len then exit;
ws:=gap shr 5; bs:=gap and 31; last:=(len-1) shr 5;
if bs=0 then
  for j:=last downto ws do rem[j]:=rem[j] xor rem[j-ws]
else
  begin
  for j:=last downto ws+1 do
    rem[j]:=rem[j] xor (rem[j-ws] shl bs) xor (rem[j-ws-1] shr (32-bs));
  rem[ws]:=rem[ws] xor (rem[0] shl bs);
  end;
end;

begin
TrySolveXShift:=false;
aa:=degreeU;
for p:=0 to degreeU do if GetBit(vg,p)<>0 then begin aa:=p; break; end;
bb:=degreeU-aa;
for p:=aa to degreeU do
  if (GetBit(vg,p)<>0)<>(((p-aa) and bb)=(p-aa)) then exit;
for p:=0 to (len-1) shr 5 do rem[p]:=ReverseWord32(ReadVec32Any(rhs,longint(n)-32-p*32));
rem[(len-1) shr 5]:=rem[(len-1) shr 5] and LowMask32(((len-1) and 31)+1);
k:=abs(bb-aa); shift:=1;
while k>0 do
  begin
  if (k and 1)<>0 then
    if bb>=aa then MultiplyBinomial(shift) else DivideBinomial(shift);
  k:=k shr 1; shift:=shift shl 1;
  end;
k:=aa; shift:=3;
while k>0 do
  begin
  if (k and 1)<>0 then DivideBinomial(shift);
  k:=k shr 1; shift:=shift shl 1;
  end;
k:=bb; shift:=5;
while k>0 do
  begin
  if (k and 1)<>0 then DivideBinomial(shift);
  k:=k shr 1; shift:=shift shl 1;
  end;
for p:=0 to (len-1) shr 5 do dst[p]:=ReverseWord32(ReadVec32Any(rem,len-32-p*32));
MaskDeg(dst,len-1);
TrySolveXShift:=true;
end;

procedure SolveXFast(const vg,rhs:TVec; var dst:TVec; degreeU:longint);
var smallG:TVec;
var kernel:TWordArray;
var tables:array of TFixedMulTable;
var quotWord:LongWord; product:QWord;
var den,iv,rem,answer:THPolyW;
var d,len,center,dl,blockLen,size,pos,k,j0,lim,off,words:longint;
var stride,fullLen,residue,mask,j1,index,take,shift0:longint;
var splitInput,splitAnswer:TVec;
var value:LongWord;
function Compress(value:LongWord):LongWord; inline;
begin
case stride of
2:value:=CompactEven32(value);
4:begin
  value:=value and $11111111;
  value:=(value or (value shr 3)) and $03030303;
  value:=(value or (value shr 6)) and $000F000F;
  value:=(value or (value shr 12)) and $000000FF;
  end;
8:begin
  value:=value and $01010101;
  value:=(value or (value shr 7)) and $00030003;
  value:=(value or (value shr 14)) and $0000000F;
  end;
16:begin value:=value and $00010001; value:=(value or (value shr 15)) and 3; end;
else value:=value and 1;
end;
Compress:=value;
end;
function Expand(value:LongWord):LongWord; inline;
begin
case stride of
2:value:=LongWord(SpreadBits32(value and $FFFF));
4:begin
  value:=value and $FF;
  value:=(value or (value shl 12)) and $000F000F;
  value:=(value or (value shl 6)) and $03030303;
  value:=(value or (value shl 3)) and $11111111;
  end;
8:begin
  value:=value and $F;
  value:=(value or (value shl 14)) and $00030003;
  value:=(value or (value shl 7)) and $01010101;
  end;
16:begin value:=value and 3; value:=(value or (value shl 15)) and $00010001; end;
else value:=value and 1;
end;
Expand:=value;
end;

begin
d:=degreeU*2; len:=longint(n)-d;
VecZero(dst);
if len<=0 then exit;
if TrySolveXShift(vg,rhs,dst,degreeU,len) then exit;
{ H90: g(U)=h(U^stride), with stride a power of two. Build only the
  kernel of h, then divide the independent residue streams by that kernel. }
mask:=0;
for j0:=0 to degreeU do if GetBit(vg,j0)<>0 then mask:=mask or j0;
stride:=1;
if mask<>0 then while (mask and stride)=0 do stride:=stride shl 1;
{ A divisor that already fits one leaf gains no shorter multiplication. }
if (d*2<32) or (len<=32) then stride:=1;
fullLen:=len; len:=(fullLen+stride-1) div stride;
if stride>1 then
  begin
  VecZero(splitInput); VecZero(splitAnswer);
  for j0:=0 to (fullLen-1) shr 5 do
    splitInput[j0]:=ReverseWord32(ReadVec32Any(rhs,longint(n)-32-(j0 shl 5)));
  MaskDeg(splitInput,fullLen-1);
  end;
take:=32 div stride; if take<1 then take:=1;

d:=d div stride;
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
if stride=1 then
  BuildUKernelFastW(vg,degreeU,kernel,center)
else
  begin
  VecZero(smallG);
  for j0:=0 to degreeU div stride do
    if GetBit(vg,j0*stride)<>0 then
      smallG[j0 shr 5]:=smallG[j0 shr 5] or (LongWord(1) shl (j0 and 31));
  BuildUKernelFastW(smallG,degreeU div stride,kernel,center);
  end;
HPWAlloc(den,(dl+31) shr 5);
for j0:=0 to den.cap-1 do den.v^[j0]:=ReadDyn32(kernel,center-d+(j0 shl 5));
den.v^[den.cap-1]:=den.v^[den.cap-1] and HPWMask(((dl-1) and 31)+1);
den.d:=dl-1; HPWNorm(den);
HPWAlloc(rem,(len+31) shr 5);

k:=blockLen; if k>len then k:=len;
HPWInvSeries(den,k,iv);
if blockLen=32 then
  begin
  SetLength(tables,den.cap+1);
  PrepareFixedMul(iv.v^[0],tables[0]);
  for j0:=0 to den.cap-1 do PrepareFixedMul(den.v^[j0],tables[j0+1]);
  end;
for residue:=0 to stride-1 do
begin
len:=(fullLen-1-residue) div stride+1;
if residue>=fullLen then break;
rem.cap:=(len+31) shr 5;
if stride=1 then
  begin
for j0:=0 to rem.cap-1 do
  rem.v^[j0]:=ReverseWord32(ReadVec32Any(rhs,longint(n)-32-(j0 shl 5)));
rem.v^[rem.cap-1]:=rem.v^[rem.cap-1] and HPWMask(((len-1) and 31)+1);
rem.d:=len-1;
  end
else
  begin
  for j0:=0 to rem.cap-1 do
    begin
    value:=0; shift0:=0;
    while shift0<32 do
      begin
      index:=residue+(j0*32+shift0)*stride;
      if index>=fullLen then break;
      value:=value or (Compress(splitInput[index shr 5] shr (index and 31)) shl shift0);
      inc(shift0,take);
      end;
    rem.v^[j0]:=value;
    end;
  rem.v^[rem.cap-1]:=rem.v^[rem.cap-1] and HPWMask(((len-1) and 31)+1);
  rem.d:=len-1;
  end;
pos:=0;
{ The same fixed 32-coefficient multiplication leaf is fused in A/B. }
if blockLen=32 then
  begin

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
if stride=1 then
  begin
HPWReverseAt(rem,len-1,len,answer);
HPWToVec(answer,dst,len-1);
  end
else
  begin
  j1:=0;
  while j1<len do
    begin
    index:=residue+j1*stride;
    value:=Expand(rem.v^[j1 shr 5] shr (j1 and 31)) shl (index and 31);
    splitAnswer[index shr 5]:=splitAnswer[index shr 5] or value;
    inc(j1,take);
    end;
  end;
end;
if stride>1 then
  begin
  for j0:=0 to (fullLen-1) shr 5 do
    dst[j0]:=ReverseWord32(ReadVec32Any(splitAnswer,fullLen-32-(j0 shl 5)));
  MaskDeg(dst,fullLen-1);
  end;
qTop:=0;
end;

procedure CalcMat2;
var gu,qu,qv:TVec;
var sa,sb,hu,su,sv:TVec;
var z:TVec;
var r0,rU:longint;
var m2,hiS,rr:longint;
var ag,au,av:QWord;
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
  { H89: gu=hu(t^2), qu=su(t^2), qv=t*su(t^2)+sv(t^2). }
  for i:=0 to hiS shr 5 do
    begin
    ag:=SpreadBits32(hu[i]); au:=SpreadBits32(su[i]); av:=SpreadBits32(sv[i]) xor (au shl 1);
    gu[2*i]:=LongWord(ag); gu[2*i+1]:=LongWord(ag shr 32);
    qu[2*i]:=LongWord(au); qu[2*i+1]:=LongWord(au shr 32);
    qv[2*i]:=LongWord(av); qv[2*i+1]:=LongWord(av shr 32);
    end;
  MaskDeg(gu,m2); MaskDeg(qu,m2); MaskDeg(qv,m2);
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
{ H87: P(H)*S_n(I+H)*1 = S_n(I+H)*P(H)*1. }
ApplyUComboOnesW(qu,qv,z,n-1,longint(n div 2),0);
ApplyFibonacciFastW(z,z,n-1,longint(n),true);
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
