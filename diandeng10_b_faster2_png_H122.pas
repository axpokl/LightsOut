{ H122: logarithmic coefficient windows accelerate short Dickson certificates.
  For an eligible even core m=nn+1 nearest to 2^k, t=abs(m-2^k)>=3,
  the GCD and canonical Bezout pair take O(nn*(1+t/k^2)) on the
  logarithmic-word, unit-lookup model. The window schedule admits
  t^2<=16*k^5 above nn=10000. General native spectral jets evaluate on
  odd multiplicative subgroups of GF(2^16), with a fixed torus-257
  kernel. Within the supported jet range M(s)=O(s log s) field work
  and general half-GCD is O(n log^2 n). Larger scalable products retain
  the H120 route. Both coefficient representations use identical cuts. }
{ H121: short Dickson certificates for near-power extended GCD.
  Balanced binomial Taylor conversion and fused jet matrix products
  accelerate the general spectral half-GCD and polynomial division.
  With t<=4*sqrt(log2(nn+1)) the certificate branch uses
  O(nn*(1+t)) binary coefficient operations and O(nn) space.
  A and B run the same exact formulas in Boolean and LongWord storage. }
{ H120: diandeng [first [last [auto|mix|karatsuba|toom|fft|ntt|additive|spectral|spectral-dft]]].
  Auto/mix use Karatsuba, Toom-3, ternary ring FFT, integer NTT, then
  exact spectral products. The final tier starts at n=1048576. Within
  it, GF(2^16) jets use five-gate ternary checks up to 2097152 input
  coefficients. The two check sums recover four disjoint error supports
  directly. Larger products fuse ternary levels into cyclic Fourier circuits.
  Forced spectral switches at 131072 coefficients. spectral-dft keeps the
  two-axis chirp/repair path for comparison. Structured solves take priority.
  The scalable word-RAM model allows logarithmic-width indices and unit
  table access. At length s, pack Theta(log s) bits per block. If the ring
  length is 3^e, the grouped FFT costs O(e/(log e)^(1/2-eps)) per block
  using The Fourier Exponent (Theorem 1.1, 24 Nov 2026); summing the
  ring-product recursion gives O(s*(log log s)^(1/2+eps)), 0<eps<1/2.
  Large radices are built by exact finite search, charged to this bound.
  Win32 reaches radix nine, implemented by an explicit 30-gate circuit.
  Laurent composition and the independent reflected Fibonacci residual
  take O(n) in logarithmic windows; the general half-GCD retains log n.
  The g timer covers generation and comparison together. A_out writes
  its diagnostic vectors and checks the board by direct row chasing. }
{ Performance repair: H115/H116 table-driven reflection and seven-product
  trials are withdrawn. These versions use the same H114 solver kernel,
  with strict Boolean A / packed B formulas and unchanged validation.
  g stays at validation ENTRY; its elapsed time is appended after gen
  in the SAME g field. No e label, no cross-row or shifted x/gen time.
  Existing compilation fixes, backend comparison modes and CRLF remain. }
{ H114: share additive-FFT forward images in paired products; fuse
  matrix products in the frequency domain before inverse conversion.
  H113 residue-class Taylor/Pascal conversion is retained. Restore exact
  integer NTT and split-root paths from H112. A/B use the same formulas,
  logical cutoffs and guards; A arithmetic data is strictly Boolean.
  Fixed-prime Montgomery constants use shifts/adds instead of two word
  multiplications. A gathers Boolean byte-product indices directly;
  Pascal blocks use the same linear XOR network in both representations.
  Matrix batching uses actual product lengths and a shared length-based
  cost guard, avoiding padded transforms for simple/unbalanced inputs.
  Fixed comparison programs disable size-specific solve shortcuts and
  select exactly one general multiplication backend above fixed leaves.
  These changes reduce repeated work; no new general asymptotic bound
  below O(M(n)*log(n)) is asserted. See H114_README.md. }
{ H112 field-product idea retained: nine small carryless-table reads
  implement the same exact 32-bit field product in A/B. H114 stores every
  table/result bit as Boolean in A. A fixed 32-bit implementation and a
  variable-word theoretical family have different cost models; this file
  does not assert an unbounded word-width asymptotic improvement. }

//{$define disp}
program diandeng;
{$mode objfpc}{$H+}
{$ifdef MSWINDOWS}{$MAXSTACKSIZE 16777216}{$endif}

{ H111: packed binary multiplication via an additive FFT in GF(2^32).
  Sixteen bits per field coefficient; exact novel-basis conversion
  for every transform dimension. Ordinary word multiplications with
  holes replace a hardware carryless-multiply requirement.
  Backend 5 covers general large inputs, including matrix products;
  it does not rely on a split-root condition on the board size.
  The half-gcd recursion and canonical solution remain unchanged.
  See the operation bound with explicit word width in the report;
  fixed-width range limits are not an unbounded bit-complexity claim. }

{ H110: norm-one torus roots for the additional split condition
  nn+1 divides 2^k+1, with quotient at most 17. A certified trace
  seed generates the required roots by a three-term recurrence,
  entirely inside GF(2^k), without a GF(2^(2k)) table or a search.
  The same recurrence replaces the O(Q*k) root scan for nn=Q;
  its original trace scan remains available if certification fails.
  The existing FWHT/IFFT, exact NTT and canonical Bezout recovery
  then give O(nn log nn) on these eligible D-family cores, in
  H106's given-field/word-RAM/supported-NTT model. General inputs
  retain half-gcd and its O(n log^2(n)) supported-NTT bound.
  The new proper-divisor path is experimental and disabled by
  default: its larger ambient field can be slower than half-gcd.
  A/B use the same roots and guards; A_out keeps its board chase. }

{ H109: identical formulas, coefficient thresholds and canonical solutions.
  Reuse the 160-coefficient leaf inputs, retaining fourteen products;
  A caches only its existing eight-bit table indices and Boolean outputs,
  B caches the corresponding five LongWord input blocks.
  Remove unreachable historical procedures and unconsumed pool-peak tracking.
  All display paths, exact fallbacks and validation remain available.
  Complexity, timing protocol and default ranges are unchanged. }

{ H108: reflected residue blocks for the bounded odd part of n+1.
  All odd b<=31 in n+1=b*2^a now have a linear first-row core,
  including singular families with the original canonical support.
  Solve P(H^(2^a))*x=J*y in constant-size cycle blocks, then impose
  the exact first coordinate of F_n(J)*x=y to recover a possible
  lost J-kernel condition. Old G/U/V and singular diagnostics remain.
  This extends special infinite families; the general worst bound
  and all supported-NTT qualifications of H107 are unchanged. }

{ H107: linear first-row solve on n+1=b*2^a, b<=31 odd,
  when gcd(t*F_(b-1)(t),(t+1)*F_(b-1)(t+1))=1.
  A constant-size Euclid computes and certifies Q*P=1 mod t*F.
  Then x=J*Q(H^(2^a))*y; verification tests P(H^(2^a))*x=J*y.
  Reflected shifts apply H^(2^a) in O(n), with no field tables
  or fixed-modulus NTT restriction. These unique-solution families
  have Theta(n) first-row cost including construction and validation.
  The general worst-case bound is unchanged. A_out retains all
  Bezout diagnostics and its independent O(n^2) board validation. }

{ H106: small-subfield bit-plane basis conversion.
  For N=2^k, c=oddpart(k) in 1,3,5, sparse conversion uses
  O(N + (N/w)*k^log2(3)) word operations, with w-bit planes.
  Thus w>=k gives O(N log N) for the whole split-root gcd,
  on H104's same eligible families and supported-NTT model.
  This Win32 implementation uses w=32 and k<=20. The general
  gcd remains O(M(n) log n). This is NOT a bit-complexity claim.
  H105 conversion is retained for coefficients outside GF(2^c). }

{ Root sets, FWHT, additive IFFT and canonical Bezout recovery
  retain H104's construction. Its old sparse conversion has now
  been replaced by H106's packed version; H105 is only a fallback.
  Eligibility remains k in 2,3,4,5,6,8,10,12,16,20;
  nn=2^k, or nn+1 divides 2^k-1 with quotient at most 17. }

{ H103: for n=2^k-1, the path adjacency H has H^n=0.
  J=I+H satisfies J^(n+1)=I and F_n(J)=J^n=J^(-1).
  Thus the UNIQUE first row is x=J*y. Build y in O(n), apply J
  in O(n), and verify through a linear tridiagonal inverse of J.
  The entire first-row core is O(n) on this infinite size family.
  General sizes retain H102 and its bounds; this is NOT a general
  O(n log n) gcd algorithm. A_out retains its diagnostic Bezout data
  and independent O(n^2) board chase, outside the first-row core. }

{ H101: large binary products use an exact radix-two integer NTT.
  Within transform length 2^27: M(N)=O(N log N) word operations,
  hence the first-row core is O(n log^2(n)) in that supported model.
  The fixed modulus is not an unbounded bit-complexity improvement:
  beyond its range the H100 FFT and bound are retained.
  A/B use identical transforms, thresholds, and GF(2) results. }

{ H100: GF(2) Toom-4 with seven recursive products and exact linear
  interpolation. Pure Toom-4 has exponent log_4(7); this hybrid uses it
  selectively because interpolation overhead can outweigh the saved products.
  A keeps Boolean coefficients; B packs the same operations into LongWord.
  Large products retain H99 FFT, so the unrestricted first-row bound stays
  O(n log^2(n) log log(n)) time and O(n) space. }

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
const m=1250000;
{$endif}

const wb=32;
const mw=(m+wb-1)div wb;

type TVec=array[-2..mw]of LongWord;
     PVec=^TVec;
     TWordArray=array of LongWord;
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

{ H102: same board-size dispatch in A/B. Force modes are used only
  by the four comparison programs. Mode 0 retains the small hybrid;
  1=Karatsuba, 2=exact ring FFT, 3=integer NTT, 4=fused matrix NTT.
  The fusion changes constants, not the half-GCD asymptotic bound. }
var h114FixedComparison:boolean=false;
var h102Force:longint=0;
var h102Backend:longint;
var h119AllDFT:boolean=false;
const h119KarLast=10000;
const h119ToomLast=262143;
const h119FftLast=524287;
const h119NttLast=1048575;

{ Small coefficient arrays are Boolean in both versions; the large
  vector representation remains Boolean in A and packed in B. }
type TH107Small=array[0..63] of boolean;
var h107P,h107Q:TH107Small;
var h107PDeg,h107QDeg,h107Step:longint;
var h107Ready:boolean;
var h108Ready:boolean;
var h108B,h108Length:longint;
var h107Work:array[0..1] of TVec;

function H107Degree(const a:TH107Small):longint;
var j:longint;
begin
j:=High(a); while (j>=0) and not a[j] do dec(j);
H107Degree:=j;
end;

procedure H107Prepare;
var f0,f1,f2,ra,rb,ua,ub,tmp,cert:TH107Small;
var b,j,k,shift,da,db:longint;
begin
if h114FixedComparison then begin h107Ready:=false; exit; end;
h107Ready:=false;
if (n=0) or (n>=LongWord(High(longint) div 2-1)) then exit;
b:=longint(n)+1; h107Step:=1;
while (b and 1)=0 do begin b:=b div 2; h107Step:=h107Step*2; end;
{ b=1 already has the H103 path. No answer or inverse table is stored. }
if (b<=1) or (b>31) or (b mod 3=0) then exit;
FillChar(f0,SizeOf(f0),0); FillChar(f1,SizeOf(f1),0); f1[0]:=true;
for j:=1 to b-1 do
  begin
  f2[0]:=f0[0];
  for k:=1 to High(f2) do f2[k]:=f0[k] xor f1[k-1];
  f0:=f1; f1:=f2;
  end;
{ P=(t+1)*F_(b-1)(t+1), M=t*F_(b-1)(t). }
FillChar(h107P,SizeOf(h107P),0);
for j:=b-1 downto 0 do
  begin
  for k:=High(h107P) downto 1 do h107P[k]:=h107P[k] xor h107P[k-1];
  h107P[0]:=h107P[0] xor f1[j];
  end;
for k:=High(h107P) downto 1 do h107P[k]:=h107P[k] xor h107P[k-1];
FillChar(ra,SizeOf(ra),0);
for k:=1 to b do ra[k]:=f1[k-1];
rb:=h107P;
FillChar(ua,SizeOf(ua),0); FillChar(ub,SizeOf(ub),0); ub[0]:=true;
{ Extended Euclid by exact leading-term cancellation. }
while H107Degree(rb)>=0 do
  begin
  da:=H107Degree(ra); db:=H107Degree(rb);
  if da<db then
    begin tmp:=ra; ra:=rb; rb:=tmp; tmp:=ua; ua:=ub; ub:=tmp; shift:=db-da; end
  else shift:=da-db;
  if H107Degree(rb)<0 then break;
  for k:=0 to High(ra)-shift do
    begin ra[k+shift]:=ra[k+shift] xor rb[k]; ua[k+shift]:=ua[k+shift] xor ub[k]; end;
  end;
if (H107Degree(ra)<>0) or not ra[0] then exit;
h107Q:=ua;
{ Normalize Q modulo M, then independently certify the short inverse. }
j:=H107Degree(h107Q);
while j>=b do
  begin
  for k:=0 to b-1 do h107Q[j-b+k+1]:=h107Q[j-b+k+1] xor f1[k];
  j:=H107Degree(h107Q);
  end;
h107PDeg:=H107Degree(h107P); h107QDeg:=H107Degree(h107Q);
FillChar(cert,SizeOf(cert),0);
for j:=0 to h107PDeg do if h107P[j] then
  for k:=0 to h107QDeg do cert[j+k]:=cert[j+k] xor h107Q[k];
j:=H107Degree(cert);
while j>=b do
  begin
  for k:=0 to b-1 do cert[j-b+k+1]:=cert[j-b+k+1] xor f1[k];
  j:=H107Degree(cert);
  end;
h107Ready:=(H107Degree(cert)=0) and cert[0];
end;

procedure H108Prepare; forward;

function H103Dyadic:boolean; inline;
begin
if h114FixedComparison then begin H103Dyadic:=false; exit; end;
H103Dyadic:=(n>0) and ((n and (n+1))=0);
end;

procedure H102Select;
begin
if h102Force<>0 then h102Backend:=h102Force
else if n<=h119KarLast then h102Backend:=1
else if n<=h119ToomLast then h102Backend:=6
else if n<=h119FftLast then h102Backend:=2
else if n<=h119NttLast then h102Backend:=4
else h102Backend:=7;
end;

function H102Max(a,b:longint):longint; inline;
begin if a>b then H102Max:=a else H102Max:=b; end;

{ Shared operand-length rule for scalar products and fused matrices. }
function H118TransformCut(originalCut:longint):longint; inline;
begin
if h102Force<>0 then H118TransformCut:=256
else if h102Backend=6 then H118TransformCut:=2048
else if h102Backend in [2,3,4,5,7] then H118TransformCut:=32768
else H118TransformCut:=originalCut;
end;

function H102Transform(a,b,originalCut:longint):boolean; inline;
begin
if h102Backend=1 then H102Transform:=false
else
  begin
  originalCut:=H118TransformCut(originalCut);
  H102Transform:=(a>originalCut) or (b>originalCut);
  end;
end;

function H102RingCut(originalCut:longint):longint; inline;
begin
if h102Force<>0 then H102RingCut:=512 else H102RingCut:=H118TransformCut(originalCut);
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
  write(' ',ms:7:3,#9,ch);
end;

{ g is a START label, like m/q/z/x. Complete its numeric field on the
  SAME line after ALL validation work. There is no separate e column. }
procedure FinishGenTiming;
var counter:Int64; ms:Double;
begin
QueryPerformanceCounter(counter);
ms:=(counter-lastCounter)*1000.0/perfFreq;
lastCounter:=counter;
write(' ',ms:7:3,#9);
end;


function DegMask(deg:longint):LongWord;
var rem:longint;
begin
rem:=deg and 31;
if rem=31 then DegMask:=$FFFFFFFF
else DegMask:=(LongWord(1) shl (rem+1))-1;
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
H102Select;
H107Prepare;
H108Prepare;
if not warming then TimeMark('m');
if not (H103Dyadic or h107Ready) then BuildFCPairsIterW(n,f,c,f1,c1,hf,hc,hf1,hc1);
ApplyFibonacciOnesW(y,longint(n));
end;

function HighBit32(x:LongWord):longint; inline;
begin
if x=0 then HighBit32:=-1 else HighBit32:=BsrDWord(x);
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
var a0,a1,a2,a3,a4,b0,b1,b2,b3,b4:LongWord;
var t0,t1,t2,t3,t4:QWord;
begin
{ Cache the same five coefficient blocks as A. }
a0:=a[ao+0]; b0:=b[bo+0];
a1:=a[ao+1]; b1:=b[bo+1];
a2:=a[ao+2]; b2:=b[bo+2];
a3:=a[ao+3]; b3:=b[bo+3];
a4:=a[ao+4]; b4:=b[bo+4];
ax:=a0; bx:=b0;
e0:=0; if (ax<>0) and (bx<>0) then e0:=CLMul32(ax,bx);
ax:=a1; bx:=b1;
e2:=0; if (ax<>0) and (bx<>0) then e2:=CLMul32(ax,bx);
ax:=a0 xor a1; bx:=b0 xor b1;
e1:=0; if (ax<>0) and (bx<>0) then e1:=CLMul32(ax,bx);
ax:=a2; bx:=b2;
f0:=0; if (ax<>0) and (bx<>0) then f0:=CLMul32(ax,bx);
ax:=a3; bx:=b3;
f1:=0; if (ax<>0) and (bx<>0) then f1:=CLMul32(ax,bx);
ax:=a4; bx:=b4;
f2:=0; if (ax<>0) and (bx<>0) then f2:=CLMul32(ax,bx);
ax:=a2 xor a3; bx:=b2 xor b3;
f01:=0; if (ax<>0) and (bx<>0) then f01:=CLMul32(ax,bx);
ax:=a2 xor a4; bx:=b2 xor b4;
f02:=0; if (ax<>0) and (bx<>0) then f02:=CLMul32(ax,bx);
ax:=a3 xor a4; bx:=b3 xor b4;
f12:=0; if (ax<>0) and (bx<>0) then f12:=CLMul32(ax,bx);
ax0:=a0 xor a2; bx0:=b0 xor b2;
g0:=0; if (ax0<>0) and (bx0<>0) then g0:=CLMul32(ax0,bx0);
ax1:=a1 xor a3; bx1:=b1 xor b3;
g1:=0; if (ax1<>0) and (bx1<>0) then g1:=CLMul32(ax1,bx1);
ax:=ax0 xor ax1; bx:=bx0 xor bx1;
g01:=0; if (ax<>0) and (bx<>0) then g01:=CLMul32(ax,bx);
ax:=ax0 xor a4; bx:=bx0 xor b4;
g02:=0; if (ax<>0) and (bx<>0) then g02:=CLMul32(ax,bx);
ax:=ax1 xor a4; bx:=bx1 xor b4;
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

{ H101: exact binary convolution through an integer NTT.
  p=15*2^27+1, primitive root 31. For L<=2^27, every integer
  coefficient is <=min(alen,blen)<p, so reduction loses no carry
  information; taking its low bit gives the exact GF(2) product.
  Each residue stores ONE coefficient: A is not bit-packed here.
  M(L)=O(L log L) word operations within this supported range.
  The unrestricted H100 FFT remains available beyond that range. }
const nttMod=LongWord(2013265921);
const nttZero=LongWord(0);
const nttRoot=LongWord(31);
const nttMaxLen=134217728;
const nttOne=LongWord(268435454);
type TNTTArray=array of LongWord;
var nttRoots,nttInvRoots:TNTTArray;
var nttRootLength:longint;

function H114UInt32Product(a,b:LongWord):QWord; inline;
begin H114UInt32Product:=QWord(a)*b; end;
function NTTMul(a,b:LongWord):LongWord; inline;
var t:QWord; u,v:LongWord;
begin
if (a=nttZero) or (b=nttZero) then begin NTTMul:=nttZero; exit; end;
if b=nttOne then begin NTTMul:=a; exit; end;
if a=nttOne then begin NTTMul:=b; exit; end;
t:=H114UInt32Product(a,b);
{ -p^(-1)=15*2^27-1 mod 2^32, p=15*2^27+1. }
u:=LongWord((LongWord(t) shl 31)-(LongWord(t) shl 27)-LongWord(t));
{ t+u+u*2^31-u*2^27 < 2^64 since a,b<p<2^31. }
t:=t+QWord(u)+(QWord(u) shl 31)-(QWord(u) shl 27);
v:=LongWord(t shr 32);
if v>=nttMod then dec(v,nttMod);
NTTMul:=v;
end;

function NTTPow(a,e:LongWord):LongWord;
var r:LongWord;
begin
r:=1;
while e<>0 do
  begin
  if (e and 1)<>0 then r:=LongWord(H114UInt32Product(r,a) mod nttMod);
  a:=LongWord(H114UInt32Product(a,a) mod nttMod); e:=e shr 1;
  end;
NTTPow:=r;
end;

procedure NTTPrepare(count:longint);
var root,invRoot:LongWord; j:longint;
begin
if count<=nttRootLength then exit;
root:=NTTPow(nttRoot,(nttMod-1) div LongWord(count));
invRoot:=NTTPow(root,nttMod-2);
root:=LongWord(H114UInt32Product(root,nttOne) mod nttMod);
invRoot:=LongWord(H114UInt32Product(invRoot,nttOne) mod nttMod);
SetLength(nttRoots,count div 2); SetLength(nttInvRoots,count div 2);
nttRoots[0]:=nttOne; nttInvRoots[0]:=nttOne;
for j:=1 to count div 2-1 do
  begin
  nttRoots[j]:=NTTMul(nttRoots[j-1],root);
  nttInvRoots[j]:=NTTMul(nttInvRoots[j-1],invRoot);
  end;
nttRootLength:=count;
end;

procedure NTTForward(var a:TNTTArray; count:longint);
var span,half,base,j,stride,k:longint; u,v,s,d:LongWord;
begin
{ DIF leaves the frequencies in bit-reversed order. }
span:=count;
while span>1 do
  begin
  half:=span div 2; stride:=nttRootLength div span; base:=0;
  while base<count do
    begin
    k:=0;
    for j:=0 to half-1 do
      begin
      u:=a[base+j]; v:=a[base+j+half];
      s:=u+v; if s>=nttMod then dec(s,nttMod);
      if u>=v then d:=u-v else d:=u+nttMod-v;
      a[base+j]:=s; a[base+j+half]:=NTTMul(d,nttRoots[k]);
      inc(k,stride);
      end;
    inc(base,span);
    end;
  span:=half;
  end;
end;

procedure NTTInverse(var a:TNTTArray; count:longint);
var span,half,base,j,stride,k:longint; u,v,s,d:LongWord;
begin
{ DIT consumes that order; normalization is fused with output. }
span:=2;
while span<=count do
  begin
  half:=span div 2; stride:=nttRootLength div span; base:=0;
  while base<count do
    begin
    k:=0;
    for j:=0 to half-1 do
      begin
      u:=a[base+j]; v:=NTTMul(a[base+j+half],nttInvRoots[k]);
      s:=u+v; if s>=nttMod then dec(s,nttMod);
      if u>=v then d:=u-v else d:=u+nttMod-v;
      a[base+j]:=s; a[base+j+half]:=d;
      inc(k,stride);
      end;
    inc(base,span);
    end;
  span:=span*2;
  end;
end;

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
if count*2*32<=H102RingCut(fftCut) then
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
procedure NTTLoadW(const a:TWordArray; ao,len,count:longint; var b:TNTTArray);
var i:longint;
begin
SetLength(b,count);
FillChar(b[0],count*4,0);
for i:=0 to len-1 do if ((a[ao+(i shr 5)] shr (i and 31)) and 1)<>0 then b[i]:=nttOne;
end;

procedure NTTStoreW(const a:TNTTArray; var r:TWordArray; ro,used,count:longint);
var i:longint; scale:LongWord; v:LongWord;
begin
{ count divides p-1: 1/count = p-(p-1)/count modulo p. }
scale:=nttMod-(nttMod-1) div LongWord(count);
v:=0;
for i:=0 to used-1 do begin
  if (NTTMul(a[i],scale) and 1)<>0 then v:=v or (LongWord(1) shl (i and 31));
  if ((i and 31)=31) or (i=used-1) then
    begin r[ro+(i shr 5)]:=r[ro+(i shr 5)] xor v; v:=0; end;
  end;
end;

procedure NTTProductW(const a:TWordArray; ao:longint;
                       const b:TWordArray; bo:longint; var r:TWordArray;
                       ro,alen,blen,lim:longint);
var aa,bb:TNTTArray; count,i,used:longint;
begin
if (alen<=0) or (blen<=0) or (lim<=0) then exit;
used:=alen+blen-1; count:=2;
while count<used do count:=count*2;
if lim<used then used:=lim;
NTTPrepare(count);
NTTLoadW(a,ao,alen,count,aa); NTTLoadW(b,bo,blen,count,bb);
NTTForward(aa,count); NTTForward(bb,count);
for i:=0 to count-1 do aa[i]:=NTTMul(aa[i],bb[i]);
NTTInverse(aa,count); NTTStoreW(aa,r,ro,used,count);
end;

{ Share the transform of a between a*b and a*c. All inputs are read
  before either destination is updated, including aliased work arrays. }
procedure NTTProductPairW(const a:TWordArray; ao:longint;
                       const b:TWordArray; bo:longint; const c:TWordArray; co:longint;
                       var r:TWordArray; ro:longint; var s:TWordArray; so:longint;
                       alen,blen,clen,lim:longint);
var aa,bb,cc:TNTTArray; count,i,top,used:longint;
begin
if (alen<=0) or ((blen<=0) and (clen<=0)) or (lim<=0) then exit;
top:=blen; if clen>top then top:=clen;
count:=2; while count<alen+top-1 do count:=count*2;
NTTPrepare(count);
NTTLoadW(a,ao,alen,count,aa); NTTLoadW(b,bo,blen,count,bb);
NTTLoadW(c,co,clen,count,cc);
NTTForward(aa,count);
if blen>0 then
  begin
  NTTForward(bb,count);
  for i:=0 to count-1 do bb[i]:=NTTMul(aa[i],bb[i]);
  NTTInverse(bb,count);
  used:=alen+blen-1; if used>lim then used:=lim;
  NTTStoreW(bb,r,ro,used,count);
  end;
if clen>0 then
  begin
  NTTForward(cc,count);
  for i:=0 to count-1 do cc[i]:=NTTMul(aa[i],cc[i]);
  NTTInverse(cc,count);
  used:=alen+clen-1; if used>lim then used:=lim;
  NTTStoreW(cc,s,so,used,count);
  end;
end;

{ GF(2^32) uses X^32+X^7+X^3+X^2+1. H112 supplies the
  exact field product; no PCLMUL/SIMD or external unit. }
type TH111Array=array of LongWord;
var h111Points:TH111Array;
var h111Initialized:boolean;
const h111Beta:array[0..31] of LongWord=($00000001,$54FD1264,$76449FC2,$98110738,$327A5F52,$2EAA1F6C,$5C742AC4,$7214BE62,$7A228834,$C9C50132,$F2874F5A,$3A94CA90,$2B66212A,$C99DD728,$10F0EA68,$016655DC,$C1C1C14A,$4154C4E6,$01AC8E72,$B7A1BBC6,$4D9A138E,$51169116,$7774B1A4,$7BA8A292,$5DDACACA,$C443197C,$F6855174,$4C14919C,$901551F2,$81BDD298,$634C282E,$5A3AB026);

{ Entries are ordinary carryless 8-bit products, not field logarithms.
  The recurrence is T[a,b]=(T[a div 2,b] shl 1) xor ((a and 1)*b).
  All 65536 entries take linear table-building time, once per process. }
type TH112Table=array[0..65535] of Word;
var h112Mul8:TH112Table;
var h112TableReady:boolean;

procedure H112PrepareTable;
var a,b,base,previous:longint; value:LongWord;
begin
if h112TableReady then exit;
for b:=0 to 255 do h112Mul8[b]:=0;
for a:=1 to 255 do
  begin
  base:=a shl 8; previous:=(a shr 1) shl 8;
  for b:=0 to 255 do
    begin
    value:=LongWord(h112Mul8[previous+b]) shl 1;
    if (a and 1)<>0 then value:=value xor LongWord(b);
    h112Mul8[base+b]:=Word(value);
    end;
  end;
h112TableReady:=true;
end;

function H112Mul16(a,b:LongWord):LongWord;
var lo,hi,middle:LongWord;
begin
lo:=h112Mul8[((a and $FF) shl 8) or (b and $FF)];
hi:=h112Mul8[((a shr 8) shl 8) or (b shr 8)];
middle:=h112Mul8[(((a xor (a shr 8)) and $FF) shl 8) or ((b xor (b shr 8)) and $FF)];
H112Mul16:=lo xor ((middle xor lo xor hi) shl 8) xor (hi shl 16);
end;

function H111Mul(a,b:LongWord):LongWord;
var lowProduct,highProduct,cross,lo,hi:LongWord; t:QWord;
begin
if (a=0) or (b=0) then begin H111Mul:=0; exit; end;
if a=1 then begin H111Mul:=b; exit; end;
if b=1 then begin H111Mul:=a; exit; end;
if not h112TableReady then H112PrepareTable;
lowProduct:=H112Mul16(a and $FFFF,b and $FFFF);
highProduct:=H112Mul16(a shr 16,b shr 16);
cross:=H112Mul16((a xor (a shr 16)) and $FFFF,(b xor (b shr 16)) and $FFFF) xor lowProduct xor highProduct;
lo:=lowProduct xor (cross shl 16); hi:=highProduct xor (cross shr 16);
t:=QWord(hi) xor (QWord(hi) shl 2) xor (QWord(hi) shl 3) xor (QWord(hi) shl 7);
lo:=lo xor LongWord(t); hi:=LongWord(t shr 32);
H111Mul:=lo xor hi xor (hi shl 2) xor (hi shl 3) xor (hi shl 7);
end;

procedure H111Prepare(count:longint);
var first,j,level:longint;
begin
if not h111Initialized then
  begin
  if h111Beta[0]<>1 then Halt(229);
  for j:=1 to High(h111Beta) do
    if H111Mul(h111Beta[j],h111Beta[j]) xor h111Beta[j]<>h111Beta[j-1] then Halt(229);
  h111Initialized:=true;
  end;
first:=Length(h111Points);
if first>=count then exit;
SetLength(h111Points,count);
if first=0 then begin h111Points[0]:=0; first:=1; end;
level:=0; j:=first; while j>1 do begin j:=j shr 1; inc(level); end;
while first<count do
  begin
  for j:=0 to first-1 do h111Points[first+j]:=h111Points[j] xor h111Beta[level];
  first:=first shl 1; inc(level);
  end;
end;

{ Convert in either direction between powers of X and the Cantor
  novel basis. Split the dimension at its largest lower power of two,
  where s_h(X)=X^(2^h)+X; this accepts EVERY transform dimension. }
{ H114: the same grouped linear Pascal network in A/B. }
procedure H113Pascal(var a:TH111Array; dim:longint);
var pass,groupDim,stage,half,base,j,count:longint;
begin
count:=1 shl dim; pass:=0;
while pass<dim do
  begin
  groupDim:=dim-pass; if groupDim>3 then groupDim:=3;
  for stage:=0 to groupDim-1 do
    begin
    half:=1 shl (pass+stage); base:=0;
    while base<count do
      begin
      for j:=base to base+half-1 do a[j]:=a[j] xor a[j+half];
      inc(base,half*2);
      end;
    end;
  inc(pass,groupDim);
  end;
end;
procedure H111Taylor(var a:TH111Array; base,stride,dim,h:longint; inverse:boolean);
var p:TH111Array; low,high,period,total,d,size,passDim,j,pos,last:longint;
var carry,value:LongWord; extra:boolean;
begin
if dim<=h then exit;
low:=1 shl h; high:=1 shl (dim-h); period:=low-1; total:=1 shl dim;
SetLength(p,high*2);
for d:=0 to period-1 do
  begin
  size:=(total-1-d) div period+1; passDim:=dim-h;
  if size>high then inc(passDim);
  FillChar(p[0],(1 shl passDim)*SizeOf(p[0]),0);
  extra:=(high=low) and (d=0);
  if inverse then
    begin
    pos:=base+d*stride;
    for j:=0 to size-1 do begin p[j]:=a[pos]; inc(pos,period*stride); end;
    H113Pascal(p,passDim);
    if extra then
      begin
      value:=p[high+1];
      p[high-1]:=p[high-1] xor value;
      a[base+(total-1)*stride]:=value;
      end;
    carry:=0;
    for j:=high-1 downto d do
      begin
      carry:=carry xor p[j+1];
      a[base+(j*low+d-j+period)*stride]:=carry;
      end;
    last:=d; if last>=high then last:=high-1;
    for j:=0 to last do
      begin
      value:=p[j];
      if j=d then value:=value xor carry;
      a[base+(j*low+d-j)*stride]:=value;
      end;
    end
  else
    begin
    last:=d; if last>=high then last:=high-1;
    for j:=0 to last do p[j]:=a[base+(j*low+d-j)*stride];
    for j:=d to high-1 do
      begin
      value:=a[base+(j*low+d-j+period)*stride];
      p[j]:=p[j] xor value;
      p[j+1]:=p[j+1] xor value;
      end;
    if extra then
      begin
      value:=a[base+(total-1)*stride];
      p[high-1]:=p[high-1] xor value;
      p[high+1]:=p[high+1] xor value;
      end;
    H113Pascal(p,passDim); pos:=base+d*stride;
    for j:=0 to size-1 do begin a[pos]:=p[j]; inc(pos,period*stride); end;
    end;
  end;
end;

procedure H111Convert(var a:TH111Array; base,stride,dim:longint; inverse:boolean);
var h,g,lowCount,highCount,p:longint;
begin
if dim<=1 then exit;
h:=1; while h*2<dim do h:=h*2;
g:=dim-h; lowCount:=1 shl h; highCount:=1 shl g;
if inverse then H111Taylor(a,base,stride,dim,h,true);
for p:=0 to highCount-1 do H111Convert(a,base+p*lowCount*stride,stride,h,inverse);
for p:=0 to lowCount-1 do H111Convert(a,base+p*stride,stride*lowCount,g,inverse);
if not inverse then H111Taylor(a,base,stride,dim,h,false);
end;

procedure H111Transform(var a:TH111Array; dim:longint; inverse:boolean);
var pass,i,h,base,j,count:longint; c,lo,hi:LongWord;
begin
count:=Length(a);
for pass:=0 to dim-1 do
  begin
  if inverse then i:=pass else i:=dim-1-pass;
  h:=1 shl i; base:=0;
  while base<count do
    begin
    c:=h111Points[base shr i];
    for j:=base to base+h-1 do
      begin
      lo:=a[j]; hi:=a[j+h];
      if inverse then begin hi:=hi xor lo; lo:=lo xor H111Mul(c,hi); end
      else begin lo:=lo xor H111Mul(c,hi); hi:=hi xor lo; end;
      a[j]:=lo; a[j+h]:=hi;
      end;
    inc(base,h*2);
    end;
  end;
end;

{ Sixteen input bits per GF(2^32) coefficient ensure that each
  coefficient product has degree <=30. Field reduction therefore
  cannot change the ordinary block convolution after interpolation. }
procedure H114Forward(var a:TH111Array; dim:longint);
begin H111Convert(a,0,1,dim,true); H111Transform(a,dim,false); end;
procedure H114Inverse(var a:TH111Array; dim:longint);
begin H111Transform(a,dim,true); H111Convert(a,0,1,dim,false); end;


procedure H114LoadInputW(const a:TWordArray; ao,len,count:longint; var b:TH111Array);
var j,take:longint;
begin
SetLength(b,count); FillChar(b[0],count*SizeOf(b[0]),0);
for j:=0 to (len+15) div 16-1 do
  begin
  take:=len-j*16; if take>16 then take:=16;
  b[j]:=(a[ao+(j shr 1)] shr ((j and 1)*16)) and (LongWord($FFFF) shr (16-take));
  end;
end;
procedure H114StoreInputW(const a:TH111Array; blocks,used:longint; var r:TWordArray; ro:longint);
var j,take,last:longint; value,part:LongWord;
begin
value:=0; last:=(used+15) div 16-1;
for j:=0 to last do
  begin
  part:=0; if j<blocks then part:=a[j];
  if j>0 then part:=part xor (a[j-1] shr 16);
  take:=used-j*16; if take>16 then take:=16;
  part:=part and (LongWord($FFFF) shr (16-take));
  value:=value or (part shl ((j and 1)*16));
  if ((j and 1)=1) or (j=last) then
    begin r[ro+(j shr 1)]:=r[ro+(j shr 1)] xor value; value:=0; end;
  end;
end;
procedure H111ProductW(const a:TWordArray; ao:longint;
                       const b:TWordArray; bo:longint; var r:TWordArray;
                       ro,alen,blen,lim:longint);
var aa,bb:TH111Array; ac,bc,count,dim,used,j:longint;
begin
if (alen<=0) or (blen<=0) or (lim<=0) then exit;
if alen>lim then alen:=lim; if blen>lim then blen:=lim;
ac:=(alen+15) shr 4; bc:=(blen+15) shr 4;
count:=2; dim:=1; while count<ac+bc-1 do begin count:=count*2; inc(dim); end;
H114LoadInputW(a,ao,alen,count,aa); H114LoadInputW(b,bo,blen,count,bb);
H111Prepare(count); H114Forward(aa,dim); H114Forward(bb,dim);
for j:=0 to count-1 do aa[j]:=H111Mul(aa[j],bb[j]);
H114Inverse(aa,dim); used:=alen+blen-1; if used>lim then used:=lim;
H114StoreInputW(aa,ac+bc-1,used,r,ro);
end;
{ H114: snapshot all inputs and transform the common operand once. }
procedure H111ProductPairW(const a:TWordArray; ao:longint;
                       const b:TWordArray; bo:longint; const c:TWordArray; co:longint;
                       var r:TWordArray; ro:longint; var s:TWordArray; so:longint;
                       alen,blen,clen,lim:longint);
var aa,bb,cc:TH111Array; ac,bc,dc,count,dim,j,used,top:longint;
begin
if (alen<=0) or ((blen<=0) and (clen<=0)) or (lim<=0) then exit;
if alen>lim then alen:=lim; if blen>lim then blen:=lim; if clen>lim then clen:=lim;
if blen<0 then blen:=0; if clen<0 then clen:=0;
ac:=(alen+15) shr 4; bc:=(blen+15) shr 4; dc:=(clen+15) shr 4;
top:=bc; if dc>top then top:=dc;
count:=2; dim:=1; while count<ac+top-1 do begin count:=count*2; inc(dim); end;
H114LoadInputW(a,ao,alen,count,aa); H114LoadInputW(b,bo,blen,count,bb);
H114LoadInputW(c,co,clen,count,cc);
H111Prepare(count); H114Forward(aa,dim);
if blen>0 then
  begin
  H114Forward(bb,dim);
  for j:=0 to count-1 do bb[j]:=H111Mul(aa[j],bb[j]);
  H114Inverse(bb,dim); used:=alen+blen-1; if used>lim then used:=lim;
  H114StoreInputW(bb,ac+bc-1,used,r,ro);
  end;
if clen>0 then
  begin
  H114Forward(cc,dim);
  for j:=0 to count-1 do cc[j]:=H111Mul(aa[j],cc[j]);
  H114Inverse(cc,dim); used:=alen+clen-1; if used>lim then used:=lim;
  H114StoreInputW(cc,ac+dc-1,used,s,so);
  end;
end;


{ H119. Exact binary multiplication on a 3 by 5 CRT grid in GF(16).
  Jet products split the two low binary digits into two ternary axes.
  Nine independent 3 by 3 transforms use a count predictor and one
  exceptional row per frequency. Growing jet tails use the exact ring FFT. }
type TH119Bits=TWordArray;
type TH119Cell=LongWord;
type TH119Fields=array of TH119Cell;
type TH119Line=array[0..8] of TH119Cell;
type TH119Batch=array[0..8] of TH119Line;
type TH119Sum=array[0..2] of TH119Cell;
var h119Mul:array[0..15,0..15] of TH119Cell;
var h119Power:array[0..14] of TH119Cell;
var h119Predict:array[0..8,0..3] of TH119Cell;
var h119Chirp,h119Eigen:TH119Line;
var h119Init:boolean;

function H119Bit(const a:TH119Bits; i:longint):boolean; inline;
begin H119Bit:=((a[i shr 5] shr (i and 31)) and 1)<>0; end;

procedure H119Flip(var a:TH119Bits; i:longint); inline;
begin a[i shr 5]:=a[i shr 5] xor (LongWord(1) shl (i and 31)); end;

procedure H119Space(var a:TH119Bits; count:longint); inline;
begin
SetLength(a,(count+31) shr 5);
if Length(a)>0 then FillChar(a[0],Length(a)*SizeOf(a[0]),0);
end;

function H119Field(i:longint):TH119Cell; inline;
begin H119Field:=i; end;

function H119Index(const a:TH119Cell):longint; inline;
begin H119Index:=longint(a); end;

function H119Add(const a,b:TH119Cell):TH119Cell; inline;
begin H119Add:=a xor b; end;

function H119Times(const a,b:TH119Cell):TH119Cell; inline;
begin H119Times:=h119Mul[H119Index(a),H119Index(b)]; end;

function H119Omega(k:longint):TH119Cell; inline;
begin H119Omega:=h119Power[((k mod 3+3) mod 3)*5]; end;

procedure H119InitTables;
var i,j,k,u,v,beta,c,x,y,cnt,a0,b0:longint;
var zero,z,p,value,factor:TH119Cell;
var kernel:array[0..3] of TH119Cell;
begin
if h119Init then exit;
zero:=H119Field(0); x:=1;
for i:=0 to 14 do
  begin
  h119Power[i]:=H119Field(x);
  x:=x shl 1; if (x and 16)<>0 then x:=x xor 19;
  end;
for i:=0 to 14 do for j:=0 to 14 do
  h119Mul[H119Index(h119Power[i]),H119Index(h119Power[j])]:=h119Power[(i+j) mod 15];
for beta:=0 to 8 do
  begin
  a0:=beta mod 3; b0:=beta div 3;
  for k:=0 to 3 do
    begin
    x:=k mod 2; y:=k div 2; value:=zero;
    for j:=0 to 8 do
      begin
      u:=j mod 3; v:=j div 3;
      i:=(2*u*u) mod 3; c:=(2*v*v) mod 3; z:=H119Omega(i+c);
      cnt:=(i+a0) mod 3+(c+b0) mod 3;
      { Integral predictor on counts 0..3. Only count 4 is exceptional. }
      if cnt=4 then p:=H119Omega(-a0-b0) else p:=z;
      factor:=H119Omega(-u*x-v*y);
      value:=H119Add(value,H119Times(p,factor));
      h119Chirp[j]:=H119Omega(-u*u-v*v); h119Eigen[j]:=z;
      end;
    kernel[k]:=value;
    end;
  h119Predict[beta,3]:=kernel[3];
  h119Predict[beta,1]:=H119Add(kernel[1],kernel[3]);
  h119Predict[beta,2]:=H119Add(kernel[2],kernel[3]);
  h119Predict[beta,0]:=H119Add(H119Add(kernel[0],kernel[2]),h119Predict[beta,1]);
  end;
h119Init:=true;
end;

procedure H119Prediction(const src:TH119Line; beta:longint; var dst:TH119Line);
var rows,cols:TH119Sum; total,common:TH119Cell; i,j,k:longint;
begin
for j:=0 to 2 do
  begin
  rows[j]:=H119Add(H119Add(src[j*3],src[j*3+1]),src[j*3+2]);
  cols[j]:=H119Add(H119Add(src[j],src[j+3]),src[j+6]);
  end;
total:=H119Times(H119Add(H119Add(rows[0],rows[1]),rows[2]),h119Predict[beta,3]);
for j:=0 to 2 do cols[j]:=H119Times(cols[j],h119Predict[beta,2]);
for j:=0 to 2 do
  begin
  common:=H119Add(total,H119Times(rows[j],h119Predict[beta,1]));
  for i:=0 to 2 do
    begin k:=3*j+i; dst[k]:=H119Add(H119Add(common,cols[i]),H119Times(src[k],h119Predict[beta,0])); end;
  end;
end;

{ Ordinary transforms only on the two parity-check rows. }
procedure H119CheckDFT(var a:TH119Line; inverse:boolean);
var stride,base,offset,i,j:longint; omega:TH119Cell; first,last,pair,middle:TH119Cell;
begin
if inverse then omega:=H119Omega(-1) else omega:=H119Omega(1);
stride:=1;
while stride<=3 do
  begin
  base:=0;
  while base<9 do
    begin
    for offset:=0 to stride-1 do
      begin
      i:=base+offset; j:=i+stride; first:=a[i]; last:=a[j+stride];
      pair:=H119Add(a[j],last);
      middle:=H119Add(H119Add(first,last),H119Times(pair,omega));
      a[i]:=H119Add(first,pair); a[j]:=middle; a[j+stride]:=H119Add(middle,pair);
      end;
    inc(base,3*stride);
    end;
  stride:=stride*3;
  end;
end;

{ In the two-axis ternary tensor, a frequency (u,v) has one exceptional
  row beta. Each beta digit is 2 for a zero frequency and 0 for a
  nonzero one. The four supports are Cartesian products of the zero
  frequency and the pair of nonzero frequencies. The two summed checks already give the entire error on the
  corresponding row. Interpolate each support separately. }
procedure H119Tensor(var a:TH119Batch; inverse:boolean);
const affected:array[0..3] of longint=(0,2,6,8);
var pred:TH119Batch; hx,hp:TH119Line; hor:array[0..2] of TH119Sum;
    vert,both:TH119Sum; omega:TH119Cell; row,i,j,k,pos:longint;
procedure InversePair(const u,v:TH119Cell; var dst:TH119Sum); inline;
begin
dst[0]:=H119Add(u,v);
dst[1]:=H119Add(u,H119Times(dst[0],omega));
dst[2]:=H119Add(dst[0],dst[1]);
end;
begin
FillChar(hx,SizeOf(hx),0); FillChar(hp,SizeOf(hp),0);
omega:=H119Omega(1);
for i:=0 to 8 do
  if (i mod 3=1) or (i div 3=1) then H119CheckDFT(a[i],inverse)
  else
    begin
    for j:=0 to 8 do a[i,j]:=H119Times(a[i,j],h119Chirp[j]);
    H119Prediction(a[i],i,pred[i]);
    for j:=0 to 8 do
      begin hx[j]:=H119Add(hx[j],a[i,j]); hp[j]:=H119Add(hp[j],pred[i,j]); end;
    end;
H119CheckDFT(hx,false); H119CheckDFT(hp,false);
for j:=0 to 8 do hp[j]:=H119Add(hp[j],H119Times(hx[j],h119Eigen[j]));
for j:=0 to 2 do InversePair(hp[3*j+1],hp[3*j+2],hor[j]);
InversePair(hp[3],hp[6],vert);
for i:=0 to 2 do
  begin
  InversePair(hor[1,i],hor[2,i],both);
  for j:=0 to 2 do
    begin
    pos:=3*j+i;
    pred[0,pos]:=H119Add(pred[0,pos],both[j]);
    pred[2,pos]:=H119Add(pred[2,pos],vert[j]);
    pred[6,pos]:=H119Add(pred[6,pos],hor[0,i]);
    pred[8,pos]:=H119Add(pred[8,pos],hp[0]);
    end;
  end;
for i:=0 to 3 do
  begin
  row:=affected[i];
  for j:=0 to 8 do
    begin
    k:=j; if inverse then k:=(3-j mod 3) mod 3+3*((3-j div 3) mod 3);
    a[row,k]:=H119Times(pred[row,j],h119Chirp[j]);
    end;
  end;
end;

procedure H119Grid(var a:TH119Fields; pitch:longint; inverse:boolean);
var src,dst:array[0..4] of TH119Cell; p,stride,base,z,i,j,k,ex:longint;
begin
p:=3; stride:=1;
repeat
  for base:=0 to 14 do if (base div stride) mod p=0 then
    for z:=0 to pitch-1 do
      begin
      for i:=0 to p-1 do src[i]:=a[(base+i*stride)*pitch+z];
      for i:=0 to p-1 do
        begin
        dst[i]:=src[0];
        for j:=1 to p-1 do
          begin
          ex:=(i*j*(15 div p)) mod 15; if inverse and (ex<>0) then ex:=15-ex;
          dst[i]:=H119Add(dst[i],H119Times(src[j],h119Power[ex]));
          end;
        end;
      for k:=0 to p-1 do a[(base+k*stride)*pitch+z]:=dst[k];
      end;
  if p=5 then break;
  p:=5; stride:=3;
until false;
end;

{ Pack b binary coefficients, with 2b slots for a product. The coefficient
  algebra is GF(2)[Y]/Y^(2b). During the ternary FFT all scalars are in
  this algebra. b=floor(log2(s)/6), with a one-bit minimum. The complete
  two-input tables have 2^(4b) entries. A refers to immutable Boolean
  coefficient vectors; B stores each vector in a LongWord. }
type TH119Block=LongWord;
type TH119BlockVec=array of TH119Block;
type TH119BlockPlan=record
  width,count:longint;
  
  sums,products:TH119BlockVec;
end;
var h119BlockPlans:array of TH119BlockPlan;

function H119BlockKey(const a:TH119Block):longint; inline;
begin H119BlockKey:=longint(a); end;

function H119BlockLookup(const plan:TH119BlockPlan; i:longint):TH119Block; inline;
begin H119BlockLookup:=LongWord(i); end;

function H119BlockBit(const a:TH119Block; i:longint):boolean; inline;
begin H119BlockBit:=(a and (LongWord(1) shl i))<>0; end;

procedure H119BuildBlockPlan(var plan:TH119BlockPlan; width:longint);
var count,len,i,j,k,h,sum,prod:longint; left,right:TH119Block; value:boolean;
begin
if plan.width=width then exit;
len:=2*width; count:=1 shl len; plan.width:=width; plan.count:=count;

SetLength(plan.sums,count*count); SetLength(plan.products,count*count);
for i:=0 to count-1 do
  begin
  left:=H119BlockLookup(plan,i);
  for j:=0 to i do
    begin
    right:=H119BlockLookup(plan,j); sum:=0; prod:=0;
    for k:=0 to len-1 do
      begin
      if H119BlockBit(left,k) xor H119BlockBit(right,k) then sum:=sum or (1 shl k);
      value:=false;
      for h:=0 to k do value:=value xor (H119BlockBit(left,h) and H119BlockBit(right,k-h));
      if value then prod:=prod or (1 shl k);
      end;
    plan.sums[i*count+j]:=H119BlockLookup(plan,sum); plan.sums[j*count+i]:=plan.sums[i*count+j];
    plan.products[i*count+j]:=H119BlockLookup(plan,prod); plan.products[j*count+i]:=plan.products[i*count+j];
    end;
  end;
end;

function H119BlockAdd(const plan:TH119BlockPlan; const a,b:TH119Block):TH119Block;
begin H119BlockAdd:=plan.sums[H119BlockKey(a)*plan.count+H119BlockKey(b)]; end;

{ Fuse consecutive ternary FFT levels. Write U=T^(3m/r) in the old
  ring modulo T^(2m)+T^m+1. Then U is a primitive r-th root and its
  binary minimal polynomial is U^(2r/3)+U^(r/3)+1. Every ring value
  splits uniquely into 3m/r residues with coefficients in this field,
  acting independently on the bits of the original block algebra. }
type TH120IndexVec=array of longint;
type TH120Gate=record left,right,scaleLeft,scaleRight:longint; end;
type TH120Circuit=record
  radix,degree,field:longint;
  mul,inv,power,outReg:TH120IndexVec;
  gates:array of TH120Gate;
end;
type TH120ScalePlan=record lanes,groups,limit:longint; value:TH119BlockVec; end;
var h120Codes:array of TH120Circuit;
    h120Scales:array of array of TH120ScalePlan;

function H120FieldProduct(const c:TH120Circuit; a,b:longint):longint; inline;
begin H120FieldProduct:=c.mul[a*c.field+b]; end;

function H120CodeSum(a,b:longint):longint; inline;
begin H120CodeSum:=longint(LongWord(a) xor LongWord(b)); end;

procedure H120Field(var c:TH120Circuit; r:longint);
var i,j,v,x,y,p,poly:longint;
begin
c.radix:=r; c.degree:=(r div 3)*2; c.field:=1 shl c.degree;
poly:=c.field or (1 shl (r div 3)) or 1;
SetLength(c.mul,c.field*c.field); SetLength(c.inv,c.field); SetLength(c.power,r+1);
for i:=1 to c.field-1 do for j:=1 to i do
  begin
  v:=0; x:=i; y:=j;
  while y>0 do
    begin
    if odd(y) then v:=H120CodeSum(v,x); y:=y shr 1; x:=x shl 1;
    if x>=c.field then x:=H120CodeSum(x,poly);
    end;
  c.mul[i*c.field+j]:=v; c.mul[j*c.field+i]:=v;
  if v=1 then begin c.inv[i]:=j; c.inv[j]:=i; end;
  end;
p:=1; for i:=0 to r do begin c.power[i]:=p; p:=H120FieldProduct(c,p,2); end;
end;

{ A native nine-point cyclic DFT has two length-three stages. In terms
  of normalized inputs A,B,C its three outputs use S=B+C,
  A+S, A+C+zeta*S and (A+C+zeta*S)+S. Twiddle scales are folded
  into the first use. This concrete circuit also serves as a test seed. }
procedure H120Nine(var c:TH120Circuit);
var next,j,k:longint; tmp:array[0..2,0..2] of longint;
function Gate(l,r,sl,sr:longint):longint;
begin
with c.gates[next] do begin left:=l; right:=r; scaleLeft:=sl; scaleRight:=sr; end;
Gate:=9+next; inc(next);
end;
procedure Three(a,b,v,sa,sb,sv:longint; var x,y,z:longint);
var both,ac:longint;
begin
both:=Gate(b,v,sb,sv); x:=Gate(a,both,sa,1); ac:=Gate(a,v,sa,sv);
y:=Gate(ac,both,1,c.power[3]); z:=Gate(y,both,1,1);
end;
begin
SetLength(c.gates,30); SetLength(c.outReg,9); next:=0;
for j:=0 to 2 do Three(j,j+3,j+6,1,1,1,tmp[j,0],tmp[j,1],tmp[j,2]);
for k:=0 to 2 do
  Three(tmp[0,k],tmp[1,k],tmp[2,k],1,c.power[k],c.power[2*k],
        c.outReg[k],c.outReg[k+3],c.outReg[k+6]);
end;

{ Uniform construction of an optimal small Fourier circuit over the
  finite root field. Linear forms are normalized by their first nonzero
  coefficient. A normalized new gate can always be written as a scaled
  A+t*B with t nonzero. Remove scalar duplicates and prune only when the
  remaining budget cannot hold the missing outputs. On i386, r=9 is the
  largest selected radix and the explicit seed above suffices. }
procedure H120Synthesize(var c:TH120Circuit);
var r,budget,maxG,p,j:longint; forms,target,found:TH120IndexVec;
    trace:array of TH120Gate;
function Search(used,missing:longint):boolean;
var slot,at,i,j,t,k,first,scale,val,existing,hit,a0,a1:longint; same:boolean;
begin
if missing=0 then
  begin
  SetLength(c.gates,used); for k:=0 to used-1 do c.gates[k]:=trace[k];
  c.outReg:=Copy(found,0,r); Search:=true; exit;
  end;
Search:=false; if budget-used<missing then exit;
slot:=r+used; at:=slot*r;
for i:=0 to slot-2 do for j:=i+1 to slot-1 do
  for t:=1 to c.field-1 do
    begin
    first:=0; a0:=i*r; a1:=j*r;
    for k:=0 to r-1 do
      begin
      val:=H120CodeSum(forms[a0+k],H120FieldProduct(c,t,forms[a1+k])); forms[at+k]:=val;
      if first=0 then first:=val;
      end;
    if first=0 then continue;
    scale:=c.inv[first];
    for k:=0 to r-1 do forms[at+k]:=H120FieldProduct(c,forms[at+k],scale);
    existing:=0;
    while existing<slot do
      begin
      k:=0; while (k<r) and (forms[existing*r+k]=forms[at+k]) do inc(k);
      if k=r then break; inc(existing);
      end;
    if existing<slot then continue;
    hit:=-1;
    for k:=0 to r-1 do if found[k]<0 then
      begin
      same:=CompareByte(forms[at],target[k*r],r*SizeOf(longint))=0;
      if same then begin hit:=k; break; end;
      end;
    if (hit<0) and (budget-used=missing) then continue;
    trace[used].left:=i; trace[used].right:=j; trace[used].scaleLeft:=scale;
    trace[used].scaleRight:=H120FieldProduct(c,scale,t);
    if hit>=0 then found[hit]:=slot;
    if Search(used+1,missing-ord(hit>=0)) then begin Search:=true; exit; end;
    if hit>=0 then found[hit]:=-1;
    end;
end;
begin
r:=c.radix; maxG:=r*(r-1); SetLength(found,r); SetLength(target,r*r);
SetLength(trace,maxG); SetLength(forms,(maxG+r)*r);
for p:=0 to r-1 do
  begin
  found[p]:=-1; forms[p*r+p]:=1;
  for j:=0 to r-1 do target[p*r+j]:=c.power[(p*j) mod r];
  end;
for budget:=r to maxG do if Search(0,r) then exit;
Halt(232);
end;

procedure H120PrepareFourier(const p:TH119BlockPlan; r,logR:longint);
var i,j,b,k,bit,at,value,key,one,limit:longint;
begin
if Length(h120Codes)<=logR then SetLength(h120Codes,logR+1);
if h120Codes[logR].radix=0 then
  begin
  H120Field(h120Codes[logR],r);
  if r=9 then H120Nine(h120Codes[logR]) else H120Synthesize(h120Codes[logR]);
  end;
if Length(h120Scales)<=p.width then SetLength(h120Scales,p.width+1);
if Length(h120Scales[p.width])<=logR then SetLength(h120Scales[p.width],logR+1);
with h120Scales[p.width,logR] do
  begin
  if lanes<>0 then exit;
  lanes:=(2*p.width) div h120Codes[logR].degree; groups:=(2*p.width+lanes-1) div lanes;
  end;
with h120Codes[logR] do
  begin
  b:=h120Scales[p.width,logR].lanes; limit:=1 shl (degree*b);
  h120Scales[p.width,logR].limit:=limit;
  SetLength(h120Scales[p.width,logR].value,field*limit);
  for i:=1 to field-1 do
    begin
    at:=i*limit; one:=1;
    for bit:=0 to degree*b-1 do
      begin
      value:=mul[i*field+(1 shl (bit div b))]; key:=0;
      for k:=0 to degree-1 do if (value and (1 shl k))<>0 then key:=key or (1 shl (k*b+bit mod b));
      h120Scales[p.width,logR].value[at+one]:=H119BlockLookup(p,key);
      for j:=1 to one-1 do
        h120Scales[p.width,logR].value[at+one+j]:=H119BlockAdd(p,
          h120Scales[p.width,logR].value[at+one],h120Scales[p.width,logR].value[at+j]);
      one:=one*2;
      end;
    end;
  end;
end;

procedure H120RadixTransform(const plan:TH119BlockPlan; var a:TH119BlockVec; k,m:longint;
                             inverse:boolean; const c:TH120Circuit; const table:TH120ScalePlan);
var cur,dst,swap,reg:TH119BlockVec; radices,shifts,f0,f1:TH120IndexVec;
    r,d,h,lanes,groups,chunk,cmask,stage,levels,v,rad,rev,src,row,g,j,t,p,key,orig,term,
    base,prev,step,root,col,delta,ex,shifted,fac,idx,z,at,sgn,i,nregs,add0,add1:longint;
    val,left,right,both,middle:TH119Block;
function Scale(alpha:longint; const x:TH119Block):TH119Block; inline;
begin if alpha=1 then Scale:=x else Scale:=table.value[alpha*table.limit+H119BlockKey(x)]; end;
begin
r:=c.radix; d:=c.degree; h:=3*m div r; lanes:=table.lanes; groups:=table.groups;
chunk:=h*groups; cmask:=(1 shl lanes)-1;
v:=k; levels:=0; while v>1 do begin v:=v div 3; inc(levels); end;
SetLength(radices,levels); levels:=0; v:=k;
while (v mod r)=0 do begin inc(levels); v:=v div r; end;
j:=0; while v>1 do begin radices[j]:=3; inc(j); v:=v div 3; end;
for i:=1 to levels do begin radices[j]:=r; inc(j); end;
levels:=j;
SetLength(cur,k*chunk); SetLength(dst,k*chunk);
SetLength(reg,r+Length(c.gates)); SetLength(shifts,r); SetLength(f0,r); SetLength(f1,r);
for row:=0 to k-1 do
  begin
  src:=row; rev:=0;
  for stage:=0 to levels-1 do
    begin rad:=radices[stage]; rev:=rev*rad+(src mod rad); src:=src div rad; end;
  for j:=0 to h-1 do for g:=0 to groups-1 do
    begin
    key:=0;
    for t:=0 to d-1 do
      begin
      orig:=H119BlockKey(a[rev*2*m+j+t*h]);
      key:=key or (((orig shr (g*lanes)) and cmask) shl (t*lanes));
      end;
    cur[row*chunk+j*groups+g]:=H119BlockLookup(plan,key);
    end;
  end;
prev:=1; nregs:=Length(c.gates);
for stage:=0 to levels-1 do
  begin
  rad:=radices[stage]; step:=prev*rad; root:=3*m div step;
  for col:=0 to prev-1 do
    begin
    delta:=col*root; if inverse and (delta<>0) then delta:=3*m-delta;
    ex:=0;
    for p:=0 to rad-1 do
      begin
      shifts[p]:=ex mod h; idx:=ex div h;
      f0[p]:=c.power[idx]; f1[p]:=c.power[idx+1];
      inc(ex,delta); if ex>=3*m then dec(ex,3*m);
      end;
    base:=0;
    while base<k do
      begin
      for j:=0 to h-1 do for g:=0 to groups-1 do
        begin
        for p:=0 to rad-1 do
          begin
          shifted:=j-shifts[p]; fac:=f0[p];
          if shifted<0 then begin inc(shifted,h); fac:=f1[p]; end;
          at:=(base+col+p*prev)*chunk+shifted*groups+g;
          reg[p]:=Scale(fac,cur[at]);
          end;
        at:=(base+col)*chunk+j*groups+g;
        if rad=3 then
          begin
          both:=H119BlockAdd(plan,reg[1],reg[2]);
          dst[at]:=H119BlockAdd(plan,reg[0],both);
          middle:=H119BlockAdd(plan,H119BlockAdd(plan,reg[0],reg[2]),Scale(c.power[r div 3],both));
          add0:=prev*chunk; add1:=2*add0; if inverse then begin idx:=add0; add0:=add1; add1:=idx; end;
          dst[at+add0]:=middle; dst[at+add1]:=H119BlockAdd(plan,middle,both);
          end
        else
          begin
          for z:=0 to nregs-1 do
            begin
            left:=Scale(c.gates[z].scaleLeft,reg[c.gates[z].left]);
            right:=Scale(c.gates[z].scaleRight,reg[c.gates[z].right]);
            reg[r+z]:=H119BlockAdd(plan,left,right);
            end;
          for p:=0 to r-1 do
            begin sgn:=p; if inverse and (p<>0) then sgn:=r-p;
            dst[at+sgn*prev*chunk]:=reg[c.outReg[p]]; end;
          end;
        end;
      inc(base,step);
      end;
    end;
  swap:=cur; cur:=dst; dst:=swap; prev:=step;
  end;
for row:=0 to k-1 do for j:=0 to h-1 do for t:=0 to d-1 do
  begin
  key:=0;
  for g:=0 to groups-1 do
    begin
    val:=cur[row*chunk+j*groups+g]; term:=(H119BlockKey(val) shr (t*lanes)) and cmask;
    key:=key or (term shl (g*lanes));
    end;
  a[row*2*m+j+t*h]:=H119BlockLookup(plan,key and (plan.count-1));
  end;
end;

function H120Transform(const plan:TH119BlockPlan; var a:TH119BlockVec; k,m:longint; inverse:boolean):boolean;
var r,logR,next,v,j,budget:longint;
begin
H120Transform:=false;
if (k<9) or (m mod 3<>0) or (2*plan.width<6) then exit;
r:=9; logR:=2; v:=k; budget:=0;
while v>1 do begin v:=v div 3; inc(budget); end;
{ r^4 <= log_3(k); divide the budget to test a candidate without overflow.
  This keeps exhaustive construction 2^O(r^3) sublinear in the global input. }
while r<=k div 3 do
  begin
  next:=3*r; v:=budget;
  for j:=1 to 4 do v:=v div next;
  if (v=0) or ((2*(next div 3))>2*plan.width) then break;
  r:=next; inc(logR);
  end;
H120PrepareFourier(plan,r,logR);
H120RadixTransform(plan,a,k,m,inverse,h120Codes[logR],h120Scales[plan.width,logR]);
H120Transform:=true;
end;

procedure H119BlockShift(const plan:TH119BlockPlan; const a:TH119BlockVec; ao:longint;
                     var d:TH119BlockVec; shift,m:longint);
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
      Move(a[ao+pos],d[dst],cnt*SizeOf(TH119Block));
      Move(a[ao+m+pos],d[m+dst],cnt*SizeOf(TH119Block));
      end;
    1:for i:=0 to cnt-1 do
      begin
      d[dst+i]:=a[ao+m+pos+i];
      d[m+dst+i]:=H119BlockAdd(plan,a[ao+pos+i],a[ao+m+pos+i]);
      end;
    2:for i:=0 to cnt-1 do
      begin
      d[dst+i]:=H119BlockAdd(plan,a[ao+pos+i],a[ao+m+pos+i]);
      d[m+dst+i]:=a[ao+pos+i];
      end;
    end;
  inc(pos,cnt); dst:=0; inc(power); if power=3 then power:=0;
  end;
end;

procedure H119BlockTransform(const plan:TH119BlockPlan; var a:TH119BlockVec; k,m:longint; inverse:boolean);
var v,w:TH119BlockVec;
var i,j,h,rev,digit,step,third,block0,p0,p1,p2,q,root:longint;
var u0,u1,v0,v1,w0,w1,s0,s1,tmp:TH119Block;
begin
if H120Transform(plan,a,k,m,inverse) then exit;
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
      H119BlockShift(plan,a,p1,v,q,m);
      q:=q*2; if q>=m*3 then dec(q,m*3);
      H119BlockShift(plan,a,p2,w,q,m);
      if inverse then begin h:=p1; p1:=p2; p2:=h; end;
      { psi=t^M: psi*(a+b*psi)=b+(a+b)*psi. }
      for i:=0 to m-1 do
        begin
        u0:=a[p0+i]; u1:=a[p0+m+i];
        v0:=v[i]; v1:=v[m+i]; w0:=w[i]; w1:=w[m+i];
        s0:=H119BlockAdd(plan,v0,w0); s1:=H119BlockAdd(plan,v1,w1);
        a[p0+i]:=H119BlockAdd(plan,u0,s0); a[p0+m+i]:=H119BlockAdd(plan,u1,s1);
        a[p1+i]:=H119BlockAdd(plan,H119BlockAdd(plan,u0,w0),s1); a[p1+m+i]:=H119BlockAdd(plan,H119BlockAdd(plan,H119BlockAdd(plan,u1,w1),s0),s1);
        a[p2+i]:=H119BlockAdd(plan,H119BlockAdd(plan,u0,v0),s1); a[p2+m+i]:=H119BlockAdd(plan,H119BlockAdd(plan,H119BlockAdd(plan,u1,v1),s0),s1);
        end;
      end;
    inc(block0,step);
    end;
  step:=step*3;
  end;
end;

{ Product modulo T^(2m)+T^m+1 over the block algebra. The inverse
  scale on 3K points is one in characteristic two. }
procedure H119BlockRing(const plan:TH119BlockPlan; const a:TH119BlockVec; ao:longint;
                    const b:TH119BlockVec; bo:longint; var r:TH119BlockVec; count:longint);
var aa,bb,pc:TH119BlockVec;
var e,k,m,i,j,base,off0,off1,d:longint; val:TH119Block;
begin
SetLength(r,count*2); FillChar(r[0],count*2*SizeOf(TH119Block),0);
if count<=9 then
  begin
  for i:=0 to count*2-1 do if H119BlockKey(a[ao+i])<>0 then
    for j:=0 to count*2-1 do if H119BlockKey(b[bo+j])<>0 then
      begin
      val:=plan.products[H119BlockKey(a[ao+i])*plan.count+H119BlockKey(b[bo+j])]; d:=i+j;
      if d>=3*count then dec(d,3*count);
      if d>=2*count then
        begin
        r[d-count]:=H119BlockAdd(plan,r[d-count],val); dec(d,2*count);
        end;
      r[d]:=H119BlockAdd(plan,r[d],val);
      end;
  exit;
  end;
e:=0; i:=count;
while (i mod 3)=0 do begin inc(e); i:=i div 3; end;
k:=1; for i:=1 to e div 2 do k:=k*3;
m:=count div k;
SetLength(aa,count*6); SetLength(bb,count*6);
for i:=0 to k*2-1 do
  begin
  Move(a[ao+i*m],aa[i*m*2],m*SizeOf(TH119Block));
  Move(b[bo+i*m],bb[i*m*2],m*SizeOf(TH119Block));
  end;
H119BlockTransform(plan,aa,k*3,m,false); H119BlockTransform(plan,bb,k*3,m,false);
for i:=0 to k*3-1 do
  begin
  base:=i*m*2;
  if i mod 3=0 then FillChar(aa[base],m*2*SizeOf(TH119Block),0)
  else
    begin
    H119BlockRing(plan,aa,base,bb,base,pc,m);
    Move(pc[0],aa[base],m*2*SizeOf(TH119Block));
    end;
  end;
H119BlockTransform(plan,aa,k*3,m,true);
{ 3K is odd: inverse scale=1. Missing frequencies only change the
  multiple of X^(2K)+X^K+1, which the final reduction discards. }
for i:=0 to k*3-1 do
  begin
  base:=i*m*2; off0:=i*m; off1:=off0+m; if off1=count*3 then off1:=0;
  if off0<count*2 then
    for j:=0 to m-1 do r[off0+j]:=H119BlockAdd(plan,r[off0+j],aa[base+j])
  else
    for j:=0 to m-1 do
      begin
      r[off0-count*2+j]:=H119BlockAdd(plan,r[off0-count*2+j],aa[base+j]);
      r[off0-count+j]:=H119BlockAdd(plan,r[off0-count+j],aa[base+j]);
      end;
  if off1<count*2 then
    for j:=0 to m-1 do r[off1+j]:=H119BlockAdd(plan,r[off1+j],aa[base+m+j])
  else
    for j:=0 to m-1 do
      begin
      r[off1-count*2+j]:=H119BlockAdd(plan,r[off1-count*2+j],aa[base+m+j]);
      r[off1-count+j]:=H119BlockAdd(plan,r[off1-count+j],aa[base+m+j]);
      end;
  end;
end;



procedure H119BlockConvolution(const a,b:TH119Bits; len:longint; var dst:TH119Bits);
var aa,bb,cc:TH119BlockVec; w,v,count,groups,i,j,at,d,va,vb:longint;
begin
v:=len; w:=0; while v>1 do begin inc(w); v:=v shr 1; end;
w:=w div 6; if w<1 then w:=1;
if (len>=8192) and (w<3) then w:=3;
if Length(h119BlockPlans)<=w then SetLength(h119BlockPlans,w+1);
H119BuildBlockPlan(h119BlockPlans[w],w);
groups:=(len+w-1) div w; count:=1; while count<groups do count:=3*count;
SetLength(aa,2*count); SetLength(bb,2*count);
for i:=0 to groups-1 do
  begin
  va:=0; vb:=0; at:=i*w;
  for j:=0 to w-1 do if at+j<len then
    begin
    if H119Bit(a,at+j) then va:=va or (1 shl j);
    if H119Bit(b,at+j) then vb:=vb or (1 shl j);
    end;
  aa[i]:=H119BlockLookup(h119BlockPlans[w],va); bb[i]:=H119BlockLookup(h119BlockPlans[w],vb);
  end;
H119BlockRing(h119BlockPlans[w],aa,0,bb,0,cc,count);
H119Space(dst,2*len+8);
for i:=0 to 2*groups-2 do
  begin
  at:=i*w;
  for j:=0 to 2*w-2 do
    begin d:=at+j; if d>=2*len-1 then break; if H119BlockBit(cc[i],j) then H119Flip(dst,d); end;
  end;
end;

{ One GF(16)[Z] product after both ternary digit evaluations. Larger
  tails use seven binary positions per extension coefficient. }
procedure H119Tail(const a,b:TH119Fields; pos,size:longint; var dst:TH119Fields; at:longint);
var i,j,k,wordIndex,raw,count:longint; value:TH119Cell; pa,pb,pc:TH119Bits;
begin
if size<=24 then
  begin
  for i:=0 to size-1 do
    for j:=0 to size-1 do
      dst[at+i+j]:=H119Add(dst[at+i+j],H119Times(a[pos+i],b[pos+j]));
  exit;
  end;
count:=7*size; H119Space(pa,count); H119Space(pb,count);
for i:=0 to size-1 do for j:=0 to 3 do
  begin
  if ((a[pos+i] and (LongWord(1) shl j))<>0) then H119Flip(pa,i*7+j);
  if ((b[pos+i] and (LongWord(1) shl j))<>0) then H119Flip(pb,i*7+j);
  end;
H119BlockConvolution(pa,pb,count,pc);
for i:=0 to 2*size-2 do
  begin
  raw:=0;
  for j:=0 to 6 do if H119Bit(pc,7*i+j) then raw:=raw or (1 shl j);
  for k:=6 downto 4 do if (raw and (1 shl k))<>0 then raw:=raw xor (19 shl (k-4));
  wordIndex:=at+i; value:=H119Field(raw); dst[wordIndex]:=value;
  end;
end;

procedure H119JetInput(const grid:TH119Fields; width,blocks:longint; var freq:TH119Fields);
const digit:array[0..3] of longint=(0,1,3,4);
var buf:TH119Batch; base,row,i,k,pos,jet,chunk:longint;
begin
SetLength(freq,15*9*blocks); base:=0;
while base<15*blocks do
  begin
  FillChar(buf,SizeOf(buf),0);
  for row:=0 to 8 do if base+row<15*blocks then
    begin
    jet:=(base+row) div blocks; chunk:=(base+row) mod blocks;
    for i:=0 to 3 do if chunk*4+i<width then buf[row,digit[i]]:=grid[jet*width+chunk*4+i];
    end;
  H119Tensor(buf,false);
  for row:=0 to 8 do if base+row<15*blocks then
    begin
    jet:=(base+row) div blocks; chunk:=(base+row) mod blocks; pos:=jet*9*blocks+chunk;
    for k:=0 to 8 do freq[pos+k*blocks]:=buf[row,k];
    end;
  inc(base,9);
  end;
end;

procedure H119JetOutput(const freq:TH119Fields; blocks,width:longint; var grid:TH119Fields);
var buf:TH119Batch; base,row,i,k,jet,chunk,pos:longint;
begin
SetLength(grid,15*width); FillChar(grid[0],Length(grid)*SizeOf(grid[0]),0); base:=0;
while base<15*blocks do
  begin
  FillChar(buf,SizeOf(buf),0);
  for row:=0 to 8 do if base+row<15*blocks then
    begin
    jet:=(base+row) div blocks; chunk:=(base+row) mod blocks;
    for k:=0 to 8 do buf[row,k]:=freq[(jet*9+k)*blocks+chunk];
    end;
  H119Tensor(buf,true);
  for row:=0 to 8 do if base+row<15*blocks then
    begin
    jet:=(base+row) div blocks; chunk:=(base+row) mod blocks;
    for i:=0 to 8 do
      begin
      pos:=chunk*4+i mod 3+2*(i div 3);
      if pos<width then grid[jet*width+pos]:=H119Add(grid[jet*width+pos],buf[row,i]);
      end;
    end;
  inc(base,9);
  end;
end;

procedure H119Pack(const src:TH119Bits; offset,len,width:longint; var grid:TH119Fields);
var i,j,k:longint;
begin
SetLength(grid,15*width);
for i:=0 to len-1 do if H119Bit(src,offset+i) then
  begin
  j:=(i div 2) div width; k:=(j mod 3+3*(j mod 5))*width+(i div 2) mod width;
  grid[k]:=H119Add(grid[k],H119Field(1 shl (i mod 2)));
  end;
end;

{ A bounded jet plan for native-size boards. Eight binary coordinates
  fit in one GF(2^16) element, so unreduced products use at most 15.
  The odd CRT grid carries jets, multiplied by a Cantor additive FFT.
  Use the scalable block circuit when a jet would exceed the field. }
type TH119F=LongWord;
type TH119FVec=array of TH119F;
type TH119IntTable=array of longint;
var h119FExp,h119FPoints:TH119FVec;
var h119FLog:TH119IntTable;
var h119FRoots:array[0..4] of TH119F;
var h119FScale1,h119FScale2:TH119FVec;


function H119FKey(const v:TH119F):longint; inline;
begin H119FKey:=longint(v); end;

function H119FValue(index:longint):TH119F; inline;
begin H119FValue:=LongWord(index); end;

function H119FBit(const v:TH119F; bit:longint):boolean; inline;
begin H119FBit:=((v shr bit) and 1)<>0; end;

function H119FAdd(const a,b:TH119F):TH119F; inline;
begin H119FAdd:=a xor b; end;

function H119FMul(const a,b:TH119F):TH119F; inline;
var i,j:longint;
begin
i:=H119FKey(a); j:=H119FKey(b);
if (i=0) or (j=0) then H119FMul:=H119FValue(0)
else H119FMul:=h119FExp[h119FLog[i]+h119FLog[j]];
end;

procedure H119FPrepare;
var i,j,x,value,first,beta:longint; roots:TH119IntTable;
begin
if Length(h119FPoints)<>0 then exit;

SetLength(h119FLog,65536); SetLength(h119FExp,131070); SetLength(roots,65536);
x:=1;
for i:=0 to 65534 do
  begin
  h119FExp[i]:=H119FValue(x); h119FExp[i+65535]:=h119FExp[i]; h119FLog[x]:=i;
  x:=x shl 1; if (x and 65536)<>0 then x:=x xor 69643;
  if (x=1) and (i<>65534) then Halt(232);
  end;
for i:=1 to 65535 do
  begin
  value:=H119FKey(h119FExp[2*h119FLog[i]]) xor i; roots[value]:=i;
  end;
SetLength(h119FPoints,65536); beta:=1; first:=1;
while first<65536 do
  begin
  if beta=0 then Halt(233);
  for j:=0 to first-1 do h119FPoints[first+j]:=H119FValue(H119FKey(h119FPoints[j]) xor beta);
  beta:=roots[beta]; first:=2*first;
  end;
SetLength(h119FScale1,65536); SetLength(h119FScale2,65536);
for i:=1 to 65535 do
  begin
  h119FScale1[i]:=h119FExp[h119FLog[i]+65535 div 3];
  h119FScale2[i]:=h119FExp[h119FLog[i]+2*(65535 div 3)];
  end;
for i:=0 to 4 do h119FRoots[i]:=h119FExp[i*(65535 div 5)];
end;

procedure H121ShortBasis(var a:TH119FVec; baseIndex,stride,dim:longint; interpolate:boolean);
var pass,level,h,base,off,i,j,k,res,count:longint; taps:array[0..15] of longint;
var v:TH119F;
begin
for pass:=0 to dim-1 do
  begin
  if interpolate then level:=pass else level:=dim-1-pass;
  h:=1 shl level; count:=0;
  for j:=0 to level-1 do if (j and level)=j then begin taps[count]:=1 shl j; inc(count); end;
  base:=0;
  while base<(1 shl dim) do
    begin
    for i:=0 to h-1 do
      begin
      if interpolate then off:=i else off:=h-1-i;
      v:=a[baseIndex+(base+h+off)*stride];
      if H119FKey(v)<>0 then for k:=0 to count-1 do
        begin res:=baseIndex+(base+off+taps[k])*stride; a[res]:=H119FAdd(a[res],v); end;
      end;
    inc(base,2*h);
    end;
  end;
end;

procedure H121JetPascal(var a:TH119FVec; dim:longint);
var half,base,j,count:longint;
begin
count:=1 shl dim; half:=1;
while half<count do
  begin
  base:=0;
  while base<count do
    begin
    for j:=base to base+half-1 do a[j]:=H119FAdd(a[j],a[j+half]);
    inc(base,2*half);
    end;
  half:=2*half;
  end;
end;

procedure H121JetTaylor(var a:TH119FVec; base,stride,dim,h:longint; inverse:boolean);
var p:TH119FVec; low,high,period,total,d,size,passDim,j,pos,last:longint;
var carry,value:LongWord; extra:boolean;
begin
if dim<=h then exit;
low:=1 shl h; high:=1 shl (dim-h); period:=low-1; total:=1 shl dim;
SetLength(p,high*2);
for d:=0 to period-1 do
  begin
  size:=(total-1-d) div period+1; passDim:=dim-h;
  if size>high then inc(passDim);
  FillChar(p[0],(1 shl passDim)*SizeOf(p[0]),0);
  extra:=(high=low) and (d=0);
  if inverse then
    begin
    pos:=base+d*stride;
    for j:=0 to size-1 do begin p[j]:=a[pos]; inc(pos,period*stride); end;
    H121JetPascal(p,passDim);
    if extra then
      begin
      value:=p[high+1];
      p[high-1]:=H119FAdd(p[high-1],value);
      a[base+(total-1)*stride]:=value;
      end;
    carry:=H119FValue(0);
    for j:=high-1 downto d do
      begin
      carry:=H119FAdd(carry,p[j+1]);
      a[base+(j*low+d-j+period)*stride]:=carry;
      end;
    last:=d; if last>=high then last:=high-1;
    for j:=0 to last do
      begin
      value:=p[j];
      if j=d then value:=H119FAdd(value,carry);
      a[base+(j*low+d-j)*stride]:=value;
      end;
    end
  else
    begin
    last:=d; if last>=high then last:=high-1;
    for j:=0 to last do p[j]:=a[base+(j*low+d-j)*stride];
    for j:=d to high-1 do
      begin
      value:=a[base+(j*low+d-j+period)*stride];
      p[j]:=H119FAdd(p[j],value);
      p[j+1]:=H119FAdd(p[j+1],value);
      end;
    if extra then
      begin
      value:=a[base+(total-1)*stride];
      p[high-1]:=H119FAdd(p[high-1],value);
      p[high+1]:=H119FAdd(p[high+1],value);
      end;
    H121JetPascal(p,passDim); pos:=base+d*stride;
    for j:=0 to size-1 do begin a[pos]:=p[j]; inc(pos,period*stride); end;
    end;
  end;
end;

procedure H121JetConvert(var a:TH119FVec; base,stride,dim:longint; inverse:boolean);
var h,g,lowCount,highCount,p:longint;
begin
if dim<=4 then begin H121ShortBasis(a,base,stride,dim,not inverse); exit; end;
h:=1; while h*2<dim do h:=h*2;
g:=dim-h; lowCount:=1 shl h; highCount:=1 shl g;
if inverse then H121JetTaylor(a,base,stride,dim,h,true);
for p:=0 to highCount-1 do H121JetConvert(a,base+p*lowCount*stride,stride,h,inverse);
for p:=0 to lowCount-1 do H121JetConvert(a,base+p*stride,stride*lowCount,g,inverse);
if not inverse then H121JetTaylor(a,base,stride,dim,h,false);
end;

procedure H119FTransform(var a:TH119FVec; dim:longint; inverse:boolean; affineBase:longint=0);
var pass,level,h,base,i:longint; lo,hi,alpha:TH119F;
begin
if not inverse then H121JetConvert(a,0,1,dim,true);
for pass:=0 to dim-1 do
  begin
  if inverse then level:=pass else level:=dim-1-pass;
  h:=1 shl level; base:=0;
  while base<Length(a) do
    begin
    alpha:=h119FPoints[(base+affineBase) shr level];
    for i:=base to base+h-1 do
      begin
      lo:=a[i]; hi:=a[i+h];
      if inverse then begin hi:=H119FAdd(hi,lo); lo:=H119FAdd(lo,H119FMul(hi,alpha)); end
      else begin lo:=H119FAdd(lo,H119FMul(hi,alpha)); hi:=H119FAdd(hi,lo); end;
      a[i]:=lo; a[i+h]:=hi;
      end;
    inc(base,2*h);
    end;
  end;
if inverse then H121JetConvert(a,0,1,dim,false);
end;

type TH119FGrid=array[0..14] of TH119FVec;

procedure H119FGridTransform(var grid:TH119FGrid; axes,pitch:longint; inverse:boolean);
var base,k,i,j:longint; src:array[0..4] of TH119F; a:TH119F;
begin
if axes=3 then exit;
for base:=0 to 2 do for k:=0 to pitch-1 do
  begin
  for i:=0 to 4 do src[i]:=grid[base+3*i,k];
  for i:=0 to 4 do
    begin
    a:=src[0];
    for j:=1 to 4 do a:=H119FAdd(a,H119FMul(src[j],h119FRoots[(i*j) mod 5]));
    if inverse then grid[base+3*((5-i) mod 5),k]:=a else grid[base+3*i,k]:=a;
    end;
  end;
end;

procedure H119FLoad(const src:TH119Bits; offset,len,width,count,axes:longint; var grid:TH119FGrid);
var i,bit,k,at,digit,id:longint;
begin
for i:=0 to axes-1 do SetLength(grid[i],count);
for i:=0 to (len-1) div 8 do
  begin
  id:=0; at:=i*8;
  for bit:=0 to 7 do if (at+bit<len) and H119Bit(src,offset+at+bit) then id:=id or (1 shl bit);
  digit:=i div width; k:=digit mod 3; if axes=15 then inc(k,3*(digit mod 5));
  grid[k,i mod width]:=H119FValue(id);
  end;
end;

{ The low binary jet digit and the CRT axis of order three share the
  same 3 by 3 tensor. The predictor, two checks and repair are the
  identical GF(4)-linear operations used by the smaller-field plan. }
type TH119FLine=array[0..8] of TH119F;
type TH119FBatch=array[0..8] of TH119FLine;
type TH119FSum=array[0..2] of TH119F;
type TH119FFreq=array[0..44] of TH119FVec;

function H119FScale(const a:TH119F; const c:TH119Cell):TH119F;
begin
case H119Index(c) of
  0:H119FScale:=H119FValue(0);
  1:H119FScale:=a;
  6:H119FScale:=h119FScale1[H119FKey(a)];
else H119FScale:=h119FScale2[H119FKey(a)];
end;
end;

procedure H119FPrediction(const src:TH119FLine; beta:longint; var dst:TH119FLine);
var rows,cols:TH119FSum; total,common:TH119F; i,j,k:longint;
begin
for j:=0 to 2 do
  begin
  rows[j]:=H119FAdd(H119FAdd(src[j*3],src[j*3+1]),src[j*3+2]);
  cols[j]:=H119FAdd(H119FAdd(src[j],src[j+3]),src[j+6]);
  end;
total:=H119FScale(H119FAdd(H119FAdd(rows[0],rows[1]),rows[2]),h119Predict[beta,3]);
for j:=0 to 2 do cols[j]:=H119FScale(cols[j],h119Predict[beta,2]);
for j:=0 to 2 do
  begin
  common:=H119FAdd(total,H119FScale(rows[j],h119Predict[beta,1]));
  for i:=0 to 2 do
    begin k:=3*j+i; dst[k]:=H119FAdd(H119FAdd(common,cols[i]),H119FScale(src[k],h119Predict[beta,0])); end;
  end;
end;

{ Ordinary transforms only on the two parity-check rows. }
procedure H119FCheckDFT(var a:TH119FLine; inverse:boolean);
var stride,base,offset,i,j:longint; omega:TH119Cell; first,last,pair,middle:TH119F;
begin
if inverse then omega:=H119Omega(-1) else omega:=H119Omega(1);
stride:=1;
while stride<=3 do
  begin
  base:=0;
  while base<9 do
    begin
    for offset:=0 to stride-1 do
      begin
      i:=base+offset; j:=i+stride; first:=a[i]; last:=a[j+stride];
      pair:=H119FAdd(a[j],last);
      middle:=H119FAdd(H119FAdd(first,last),H119FScale(pair,omega));
      a[i]:=H119FAdd(first,pair); a[j]:=middle; a[j+stride]:=H119FAdd(middle,pair);
      end;
    inc(base,3*stride);
    end;
  stride:=stride*3;
  end;
end;

{ In the two-axis ternary tensor, a frequency (u,v) has one exceptional
  row beta. Each beta digit is 2 for a zero frequency and 0 for a
  nonzero one. The four supports are Cartesian products of the zero
  frequency and the pair of nonzero frequencies. The two summed checks already give the entire error on the
  corresponding row. Interpolate each support separately. }
procedure H119FTensor(var a:TH119FBatch; inverse:boolean);
const affected:array[0..3] of longint=(0,2,6,8);
var pred:TH119FBatch; hx,hp:TH119FLine; hor:array[0..2] of TH119FSum;
    vert,both:TH119FSum; omega:TH119Cell; row,i,j,k,pos:longint;
procedure InversePair(const u,v:TH119F; var dst:TH119FSum); inline;
begin
dst[0]:=H119FAdd(u,v);
dst[1]:=H119FAdd(u,H119FScale(dst[0],omega));
dst[2]:=H119FAdd(dst[0],dst[1]);
end;
begin
FillChar(hx,SizeOf(hx),0); FillChar(hp,SizeOf(hp),0);
omega:=H119Omega(1);
for i:=0 to 8 do
  if (i mod 3=1) or (i div 3=1) then H119FCheckDFT(a[i],inverse)
  else
    begin
    for j:=0 to 8 do a[i,j]:=H119FScale(a[i,j],h119Chirp[j]);
    H119FPrediction(a[i],i,pred[i]);
    for j:=0 to 8 do
      begin hx[j]:=H119FAdd(hx[j],a[i,j]); hp[j]:=H119FAdd(hp[j],pred[i,j]); end;
    end;
H119FCheckDFT(hx,false); H119FCheckDFT(hp,false);
for j:=0 to 8 do hp[j]:=H119FAdd(hp[j],H119FScale(hx[j],h119Eigen[j]));
for j:=0 to 2 do InversePair(hp[3*j+1],hp[3*j+2],hor[j]);
InversePair(hp[3],hp[6],vert);
for i:=0 to 2 do
  begin
  InversePair(hor[1,i],hor[2,i],both);
  for j:=0 to 2 do
    begin
    pos:=3*j+i;
    pred[0,pos]:=H119FAdd(pred[0,pos],both[j]);
    pred[2,pos]:=H119FAdd(pred[2,pos],vert[j]);
    pred[6,pos]:=H119FAdd(pred[6,pos],hor[0,i]);
    pred[8,pos]:=H119FAdd(pred[8,pos],hp[0]);
    end;
  end;
for i:=0 to 3 do
  begin
  row:=affected[i];
  for j:=0 to 8 do
    begin
    k:=j; if inverse then k:=(3-j mod 3) mod 3+3*((3-j div 3) mod 3);
    a[row,k]:=H119FScale(pred[row,j],h119Chirp[j]);
    end;
  end;
end;

procedure H119FLift(const grid:TH119FGrid; axes,width,chunks,count:longint; var freq:TH119FFreq);
var buf:TH119FBatch; base,top,row,g,h,i,j,k:longint;
begin
for i:=0 to 3*axes-1 do SetLength(freq[i],count);
base:=0; top:=(axes div 3)*chunks;
while base<top do
  begin
  FillChar(buf,SizeOf(buf),0);
  for row:=0 to 8 do if base+row<top then
    begin
    g:=(base+row) div chunks; h:=(base+row) mod chunks;
    for i:=0 to 2 do for j:=0 to 1 do
      if 2*h+j<width then buf[row,i+3*j]:=grid[3*g+i,2*h+j];
    end;
  H119FTensor(buf,false);
  for row:=0 to 8 do if base+row<top then
    begin
    g:=(base+row) div chunks; h:=(base+row) mod chunks;
    for k:=0 to 8 do freq[9*g+k,h]:=buf[row,k];
    end;
  inc(base,9);
  end;
end;

procedure H119FCollect(const freq:TH119FFreq; axes,width,chunks:longint; var grid:TH119FGrid);
var buf:TH119FBatch; base,top,row,g,h,i,j,k,pos:longint;
begin
for i:=0 to axes-1 do
  begin SetLength(grid[i],width); FillChar(grid[i,0],width*SizeOf(TH119F),0); end;
base:=0; top:=(axes div 3)*chunks;
while base<top do
  begin
  FillChar(buf,SizeOf(buf),0);
  for row:=0 to 8 do if base+row<top then
    begin
    g:=(base+row) div chunks; h:=(base+row) mod chunks;
    for k:=0 to 8 do buf[row,k]:=freq[9*g+k,h];
    end;
  H119FTensor(buf,true);
  for row:=0 to 8 do if base+row<top then
    begin
    g:=(base+row) div chunks; h:=(base+row) mod chunks;
    for i:=0 to 2 do for j:=0 to 2 do
      begin
      pos:=2*h+j;
      if pos<width then grid[3*g+i,pos]:=H119FAdd(grid[3*g+i,pos],buf[row,i+3*j]);
      end;
    end;
  inc(base,9);
  end;
end;

{ The multiplicative group of GF(2^16) has order 3*5*17*257.
  CRT digit order is used on both sides of every pointwise product.
  Thus neither twiddles nor monomial-to-additive basis conversion are
  required for a variable-length jet. A norm-one torus handles radix 257. }
const h122Lengths:array[0..15] of longint=(1,3,5,15,17,51,85,255,257,771,1285,3855,4369,13107,21845,65535);
      h122Primes:array[0..3] of longint=(3,5,17,257);
type TH122TransformPlan=record
  perm:array of longint;
  radix:array[0..3] of longint;
  levels:longint;
  end;
var h122Plans:array[0..15] of TH122TransformPlan;
    h122Roots:array[0..16,0..16] of TH119F;
    h122Five:array[0..4,0..4] of TH119F;
    h122TorusScale:TH119FVec; h122TorusSlot:array[0..255] of longint;
    h122Root3:TH119F;

procedure H122InitLengths(index:longint);
var i,j,np,r,stride,total,logRoot:longint; z,one,conjugate,u:TH119F;
begin
with h122Plans[index] do
  begin
  if Length(perm)<>0 then exit;
  total:=h122Lengths[index]; SetLength(perm,total);
  stride:=1;
  for np:=0 to 3 do
    begin
    r:=h122Primes[np]; if total mod r<>0 then continue;
    radix[levels]:=r; inc(levels);
    for i:=0 to total-1 do inc(perm[i],(i mod r)*stride);
    stride:=stride*r;
    end;
  end;
if H119FKey(h122Root3)=0 then
  begin
  h122Root3:=h119FExp[65535 div 3];
  for i:=0 to 4 do for j:=0 to 4 do h122Five[i,j]:=h119FExp[(65535 div 5)*(i*j mod 5)];
  for i:=0 to 16 do for j:=0 to 16 do h122Roots[i,j]:=h119FExp[(65535 div 17)*(i*j mod 17)];
  end;
if (h122Lengths[index] mod 257=0) and (Length(h122TorusScale)=0) then
  begin
  { Cantor affine coset z^256=z+1; u=1+1/z covers the 256
    nontrivial norm-one roots. F(z)/z^256 evaluates the original P(u). }
  SetLength(h122TorusScale,256); one:=H119FValue(1);
  for i:=0 to 255 do
    begin
    z:=h119FPoints[256+i]; conjugate:=H119FAdd(z,one);
    u:=H119FAdd(one,h119FExp[65535-h119FLog[H119FKey(z)]]);
    logRoot:=h119FLog[H119FKey(u)];
    if (logRoot=0) or (logRoot mod 255<>0) then Halt(234);
    h122TorusSlot[i]:=logRoot div 255;
    h122TorusScale[i]:=h119FExp[65535-h119FLog[H119FKey(conjugate)]];
    end;
  end;
end;

procedure H122PrimeDFT(var v:TH119FVec; first,step,r:longint; var a:TH119FVec; inverse:boolean);
var i,j,k:longint; dc,origin,s,t:TH119F;
begin
if r=3 then
  begin
  origin:=v[first]; s:=H119FAdd(v[first+step],v[first+2*step]);
  t:=H119FAdd(H119FAdd(origin,v[first+2*step]),H119FMul(h122Root3,s));
  v[first]:=H119FAdd(origin,s);
  if inverse then begin v[first+step]:=H119FAdd(t,s); v[first+2*step]:=t; end
  else begin v[first+step]:=t; v[first+2*step]:=H119FAdd(t,s); end;
  exit;
  end;
origin:=v[first]; dc:=origin;
if r=257 then
  begin
  for i:=0 to 255 do a[i]:=v[first+i*step];
  H121JetPascal(a,8);
  t:=v[first+256*step]; dc:=H119FAdd(a[0],t);
  { h(Y)=P(1+Y); reverse its 257 coefficients and fold the top
    coefficient with z^256=z+1 before evaluating on the affine coset. }
  for i:=1 to 127 do begin s:=a[i]; a[i]:=a[256-i]; a[256-i]:=s; end;
  a[0]:=H119FAdd(t,dc); a[1]:=H119FAdd(a[1],dc);
  H119FTransform(a,8,false,256);
  for i:=0 to 255 do
    begin
    k:=h122TorusSlot[i]; if inverse then k:=257-k;
    v[first+k*step]:=H119FMul(a[i],h122TorusScale[i]);
    end;
  end
else
  begin
  for j:=1 to r-1 do begin a[j]:=v[first+j*step]; dc:=H119FAdd(dc,a[j]); end;
  for i:=1 to r-1 do
    begin
    s:=origin;
    if r=5 then for j:=1 to 4 do s:=H119FAdd(s,H119FMul(a[j],h122Five[i,j]))
    else for j:=1 to 16 do s:=H119FAdd(s,H119FMul(a[j],h122Roots[i,j]));
    k:=i; if inverse then k:=r-i; v[first+k*step]:=s;
    end;
  end;
v[first]:=dc;
end;

procedure H122JetDFT(var a:TH119FVec; dim,index:longint; inverse:boolean);
var v,buf:TH119FVec; l,i,j,r,stride,base,count:longint;
begin
if index=0 then begin H119FTransform(a,dim,inverse); exit; end;
H122InitLengths(index);
with h122Plans[index] do
  begin
  count:=Length(perm); SetLength(v,count); SetLength(buf,256);
  if inverse then Move(a[0],v[0],count*SizeOf(v[0]))
  else for i:=0 to count-1 do v[perm[i]]:=a[i];
  stride:=1;
  for l:=0 to levels-1 do
    begin
    r:=radix[l]; base:=0;
    while base<count do
      begin
      for j:=0 to stride-1 do H122PrimeDFT(v,base+j,stride,r,buf,inverse);
      inc(base,r*stride);
      end;
    stride:=stride*r;
    end;
  if inverse then for i:=0 to count-1 do a[i]:=v[perm[i]]
  else a:=v;
  end;
end;

type TH121JetPlan=record axes,width,blocks,count,dim,oddIndex:longint; end;

procedure H121JetPlan(span:longint; out plan:TH121JetPlan);
var chunks,half,need:longint;
begin
chunks:=(span+7) div 8;
with plan do
  begin
  if chunks<=65536 then axes:=3 else axes:=15;
  half:=(axes+1) div 2; width:=(chunks+half-1) div half;
  blocks:=(width+1) div 2; count:=1; dim:=0;
  need:=2*blocks-1; while count<need do begin count:=count*2; inc(dim); end;
  oddIndex:=0;
  if (need>2048) and (need<=65535) then
    begin
    oddIndex:=1; while h122Lengths[oddIndex]<need do inc(oddIndex);
    count:=h122Lengths[oddIndex];
    end;
  end;
end;

procedure H121JetLift(const src:TH119Bits; offset,len:longint;
                     const plan:TH121JetPlan; out freq:TH119FFreq);
var grid:TH119FGrid;
begin
with plan do
  begin
  H119FLoad(src,offset,len,width,width,axes,grid);
  H119FGridTransform(grid,axes,width,false);
  H119FLift(grid,axes,width,blocks,count,freq);
  end;
end;

procedure H121JetStore(const freq:TH119FFreq; const plan:TH121JetPlan;
                      var dst:TH119Bits; off,used:longint);
var grid:TH119FGrid; i,j,k,at,bit:longint; v:TH119F;
begin
with plan do
  begin
  H119FCollect(freq,axes,2*width-1,2*blocks-1,grid);
  H119FGridTransform(grid,axes,2*width-1,true);
  for i:=0 to axes-1 do
    begin
    k:=i mod 3; if axes=15 then inc(k,3*(i mod 5));
    for j:=0 to 2*width-2 do
      begin
      at:=8*(width*i+j); if at>=used then break;
      v:=grid[k,j];
      if H119FKey(v)<>0 then for bit:=0 to 14 do
        if (at+bit<used) and H119FBit(v,bit) then H119Flip(dst,off+at+bit);
      end;
    end;
  end;
end;

procedure H119FiniteProduct(const a:TH119Bits; ao:longint; const b:TH119Bits; bo:longint;
                            var dst:TH119Bits; off,alen,blen,used:longint);
var fa,fb:TH119FFreq; plan:TH121JetPlan; i,j:longint;
begin
H119InitTables; H119FPrepare;
if alen>blen then H121JetPlan(alen,plan) else H121JetPlan(blen,plan);
H121JetLift(a,ao,alen,plan,fa); H121JetLift(b,bo,blen,plan,fb);
for i:=0 to 3*plan.axes-1 do
  begin
  H122JetDFT(fa[i],plan.dim,plan.oddIndex,false); H122JetDFT(fb[i],plan.dim,plan.oddIndex,false);
  for j:=0 to plan.count-1 do fa[i,j]:=H119FMul(fa[i,j],fb[i,j]);
  fb[i]:=nil; H122JetDFT(fa[i],plan.dim,plan.oddIndex,true);
  end;
H121JetStore(fa,plan,dst,off,used);
end;


{ The grouped root-field FFT handles arbitrary lengths. The finite-field
  kernel is faster within its native range; spectral can force this kernel
  earlier for comparison. Offsets and truncation are measured in bits. }
procedure H120PackedProduct(const a:TH119Bits; ao:longint; const b:TH119Bits; bo:longint;
                            var dst:TH119Bits; off,alen,blen,used:longint);
var left,right,prod:TH119Bits; span,i:longint;
begin
span:=alen; if blen>span then span:=blen;
H119Space(left,span); H119Space(right,span);
for i:=0 to alen-1 do if H119Bit(a,ao+i) then H119Flip(left,i);
for i:=0 to blen-1 do if H119Bit(b,bo+i) then H119Flip(right,i);
H119BlockConvolution(left,right,span,prod);
for i:=0 to used-1 do if H119Bit(prod,i) then H119Flip(dst,off+i);
end;

{ Offsets are in bits; accumulate the low lim coefficients by XOR. }
procedure H119Product(const a:TH119Bits; ao:longint; const b:TH119Bits; bo:longint;
                      var dst:TH119Bits; off,alen,blen,lim:longint);
var ga,gb,fa,fb,fc:TH119Fields;
var span,r,width,blocks,cb,jet,j,i,bit,k,pos,used:longint;
begin
if (alen<=0) or (blen<=0) or (lim<=0) then exit;
if alen>lim then alen:=lim;
if blen>lim then blen:=lim;
used:=alen+blen-1; if used>lim then used:=lim;
span:=alen; if blen>span then span:=blen;
if (span<=96) or (alen<=4) or (blen<=4) then
  begin
  for i:=0 to alen-1 do if H119Bit(a,ao+i) then
    begin
    k:=blen; if i+k>used then k:=used-i;
    for j:=0 to k-1 do if H119Bit(b,bo+j) then H119Flip(dst,off+i+j);
    end;
  exit;
  end;
if not h119AllDFT and ((span>2097152) or ((h102Force=7) and (span>=131072))) then
  begin H120PackedProduct(a,ao,b,bo,dst,off,alen,blen,used); exit; end;
if not h119AllDFT and (span>=1024) and (span<=2097152) then
  begin H119FiniteProduct(a,ao,b,bo,dst,off,alen,blen,used); exit; end;
H119InitTables;
r:=(8*span+59) div 60; width:=(r+1) div 2; blocks:=(width+3) div 4; cb:=2*blocks-1;
H119Pack(a,ao,alen,width,ga); H119Pack(b,bo,blen,width,gb);
H119Grid(ga,width,false); H119Grid(gb,width,false);
H119JetInput(ga,width,blocks,fa); H119JetInput(gb,width,blocks,fb);
SetLength(ga,0); SetLength(gb,0); SetLength(fc,135*cb);
for j:=0 to 134 do H119Tail(fa,fb,j*blocks,blocks,fc,j*cb);
SetLength(fa,0); SetLength(fb,0);
H119JetOutput(fc,cb,r,ga); SetLength(fc,0); H119Grid(ga,r,true);
for jet:=0 to 14 do
  begin
  k:=(jet mod 3+3*(jet mod 5))*r;
  for j:=0 to r-1 do
    begin
    pos:=2*(width*jet+j); if pos>=used then break;
    for bit:=0 to 3 do if (pos+bit<used) and ((ga[k+j] and (LongWord(1) shl bit))<>0) then H119Flip(dst,off+pos+bit);
    end;
  end;
end;

procedure H114ToomProductW(const a:TWordArray; ao:longint; const b:TWordArray; bo:longint;
                          var r:TWordArray; ro,alen,blen,lim:longint); forward;
procedure FFTProductW(const a:TWordArray; ao:longint;
                       const b:TWordArray; bo:longint; var r:TWordArray;
                       ro,alen,blen,lim:longint);
var aa,bb,cc:TWordArray;
var count,i,used:longint;
begin
if h102Backend=7 then begin H119Product(a,ao shl 5,b,bo shl 5,r,ro shl 5,alen,blen,lim); exit; end;
if h102Backend=6 then begin H114ToomProductW(a,ao,b,bo,r,ro,alen,blen,lim); exit; end;
if (alen<=0) or (blen<=0) or (lim<=0) then exit;
{ Forced NTT modes reject unsupported lengths instead of mixing backends. }
if (h102Force in [3,4,5]) and (Int64(alen)+blen-1>nttMaxLen) then Halt(219);
{ H111: all general large products use the packed additive backend. }
if (h102Backend=5) and (Int64(alen)+blen-1<=nttMaxLen) then
  begin H111ProductW(a,ao,b,bo,r,ro,alen,blen,lim); exit; end;
{ Automatic mode retains the original exact FFT fallback. }
if (h102Backend in [3,4,5]) and (Int64(alen)+blen-1<=nttMaxLen) then
  begin NTTProductW(a,ao,b,bo,r,ro,alen,blen,lim); exit; end;
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
procedure H114ToomProductW(const a:TWordArray; ao:longint; const b:TWordArray; bo:longint;
                          var r:TWordArray; ro,alen,blen,lim:longint);
var temp:TWordArray; used,i:longint;
begin
if (alen<=0) or (blen<=0) or (lim<=0) then exit;
if alen>lim then alen:=lim; if blen>lim then blen:=lim;
SetLength(temp,(alen+blen+31) shr 5);
Toom3W(a,ao,b,bo,temp,0,alen,blen);
used:=alen+blen-1; if used>lim then used:=lim;
for i:=0 to (used shr 5)-1 do r[ro+i]:=r[ro+i] xor temp[i];
if (used and 31)<>0 then r[ro+(used shr 5)]:=r[ro+(used shr 5)] xor
  (temp[used shr 5] and (LongWord($FFFFFFFF) shr ((-used) and 31)));
end;
procedure H114ToomPairW(const a:TWordArray; ao:longint; const b:TWordArray; bo:longint;
                       const c:TWordArray; co:longint; var r:TWordArray; ro:longint;
                       var s:TWordArray; so,alen,blen,clen,lim:longint);
var aa,bb,cc:TWordArray;
begin
if (alen<=0) or ((blen<=0) and (clen<=0)) or (lim<=0) then exit;
if alen>lim then alen:=lim; if blen>lim then blen:=lim; if clen>lim then clen:=lim;
aa:=Copy(a,ao,(alen+31) shr 5);
if blen>0 then bb:=Copy(b,bo,(blen+31) shr 5);
if clen>0 then cc:=Copy(c,co,(clen+31) shr 5);
H114ToomProductW(aa,0,bb,0,r,ro,alen,blen,lim);
H114ToomProductW(aa,0,cc,0,s,so,alen,clen,lim);
end;


{ H100: four blocks and seven products over GF(2)[t].
  Evaluate at 0,1,t,t+1,t^2,t^2+1,infinity; interpolate exactly.
  Pure recursive Toom-4 has T(N)=7*T(N/4+O(1))+O(N).
  This hybrid only uses its measured beneficial band, not that global bound.
  Each denominator factors into t, t+1, and t^2+t+1.
  Division by t^2+t+1 uses (1+t)/(1+t^3), cancelling shared factors.
  Boolean and packed versions use the same identities and cutoff. }
{ Logical coefficient lengths; both operands must be in this band. }
const toom4Cut=24576;
const toom4Max=36864;

procedure T4AddW(const a:TWordArray; ao,count:longint; var dst:TWordArray; mask:LongWord);
var shift,i:longint;
begin
shift:=0;
while mask<>0 do
  begin
  if (mask and 1)<>0 then
    begin
    if shift=0 then
      for i:=0 to count-1 do dst[i]:=dst[i] xor a[ao+i]
    else
      for i:=0 to count-1 do
        begin
        dst[i]:=dst[i] xor (a[ao+i] shl shift);
        dst[i+1]:=dst[i+1] xor (a[ao+i] shr (32-shift));
        end;
    end;
  inc(shift); mask:=mask shr 1;
  end;
end;

procedure T4DivBinW(var a:TWordArray; step:longint);
var i:longint; carry,v:LongWord;
begin
carry:=0;
case step of
  1:for i:=0 to High(a) do
    begin
    v:=a[i] xor carry;
    v:=v xor (v shl 1); v:=v xor (v shl 2); v:=v xor (v shl 4);
    v:=v xor (v shl 8); v:=v xor (v shl 16);
    a[i]:=v; carry:=v shr 31;
    end;
  2:for i:=0 to High(a) do
    begin
    v:=a[i] xor carry;
    v:=v xor (v shl 2); v:=v xor (v shl 4);
    v:=v xor (v shl 8); v:=v xor (v shl 16);
    a[i]:=v; carry:=v shr 30;
    end;
  3:for i:=0 to High(a) do
    begin
    v:=a[i] xor carry;
    v:=v xor (v shl 3); v:=v xor (v shl 6);
    v:=v xor (v shl 12); v:=v xor (v shl 24);
    a[i]:=v; carry:=v shr 29;
    end;
  end;
end;

procedure Toom4W(const a:TWordArray; ao:longint; const b:TWordArray; bo:longint;
                  var r:TWordArray; ro,alen,blen:longint);
const nums:array[0..4,0..4] of LongWord=(
  (108,60,40,5,4),
  (126,250,132,29,26),
  (19,18,18,1,1),
  (0,10,12,5,4),
  (7,6,6,1,1));
const shift0:array[0..4] of longint=(2,3,3,3,3);
const ones:array[0..4] of longint=(1,2,3,2,2);
const thirds:array[0..4] of longint=(1,1,0,1,1);
const powers:array[0..4,0..3] of LongWord=(
  (1,1,1,1),
  (1,2,4,8),
  (1,3,5,15),
  (1,4,16,64),
  (1,5,17,85));
const highPowers:array[0..4] of LongWord=(1,64,85,4096,4369);
var aa,bb,ea,eb,p0,p6,tmp,work:TWordArray;
var products:array[0..4] of TWordArray;
var k,l,top,i,j,h,al,bl,count,lim,step,exponent:longint;
begin
top:=alen; if blen>top then top:=blen;
k:=((top+127) div 128)*1; l:=k+1;
SetLength(aa,k*4); SetLength(bb,k*4);
Move(a[ao],aa[0],((alen+31) shr 5)*4); Move(b[bo],bb[0],((blen+31) shr 5)*4);
if (alen and 31)<>0 then aa[alen shr 5]:=aa[alen shr 5] and (LongWord($FFFFFFFF) shr ((-alen) and 31));
if (blen and 31)<>0 then bb[blen shr 5]:=bb[blen shr 5] and (LongWord($FFFFFFFF) shr ((-blen) and 31));
SetLength(ea,l); SetLength(eb,l); SetLength(p0,l*2); SetLength(p6,l*2);
SetLength(work,l*5); count:=l*2; SetLength(tmp,count+1);
al:=alen; if al>k*32 then al:=k*32; bl:=blen; if bl>k*32 then bl:=k*32;
KarConvW(aa,0,bb,0,p0,0,k*32 div 32,al,bl,work,0);
al:=alen-k*96; bl:=blen-k*96;
KarConvW(aa,k*3,bb,k*3,p6,0,k*32 div 32,al,bl,work,0);
for j:=0 to 4 do
  begin
  FillChar(ea[0],l*4,0); FillChar(eb[0],l*4,0);
  for h:=0 to 3 do
    begin
    T4AddW(aa,h*k,k,ea,powers[j,h]); T4AddW(bb,h*k,k,eb,powers[j,h]);
    end;
  SetLength(products[j],count+1);
  al:=KarTrimTopW(ea,0,k*32+6); bl:=KarTrimTopW(eb,0,k*32+6);
  KarConvW(ea,0,eb,0,products[j],0,l*32 div 32,al,bl,work,0);
  T4AddW(p0,0,count,products[j],1); T4AddW(p6,0,count,products[j],highPowers[j]);
  end;
lim:=(alen+blen-2) div 32+1;
for i:=0 to k*2-1 do
  begin
  if i<lim then r[ro+i]:=r[ro+i] xor p0[i];
  if 6*k+i<lim then r[ro+6*k+i]:=r[ro+6*k+i] xor p6[i];
  end;
for h:=0 to 4 do
  begin
  FillChar(tmp[0],Length(tmp)*4,0);
  for j:=0 to 4 do T4AddW(products[j],0,count,tmp,nums[h,j]);
  for i:=0 to High(tmp)-1 do tmp[i]:=(tmp[i] shr shift0[h]) xor (tmp[i+1] shl (32-shift0[h]));
  tmp[High(tmp)]:=tmp[High(tmp)] shr shift0[h];
  exponent:=ones[h]; step:=1;
  while exponent<>0 do
    begin
    if (exponent and 1)<>0 then T4DivBinW(tmp,step);
    step:=step shl 1; exponent:=exponent shr 1;
    end;
  if thirds[h]<>0 then T4DivBinW(tmp,3);
  for i:=0 to k*2-1 do
    if (h+1)*k+i<lim then r[ro+(h+1)*k+i]:=r[ro+(h+1)*k+i] xor tmp[i];
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
if (h102Backend<>0) and H102Transform(alen,blen,fftCut) then
  begin FFTProductW(a,ao,b,bo,r,ro,alen,blen,alen+blen-1); exit; end;
if (h102Backend<>1) and ((h102Backend=0) or (h102Force=0)) and ((alen>toomCut) or (blen>toomCut)) then
  begin
  if H102Transform(alen,blen,fftCut) then FFTProductW(a,ao,b,bo,r,ro,alen,blen,alen+blen-1)
  else if (alen>toom4Cut) and (blen>toom4Cut) and (alen<=toom4Max) and (blen<=toom4Max) then Toom4W(a,ao,b,bo,r,ro,alen,blen)
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
if (h102Backend<>0) and H102Transform(alen,blen,fftCut) then
  begin FFTProductW(a,ao,b,bo,r,ro,alen,blen,alen+blen-1); exit; end;
if (h102Backend<>1) and ((h102Backend=0) or (h102Force=0)) and ((alen>toomCut) or (blen>toomCut)) then
  begin
  if H102Transform(alen,blen,fftCut) then FFTProductW(a,ao,b,bo,r,ro,alen,blen,alen+blen-1)
  else if (alen>toom4Cut) and (blen>toom4Cut) and (alen<=toom4Max) and (blen<=toom4Max) then Toom4W(a,ao,b,bo,r,ro,alen,blen)
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
if H102Transform(alen,blen,fftCut) then
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
if (h102Backend=6) and H102Transform(alen,H102Max(blen,clen),fftCut) then
  begin H114ToomPairW(a,ao,b,bo,c,co,r,ro,s,so,alen,blen,clen,lenWords*64); exit; end;
if (h102Backend=5) and H102Transform(alen,H102Max(blen,clen),fftCut) and
   (Int64(alen)+blen-1<=nttMaxLen) and (Int64(alen)+clen-1<=nttMaxLen) then
  begin
  H111ProductPairW(a,ao,b,bo,c,co,r,ro,s,so,alen,blen,clen,lenWords*64);
  exit;
  end;
if (h102Backend in [3,4,5]) and (h102Backend<>5) and H102Transform(alen,H102Max(blen,clen),fftCut) and
   (Int64(alen)+blen-1<=nttMaxLen) and (Int64(alen)+clen-1<=nttMaxLen) then
  begin
  NTTProductPairW(a,ao,b,bo,c,co,r,ro,s,so,alen,blen,clen,lenWords*64);
  exit;
  end;
if (h102Backend<>0) and H102Transform(alen,H102Max(blen,clen),fftCut) then
  begin
  FFTProductW(a,ao,b,bo,r,ro,alen,blen,alen+blen-1);
  FFTProductW(a,ao,c,co,s,so,alen,clen,alen+clen-1);
  exit;
  end;
if (h102Backend<>1) and ((h102Backend=0) or (h102Force=0)) and ((alen>toomCut) or (blen>toomCut) or (clen>toomCut)) then
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
var qTop:longint;

procedure HPWAlloc(out a:THPolyW; count:longint); inline;
begin
a.d:=-1; a.cap:=count;
if count<=0 then begin a.v:=nil; exit; end;
if qTop+count>Length(qPool) then Halt(217);
a.v:=PHBuffer(@qPool[qTop]);
FillChar(a.v^[0],count*SizeOf(LongWord),0);
inc(qTop,count);
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
if (h102Backend=6) and H102Transform(alen,H102Max(blen,clen),fftCut) then
  begin H114ToomPairW(a,ao,b,bo,c,co,r,ro,s,so,alen,blen,clen,lim); exit; end;
if H102Transform(alen,H102Max(blen,clen),fftCut) then
  begin
  if (h102Backend=5) and (Int64(alen)+blen-1<=nttMaxLen) and (Int64(alen)+clen-1<=nttMaxLen) then
    begin
    H111ProductPairW(a,ao,b,bo,c,co,r,ro,s,so,alen,blen,clen,lim);
    exit;
    end;
  if (h102Backend in [3,4,5]) and (h102Backend<>5) and (Int64(alen)+blen-1<=nttMaxLen) and (Int64(alen)+clen-1<=nttMaxLen) then
    begin
    NTTProductPairW(a,ao,b,bo,c,co,r,ro,s,so,alen,blen,clen,lim);
    exit;
    end;
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

{ H102: transform each matrix entry once. Each output is the sum of
  two INTEGER convolutions, bounded by 2*L<p; reduce to GF(2) at output.
  Never perform Euclid or matrix inversion in the odd-characteristic field. }
type TH102PolysW=array[0..7] of THPolyW;
     TH102FreqsW=array[0..7] of TNTTArray;

{ Length/cost metadata only; these arrays contain no coefficients. }
type TH114Sizes=array[0..7]of longint;
function H114ScalarScore(alen,blen,blockBits,transformCut:longint):Int64;
var need,count,dim:longint;
begin
H114ScalarScore:=0;
if (alen<=32) or (blen<=32) or ((alen<=transformCut) and (blen<=transformCut)) then exit;
need:=(alen+blockBits-1) div blockBits+(blen+blockBits-1) div blockBits-1;
count:=2; dim:=1; while count<need do begin count:=count*2; inc(dim); end;
H114ScalarScore:=Int64(3)*count*(dim+1)+count;
end;
function H114PairScore(alen,blen,clen,blockBits,transformCut:longint):Int64;
var top,need,count,dim:longint;
begin
if (alen<=32) or (blen<=32) or (clen<=32) then
  begin H114PairScore:=H114ScalarScore(alen,blen,blockBits,transformCut)+H114ScalarScore(alen,clen,blockBits,transformCut); exit; end;
H114PairScore:=0; top:=blen; if clen>top then top:=clen;
if (alen<=transformCut) and (top<=transformCut) then exit;
need:=(alen+blockBits-1) div blockBits+(top+blockBits-1) div blockBits-1;
count:=2; dim:=1; while count<need do begin count:=count*2; inc(dim); end;
H114PairScore:=Int64(5)*count*(dim+1)+Int64(2)*count;
end;
function H114BatchPlan(const lengths:TH114Sizes; entries,blockBits,transformCut:longint;
                       out count,dim:longint):boolean;
const left8:array[0..7]of longint=(0,1,0,1,2,3,2,3);
      right8:array[0..7]of longint=(4,6,5,7,4,6,5,7);
      left6:array[0..3]of longint=(0,1,2,3);
      right6:array[0..3]of longint=(4,5,4,5);
var blocks:TH114Sizes; i,a,b,need,terms,outputs,forwards,inverses,largest:longint;
var oldScore,newScore:Int64; active:boolean;
begin
H114BatchPlan:=false; need:=0; forwards:=0; largest:=0;
for i:=0 to entries-1 do
  begin
  if lengths[i]>nttMaxLen then exit;
  blocks[i]:=(lengths[i]+blockBits-1) div blockBits;
  if blocks[i]>need then need:=blocks[i];
  if lengths[i]>0 then inc(forwards);
  end;
if entries=8 then begin terms:=8; outputs:=4; end
else begin terms:=4; outputs:=2; end;
inverses:=0; active:=false;
for i:=0 to terms-1 do
  begin
  if entries=8 then begin a:=left8[i]; b:=right8[i]; end
  else begin a:=left6[i]; b:=right6[i]; end;
  if (lengths[a]>0) and (lengths[b]>0) then
    begin
    active:=true;
    if lengths[a]+lengths[b]-1>largest then largest:=lengths[a]+lengths[b]-1;
    if blocks[a]+blocks[b]-1>need then need:=blocks[a]+blocks[b]-1;
    end;
  if (i and 1)=1 then begin if active then inc(inverses); active:=false; end;
  end;
if (largest<=0) or (largest>nttMaxLen) then exit;
count:=2; dim:=1; while count<need do begin count:=count*2; inc(dim); end;
if entries=8 then
  oldScore:=H114PairScore(lengths[0],lengths[4],lengths[5],blockBits,transformCut)+
            H114PairScore(lengths[1],lengths[6],lengths[7],blockBits,transformCut)+
            H114PairScore(lengths[2],lengths[4],lengths[5],blockBits,transformCut)+
            H114PairScore(lengths[3],lengths[6],lengths[7],blockBits,transformCut)
else
  oldScore:=H114PairScore(lengths[4],lengths[0],lengths[2],blockBits,transformCut)+
            H114PairScore(lengths[5],lengths[1],lengths[3],blockBits,transformCut);
if blockBits=1 then begin forwards:=entries; inverses:=outputs; end;
newScore:=Int64(forwards+inverses)*count*(dim+1)+Int64(outputs)*2*count;
H114BatchPlan:=oldScore>newScore;
end;
function H102ProductLenW(const a,b:THPolyW):longint; inline;
begin
if (a.d<0) or (b.d<0) then H102ProductLenW:=0
else H102ProductLenW:=a.d+b.d+1;
end;

procedure H102LoadPolyW(const a:THPolyW; limit,count:longint; var z:TNTTArray);
var i,used:longint;
begin
SetLength(z,count); FillChar(z[0],count*4,0);
used:=a.d+1; if used>limit then used:=limit;
for i:=0 to used-1 do if ((a.v^[i shr 5] shr (i and 31)) and 1)<>0 then z[i]:=nttOne;
end;

procedure H102StorePolyW(const z:TNTTArray; count,used:longint; out a:THPolyW);
var i:longint; scale:LongWord;
begin
if used<=0 then begin HPWZero(a); exit; end;
HPWAlloc(a,(used+31) shr 5);
scale:=nttMod-(nttMod-1) div LongWord(count);
for i:=0 to used-1 do if (NTTMul(z[i],scale) and 1)<>0 then a.v^[i shr 5]:=a.v^[i shr 5] or (LongWord(1) shl (i and 31));
HPWNorm(a);
end;

function H102MatrixReadyW(const a:TH102PolysW; entries,limit:longint; out count:longint):boolean;
var i,top,used,cutoff,transformCut,dim:longint; lengths:TH114Sizes;
begin
H102MatrixReadyW:=false;
if (h102Backend<>4) or (limit<=0) then exit;
top:=0; FillChar(lengths,SizeOf(lengths),0);
for i:=0 to entries-1 do
  begin
  used:=a[i].d+1; if used>limit then used:=limit; lengths[i]:=used;
  if used>top then top:=used;
  end;
cutoff:=4096; transformCut:=256;
if h102Force=0 then begin cutoff:=H118TransformCut(fftCut); transformCut:=cutoff; end;
if top<=cutoff then exit;
H102MatrixReadyW:=H114BatchPlan(lengths,entries,1,transformCut,count,dim);
end;

procedure H102DotW(const a,b,c,d:TNTTArray; count:longint; var z:TNTTArray);
var i:longint; v:LongWord;
begin
SetLength(z,count);
for i:=0 to count-1 do
  begin
  v:=NTTMul(a[i],b[i])+NTTMul(c[i],d[i]);
  if v>=nttMod then dec(v,nttMod);
  z[i]:=v;
  end;
NTTInverse(z,count);
end;

function H102MatApplyW(const a:THMatW; const x,y:THPolyW; limit:longint; out u,v:THPolyW):boolean;
var p:TH102PolysW; f:TH102FreqsW; z:TNTTArray; count,i,used:longint;
begin
H102MatApplyW:=false;
p[0]:=a.p00; p[1]:=a.p01; p[2]:=a.p10; p[3]:=a.p11; p[4]:=x; p[5]:=y;
if not H102MatrixReadyW(p,6,limit,count) then exit;
NTTPrepare(count);
for i:=0 to 5 do begin H102LoadPolyW(p[i],limit,count,f[i]); NTTForward(f[i],count); end;
H102DotW(f[0],f[4],f[1],f[5],count,z);
used:=H102Max(H102ProductLenW(p[0],p[4]),H102ProductLenW(p[1],p[5]));
if used>limit then used:=limit;
H102StorePolyW(z,count,used,u);
H102DotW(f[2],f[4],f[3],f[5],count,z);
used:=H102Max(H102ProductLenW(p[2],p[4]),H102ProductLenW(p[3],p[5]));
if used>limit then used:=limit;
H102StorePolyW(z,count,used,v);
H102MatApplyW:=true;
end;

function H102MatMulW(const a,b:THMatW; out c:THMatW):boolean;
var p:TH102PolysW; f:TH102FreqsW; z:TNTTArray; count,i,used:longint;
begin
H102MatMulW:=false;
p[0]:=a.p00; p[1]:=a.p01; p[2]:=a.p10; p[3]:=a.p11;
p[4]:=b.p00; p[5]:=b.p01; p[6]:=b.p10; p[7]:=b.p11;
if not H102MatrixReadyW(p,8,High(longint),count) then exit;
NTTPrepare(count);
for i:=0 to 7 do begin H102LoadPolyW(p[i],High(longint),count,f[i]); NTTForward(f[i],count); end;
H102DotW(f[0],f[4],f[1],f[6],count,z);
used:=H102Max(H102ProductLenW(p[0],p[4]),H102ProductLenW(p[1],p[6]));
H102StorePolyW(z,count,used,c.p00);
H102DotW(f[0],f[5],f[1],f[7],count,z);
used:=H102Max(H102ProductLenW(p[0],p[5]),H102ProductLenW(p[1],p[7]));
H102StorePolyW(z,count,used,c.p01);
H102DotW(f[2],f[4],f[3],f[6],count,z);
used:=H102Max(H102ProductLenW(p[2],p[4]),H102ProductLenW(p[3],p[6]));
H102StorePolyW(z,count,used,c.p10);
H102DotW(f[2],f[5],f[3],f[7],count,z);
used:=H102Max(H102ProductLenW(p[2],p[5]),H102ProductLenW(p[3],p[7]));
H102StorePolyW(z,count,used,c.p11);
H102MatMulW:=true;
end;

type TH114Freqs=array[0..7] of TH111Array;
function H114MatrixReadyW(const a:TH102PolysW; entries,limit:longint; out count,dim:longint):boolean;
var i,used,top,cutoff,transformCut:longint; lengths:TH114Sizes;
begin
H114MatrixReadyW:=false;
if (h102Backend<>5) or (limit<=0) then exit;
top:=0; FillChar(lengths,SizeOf(lengths),0);
for i:=0 to entries-1 do
  begin used:=a[i].d+1; if used>limit then used:=limit; lengths[i]:=used; if used>top then top:=used; end;
cutoff:=4096; transformCut:=256;
if h102Force=0 then begin cutoff:=H118TransformCut(fftCut); transformCut:=cutoff; end;
if top<=cutoff then exit;
H114MatrixReadyW:=H114BatchPlan(lengths,entries,16,transformCut,count,dim);
end;
procedure H114Dot(const a,b,c,d:TH111Array; dim:longint; var z:TH111Array);
var i:longint;
begin
SetLength(z,Length(a));
for i:=0 to High(a) do z[i]:=H111Mul(a[i],b[i]) xor H111Mul(c[i],d[i]);
H114Inverse(z,dim);
end;
procedure H114LoadPolyW(const a:THPolyW; limit,count,dim:longint; var z:TH111Array);
var used,j,take:longint;
begin
SetLength(z,count); FillChar(z[0],count*SizeOf(z[0]),0);
used:=a.d+1; if used>limit then used:=limit;
if used<=0 then exit;
for j:=0 to (used+15) div 16-1 do
  begin
  take:=used-j*16; if take>16 then take:=16;
  z[j]:=(a.v^[j shr 1] shr ((j and 1)*16)) and (LongWord($FFFF) shr (16-take));
  end;
H114Forward(z,dim);
end;
procedure H114StorePolyW(const z:TH111Array; used:longint; out a:THPolyW);
var j,take,last:longint; value,part:LongWord;
begin
if used<=0 then begin HPWZero(a); exit; end;
HPWAlloc(a,(used+31) shr 5); value:=0; last:=(used+15) div 16-1;
for j:=0 to last do
  begin
  part:=0; if j<Length(z) then part:=z[j];
  if j>0 then part:=part xor (z[j-1] shr 16);
  take:=used-j*16; if take>16 then take:=16;
  part:=part and (LongWord($FFFF) shr (16-take));
  value:=value or (part shl ((j and 1)*16));
  if ((j and 1)=1) or (j=last) then begin a.v^[j shr 1]:=value; value:=0; end;
  end;
a.d:=used-1; HPWNorm(a);
end;
function H114MatApplyW(const a:THMatW; const x,y:THPolyW; limit:longint; out u,v:THPolyW):boolean;
var p:TH102PolysW; f:TH114Freqs; z:TH111Array; count,dim,i,used:longint;
begin
H114MatApplyW:=false;
p[0]:=a.p00; p[1]:=a.p01; p[2]:=a.p10; p[3]:=a.p11; p[4]:=x; p[5]:=y;
if not H114MatrixReadyW(p,6,limit,count,dim) then exit;
H111Prepare(count);
for i:=0 to 5 do H114LoadPolyW(p[i],limit,count,dim,f[i]);
used:=H102Max(H102ProductLenW(p[0],p[4]),H102ProductLenW(p[1],p[5]));
if used>limit then used:=limit;
if used<=0 then HPWZero(u)
else begin H114Dot(f[0],f[4],f[1],f[5],dim,z); H114StorePolyW(z,used,u); end;
used:=H102Max(H102ProductLenW(p[2],p[4]),H102ProductLenW(p[3],p[5]));
if used>limit then used:=limit;
if used<=0 then HPWZero(v)
else begin H114Dot(f[2],f[4],f[3],f[5],dim,z); H114StorePolyW(z,used,v); end;
H114MatApplyW:=true;
end;
function H114MatMulW(const a,b:THMatW; out c:THMatW):boolean;
var p:TH102PolysW; f:TH114Freqs; z:TH111Array; count,dim,i,used:longint;
begin
H114MatMulW:=false;
p[0]:=a.p00; p[1]:=a.p01; p[2]:=a.p10; p[3]:=a.p11;
p[4]:=b.p00; p[5]:=b.p01; p[6]:=b.p10; p[7]:=b.p11;
if not H114MatrixReadyW(p,8,High(longint),count,dim) then exit;
H111Prepare(count);
for i:=0 to 7 do H114LoadPolyW(p[i],High(longint),count,dim,f[i]);
used:=H102Max(H102ProductLenW(p[0],p[4]),H102ProductLenW(p[1],p[6]));
if used<=0 then HPWZero(c.p00)
else begin H114Dot(f[0],f[4],f[1],f[6],dim,z); H114StorePolyW(z,used,c.p00); end;
used:=H102Max(H102ProductLenW(p[0],p[5]),H102ProductLenW(p[1],p[7]));
if used<=0 then HPWZero(c.p01)
else begin H114Dot(f[0],f[5],f[1],f[7],dim,z); H114StorePolyW(z,used,c.p01); end;
used:=H102Max(H102ProductLenW(p[2],p[4]),H102ProductLenW(p[3],p[6]));
if used<=0 then HPWZero(c.p10)
else begin H114Dot(f[2],f[4],f[3],f[6],dim,z); H114StorePolyW(z,used,c.p10); end;
used:=H102Max(H102ProductLenW(p[2],p[5]),H102ProductLenW(p[3],p[7]));
if used<=0 then HPWZero(c.p11)
else begin H114Dot(f[2],f[5],f[3],f[7],dim,z); H114StorePolyW(z,used,c.p11); end;
H114MatMulW:=true;
end;

type TH121JetFreqs=array[0..7] of TH119FFreq;

function H121JetCost(const plan:TH121JetPlan):int64; inline;
begin H121JetCost:=int64(plan.axes)*plan.count*(plan.dim+2); end;

{ Fused exact sums of products in the GF(2^16) jet transform.
  Select a common plan only if it saves work after padding. }
function H121JetMatrix(const p:TH102PolysW; rows,cols,limit:longint;
                      out f:TH121JetFreqs; out plan:TH121JetPlan):boolean;
var lengths:TH114Sizes; term:TH121JetPlan; src:TH119Bits;
var count,i,j,k,a,b,span,top,cut:longint; separate:int64;
begin
H121JetMatrix:=false;
if (h102Backend<>7) or h119AllDFT or (limit<=0) then exit;
count:=2*(rows+cols); span:=0;
for i:=0 to count-1 do
  begin
  lengths[i]:=p[i].d+1;
  if lengths[i]>limit then lengths[i]:=limit;
  if lengths[i]<=32 then exit;
  if lengths[i]>span then span:=lengths[i];
  end;
if (span>2097152) or ((h102Force=7) and (span>=131072)) then exit;
cut:=H118TransformCut(fftCut);
if cut<1023 then cut:=1023;
separate:=0;
for i:=0 to rows-1 do for j:=0 to cols-1 do for k:=0 to 1 do
  begin
  a:=lengths[2*i+k]; b:=lengths[2*rows+k*cols+j];
  top:=H102Max(a,b);
  if top>cut then
    begin H121JetPlan(top,term); inc(separate,3*H121JetCost(term)); end;
  end;
if separate=0 then exit;
H121JetPlan(span,plan);
if (count+rows*cols)*H121JetCost(plan)>=separate then exit;
H119InitTables; H119FPrepare;
for i:=0 to count-1 do
  begin
  H119Space(src,lengths[i]); Move(p[i].v^[0],src[0],Length(src)*SizeOf(src[0]));
  H121JetLift(src,0,lengths[i],plan,f[i]);
  for j:=0 to 3*plan.axes-1 do H122JetDFT(f[i,j],plan.dim,plan.oddIndex,false);
  end;
H121JetMatrix:=true;
end;

procedure H121JetDot(const a,b,c,d:TH119FFreq; const plan:TH121JetPlan;
                    used:longint; out dest:THPolyW);
var f:TH119FFreq; dst:TH119Bits; i,j:longint;
begin
for i:=0 to 3*plan.axes-1 do
  begin
  SetLength(f[i],plan.count);
  for j:=0 to plan.count-1 do
    f[i,j]:=H119FAdd(H119FMul(a[i,j],b[i,j]),H119FMul(c[i,j],d[i,j]));
  H122JetDFT(f[i],plan.dim,plan.oddIndex,true);
  end;
H119Space(dst,used);
H121JetStore(f,plan,dst,0,used);
HPWAlloc(dest,Length(dst)); Move(dst[0],dest.v^[0],Length(dst)*SizeOf(dst[0]));
HPWNorm(dest);
end;

function H121MatApply(const a:THMatW; const x,y:THPolyW; limit:longint; out u,v:THPolyW):boolean;
var p:TH102PolysW; f:TH121JetFreqs; plan:TH121JetPlan; used:longint;
begin
H121MatApply:=false;
p[0]:=a.p00; p[1]:=a.p01; p[2]:=a.p10; p[3]:=a.p11; p[4]:=x; p[5]:=y;
if not H121JetMatrix(p,2,1,limit,f,plan) then exit;
used:=H102Max(H102ProductLenW(p[0],p[4]),H102ProductLenW(p[1],p[5]));
if used>limit then used:=limit;
H121JetDot(f[0],f[4],f[1],f[5],plan,used,u);
used:=H102Max(H102ProductLenW(p[2],p[4]),H102ProductLenW(p[3],p[5]));
if used>limit then used:=limit;
H121JetDot(f[2],f[4],f[3],f[5],plan,used,v);
H121MatApply:=true;
end;

function H121MatMul(const a,b:THMatW; out c:THMatW):boolean;
var p:TH102PolysW; f:TH121JetFreqs; plan:TH121JetPlan; used:longint;
begin
H121MatMul:=false;
p[0]:=a.p00; p[1]:=a.p01; p[2]:=a.p10; p[3]:=a.p11;
p[4]:=b.p00; p[5]:=b.p01; p[6]:=b.p10; p[7]:=b.p11;
if not H121JetMatrix(p,2,2,High(longint),f,plan) then exit;
used:=H102Max(H102ProductLenW(p[0],p[4]),H102ProductLenW(p[1],p[6]));
H121JetDot(f[0],f[4],f[1],f[6],plan,used,c.p00);
used:=H102Max(H102ProductLenW(p[0],p[5]),H102ProductLenW(p[1],p[7]));
H121JetDot(f[0],f[5],f[1],f[7],plan,used,c.p01);
used:=H102Max(H102ProductLenW(p[2],p[4]),H102ProductLenW(p[3],p[6]));
H121JetDot(f[2],f[4],f[3],f[6],plan,used,c.p10);
used:=H102Max(H102ProductLenW(p[2],p[5]),H102ProductLenW(p[3],p[7]));
H121JetDot(f[2],f[5],f[3],f[7],plan,used,c.p11);
H121MatMul:=true;
end;


procedure HPWMatApply(const a:THMatW; const x,y:THPolyW; out u,v:THPolyW);
var lim:longint;
var t0,t1,t2,t3:THPolyW;
begin
{ Euclidean prefix: deg(u) <= deg(x)-deg(a.p11), and deg(v)<deg(u). }
lim:=x.d+1; if a.p11.d>=0 then dec(lim,a.p11.d);
if H121MatApply(a,x,y,lim,u,v) then exit;
if H114MatApplyW(a,x,y,lim,u,v) then exit;
if H102MatApplyW(a,x,y,lim,u,v) then exit;
HPWMulPairTrunc(x,a.p00,a.p10,t0,t1,lim); HPWMulPairTrunc(y,a.p01,a.p11,t2,t3,lim);
HPWAdd(t0,t2,u); HPWAdd(t1,t3,v);
end;

procedure HPWMatMul(const a,b:THMatW; out c:THMatW);
var t0,t1,t2,t3,t4,t5,t6,t7:THPolyW;
begin
if H121MatMul(a,b,c) then exit;
if H114MatMulW(a,b,c) then exit;
if H102MatMulW(a,b,c) then exit;
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
procedure H121GcdScratch(hi:longint);
var size:longint;
begin
size:=(hi*2+96) shr 5;
if (Length(qPool)<size*128) or (Length(qPool)>(size*128)*4) then SetLength(qPool,size*128); qTop:=0;
if (Length(qA)<size) or (Length(qA)>(size)*4) then SetLength(qA,size); if (Length(qB)<size) or (Length(qB)>(size)*4) then SetLength(qB,size); if (Length(qC)<size) or (Length(qC)>(size)*4) then SetLength(qC,size);
if (Length(qR)<size*2) or (Length(qR)>(size*2)*4) then SetLength(qR,size*2); if (Length(qS)<size*2) or (Length(qS)>(size*2)*4) then SetLength(qS,size*2); if (Length(qWork)<size*10) or (Length(qWork)>(size*10)*4) then SetLength(qWork,size*10);
end;

function GcdU(const va,vb:TVec; var vg,vu,vv:TVec; hi:longint):longint;
var a,b,g,u,v:THPolyW;
begin
H121GcdScratch(hi);
HPWFromVec(va,hi,a); HPWFromVec(vb,hi,b); HPWXGCD(a,b,g,u,v);
HPWToVec(g,vg,hi); HPWToVec(u,vu,hi); HPWToVec(v,vv,hi); GcdU:=g.d;
end;

{ H104: split-root GCD on a Cantor field. Field arithmetic, root sets,
  FWHT, additive FFT and basis conversion are identical in A and B. }
type TH104Array=array of LongWord;
var h104K,h104Count,h104Order,h104Odd:longint;
var h104Exp,h104Log,h104Point,h104Label,h104LogFW:TH104Array;
var h104Support:array[0..19,0..19] of longint;
var h104SupportCount:array[0..19] of longint;
var h104SupportCoef:array[0..19,0..19] of LongWord;
var h104Sub:array[0..5,0..5] of LongWord;
var h104Scale:array[0..4] of LongWord;

function H104Mul(a,b:LongWord):LongWord; inline;
begin
if (a=0) or (b=0) then H104Mul:=0
else if a=1 then H104Mul:=b
else if b=1 then H104Mul:=a
else H104Mul:=h104Exp[(h104Log[a]+h104Log[b]) mod LongWord(h104Order)];
end;

function H104Inverse(a:LongWord):LongWord; inline;
begin
if a=0 then Halt(223);
H104Inverse:=h104Exp[(h104Order-longint(h104Log[a])) mod h104Order];
end;

procedure H104FWHT(var a:TH104Array);
var h,base,j:longint; u,v:LongWord;
begin
h:=1;
while h<h104Count do
  begin
  base:=0;
  while base<h104Count do
    begin
    for j:=base to base+h-1 do
      begin
      u:=a[j]; v:=a[j+h];
      a[j]:=(u+v) mod LongWord(h104Order);
      a[j+h]:=(u+LongWord(h104Order)-v) mod LongWord(h104Order);
      end;
    inc(base,h*2);
    end;
  h:=h*2;
  end;
end;

function H104Square(a:LongWord):LongWord; inline;
begin
if a=0 then H104Square:=0
else H104Square:=h104Exp[(h104Log[a]*2) mod LongWord(h104Order)];
end;

function H104SubValue(x:LongWord; s:longint):LongWord;
var j:longint; value:LongWord;
begin
value:=0;
for j:=0 to s do
  begin
  value:=value xor H104Mul(h104Sub[s,j],x);
  x:=H104Square(x);
  end;
H104SubValue:=value;
end;

procedure H104Prepare(k:longint);
var root,beta,chain,theta:TH104Array;
var count,order,p,j,bit,x,poly,t,c,blocks,a,b,e,l,cs:longint;
var d:LongWord;
begin
if h104K=k then exit;
count:=1 shl k; order:=count-1;
case k of
2:poly:=$7;
3:poly:=$B;
4:poly:=$13;
5:poly:=$25;
6:poly:=$43;
8:poly:=$11D;
10:poly:=$409;
12:poly:=$1053;
16:poly:=$1100B;
20:poly:=$100009;
else Halt(224);
end;
h104K:=k; h104Count:=count; h104Order:=order;
SetLength(h104Exp,order); SetLength(h104Log,count);
FillChar(h104Log[0],count*SizeOf(LongWord),$FF);
x:=1;
for j:=0 to order-1 do
  begin
  if h104Log[x]<>$FFFFFFFF then Halt(224);
  h104Exp[j]:=x; h104Log[x]:=j;
  x:=x shl 1; if (x and count)<>0 then x:=x xor poly;
  end;
if x<>1 then Halt(224);
{ k=c*2^r, c in 1,3,5. L=x^(2^c)+x gives a Cantor chain
  over the constant-size subfield GF(2^c), including degrees 10/20. }
c:=k; blocks:=1;
while (c and 1)=0 do begin c:=c div 2; blocks:=blocks*2; end;
h104Odd:=c;
SetLength(root,count); FillChar(root[0],count*SizeOf(LongWord),$FF);
for x:=0 to count-1 do
  begin
  d:=x; for j:=1 to c do d:=H104Square(d);
  root[d xor LongWord(x)]:=x;
  end;
SetLength(chain,blocks); chain[0]:=1;
for j:=1 to blocks-1 do
  begin
  if root[chain[j-1]]=$FFFFFFFF then Halt(224);
  chain[j]:=root[chain[j-1]];
  end;
SetLength(theta,c);
for j:=0 to c-1 do theta[j]:=h104Exp[(order div ((1 shl c)-1)*j) mod order];
FillChar(h104Sub,SizeOf(h104Sub),0); h104Sub[0,0]:=1;
for j:=0 to c-1 do
  begin
  d:=H104SubValue(theta[j],j); h104Scale[j]:=H104Inverse(d);
  for l:=0 to j+1 do
    begin
    if l>0 then h104Sub[j+1,l]:=H104Square(h104Sub[j,l-1]);
    if l<=j then h104Sub[j+1,l]:=h104Sub[j+1,l] xor H104Mul(d,h104Sub[j,l]);
    end;
  end;
SetLength(beta,k);
for j:=0 to blocks-1 do
  for l:=0 to c-1 do beta[c*j+l]:=H104Mul(chain[j],theta[l]);
for p:=0 to k-1 do
  begin
  a:=p div c; b:=p mod c; h104SupportCount[p]:=0;
  for j:=0 to a do if (j and a)=j then
    for l:=0 to b do if h104Sub[b,l]<>0 then
      begin
      e:=c*j+l;
      if e<p then
        begin
        cs:=h104SupportCount[p]; h104Support[p,cs]:=1 shl e;
        h104SupportCoef[p,cs]:=h104Sub[b,l]; inc(h104SupportCount[p]);
        end;
      end;
  end;
SetLength(h104Point,count); SetLength(h104Label,count);
FillChar(h104Label[0],count*SizeOf(LongWord),$FF);
h104Point[0]:=0; h104Label[0]:=0;
for j:=1 to count-1 do
  begin
  bit:=j and (-j); p:=0; t:=bit;
  while t>1 do begin t:=t shr 1; inc(p); end;
  x:=h104Point[j xor bit] xor beta[p];
  if h104Label[x]<>$FFFFFFFF then Halt(224);
  h104Point[j]:=x; h104Label[x]:=j;
  end;
SetLength(h104LogFW,count);
for j:=0 to count-1 do
  if h104Point[j]=0 then h104LogFW[j]:=0 else h104LogFW[j]:=h104Log[h104Point[j]];
H104FWHT(h104LogFW);
end;

{ Enable only to study the additional O(nn log nn) D-family path.
  Default false avoids the measured large ambient-field overhead. }
var h110PlusRoots:boolean=false;

{ C_s(z+1/z)=z^s+z^(-s), C_0=0, C_1=x in characteristic two.
  C_(2s)=C_s^2 and C_(2s+1)=C_s*C_(s+1)+x. }
function H110Dickson(x:LongWord; index:longint):LongWord;
var a,b,t:LongWord; mask:longint;
begin
a:=0; b:=x; mask:=1;
while mask<=index div 2 do mask:=mask shl 1;
while mask>0 do
  begin
  t:=H104Mul(a,b) xor x;
  if (index and mask)<>0 then begin a:=t; b:=H104Square(b); end
  else begin b:=t; a:=H104Square(a); end;
  mask:=mask shr 1;
  end;
H110Dickson:=a;
end;

{ Polynomial-basis trace seeds for the existing H104 field polynomials.
  Certify exact order Q+1 before using a seed; no trusted root table. }
function H110TorusRoots(var roots:TH104Array; period:longint):boolean;
var alpha,beta,a,b,t:LongWord;
var order,rest,factor,j,used:longint;
begin
H110TorusRoots:=false;
order:=h104Count+1;
if (period<3) or ((period and 1)=0) or (order mod period<>0) then exit;
case h104K of
2,3,4,6,12,16:alpha:=2;
5:alpha:=6;
8,10,20:alpha:=3;
else exit;
end;
if H110Dickson(alpha,order)<>0 then exit;
rest:=order; factor:=3;
while factor<=rest div factor do
  begin
  if rest mod factor=0 then
    begin
    if H110Dickson(alpha,order div factor)=0 then exit;
    repeat rest:=rest div factor until rest mod factor<>0;
    end;
  inc(factor,2);
  end;
if rest>1 then if H110Dickson(alpha,order div rest)=0 then exit;
beta:=H110Dickson(alpha,order div period);
if beta=0 then exit;
a:=0; b:=beta; used:=0;
for j:=1 to period div 2 do
  begin
  if (b=0) or (roots[b]<>0) then exit;
  roots[b]:=1; inc(used);
  t:=H104Mul(beta,b) xor a; a:=b; b:=t;
  end;
if (used<>period div 2) or (a<>b) then exit;
H110TorusRoots:=true;
end;

function H104FieldFor(nn:longword):longint;
const degrees:array[0..9] of longint=(2,3,4,5,6,8,10,12,16,20);
var k,count,period,j:longint;
begin
H104FieldFor:=0;
if (nn<2) or ((nn and 1)<>0) or (nn>1048576) then exit;
period:=longint(nn)+1;
for j:=0 to High(degrees) do
  begin
  k:=degrees[j]; count:=1 shl k;
  if (longint(nn)=count) or
     (((count-1) mod period=0) and ((count-1) div period<=17)) or
     (h110PlusRoots and ((count+1) mod period=0) and ((count+1) div period<=17)) then
    begin H104FieldFor:=k; exit; end;
  end;
end;

{ H^2=count*I and count=1 modulo count-1: no inverse scaling. }
procedure H104RootValues(const mask:TH104Array; var values:TH104Array);
var p:longint;
begin
SetLength(values,h104Count);
Move(mask[0],values[0],h104Count*SizeOf(LongWord));
H104FWHT(values);
for p:=0 to h104Count-1 do
  values[p]:=LongWord((QWord(values[p])*h104LogFW[p]) mod LongWord(h104Order));
H104FWHT(values);
for p:=0 to h104Count-1 do values[p]:=h104Exp[values[p]];
end;

procedure H104IFFT(var a:TH104Array);
var i,h,base,j:longint; c,lo,hi:LongWord;
begin
for i:=0 to h104K-1 do
  begin
  h:=1 shl i; base:=0;
  while base<h104Count do
    begin
    c:=H104SubValue(h104Point[base shr (i div h104Odd*h104Odd)],i mod h104Odd);
    for j:=base to base+h-1 do
      begin
      hi:=H104Mul(a[j] xor a[j+h],h104Scale[i mod h104Odd]);
      lo:=a[j] xor H104Mul(c,hi);
      a[j]:=lo; a[j+h]:=hi;
      end;
    inc(base,h*2);
    end;
  end;
end;

{ H105: the small GF(2^c) basis has constant c in 1,3,5.
  A strided view avoids an extra transpose buffer. }
procedure H105Small(var a:TH104Array; base,stride,i:longint);
var h,p,j,src,dst:longint; value:LongWord;
begin
if i<0 then exit;
h:=1 shl i;
H105Small(a,base,stride,i-1); H105Small(a,base+h*stride,stride,i-1);
for p:=h to h*2-1 do
  begin
  src:=base+p*stride; value:=a[src];
  if value<>0 then
    for j:=0 to h104SupportCount[i]-1 do
      begin
      dst:=base+(p-h+h104Support[i,j])*stride;
      a[dst]:=a[dst] xor H104Mul(value,h104SupportCoef[i,j]);
      end;
  end;
end;

{ Collapse sum P_j(x)*Y^j with Y=x^(2^h)+x, deg(P_j)<2^h.
  Y^(2^t)=x^(2^(h+t))+x^(2^t), so each merge has only one XOR
  shift. Ascending order handles the overlapping strided ranges. }
procedure H105Taylor(var a:TH104Array; base,stride,dim,h:longint);
var half,shift,p,dst,src:longint;
begin
if dim<=h then exit;
half:=1 shl (dim-1); shift:=1 shl (dim-h-1);
H105Taylor(a,base,stride,dim-1,h);
H105Taylor(a,base+half*stride,stride,dim-1,h);
dst:=base+shift*stride; src:=base+half*stride;
for p:=0 to half-1 do
  begin
  a[dst]:=a[dst] xor a[src]; inc(dst,stride); inc(src,stride);
  end;
end;

{ For dim=c*2^r choose h=dim/2. Then s_h=x^(2^h)+x and
  X_(lo+hi*2^h)(x)=X_lo(x)*X_hi(s_h(x)). Convert both tensor
  directions, then collapse the binomial Taylor expansion.
  T(2^k)=2*2^(k/2)*T(2^(k/2))+O(2^k*k), hence
  T(N)=O(N log N log log N), including the basis conversion. }
procedure H105Monomial(var a:TH104Array; base,stride,dim:longint);
var h,lowCount,highCount,p:longint;
begin
if dim<=h104Odd then
  begin H105Small(a,base,stride,dim-1); exit; end;
h:=dim div 2; lowCount:=1 shl h; highCount:=1 shl (dim-h);
for p:=0 to highCount-1 do H105Monomial(a,base+p*lowCount*stride,stride,h);
for p:=0 to lowCount-1 do H105Monomial(a,base+p*stride,stride*lowCount,dim-h);
H105Taylor(a,base,stride,dim,h);
end;

{ H106: compress the GF(2^c) coefficients into c bit planes, c<=5.
  One LongWord holds 32 adjacent coefficients of a plane. The old
  sparse triangular map is evaluated with word masks and XOR shifts.
  All source planes for a chunk are saved before any destination write. }
function H106Monomial(var a:TH104Array):boolean;
type TPlanes=array[0..4] of TH104Array;
var plane:TPlanes;
var columns:array[0..19,0..4] of LongWord;
var u:array[0..4] of LongWord;
var i,j,p,t,l,h,words,base,q,src,dst,delta,shift:longint;
var labelValue,mask,value:LongWord;
begin
H106Monomial:=false;
{ The inverse triangular basis map is defined over GF(2^c).
  Check membership before changing a; retain H105 for other inputs. }
for p:=0 to h104Count-1 do
  if h104Label[a[p]]>=LongWord(1 shl h104Odd) then exit;
words:=(h104Count+31) shr 5;
for t:=0 to h104Odd-1 do SetLength(plane[t],words);
for p:=0 to h104Count-1 do
  begin
  labelValue:=h104Label[a[p]];
  for t:=0 to h104Odd-1 do
    if (labelValue and (LongWord(1) shl t))<>0 then
      plane[t][p shr 5]:=plane[t][p shr 5] or (LongWord(1) shl (p and 31));
  end;
for i:=0 to h104K-1 do
  begin
  h:=1 shl i;
  { Matrix columns for multiplication by each small-subfield constant. }
  for j:=0 to h104SupportCount[i]-1 do
    for l:=0 to h104Odd-1 do
      columns[j,l]:=h104Label[H104Mul(h104Point[1 shl l],h104SupportCoef[i,j])];
  if h<32 then
    begin
    mask:=0;
    for p:=0 to 31 do if (p and h)<>0 then mask:=mask or (LongWord(1) shl p);
    for q:=0 to words-1 do
      begin
      for l:=0 to h104Odd-1 do u[l]:=plane[l][q] and mask;
      for j:=0 to h104SupportCount[i]-1 do
        begin
        shift:=h-h104Support[i,j];
        for t:=0 to h104Odd-1 do
          begin
          value:=0;
          for l:=0 to h104Odd-1 do
            if (columns[j,l] and (LongWord(1) shl t))<>0 then value:=value xor u[l];
          plane[t][q]:=plane[t][q] xor (value shr shift);
          end;
        end;
      end;
    end
  else
    begin
    base:=0;
    while base<h104Count do
      begin
      for q:=0 to (h shr 5)-1 do
        begin
        src:=((base+h) shr 5)+q;
        for l:=0 to h104Odd-1 do u[l]:=plane[l][src];
        for j:=0 to h104SupportCount[i]-1 do
          begin
          delta:=h104Support[i,j]; dst:=((base+delta) shr 5)+q; shift:=delta and 31;
          for t:=0 to h104Odd-1 do
            begin
            value:=0;
            for l:=0 to h104Odd-1 do
              if (columns[j,l] and (LongWord(1) shl t))<>0 then value:=value xor u[l];
            if shift=0 then plane[t][dst]:=plane[t][dst] xor value
            else
              begin
              plane[t][dst]:=plane[t][dst] xor (value shl shift);
              plane[t][dst+1]:=plane[t][dst+1] xor (value shr (32-shift));
              end;
            end;
          end;
        end;
      inc(base,h*2);
      end;
    end;
  end;
for p:=0 to h104Count-1 do
  begin
  labelValue:=0;
  for t:=0 to h104Odd-1 do
    if ((plane[t][p shr 5] shr (p and 31)) and 1)<>0 then
      labelValue:=labelValue or (LongWord(1) shl t);
  a[p]:=h104Point[labelValue];
  end;
H106Monomial:=true;
end;

procedure H104Interpolate(var a:TH104Array);
var p:longint;
begin
H104IFFT(a); if not H106Monomial(a) then H105Monomial(a,0,1,h104K);
for p:=0 to h104Count-1 do if a[p]>1 then Halt(225);
end;

{ Invert P(x)=A(x^2+x)+x*B(x^2+x). After the binary divisions,
  even slots contain A and odd slots B. All coefficients remain binary. }
procedure H104Decompose(var a:TH104Array; base,count:longint);
var h,p:longint;
begin
if count<=2 then exit;
h:=count div 4;
for p:=base+count-1 downto base+count div 2 do a[p-h]:=a[p-h] xor a[p];
H104Decompose(a,base,count div 2);
H104Decompose(a,base+count div 2,count div 2);
end;

procedure H104Translate(var a:TH104Array);
var h,base,j:longint;
begin
h:=1;
while h<h104Count do
  begin
  base:=0;
  while base<h104Count do
    begin
    for j:=base to base+h-1 do a[j]:=a[j] xor a[j+h];
    inc(base,h*2);
    end;
  h:=h*2;
  end;
end;

procedure H104FromField(const a:TH104Array; out b:THPolyW);
var p:longint;
begin
HPWAlloc(b,(h104Count+31) shr 5);
for p:=0 to h104Count-1 do
  begin
  if a[p]>1 then Halt(225);
  if a[p]<>0 then b.v^[p shr 5]:=b.v^[p shr 5] or (LongWord(1) shl (p and 31));
  end;
b.d:=h104Count-1; HPWNorm(b);
end;

procedure H104ToField(const a:THPolyW; var b:TH104Array);
var p:longint;
begin
SetLength(b,h104Count); FillChar(b[0],h104Count*SizeOf(LongWord),0);
for p:=0 to a.d do b[p]:=(a.v^[p shr 5] shr (p and 31)) and 1;
end;

procedure H104Project(var a:TH104Array; out b:THPolyW; invariant:boolean);
var p:longint;
begin
H104Decompose(a,0,h104Count);
HPWAlloc(b,(h104Count div 2+31) shr 5);
for p:=0 to h104Count div 2-1 do
  begin
  if invariant and (a[p*2+1]<>0) then Halt(226);
  if a[p*2]<>0 then b.v^[p shr 5]:=b.v^[p shr 5] or (LongWord(1) shl (p and 31));
  end;
b.d:=h104Count div 2-1; HPWNorm(b);
end;

function H104Equal(const a,b:THPolyW):boolean;
var p:longint;
begin
H104Equal:=false;
if a.d<>b.d then exit;
if a.d<0 then begin H104Equal:=true; exit; end;
for p:=0 to a.d shr 5 do if a.v^[p]<>b.v^[p] then exit;
H104Equal:=true;
end;

{ For m=nn+1 odd, put m'=2^(k+1)-m and t=abs(m-2^k).
  Let P_m=U_((m-1)/2)+U_((m-3)/2)=a+T*b in u=T^2+T,
  and P_m'=e+T*f. For the Dickson polynomials D, the identity
  T*P_m*P_m'=T^(2^k)+D_t(T) and its translate give
  a*(e+f)+b*(e+f+u*f)=1+D_t(T)+D_t(T+1).
  The right side has u-degree (t-1)/2 for odd t>1. }
type TH121Fib=record a,b:THPolyW; end;

procedure H121TimesU(const a:THPolyW; out b:THPolyW);
begin
if a.d<0 then begin HPWZero(b); exit; end;
HPWAlloc(b,(a.d+33) shr 5); HPWXorShift(b,a,1);
b.d:=a.d+1;
end;

procedure H121SquareFib(const p:TH121Fib; out q:TH121Fib);
var a,b:THPolyW;
begin
HPWSquareTrunc(p.a,a,2*p.a.d+1);
HPWSquareTrunc(p.b,q.b,2*p.b.d+1);
H121TimesU(q.b,b); HPWAdd(a,b,q.a);
end;

procedure H121TimesT(const p:TH121Fib; out q:TH121Fib);
begin
H121TimesU(p.b,q.a); HPWAdd(p.a,p.b,q.b);
end;

{ U_k and U_(k-1), in the basis 1,T over GF(2)[u]. }
procedure H121FibPair(k:longint; out p,q:TH121Fib);
var a,b,s,t,e:TH121Fib;
begin
if k=0 then
  begin HPWOne(p.a); HPWZero(p.b); HPWZero(q.a); HPWZero(q.b); exit; end;
H121FibPair(k div 2,a,b);
H121SquareFib(a,s); H121SquareFib(b,t);
HPWAdd(s.a,t.a,e.a); HPWAdd(s.b,t.b,e.b);
if odd(k) then begin H121TimesT(s,p); q:=e; end
else begin p:=e; H121TimesT(t,q); end;
end;

{ One side has degree O(t). Use the fixed-size carryless leaves here
  so even a long unbalanced product costs O(nn*(1+t)). }
procedure H121ShortProduct(const a,b:THPolyW; out c:THPolyW);
var i,j:longint; product:QWord;
begin
if (a.d<0) or (b.d<0) then begin HPWZero(c); exit; end;
if a.d=0 then begin c:=b; exit; end;
if b.d=0 then begin c:=a; exit; end;
if a.d>b.d then begin H121ShortProduct(b,a,c); exit; end;
HPWAlloc(c,(a.d+b.d+32) shr 5);
for i:=0 to a.cap-1 do for j:=0 to b.cap-1 do
  begin
  product:=CLMul32(a.v^[i],b.v^[j]);
  c.v^[i+j]:=c.v^[i+j] xor LongWord(product);
  if i+j+1<c.cap then c.v^[i+j+1]:=c.v^[i+j+1] xor LongWord(product shr 32);
  end;
c.d:=a.d+b.d;
end;

{ Windows of w consecutive GF(2) coefficients. A addresses Boolean
  tuples and B stores the same tuples in words. }
type TH122Digit=LongWord;

function H122Key(a:TH122Digit):longint; inline;
begin H122Key:=longint(a); end;

function H122DigitAt(i:longint):TH122Digit; inline;
begin H122DigitAt:=LongWord(i); end;

function H122DigitBit(a:TH122Digit; i:longint):boolean; inline;
begin H122DigitBit:=(a and (LongWord(1) shl i))<>0; end;

function H122Plus(a,b:TH122Digit):TH122Digit; inline;
begin H122Plus:=a xor b; end;
type TH122Digits=array of TH122Digit;
var h122Window,h122Alphabet:longint;

procedure H122PrepareWindows(level:longint);
var w:longint; 
begin
w:=level div 3; if w<3 then w:=3;
if w=h122Window then exit;
h122Window:=w; h122Alphabet:=1 shl w;

end;

function H122Read(const a:THPolyW; first:longint):TH122Digit;
var i,at,key:longint;
begin
key:=0;
for i:=0 to h122Window-1 do
  begin
  at:=first+i;
  if (at>=0) and (at<=a.d) and HPWGet(a,at) then inc(key,1 shl i);
  end;
H122Read:=H122DigitAt(key);
end;

procedure H122Export(const digits:TH122Digits; skip,count:longint; out a:THPolyW);
var i,at:longint;
begin
if count<=0 then begin HPWZero(a); exit; end;
HPWAlloc(a,(count+31) shr 5);
for i:=0 to count-1 do
  begin
  at:=i+skip;
  if H122DigitBit(digits[at div h122Window],at mod h122Window) then a.v^[i shr 5]:=a.v^[i shr 5] or (LongWord(1) shl (i and 31));
  end;
HPWNorm(a);
end;

{ multiples[k,*] is b(x)*x^pad*k(x). In division the top coefficient
  of b sits on a window boundary, so the last digit permutes the keys. }
procedure H122Multiples(const b:THPolyW; pad:longint; out tab:TH122Digits; out stride:longint);
var j,lead,k,i,offset,base:longint;
begin
stride:=(b.d+pad+h122Window-1) div h122Window+1;
SetLength(tab,h122Alphabet*stride);
for j:=0 to h122Window-1 do
  begin
  lead:=1 shl j; base:=lead*stride;
  for i:=0 to stride-1 do tab[base+i]:=H122Read(b,i*h122Window-pad-j);
  for k:=1 to lead-1 do
    begin
    offset:=k*stride;
    for i:=0 to stride-1 do tab[base+offset+i]:=H122Plus(tab[base+i],tab[offset+i]);
    end;
  end;
end;

procedure H122Product(const a,b:THPolyW; out c:THPolyW);
var tab,dst:TH122Digits; stride,count,i,j,base:longint;
begin
if a.d>b.d then begin H122Product(b,a,c); exit; end;
if (a.d<=8) or (b.d<=512) then begin H121ShortProduct(a,b,c); exit; end;
H122Multiples(a,0,tab,stride); count:=b.d div h122Window+1;
SetLength(dst,count+stride);
for i:=0 to count-1 do
  begin
  base:=H122Key(H122Read(b,i*h122Window))*stride;
  if base<>0 then for j:=0 to stride-1 do dst[i+j]:=H122Plus(dst[i+j],tab[base+j]);
  end;
H122Export(dst,0,a.d+b.d+1,c);
end;

procedure H122DivRem(const a,b:THPolyW; out q,r:THPolyW);
var tab,work,quot,decode:TH122Digits; ah,bh,rest,prod:THPolyW;
var qd,pad,stride,head,rows,i,j,base:longint;
begin
qd:=a.d-b.d;
if (b.d<=8) or (qd<=8) or (a.d<=512) then begin HPWDivRemClassic(a,b,q,r); exit; end;
if qd<b.d then
  begin
  { Quotient depends only on the top 2*qd+1 and qd+1 bits. }
  HPWShiftDown(a,b.d-qd,ah); HPWShiftDown(b,b.d-qd,bh);
  HPWDivRemClassic(ah,bh,q,rest); H122Product(q,b,prod); HPWAdd(a,prod,r); exit;
  end;
pad:=(h122Window-b.d mod h122Window) mod h122Window;
H122Multiples(b,pad,tab,stride); head:=(b.d+pad) div h122Window;
SetLength(decode,h122Alphabet);
for i:=0 to h122Alphabet-1 do decode[H122Key(tab[i*stride+head])]:=H122DigitAt(i);
rows:=qd div h122Window+1; SetLength(quot,rows); SetLength(work,rows+stride);
for i:=0 to rows+head-1 do work[i]:=H122Read(a,i*h122Window-pad);
for i:=rows-1 downto 0 do
  begin
  quot[i]:=decode[H122Key(work[i+head])]; base:=H122Key(quot[i])*stride;
  if base<>0 then for j:=0 to head do work[i+j]:=H122Plus(work[i+j],tab[base+j]);
  end;
H122Export(quot,0,qd+1,q); H122Export(work,pad,b.d,r);
end;

function H121ExactQuotient(const a,b:THPolyW; out q:THPolyW):boolean;
var rem:THPolyW;
begin
if b.d=0 then begin q:=a; H121ExactQuotient:=true; exit; end;
H122DivRem(a,b,q,rem);
H121ExactQuotient:=rem.d<0;
end;

{ First remove the common factor using only residues modulo cert.
  For A=a/g, B=b/g, C=cert/g, find s*A+t*B=1 (mod C).
  Then h=s*v0+t*u0 (mod C) makes both quotients below exact:
      U=(u0+B*h)/C, V=(v0+A*h)/C. }
function H121LiftBezout(const a,b,cert,u0,v0:THPolyW; out g,u,v:THPolyW):boolean;
var ra,rb,d,s,t,e,ei,q,r,ap,bp,cp,h,left,right,tmp:THPolyW;
begin
H121LiftBezout:=false;
if b.d<0 then begin g:=a; HPWOne(u); HPWZero(v); H121LiftBezout:=true; exit; end;
if a.d<0 then begin g:=b; HPWZero(u); HPWOne(v); H121LiftBezout:=true; exit; end;
H122DivRem(a,cert,q,ra); H122DivRem(b,cert,q,rb);
HPWXGCD(ra,rb,d,s,t);
HPWXGCD(d,cert,g,s,t);
if not H121ExactQuotient(a,g,ap) then exit;
if not H121ExactQuotient(b,g,bp) then exit;
if not H121ExactQuotient(cert,g,cp) then exit;
HPWZero(h);
if cp.d>0 then
  begin
  H122DivRem(ap,cp,q,ra); H122DivRem(bp,cp,q,rb);
  HPWXGCD(ra,rb,d,s,t);
  HPWXGCD(d,cp,e,ei,tmp);
  if e.d<>0 then exit;
  H122DivRem(v0,cp,q,ra); H122DivRem(u0,cp,q,rb);
  HPWMul(s,ra,left); HPWMul(t,rb,right); HPWAdd(left,right,tmp);
  H122DivRem(tmp,cp,q,r);
  HPWMul(ei,r,tmp); H122DivRem(tmp,cp,q,h);
  end;
H122Product(bp,h,left); HPWAdd(u0,left,tmp);
if not H121ExactQuotient(tmp,cp,u) then exit;
H122Product(ap,h,right); HPWAdd(v0,right,tmp);
if not H121ExactQuotient(tmp,cp,v) then exit;
{ Match the degree bounds and the equal-input tie of HPXGCD. }
if (ap.d=0) and (bp.d=0) then begin HPWZero(u); HPWOne(v); end
else if ap.d>=bp.d then
  begin
  H122DivRem(v,ap,q,r); v:=r;
  H122Product(bp,q,left); HPWAdd(u,left,tmp); u:=tmp;
  end
else
  begin
  H122DivRem(u,bp,q,r); u:=r;
  H122Product(ap,q,right); HPWAdd(v,right,tmp); v:=tmp;
  end;
H121LiftBezout:=true;
end;

{ t <= 4*k^2*sqrt(k). Logarithmic coefficient windows give
  O(nn + nn*t/k^2) word/table operations on these cores. }
function H121NearPower(const va,vb:TVec; var vg,vu,vv:TVec; hi,nn:longint;
                       out degree:longint):boolean;
var period,power,distance,mirror,level:longint;
var p,q,trace:TH121Fib;
var cert,g,u,v,u0,v0,a,b,f,one,shifted:THPolyW;
begin
H121NearPower:=false;
if (nn<1024) or odd(nn) or (nn>=High(longint) div 2) then exit;
period:=nn+1; power:=1; level:=0;
while power<=period div 2 do begin power:=power shl 1; inc(level); end;
if period-power>2*power-period then begin power:=power shl 1; inc(level); end;
distance:=abs(period-power);
if distance<3 then exit;
if nn<=10000 then
  begin if int64(distance)*distance>16*level then exit; end
else if int64(distance)*distance>int64(16)*level*level*level*level*level then exit;
H122PrepareWindows(level);
mirror:=longint(2*int64(power)-period);
H121GcdScratch(hi);
H121FibPair(distance-1,p,q); H121TimesT(p,trace);
HPWOne(one); HPWAdd(one,trace.b,cert);
if cert.d<0 then exit;
H121FibPair((mirror-1) div 2,p,q);
HPWAdd(p.a,q.a,f); HPWAdd(p.b,q.b,b);
HPWAdd(f,b,u0); H121TimesU(b,shifted); HPWAdd(u0,shifted,v0);
HPWFromVec(va,hi,a); HPWFromVec(vb,hi,b);
if not H121LiftBezout(a,b,cert,u0,v0,g,u,v) then exit;
if (g.d>hi) or (u.d>hi) or (v.d>hi) then exit;
HPWToVec(g,vg,hi); HPWToVec(u,vu,hi); HPWToVec(v,vv,hi);
degree:=g.d; H121NearPower:=true;
end;

{ Only call this wrapper on D-family inputs constructed from an EVEN
  Fibonacci index nn. Arbitrary polynomial pairs still use GcdU. }
function GcdD(const va,vb:TVec; var vg,vu,vv:TVec; hi:longint; nn:longword):longint;
var k,p,j,step,period,m2,size,savedForce,savedBackend:longint;
var rootMask,ma,mb,mg,ra,rb,gv,av,bd,cv,hv,da,db,uf,vf,ss,tt:TH104Array;
var a,b,gx,hp,cp,ux,vx,dp,bp,prod,num,rem,gu,su,sv,ag,bg,quot,ur,vr,t0,t1:THPolyW;
var fieldValue,traceValue:LongWord;
begin
if not h114FixedComparison and H121NearPower(va,vb,vg,vu,vv,hi,longint(nn),p) then
  begin GcdD:=p; exit; end;
if h114FixedComparison or (h102Backend=7) then begin GcdD:=GcdU(va,vb,vg,vu,vv,hi); exit; end;
k:=H104FieldFor(nn);
if (k=0) or (TopBitLE(vb,hi)<0) then
  begin GcdD:=GcdU(va,vb,vg,vu,vv,hi); exit; end;
H104Prepare(k);
period:=longint(nn)+1; m2:=longint(nn) div 2; step:=h104Order div period;
SetLength(rootMask,h104Count);
if longint(nn)=h104Count then
  begin
  { H110: generate the same Q/2 roots in O(Q), retaining the
    original O(Q*k) trace scan as an exact guarded fallback. }
  if not H110TorusRoots(rootMask,period) then
  begin
  for p:=1 to h104Count-1 do
    begin
    fieldValue:=H104Inverse(p); traceValue:=fieldValue;
    for j:=1 to h104K-1 do
      begin fieldValue:=H104Square(fieldValue); traceValue:=traceValue xor fieldValue; end;
    if traceValue>1 then Halt(224);
    rootMask[p]:=traceValue;
    end;
  end;
  end
else if (h104Count+1) mod period=0 then
  begin
  if not H110TorusRoots(rootMask,period) then
    begin GcdD:=GcdU(va,vb,vg,vu,vv,hi); exit; end;
  end
else
  for j:=1 to period-1 do
    begin
    p:=j*step; fieldValue:=h104Exp[p] xor h104Exp[h104Order-p];
    rootMask[fieldValue]:=1;
    end;
SetLength(ma,h104Count); SetLength(mb,h104Count); SetLength(mg,h104Count);
SetLength(ra,h104Count); SetLength(rb,h104Count);
for p:=0 to h104Count-1 do
  begin
  ma[p]:=rootMask[h104Point[p]]; mb[p]:=rootMask[h104Point[p] xor 1];
  mg[p]:=ma[p] and mb[p]; ra[p]:=ma[p] and (1 xor mb[p]);
  rb[p]:=mb[p] and (1 xor ma[p]);
  end;
H104RootValues(mg,gv);
for p:=0 to h104Count-1 do if mg[p]<>0 then gv[p]:=0;
H104Interpolate(gv);
H104RootValues(ra,av); H104RootValues(rb,bd);
SetLength(cv,h104Count); SetLength(hv,h104Count);
for p:=0 to h104Count-1 do if rb[p]<>0 then
  begin
  cv[p]:=H104Inverse(bd[p]); hv[p]:=H104Mul(cv[p],H104Inverse(av[p]));
  end;
H104Interpolate(cv); H104Interpolate(hv);
SetLength(da,h104Count); SetLength(db,h104Count);
for p:=0 to m2 do
  if ((m2-p) and (p shl 1))=0 then da[p]:=1;
Move(da[0],db[0],h104Count*SizeOf(LongWord)); H104Translate(db);
{ Exact GF(2) products keep the selected backend here. Only the NTT
  range switches to its local NTT mode for this calculation. }
savedForce:=h102Force; savedBackend:=h102Backend;
if h102Backend=4 then begin h102Force:=3; h102Backend:=3; end;
size:=(h104Count+31) shr 5;
if Length(qPool)<size*128 then SetLength(qPool,size*128);
if Length(qA)<size then SetLength(qA,size); if Length(qB)<size then SetLength(qB,size);
if Length(qC)<size then SetLength(qC,size);
if Length(qR)<size*2 then SetLength(qR,size*2); if Length(qS)<size*2 then SetLength(qS,size*2);
if Length(qWork)<size*10 then SetLength(qWork,size*10);
qTop:=0;
HPWFromVec(va,hi,a); HPWFromVec(vb,hi,b);
H104FromField(gv,gx); H104FromField(hv,hp); H104FromField(cv,cp);
HPWDivRem(hp,cp,ux,rem); if rem.d>=0 then Halt(227);
H104FromField(da,dp); H104FromField(db,bp);
HPWMul(ux,dp,prod); HPWAdd(gx,prod,num);
HPWDivRem(num,bp,vx,rem); if rem.d>=0 then Halt(227);
H104ToField(ux,uf); H104ToField(vx,vf);
SetLength(ss,h104Count); SetLength(tt,h104Count);
for p:=0 to h104Count-1 do ss[p]:=uf[p] xor vf[p];
tt[0]:=vf[0];
for p:=1 to h104Count-1 do tt[p]:=ss[p-1] xor vf[p];
H104Project(gv,gu,true); H104Project(ss,su,false); H104Project(tt,sv,false);
HPWDivRem(a,gu,ag,rem); if rem.d>=0 then Halt(227);
HPWDivRem(b,gu,bg,rem); if rem.d>=0 then Halt(227);
{ Canonical u modulo b/g makes the result identical to extended Euclid,
  rather than merely returning some valid Bezout pair. }
HPWDivRem(su,bg,quot,ur); HPWMul(quot,ag,t0); HPWAdd(sv,t0,vr);
HPWMul(ur,a,t0); HPWMul(vr,b,t1); HPWAdd(t0,t1,num);
if not H104Equal(num,gu) then Halt(228);
HPWToVec(gu,vg,hi); HPWToVec(ur,vu,hi); HPWToVec(vr,vv,hi);
GcdD:=gu.d;
qTop:=0; h102Force:=savedForce; h102Backend:=savedBackend;
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


function CoeffByte(const coeff:TVec; first,degmax:longint):LongWord; inline;
var keep:longint;
begin
if first>degmax then begin CoeffByte:=0; exit; end;
keep:=degmax-first+1;
if keep>8 then keep:=8;
CoeffByte:=((coeff[first shr 5] shr (first and 31)) and $FF) and ((LongWord(1) shl keep)-1);
end;








{ Only words touching the nonnegative Laurent half are needed. }

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
if (mode=0) and (degmax=(hi+1) div 2) then
  begin
  bit0:=0; if DynBit(combo,0)<>0 then bit0:=$FFFFFFFF;
  lastWord:=(hi div 2) shr 5;
  for w0:=0 to lastWord do
    begin
    p:=w0 shl 5;
    vdst[w0]:=ReadDyn32(combo,p+1) xor ReadDyn32Reverse(combo,hi-p+1) xor bit0;
    end;
  for w0:=(hi div 2+1) shr 5 to hi shr 5 do
    begin
    keep:=hi div 2+1-w0*32; if keep<0 then keep:=0;
    q0:=Reverse32(ReadVec32Any(vdst,hi-w0*32-31));
    if keep=0 then vdst[w0]:=q0 else vdst[w0]:=(vdst[w0] and LowMask32(keep)) or (q0 and not LowMask32(keep));
    end;
  MaskDeg(vdst,hi); exit;
  end;
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
procedure ApplyFibonacciFastW(const src:TVec; var dst:TVec; hi,degree:longint; summed:boolean=false; knownSymmetric:boolean=false);
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
if not knownSymmetric then for p:=0 to (hi div 2) shr 5 do
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
GcdD(sa,sb,tg,tu,tv,h,cur);
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

{ Same x=J*y stencil as A, with 32 coefficients per LongWord. }
{ Read 32 reflected coefficients, splitting only at zero boundaries.
  Forward reads, word reversal, masks and shifts preserve the scalar map. }
function H107Read32(const v:TVec; p:longint):LongWord;
var l,period,done,take:longint; value,r:LongWord;
begin
l:=longint(n)+1; period:=l*2; done:=0; r:=0;
p:=(p+1) mod period; if p<0 then inc(p,period);
while done<32 do
  begin
  if (p=0) or (p=l) then begin inc(p); inc(done); end
  else
    begin
    take:=32-done;
    if p<l then
      begin
      if take>l-p then take:=l-p;
      value:=ReadVec32Any(v,p-1);
      end
    else
      begin
      if take>period-p then take:=period-p;
      value:=ReverseWord32(ReadVec32Any(v,period-p-32));
      end;
    r:=r xor ((value and LowMask32(take)) shl done);
    inc(p,take); inc(done,take);
    end;
  if p=period then p:=0;
  end;
H107Read32:=r;
end;

procedure H107Apply(const src:TVec; var dst:TVec; const coeff:TH107Small; degree:longint);
var a,b,tmp:PVec; j,w,p:longint; value:LongWord;
begin
a:=@h107Work[0]; b:=@h107Work[1]; VecCopy(a^,src);
for j:=degree-1 downto 0 do
  begin
  for w:=0 to wn-1 do
    begin
    p:=w shl 5;
    value:=H107Read32(a^,p-h107Step) xor H107Read32(a^,p+h107Step);
    if coeff[j] then value:=value xor src[w];
    b^[w]:=value;
    end;
  MaskDeg(b^,longint(n)-1);
  tmp:=a; a:=b; b:=tmp;
  end;
VecCopy(dst,a^); MaskDeg(dst,longint(n)-1);
end;

procedure H107FirstRow;
var t:TVec; w,p:longint;
begin
H107Apply(y,t,h107Q,h107QDeg);
for w:=0 to wn-1 do
  begin
  p:=w shl 5;
  x[w]:=ReadVec32Any(t,p-1) xor t[w] xor ReadVec32Any(t,p+1);
  end;
MaskDeg(x,longint(n)-1);
end;

function H107Check:boolean;
var t:TVec; w,p:longint; value:LongWord;
begin
H107Apply(x,t,h107P,h107PDeg); H107Check:=true;
for w:=0 to nWord do
  begin
  p:=w shl 5;
  value:=ReadVec32Any(y,p-1) xor y[w] xor ReadVec32Any(y,p+1);
  if w=nWord then value:=value and nMask;
  if t[w]<>value then H107Check:=false;
  end;
end;

{ A canonical first row has support 0..n-deg(g)-1. Restrict the
  cycle equations to that support before elimination, preserving the
  exact solution selected by SolveXFast, even when the operator is singular. }
type TH108Line=array[0..63] of boolean;
     TH108Matrix=array[0..63] of TH108Line;
     TH108Slots=array[0..63] of longint;
     TH108Plan=record
       rows,cols,rank:longint;
       rowSlot,colSlot,pivot:TH108Slots;
       transform:TH108Matrix;
       nullVector:TH108Line;
       nullity:longint;
     end;
var h108Source,h108Null:TVec;
var h108NullCount:longint;

procedure H108Prepare;
var f0,f1,f2,c,ra,rb:TH107Small;
var j,k,d,db,d0:longint;
begin
if h114FixedComparison then begin h108Ready:=false; exit; end;
h108Ready:=false;
if h107Ready or (n=0) or (n>=LongWord(High(longint) div 2-1)) then exit;
h108B:=longint(n)+1; h107Step:=1;
while (h108B and 1)=0 do begin h108B:=h108B div 2; h107Step:=h107Step*2; end;
if (h108B<=1) or (h108B>31) then exit;
FillChar(f0,SizeOf(f0),0); FillChar(f1,SizeOf(f1),0); f1[0]:=true;
for j:=1 to h108B-1 do
  begin
  f2[0]:=f0[0];
  for k:=1 to High(f2) do f2[k]:=f0[k] xor f1[k-1];
  f0:=f1; f1:=f2;
  end;
FillChar(c,SizeOf(c),0);
for j:=h108B-1 downto 0 do
  begin
  for k:=High(c) downto 1 do c[k]:=c[k] xor c[k-1];
  c[0]:=c[0] xor f1[j];
  end;
h107P:=c;
for k:=High(h107P) downto 1 do h107P[k]:=h107P[k] xor h107P[k-1];
h107PDeg:=H107Degree(h107P);
ra:=f1; rb:=c;
while H107Degree(rb)>=0 do
  begin
  d:=H107Degree(ra); db:=H107Degree(rb);
  if d<db then begin f2:=ra; ra:=rb; rb:=f2; d:=H107Degree(ra); db:=H107Degree(rb); end;
  if db<0 then break;
  for k:=0 to db do ra[k+d-db]:=ra[k+d-db] xor rb[k];
  end;
d0:=H107Degree(ra);
h108Length:=longint(n)-h107Step*d0;
if h108B mod 3=0 then dec(h108Length,2*(h107Step-1));
if (h108Length<0) or (h108Length>longint(n)) then exit;
h108Ready:=true;
end;

function H108Position(r,slot:longint):longint; inline;
var p,l:longint;
begin
l:=longint(n)+1; p:=r+slot*h107Step;
if p>l then p:=l*2-p;
H108Position:=p;
end;

function H108MakePlan(r:longint; out plan:TH108Plan):boolean;
var a:TH108Matrix; line:TH108Line;
var cyc,tmp:TH108Line;
var positions:TH108Slots;
var count,i,j,k,t,p,row,col,rank,freeCol:longint;
var duplicate:boolean;
begin
H108MakePlan:=false; plan:=Default(TH108Plan);
FillChar(a,SizeOf(a),0); count:=h108B*2;
for j:=0 to count-1 do positions[j]:=H108Position(r,j);
for j:=0 to count-1 do
  if (positions[j]>0) and (positions[j]<=longint(n)) then
    begin
    duplicate:=false;
    for i:=0 to plan.rows-1 do if positions[plan.rowSlot[i]]=positions[j] then duplicate:=true;
    if not duplicate then
      begin
      plan.rowSlot[plan.rows]:=j; inc(plan.rows);
      if positions[j]<=h108Length then begin plan.colSlot[plan.cols]:=j; inc(plan.cols); end;
      end;
    end;
for col:=0 to plan.cols-1 do
  begin
  for j:=0 to count-1 do cyc[j]:=positions[j]=positions[plan.colSlot[col]];
  for k:=h107PDeg-1 downto 0 do
    begin
    for j:=0 to count-1 do
      begin
      p:=j-1; if p<0 then p:=count-1;
      t:=j+1; if t=count then t:=0;
      tmp[j]:=cyc[p] xor cyc[t] xor (h107P[k] and (positions[j]=positions[plan.colSlot[col]]));
      end;
    cyc:=tmp;
    end;
  for row:=0 to plan.rows-1 do a[row,col]:=cyc[plan.rowSlot[row]];
  end;
for row:=0 to plan.rows-1 do plan.transform[row,row]:=true;
rank:=0;
for col:=0 to plan.cols-1 do
  begin
  row:=rank;
  while (row<plan.rows) and not a[row,col] do inc(row);
  if row=plan.rows then continue;
  line:=a[row]; a[row]:=a[rank]; a[rank]:=line;
  line:=plan.transform[row]; plan.transform[row]:=plan.transform[rank]; plan.transform[rank]:=line;
  for i:=0 to plan.rows-1 do if (i<>rank) and a[i,col] then
    for j:=0 to 63 do
      begin a[i,j]:=a[i,j] xor a[rank,j]; plan.transform[i,j]:=plan.transform[i,j] xor plan.transform[rank,j]; end;
  plan.pivot[rank]:=col; inc(rank);
  end;
plan.rank:=rank; plan.nullity:=plan.cols-rank;
if plan.nullity>1 then exit;
if plan.nullity=1 then
  begin
  freeCol:=-1;
  for col:=0 to plan.cols-1 do
    begin
    duplicate:=false;
    for row:=0 to rank-1 do if plan.pivot[row]=col then duplicate:=true;
    if not duplicate then freeCol:=col;
    end;
  if freeCol<0 then exit;
  plan.nullVector[freeCol]:=true;
  for row:=0 to rank-1 do plan.nullVector[plan.pivot[row]]:=a[row,freeCol];
  end;
H108MakePlan:=true;
end;

var h108Kernel:TWordArray;

function H108Seed(const v:TVec):boolean;
var w:longint; value:LongWord;
begin
value:=0;
for w:=0 to nWord do
  value:=value xor (v[w] and (ReadDyn32(h108Kernel,w*32) xor ReadDyn32(h108Kernel,w*32+2)) and LowMask32(longint(n)-w*32));
value:=value xor (value shr 16); value:=value xor (value shr 8);
value:=value xor (value shr 4); value:=value xor (value shr 2);
H108Seed:=((value xor (value shr 1)) and 1)<>0;
end;

function H108Gather(const v:TVec; r,slot:longint):LongWord;
var p:longint;
begin
p:=H108Position(r,slot)-1;
if slot<h108B then H108Gather:=ReadVec32Any(v,p)
else H108Gather:=ReverseWord32(ReadVec32Any(v,p-31));
end;

procedure H108Scatter(var v:TVec; r,slot,take:longint; value:LongWord);
var p,w,shift:longint;
begin
p:=H108Position(r,slot)-1; value:=value and LowMask32(take);
if slot>=h108B then begin p:=p-take+1; value:=ReverseWord32(value) shr (32-take); end;
w:=p shr 5; shift:=p and 31;
v[w]:=v[w] xor (value shl shift);
if (shift<>0) and (w<mw) then v[w+1]:=v[w+1] xor (value shr (32-shift));
end;

function H108Group(first,last:longint):boolean;
var plan:TH108Plan; rhs,value:array[0..63] of LongWord;
var r,i,j,col,take:longint; mask:LongWord;
begin
H108Group:=false;
if first>last then begin H108Group:=true; exit; end;
if not H108MakePlan(first,plan) then exit;
r:=first;
while r<=last do
  begin
  take:=last-r+1; if take>32 then take:=32; mask:=LowMask32(take);
  for i:=0 to plan.rows-1 do rhs[i]:=H108Gather(h108Source,r,plan.rowSlot[i]) and mask;
  for i:=0 to plan.rows-1 do
    begin
    value[i]:=0;
    for j:=0 to plan.rows-1 do if plan.transform[i,j] then value[i]:=value[i] xor rhs[j];
    if (i>=plan.rank) and (value[i]<>0) then exit;
    end;
  for i:=0 to plan.rank-1 do
    begin col:=plan.pivot[i]; H108Scatter(x,r,plan.colSlot[col],take,value[i]); end;
  if plan.nullity=1 then
    begin
    inc(h108NullCount,take); if h108NullCount>1 then exit;
    for col:=0 to plan.cols-1 do if plan.nullVector[col] then H108Scatter(h108Null,r,plan.colSlot[col],take,1);
    end;
  inc(r,take);
  end;
H108Group:=true;
end;

function H108FirstRow:boolean;
var w,p,half:longint; seed:boolean;
begin
H108FirstRow:=false;
if not h108Ready then exit;
h108Ready:=false;
VecZero(x); VecZero(h108Null); h108NullCount:=0;
for w:=0 to wn-1 do
  begin p:=w shl 5; h108Source[w]:=ReadVec32Any(y,p-1) xor y[w] xor ReadVec32Any(y,p+1); end;
MaskDeg(h108Source,longint(n)-1);
half:=h107Step div 2;
if not H108Group(0,0) then exit;
if half>0 then if not H108Group(1,1) then exit;
if half>2 then if not H108Group(2,half-1) then exit;
if half>1 then if not H108Group(half,half) then exit;
MaskDeg(x,longint(n)-1); MaskDeg(h108Null,longint(n)-1);
BuildFibonacciHalfKernelW(longint(n),h108Kernel,(longint(n)+35) shr 5);
seed:=H108Seed(x);
if h108NullCount=1 then
  begin
  if not H108Seed(h108Null) then exit;
  if seed<>(GetBit(y,0)<>0) then VecXorEq(x,h108Null);
  end
else if seed<>(GetBit(y,0)<>0) then exit;
h108Ready:=true; H108FirstRow:=true;
end;

function H108Check:boolean;
var t:TVec; w,p:longint; value:LongWord;
begin
H107Apply(x,t,h107P,h107PDeg); H108Check:=H108Seed(x)=(GetBit(y,0)<>0);
for w:=0 to nWord do
  begin
  p:=w shl 5; value:=ReadVec32Any(y,p-1) xor y[w] xor ReadVec32Any(y,p+1);
  if w=nWord then value:=value and nMask;
  if t[w]<>value then H108Check:=false;
  end;
end;

procedure H103FirstRow;
begin
VecZero(x);
VecXorIHTo(x,y,longint(n)-1);
MaskDeg(x,longint(n)-1);
end;

{ Same tridiagonal recurrence as A. If q[i]=t[i+1], then
  q=src/(1+t+t^2)=src*(1+t)/(1+t^3). The three residue-class
  prefixes compute q in one word scan, including the word carries.
  A second scan fixes the homogeneous boundary and shifts q back. }
procedure H103InverseJ(const src:TVec; var dst:TVec);
const phase:array[0..2] of LongWord=($DB6DB6DB,$B6DB6DB6,$6DB6DB6D);
var p:longint; value,prevInput,prevQ,leftQ,curQ,seed:LongWord;
begin
VecZero(dst);
prevInput:=0; prevQ:=0;
for p:=0 to nWord do
  begin
  value:=src[p] xor (src[p] shl 1) xor prevInput xor (prevQ shr 29);
  prevInput:=src[p] shr 31;
  value:=value xor (value shl 3);
  value:=value xor (value shl 6);
  value:=value xor (value shl 12);
  value:=value xor (value shl 24);
  dst[p]:=value; prevQ:=value;
  end;
seed:=GetBit(dst,longint(n)-1);
leftQ:=0;
for p:=0 to nWord do
  begin
  curQ:=dst[p]; value:=(curQ shl 1) xor (leftQ shr 31);
  if seed<>0 then value:=value xor phase[p mod 3];
  dst[p]:=value; leftQ:=curQ;
  end;
MaskDeg(dst,longint(n)-1);
end;

{ H117. Write n+1=b*s, s a power of two. On the reflected cycle R
  is the one-site shift, J=1+R+R^-1, and Z=R^s has period 2*b.
  J*F_n(J) = (J*F_(b-1)(J))^s = P(Z) in characteristic two.
  Invert P modulo Z^(2*b)+1. Unit P implies both factors on the
  path are invertible. The unique first row is J*Q(Z)*y.
  Preparation costs O(b^2), each application O(n*b), storage O(n).
  The cutoff admits b=O(log n); general sizes retain the older bound. }
type TH117Poly=array of boolean;
var h117P,h117Q:TH117Poly;
var h117Stride:longint;
var h117Ready:boolean;

function H117Prepare:boolean;
var half:TWordArray;
var prev,cur,left,right,u,v,tmp:TH117Poly;
var b,l,p,j,k,d,e,shift,bits:longint;
begin
H117Prepare:=false;
if h114FixedComparison or (n<16384) or (n>=LongWord(High(longint) div 4)) then exit;
l:=longint(n)+1;
if (l and 127)<>0 then exit;
b:=l; h117Stride:=1;
while (b and 1)=0 do begin b:=b shr 1; h117Stride:=h117Stride shl 1; end;
bits:=0; p:=l;
while p>0 do begin inc(bits); p:=p shr 1; end;
if (h102Backend=7) and (b>127) then exit;
if (b<=31) or (b>4*bits) or (h117Stride<8*b) or (b mod 3=0) then exit;
l:=2*b;
BuildFibonacciHalfKernelW(b-1,half,(b+33) shr 5);
SetLength(prev,l); SetLength(cur,l);
for p:=0 to l-1 do
  begin
  j:=p; if j>b then j:=l-j;
  if j<b then cur[p]:=((half[j shr 5] shr (j and 31)) and 1)<>0;
  end;
for p:=0 to l-1 do prev[p]:=cur[p] xor cur[(p+l-1) mod l] xor cur[(p+1) mod l];
h117P:=prev;
SetLength(left,l+1); left[l]:=true; left[0]:=true;
right:=Copy(prev,0,l); SetLength(right,l+1);
SetLength(u,l); SetLength(v,l); v[0]:=true;
d:=l; e:=l-1; while (e>=0) and not right[e] do dec(e);
while e>=0 do
  begin
  if d<e then
    begin
    tmp:=left; left:=right; right:=tmp;
    tmp:=u; u:=v; v:=tmp; k:=d; d:=e; e:=k;
    if e<0 then break;
    end;
  shift:=d-e;
  for p:=0 to e do left[p+shift]:=left[p+shift] xor right[p];
  for p:=0 to l-1 do
    begin k:=p+shift; if k>=l then dec(k,l); u[k]:=u[k] xor v[p]; end;
  while (d>=0) and not left[d] do dec(d);
  end;
if d<>0 then exit;
{ Certify the inverse by cyclic multiplication before selecting this path. }
for k:=0 to l-1 do
  begin
  cur[k]:=false;
  for p:=0 to l-1 do cur[k]:=cur[k] xor (u[p] and h117P[(k+l-p) mod l]);
  if cur[k]<>(k=0) then exit;
  end;
h117Q:=u; H117Prepare:=true;
end;

procedure H117Apply(const src:TVec; var dst:TVec; const coeff:TH117Poly);
var cycle:array of LongWord;
var l,k,p,start:longint;

{ Equal input stripes contribute the same vector. Reduce their
  multiplicities mod 2, then reuse an output with the same coefficients.
  CompareByte checks every byte before sharing, including on altered inputs. }
function FoldStripes:boolean;
type TParity=array[0..15] of boolean;
var sourceId,representative:array of longint;
var saved:array of TParity; mask:TParity;
var count,width,i,j,id,row,col,q:longint;
begin
FoldStripes:=false; count:=0; width:=h117Stride shr 5;
SetLength(sourceId,Length(coeff)); SetLength(representative,16);
for i:=0 to High(sourceId) do
  begin
  id:=0;
  while id<count do
    begin
    if CompareByte(cycle[i*width],cycle[representative[id]*width],width*SizeOf(cycle[0]))=0 then break;
    inc(id);
    end;
  if id=count then
    begin
    if count=16 then exit;
    representative[id]:=i; inc(count);
    end;
  sourceId[i]:=id;
  end;
SetLength(saved,Length(coeff) div 2);
for row:=0 to High(saved) do
  begin
  FillChar(mask,SizeOf(mask),0);
  for j:=0 to High(coeff) do if coeff[j] then
    begin
    col:=row+j; if col>=Length(coeff) then dec(col,Length(coeff));
    id:=sourceId[col]; mask[id]:=not mask[id];
    end;
  i:=0;
  while i<row do
    begin
    if CompareByte(mask,saved[i],SizeOf(mask))=0 then break;
    inc(i);
    end;
  if i<row then Move(dst[i*width],dst[row*width],width*SizeOf(dst[0]))
  else for id:=0 to count-1 do if mask[id] then
    for q:=0 to width-1 do dst[row*width+q]:=dst[row*width+q] xor cycle[representative[id]*width+q];
  saved[row]:=mask;
  end;
FoldStripes:=true;
end;
begin
l:=wn; SetLength(cycle,3*l);
for p:=0 to l-1 do
  begin
  cycle[p]:=src[p]; cycle[p+l]:=ReverseWord32(ReadVec32Any(src,longint(n)-32-(p shl 5)));
  cycle[p+2*l]:=cycle[p];
  end;
VecZero(dst);
if not FoldStripes then
for k:=0 to High(coeff) do if coeff[k] then
  begin
  start:=k*(h117Stride shr 5);
  for p:=0 to l-1 do dst[p]:=dst[p] xor cycle[start+p];
  end;
VecNorm(dst);
end;

procedure H117FirstRow;
var t:TVec; p:longint;
begin
H117Apply(y,t,h117Q);
for p:=0 to wn-1 do x[p]:=ReadVec32Any(t,(p shl 5)-1) xor t[p] xor ReadVec32Any(t,(p shl 5)+1);
MaskDeg(x,longint(n)-1);
end;

function H117Check:boolean;
var t:TVec; p:longint; value:LongWord;
begin
H117Apply(x,t,h117P); H117Check:=true;
for p:=0 to nWord do
  begin
  value:=ReadVec32Any(y,(p shl 5)-1) xor y[p] xor ReadVec32Any(y,(p shl 5)+1);
  if p=nWord then value:=value and nMask;
  if t[p]<>value then H117Check:=false;
  end;
end;

type TH118SolveWork=record
  gu,qu,qv,sa,sb,hu,su,sv,z:TVec;
end;
var h118SolveWork:TH118SolveWork;

{ H119. Binary Laurent composition in two Frobenius axes.
  Split P(Y) at B, a power of two, and use u(t)^B=u(t^B).
  A length 4B-1 multiplicative Fourier transform separates the powers
  -2(B-1)..2(B-1). Each extension coordinate carries a separate fiber. }
type TH119Ints=array of longint;
type TH119Native=LongWord;
type TH119Plan=record
  zech:TH119Ints;
  order,w,step:longint;
  power,logarithm,reduce,whereU,chirp:TH119Ints;
  forwardKernel,inverseKernel:TH119Bits;
end;
var h119Plans:array of TH119Plan;

function H119RowBit(const a:TVec; i:longint):boolean; inline;
begin H119RowBit:=GetBit(a,i)<>0; end;

procedure H119RowOne(var a:TVec; i:longint); inline;
begin a[i shr 5]:=a[i shr 5] or (LongWord(1) shl (i and 31)); end;

procedure H119ClearRow(var a:TVec); inline;
begin VecZero(a); end;

procedure H119PutIndex(var a:TH119Bits; pos,w,index:longint); inline;
var j:longint;
begin
for j:=0 to w-1 do if index and (1 shl j)<>0 then H119Flip(a,pos+j);
end;

function H119ReadIndex(const a:TH119Bits; pos,w:longint):longint; inline;
var j,value:longint;
begin
value:=0; for j:=0 to w-1 do if H119Bit(a,pos+j) then value:=value or (1 shl j);
H119ReadIndex:=value;
end;

function H119XorIndex(a,b,w:longint):longint; inline;
begin H119XorIndex:=a xor b; end;

function H119MulPower(const plan:TH119Plan; index,exponent:longint):longint; inline;
begin
if index=0 then H119MulPower:=0
else H119MulPower:=plan.power[(plan.logarithm[index]+exponent) mod plan.order];
end;

procedure H119MakePlan(var plan:TH119Plan; w:longint);
var d,poly,field,i,x,k,v,ex:longint;
begin
if plan.w=w then exit;
field:=1 shl w; d:=field-1; plan.order:=d; plan.w:=w; plan.step:=2*w-1;
poly:=field+1;
repeat
  x:=1; i:=0;
  repeat x:=x shl 1; if x>=field then x:=x xor poly; inc(i); until x=1;
  if i=d then break;
  inc(poly,2);
until poly>=2*field;
if poly>=2*field then Halt(230);
SetLength(plan.power,d); SetLength(plan.logarithm,field); SetLength(plan.reduce,field div 2);
SetLength(plan.whereU,d); SetLength(plan.chirp,d); x:=1;
for i:=0 to d-1 do
  begin
  plan.power[i]:=x; plan.logarithm[x]:=i;
  x:=x shl 1; if x>=field then x:=x xor poly;
  end;
if d<=4095 then
  begin
  SetLength(plan.zech,d);
  for i:=1 to d-1 do plan.zech[i]:=plan.logarithm[1 xor plan.power[i]];
  end;
for i:=1 to field div 2-1 do
  begin
  x:=plan.reduce[i shr 1] shl 1; if x>=field then x:=x xor poly;
  if odd(i) then x:=x xor (poly-field);
  plan.reduce[i]:=x;
  end;
H119Space(plan.forwardKernel,d*plan.step); H119Space(plan.inverseKernel,d*plan.step);
ex:=0;
for k:=0 to d-1 do
  begin
  plan.chirp[k]:=ex;
  H119PutIndex(plan.forwardKernel,k*plan.step,w,plan.power[(d-ex) mod d]);
  H119PutIndex(plan.inverseKernel,k*plan.step,w,plan.power[ex]);
  ex:=(ex+k+(d+1) div 2) mod d;
  v:=plan.power[k] xor plan.power[(d-k) mod d] xor plan.power[(2*k) mod d] xor plan.power[(2*d-2*k) mod d];
  if v=0 then plan.whereU[k]:=-1 else plan.whereU[k]:=plan.logarithm[v];
  end;
end;

{ A bounded mixed-radix DFT leaf for the small multiplicative groups
  in the composition plan. Children read strided subsequences; an
  output at k combines child outputs at k mod m. }
type TH119NativeVec=array of TH119Native;
function H119NativeKey(const a:TH119Native):longint; inline;
begin H119NativeKey:=longint(a); end;

function H119NativeValue(const plan:TH119Plan; i:longint):TH119Native; inline;
begin H119NativeValue:=LongWord(i); end;

function H119NativeBit(const a:TH119Native; bit:longint):boolean; inline;
begin H119NativeBit:=((a shr bit) and 1)<>0; end;

procedure H119NativeTransform(var data:TH119Bits; const plan:TH119Plan; inverse:boolean);
var input,left,right:TH119NativeVec; i,j,d:longint;
procedure Transform(var dst,tmp:TH119NativeVec; first,stride,at,len:longint);
var radix,m,j,k,u,step,power,key,term,diff,acc,sgn:longint;
begin
if len=1 then begin dst[at]:=input[first]; exit; end;
radix:=3; while (len mod radix)<>0 do inc(radix,2);
m:=len div radix;
for j:=0 to radix-1 do Transform(tmp,dst,first+j*stride,stride*radix,at+j*m,m);
sgn:=d div len; if inverse then sgn:=d-sgn;
step:=0; u:=0;
for k:=0 to len-1 do
  begin
  acc:=-1; power:=0;
  for j:=0 to radix-1 do
    begin
    key:=H119NativeKey(tmp[at+j*m+u]);
    if key<>0 then
      begin
      term:=plan.logarithm[key]+power; if term>=d then dec(term,d);
      if acc<0 then acc:=term
      else if acc=term then acc:=-1
      else
        begin
        diff:=term-acc; if diff<0 then inc(diff,d);
        inc(acc,plan.zech[diff]); if acc>=d then dec(acc,d);
        end;
      end;
    inc(power,step); if power>=d then dec(power,d);
    end;
  if acc<0 then dst[at+k]:=H119NativeValue(plan,0)
  else dst[at+k]:=H119NativeValue(plan,plan.power[acc]);
  inc(u); if u=m then u:=0;
  inc(step,sgn); if step>=d then dec(step,d);
  end;
end;
begin
d:=plan.order;
SetLength(input,d); SetLength(left,d); SetLength(right,d);
for i:=0 to d-1 do input[i]:=H119NativeValue(plan,H119ReadIndex(data,i*plan.w,plan.w));
Transform(left,right,0,1,0,d); H119Space(data,d*plan.w);
for i:=0 to d-1 do for j:=0 to plan.w-1 do if H119NativeBit(left[i],j) then H119Flip(data,i*plan.w+j);
end;

{ Bluestein on the odd cyclic group. In characteristic two, 1/D=1. }
procedure H119DFT(var data:TH119Bits; const plan:TH119Plan; inverse:boolean);
var a,prod:TH119Bits; w,d,step,span,i,j,at,other,ex,index,lo,hi:longint;
begin
if (plan.order<=4095) and not h119AllDFT then begin H119NativeTransform(data,plan,inverse); exit; end;
w:=plan.w; d:=plan.order; step:=plan.step; span:=d*step;
H119Space(a,span); H119Space(prod,2*span);
for i:=0 to d-1 do
  begin
  ex:=plan.chirp[i]; if inverse then ex:=d-ex;
  index:=H119ReadIndex(data,i*w,w);
  H119PutIndex(a,i*step,w,H119MulPower(plan,index,ex));
  end;
if inverse then H119Product(a,0,plan.inverseKernel,0,prod,0,span,span,2*span-1)
else H119Product(a,0,plan.forwardKernel,0,prod,0,span,span,2*span-1);
H119Space(data,w*d);
for i:=0 to d-1 do
  begin
  at:=i*step; other:=at+span; lo:=0; hi:=0;
  for j:=0 to w-1 do if H119Bit(prod,at+j) xor H119Bit(prod,other+j) then lo:=lo or (1 shl j);
  for j:=w to step-1 do if H119Bit(prod,at+j) xor H119Bit(prod,other+j) then hi:=hi or (1 shl (j-w));
  index:=H119XorIndex(lo,plan.reduce[hi],w); ex:=plan.chirp[i]; if inverse then ex:=d-ex;
  H119PutIndex(data,i*w,w,H119MulPower(plan,index,ex));
  end;
end;

procedure H119Axis(const src:TH119Bits; var dst:TH119Bits; const plan:TH119Plan;
                   rows,b,srcRow,srcTerm,dstRow,dstTerm:longint);
var a,values:TH119Bits; base,r,i,j,w,d,rad,count,at,k,constantTerm:longint;
begin
w:=plan.w; d:=plan.order; rad:=2*(b-1); base:=0;
while base<rows do
  begin
  count:=rows-base; if count>w then count:=w;
  H119Space(a,d*w);
  for r:=0 to count-1 do for i:=0 to b-1 do
    if H119Bit(src,(base+r)*srcRow+i*srcTerm) then H119Flip(a,i*w+r);
  constantTerm:=H119ReadIndex(a,0,w); H119DFT(a,plan,false);
  H119Space(values,d*w);
  for j:=0 to d-1 do
    begin
    k:=plan.whereU[j];
    if k<0 then H119PutIndex(values,j*w,w,constantTerm)
    else H119PutIndex(values,j*w,w,H119ReadIndex(a,k*w,w));
    end;
  H119DFT(values,plan,true);
  for i:=-rad to rad do
    begin
    k:=i; if k<0 then inc(k,d); at:=(i+rad)*dstTerm+base*dstRow;
    for r:=0 to count-1 do if H119Bit(values,k*w+r) then H119Flip(dst,at+r*dstRow);
    end;
  inc(base,count);
  end;
end;

{ The center of the output is 2*degree, including for a zero input. }
procedure H119Compose(const coeff:TVec; degree:longint; var resultBits:TH119Bits);
var input,first,second,current,next:TH119Bits; b,w,rad,span,i,j,k,center:longint;
begin
center:=2*degree; H119Space(resultBits,2*center+1);
if degree<=32 then
  begin
  H119Space(current,2*center+1);
  for i:=degree downto 0 do
    begin
    H119Space(next,2*center+1); k:=2*(degree-i-1);
    for j:=-k to k do if H119Bit(current,center+j) then
      begin
      H119Flip(next,center+j-2); H119Flip(next,center+j-1);
      H119Flip(next,center+j+1); H119Flip(next,center+j+2);
      end;
    if H119RowBit(coeff,i) then H119Flip(next,center);
    current:=next; next:=nil;
    end;
  resultBits:=current; exit;
  end;
b:=1; w:=2; while Int64(b)*b<=degree do begin b:=b shl 1; inc(w); end;
rad:=2*(b-1); span:=2*rad+1;
if Length(h119Plans)<=w then SetLength(h119Plans,w+1);
H119MakePlan(h119Plans[w],w);
H119Space(input,b*b); H119Space(first,b*span); H119Space(second,span*span);
for i:=0 to degree do if H119RowBit(coeff,i) then H119Flip(input,i);
H119Axis(input,first,h119Plans[w],b,b,b,1,span,1);
H119Axis(first,second,h119Plans[w],span,b,1,span,1,span);
for j:=-rad to rad do
  for i:=-rad to rad do
    begin
    k:=center+i+b*j;
    if (k>=0) and (k<=2*center) then
      if H119Bit(second,(j+rad)*span+i+rad) then H119Flip(resultBits,k);
    end;
end;

procedure H119Fibonacci(const src:TVec; var dst:TVec; summed:boolean);
var kernel,cycle,op,prod:TH119Bits; half,period,i:longint;
begin
half:=longint(n)+1; period:=2*half;
if summed and (currentSumDegree=longint(n)) then kernel:=currentSumKernel
else BuildFibonacciHalfKernelW(longint(n),kernel,(longint(n)+34) shr 5,summed);
H119Space(cycle,period); H119Space(op,period); H119Space(prod,2*period);
if H119Bit(kernel,0) then H119Flip(op,0);
for i:=1 to longint(n) do
  begin
  if H119Bit(kernel,i) then begin H119Flip(op,i); H119Flip(op,period-i); end;
  if H119RowBit(src,i-1) then begin H119Flip(cycle,i); H119Flip(cycle,period-i); end;
  end;
H119Product(op,0,cycle,0,prod,0,period,period,2*period-1);
H119ClearRow(dst);
for i:=1 to longint(n) do if H119Bit(prod,i) xor H119Bit(prod,i+period) then H119RowOne(dst,i-1);
end;

{ Combine k Frobenius levels, R=2^k. An address encodes R input bits.
  Lookup entries describe nonzero Laurent offsets of sum b_j*u^j.
  R <= (log2 length)/2 keeps table construction and storage linear. }
type TH119OffsetTable=record
  start,offsets:TH119Ints;
end;
var h119OffsetPlan:array[0..5] of TH119OffsetTable;

function H119Log2(v:longint):longint; inline;
var k:longint;
begin k:=0; while v>1 do begin inc(k); v:=v shr 1; end; H119Log2:=k; end;

procedure H119Offsets(var plan:TH119OffsetTable; r:longint);
var polynomials,basis:TH119Bits; count,width,center,j,i,mask,at,step,total:longint;
begin
if Length(plan.start)<>0 then exit;
count:=1 shl r; center:=2*(r-1); width:=2*center+1;
H119Space(basis,r*width); H119Flip(basis,center);
for j:=1 to r-1 do
  for i:=2 to width-3 do if H119Bit(basis,(j-1)*width+i) then
    begin
    at:=j*width+i; H119Flip(basis,at-2); H119Flip(basis,at-1);
    H119Flip(basis,at+1); H119Flip(basis,at+2);
    end;
H119Space(polynomials,count*width); SetLength(plan.start,count+1);
total:=0; step:=1;
for j:=0 to r-1 do
  begin
  for mask:=0 to step-1 do
    begin
    at:=(step+mask)*width; plan.start[step+mask]:=total;
    for i:=0 to width-1 do
      if H119Bit(polynomials,mask*width+i) xor H119Bit(basis,j*width+i) then
        begin H119Flip(polynomials,at+i); inc(total); end;
    end;
  step:=step*2;
  end;
plan.start[count]:=total; SetLength(plan.offsets,total); total:=0;
for mask:=1 to count-1 do for i:=0 to width-1 do if H119Bit(polynomials,mask*width+i) then
  begin plan.offsets[total]:=i-center; inc(total); end;
end;

procedure H119GroupedCompose(const coeff:TVec; degree:longint; var dst:TH119Bits);
var a,b,swap:TH119Bits; length0,log0,k,radix,r,h,start,i,j,v,bits,at,d,center,cut:longint;
begin
length0:=1; while length0<=degree do length0:=2*length0;
log0:=H119Log2(length0); radix:=2; k:=1;
while (2*radix<=log0 div 2) do begin radix:=2*radix; inc(k); end;
H119Offsets(h119OffsetPlan[k],radix);
H119Space(a,4*length0); H119Space(b,4*length0);
for i:=0 to degree do if H119RowBit(coeff,i) then H119Flip(a,4*i);
h:=1;
while h<length0 do
  begin
  r:=length0 div h; if r>radix then r:=radix;
  FillChar(b[0],Length(b)*SizeOf(b[0]),0); start:=0;
  while start<length0 do
    begin
    for v:=0 to 4*(h-1) do
      begin
      bits:=0; at:=4*start+v;
      for j:=0 to r-1 do
        begin if H119Bit(a,at) then bits:=bits or (1 shl j); inc(at,4*h); end;
      at:=4*start+v+2*(r-1)*h;
      for i:=h119OffsetPlan[k].start[bits] to h119OffsetPlan[k].start[bits+1]-1 do
        H119Flip(b,at+h119OffsetPlan[k].offsets[i]*h);
      end;
    inc(start,r*h);
    end;
  swap:=a; a:=b; b:=swap; h:=h*r;
  end;
center:=2*(length0-1); cut:=center-2*degree; d:=4*degree+1;
H119Space(dst,d);
for i:=0 to d-1 do if H119Bit(a,cut+i) then H119Flip(dst,i);
end;

{ Batch k levels of the Fibonacci transfer on the reflected cycle.
  A group with smallest shift h sees a window of 2*(2^k)-1 entries
  along each stride-h orbit. Roll the lookup address once per output. }
type TH119Sums=array[0..2] of TH119Bits;
type TH119Int3=array[0..2] of longint;
type TH119Gates=array[0..2,0..2] of TH119Bits;

procedure H119WindowMaps(degree,lowBit,k,streams:longint; var maps:TH119Sums);
var taps,next:TH119Gates; rad,width,t,i,j,p,shift,idx,step,code,bit:longint;
var isOdd,va,vb,vs:boolean;
begin
rad:=(1 shl k)-1; width:=2*rad+1;
for i:=0 to streams-1 do for j:=0 to streams-1 do
  begin H119Space(taps[i,j],width); if i=j then H119Flip(taps[i,j],rad); end;
for t:=k-1 downto 0 do
  begin
  shift:=1 shl t; isOdd:=(degree and (lowBit shl t))<>0;
  for i:=0 to streams-1 do for j:=0 to streams-1 do H119Space(next[i,j],width);
  for j:=0 to streams-1 do for p:=0 to width-1 do
    begin
    va:=H119Bit(taps[0,j],p); vb:=H119Bit(taps[1,j],p);
    if streams=3 then
      begin
      vs:=H119Bit(taps[2,j],p); if isOdd then vs:=vs xor va else vs:=vs xor vb;
      if p>=shift then vs:=vs xor H119Bit(taps[2,j],p-shift);
      if p+shift<width then vs:=vs xor H119Bit(taps[2,j],p+shift);
      if vs then H119Flip(next[2,j],p);
      end;
    if va xor vb then H119Flip(next[ord(isOdd),j],p);
    if isOdd then idx:=0 else idx:=1;
    vs:=H119Bit(taps[idx,j],p);
    if p>=shift then vs:=vs xor H119Bit(taps[idx,j],p-shift);
    if p+shift<width then vs:=vs xor H119Bit(taps[idx,j],p+shift);
    if vs then H119Flip(next[idx,j],p);
    end;
  taps:=next;
  for i:=0 to streams-1 do for j:=0 to streams-1 do next[i,j]:=nil;
  end;
for j:=0 to streams-1 do
  begin
  H119Space(maps[j],3*(1 shl width)); step:=1;
  for t:=0 to width-1 do
    begin
    for i:=0 to streams-1 do
      begin
      va:=H119Bit(taps[i,j],t); bit:=3*step+i;
      for code:=0 to step-1 do
        if H119Bit(maps[j],3*code+i) xor va then H119Flip(maps[j],3*code+bit);
      end;
    step:=2*step;
    end;
  end;
end;

procedure H119GroupedFibonacci(const src:TVec; var dst:TVec; summed:boolean);
var a,b,swap,maps:TH119Sums; window:TH119Int3;
var period,half,degree,streams,bits,k,maxK,lowBit,h,rad,width,top,cycles,orbit,
    head,tail,base,p,j,i,steps,nextPos,index,output:longint; flag:boolean;
begin
degree:=longint(n); half:=degree+1; period:=2*half; streams:=2+ord(summed);
for i:=0 to streams-1 do begin H119Space(a[i],period); H119Space(b[i],period); end;
for i:=1 to degree do if H119RowBit(src,i-1) then
  begin H119Flip(a[0],i); H119Flip(a[0],period-i); end;
bits:=H119Log2(degree)+1; maxK:=1;
while ((1 shl (maxK+2))-1<=bits) do inc(maxK);
while bits>0 do
  begin
  k:=maxK; if k>bits then k:=bits; dec(bits,k);
  lowBit:=1 shl bits; h:=lowBit mod period; rad:=(1 shl k)-1;
  width:=2*rad+1; top:=1 shl (width-1);
  H119WindowMaps(degree,lowBit,k,streams,maps);
  for i:=0 to streams-1 do FillChar(b[i,0],Length(b[i])*SizeOf(b[i,0]),0);
  cycles:=1; while (cycles<lowBit) and ((period div cycles) and 1=0) do cycles:=cycles*2;
  steps:=period div cycles;
  for orbit:=0 to cycles-1 do
    begin
    head:=(Int64(orbit)+Int64(period)*rad-Int64(rad)*h) mod period;
    for j:=0 to streams-1 do window[j]:=0;
    tail:=head;
    for i:=0 to width-1 do
      begin
      for j:=0 to streams-1 do if H119Bit(a[j],tail) then window[j]:=window[j] or (1 shl i);
      inc(tail,h); if tail>=period then dec(tail,period);
      end;
    base:=orbit;
    for p:=1 to steps do
      begin
      for output:=0 to streams-1 do
        begin
        flag:=false;
        for j:=0 to streams-1 do
          begin index:=3*window[j]+output; flag:=flag xor H119Bit(maps[j],index); end;
        if flag then H119Flip(b[output],base);
        end;
      if p<steps then
        begin
        for j:=0 to streams-1 do
          begin
          window[j]:=window[j] shr 1;
          if H119Bit(a[j],tail) then window[j]:=window[j] or top;
          end;
        inc(tail,h); if tail>=period then dec(tail,period);
        end;
      nextPos:=base+h; if nextPos>=period then dec(nextPos,period); base:=nextPos;
      end;
    end;
  swap:=a; a:=b; b:=swap;
  end;
if summed then output:=2 else output:=0;
H119ClearRow(dst);
for i:=1 to degree do if H119Bit(a[output],i) then H119RowOne(dst,i-1);
end;

{ The blocked binary transform has smaller working sets at machine sizes.
  Both variants can exercise the full two-axis Bluestein path explicitly. }
{ Consecutive GF(2) coordinates are stored in windows of logarithmic width.
  In A the window is a reference to its Boolean tuple. An integer key is
  used only to address a tuple or gather disjoint parts of adjacent windows. }
type TH120Lane=LongWord;
type TH120Lanes=array of TH120Lane;
var h120W,h120Alphabet,h120Mask:longint;
    h120Leaf:TH120Lanes;


function H120Key(const a:TH120Lane):longint; inline;
begin H120Key:=longint(a); end;

function H120LaneAt(v:longint):TH120Lane; inline;
begin H120LaneAt:=LongWord(v); end;

function H120Plus(const a,b:TH120Lane):TH120Lane; inline;
begin H120Plus:=a xor b; end;

function H120LaneBit(const a:TH120Lane; i:longint):boolean; inline;
begin H120LaneBit:=(a and (LongWord(1) shl i))<>0; end;

procedure H120PrepareLanes(size:longint);
var w,lg,c,i,j,k,t,base:longint; powers:TH119Bits;
begin
lg:=0; t:=size; while t>1 do begin inc(lg); t:=t shr 1; end;
w:=8; while 2*w<=lg div 4 do w:=2*w;
if h120W=w then exit;
h120W:=w; c:=1 shl w; h120Alphabet:=c; h120Mask:=h120Alphabet-1;

{ Table entry v contains the full Laurent polynomial at offsets 0..4w-4,
  centered at 2(w-1). Separately tabulate the w single monomials. }
H119Space(powers,w*4*w); H119Flip(powers,2*(w-1));
for j:=1 to w-1 do
  for i:=2 to 4*w-3 do if H119Bit(powers,(j-1)*4*w+i) then
    begin
    base:=j*4*w+i; H119Flip(powers,base-2); H119Flip(powers,base-1);
    H119Flip(powers,base+1); H119Flip(powers,base+2);
    end;
SetLength(h120Leaf,4*c);
for k:=0 to 3 do h120Leaf[k]:=H120LaneAt(0);
for j:=0 to w-1 do
  for k:=0 to 3 do
    begin
    t:=0; for i:=0 to w-1 do if H119Bit(powers,j*4*w+k*w+i) then t:=t or (1 shl i);
    base:=1 shl j;
    for i:=0 to base-1 do h120Leaf[4*(base+i)+k]:=H120Plus(h120Leaf[4*i+k],H120LaneAt(t));
    end;
end;

procedure H120Compose(const coeff:TVec; degree:longint; var kernel:TH119Bits);
var a,b,swap:TH120Lanes; size,span,blocks,h,at,p,i,j,key,cut:longint;
    lo,hi:TH120Lane;
begin
H120PrepareLanes(degree+1);
size:=h120W; while size<=degree do size:=size*2;
blocks:=size div h120W; span:=4*blocks;
SetLength(a,span); SetLength(b,span);
for p:=0 to blocks-1 do
  begin
  key:=0; for j:=0 to h120W-1 do
    if (p*h120W+j<=degree) and H119RowBit(coeff,p*h120W+j) then key:=key or (1 shl j);
  for j:=0 to 3 do a[4*p+j]:=h120Leaf[4*key+j];
  end;
h:=1;
while h<blocks do
  begin
  for j:=0 to span-1 do b[j]:=H120LaneAt(0);
  at:=0;
  while at<span do
    begin
    for i:=0 to 4*h-1 do
      begin
      lo:=a[at+i]; hi:=a[at+4*h+i];
      b[at+i]:=H120Plus(b[at+i],hi);
      b[at+h+i]:=H120Plus(b[at+h+i],hi);
      b[at+2*h+i]:=H120Plus(b[at+2*h+i],lo);
      b[at+3*h+i]:=H120Plus(b[at+3*h+i],hi);
      b[at+4*h+i]:=H120Plus(b[at+4*h+i],hi);
      end;
    inc(at,8*h);
    end;
  swap:=a; a:=b; b:=swap; h:=2*h;
  end;
H119Space(kernel,4*degree+1); cut:=2*(size-1-degree);
for i:=0 to 4*degree do if H120LaneBit(a[(cut+i) div h120W],(cut+i) mod h120W) then H119Flip(kernel,i);
end;

function H120CyclicWindow(const a:TH120Lanes; at,period:longint):TH120Lane; inline;
var p,remn,span,key:longint;
begin
p:=at div h120W; remn:=at mod h120W;
key:=H120Key(a[p]) shr remn;
if remn<>0 then key:=key or ((H120Key(a[p+1]) shl (h120W-remn)) and h120Mask);
span:=period-at;
if span<h120W then key:=(key and ((1 shl span)-1)) or ((H120Key(a[0]) shl span) and h120Mask);
H120CyclicWindow:=H120LaneAt(key);
end;

procedure H120Fibonacci(const src:TVec; var dst:TVec; summed:boolean);
var a,b,c,na,nb,nc,swap:TH120Lanes; v,vshift:TH120Lane;
    period,half,slots,i,j,pos,k,mask,h,low,high:longint; oddStep:boolean;
begin
half:=longint(n)+1; period:=2*half; H120PrepareLanes(period);
if period<h120W then begin H119GroupedFibonacci(src,dst,summed); exit; end;
slots:=(period+h120W-1) div h120W;
SetLength(a,slots+1); SetLength(b,slots+1); SetLength(na,slots+1); SetLength(nb,slots+1);
if summed then begin SetLength(c,slots+1); SetLength(nc,slots+1); end;
for i:=0 to slots-1 do
  begin
  k:=0;
  for j:=0 to h120W-1 do
    begin
    pos:=i*h120W+j;
    if pos<period then
      begin
      if pos>half then pos:=period-pos;
      if (pos>0) and (pos<half) and H119RowBit(src,pos-1) then k:=k or (1 shl j);
      end;
    end;
  a[i]:=H120LaneAt(k);
  end;
mask:=1; while mask<=longint(n) div 2 do mask:=mask*2;
while mask>0 do
  begin
  oddStep:=(longint(n) and mask)<>0; h:=mask mod period; high:=h; low:=(period-h) mod period;
  for i:=0 to slots-1 do
    begin
    if oddStep then
      begin
      v:=a[i]; vshift:=H120Plus(H120CyclicWindow(a,low,period),H120CyclicWindow(a,high,period));
      na[i]:=H120Plus(v,vshift); nb[i]:=H120Plus(v,b[i]);
      end
    else
      begin
      v:=b[i]; vshift:=H120Plus(H120CyclicWindow(b,low,period),H120CyclicWindow(b,high,period));
      nb[i]:=H120Plus(v,vshift); na[i]:=H120Plus(a[i],v);
      end;
    if summed then
      begin
      vshift:=H120Plus(H120CyclicWindow(c,low,period),H120CyclicWindow(c,high,period));
      nc[i]:=H120Plus(H120Plus(c[i],vshift),v);
      end;
    inc(low,h120W); if low>=period then dec(low,period);
    inc(high,h120W); if high>=period then dec(high,period);
    end;
  swap:=a; a:=na; na:=swap; swap:=b; b:=nb; nb:=swap;
  if summed then begin swap:=c; c:=nc; nc:=swap; end;
  mask:=mask shr 1;
  end;
if summed then a:=c;
H119ClearRow(dst);
for i:=1 to longint(n) do if H120LaneBit(a[i div h120W],i mod h120W) then H119RowOne(dst,i-1);
end;

function H119UseDFT:boolean; inline;
begin H119UseDFT:=h119AllDFT;
end;

procedure H119Z(const qu,qv:TVec; var dst:TVec);
var cycle:TH119Bits; i,half,period:longint; parity:boolean;
procedure Accumulate(const poly:TVec; applyH:boolean);
var kernel:TH119Bits; degree,center,j,k:longint;
begin
degree:=longint(n div 2); while degree>=0 do
  begin if H119RowBit(poly,degree) then break; dec(degree); end;
if degree<0 then exit;
if H119UseDFT then H119Compose(poly,degree,kernel) else H120Compose(poly,degree,kernel);
center:=2*degree;
for j:=0 to 2*center do if H119Bit(kernel,j) then
  begin
  k:=(j-center+period) mod period;
  if applyH then begin H119Flip(cycle,(k+period-1) mod period); H119Flip(cycle,(k+1) mod period); end
  else H119Flip(cycle,k);
  end;
end;
begin
half:=longint(n)+1; period:=2*half;
H119Space(cycle,period); Accumulate(qu,true); Accumulate(qv,false);
parity:=false; for i:=0 to period-1 do parity:=parity xor H119Bit(cycle,i);
H119ClearRow(dst);
for i:=1 to longint(n) do if parity xor H119Bit(cycle,i) xor H119Bit(cycle,i+half) then H119RowOne(dst,i-1);
if H119UseDFT then H119Fibonacci(dst,dst,true) else H120Fibonacci(dst,dst,true);
end;

procedure H119SolveX(const g,rhs:TVec; var dst:TVec; degree:longint);
var den,iv,square,next,rev,answer:TH119Bits; len,dl,known,want,i,take:longint;
begin
len:=longint(n)-2*degree; H119ClearRow(dst); if len<=0 then exit;
if (not h119AllDFT) and (degree<=32) then begin SolveXFast(g,rhs,dst,degree); exit; end;
if H119UseDFT then H119Compose(g,degree,den) else H120Compose(g,degree,den); dl:=4*degree+1; if dl>len then dl:=len;
if not H119Bit(den,0) then Halt(231);
H119Space(iv,1); H119Flip(iv,0); known:=1;
while known<len do
  begin
  want:=2*known; if want>len then want:=len;
  H119Space(square,want); H119Space(next,want);
  for i:=0 to (want-1) div 2 do if H119Bit(iv,i) then H119Flip(square,2*i);
  take:=dl; if take>want then take:=want;
  H119Product(den,0,square,0,next,0,take,want,want); iv:=next; next:=nil; known:=want;
  end;
H119Space(rev,len); H119Space(answer,len);
for i:=0 to len-1 do if H119RowBit(rhs,longint(n)-1-i) then H119Flip(rev,i);
H119Product(rev,0,iv,0,answer,0,len,len,len);
for i:=0 to len-1 do if H119Bit(answer,i) then H119RowOne(dst,len-1-i);
end;

procedure CalcMat2;
var r0,rU:longint;
var m2,hiS,rr:longint;
var ag,au,av:QWord;
begin
with h118SolveWork do
begin
TimeMark('c');
TimeMark('q');
h117Ready:=H117Prepare;
if h117Ready then
  begin
  TimeMark('z'); H117FirstRow; TimeMark('d'); exit;
  end;
if H103Dyadic then
  begin
  TimeMark('z');
  H103FirstRow;
  TimeMark('d');
  exit;
  end;
if h107Ready then
  begin
  TimeMark('z');
  H107FirstRow;
  TimeMark('d');
  exit;
  end;
{ Failed guards fall back before emitting any extra timing label. }
if h108Ready and H108FirstRow then
  begin
  TimeMark('z');
  TimeMark('d');
  exit;
  end;
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
  rr:=GcdD(sa,sb,hu,su,sv,hiS,n);
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
if h102Backend=7 then H119Z(qu,qv,z)
else
  begin
  ApplyUComboOnesW(qu,qv,z,n-1,longint(n div 2),0);
  ApplyFibonacciFastW(z,z,n-1,longint(n),true,true);
  end;
TimeMark('d');
if r0=0 then
  begin
  VecCopy(x,z);
  end
else
begin
TimeMark('x');
if h102Backend=7 then H119SolveX(gu,z,x,rU) else SolveXFast(gu,z,x,rU);
end;
end;
end;

function GeneMat():boolean;
var t:TVec;
var wn0:longint;
var mask0:LongWord;
var k2:longint;
begin
TimeMark('g');
if h117Ready then begin GeneMat:=H117Check; FinishGenTiming; write(GeneMat); exit; end;
if h108Ready then begin GeneMat:=H108Check; FinishGenTiming; write(GeneMat); exit; end;
if h107Ready then begin GeneMat:=H107Check; FinishGenTiming; write(GeneMat); exit; end;
if H103Dyadic then H103InverseJ(x,t)
else if h102Backend=7 then
  begin if H119UseDFT then H119Fibonacci(x,t,false) else H120Fibonacci(x,t,false); end
else
ApplyFastUComboW(f,c,x,t,n-1,longint(n div 2),2);
wn0:=(longint(n)+31) shr 5;
if (longint(n) and 31)=0 then mask0:=$FFFFFFFF else mask0:=(LongWord(1) shl (longint(n) and 31))-1;
GeneMat:=true;
for k2:=0 to wn0-2 do GeneMat:=GeneMat and (t[k2]=y[k2]);
GeneMat:=GeneMat and (((t[wn0-1] xor y[wn0-1]) and mask0)=0);
FinishGenTiming; write(GeneMat);
end;

{ No arguments preserves the historical benchmark. The console build
  also accepts one board size, or an inclusive first and last size. }
function H118Size(const arg:ansistring):longint;
var err,value:longint;
begin
Val(arg,value,err);
if err<>0 then value:=0;
H118Size:=value;
end;

var firstN,lastN:longint;
begin
firstN:=9900; lastN:=10000;
{$ifdef disp}
firstN:=1; lastN:=m;
{$else}
if ParamCount>3 then
  begin writeln('Usage: diandeng [n [last_n [backend]]]'); halt(2); end;
if ParamCount>=1 then
  begin
  firstN:=H118Size(ParamStr(1));
  lastN:=firstN;
  end;
if ParamCount>=2 then
  begin
  lastN:=H118Size(ParamStr(2));
  end;
if (firstN<1) or (lastN<firstN) or (lastN>m) then
  begin writeln('Require 1 <= n <= last_n <= ',m); halt(2); end;
if ParamCount=3 then
  begin
  case ParamStr(3) of
    'auto','mix': h102Force:=0;
    'toom': h102Force:=6;
    'spectral': h102Force:=7;
    'spectral-dft': begin h102Force:=7; h119AllDFT:=true; end;
    'karatsuba': h102Force:=1;
    'fft': h102Force:=2;
    'ntt': h102Force:=4;
    'additive': h102Force:=5;
  else
    writeln('Backend must be auto, mix, karatsuba, toom, fft, ntt, additive, spectral or spectral-dft'); halt(2);
  end;
  h114FixedComparison:=h102Force<>0;
  end;
{$endif}
{$ifdef disp}
CreateWin(m,m);
bb:=CreateBB(GetWin());
bp:=CreateBMP(m,m);
{$endif}
QueryPerformanceFrequency(perfFreq);
hasLastCounter:=false;
InitMul8;
InitUKernel8;
warming:=true;
n:=lastN;
PrepN;
MakeMat();
warming:=false;
hasLastCounter:=false;
{$ifdef disp}
for n:=1 to m do
{$else}
for n:=firstN to lastN do
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
