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

const m=2000;

{ Strict A: every arithmetic data bit is Boolean. Integers hold constants,
  dimensions, addresses, lookup indices and timing. Fixed-width operators
  implement the same unsigned arithmetic as the corresponding packed B. }
type TBW16=array[0..15] of boolean;
     TBW32=array[0..31] of boolean;
     TBW64=array[0..63] of boolean;

function BW16(v:Word):TBW16; overload;
var i:longint;
begin for i:=0 to 15 do BW16[i]:=((v shr i) and 1)<>0; end;
operator :=(v:Word)r:TBW16;
begin r:=BW16(v); end;

function BW32(v:LongWord):TBW32; overload;
var i:longint;
begin for i:=0 to 31 do BW32[i]:=((v shr i) and 1)<>0; end;
operator :=(v:LongWord)r:TBW32;
begin r:=BW32(v); end;

function BW64(v:QWord):TBW64; overload;
var i:longint;
begin for i:=0 to 63 do BW64[i]:=((v shr i) and 1)<>0; end;
operator :=(v:QWord)r:TBW64;
begin r:=BW64(v); end;

function BW16(const v:TBW16):TBW16; overload;
var i:longint;
begin
for i:=0 to 15 do BW16[i]:=v[i];
end;

function BW16(const v:TBW32):TBW16; overload;
var i:longint;
begin
for i:=0 to 15 do BW16[i]:=v[i];
end;

function BW16(const v:TBW64):TBW16; overload;
var i:longint;
begin
for i:=0 to 15 do BW16[i]:=v[i];
end;

function BW32(const v:TBW16):TBW32; overload;
var i:longint;
begin
for i:=0 to 15 do BW32[i]:=v[i];
for i:=16 to 31 do BW32[i]:=false;
end;

operator :=(const v:TBW16)r:TBW32;
begin r:=BW32(v); end;

function BW32(const v:TBW32):TBW32; overload;
var i:longint;
begin
for i:=0 to 31 do BW32[i]:=v[i];
end;

function BW32(const v:TBW64):TBW32; overload;
var i:longint;
begin
for i:=0 to 31 do BW32[i]:=v[i];
end;

function BW64(const v:TBW16):TBW64; overload;
var i:longint;
begin
for i:=0 to 15 do BW64[i]:=v[i];
for i:=16 to 63 do BW64[i]:=false;
end;

operator :=(const v:TBW16)r:TBW64;
begin r:=BW64(v); end;

function BW64(const v:TBW32):TBW64; overload;
var i:longint;
begin
for i:=0 to 31 do BW64[i]:=v[i];
for i:=32 to 63 do BW64[i]:=false;
end;

operator :=(const v:TBW32)r:TBW64;
begin r:=BW64(v); end;

function BW64(const v:TBW64):TBW64; overload;
var i:longint;
begin
for i:=0 to 63 do BW64[i]:=v[i];
end;

function BWIndex(v:Int64):longint; overload;
begin if (v<Low(longint)) or (v>High(longint)) then Halt(231); BWIndex:=longint(v); end;

function BWIndex(const v:TBW16):longint; overload;
var i:longint;
begin
BWIndex:=0;
for i:=0 to 15 do if v[i] then BWIndex:=BWIndex or (longint(1) shl i);
end;

function BWIndex(const v:TBW32):longint; overload;
var i:longint;
begin
BWIndex:=0;
for i:=31 to 31 do if v[i] then Halt(231);
for i:=0 to 30 do if v[i] then BWIndex:=BWIndex or (longint(1) shl i);
end;

function BWIndex(const v:TBW64):longint; overload;
var i:longint;
begin
BWIndex:=0;
for i:=31 to 63 do if v[i] then Halt(231);
for i:=0 to 30 do if v[i] then BWIndex:=BWIndex or (longint(1) shl i);
end;

operator and(const a,b:TBW32)r:TBW32;
var i:longint;
begin for i:=0 to 31 do r[i]:=a[i] and b[i]; end;

operator or(const a,b:TBW32)r:TBW32;
var i:longint;
begin for i:=0 to 31 do r[i]:=a[i] or b[i]; end;

operator xor(const a,b:TBW32)r:TBW32;
var i:longint;
begin for i:=0 to 31 do r[i]:=a[i] xor b[i]; end;

operator not(const a:TBW32)r:TBW32;
var i:longint;
begin for i:=0 to 31 do r[i]:=not a[i]; end;

operator shl(const a:TBW32;b:longint)r:TBW32;
var i:longint;
begin
for i:=0 to 31 do if (b>=0) and (i>=b) then r[i]:=a[i-b] else r[i]:=false;
end;

operator shr(const a:TBW32;b:longint)r:TBW32;
var i:longint;
begin
for i:=0 to 31 do if (b>=0) and (i+b<32) then r[i]:=a[i+b] else r[i]:=false;
end;

function BWCompare32(const a,b:TBW32):longint;
var i:longint;
begin
BWCompare32:=0;
for i:=31 downto 0 do if a[i]<>b[i] then
  begin if a[i] then BWCompare32:=1 else BWCompare32:=-1;exit;end;
end;

operator =(const a,b:TBW32)r:boolean;
begin r:=BWCompare32(a,b)=0; end;

operator <>(const a,b:TBW32)r:boolean;
begin r:=BWCompare32(a,b)<>0; end;

operator <(const a,b:TBW32)r:boolean;
begin r:=BWCompare32(a,b)<0; end;

operator <=(const a,b:TBW32)r:boolean;
begin r:=BWCompare32(a,b)<=0; end;

operator >(const a,b:TBW32)r:boolean;
begin r:=BWCompare32(a,b)>0; end;

operator >=(const a,b:TBW32)r:boolean;
begin r:=BWCompare32(a,b)>=0; end;

operator +(const a,b:TBW32)r:TBW32;
var i:longint;carry,next:boolean;
begin
carry:=false;
for i:=0 to 31 do
  begin
  next:=(a[i] and b[i]) or (carry and (a[i] xor b[i]));r[i]:=a[i] xor b[i] xor carry;carry:=next;
  end;
end;

operator -(const a,b:TBW32)r:TBW32;
var i:longint;carry,next:boolean;
begin
carry:=false;
for i:=0 to 31 do
  begin
  next:=((not a[i]) and b[i]) or (carry and not(a[i] xor b[i]));r[i]:=a[i] xor b[i] xor carry;carry:=next;
  end;
end;

operator *(const a,b:TBW32)r:TBW32;
var i,j,k,hiA,hiB,last:longint;carry,next:boolean;
begin
FillChar(r,SizeOf(r),0);hiA:=31;hiB:=31;
while (hiA>=0) and not a[hiA] do dec(hiA);
while (hiB>=0) and not b[hiB] do dec(hiB);
for j:=0 to hiB do if b[j] then
  begin
  last:=hiA;if last>31-j then last:=31-j;carry:=false;
  for i:=0 to last do
    begin
    k:=i+j;next:=(r[k] and a[i]) or (carry and (r[k] xor a[i]));
    r[k]:=r[k] xor a[i] xor carry;carry:=next;
    end;
  k:=last+j+1;
  while carry and (k<32) do begin next:=r[k];r[k]:=not r[k];carry:=next;inc(k);end;
  end;
end;
procedure BWDivRem32(const a,b:TBW32;out q,r:TBW32);
var hiB,hiA,s:longint;t:TBW32;
begin
FillChar(q,SizeOf(q),0);r:=a;hiB:=31;hiA:=31;
while (hiB>=0) and not b[hiB] do dec(hiB);
if hiB<0 then Halt(232);
while (hiA>=0) and not a[hiA] do dec(hiA);
for s:=hiA-hiB downto 0 do
  begin
  t:=b shl s;
  if r>=t then begin r:=r-t;q[s]:=true;end;
  end;
end;
operator div(const a,b:TBW32)r:TBW32;
var t:TBW32;
begin BWDivRem32(a,b,r,t); end;
operator mod(const a,b:TBW32)r:TBW32;
var t:TBW32;
begin BWDivRem32(a,b,t,r); end;

operator and(const a,b:TBW64)r:TBW64;
var i:longint;
begin for i:=0 to 63 do r[i]:=a[i] and b[i]; end;

operator or(const a,b:TBW64)r:TBW64;
var i:longint;
begin for i:=0 to 63 do r[i]:=a[i] or b[i]; end;

operator xor(const a,b:TBW64)r:TBW64;
var i:longint;
begin for i:=0 to 63 do r[i]:=a[i] xor b[i]; end;

operator not(const a:TBW64)r:TBW64;
var i:longint;
begin for i:=0 to 63 do r[i]:=not a[i]; end;

operator shl(const a:TBW64;b:longint)r:TBW64;
var i:longint;
begin
for i:=0 to 63 do if (b>=0) and (i>=b) then r[i]:=a[i-b] else r[i]:=false;
end;

operator shr(const a:TBW64;b:longint)r:TBW64;
var i:longint;
begin
for i:=0 to 63 do if (b>=0) and (i+b<64) then r[i]:=a[i+b] else r[i]:=false;
end;

function BWCompare64(const a,b:TBW64):longint;
var i:longint;
begin
BWCompare64:=0;
for i:=63 downto 0 do if a[i]<>b[i] then
  begin if a[i] then BWCompare64:=1 else BWCompare64:=-1;exit;end;
end;

operator =(const a,b:TBW64)r:boolean;
begin r:=BWCompare64(a,b)=0; end;

operator <>(const a,b:TBW64)r:boolean;
begin r:=BWCompare64(a,b)<>0; end;

operator <(const a,b:TBW64)r:boolean;
begin r:=BWCompare64(a,b)<0; end;

operator <=(const a,b:TBW64)r:boolean;
begin r:=BWCompare64(a,b)<=0; end;

operator >(const a,b:TBW64)r:boolean;
begin r:=BWCompare64(a,b)>0; end;

operator >=(const a,b:TBW64)r:boolean;
begin r:=BWCompare64(a,b)>=0; end;

operator +(const a,b:TBW64)r:TBW64;
var i:longint;carry,next:boolean;
begin
carry:=false;
for i:=0 to 63 do
  begin
  next:=(a[i] and b[i]) or (carry and (a[i] xor b[i]));r[i]:=a[i] xor b[i] xor carry;carry:=next;
  end;
end;

operator -(const a,b:TBW64)r:TBW64;
var i:longint;carry,next:boolean;
begin
carry:=false;
for i:=0 to 63 do
  begin
  next:=((not a[i]) and b[i]) or (carry and not(a[i] xor b[i]));r[i]:=a[i] xor b[i] xor carry;carry:=next;
  end;
end;

operator *(const a,b:TBW64)r:TBW64;
var i,j,k,hiA,hiB,last:longint;carry,next:boolean;
begin
FillChar(r,SizeOf(r),0);hiA:=63;hiB:=63;
while (hiA>=0) and not a[hiA] do dec(hiA);
while (hiB>=0) and not b[hiB] do dec(hiB);
for j:=0 to hiB do if b[j] then
  begin
  last:=hiA;if last>63-j then last:=63-j;carry:=false;
  for i:=0 to last do
    begin
    k:=i+j;next:=(r[k] and a[i]) or (carry and (r[k] xor a[i]));
    r[k]:=r[k] xor a[i] xor carry;carry:=next;
    end;
  k:=last+j+1;
  while carry and (k<64) do begin next:=r[k];r[k]:=not r[k];carry:=next;inc(k);end;
  end;
end;
procedure BWDivRem64(const a,b:TBW64;out q,r:TBW64);
var hiB,hiA,s:longint;t:TBW64;
begin
FillChar(q,SizeOf(q),0);r:=a;hiB:=63;hiA:=63;
while (hiB>=0) and not b[hiB] do dec(hiB);
if hiB<0 then Halt(232);
while (hiA>=0) and not a[hiA] do dec(hiA);
for s:=hiA-hiB downto 0 do
  begin
  t:=b shl s;
  if r>=t then begin r:=r-t;q[s]:=true;end;
  end;
end;
operator div(const a,b:TBW64)r:TBW64;
var t:TBW64;
begin BWDivRem64(a,b,r,t); end;
operator mod(const a,b:TBW64)r:TBW64;
var t:TBW64;
begin BWDivRem64(a,b,t,r); end;

type TVec=array[-2..m]of boolean;
     PVec=^TVec;

var n:longword;
var i,j:longint;
var x,y,f,f1,c,c1:TVec;
var hf,hf1,hc,hc1:TVec;
var uKernel8:array[0..255,0..28] of boolean;



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

procedure VecZeroHi(var a:TVec;hi:longint);
begin
if hi<-2 then hi:=-2;
FillChar(a[-2],hi+3,0);
end;

procedure VecCopyHi(var a:TVec; const b:TVec; hi:longint);
begin
if hi<-2 then hi:=-2;
Move(b[-2],a[-2],hi+3);
end;

function PolyDeg(const a:TVec;hi:longint):longint;
begin
while (hi>=0) and not(a[hi]) do dec(hi);
PolyDeg:=hi;
end;
















procedure DoubleFCVec(nn:longword; const af,ac,af1,ac1:TVec;
                      var nf,nc,nf1,nc1:TVec; srcHi:longint);
var ii,hi0,e0,o0:longint;
begin
hi0:=longint(nn div 2);
if (nn and 1)=0 then
  begin
  { H96: only the last coefficient pair can cross the output boundary. }
  for ii:=0 to srcHi-1 do
    begin
    e0:=ii shl 1; o0:=e0+1;
      nf[e0]:=af[ii] xor af1[ii];
      nc[e0]:=ac[ii] xor ac1[ii];
      nf1[e0]:=false;
      nc1[e0]:=af1[ii] xor ac1[ii];
      nf[o0]:=ac[ii] xor ac1[ii];
      nc[o0]:=false;
      nf1[o0]:=ac1[ii];
      nc1[o0]:=ac1[ii];
    end;
  ii:=srcHi; e0:=ii shl 1; o0:=e0+1;
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
  end
else
  begin
  { H96: only the last coefficient pair can cross the output boundary. }
  for ii:=0 to srcHi-1 do
    begin
    e0:=ii shl 1; o0:=e0+1;
      nf[e0]:=false;
      nc[e0]:=af[ii] xor ac[ii];
      nf1[e0]:=af[ii] xor af1[ii];
      nc1[e0]:=ac[ii] xor ac1[ii];
      nf[o0]:=ac[ii];
      nc[o0]:=ac[ii];
      nf1[o0]:=ac[ii] xor ac1[ii];
      nc1[o0]:=false;
    end;
  ii:=srcHi; e0:=ii shl 1; o0:=e0+1;
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

procedure ApplyUComboOnes(const va,vb:TVec; var vdst:TVec; hi,degmax,mode:longint); forward;

procedure ApplyFibonacciOnes(var dst:TVec; degree:longint); forward;

procedure MakeMat();
begin
H102Select;
H107Prepare;
H108Prepare;

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

{ H80: reuse common XORs in the H79 64+96 split and fourteen products. }
{ H109: reuse the same eight-bit table indices across the fourteen
  fixed-leaf products. Coefficients and results remain Boolean. }
procedure CLMul32Indexed(a0,a1,a2,a3,b0,b1,b2,b3:longint; out p:TMul64Bool);
var z0,z1,z2:TMul32Bool; i:longint;
begin
if ((a0 or a1 or a2 or a3)=0) or ((b0 or b1 or b2 or b3)=0) then
  begin FillChar(p,SizeOf(p),0); exit; end;
CLMul16Bool(a0,a1,b0,b1,z0);
CLMul16Bool(a2,a3,b2,b3,z2);
CLMul16Bool(a0 xor a2,a1 xor a3,b0 xor b2,b1 xor b3,z1);
for i:=0 to 15 do
  begin
  p[i]:=z0[i]; p[16+i]:=z0[16+i] xor z0[i] xor z1[i] xor z2[i];
  p[32+i]:=z2[i] xor z0[16+i] xor z1[16+i] xor z2[16+i]; p[48+i]:=z2[16+i];
  end;
end;

procedure KarLeaf160(const a:TDynBool; ao:longint; const b:TDynBool; bo:longint;
                     var r:TDynBool; ro,alen,blen:longint);
var e0,e2,e1,f0,f1,f2,f01,f02,f12,g0,g1,g01,g02,g12:TMul64Bool;
var aa,bb:array[0..19] of longint;
var byteIndex,bitIndex,k:longint;
var i,last,lim:longint;
var t0,t1,t2,t3,t4:boolean;
begin
{ Cache each original byte once; the final 32-coefficient block is bounded. }
for byteIndex:=0 to 19 do
  begin
  aa[byteIndex]:=0; bb[byteIndex]:=0;
  for bitIndex:=0 to 7 do
    begin
    k:=byteIndex*8+bitIndex;
    if (k<128) or (k<alen) then aa[byteIndex]:=aa[byteIndex] or (ord(a[ao+k]) shl bitIndex);
    if (k<128) or (k<blen) then bb[byteIndex]:=bb[byteIndex] or (ord(b[bo+k]) shl bitIndex);
    end;
  end;
CLMul32Indexed(aa[0],aa[1],aa[2],aa[3],bb[0],bb[1],bb[2],bb[3],e0);
CLMul32Indexed(aa[4],aa[5],aa[6],aa[7],bb[4],bb[5],bb[6],bb[7],e2);
CLMul32Indexed(aa[0] xor aa[4],aa[1] xor aa[5],aa[2] xor aa[6],aa[3] xor aa[7],bb[0] xor bb[4],bb[1] xor bb[5],bb[2] xor bb[6],bb[3] xor bb[7],e1);
CLMul32Indexed(aa[8],aa[9],aa[10],aa[11],bb[8],bb[9],bb[10],bb[11],f0);
CLMul32Indexed(aa[12],aa[13],aa[14],aa[15],bb[12],bb[13],bb[14],bb[15],f1);
CLMul32Indexed(aa[16],aa[17],aa[18],aa[19],bb[16],bb[17],bb[18],bb[19],f2);
CLMul32Indexed(aa[8] xor aa[12],aa[9] xor aa[13],aa[10] xor aa[14],aa[11] xor aa[15],bb[8] xor bb[12],bb[9] xor bb[13],bb[10] xor bb[14],bb[11] xor bb[15],f01);
CLMul32Indexed(aa[8] xor aa[16],aa[9] xor aa[17],aa[10] xor aa[18],aa[11] xor aa[19],bb[8] xor bb[16],bb[9] xor bb[17],bb[10] xor bb[18],bb[11] xor bb[19],f02);
CLMul32Indexed(aa[12] xor aa[16],aa[13] xor aa[17],aa[14] xor aa[18],aa[15] xor aa[19],bb[12] xor bb[16],bb[13] xor bb[17],bb[14] xor bb[18],bb[15] xor bb[19],f12);
CLMul32Indexed(aa[0] xor aa[8],aa[1] xor aa[9],aa[2] xor aa[10],aa[3] xor aa[11],bb[0] xor bb[8],bb[1] xor bb[9],bb[2] xor bb[10],bb[3] xor bb[11],g0);
CLMul32Indexed(aa[4] xor aa[12],aa[5] xor aa[13],aa[6] xor aa[14],aa[7] xor aa[15],bb[4] xor bb[12],bb[5] xor bb[13],bb[6] xor bb[14],bb[7] xor bb[15],g1);
CLMul32Indexed(aa[0] xor aa[4] xor aa[8] xor aa[12],aa[1] xor aa[5] xor aa[9] xor aa[13],aa[2] xor aa[6] xor aa[10] xor aa[14],aa[3] xor aa[7] xor aa[11] xor aa[15],bb[0] xor bb[4] xor bb[8] xor bb[12],bb[1] xor bb[5] xor bb[9] xor bb[13],bb[2] xor bb[6] xor bb[10] xor bb[14],bb[3] xor bb[7] xor bb[11] xor bb[15],g01);
CLMul32Indexed(aa[0] xor aa[8] xor aa[16],aa[1] xor aa[9] xor aa[17],aa[2] xor aa[10] xor aa[18],aa[3] xor aa[11] xor aa[19],bb[0] xor bb[8] xor bb[16],bb[1] xor bb[9] xor bb[17],bb[2] xor bb[10] xor bb[18],bb[3] xor bb[11] xor bb[19],g02);
CLMul32Indexed(aa[4] xor aa[12] xor aa[16],aa[5] xor aa[13] xor aa[17],aa[6] xor aa[14] xor aa[18],aa[7] xor aa[15] xor aa[19],bb[4] xor bb[12] xor bb[16],bb[5] xor bb[13] xor bb[17],bb[6] xor bb[14] xor bb[18],bb[7] xor bb[15] xor bb[19],g12);
for i:=0 to 63 do
  begin
  t0:=e0[i] xor e2[i];
  t1:=e1[i] xor t0;
  t2:=f0[i] xor g0[i];
  t3:=f01[i] xor g1[i];
  t4:=f02[i] xor f1[i];
  g02[i]:=e2[i] xor g0[i] xor g02[i] xor g1[i] xor t4;
  g12[i]:=f0[i] xor f12[i] xor g12[i] xor t3;
  g01[i]:=f1[i] xor g01[i] xor t1 xor t2 xor t3;
  g0[i]:=t0 xor t2;
  e1[i]:=t1;
  f02[i]:=f0[i] xor f2[i] xor t4;
  f12[i]:=f1[i] xor f12[i] xor f2[i];
  end;
for i:=0 to 31 do
  begin
  r[ro+0+i]:=r[ro+0+i] xor e0[i];
  r[ro+32+i]:=r[ro+32+i] xor e0[32+i] xor e1[i];
  r[ro+64+i]:=r[ro+64+i] xor e1[32+i] xor g0[i];
  r[ro+96+i]:=r[ro+96+i] xor g0[32+i] xor g01[i];
  r[ro+128+i]:=r[ro+128+i] xor g01[32+i] xor g02[i];
  r[ro+160+i]:=r[ro+160+i] xor g02[32+i] xor g12[i];
  r[ro+192+i]:=r[ro+192+i] xor g12[32+i] xor f02[i];
  r[ro+224+i]:=r[ro+224+i] xor f02[32+i] xor f12[i];
  end;
lim:=alen+blen-1; last:=lim-256; if last>32 then last:=32;
for i:=0 to last-1 do r[ro+256+i]:=r[ro+256+i] xor f12[32+i] xor f2[i];
for i:=0 to lim-289 do r[ro+288+i]:=r[ro+288+i] xor f2[32+i];
end;

{ H81: remove whole zero coefficient blocks before choosing a product split. }
function KarTrimTop(const a:TDynBool; first,count:longint):longint; inline;
var base,i:longint;
begin
while count>0 do
  begin
  base:=(count-1) and not 31;
  for i:=count-1 downto base do
    if a[first+i] then begin KarTrimTop:=count; exit; end;
  count:=base;
  end;
KarTrimTop:=0;
end;

{ H93: common cutoff measured in logical coefficients, not packed words. }
const toomCut=6144;

procedure KarConv(const a:TDynBool; ao:longint; const b:TDynBool; bo:longint;
                 var r:TDynBool; ro,lenWords,alen,blen:longint;
                 var work:TDynBool; wo:longint); forward;

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
const nttMod:TBW32=(true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,true,true,true,true,false);
const nttZero:TBW32=(false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false);
const nttRoot:TBW32=(true,true,true,true,true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false);
const nttMaxLen=134217728;
const nttOne:TBW32=(false,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,false,false,false,false);
type TNTTArray=array of TBW32;
var nttRoots,nttInvRoots:TNTTArray;
var nttRootLength:longint;

{ Ordinary integer products with carry, distinct from h112Mul8's
  carryless table. Every result bit is Boolean; cached bytes are only
  lookup addresses, as in the original A leaf-index cache. }
type TH114IntegerTable=array[0..65535] of TBW16;
var h114IntegerMul8:TH114IntegerTable;
var h114IntegerReady:boolean;
procedure H114PrepareIntegerTable;
var a,b,bit,previous,index:longint; left,add,carry,next:boolean;
begin
if h114IntegerReady then exit;
FillChar(h114IntegerMul8,SizeOf(h114IntegerMul8),0);
for a:=1 to 255 do for b:=0 to 255 do
  begin
  previous:=(a shr 1) shl 8; index:=(a shl 8) or b; carry:=false;
  for bit:=0 to 15 do
    begin
    left:=false; if bit>0 then left:=h114IntegerMul8[previous+b,bit-1];
    add:=((a and 1)<>0) and (((b shr bit) and 1)<>0);
    next:=(left and add) or (carry and (left xor add));
    h114IntegerMul8[index,bit]:=left xor add xor carry; carry:=next;
    end;
  end;
h114IntegerReady:=true;
end;
function H114UInt32Product(const a,b:TBW32):TBW64;
var ai,bi:array[0..3]of longint;
var i,j,k,bit,base,index:longint; carry,next:boolean; product:TBW16;
begin
if not h114IntegerReady then H114PrepareIntegerTable;
for i:=0 to 3 do
  begin
  ai[i]:=0; bi[i]:=0;
  for bit:=0 to 7 do
    begin
    if a[i*8+bit] then ai[i]:=ai[i] or (1 shl bit);
    if b[i*8+bit] then bi[i]:=bi[i] or (1 shl bit);
    end;
  end;
FillChar(H114UInt32Product,SizeOf(H114UInt32Product),0);
for i:=0 to 3 do for j:=0 to 3 do if (ai[i]<>0) and (bi[j]<>0) then
  begin
  index:=(ai[i] shl 8) or bi[j]; product:=h114IntegerMul8[index];
  base:=(i+j)*8; carry:=false;
  for bit:=0 to 15 do
    begin
    k:=base+bit;
    next:=(H114UInt32Product[k] and product[bit]) or
          (carry and (H114UInt32Product[k] xor product[bit]));
    H114UInt32Product[k]:=H114UInt32Product[k] xor product[bit] xor carry; carry:=next;
    end;
  k:=base+16;
  while carry and (k<64) do
    begin next:=H114UInt32Product[k]; H114UInt32Product[k]:=not next; carry:=next; inc(k); end;
  end;
end;

function NTTMul(a,b:TBW32):TBW32; inline;
var t:TBW64; u,v:TBW32;
begin
if (a=nttZero) or (b=nttZero) then begin NTTMul:=nttZero; exit; end;
if b=nttOne then begin NTTMul:=a; exit; end;
if a=nttOne then begin NTTMul:=b; exit; end;
t:=H114UInt32Product(a,b);
{ -p^(-1)=15*2^27-1 mod 2^32, p=15*2^27+1. }
u:=BW32((BW32(t) shl 31)-(BW32(t) shl 27)-BW32(t));
{ t+u+u*2^31-u*2^27 < 2^64 since a,b<p<2^31. }
t:=t+BW64(u)+(BW64(u) shl 31)-(BW64(u) shl 27);
v:=BW32(t shr 32);
if v>=nttMod then v:=v-nttMod;
NTTMul:=v;
end;

function NTTPow(a,e:TBW32):TBW32;
var r:TBW32;
begin
r:=1;
while e<>0 do
  begin
  if (e and 1)<>0 then r:=BW32(H114UInt32Product(r,a) mod nttMod);
  a:=BW32(H114UInt32Product(a,a) mod nttMod); e:=e shr 1;
  end;
NTTPow:=r;
end;

procedure NTTPrepare(count:longint);
var root,invRoot:TBW32; j:longint;
begin
if count<=nttRootLength then exit;
root:=NTTPow(nttRoot,(nttMod-1) div BW32(count));
invRoot:=NTTPow(root,nttMod-2);
root:=BW32(H114UInt32Product(root,nttOne) mod nttMod);
invRoot:=BW32(H114UInt32Product(invRoot,nttOne) mod nttMod);
SetLength(nttRoots,count div 2); SetLength(nttInvRoots,count div 2);
nttRoots[BWIndex(0)]:=nttOne; nttInvRoots[BWIndex(0)]:=nttOne;
for j:=1 to count div 2-1 do
  begin
  nttRoots[BWIndex(j)]:=NTTMul(nttRoots[BWIndex(j-1)],root);
  nttInvRoots[BWIndex(j)]:=NTTMul(nttInvRoots[BWIndex(j-1)],invRoot);
  end;
nttRootLength:=count;
end;

procedure NTTForward(var a:TNTTArray; count:longint);
var span,half,base,j,stride,k:longint; u,v,s,d:TBW32;
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
      u:=a[BWIndex(base+j)]; v:=a[BWIndex(base+j+half)];
      s:=u+v; if s>=nttMod then s:=s-nttMod;
      if u>=v then d:=u-v else d:=u+nttMod-v;
      a[BWIndex(base+j)]:=s; a[BWIndex(base+j+half)]:=NTTMul(d,nttRoots[BWIndex(k)]);
      inc(k,stride);
      end;
    inc(base,span);
    end;
  span:=half;
  end;
end;

procedure NTTInverse(var a:TNTTArray; count:longint);
var span,half,base,j,stride,k:longint; u,v,s,d:TBW32;
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
      u:=a[BWIndex(base+j)]; v:=NTTMul(a[BWIndex(base+j+half)],nttInvRoots[BWIndex(k)]);
      s:=u+v; if s>=nttMod then s:=s-nttMod;
      if u>=v then d:=u-v else d:=u+nttMod-v;
      a[BWIndex(base+j)]:=s; a[BWIndex(base+j+half)]:=d;
      inc(k,stride);
      end;
    inc(base,span);
    end;
  span:=span*2;
  end;
end;

procedure FFTShift(const a:TDynBool; ao:longint;
                     var d:TDynBool; shift,m:longint);
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
      Move(a[ao+pos],d[dst],cnt*1);
      Move(a[ao+m+pos],d[m+dst],cnt*1);
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

procedure FFTTransform(var a:TDynBool; k,m:longint; inverse:boolean);
var v,w:TDynBool;
var i,j,h,rev,digit,step,third,block0,p0,p1,p2,q,root:longint;
var u0,u1,v0,v1,w0,w1,s0,s1,tmp:boolean;
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
      FFTShift(a,p1,v,q,m);
      q:=q*2; if q>=m*3 then dec(q,m*3);
      FFTShift(a,p2,w,q,m);
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

{ Inputs occupy 2*count elements; N=count*1=32*c*3^e (c=1 or 2).
  Returns a*b modulo t^(2N)+t^N+1. Of the 3K Fourier points,
  only the 2K indices not divisible by three are needed. }
procedure FFTRing(const a:TDynBool; ao:longint;
                    const b:TDynBool; bo:longint; var r:TDynBool; count:longint);
var aa,bb,p0,p1,pc,work:TDynBool;
var e,k,m,i,j,base,off0,off1,al,bl:longint;
begin
SetLength(r,count*2); FillChar(r[0],count*2*1,0);
if count*2*1<=H102RingCut(fftCut) then
  begin
  { Three half-size products, with reduction fused into recombination. }
  SetLength(aa,count); SetLength(bb,count);
  SetLength(p0,count*2); SetLength(p1,count*2); SetLength(pc,count*2);
  SetLength(work,count*5);
  for i:=0 to count-1 do
    begin aa[i]:=a[ao+i] xor a[ao+count+i]; bb[i]:=b[bo+i] xor b[bo+count+i]; end;
  al:=KarTrimTop(a,ao,count*1); bl:=KarTrimTop(b,bo,count*1);
  KarConv(a,ao,b,bo,p0,0,count*1 div 32,al,bl,work,0);
  al:=KarTrimTop(a,ao+count,count*1); bl:=KarTrimTop(b,bo+count,count*1);
  KarConv(a,ao+count,b,bo+count,p1,0,count*1 div 32,al,bl,work,0);
  al:=KarTrimTop(aa,0,count*1); bl:=KarTrimTop(bb,0,count*1);
  KarConv(aa,0,bb,0,pc,0,count*1 div 32,al,bl,work,0);
  for i:=0 to count-1 do
    begin
    r[i]:=p0[i] xor p1[i] xor pc[count+i] xor p0[count+i];
    r[count+i]:=p1[count+i] xor pc[i] xor p0[i] xor pc[count+i];
    end;
  exit;
  end;
e:=0; i:=count*1 div 32;
while (i mod 3)=0 do begin inc(e); i:=i div 3; end;
k:=1; for i:=1 to e div 2 do k:=k*3;
m:=count div k;
SetLength(aa,count*6); SetLength(bb,count*6);
for i:=0 to k*2-1 do
  begin
  Move(a[ao+i*m],aa[i*m*2],m*1);
  Move(b[bo+i*m],bb[i*m*2],m*1);
  end;
FFTTransform(aa,k*3,m,false); FFTTransform(bb,k*3,m,false);
for i:=0 to k*3-1 do
  begin
  base:=i*m*2;
  if i mod 3=0 then FillChar(aa[base],m*2*1,0)
  else
    begin
    FFTRing(aa,base,bb,base,pc,m);
    Move(pc[0],aa[base],m*2*1);
    end;
  end;
FFTTransform(aa,k*3,m,true);
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
procedure NTTLoad(const a:TDynBool; ao,len,count:longint; var b:TNTTArray);
var i:longint;
begin
SetLength(b,count);
FillChar(b[BWIndex(0)],count*SizeOf(TBW32),0);
for i:=0 to len-1 do if a[BWIndex(ao+i)] then b[BWIndex(i)]:=nttOne;
end;

procedure NTTStore(const a:TNTTArray; var r:TDynBool; ro,used,count:longint);
var i:longint; scale:TBW32;
begin
{ count divides p-1: 1/count = p-(p-1)/count modulo p. }
scale:=nttMod-(nttMod-1) div BW32(count);
for i:=0 to used-1 do r[BWIndex(ro+i)]:=r[BWIndex(ro+i)] xor ((NTTMul(a[BWIndex(i)],scale) and 1)<>0);
end;

procedure NTTProduct(const a:TDynBool; ao:longint;
                       const b:TDynBool; bo:longint; var r:TDynBool;
                       ro,alen,blen,lim:longint);
var aa,bb:TNTTArray; count,i,used:longint;
begin
if (alen<=0) or (blen<=0) or (lim<=0) then exit;
used:=alen+blen-1; count:=2;
while count<used do count:=count*2;
if lim<used then used:=lim;
NTTPrepare(count);
NTTLoad(a,ao,alen,count,aa); NTTLoad(b,bo,blen,count,bb);
NTTForward(aa,count); NTTForward(bb,count);
for i:=0 to count-1 do aa[BWIndex(i)]:=NTTMul(aa[BWIndex(i)],bb[BWIndex(i)]);
NTTInverse(aa,count); NTTStore(aa,r,ro,used,count);
end;

{ Share the transform of a between a*b and a*c. All inputs are read
  before either destination is updated, including aliased work arrays. }
procedure NTTProductPair(const a:TDynBool; ao:longint;
                       const b:TDynBool; bo:longint; const c:TDynBool; co:longint;
                       var r:TDynBool; ro:longint; var s:TDynBool; so:longint;
                       alen,blen,clen,lim:longint);
var aa,bb,cc:TNTTArray; count,i,top,used:longint;
begin
if (alen<=0) or ((blen<=0) and (clen<=0)) or (lim<=0) then exit;
top:=blen; if clen>top then top:=clen;
count:=2; while count<alen+top-1 do count:=count*2;
NTTPrepare(count);
NTTLoad(a,ao,alen,count,aa); NTTLoad(b,bo,blen,count,bb);
NTTLoad(c,co,clen,count,cc);
NTTForward(aa,count);
if blen>0 then
  begin
  NTTForward(bb,count);
  for i:=0 to count-1 do bb[BWIndex(i)]:=NTTMul(aa[BWIndex(i)],bb[BWIndex(i)]);
  NTTInverse(bb,count);
  used:=alen+blen-1; if used>lim then used:=lim;
  NTTStore(bb,r,ro,used,count);
  end;
if clen>0 then
  begin
  NTTForward(cc,count);
  for i:=0 to count-1 do cc[BWIndex(i)]:=NTTMul(aa[BWIndex(i)],cc[BWIndex(i)]);
  NTTInverse(cc,count);
  used:=alen+clen-1; if used>lim then used:=lim;
  NTTStore(cc,s,so,used,count);
  end;
end;

{ GF(2^32) uses X^32+X^7+X^3+X^2+1. H112 supplies the
  exact field product; no PCLMUL/SIMD or external unit. }
type TH111Array=array of TBW32;
var h111Points:TH111Array;
var h111Initialized:boolean;
const h111Beta:array[0..31] of TBW32=((true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false),(false,false,true,false,false,true,true,false,false,true,false,false,true,false,false,false,true,false,true,true,true,true,true,true,false,false,true,false,true,false,true,false),(false,true,false,false,false,false,true,true,true,true,true,true,true,false,false,true,false,false,true,false,false,false,true,false,false,true,true,false,true,true,true,false),(false,false,false,true,true,true,false,false,true,true,true,false,false,false,false,false,true,false,false,false,true,false,false,false,false,false,false,true,true,false,false,true),(false,true,false,false,true,false,true,false,true,true,true,true,true,false,true,false,false,true,false,true,true,true,true,false,false,true,false,false,true,true,false,false),(false,false,true,true,false,true,true,false,true,true,true,true,true,false,false,false,false,true,false,true,false,true,false,true,false,true,true,true,false,true,false,false),(false,false,true,false,false,false,true,true,false,true,false,true,false,true,false,false,false,false,true,false,true,true,true,false,false,false,true,true,true,false,true,false),(false,true,false,false,false,true,true,false,false,true,true,true,true,true,false,true,false,false,true,false,true,false,false,false,false,true,false,false,true,true,true,false),(false,false,true,false,true,true,false,false,false,false,false,true,false,false,false,true,false,true,false,false,false,true,false,false,false,true,false,true,true,true,true,false),(false,true,false,false,true,true,false,false,true,false,false,false,false,false,false,false,true,false,true,false,false,false,true,true,true,false,false,true,false,false,true,true),(false,true,false,true,true,false,true,false,true,true,true,true,false,false,true,false,true,true,true,false,false,false,false,true,false,true,false,false,true,true,true,true),(false,false,false,false,true,false,false,true,false,true,false,true,false,false,true,true,false,false,true,false,true,false,false,true,false,true,false,true,true,true,false,false),(false,true,false,true,false,true,false,false,true,false,false,false,false,true,false,false,false,true,true,false,false,true,true,false,true,true,false,true,false,true,false,false),(false,false,false,true,false,true,false,false,true,true,true,false,true,false,true,true,true,false,true,true,true,false,false,true,true,false,false,true,false,false,true,true),(false,false,false,true,false,true,true,false,false,true,false,true,false,true,true,true,false,false,false,false,true,true,true,true,false,false,false,false,true,false,false,false),(false,false,true,true,true,false,true,true,true,false,true,false,true,false,true,false,false,true,true,false,false,true,true,false,true,false,false,false,false,false,false,false),(false,true,false,true,false,false,true,false,true,false,false,false,false,false,true,true,true,false,false,false,false,false,true,true,true,false,false,false,false,false,true,true),(false,true,true,false,false,true,true,true,false,false,true,false,false,false,true,true,false,false,true,false,true,false,true,false,true,false,false,false,false,false,true,false),(false,true,false,false,true,true,true,false,false,true,true,true,false,false,false,true,false,false,true,true,false,true,false,true,true,false,false,false,false,false,false,false),(false,true,true,false,false,false,true,true,true,true,false,true,true,true,false,true,true,false,false,false,false,true,false,true,true,true,true,false,true,true,false,true),(false,true,true,true,false,false,false,true,true,true,false,false,true,false,false,false,false,true,false,true,true,false,false,true,true,false,true,true,false,false,true,false),(false,true,true,false,true,false,false,false,true,false,false,false,true,false,false,true,false,true,true,false,true,false,false,false,true,false,false,false,true,false,true,false),(false,false,true,false,false,true,false,true,true,false,false,false,true,true,false,true,false,false,true,false,true,true,true,false,true,true,true,false,true,true,true,false),(false,true,false,false,true,false,false,true,false,true,false,false,false,true,false,true,false,false,false,true,false,true,false,true,true,true,false,true,true,true,true,false),(false,true,false,true,false,false,true,true,false,true,false,true,false,false,true,true,false,true,false,true,true,false,true,true,true,false,true,true,true,false,true,false),(false,false,true,true,true,true,true,false,true,false,false,true,true,false,false,false,true,true,false,false,false,false,true,false,false,false,true,false,false,false,true,true),(false,false,true,false,true,true,true,false,true,false,false,false,true,false,true,false,true,false,true,false,false,false,false,true,false,true,true,false,true,true,true,true),(false,false,true,true,true,false,false,true,true,false,false,false,true,false,false,true,false,false,true,false,true,false,false,false,false,false,true,true,false,false,true,false),(false,true,false,false,true,true,true,true,true,false,false,false,true,false,true,false,true,false,true,false,true,false,false,false,false,false,false,false,true,false,false,true),(false,false,false,true,true,false,false,true,false,true,false,false,true,false,true,true,true,false,true,true,true,true,false,true,true,false,false,false,false,false,false,true),(false,true,true,true,false,true,false,false,false,false,false,true,false,true,false,false,false,false,true,true,false,false,true,false,true,true,false,false,false,true,true,false),(false,true,true,false,false,true,false,false,false,false,false,false,true,true,false,true,false,true,false,true,true,true,false,false,false,true,false,true,true,false,true,false));

{ Entries are ordinary carryless 8-bit products, not field logarithms.
  The recurrence is T[a,b]=(T[a div 2,b] shl 1) xor ((a and 1)*b).
  All 65536 entries take linear table-building time, once per process. }
type TH112Table=array[0..65535] of TBW16;
var h112Mul8:TH112Table;
var h112TableReady:boolean;

procedure H112PrepareTable;
var a,b,base,previous:longint; value:TBW32;
begin
if h112TableReady then exit;
for b:=0 to 255 do h112Mul8[BWIndex(b)]:=0;
for a:=1 to 255 do
  begin
  base:=a shl 8; previous:=(a shr 1) shl 8;
  for b:=0 to 255 do
    begin
    value:=BW32(h112Mul8[BWIndex(previous+b)]) shl 1;
    if (a and 1)<>0 then value:=value xor BW32(b);
    h112Mul8[BWIndex(base+b)]:=BW16(value);
    end;
  end;
h112TableReady:=true;
end;



function H114Mul16Parts(const a,b:TBW32; part:longint):TBW32;
var t:array[0..2]of TBW16;
var inner,k,p,base,index,i:longint; av,bv,value:boolean;
begin
base:=0; if part=1 then base:=16;
for inner:=0 to 2 do
  begin
  index:=0;
  for k:=0 to 7 do
    begin
    p:=base+k; if inner=1 then inc(p,8);
    av:=a[p]; bv:=b[p];
    if inner=2 then begin av:=av xor a[p+8]; bv:=bv xor b[p+8]; end;
    if part=2 then
      begin
      av:=av xor a[p+16]; bv:=bv xor b[p+16];
      if inner=2 then begin av:=av xor a[p+24]; bv:=bv xor b[p+24]; end;
      end;
    if av then index:=index or (1 shl (k+8));
    if bv then index:=index or (1 shl k);
    end;
  t[inner]:=h112Mul8[index];
  end;
for i:=0 to 31 do
  begin
  value:=false; if i<16 then value:=t[0,i];
  if (i>=8) and (i<24) then value:=value xor t[2,i-8] xor t[0,i-8] xor t[1,i-8];
  if i>=16 then value:=value xor t[1,i-16];
  H114Mul16Parts[i]:=value;
  end;
end;
function H111Mul(const a,b:TBW32):TBW32;
var lowProduct,highProduct,cross,lo,hi:TBW32;
var fold:array[0..6]of boolean;
var i:longint; zeroA,zeroB,oneA,oneB,value:boolean;
begin
zeroA:=true; zeroB:=true; oneA:=a[0]; oneB:=b[0];
for i:=0 to 31 do
  begin
  if a[i] then begin zeroA:=false; if i>0 then oneA:=false; end;
  if b[i] then begin zeroB:=false; if i>0 then oneB:=false; end;
  end;
if zeroA or zeroB then begin FillChar(H111Mul,SizeOf(H111Mul),0); exit; end;
if oneA then begin H111Mul:=b; exit; end;
if oneB then begin H111Mul:=a; exit; end;
if not h112TableReady then H112PrepareTable;
lowProduct:=H114Mul16Parts(a,b,0); highProduct:=H114Mul16Parts(a,b,1);
cross:=H114Mul16Parts(a,b,2);
for i:=0 to 31 do cross[i]:=cross[i] xor lowProduct[i] xor highProduct[i];
for i:=0 to 31 do
  begin
  lo[i]:=lowProduct[i]; if i>=16 then lo[i]:=lo[i] xor cross[i-16];
  hi[i]:=highProduct[i]; if i<16 then hi[i]:=hi[i] xor cross[i+16];
  end;
{ Exactly the same two sparse folds as B, expanded into Boolean bits. }
for i:=0 to 31 do
  begin
  value:=lo[i] xor hi[i];
  if i>=2 then value:=value xor hi[i-2];
  if i>=3 then value:=value xor hi[i-3];
  if i>=7 then value:=value xor hi[i-7];
  H111Mul[i]:=value;
  end;
for i:=0 to 6 do
  begin
  value:=hi[i+25];
  if i<2 then value:=value xor hi[i+30];
  if i<3 then value:=value xor hi[i+29];
  fold[i]:=value;
  end;
for i:=0 to 6 do if fold[i] then
  begin
  H111Mul[i]:=not H111Mul[i]; H111Mul[i+2]:=not H111Mul[i+2];
  H111Mul[i+3]:=not H111Mul[i+3]; H111Mul[i+7]:=not H111Mul[i+7];
  end;
end;

procedure H111Prepare(count:longint);
var first,j,level:longint;
begin
if not h111Initialized then
  begin
  if h111Beta[BWIndex(0)]<>1 then Halt(229);
  for j:=1 to High(h111Beta) do
    if H111Mul(h111Beta[BWIndex(j)],h111Beta[BWIndex(j)]) xor h111Beta[BWIndex(j)]<>h111Beta[BWIndex(j-1)] then Halt(229);
  h111Initialized:=true;
  end;
first:=Length(h111Points);
if first>=count then exit;
SetLength(h111Points,count);
if first=0 then begin h111Points[BWIndex(0)]:=0; first:=1; end;
level:=0; j:=first; while j>1 do begin j:=j shr 1; inc(level); end;
while first<count do
  begin
  for j:=0 to first-1 do h111Points[BWIndex(first+j)]:=h111Points[BWIndex(j)] xor h111Beta[BWIndex(level)];
  first:=first shl 1; inc(level);
  end;
end;

{ Convert in either direction between powers of X and the Cantor
  novel basis. Split the dimension at its largest lower power of two,
  where s_h(X)=X^(2^h)+X; this accepts EVERY transform dimension. }
{ H114: the same grouped linear Pascal network in A/B. }
{ H114: the same grouped linear Pascal network in A/B. }
procedure H113Pascal(var a:TH111Array; dim:longint);
var pass,groupDim,stage,half,base,j,k,count:longint;
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
      for j:=base to base+half-1 do for k:=0 to 31 do a[j,k]:=a[j,k] xor a[j+half,k];
      inc(base,half*2);
      end;
    end;
  inc(pass,groupDim);
  end;
end;

procedure H111Taylor(var a:TH111Array; base,stride,dim,h:longint; inverse:boolean);
var p:TH111Array; low,high,period,total,d,size,passDim,j,pos,last:longint;
var carry,value:TBW32; extra:boolean;
begin
if dim<=h then exit;
low:=1 shl h; high:=1 shl (dim-h); period:=low-1; total:=1 shl dim;
SetLength(p,high*2);
for d:=0 to period-1 do
  begin
  size:=(total-1-d) div period+1; passDim:=dim-h;
  if size>high then inc(passDim);
  FillChar(p[BWIndex(0)],(1 shl passDim)*SizeOf(p[BWIndex(0)]),0);
  extra:=(high=low) and (d=0);
  if inverse then
    begin
    pos:=base+d*stride;
    for j:=0 to size-1 do begin p[BWIndex(j)]:=a[BWIndex(pos)]; inc(pos,period*stride); end;
    H113Pascal(p,passDim);
    if extra then
      begin
      value:=p[BWIndex(high+1)];
      p[BWIndex(high-1)]:=p[BWIndex(high-1)] xor value;
      a[BWIndex(base+(total-1)*stride)]:=value;
      end;
    carry:=0;
    for j:=high-1 downto d do
      begin
      carry:=carry xor p[BWIndex(j+1)];
      a[BWIndex(base+(j*low+d-j+period)*stride)]:=carry;
      end;
    last:=d; if last>=high then last:=high-1;
    for j:=0 to last do
      begin
      value:=p[BWIndex(j)];
      if j=d then value:=value xor carry;
      a[BWIndex(base+(j*low+d-j)*stride)]:=value;
      end;
    end
  else
    begin
    last:=d; if last>=high then last:=high-1;
    for j:=0 to last do p[BWIndex(j)]:=a[BWIndex(base+(j*low+d-j)*stride)];
    for j:=d to high-1 do
      begin
      value:=a[BWIndex(base+(j*low+d-j+period)*stride)];
      p[BWIndex(j)]:=p[BWIndex(j)] xor value;
      p[BWIndex(j+1)]:=p[BWIndex(j+1)] xor value;
      end;
    if extra then
      begin
      value:=a[BWIndex(base+(total-1)*stride)];
      p[BWIndex(high-1)]:=p[BWIndex(high-1)] xor value;
      p[BWIndex(high+1)]:=p[BWIndex(high+1)] xor value;
      end;
    H113Pascal(p,passDim); pos:=base+d*stride;
    for j:=0 to size-1 do begin a[BWIndex(pos)]:=p[BWIndex(j)]; inc(pos,period*stride); end;
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
var pass,i,h,base,j,count:longint; c,lo,hi:TBW32;
begin
count:=Length(a);
for pass:=0 to dim-1 do
  begin
  if inverse then i:=pass else i:=dim-1-pass;
  h:=1 shl i; base:=0;
  while base<count do
    begin
    c:=h111Points[BWIndex(base shr i)];
    for j:=base to base+h-1 do
      begin
      lo:=a[BWIndex(j)]; hi:=a[BWIndex(j+h)];
      if inverse then begin hi:=hi xor lo; lo:=lo xor H111Mul(c,hi); end
      else begin lo:=lo xor H111Mul(c,hi); hi:=hi xor lo; end;
      a[BWIndex(j)]:=lo; a[BWIndex(j+h)]:=hi;
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


procedure H114LoadInput(const a:TDynBool; ao,len,count:longint; var b:TH111Array);
var j,k,take:longint;
begin
SetLength(b,count); FillChar(b[BWIndex(0)],count*SizeOf(b[BWIndex(0)]),0);
for j:=0 to (len+15) div 16-1 do
  begin
  take:=len-j*16; if take>16 then take:=16;
  for k:=0 to take-1 do b[BWIndex(j),BWIndex(k)]:=a[BWIndex(ao+j*16+k)];
  end;
end;
procedure H114StoreInput(const a:TH111Array; blocks,used:longint; var r:TDynBool; ro:longint);
var i,j,k:longint; value:boolean;
begin
for i:=0 to used-1 do
  begin
  j:=i shr 4; k:=i and 15; value:=false;
  if j<blocks then value:=a[BWIndex(j),BWIndex(k)];
  if j>0 then value:=value xor a[BWIndex(j-1),BWIndex(k+16)];
  r[BWIndex(ro+i)]:=r[BWIndex(ro+i)] xor value;
  end;
end;
procedure H111Product(const a:TDynBool; ao:longint;
                       const b:TDynBool; bo:longint; var r:TDynBool;
                       ro,alen,blen,lim:longint);
var aa,bb:TH111Array; ac,bc,count,dim,used,j:longint;
begin
if (alen<=0) or (blen<=0) or (lim<=0) then exit;
if alen>lim then alen:=lim; if blen>lim then blen:=lim;
ac:=(alen+15) shr 4; bc:=(blen+15) shr 4;
count:=2; dim:=1; while count<ac+bc-1 do begin count:=count*2; inc(dim); end;
H114LoadInput(a,ao,alen,count,aa); H114LoadInput(b,bo,blen,count,bb);
H111Prepare(count); H114Forward(aa,dim); H114Forward(bb,dim);
for j:=0 to count-1 do aa[BWIndex(j)]:=H111Mul(aa[BWIndex(j)],bb[BWIndex(j)]);
H114Inverse(aa,dim); used:=alen+blen-1; if used>lim then used:=lim;
H114StoreInput(aa,ac+bc-1,used,r,ro);
end;
{ H114: snapshot all inputs and transform the common operand once. }
procedure H111ProductPair(const a:TDynBool; ao:longint;
                       const b:TDynBool; bo:longint; const c:TDynBool; co:longint;
                       var r:TDynBool; ro:longint; var s:TDynBool; so:longint;
                       alen,blen,clen,lim:longint);
var aa,bb,cc:TH111Array; ac,bc,dc,count,dim,j,used,top:longint;
begin
if (alen<=0) or ((blen<=0) and (clen<=0)) or (lim<=0) then exit;
if alen>lim then alen:=lim; if blen>lim then blen:=lim; if clen>lim then clen:=lim;
if blen<0 then blen:=0; if clen<0 then clen:=0;
ac:=(alen+15) shr 4; bc:=(blen+15) shr 4; dc:=(clen+15) shr 4;
top:=bc; if dc>top then top:=dc;
count:=2; dim:=1; while count<ac+top-1 do begin count:=count*2; inc(dim); end;
H114LoadInput(a,ao,alen,count,aa); H114LoadInput(b,bo,blen,count,bb);
H114LoadInput(c,co,clen,count,cc);
H111Prepare(count); H114Forward(aa,dim);
if blen>0 then
  begin
  H114Forward(bb,dim);
  for j:=0 to count-1 do bb[BWIndex(j)]:=H111Mul(aa[BWIndex(j)],bb[BWIndex(j)]);
  H114Inverse(bb,dim); used:=alen+blen-1; if used>lim then used:=lim;
  H114StoreInput(bb,ac+bc-1,used,r,ro);
  end;
if clen>0 then
  begin
  H114Forward(cc,dim);
  for j:=0 to count-1 do cc[BWIndex(j)]:=H111Mul(aa[BWIndex(j)],cc[BWIndex(j)]);
  H114Inverse(cc,dim); used:=alen+clen-1; if used>lim then used:=lim;
  H114StoreInput(cc,ac+dc-1,used,s,so);
  end;
end;


{ H119. Exact binary multiplication on a 3 by 5 CRT grid in GF(16).
  Jet products split the two low binary digits into two ternary axes.
  Nine independent 3 by 3 transforms use a count predictor and one
  exceptional row per frequency. Growing jet tails use the exact ring FFT. }
type TH119Bits=TDynBool;
type TH119Cell=array[0..3] of boolean;
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
begin H119Bit:=a[i]; end;

procedure H119Flip(var a:TH119Bits; i:longint); inline;
begin a[i]:=not a[i]; end;

procedure H119Space(var a:TH119Bits; count:longint); inline;
begin
SetLength(a,count);
if Length(a)>0 then FillChar(a[0],Length(a)*SizeOf(a[0]),0);
end;

function H119Field(i:longint):TH119Cell;
begin H119Field[0]:=odd(i); H119Field[1]:=(i and 2)<>0; H119Field[2]:=(i and 4)<>0; H119Field[3]:=(i and 8)<>0; end;

function H119Index(const a:TH119Cell):longint;
begin H119Index:=ord(a[0])+2*ord(a[1])+4*ord(a[2])+8*ord(a[3]); end;

function H119Add(const a,b:TH119Cell):TH119Cell;
begin H119Add[0]:=a[0] xor b[0]; H119Add[1]:=a[1] xor b[1]; H119Add[2]:=a[2] xor b[2]; H119Add[3]:=a[3] xor b[3]; end;

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
type TH119BooleanBlock=record key:longint; bits:TH119Bits; end;
type TH119Block=^TH119BooleanBlock;
type TH119BlockVec=array of TH119Block;
type TH119BlockPlan=record
  width,count:longint;
  dictionary:array of TH119BooleanBlock;
  sums,products:TH119BlockVec;
end;
var h119BlockPlans:array of TH119BlockPlan;

function H119BlockKey(const a:TH119Block):longint;
begin if a=nil then H119BlockKey:=0 else H119BlockKey:=a^.key; end;

function H119BlockLookup(const plan:TH119BlockPlan; i:longint):TH119Block;
begin if i=0 then H119BlockLookup:=nil else H119BlockLookup:=@plan.dictionary[i]; end;

function H119BlockBit(const a:TH119Block; i:longint):boolean;
begin if a=nil then H119BlockBit:=false else H119BlockBit:=a^.bits[i]; end;

procedure H119BuildBlockPlan(var plan:TH119BlockPlan; width:longint);
var count,len,i,j,k,h,sum,prod:longint; left,right:TH119Block; value:boolean;
begin
if plan.width=width then exit;
len:=2*width; count:=1 shl len; plan.width:=width; plan.count:=count;
SetLength(plan.dictionary,count);
for i:=1 to count-1 do
  begin
  plan.dictionary[i].key:=i; H119Space(plan.dictionary[i].bits,len);
  for j:=0 to len-1 do if (i and (1 shl j))<>0 then H119Flip(plan.dictionary[i].bits,j);
  end;
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
var bit,value:longint;
begin
bit:=1; value:=0;
while (a<>0) or (b<>0) do
  begin
  if odd(a) xor odd(b) then inc(value,bit);
  a:=a shr 1; b:=b shr 1; bit:=2*bit;
  end;
H120CodeSum:=value;
end;

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
  if (a[pos+i,j]) then H119Flip(pa,i*7+j);
  if (b[pos+i,j]) then H119Flip(pb,i*7+j);
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
type TH119FEntry=record key:longint; bits:array[0..15] of boolean; end;
type TH119F=^TH119FEntry;
type TH119FVec=array of TH119F;
type TH119IntTable=array of longint;
var h119FExp,h119FPoints:TH119FVec;
var h119FLog,h119FZech:TH119IntTable;
var h119FRoots:array[0..4] of TH119F;
var h119FScale1,h119FScale2:TH119FVec;
var h119FDictionary:array of TH119FEntry;

function H119FKey(const v:TH119F):longint;
begin if v=nil then H119FKey:=0 else H119FKey:=v^.key; end;

function H119FValue(index:longint):TH119F;
begin if index=0 then H119FValue:=nil else H119FValue:=@h119FDictionary[index]; end;

function H119FBit(const v:TH119F; bit:longint):boolean;
begin if v=nil then H119FBit:=false else H119FBit:=v^.bits[bit]; end;

function H119FAdd(const a,b:TH119F):TH119F;
var i,j,d:longint;
begin
i:=H119FKey(a); j:=H119FKey(b);
if i=0 then begin H119FAdd:=b; exit; end;
if j=0 then begin H119FAdd:=a; exit; end;
if i=j then begin H119FAdd:=H119FValue(0); exit; end;
i:=h119FLog[i]; d:=h119FLog[j]-i; if d<0 then inc(d,65535);
H119FAdd:=h119FExp[i+h119FZech[d]];
end;

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
SetLength(h119FDictionary,65536);
for i:=1 to 65535 do
  begin
  h119FDictionary[i].key:=i;
  for j:=0 to 15 do h119FDictionary[i].bits[j]:=(i and (1 shl j))<>0;
  end;
SetLength(h119FLog,65536); SetLength(h119FExp,131070); SetLength(roots,65536);
SetLength(h119FZech,65535);
x:=1;
for i:=0 to 65534 do
  begin
  h119FExp[i]:=H119FValue(x); h119FExp[i+65535]:=h119FExp[i]; h119FLog[x]:=i;
  x:=x shl 1; if (x and 65536)<>0 then x:=x xor 69643;
  if (x=1) and (i<>65534) then Halt(232);
  end;
for i:=1 to 65534 do h119FZech[i]:=h119FLog[1 xor H119FKey(h119FExp[i])];
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
var carry,value:TH119F; extra:boolean;
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
      a[BWIndex(base+(total-1)*stride)]:=value;
      end;
    carry:=H119FValue(0);
    for j:=high-1 downto d do
      begin
      carry:=H119FAdd(carry,p[j+1]);
      a[BWIndex(base+(j*low+d-j+period)*stride)]:=carry;
      end;
    last:=d; if last>=high then last:=high-1;
    for j:=0 to last do
      begin
      value:=p[j];
      if j=d then value:=H119FAdd(value,carry);
      a[BWIndex(base+(j*low+d-j)*stride)]:=value;
      end;
    end
  else
    begin
    last:=d; if last>=high then last:=high-1;
    for j:=0 to last do p[j]:=a[BWIndex(base+(j*low+d-j)*stride)];
    for j:=d to high-1 do
      begin
      value:=a[BWIndex(base+(j*low+d-j+period)*stride)];
      p[j]:=H119FAdd(p[j],value);
      p[j+1]:=H119FAdd(p[j+1],value);
      end;
    if extra then
      begin
      value:=a[BWIndex(base+(total-1)*stride)];
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

procedure H119FTransform(var a:TH119FVec; dim:longint; inverse:boolean);
var pass,level,h,base,i:longint; lo,hi,alpha:TH119F;
begin
if not inverse then H121JetConvert(a,0,1,dim,true);
for pass:=0 to dim-1 do
  begin
  if inverse then level:=pass else level:=dim-1-pass;
  h:=1 shl level; base:=0;
  while base<Length(a) do
    begin
    alpha:=h119FPoints[base shr level];
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

type TH121JetPlan=record axes,width,blocks,count,dim:longint; end;

procedure H121JetPlan(span:longint; out plan:TH121JetPlan);
var chunks,half:longint;
begin
chunks:=(span+7) div 8;
with plan do
  begin
  if chunks<=65536 then axes:=3 else axes:=15;
  half:=(axes+1) div 2; width:=(chunks+half-1) div half;
  blocks:=(width+1) div 2; count:=1; dim:=0;
  while count<2*blocks-1 do begin count:=count*2; inc(dim); end;
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
  H119FTransform(fa[i],plan.dim,false); H119FTransform(fb[i],plan.dim,false);
  for j:=0 to plan.count-1 do fa[i,j]:=H119FMul(fa[i,j],fb[i,j]);
  fb[i]:=nil; H119FTransform(fa[i],plan.dim,true);
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
    for bit:=0 to 3 do if (pos+bit<used) and (ga[k+j,bit]) then H119Flip(dst,off+pos+bit);
    end;
  end;
end;

procedure H114ToomProduct(const a:TDynBool; ao:longint; const b:TDynBool; bo:longint;
                          var r:TDynBool; ro,alen,blen,lim:longint); forward;
procedure FFTProduct(const a:TDynBool; ao:longint;
                       const b:TDynBool; bo:longint; var r:TDynBool;
                       ro,alen,blen,lim:longint);
var aa,bb,cc:TDynBool;
var count,i,used:longint;
begin
if h102Backend=7 then begin H119Product(a,ao,b,bo,r,ro,alen,blen,lim); exit; end;
if h102Backend=6 then begin H114ToomProduct(a,ao,b,bo,r,ro,alen,blen,lim); exit; end;
if (alen<=0) or (blen<=0) or (lim<=0) then exit;
{ Forced NTT modes reject unsupported lengths instead of mixing backends. }
if (h102Force in [3,4,5]) and (Int64(alen)+blen-1>nttMaxLen) then Halt(219);
{ H111: all general large products use the packed additive backend. }
if (h102Backend=5) and (Int64(alen)+blen-1<=nttMaxLen) then
  begin H111Product(a,ao,b,bo,r,ro,alen,blen,lim); exit; end;
{ Automatic mode retains the original exact FFT fallback. }
if (h102Backend in [3,4,5]) and (Int64(alen)+blen-1<=nttMaxLen) then
  begin NTTProduct(a,ao,b,bo,r,ro,alen,blen,lim); exit; end;
used:=alen+blen-1; if lim<used then used:=lim;
count:=32; while count*2<alen+blen-1 do count:=count*3;
if (count>=96) and ((count div 3)*4>=alen+blen-1) then count:=(count div 3)*2;
count:=count div 1;
SetLength(aa,count*2); SetLength(bb,count*2);
Move(a[ao],aa[0],alen); Move(b[bo],bb[0],blen);
FFTRing(aa,0,bb,0,cc,count);
for i:=0 to used-1 do r[ro+i]:=r[ro+i] xor cc[i];
end;

{ H93: five evaluations at 0,1,t,t+1,infinity in GF(2)[t].
  Exact divisions by t and t+1 replace field interpolation. }
procedure Toom3(const a:TDynBool; ao:longint; const b:TDynBool; bo:longint;
                 var r:TDynBool; ro,alen,blen:longint);
var aa,bb,e1,et,eu,f1,ft,fu,p0,p1,pt,pu,p4,w:TDynBool;
var k,l,i,top,lim,a0,a2,b0,b2:longint;
var c2,c3,prev2,prev3,old3,st,st1,s1:boolean;
begin
top:=alen; if blen>top then top:=blen;
k:=((top+95) div 96)*32; l:=k+32;
SetLength(aa,k*3); SetLength(bb,k*3);
for i:=0 to alen-1 do aa[i]:=a[ao+i];
for i:=0 to blen-1 do bb[i]:=b[bo+i];
SetLength(e1,l);SetLength(et,l);SetLength(eu,l);
SetLength(f1,l);SetLength(ft,l);SetLength(fu,l);
for i:=0 to k-1 do
  begin
  e1[i]:=aa[i] xor aa[k+i] xor aa[k*2+i];
  f1[i]:=bb[i] xor bb[k+i] xor bb[k*2+i];
  et[i]:=et[i] xor aa[i]; et[i+1]:=et[i+1] xor aa[k+i]; et[i+2]:=et[i+2] xor aa[k*2+i];
  ft[i]:=ft[i] xor bb[i]; ft[i+1]:=ft[i+1] xor bb[k+i]; ft[i+2]:=ft[i+2] xor bb[k*2+i];
  end;
for i:=0 to k-1 do
  begin
  eu[i]:=et[i] xor aa[k+i] xor aa[k*2+i];
  fu[i]:=ft[i] xor bb[k+i] xor bb[k*2+i];
  end;
eu[k]:=et[k]; eu[k+1]:=et[k+1]; fu[k]:=ft[k]; fu[k+1]:=ft[k+1];
SetLength(p0,l*2);SetLength(p1,l*2);SetLength(pt,l*2);SetLength(pu,l*2);SetLength(p4,l*2);
SetLength(w,l*5);
a0:=alen;if a0>k then a0:=k; b0:=blen;if b0>k then b0:=k;
a2:=alen-2*k;b2:=blen-2*k;
KarConv(aa,0,bb,0,p0,0,k shr 5,a0,b0,w,0);
KarConv(aa,k*2,bb,k*2,p4,0,k shr 5,a2,b2,w,0);
KarConv(e1,0,f1,0,p1,0,k shr 5,k,k,w,0);
KarConv(et,0,ft,0,pt,0,l shr 5,k+2,k+2,w,0);
KarConv(eu,0,fu,0,pu,0,l shr 5,k+2,k+2,w,0);
for i:=l*2-1 downto 0 do
  begin
  s1:=p1[i] xor p0[i] xor p4[i];
  st:=pt[i] xor p0[i];st1:=pu[i] xor p0[i] xor p4[i];
  if i>=4 then begin st:=st xor p4[i-4];st1:=st1 xor p4[i-4];end;
  p1[i]:=s1;pt[i]:=st;pu[i]:=st xor st1 xor s1;
  end;
{ s1=c1+c2+c3; st=t*c1+t^2*c2+t^3*c3.
  c3=(st+st1+s1)/(t*(t+1));
  c2=(st/t+s1)/(t+1)+(t+1)*c3; c1=s1+c2+c3. }
prev2:=false;prev3:=false;lim:=alen+blen-1;
for i:=0 to k*2-1 do
  begin
  old3:=prev3;c3:=pu[i+1] xor prev3;prev3:=c3;
  prev2:=pt[i+1] xor p1[i] xor prev2;c2:=prev2 xor c3 xor old3;
  if i<lim then r[ro+i]:=r[ro+i] xor p0[i];
  if k+i<lim then r[ro+k+i]:=r[ro+k+i] xor p1[i] xor c2 xor c3;
  if 2*k+i<lim then r[ro+2*k+i]:=r[ro+2*k+i] xor c2;
  if 3*k+i<lim then r[ro+3*k+i]:=r[ro+3*k+i] xor c3;
  if 4*k+i<lim then r[ro+4*k+i]:=r[ro+4*k+i] xor p4[i];
  end;
end;
procedure H114ToomProduct(const a:TDynBool; ao:longint; const b:TDynBool; bo:longint;
                          var r:TDynBool; ro,alen,blen,lim:longint);
var temp:TDynBool; used,i:longint;
begin
if (alen<=0) or (blen<=0) or (lim<=0) then exit;
if alen>lim then alen:=lim; if blen>lim then blen:=lim;
SetLength(temp,((alen+blen+31) shr 5)*32);
Toom3(a,ao,b,bo,temp,0,alen,blen);
used:=alen+blen-1; if used>lim then used:=lim;
for i:=0 to used-1 do r[ro+i]:=r[ro+i] xor temp[i];
end;
procedure H114ToomPair(const a:TDynBool; ao:longint; const b:TDynBool; bo:longint;
                       const c:TDynBool; co:longint; var r:TDynBool; ro:longint;
                       var s:TDynBool; so,alen,blen,clen,lim:longint);
var aa,bb,cc:TDynBool;
begin
if (alen<=0) or ((blen<=0) and (clen<=0)) or (lim<=0) then exit;
if alen>lim then alen:=lim; if blen>lim then blen:=lim; if clen>lim then clen:=lim;
aa:=Copy(a,ao,alen);
if blen>0 then bb:=Copy(b,bo,blen);
if clen>0 then cc:=Copy(c,co,clen);
H114ToomProduct(aa,0,bb,0,r,ro,alen,blen,lim);
H114ToomProduct(aa,0,cc,0,s,so,alen,clen,lim);
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

procedure T4Add(const a:TDynBool; ao,count:longint; var dst:TDynBool; mask:TBW32);
var shift,i:longint;
begin
shift:=0;
while mask<>0 do
  begin
  if (mask and 1)<>0 then
    begin
    for i:=0 to count-1 do dst[BWIndex(i+shift)]:=dst[BWIndex(i+shift)] xor a[BWIndex(ao+i)];
    end;
  inc(shift); mask:=mask shr 1;
  end;
end;

procedure T4DivBin(var a:TDynBool; step:longint);
var i:longint;
begin
for i:=step to High(a) do a[BWIndex(i)]:=a[BWIndex(i)] xor a[BWIndex(i-step)];
end;

procedure Toom4(const a:TDynBool; ao:longint; const b:TDynBool; bo:longint;
                  var r:TDynBool; ro,alen,blen:longint);
const nums:array[0..4,0..4] of TBW32=(
  ((false,false,true,true,false,true,true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false),(false,false,true,true,true,true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false),(false,false,false,true,false,true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false),(true,false,true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false),(false,false,true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false)),
  ((false,true,true,true,true,true,true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false),(false,true,false,true,true,true,true,true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false),(false,false,true,false,false,false,false,true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false),(true,false,true,true,true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false),(false,true,false,true,true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false)),
  ((true,true,false,false,true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false),(false,true,false,false,true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false),(false,true,false,false,true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false),(true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false),(true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false)),
  ((false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false),(false,true,false,true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false),(false,false,true,true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false),(true,false,true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false),(false,false,true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false)),
  ((true,true,true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false),(false,true,true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false),(false,true,true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false),(true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false),(true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false)));
const shift0:array[0..4] of longint=(2,3,3,3,3);
const ones:array[0..4] of longint=(1,2,3,2,2);
const thirds:array[0..4] of longint=(1,1,0,1,1);
const powers:array[0..4,0..3] of TBW32=(
  ((true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false),(true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false),(true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false),(true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false)),
  ((true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false),(false,true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false),(false,false,true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false),(false,false,false,true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false)),
  ((true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false),(true,true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false),(true,false,true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false),(true,true,true,true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false)),
  ((true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false),(false,false,true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false),(false,false,false,false,true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false),(false,false,false,false,false,false,true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false)),
  ((true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false),(true,false,true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false),(true,false,false,false,true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false),(true,false,true,false,true,false,true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false)));
const highPowers:array[0..4] of TBW32=((true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false),(false,false,false,false,false,false,true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false),(true,false,true,false,true,false,true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false),(false,false,false,false,false,false,false,false,false,false,false,false,true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false),(true,false,false,false,true,false,false,false,true,false,false,false,true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false));
var aa,bb,ea,eb,p0,p6,tmp,work:TDynBool;
var products:array[0..4] of TDynBool;
var k,l,top,i,j,h,al,bl,count,lim,step,exponent:longint;
begin
top:=alen; if blen>top then top:=blen;
k:=((top+127) div 128)*32; l:=k+32;
SetLength(aa,k*4); SetLength(bb,k*4);
Move(a[BWIndex(ao)],aa[BWIndex(0)],alen); Move(b[BWIndex(bo)],bb[BWIndex(0)],blen);
SetLength(ea,l); SetLength(eb,l); SetLength(p0,l*2); SetLength(p6,l*2);
SetLength(work,l*5); count:=l*2; SetLength(tmp,count+32);
al:=alen; if al>k*1 then al:=k*1; bl:=blen; if bl>k*1 then bl:=k*1;
KarConv(aa,0,bb,0,p0,0,k*1 div 32,al,bl,work,0);
al:=alen-k*3; bl:=blen-k*3;
KarConv(aa,k*3,bb,k*3,p6,0,k*1 div 32,al,bl,work,0);
for j:=0 to 4 do
  begin
  FillChar(ea[BWIndex(0)],l*1,0); FillChar(eb[BWIndex(0)],l*1,0);
  for h:=0 to 3 do
    begin
    T4Add(aa,h*k,k,ea,powers[BWIndex(j),BWIndex(h)]); T4Add(bb,h*k,k,eb,powers[BWIndex(j),BWIndex(h)]);
    end;
  SetLength(products[BWIndex(j)],count+32);
  al:=KarTrimTop(ea,0,k*1+6); bl:=KarTrimTop(eb,0,k*1+6);
  KarConv(ea,0,eb,0,products[BWIndex(j)],0,l*1 div 32,al,bl,work,0);
  T4Add(p0,0,count,products[BWIndex(j)],1); T4Add(p6,0,count,products[BWIndex(j)],highPowers[BWIndex(j)]);
  end;
lim:=(alen+blen-2) div 1+1;
for i:=0 to k*2-1 do
  begin
  if i<lim then r[BWIndex(ro+i)]:=r[BWIndex(ro+i)] xor p0[BWIndex(i)];
  if 6*k+i<lim then r[BWIndex(ro+6*k+i)]:=r[BWIndex(ro+6*k+i)] xor p6[BWIndex(i)];
  end;
for h:=0 to 4 do
  begin
  FillChar(tmp[BWIndex(0)],Length(tmp)*1,0);
  for j:=0 to 4 do T4Add(products[BWIndex(j)],0,count,tmp,nums[BWIndex(h),BWIndex(j)]);
  for i:=0 to High(tmp)-shift0[BWIndex(h)] do tmp[BWIndex(i)]:=tmp[BWIndex(i+shift0[BWIndex(h)])];
  for i:=High(tmp)-shift0[BWIndex(h)]+1 to High(tmp) do tmp[BWIndex(i)]:=false;
  exponent:=ones[BWIndex(h)]; step:=1;
  while exponent<>0 do
    begin
    if (exponent and 1)<>0 then T4DivBin(tmp,step);
    step:=step shl 1; exponent:=exponent shr 1;
    end;
  if thirds[BWIndex(h)]<>0 then T4DivBin(tmp,3);
  for i:=0 to k*2-1 do
    if (h+1)*k+i<lim then r[BWIndex(ro+(h+1)*k+i)]:=r[BWIndex(ro+(h+1)*k+i)] xor tmp[BWIndex(i)];
  end;
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
if (alen>128) and (blen>128) and (alen<=160) and (blen<=160) then
  begin KarLeaf160(a,ao,b,bo,r,ro,alen,blen); exit; end;
if (alen>128) and (blen>128) and (alen<=192) and (blen<=192) then
  begin KarLeaf192(a,ao,b,bo,r,ro,alen,blen); exit; end;
if (h102Backend<>0) and H102Transform(alen,blen,fftCut) then
  begin FFTProduct(a,ao,b,bo,r,ro,alen,blen,alen+blen-1); exit; end;
if (h102Backend<>1) and ((h102Backend=0) or (h102Force=0)) and ((alen>toomCut) or (blen>toomCut)) then
  begin
  if H102Transform(alen,blen,fftCut) then FFTProduct(a,ao,b,bo,r,ro,alen,blen,alen+blen-1)
  else if (alen>toom4Cut) and (blen>toom4Cut) and (alen<=toom4Max) and (blen<=toom4Max) then Toom4(a,ao,b,bo,r,ro,alen,blen)
  else Toom3(a,ao,b,bo,r,ro,alen,blen);
  exit;
  end;
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
alen:=KarTrimTop(a,ao,alen); blen:=KarTrimTop(b,bo,blen);
if (alen<=0) or (blen<=0) then exit;
if lenWords>cut then
  begin
  lenBits:=alen; if blen>lenBits then lenBits:=blen;
  lenWords:=(lenBits+31) shr 5;
  end;
if (h102Backend<>0) and H102Transform(alen,blen,fftCut) then
  begin FFTProduct(a,ao,b,bo,r,ro,alen,blen,alen+blen-1); exit; end;
if (h102Backend<>1) and ((h102Backend=0) or (h102Force=0)) and ((alen>toomCut) or (blen>toomCut)) then
  begin
  if H102Transform(alen,blen,fftCut) then FFTProduct(a,ao,b,bo,r,ro,alen,blen,alen+blen-1)
  else if (alen>toom4Cut) and (blen>toom4Cut) and (alen<=toom4Max) and (blen<=toom4Max) then Toom4(a,ao,b,bo,r,ro,alen,blen)
  else Toom3(a,ao,b,bo,r,ro,alen,blen);
  exit;
  end;
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
if H102Transform(alen,blen,fftCut) then
  begin
  FFTProduct(a,ao,b,bo,r,ro,alen,blen,lim);
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
alen:=KarTrimTop(a,ao,alen); blen:=KarTrimTop(b,bo,blen);
clen:=KarTrimTop(c,co,clen);
if (alen<=0) or ((blen<=0) and (clen<=0)) then exit;
if lenWords>cut then
  begin
  lenBits:=alen; if blen>lenBits then lenBits:=blen;
  if clen>lenBits then lenBits:=clen;
  lenWords:=(lenBits+31) shr 5;
  end;
if (h102Backend=6) and H102Transform(alen,H102Max(blen,clen),fftCut) then
  begin H114ToomPair(a,ao,b,bo,c,co,r,ro,s,so,alen,blen,clen,lenWords*64); exit; end;
if (h102Backend=5) and H102Transform(alen,H102Max(blen,clen),fftCut) and
   (Int64(alen)+blen-1<=nttMaxLen) and (Int64(alen)+clen-1<=nttMaxLen) then
  begin
  H111ProductPair(a,ao,b,bo,c,co,r,ro,s,so,alen,blen,clen,lenWords*64);
  exit;
  end;
if (h102Backend in [3,4,5]) and (h102Backend<>5) and H102Transform(alen,H102Max(blen,clen),fftCut) and
   (Int64(alen)+blen-1<=nttMaxLen) and (Int64(alen)+clen-1<=nttMaxLen) then
  begin
  NTTProductPair(a,ao,b,bo,c,co,r,ro,s,so,alen,blen,clen,lenWords*64);
  exit;
  end;
if (h102Backend<>0) and H102Transform(alen,H102Max(blen,clen),fftCut) then
  begin
  FFTProduct(a,ao,b,bo,r,ro,alen,blen,alen+blen-1);
  FFTProduct(a,ao,c,co,s,so,alen,clen,alen+clen-1);
  exit;
  end;
if (h102Backend<>1) and ((h102Backend=0) or (h102Force=0)) and ((alen>toomCut) or (blen>toomCut) or (clen>toomCut)) then
  begin
  KarRec(a,ao,b,bo,r,ro,lenWords,alen,blen,work,wo);
  KarRec(a,ao,c,co,s,so,lenWords,alen,clen,work,wo);
  exit;
  end;
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


{ H83: A(t)=P(t^2), t*P(t^2), or c+(1+t)*P(t^2). }
{ H83 revision: recursively reuse one workspace for parity compression. }




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

{ H86: fixed recursion leaf of degree <= 4096, identical in A/B. }
const hgcdCut=4096;
      divCut=64;

var qPool,qA,qB,qC,qR,qS,qWork:TDynBool;
var qTop:longint;

procedure HPAlloc(out a:THPoly; count:longint); inline;
begin
a.d:=-1; a.cap:=count;
if count<=0 then begin a.v:=nil; exit; end;
if qTop+count>Length(qPool) then Halt(217);
a.v:=PHBuffer(@qPool[qTop]);
FillChar(a.v^[0],count*SizeOf(boolean),0);
inc(qTop,count);
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
if (h102Backend=6) and H102Transform(alen,H102Max(blen,clen),fftCut) then
  begin H114ToomPair(a,ao,b,bo,c,co,r,ro,s,so,alen,blen,clen,lim); exit; end;
if H102Transform(alen,H102Max(blen,clen),fftCut) then
  begin
  if (h102Backend=5) and (Int64(alen)+blen-1<=nttMaxLen) and (Int64(alen)+clen-1<=nttMaxLen) then
    begin
    H111ProductPair(a,ao,b,bo,c,co,r,ro,s,so,alen,blen,clen,lim);
    exit;
    end;
  if (h102Backend in [3,4,5]) and (h102Backend<>5) and (Int64(alen)+blen-1<=nttMaxLen) and (Int64(alen)+clen-1<=nttMaxLen) then
    begin
    NTTProductPair(a,ao,b,bo,c,co,r,ro,s,so,alen,blen,clen,lim);
    exit;
    end;
  FFTProduct(a,ao,b,bo,r,ro,alen,blen,lim);
  FFTProduct(a,ao,c,co,s,so,alen,clen,lim);
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

{ H102: transform each matrix entry once. Each output is the sum of
  two INTEGER convolutions, bounded by 2*L<p; reduce to GF(2) at output.
  Never perform Euclid or matrix inversion in the odd-characteristic field. }
type TH102Polys=array[0..7] of THPoly;
     TH102Freqs=array[0..7] of TNTTArray;

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
  if lengths[BWIndex(i)]>nttMaxLen then exit;
  blocks[BWIndex(i)]:=(lengths[BWIndex(i)]+blockBits-1) div blockBits;
  if blocks[BWIndex(i)]>need then need:=blocks[BWIndex(i)];
  if lengths[BWIndex(i)]>0 then inc(forwards);
  end;
if entries=8 then begin terms:=8; outputs:=4; end
else begin terms:=4; outputs:=2; end;
inverses:=0; active:=false;
for i:=0 to terms-1 do
  begin
  if entries=8 then begin a:=left8[BWIndex(i)]; b:=right8[BWIndex(i)]; end
  else begin a:=left6[BWIndex(i)]; b:=right6[BWIndex(i)]; end;
  if (lengths[BWIndex(a)]>0) and (lengths[BWIndex(b)]>0) then
    begin
    active:=true;
    if lengths[BWIndex(a)]+lengths[BWIndex(b)]-1>largest then largest:=lengths[BWIndex(a)]+lengths[BWIndex(b)]-1;
    if blocks[BWIndex(a)]+blocks[BWIndex(b)]-1>need then need:=blocks[BWIndex(a)]+blocks[BWIndex(b)]-1;
    end;
  if (i and 1)=1 then begin if active then inc(inverses); active:=false; end;
  end;
if (largest<=0) or (largest>nttMaxLen) then exit;
count:=2; dim:=1; while count<need do begin count:=count*2; inc(dim); end;
if entries=8 then
  oldScore:=H114PairScore(lengths[BWIndex(0)],lengths[BWIndex(4)],lengths[BWIndex(5)],blockBits,transformCut)+
            H114PairScore(lengths[BWIndex(1)],lengths[BWIndex(6)],lengths[BWIndex(7)],blockBits,transformCut)+
            H114PairScore(lengths[BWIndex(2)],lengths[BWIndex(4)],lengths[BWIndex(5)],blockBits,transformCut)+
            H114PairScore(lengths[BWIndex(3)],lengths[BWIndex(6)],lengths[BWIndex(7)],blockBits,transformCut)
else
  oldScore:=H114PairScore(lengths[BWIndex(4)],lengths[BWIndex(0)],lengths[BWIndex(2)],blockBits,transformCut)+
            H114PairScore(lengths[BWIndex(5)],lengths[BWIndex(1)],lengths[BWIndex(3)],blockBits,transformCut);
if blockBits=1 then begin forwards:=entries; inverses:=outputs; end;
newScore:=Int64(forwards+inverses)*count*(dim+1)+Int64(outputs)*2*count;
H114BatchPlan:=oldScore>newScore;
end;
function H102ProductLen(const a,b:THPoly):longint; inline;
begin
if (a.d<0) or (b.d<0) then H102ProductLen:=0
else H102ProductLen:=a.d+b.d+1;
end;

procedure H102LoadPoly(const a:THPoly; limit,count:longint; var z:TNTTArray);
var i,used:longint;
begin
SetLength(z,count); FillChar(z[BWIndex(0)],count*SizeOf(TBW32),0);
used:=a.d+1; if used>limit then used:=limit;
for i:=0 to used-1 do if a.v^[BWIndex(i)] then z[BWIndex(i)]:=nttOne;
end;

procedure H102StorePoly(const z:TNTTArray; count,used:longint; out a:THPoly);
var i:longint; scale:TBW32;
begin
if used<=0 then begin HPZero(a); exit; end;
HPAlloc(a,used);
scale:=nttMod-(nttMod-1) div BW32(count);
for i:=0 to used-1 do a.v^[BWIndex(i)]:=(NTTMul(z[BWIndex(i)],scale) and 1)<>0;
HPNorm(a);
end;

function H102MatrixReady(const a:TH102Polys; entries,limit:longint; out count:longint):boolean;
var i,top,used,cutoff,transformCut,dim:longint; lengths:TH114Sizes;
begin
H102MatrixReady:=false;
if (h102Backend<>4) or (limit<=0) then exit;
top:=0; FillChar(lengths,SizeOf(lengths),0);
for i:=0 to entries-1 do
  begin
  used:=a[BWIndex(i)].d+1; if used>limit then used:=limit; lengths[BWIndex(i)]:=used;
  if used>top then top:=used;
  end;
cutoff:=4096; transformCut:=256;
if h102Force=0 then begin cutoff:=H118TransformCut(fftCut); transformCut:=cutoff; end;
if top<=cutoff then exit;
H102MatrixReady:=H114BatchPlan(lengths,entries,1,transformCut,count,dim);
end;

procedure H102Dot(const a,b,c,d:TNTTArray; count:longint; var z:TNTTArray);
var i:longint; v:TBW32;
begin
SetLength(z,count);
for i:=0 to count-1 do
  begin
  v:=NTTMul(a[BWIndex(i)],b[BWIndex(i)])+NTTMul(c[BWIndex(i)],d[BWIndex(i)]);
  if v>=nttMod then v:=v-nttMod;
  z[BWIndex(i)]:=v;
  end;
NTTInverse(z,count);
end;

function H102MatApply(const a:THMat; const x,y:THPoly; limit:longint; out u,v:THPoly):boolean;
var p:TH102Polys; f:TH102Freqs; z:TNTTArray; count,i,used:longint;
begin
H102MatApply:=false;
p[BWIndex(0)]:=a.p00; p[BWIndex(1)]:=a.p01; p[BWIndex(2)]:=a.p10; p[BWIndex(3)]:=a.p11; p[BWIndex(4)]:=x; p[BWIndex(5)]:=y;
if not H102MatrixReady(p,6,limit,count) then exit;
NTTPrepare(count);
for i:=0 to 5 do begin H102LoadPoly(p[BWIndex(i)],limit,count,f[BWIndex(i)]); NTTForward(f[BWIndex(i)],count); end;
H102Dot(f[BWIndex(0)],f[BWIndex(4)],f[BWIndex(1)],f[BWIndex(5)],count,z);
used:=H102Max(H102ProductLen(p[BWIndex(0)],p[BWIndex(4)]),H102ProductLen(p[BWIndex(1)],p[BWIndex(5)]));
if used>limit then used:=limit;
H102StorePoly(z,count,used,u);
H102Dot(f[BWIndex(2)],f[BWIndex(4)],f[BWIndex(3)],f[BWIndex(5)],count,z);
used:=H102Max(H102ProductLen(p[BWIndex(2)],p[BWIndex(4)]),H102ProductLen(p[BWIndex(3)],p[BWIndex(5)]));
if used>limit then used:=limit;
H102StorePoly(z,count,used,v);
H102MatApply:=true;
end;

function H102MatMul(const a,b:THMat; out c:THMat):boolean;
var p:TH102Polys; f:TH102Freqs; z:TNTTArray; count,i,used:longint;
begin
H102MatMul:=false;
p[BWIndex(0)]:=a.p00; p[BWIndex(1)]:=a.p01; p[BWIndex(2)]:=a.p10; p[BWIndex(3)]:=a.p11;
p[BWIndex(4)]:=b.p00; p[BWIndex(5)]:=b.p01; p[BWIndex(6)]:=b.p10; p[BWIndex(7)]:=b.p11;
if not H102MatrixReady(p,8,High(longint),count) then exit;
NTTPrepare(count);
for i:=0 to 7 do begin H102LoadPoly(p[BWIndex(i)],High(longint),count,f[BWIndex(i)]); NTTForward(f[BWIndex(i)],count); end;
H102Dot(f[BWIndex(0)],f[BWIndex(4)],f[BWIndex(1)],f[BWIndex(6)],count,z);
used:=H102Max(H102ProductLen(p[BWIndex(0)],p[BWIndex(4)]),H102ProductLen(p[BWIndex(1)],p[BWIndex(6)]));
H102StorePoly(z,count,used,c.p00);
H102Dot(f[BWIndex(0)],f[BWIndex(5)],f[BWIndex(1)],f[BWIndex(7)],count,z);
used:=H102Max(H102ProductLen(p[BWIndex(0)],p[BWIndex(5)]),H102ProductLen(p[BWIndex(1)],p[BWIndex(7)]));
H102StorePoly(z,count,used,c.p01);
H102Dot(f[BWIndex(2)],f[BWIndex(4)],f[BWIndex(3)],f[BWIndex(6)],count,z);
used:=H102Max(H102ProductLen(p[BWIndex(2)],p[BWIndex(4)]),H102ProductLen(p[BWIndex(3)],p[BWIndex(6)]));
H102StorePoly(z,count,used,c.p10);
H102Dot(f[BWIndex(2)],f[BWIndex(5)],f[BWIndex(3)],f[BWIndex(7)],count,z);
used:=H102Max(H102ProductLen(p[BWIndex(2)],p[BWIndex(5)]),H102ProductLen(p[BWIndex(3)],p[BWIndex(7)]));
H102StorePoly(z,count,used,c.p11);
H102MatMul:=true;
end;

type TH114Freqs=array[0..7] of TH111Array;
function H114MatrixReady(const a:TH102Polys; entries,limit:longint; out count,dim:longint):boolean;
var i,used,top,cutoff,transformCut:longint; lengths:TH114Sizes;
begin
H114MatrixReady:=false;
if (h102Backend<>5) or (limit<=0) then exit;
top:=0; FillChar(lengths,SizeOf(lengths),0);
for i:=0 to entries-1 do
  begin used:=a[BWIndex(i)].d+1; if used>limit then used:=limit; lengths[BWIndex(i)]:=used; if used>top then top:=used; end;
cutoff:=4096; transformCut:=256;
if h102Force=0 then begin cutoff:=H118TransformCut(fftCut); transformCut:=cutoff; end;
if top<=cutoff then exit;
H114MatrixReady:=H114BatchPlan(lengths,entries,16,transformCut,count,dim);
end;
procedure H114Dot(const a,b,c,d:TH111Array; dim:longint; var z:TH111Array);
var i:longint;
begin
SetLength(z,Length(a));
for i:=0 to High(a) do z[BWIndex(i)]:=H111Mul(a[BWIndex(i)],b[BWIndex(i)]) xor H111Mul(c[BWIndex(i)],d[BWIndex(i)]);
H114Inverse(z,dim);
end;
procedure H114LoadPoly(const a:THPoly; limit,count,dim:longint; var z:TH111Array);
var used,j,k,take:longint;
begin
SetLength(z,count); FillChar(z[BWIndex(0)],count*SizeOf(z[BWIndex(0)]),0);
used:=a.d+1; if used>limit then used:=limit;
if used<=0 then exit;
for j:=0 to (used+15) div 16-1 do
  begin
  take:=used-j*16; if take>16 then take:=16;
  for k:=0 to take-1 do z[BWIndex(j),BWIndex(k)]:=a.v^[BWIndex(j*16+k)];
  end;
H114Forward(z,dim);
end;
procedure H114StorePoly(const z:TH111Array; used:longint; out a:THPoly);
var i,j,k:longint; value:boolean;
begin
if used<=0 then begin HPZero(a); exit; end;
HPAlloc(a,used);
for i:=0 to used-1 do
  begin
  j:=i shr 4; k:=i and 15; value:=false;
  if j<Length(z) then value:=z[BWIndex(j),BWIndex(k)];
  if j>0 then value:=value xor z[BWIndex(j-1),BWIndex(k+16)];
  a.v^[BWIndex(i)]:=value;
  end;
a.d:=used-1; HPNorm(a);
end;
function H114MatApply(const a:THMat; const x,y:THPoly; limit:longint; out u,v:THPoly):boolean;
var p:TH102Polys; f:TH114Freqs; z:TH111Array; count,dim,i,used:longint;
begin
H114MatApply:=false;
p[BWIndex(0)]:=a.p00; p[BWIndex(1)]:=a.p01; p[BWIndex(2)]:=a.p10; p[BWIndex(3)]:=a.p11; p[BWIndex(4)]:=x; p[BWIndex(5)]:=y;
if not H114MatrixReady(p,6,limit,count,dim) then exit;
H111Prepare(count);
for i:=0 to 5 do H114LoadPoly(p[BWIndex(i)],limit,count,dim,f[BWIndex(i)]);
used:=H102Max(H102ProductLen(p[BWIndex(0)],p[BWIndex(4)]),H102ProductLen(p[BWIndex(1)],p[BWIndex(5)]));
if used>limit then used:=limit;
if used<=0 then HPZero(u)
else begin H114Dot(f[BWIndex(0)],f[BWIndex(4)],f[BWIndex(1)],f[BWIndex(5)],dim,z); H114StorePoly(z,used,u); end;
used:=H102Max(H102ProductLen(p[BWIndex(2)],p[BWIndex(4)]),H102ProductLen(p[BWIndex(3)],p[BWIndex(5)]));
if used>limit then used:=limit;
if used<=0 then HPZero(v)
else begin H114Dot(f[BWIndex(2)],f[BWIndex(4)],f[BWIndex(3)],f[BWIndex(5)],dim,z); H114StorePoly(z,used,v); end;
H114MatApply:=true;
end;
function H114MatMul(const a,b:THMat; out c:THMat):boolean;
var p:TH102Polys; f:TH114Freqs; z:TH111Array; count,dim,i,used:longint;
begin
H114MatMul:=false;
p[BWIndex(0)]:=a.p00; p[BWIndex(1)]:=a.p01; p[BWIndex(2)]:=a.p10; p[BWIndex(3)]:=a.p11;
p[BWIndex(4)]:=b.p00; p[BWIndex(5)]:=b.p01; p[BWIndex(6)]:=b.p10; p[BWIndex(7)]:=b.p11;
if not H114MatrixReady(p,8,High(longint),count,dim) then exit;
H111Prepare(count);
for i:=0 to 7 do H114LoadPoly(p[BWIndex(i)],High(longint),count,dim,f[BWIndex(i)]);
used:=H102Max(H102ProductLen(p[BWIndex(0)],p[BWIndex(4)]),H102ProductLen(p[BWIndex(1)],p[BWIndex(6)]));
if used<=0 then HPZero(c.p00)
else begin H114Dot(f[BWIndex(0)],f[BWIndex(4)],f[BWIndex(1)],f[BWIndex(6)],dim,z); H114StorePoly(z,used,c.p00); end;
used:=H102Max(H102ProductLen(p[BWIndex(0)],p[BWIndex(5)]),H102ProductLen(p[BWIndex(1)],p[BWIndex(7)]));
if used<=0 then HPZero(c.p01)
else begin H114Dot(f[BWIndex(0)],f[BWIndex(5)],f[BWIndex(1)],f[BWIndex(7)],dim,z); H114StorePoly(z,used,c.p01); end;
used:=H102Max(H102ProductLen(p[BWIndex(2)],p[BWIndex(4)]),H102ProductLen(p[BWIndex(3)],p[BWIndex(6)]));
if used<=0 then HPZero(c.p10)
else begin H114Dot(f[BWIndex(2)],f[BWIndex(4)],f[BWIndex(3)],f[BWIndex(6)],dim,z); H114StorePoly(z,used,c.p10); end;
used:=H102Max(H102ProductLen(p[BWIndex(2)],p[BWIndex(5)]),H102ProductLen(p[BWIndex(3)],p[BWIndex(7)]));
if used<=0 then HPZero(c.p11)
else begin H114Dot(f[BWIndex(2)],f[BWIndex(5)],f[BWIndex(3)],f[BWIndex(7)],dim,z); H114StorePoly(z,used,c.p11); end;
H114MatMul:=true;
end;

type TH121JetFreqs=array[0..7] of TH119FFreq;

function H121JetCost(const plan:TH121JetPlan):int64; inline;
begin H121JetCost:=int64(plan.axes)*plan.count*(plan.dim+2); end;

{ Fused exact sums of products in the GF(2^16) jet transform.
  Select a common plan only if it saves work after padding. }
function H121JetMatrix(const p:TH102Polys; rows,cols,limit:longint;
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
  for j:=0 to 3*plan.axes-1 do H119FTransform(f[i,j],plan.dim,false);
  end;
H121JetMatrix:=true;
end;

procedure H121JetDot(const a,b,c,d:TH119FFreq; const plan:TH121JetPlan;
                    used:longint; out dest:THPoly);
var f:TH119FFreq; dst:TH119Bits; i,j:longint;
begin
for i:=0 to 3*plan.axes-1 do
  begin
  SetLength(f[i],plan.count);
  for j:=0 to plan.count-1 do
    f[i,j]:=H119FAdd(H119FMul(a[i,j],b[i,j]),H119FMul(c[i,j],d[i,j]));
  H119FTransform(f[i],plan.dim,true);
  end;
H119Space(dst,used);
H121JetStore(f,plan,dst,0,used);
HPAlloc(dest,Length(dst)); Move(dst[0],dest.v^[0],Length(dst)*SizeOf(dst[0]));
HPNorm(dest);
end;

function H121MatApply(const a:THMat; const x,y:THPoly; limit:longint; out u,v:THPoly):boolean;
var p:TH102Polys; f:TH121JetFreqs; plan:TH121JetPlan; used:longint;
begin
H121MatApply:=false;
p[0]:=a.p00; p[1]:=a.p01; p[2]:=a.p10; p[3]:=a.p11; p[4]:=x; p[5]:=y;
if not H121JetMatrix(p,2,1,limit,f,plan) then exit;
used:=H102Max(H102ProductLen(p[0],p[4]),H102ProductLen(p[1],p[5]));
if used>limit then used:=limit;
H121JetDot(f[0],f[4],f[1],f[5],plan,used,u);
used:=H102Max(H102ProductLen(p[2],p[4]),H102ProductLen(p[3],p[5]));
if used>limit then used:=limit;
H121JetDot(f[2],f[4],f[3],f[5],plan,used,v);
H121MatApply:=true;
end;

function H121MatMul(const a,b:THMat; out c:THMat):boolean;
var p:TH102Polys; f:TH121JetFreqs; plan:TH121JetPlan; used:longint;
begin
H121MatMul:=false;
p[0]:=a.p00; p[1]:=a.p01; p[2]:=a.p10; p[3]:=a.p11;
p[4]:=b.p00; p[5]:=b.p01; p[6]:=b.p10; p[7]:=b.p11;
if not H121JetMatrix(p,2,2,High(longint),f,plan) then exit;
used:=H102Max(H102ProductLen(p[0],p[4]),H102ProductLen(p[1],p[6]));
H121JetDot(f[0],f[4],f[1],f[6],plan,used,c.p00);
used:=H102Max(H102ProductLen(p[0],p[5]),H102ProductLen(p[1],p[7]));
H121JetDot(f[0],f[5],f[1],f[7],plan,used,c.p01);
used:=H102Max(H102ProductLen(p[2],p[4]),H102ProductLen(p[3],p[6]));
H121JetDot(f[2],f[4],f[3],f[6],plan,used,c.p10);
used:=H102Max(H102ProductLen(p[2],p[5]),H102ProductLen(p[3],p[7]));
H121JetDot(f[2],f[5],f[3],f[7],plan,used,c.p11);
H121MatMul:=true;
end;


procedure HPMatApply(const a:THMat; const x,y:THPoly; out u,v:THPoly);
var lim:longint;
var t0,t1,t2,t3:THPoly;
begin
{ Euclidean prefix: deg(u) <= deg(x)-deg(a.p11), and deg(v)<deg(u). }
lim:=x.d+1; if a.p11.d>=0 then dec(lim,a.p11.d);
if H121MatApply(a,x,y,lim,u,v) then exit;
if H114MatApply(a,x,y,lim,u,v) then exit;
if H102MatApply(a,x,y,lim,u,v) then exit;
HPMulPairTrunc(x,a.p00,a.p10,t0,t1,lim);
HPMulPairTrunc(y,a.p01,a.p11,t2,t3,lim);
HPAdd(t0,t2,u); HPAdd(t1,t3,v);
end;

procedure HPMatMul(const a,b:THMat; out c:THMat);
var t0,t1,t2,t3,t4,t5,t6,t7:THPoly;
begin
if H121MatMul(a,b,c) then exit;
if H114MatMul(a,b,c) then exit;
if H102MatMul(a,b,c) then exit;
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
type TL=array[0..hgcdCut+63] of boolean; PL=^TL;
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
{ H84: derive an exact Euclidean prefix from the leading 32 coefficients. }
function BlockStep:boolean;
type TS=array[0..31] of boolean; TM=array[0..15] of boolean;
type PS=^TS; PM=^TM;
var aa0,aa1:TS; mm00,mm01,mm10,mm11:TM;
var a0,a1,at:PS; m00,m01,m10,m11,mt:PM;
var lo,e0,e1,sh,j,md0,md1,k,tmp,c00,c01,c10,c11:longint;
procedure ApplyPair(var x,y:TL; var dx,dy:longint);
var i,j,lim,ix0,ix1,iy0,iy1:longint; cx,cy:TM;
var p:array[0..11] of ^TMul16Bool;
var l0,l1,h0,h1,s0,s1:boolean;
begin
lim:=dx; if dy>lim then lim:=dy;
lim:=(lim+16) shr 4;
cx:=Default(TM); cy:=Default(TM);
for i:=0 to lim-1 do
  begin
  ix0:=(ord(x[i*16+0]) shl 0) or (ord(x[i*16+1]) shl 1) or (ord(x[i*16+2]) shl 2) or (ord(x[i*16+3]) shl 3) or (ord(x[i*16+4]) shl 4) or (ord(x[i*16+5]) shl 5) or (ord(x[i*16+6]) shl 6) or (ord(x[i*16+7]) shl 7);
  ix1:=(ord(x[i*16+8]) shl 0) or (ord(x[i*16+9]) shl 1) or (ord(x[i*16+10]) shl 2) or (ord(x[i*16+11]) shl 3) or (ord(x[i*16+12]) shl 4) or (ord(x[i*16+13]) shl 5) or (ord(x[i*16+14]) shl 6) or (ord(x[i*16+15]) shl 7);
  iy0:=(ord(y[i*16+0]) shl 0) or (ord(y[i*16+1]) shl 1) or (ord(y[i*16+2]) shl 2) or (ord(y[i*16+3]) shl 3) or (ord(y[i*16+4]) shl 4) or (ord(y[i*16+5]) shl 5) or (ord(y[i*16+6]) shl 6) or (ord(y[i*16+7]) shl 7);
  iy1:=(ord(y[i*16+8]) shl 0) or (ord(y[i*16+9]) shl 1) or (ord(y[i*16+10]) shl 2) or (ord(y[i*16+11]) shl 3) or (ord(y[i*16+12]) shl 4) or (ord(y[i*16+13]) shl 5) or (ord(y[i*16+14]) shl 6) or (ord(y[i*16+15]) shl 7);
  p[0]:=@mul8Bool[((c00 and $FF) shl 8) or ix0];
  p[1]:=@mul8Bool[((c01 and $FF) shl 8) or iy0];
  p[2]:=@mul8Bool[((c00 shr 8) shl 8) or ix1];
  p[3]:=@mul8Bool[((c01 shr 8) shl 8) or iy1];
  p[4]:=@mul8Bool[(((c00 xor (c00 shr 8)) and $FF) shl 8) or (ix0 xor ix1)];
  p[5]:=@mul8Bool[(((c01 xor (c01 shr 8)) and $FF) shl 8) or (iy0 xor iy1)];
  p[6]:=@mul8Bool[((c10 and $FF) shl 8) or ix0];
  p[7]:=@mul8Bool[((c11 and $FF) shl 8) or iy0];
  p[8]:=@mul8Bool[((c10 shr 8) shl 8) or ix1];
  p[9]:=@mul8Bool[((c11 shr 8) shl 8) or iy1];
  p[10]:=@mul8Bool[(((c10 xor (c10 shr 8)) and $FF) shl 8) or (ix0 xor ix1)];
  p[11]:=@mul8Bool[(((c11 xor (c11 shr 8)) and $FF) shl 8) or (iy0 xor iy1)];
    l0:=p[0]^[0] xor p[1]^[0]; l1:=p[0]^[0+8] xor p[1]^[0+8];
    h0:=p[2]^[0] xor p[3]^[0]; h1:=p[2]^[0+8] xor p[3]^[0+8];
    s0:=p[4]^[0] xor p[5]^[0]; s1:=p[4]^[0+8] xor p[5]^[0+8];
    x[i*16+0]:=l0 xor cx[0];
    x[i*16+8+0]:=l1 xor l0 xor s0 xor h0 xor cx[0+8];
    cx[0]:=h0 xor l1 xor s1 xor h1; cx[0+8]:=h1;
    l0:=p[6]^[0] xor p[7]^[0]; l1:=p[6]^[0+8] xor p[7]^[0+8];
    h0:=p[8]^[0] xor p[9]^[0]; h1:=p[8]^[0+8] xor p[9]^[0+8];
    s0:=p[10]^[0] xor p[11]^[0]; s1:=p[10]^[0+8] xor p[11]^[0+8];
    y[i*16+0]:=l0 xor cy[0];
    y[i*16+8+0]:=l1 xor l0 xor s0 xor h0 xor cy[0+8];
    cy[0]:=h0 xor l1 xor s1 xor h1; cy[0+8]:=h1;
    l0:=p[0]^[1] xor p[1]^[1]; l1:=p[0]^[1+8] xor p[1]^[1+8];
    h0:=p[2]^[1] xor p[3]^[1]; h1:=p[2]^[1+8] xor p[3]^[1+8];
    s0:=p[4]^[1] xor p[5]^[1]; s1:=p[4]^[1+8] xor p[5]^[1+8];
    x[i*16+1]:=l0 xor cx[1];
    x[i*16+8+1]:=l1 xor l0 xor s0 xor h0 xor cx[1+8];
    cx[1]:=h0 xor l1 xor s1 xor h1; cx[1+8]:=h1;
    l0:=p[6]^[1] xor p[7]^[1]; l1:=p[6]^[1+8] xor p[7]^[1+8];
    h0:=p[8]^[1] xor p[9]^[1]; h1:=p[8]^[1+8] xor p[9]^[1+8];
    s0:=p[10]^[1] xor p[11]^[1]; s1:=p[10]^[1+8] xor p[11]^[1+8];
    y[i*16+1]:=l0 xor cy[1];
    y[i*16+8+1]:=l1 xor l0 xor s0 xor h0 xor cy[1+8];
    cy[1]:=h0 xor l1 xor s1 xor h1; cy[1+8]:=h1;
    l0:=p[0]^[2] xor p[1]^[2]; l1:=p[0]^[2+8] xor p[1]^[2+8];
    h0:=p[2]^[2] xor p[3]^[2]; h1:=p[2]^[2+8] xor p[3]^[2+8];
    s0:=p[4]^[2] xor p[5]^[2]; s1:=p[4]^[2+8] xor p[5]^[2+8];
    x[i*16+2]:=l0 xor cx[2];
    x[i*16+8+2]:=l1 xor l0 xor s0 xor h0 xor cx[2+8];
    cx[2]:=h0 xor l1 xor s1 xor h1; cx[2+8]:=h1;
    l0:=p[6]^[2] xor p[7]^[2]; l1:=p[6]^[2+8] xor p[7]^[2+8];
    h0:=p[8]^[2] xor p[9]^[2]; h1:=p[8]^[2+8] xor p[9]^[2+8];
    s0:=p[10]^[2] xor p[11]^[2]; s1:=p[10]^[2+8] xor p[11]^[2+8];
    y[i*16+2]:=l0 xor cy[2];
    y[i*16+8+2]:=l1 xor l0 xor s0 xor h0 xor cy[2+8];
    cy[2]:=h0 xor l1 xor s1 xor h1; cy[2+8]:=h1;
    l0:=p[0]^[3] xor p[1]^[3]; l1:=p[0]^[3+8] xor p[1]^[3+8];
    h0:=p[2]^[3] xor p[3]^[3]; h1:=p[2]^[3+8] xor p[3]^[3+8];
    s0:=p[4]^[3] xor p[5]^[3]; s1:=p[4]^[3+8] xor p[5]^[3+8];
    x[i*16+3]:=l0 xor cx[3];
    x[i*16+8+3]:=l1 xor l0 xor s0 xor h0 xor cx[3+8];
    cx[3]:=h0 xor l1 xor s1 xor h1; cx[3+8]:=h1;
    l0:=p[6]^[3] xor p[7]^[3]; l1:=p[6]^[3+8] xor p[7]^[3+8];
    h0:=p[8]^[3] xor p[9]^[3]; h1:=p[8]^[3+8] xor p[9]^[3+8];
    s0:=p[10]^[3] xor p[11]^[3]; s1:=p[10]^[3+8] xor p[11]^[3+8];
    y[i*16+3]:=l0 xor cy[3];
    y[i*16+8+3]:=l1 xor l0 xor s0 xor h0 xor cy[3+8];
    cy[3]:=h0 xor l1 xor s1 xor h1; cy[3+8]:=h1;
    l0:=p[0]^[4] xor p[1]^[4]; l1:=p[0]^[4+8] xor p[1]^[4+8];
    h0:=p[2]^[4] xor p[3]^[4]; h1:=p[2]^[4+8] xor p[3]^[4+8];
    s0:=p[4]^[4] xor p[5]^[4]; s1:=p[4]^[4+8] xor p[5]^[4+8];
    x[i*16+4]:=l0 xor cx[4];
    x[i*16+8+4]:=l1 xor l0 xor s0 xor h0 xor cx[4+8];
    cx[4]:=h0 xor l1 xor s1 xor h1; cx[4+8]:=h1;
    l0:=p[6]^[4] xor p[7]^[4]; l1:=p[6]^[4+8] xor p[7]^[4+8];
    h0:=p[8]^[4] xor p[9]^[4]; h1:=p[8]^[4+8] xor p[9]^[4+8];
    s0:=p[10]^[4] xor p[11]^[4]; s1:=p[10]^[4+8] xor p[11]^[4+8];
    y[i*16+4]:=l0 xor cy[4];
    y[i*16+8+4]:=l1 xor l0 xor s0 xor h0 xor cy[4+8];
    cy[4]:=h0 xor l1 xor s1 xor h1; cy[4+8]:=h1;
    l0:=p[0]^[5] xor p[1]^[5]; l1:=p[0]^[5+8] xor p[1]^[5+8];
    h0:=p[2]^[5] xor p[3]^[5]; h1:=p[2]^[5+8] xor p[3]^[5+8];
    s0:=p[4]^[5] xor p[5]^[5]; s1:=p[4]^[5+8] xor p[5]^[5+8];
    x[i*16+5]:=l0 xor cx[5];
    x[i*16+8+5]:=l1 xor l0 xor s0 xor h0 xor cx[5+8];
    cx[5]:=h0 xor l1 xor s1 xor h1; cx[5+8]:=h1;
    l0:=p[6]^[5] xor p[7]^[5]; l1:=p[6]^[5+8] xor p[7]^[5+8];
    h0:=p[8]^[5] xor p[9]^[5]; h1:=p[8]^[5+8] xor p[9]^[5+8];
    s0:=p[10]^[5] xor p[11]^[5]; s1:=p[10]^[5+8] xor p[11]^[5+8];
    y[i*16+5]:=l0 xor cy[5];
    y[i*16+8+5]:=l1 xor l0 xor s0 xor h0 xor cy[5+8];
    cy[5]:=h0 xor l1 xor s1 xor h1; cy[5+8]:=h1;
    l0:=p[0]^[6] xor p[1]^[6]; l1:=p[0]^[6+8] xor p[1]^[6+8];
    h0:=p[2]^[6] xor p[3]^[6]; h1:=p[2]^[6+8] xor p[3]^[6+8];
    s0:=p[4]^[6] xor p[5]^[6]; s1:=p[4]^[6+8] xor p[5]^[6+8];
    x[i*16+6]:=l0 xor cx[6];
    x[i*16+8+6]:=l1 xor l0 xor s0 xor h0 xor cx[6+8];
    cx[6]:=h0 xor l1 xor s1 xor h1; cx[6+8]:=h1;
    l0:=p[6]^[6] xor p[7]^[6]; l1:=p[6]^[6+8] xor p[7]^[6+8];
    h0:=p[8]^[6] xor p[9]^[6]; h1:=p[8]^[6+8] xor p[9]^[6+8];
    s0:=p[10]^[6] xor p[11]^[6]; s1:=p[10]^[6+8] xor p[11]^[6+8];
    y[i*16+6]:=l0 xor cy[6];
    y[i*16+8+6]:=l1 xor l0 xor s0 xor h0 xor cy[6+8];
    cy[6]:=h0 xor l1 xor s1 xor h1; cy[6+8]:=h1;
    l0:=p[0]^[7] xor p[1]^[7]; l1:=p[0]^[7+8] xor p[1]^[7+8];
    h0:=p[2]^[7] xor p[3]^[7]; h1:=p[2]^[7+8] xor p[3]^[7+8];
    s0:=p[4]^[7] xor p[5]^[7]; s1:=p[4]^[7+8] xor p[5]^[7+8];
    x[i*16+7]:=l0 xor cx[7];
    x[i*16+8+7]:=l1 xor l0 xor s0 xor h0 xor cx[7+8];
    cx[7]:=h0 xor l1 xor s1 xor h1; cx[7+8]:=h1;
    l0:=p[6]^[7] xor p[7]^[7]; l1:=p[6]^[7+8] xor p[7]^[7+8];
    h0:=p[8]^[7] xor p[9]^[7]; h1:=p[8]^[7+8] xor p[9]^[7+8];
    s0:=p[10]^[7] xor p[11]^[7]; s1:=p[10]^[7+8] xor p[11]^[7+8];
    y[i*16+7]:=l0 xor cy[7];
    y[i*16+8+7]:=l1 xor l0 xor s0 xor h0 xor cy[7+8];
    cy[7]:=h0 xor l1 xor s1 xor h1; cy[7+8]:=h1;
  end;
for j:=0 to 15 do begin x[lim*16+j]:=cx[j]; y[lim*16+j]:=cy[j]; end;
dx:=lim*16+15; dy:=dx; Degree(x,dx); Degree(y,dy);
end;
begin
BlockStep:=false;
if (d0<63) or (d1>d0) or (d1<d0-15) or (d1<target+16) then exit;
lo:=d0-31;
{ H95: exchange Boolean window/matrix buffer addresses, as the outer leaf does. }
a0:=@aa0; a1:=@aa1;
m00:=@mm00; m01:=@mm01; m10:=@mm10; m11:=@mm11;
for j:=0 to 31 do begin a0^[j]:=r0^[lo+j]; a1^[j]:=r1^[lo+j]; end;
m00^:=Default(TM); m01^:=Default(TM); m10^:=Default(TM); m11^:=Default(TM);
m00^[0]:=true; m11^[0]:=true;
e0:=31; e1:=d1-lo; md0:=0; md1:=0;
while e1>=16 do
  begin
  while e0>=e1 do
    begin
    sh:=e0-e1;
    for j:=0 to e1 do a0^[j+sh]:=a0^[j+sh] xor a1^[j];
    { H96: matrix coefficients above the row degree are zero. }
    for j:=0 to md1 do
      begin m00^[j+sh]:=m00^[j+sh] xor m10^[j]; m01^[j+sh]:=m01^[j+sh] xor m11^[j]; end;
    if md1+sh>md0 then md0:=md1+sh;
    dec(e0); while (e0>=0) and not a0^[e0] do dec(e0);
    end;
  at:=a0; a0:=a1; a1:=at; tmp:=e0; e0:=e1; e1:=tmp;
  mt:=m00; m00:=m10; m10:=mt; mt:=m01; m01:=m11; m11:=mt;
  tmp:=md0; md0:=md1; md1:=tmp;
  end;
c00:=0; c01:=0; c10:=0; c11:=0;
for k:=0 to 15 do
  begin
  c00:=c00 or (ord(m00^[k]) shl k); c01:=c01 or (ord(m01^[k]) shl k);
  c10:=c10 or (ord(m10^[k]) shl k); c11:=c11 or (ord(m11^[k]) shl k);
  end;
ApplyPair(r0^,r1^,d0,d1); ApplyPair(u0^,u1^,du0,du1); ApplyPair(v0^,v1^,dv0,dv1);
BlockStep:=true;
end;
{ H85: a 64-coefficient window batches a degree <= 31 matrix. }
function BlockStep64:boolean;
type TS=array[0..63] of boolean; TM=array[0..31] of boolean;
type PS=^TS; PM=^TM;
var aa0,aa1:TS; mm00,mm01,mm10,mm11:TM;
var a0,a1,at:PS; m00,m01,m10,m11,mt:PM;
var lo,e0,e1,sh,j,md0,md1,tmp:longint;
type TP=array[0..33] of boolean; PP=^TP;
var tx,ty:array[0..63] of TP;
var sx,sy,dx,dy:PP;
var jx,jy:TP; bit,power,index,i:longint;
{ H91: reuse row addresses and joint-table entries in the same 3+3 batch. }
procedure ApplyPair32(var x,y:TL; var dx,dy:longint);
var i,j,lim:longint; index:array[0..10] of longint;
var px,py:array[0..10] of PP; cx,cy:TM;
var bx,by:^TM;
begin
cx:=Default(TM); cy:=Default(TM);
lim:=dx; if dy>lim then lim:=dy; lim:=(lim+32) shr 5;
for i:=0 to lim-1 do
  begin
  bx:=@x[i*32]; by:=@y[i*32];
  index[0]:=(ord(bx^[0]) shl 0) or (ord(bx^[1]) shl 1) or (ord(bx^[2]) shl 2) or (ord(by^[0]) shl 3) or (ord(by^[1]) shl 4) or (ord(by^[2]) shl 5);
  px[0]:=@tx[index[0]]; py[0]:=@ty[index[0]];
  index[1]:=(ord(bx^[3]) shl 0) or (ord(bx^[4]) shl 1) or (ord(bx^[5]) shl 2) or (ord(by^[3]) shl 3) or (ord(by^[4]) shl 4) or (ord(by^[5]) shl 5);
  px[1]:=@tx[index[1]]; py[1]:=@ty[index[1]];
  index[2]:=(ord(bx^[6]) shl 0) or (ord(bx^[7]) shl 1) or (ord(bx^[8]) shl 2) or (ord(by^[6]) shl 3) or (ord(by^[7]) shl 4) or (ord(by^[8]) shl 5);
  px[2]:=@tx[index[2]]; py[2]:=@ty[index[2]];
  index[3]:=(ord(bx^[9]) shl 0) or (ord(bx^[10]) shl 1) or (ord(bx^[11]) shl 2) or (ord(by^[9]) shl 3) or (ord(by^[10]) shl 4) or (ord(by^[11]) shl 5);
  px[3]:=@tx[index[3]]; py[3]:=@ty[index[3]];
  index[4]:=(ord(bx^[12]) shl 0) or (ord(bx^[13]) shl 1) or (ord(bx^[14]) shl 2) or (ord(by^[12]) shl 3) or (ord(by^[13]) shl 4) or (ord(by^[14]) shl 5);
  px[4]:=@tx[index[4]]; py[4]:=@ty[index[4]];
  index[5]:=(ord(bx^[15]) shl 0) or (ord(bx^[16]) shl 1) or (ord(bx^[17]) shl 2) or (ord(by^[15]) shl 3) or (ord(by^[16]) shl 4) or (ord(by^[17]) shl 5);
  px[5]:=@tx[index[5]]; py[5]:=@ty[index[5]];
  index[6]:=(ord(bx^[18]) shl 0) or (ord(bx^[19]) shl 1) or (ord(bx^[20]) shl 2) or (ord(by^[18]) shl 3) or (ord(by^[19]) shl 4) or (ord(by^[20]) shl 5);
  px[6]:=@tx[index[6]]; py[6]:=@ty[index[6]];
  index[7]:=(ord(bx^[21]) shl 0) or (ord(bx^[22]) shl 1) or (ord(bx^[23]) shl 2) or (ord(by^[21]) shl 3) or (ord(by^[22]) shl 4) or (ord(by^[23]) shl 5);
  px[7]:=@tx[index[7]]; py[7]:=@ty[index[7]];
  index[8]:=(ord(bx^[24]) shl 0) or (ord(bx^[25]) shl 1) or (ord(bx^[26]) shl 2) or (ord(by^[24]) shl 3) or (ord(by^[25]) shl 4) or (ord(by^[26]) shl 5);
  px[8]:=@tx[index[8]]; py[8]:=@ty[index[8]];
  index[9]:=(ord(bx^[27]) shl 0) or (ord(bx^[28]) shl 1) or (ord(bx^[29]) shl 2) or (ord(by^[27]) shl 3) or (ord(by^[28]) shl 4) or (ord(by^[29]) shl 5);
  px[9]:=@tx[index[9]]; py[9]:=@ty[index[9]];
  index[10]:=(ord(bx^[30]) shl 0) or (ord(bx^[31]) shl 1) or (ord(by^[30]) shl 3) or (ord(by^[31]) shl 4);
  px[10]:=@tx[index[10]]; py[10]:=@ty[index[10]];
  bx^[0]:=px[0]^[0] xor cx[0];
  bx^[1]:=px[0]^[1] xor cx[1];
  bx^[2]:=px[0]^[2] xor cx[2];
  bx^[3]:=px[0]^[3] xor px[1]^[0] xor cx[3];
  bx^[4]:=px[0]^[4] xor px[1]^[1] xor cx[4];
  bx^[5]:=px[0]^[5] xor px[1]^[2] xor cx[5];
  bx^[6]:=px[0]^[6] xor px[1]^[3] xor px[2]^[0] xor cx[6];
  bx^[7]:=px[0]^[7] xor px[1]^[4] xor px[2]^[1] xor cx[7];
  bx^[8]:=px[0]^[8] xor px[1]^[5] xor px[2]^[2] xor cx[8];
  bx^[9]:=px[0]^[9] xor px[1]^[6] xor px[2]^[3] xor px[3]^[0] xor cx[9];
  bx^[10]:=px[0]^[10] xor px[1]^[7] xor px[2]^[4] xor px[3]^[1] xor cx[10];
  bx^[11]:=px[0]^[11] xor px[1]^[8] xor px[2]^[5] xor px[3]^[2] xor cx[11];
  bx^[12]:=px[0]^[12] xor px[1]^[9] xor px[2]^[6] xor px[3]^[3] xor px[4]^[0] xor cx[12];
  bx^[13]:=px[0]^[13] xor px[1]^[10] xor px[2]^[7] xor px[3]^[4] xor px[4]^[1] xor cx[13];
  bx^[14]:=px[0]^[14] xor px[1]^[11] xor px[2]^[8] xor px[3]^[5] xor px[4]^[2] xor cx[14];
  bx^[15]:=px[0]^[15] xor px[1]^[12] xor px[2]^[9] xor px[3]^[6] xor px[4]^[3] xor px[5]^[0] xor cx[15];
  bx^[16]:=px[0]^[16] xor px[1]^[13] xor px[2]^[10] xor px[3]^[7] xor px[4]^[4] xor px[5]^[1] xor cx[16];
  bx^[17]:=px[0]^[17] xor px[1]^[14] xor px[2]^[11] xor px[3]^[8] xor px[4]^[5] xor px[5]^[2] xor cx[17];
  bx^[18]:=px[0]^[18] xor px[1]^[15] xor px[2]^[12] xor px[3]^[9] xor px[4]^[6] xor px[5]^[3] xor px[6]^[0] xor cx[18];
  bx^[19]:=px[0]^[19] xor px[1]^[16] xor px[2]^[13] xor px[3]^[10] xor px[4]^[7] xor px[5]^[4] xor px[6]^[1] xor cx[19];
  bx^[20]:=px[0]^[20] xor px[1]^[17] xor px[2]^[14] xor px[3]^[11] xor px[4]^[8] xor px[5]^[5] xor px[6]^[2] xor cx[20];
  bx^[21]:=px[0]^[21] xor px[1]^[18] xor px[2]^[15] xor px[3]^[12] xor px[4]^[9] xor px[5]^[6] xor px[6]^[3] xor px[7]^[0] xor cx[21];
  bx^[22]:=px[0]^[22] xor px[1]^[19] xor px[2]^[16] xor px[3]^[13] xor px[4]^[10] xor px[5]^[7] xor px[6]^[4] xor px[7]^[1] xor cx[22];
  bx^[23]:=px[0]^[23] xor px[1]^[20] xor px[2]^[17] xor px[3]^[14] xor px[4]^[11] xor px[5]^[8] xor px[6]^[5] xor px[7]^[2] xor cx[23];
  bx^[24]:=px[0]^[24] xor px[1]^[21] xor px[2]^[18] xor px[3]^[15] xor px[4]^[12] xor px[5]^[9] xor px[6]^[6] xor px[7]^[3] xor px[8]^[0] xor cx[24];
  bx^[25]:=px[0]^[25] xor px[1]^[22] xor px[2]^[19] xor px[3]^[16] xor px[4]^[13] xor px[5]^[10] xor px[6]^[7] xor px[7]^[4] xor px[8]^[1] xor cx[25];
  bx^[26]:=px[0]^[26] xor px[1]^[23] xor px[2]^[20] xor px[3]^[17] xor px[4]^[14] xor px[5]^[11] xor px[6]^[8] xor px[7]^[5] xor px[8]^[2] xor cx[26];
  bx^[27]:=px[0]^[27] xor px[1]^[24] xor px[2]^[21] xor px[3]^[18] xor px[4]^[15] xor px[5]^[12] xor px[6]^[9] xor px[7]^[6] xor px[8]^[3] xor px[9]^[0] xor cx[27];
  bx^[28]:=px[0]^[28] xor px[1]^[25] xor px[2]^[22] xor px[3]^[19] xor px[4]^[16] xor px[5]^[13] xor px[6]^[10] xor px[7]^[7] xor px[8]^[4] xor px[9]^[1] xor cx[28];
  bx^[29]:=px[0]^[29] xor px[1]^[26] xor px[2]^[23] xor px[3]^[20] xor px[4]^[17] xor px[5]^[14] xor px[6]^[11] xor px[7]^[8] xor px[8]^[5] xor px[9]^[2] xor cx[29];
  bx^[30]:=px[0]^[30] xor px[1]^[27] xor px[2]^[24] xor px[3]^[21] xor px[4]^[18] xor px[5]^[15] xor px[6]^[12] xor px[7]^[9] xor px[8]^[6] xor px[9]^[3] xor px[10]^[0] xor cx[30];
  bx^[31]:=px[0]^[31] xor px[1]^[28] xor px[2]^[25] xor px[3]^[22] xor px[4]^[19] xor px[5]^[16] xor px[6]^[13] xor px[7]^[10] xor px[8]^[7] xor px[9]^[4] xor px[10]^[1] xor cx[31];
  cx[0]:=px[0]^[32] xor px[1]^[29] xor px[2]^[26] xor px[3]^[23] xor px[4]^[20] xor px[5]^[17] xor px[6]^[14] xor px[7]^[11] xor px[8]^[8] xor px[9]^[5] xor px[10]^[2];
  cx[1]:=px[0]^[33] xor px[1]^[30] xor px[2]^[27] xor px[3]^[24] xor px[4]^[21] xor px[5]^[18] xor px[6]^[15] xor px[7]^[12] xor px[8]^[9] xor px[9]^[6] xor px[10]^[3];
  cx[2]:=px[1]^[31] xor px[2]^[28] xor px[3]^[25] xor px[4]^[22] xor px[5]^[19] xor px[6]^[16] xor px[7]^[13] xor px[8]^[10] xor px[9]^[7] xor px[10]^[4];
  cx[3]:=px[1]^[32] xor px[2]^[29] xor px[3]^[26] xor px[4]^[23] xor px[5]^[20] xor px[6]^[17] xor px[7]^[14] xor px[8]^[11] xor px[9]^[8] xor px[10]^[5];
  cx[4]:=px[1]^[33] xor px[2]^[30] xor px[3]^[27] xor px[4]^[24] xor px[5]^[21] xor px[6]^[18] xor px[7]^[15] xor px[8]^[12] xor px[9]^[9] xor px[10]^[6];
  cx[5]:=px[2]^[31] xor px[3]^[28] xor px[4]^[25] xor px[5]^[22] xor px[6]^[19] xor px[7]^[16] xor px[8]^[13] xor px[9]^[10] xor px[10]^[7];
  cx[6]:=px[2]^[32] xor px[3]^[29] xor px[4]^[26] xor px[5]^[23] xor px[6]^[20] xor px[7]^[17] xor px[8]^[14] xor px[9]^[11] xor px[10]^[8];
  cx[7]:=px[2]^[33] xor px[3]^[30] xor px[4]^[27] xor px[5]^[24] xor px[6]^[21] xor px[7]^[18] xor px[8]^[15] xor px[9]^[12] xor px[10]^[9];
  cx[8]:=px[3]^[31] xor px[4]^[28] xor px[5]^[25] xor px[6]^[22] xor px[7]^[19] xor px[8]^[16] xor px[9]^[13] xor px[10]^[10];
  cx[9]:=px[3]^[32] xor px[4]^[29] xor px[5]^[26] xor px[6]^[23] xor px[7]^[20] xor px[8]^[17] xor px[9]^[14] xor px[10]^[11];
  cx[10]:=px[3]^[33] xor px[4]^[30] xor px[5]^[27] xor px[6]^[24] xor px[7]^[21] xor px[8]^[18] xor px[9]^[15] xor px[10]^[12];
  cx[11]:=px[4]^[31] xor px[5]^[28] xor px[6]^[25] xor px[7]^[22] xor px[8]^[19] xor px[9]^[16] xor px[10]^[13];
  cx[12]:=px[4]^[32] xor px[5]^[29] xor px[6]^[26] xor px[7]^[23] xor px[8]^[20] xor px[9]^[17] xor px[10]^[14];
  cx[13]:=px[4]^[33] xor px[5]^[30] xor px[6]^[27] xor px[7]^[24] xor px[8]^[21] xor px[9]^[18] xor px[10]^[15];
  cx[14]:=px[5]^[31] xor px[6]^[28] xor px[7]^[25] xor px[8]^[22] xor px[9]^[19] xor px[10]^[16];
  cx[15]:=px[5]^[32] xor px[6]^[29] xor px[7]^[26] xor px[8]^[23] xor px[9]^[20] xor px[10]^[17];
  cx[16]:=px[5]^[33] xor px[6]^[30] xor px[7]^[27] xor px[8]^[24] xor px[9]^[21] xor px[10]^[18];
  cx[17]:=px[6]^[31] xor px[7]^[28] xor px[8]^[25] xor px[9]^[22] xor px[10]^[19];
  cx[18]:=px[6]^[32] xor px[7]^[29] xor px[8]^[26] xor px[9]^[23] xor px[10]^[20];
  cx[19]:=px[6]^[33] xor px[7]^[30] xor px[8]^[27] xor px[9]^[24] xor px[10]^[21];
  cx[20]:=px[7]^[31] xor px[8]^[28] xor px[9]^[25] xor px[10]^[22];
  cx[21]:=px[7]^[32] xor px[8]^[29] xor px[9]^[26] xor px[10]^[23];
  cx[22]:=px[7]^[33] xor px[8]^[30] xor px[9]^[27] xor px[10]^[24];
  cx[23]:=px[8]^[31] xor px[9]^[28] xor px[10]^[25];
  cx[24]:=px[8]^[32] xor px[9]^[29] xor px[10]^[26];
  cx[25]:=px[8]^[33] xor px[9]^[30] xor px[10]^[27];
  cx[26]:=px[9]^[31] xor px[10]^[28];
  cx[27]:=px[9]^[32] xor px[10]^[29];
  cx[28]:=px[9]^[33] xor px[10]^[30];
  cx[29]:=px[10]^[31];
  cx[30]:=px[10]^[32];
  cx[31]:=px[10]^[33];
  by^[0]:=py[0]^[0] xor cy[0];
  by^[1]:=py[0]^[1] xor cy[1];
  by^[2]:=py[0]^[2] xor cy[2];
  by^[3]:=py[0]^[3] xor py[1]^[0] xor cy[3];
  by^[4]:=py[0]^[4] xor py[1]^[1] xor cy[4];
  by^[5]:=py[0]^[5] xor py[1]^[2] xor cy[5];
  by^[6]:=py[0]^[6] xor py[1]^[3] xor py[2]^[0] xor cy[6];
  by^[7]:=py[0]^[7] xor py[1]^[4] xor py[2]^[1] xor cy[7];
  by^[8]:=py[0]^[8] xor py[1]^[5] xor py[2]^[2] xor cy[8];
  by^[9]:=py[0]^[9] xor py[1]^[6] xor py[2]^[3] xor py[3]^[0] xor cy[9];
  by^[10]:=py[0]^[10] xor py[1]^[7] xor py[2]^[4] xor py[3]^[1] xor cy[10];
  by^[11]:=py[0]^[11] xor py[1]^[8] xor py[2]^[5] xor py[3]^[2] xor cy[11];
  by^[12]:=py[0]^[12] xor py[1]^[9] xor py[2]^[6] xor py[3]^[3] xor py[4]^[0] xor cy[12];
  by^[13]:=py[0]^[13] xor py[1]^[10] xor py[2]^[7] xor py[3]^[4] xor py[4]^[1] xor cy[13];
  by^[14]:=py[0]^[14] xor py[1]^[11] xor py[2]^[8] xor py[3]^[5] xor py[4]^[2] xor cy[14];
  by^[15]:=py[0]^[15] xor py[1]^[12] xor py[2]^[9] xor py[3]^[6] xor py[4]^[3] xor py[5]^[0] xor cy[15];
  by^[16]:=py[0]^[16] xor py[1]^[13] xor py[2]^[10] xor py[3]^[7] xor py[4]^[4] xor py[5]^[1] xor cy[16];
  by^[17]:=py[0]^[17] xor py[1]^[14] xor py[2]^[11] xor py[3]^[8] xor py[4]^[5] xor py[5]^[2] xor cy[17];
  by^[18]:=py[0]^[18] xor py[1]^[15] xor py[2]^[12] xor py[3]^[9] xor py[4]^[6] xor py[5]^[3] xor py[6]^[0] xor cy[18];
  by^[19]:=py[0]^[19] xor py[1]^[16] xor py[2]^[13] xor py[3]^[10] xor py[4]^[7] xor py[5]^[4] xor py[6]^[1] xor cy[19];
  by^[20]:=py[0]^[20] xor py[1]^[17] xor py[2]^[14] xor py[3]^[11] xor py[4]^[8] xor py[5]^[5] xor py[6]^[2] xor cy[20];
  by^[21]:=py[0]^[21] xor py[1]^[18] xor py[2]^[15] xor py[3]^[12] xor py[4]^[9] xor py[5]^[6] xor py[6]^[3] xor py[7]^[0] xor cy[21];
  by^[22]:=py[0]^[22] xor py[1]^[19] xor py[2]^[16] xor py[3]^[13] xor py[4]^[10] xor py[5]^[7] xor py[6]^[4] xor py[7]^[1] xor cy[22];
  by^[23]:=py[0]^[23] xor py[1]^[20] xor py[2]^[17] xor py[3]^[14] xor py[4]^[11] xor py[5]^[8] xor py[6]^[5] xor py[7]^[2] xor cy[23];
  by^[24]:=py[0]^[24] xor py[1]^[21] xor py[2]^[18] xor py[3]^[15] xor py[4]^[12] xor py[5]^[9] xor py[6]^[6] xor py[7]^[3] xor py[8]^[0] xor cy[24];
  by^[25]:=py[0]^[25] xor py[1]^[22] xor py[2]^[19] xor py[3]^[16] xor py[4]^[13] xor py[5]^[10] xor py[6]^[7] xor py[7]^[4] xor py[8]^[1] xor cy[25];
  by^[26]:=py[0]^[26] xor py[1]^[23] xor py[2]^[20] xor py[3]^[17] xor py[4]^[14] xor py[5]^[11] xor py[6]^[8] xor py[7]^[5] xor py[8]^[2] xor cy[26];
  by^[27]:=py[0]^[27] xor py[1]^[24] xor py[2]^[21] xor py[3]^[18] xor py[4]^[15] xor py[5]^[12] xor py[6]^[9] xor py[7]^[6] xor py[8]^[3] xor py[9]^[0] xor cy[27];
  by^[28]:=py[0]^[28] xor py[1]^[25] xor py[2]^[22] xor py[3]^[19] xor py[4]^[16] xor py[5]^[13] xor py[6]^[10] xor py[7]^[7] xor py[8]^[4] xor py[9]^[1] xor cy[28];
  by^[29]:=py[0]^[29] xor py[1]^[26] xor py[2]^[23] xor py[3]^[20] xor py[4]^[17] xor py[5]^[14] xor py[6]^[11] xor py[7]^[8] xor py[8]^[5] xor py[9]^[2] xor cy[29];
  by^[30]:=py[0]^[30] xor py[1]^[27] xor py[2]^[24] xor py[3]^[21] xor py[4]^[18] xor py[5]^[15] xor py[6]^[12] xor py[7]^[9] xor py[8]^[6] xor py[9]^[3] xor py[10]^[0] xor cy[30];
  by^[31]:=py[0]^[31] xor py[1]^[28] xor py[2]^[25] xor py[3]^[22] xor py[4]^[19] xor py[5]^[16] xor py[6]^[13] xor py[7]^[10] xor py[8]^[7] xor py[9]^[4] xor py[10]^[1] xor cy[31];
  cy[0]:=py[0]^[32] xor py[1]^[29] xor py[2]^[26] xor py[3]^[23] xor py[4]^[20] xor py[5]^[17] xor py[6]^[14] xor py[7]^[11] xor py[8]^[8] xor py[9]^[5] xor py[10]^[2];
  cy[1]:=py[0]^[33] xor py[1]^[30] xor py[2]^[27] xor py[3]^[24] xor py[4]^[21] xor py[5]^[18] xor py[6]^[15] xor py[7]^[12] xor py[8]^[9] xor py[9]^[6] xor py[10]^[3];
  cy[2]:=py[1]^[31] xor py[2]^[28] xor py[3]^[25] xor py[4]^[22] xor py[5]^[19] xor py[6]^[16] xor py[7]^[13] xor py[8]^[10] xor py[9]^[7] xor py[10]^[4];
  cy[3]:=py[1]^[32] xor py[2]^[29] xor py[3]^[26] xor py[4]^[23] xor py[5]^[20] xor py[6]^[17] xor py[7]^[14] xor py[8]^[11] xor py[9]^[8] xor py[10]^[5];
  cy[4]:=py[1]^[33] xor py[2]^[30] xor py[3]^[27] xor py[4]^[24] xor py[5]^[21] xor py[6]^[18] xor py[7]^[15] xor py[8]^[12] xor py[9]^[9] xor py[10]^[6];
  cy[5]:=py[2]^[31] xor py[3]^[28] xor py[4]^[25] xor py[5]^[22] xor py[6]^[19] xor py[7]^[16] xor py[8]^[13] xor py[9]^[10] xor py[10]^[7];
  cy[6]:=py[2]^[32] xor py[3]^[29] xor py[4]^[26] xor py[5]^[23] xor py[6]^[20] xor py[7]^[17] xor py[8]^[14] xor py[9]^[11] xor py[10]^[8];
  cy[7]:=py[2]^[33] xor py[3]^[30] xor py[4]^[27] xor py[5]^[24] xor py[6]^[21] xor py[7]^[18] xor py[8]^[15] xor py[9]^[12] xor py[10]^[9];
  cy[8]:=py[3]^[31] xor py[4]^[28] xor py[5]^[25] xor py[6]^[22] xor py[7]^[19] xor py[8]^[16] xor py[9]^[13] xor py[10]^[10];
  cy[9]:=py[3]^[32] xor py[4]^[29] xor py[5]^[26] xor py[6]^[23] xor py[7]^[20] xor py[8]^[17] xor py[9]^[14] xor py[10]^[11];
  cy[10]:=py[3]^[33] xor py[4]^[30] xor py[5]^[27] xor py[6]^[24] xor py[7]^[21] xor py[8]^[18] xor py[9]^[15] xor py[10]^[12];
  cy[11]:=py[4]^[31] xor py[5]^[28] xor py[6]^[25] xor py[7]^[22] xor py[8]^[19] xor py[9]^[16] xor py[10]^[13];
  cy[12]:=py[4]^[32] xor py[5]^[29] xor py[6]^[26] xor py[7]^[23] xor py[8]^[20] xor py[9]^[17] xor py[10]^[14];
  cy[13]:=py[4]^[33] xor py[5]^[30] xor py[6]^[27] xor py[7]^[24] xor py[8]^[21] xor py[9]^[18] xor py[10]^[15];
  cy[14]:=py[5]^[31] xor py[6]^[28] xor py[7]^[25] xor py[8]^[22] xor py[9]^[19] xor py[10]^[16];
  cy[15]:=py[5]^[32] xor py[6]^[29] xor py[7]^[26] xor py[8]^[23] xor py[9]^[20] xor py[10]^[17];
  cy[16]:=py[5]^[33] xor py[6]^[30] xor py[7]^[27] xor py[8]^[24] xor py[9]^[21] xor py[10]^[18];
  cy[17]:=py[6]^[31] xor py[7]^[28] xor py[8]^[25] xor py[9]^[22] xor py[10]^[19];
  cy[18]:=py[6]^[32] xor py[7]^[29] xor py[8]^[26] xor py[9]^[23] xor py[10]^[20];
  cy[19]:=py[6]^[33] xor py[7]^[30] xor py[8]^[27] xor py[9]^[24] xor py[10]^[21];
  cy[20]:=py[7]^[31] xor py[8]^[28] xor py[9]^[25] xor py[10]^[22];
  cy[21]:=py[7]^[32] xor py[8]^[29] xor py[9]^[26] xor py[10]^[23];
  cy[22]:=py[7]^[33] xor py[8]^[30] xor py[9]^[27] xor py[10]^[24];
  cy[23]:=py[8]^[31] xor py[9]^[28] xor py[10]^[25];
  cy[24]:=py[8]^[32] xor py[9]^[29] xor py[10]^[26];
  cy[25]:=py[8]^[33] xor py[9]^[30] xor py[10]^[27];
  cy[26]:=py[9]^[31] xor py[10]^[28];
  cy[27]:=py[9]^[32] xor py[10]^[29];
  cy[28]:=py[9]^[33] xor py[10]^[30];
  cy[29]:=py[10]^[31];
  cy[30]:=py[10]^[32];
  cy[31]:=py[10]^[33];
  end;
for j:=0 to 31 do begin x[lim*32+j]:=cx[j]; y[lim*32+j]:=cy[j]; end;
dx:=lim*32+31; dy:=dx; Degree(x,dx); Degree(y,dy);
end;
begin
BlockStep64:=false;
if (d0<127) or (d1>d0) or (d1<d0-31) or (d1<target+32) then exit;
lo:=d0-63;
{ H95: exchange Boolean window/matrix buffer addresses, as the outer leaf does. }
a0:=@aa0; a1:=@aa1;
m00:=@mm00; m01:=@mm01; m10:=@mm10; m11:=@mm11;
for j:=0 to 63 do begin a0^[j]:=r0^[lo+j]; a1^[j]:=r1^[lo+j]; end;
m00^:=Default(TM); m01^:=Default(TM); m10^:=Default(TM); m11^:=Default(TM);
m00^[0]:=true; m11^[0]:=true;
e0:=63; e1:=d1-lo; md0:=0; md1:=0;
while e1>=32 do
  begin
  while e0>=e1 do
    begin
    sh:=e0-e1;
    for j:=0 to e1 do a0^[j+sh]:=a0^[j+sh] xor a1^[j];
    { H96: matrix coefficients above the row degree are zero. }
    for j:=0 to md1 do
      begin m00^[j+sh]:=m00^[j+sh] xor m10^[j]; m01^[j+sh]:=m01^[j+sh] xor m11^[j]; end;
    if md1+sh>md0 then md0:=md1+sh;
    dec(e0); while (e0>=0) and not a0^[e0] do dec(e0);
    end;
  at:=a0; a0:=a1; a1:=at; tmp:=e0; e0:=e1; e1:=tmp;
  mt:=m00; m00:=m10; m10:=mt; mt:=m01; m01:=m11; m11:=mt;
  tmp:=md0; md0:=md1; md1:=tmp;
  end;
tx[0]:=Default(TP); ty[0]:=tx[0];
power:=1;
for i:=0 to 5 do
  begin
  bit:=i mod 3;
  jx:=Default(TP); jy:=Default(TP);
  if i<3 then
    for j:=0 to 31 do begin jx[j+bit]:=m00^[j]; jy[j+bit]:=m10^[j]; end
  else
    for j:=0 to 31 do begin jx[j+bit]:=m01^[j]; jy[j+bit]:=m11^[j]; end;
  for index:=0 to power-1 do
    begin
    sx:=@tx[index]; sy:=@ty[index]; dx:=@tx[index+power]; dy:=@ty[index+power];
    dx^[0]:=sx^[0] xor jx[0]; dy^[0]:=sy^[0] xor jy[0];
    dx^[1]:=sx^[1] xor jx[1]; dy^[1]:=sy^[1] xor jy[1];
    dx^[2]:=sx^[2] xor jx[2]; dy^[2]:=sy^[2] xor jy[2];
    dx^[3]:=sx^[3] xor jx[3]; dy^[3]:=sy^[3] xor jy[3];
    dx^[4]:=sx^[4] xor jx[4]; dy^[4]:=sy^[4] xor jy[4];
    dx^[5]:=sx^[5] xor jx[5]; dy^[5]:=sy^[5] xor jy[5];
    dx^[6]:=sx^[6] xor jx[6]; dy^[6]:=sy^[6] xor jy[6];
    dx^[7]:=sx^[7] xor jx[7]; dy^[7]:=sy^[7] xor jy[7];
    dx^[8]:=sx^[8] xor jx[8]; dy^[8]:=sy^[8] xor jy[8];
    dx^[9]:=sx^[9] xor jx[9]; dy^[9]:=sy^[9] xor jy[9];
    dx^[10]:=sx^[10] xor jx[10]; dy^[10]:=sy^[10] xor jy[10];
    dx^[11]:=sx^[11] xor jx[11]; dy^[11]:=sy^[11] xor jy[11];
    dx^[12]:=sx^[12] xor jx[12]; dy^[12]:=sy^[12] xor jy[12];
    dx^[13]:=sx^[13] xor jx[13]; dy^[13]:=sy^[13] xor jy[13];
    dx^[14]:=sx^[14] xor jx[14]; dy^[14]:=sy^[14] xor jy[14];
    dx^[15]:=sx^[15] xor jx[15]; dy^[15]:=sy^[15] xor jy[15];
    dx^[16]:=sx^[16] xor jx[16]; dy^[16]:=sy^[16] xor jy[16];
    dx^[17]:=sx^[17] xor jx[17]; dy^[17]:=sy^[17] xor jy[17];
    dx^[18]:=sx^[18] xor jx[18]; dy^[18]:=sy^[18] xor jy[18];
    dx^[19]:=sx^[19] xor jx[19]; dy^[19]:=sy^[19] xor jy[19];
    dx^[20]:=sx^[20] xor jx[20]; dy^[20]:=sy^[20] xor jy[20];
    dx^[21]:=sx^[21] xor jx[21]; dy^[21]:=sy^[21] xor jy[21];
    dx^[22]:=sx^[22] xor jx[22]; dy^[22]:=sy^[22] xor jy[22];
    dx^[23]:=sx^[23] xor jx[23]; dy^[23]:=sy^[23] xor jy[23];
    dx^[24]:=sx^[24] xor jx[24]; dy^[24]:=sy^[24] xor jy[24];
    dx^[25]:=sx^[25] xor jx[25]; dy^[25]:=sy^[25] xor jy[25];
    dx^[26]:=sx^[26] xor jx[26]; dy^[26]:=sy^[26] xor jy[26];
    dx^[27]:=sx^[27] xor jx[27]; dy^[27]:=sy^[27] xor jy[27];
    dx^[28]:=sx^[28] xor jx[28]; dy^[28]:=sy^[28] xor jy[28];
    dx^[29]:=sx^[29] xor jx[29]; dy^[29]:=sy^[29] xor jy[29];
    dx^[30]:=sx^[30] xor jx[30]; dy^[30]:=sy^[30] xor jy[30];
    dx^[31]:=sx^[31] xor jx[31]; dy^[31]:=sy^[31] xor jy[31];
    dx^[32]:=sx^[32] xor jx[32]; dy^[32]:=sy^[32] xor jy[32];
    dx^[33]:=sx^[33] xor jx[33]; dy^[33]:=sy^[33] xor jy[33];
    end;
  power:=power shl 1;
  end;
ApplyPair32(r0^,r1^,d0,d1); ApplyPair32(u0^,u1^,du0,du1); ApplyPair32(v0^,v1^,dv0,dv1);
BlockStep64:=true;
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
  if BlockStep64 then continue;
  if BlockStep then continue;
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

{ H91: reuse bounded scratch capacity; each used polynomial is initialized. }
procedure H121GcdScratch(hi:longint);
var size:longint;
begin
size:=((hi*2+96) shr 5) shl 5;
if (Length(qPool)<size*128) or (Length(qPool)>(size*128)*4) then SetLength(qPool,size*128); qTop:=0;
if (Length(qA)<size) or (Length(qA)>(size)*4) then SetLength(qA,size); if (Length(qB)<size) or (Length(qB)>(size)*4) then SetLength(qB,size); if (Length(qC)<size) or (Length(qC)>(size)*4) then SetLength(qC,size);
if (Length(qR)<size*2) or (Length(qR)>(size*2)*4) then SetLength(qR,size*2); if (Length(qS)<size*2) or (Length(qS)>(size*2)*4) then SetLength(qS,size*2); if (Length(qWork)<size*10) or (Length(qWork)>(size*10)*4) then SetLength(qWork,size*10);
end;

function GcdU(const va,vb:TVec; var vg,vu,vv:TVec; hi:longint):longint;
var a,b,g,u,v:THPoly;
begin
H121GcdScratch(hi);
HPFromVec(va,hi,a); HPFromVec(vb,hi,b);
HPXGCD(a,b,g,u,v);
HPToVec(g,vg,hi); HPToVec(u,vu,hi); HPToVec(v,vv,hi);
GcdU:=g.d;
end;

{ H104: split-root GCD on a Cantor field. Field arithmetic, root sets,
  FWHT, additive FFT and basis conversion are identical in A and B. }
type TH104Array=array of TBW32;
var h104K,h104Count,h104Order,h104Odd:longint;
var h104Exp,h104Log,h104Point,h104Label,h104LogFW:TH104Array;
var h104Support:array[0..19,0..19] of longint;
var h104SupportCount:array[0..19] of longint;
var h104SupportCoef:array[0..19,0..19] of TBW32;
var h104Sub:array[0..5,0..5] of TBW32;
var h104Scale:array[0..4] of TBW32;

function H104Mul(a,b:TBW32):TBW32; inline;
begin
if (a=0) or (b=0) then H104Mul:=0
else if a=1 then H104Mul:=b
else if b=1 then H104Mul:=a
else H104Mul:=h104Exp[BWIndex((h104Log[BWIndex(a)]+h104Log[BWIndex(b)]) mod BW32(h104Order))];
end;

function H104Inverse(a:TBW32):TBW32; inline;
begin
if a=0 then Halt(223);
H104Inverse:=h104Exp[BWIndex((h104Order-BWIndex(h104Log[BWIndex(a)])) mod h104Order)];
end;

procedure H104FWHT(var a:TH104Array);
var h,base,j:longint; u,v:TBW32;
begin
h:=1;
while h<h104Count do
  begin
  base:=0;
  while base<h104Count do
    begin
    for j:=base to base+h-1 do
      begin
      u:=a[BWIndex(j)]; v:=a[BWIndex(j+h)];
      a[BWIndex(j)]:=(u+v) mod BW32(h104Order);
      a[BWIndex(j+h)]:=(u+BW32(h104Order)-v) mod BW32(h104Order);
      end;
    inc(base,h*2);
    end;
  h:=h*2;
  end;
end;

function H104Square(a:TBW32):TBW32; inline;
begin
if a=0 then H104Square:=0
else H104Square:=h104Exp[BWIndex((h104Log[BWIndex(a)]*2) mod BW32(h104Order))];
end;

function H104SubValue(x:TBW32; s:longint):TBW32;
var j:longint; value:TBW32;
begin
value:=0;
for j:=0 to s do
  begin
  value:=value xor H104Mul(h104Sub[BWIndex(s),BWIndex(j)],x);
  x:=H104Square(x);
  end;
H104SubValue:=value;
end;

procedure H104Prepare(k:longint);
var root,beta,chain,theta:TH104Array;
var count,order,p,j,bit,x,t,c,blocks,a,b,e,l,cs:longint;
var d,poly,fieldX:TBW32;
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
FillChar(h104Log[BWIndex(0)],count*SizeOf(TBW32),1);
fieldX:=1;
for j:=0 to order-1 do
  begin
  if h104Log[BWIndex(fieldX)]<>$FFFFFFFF then Halt(224);
  h104Exp[BWIndex(j)]:=fieldX; h104Log[BWIndex(fieldX)]:=j;
  fieldX:=fieldX shl 1; if (fieldX and count)<>0 then fieldX:=fieldX xor poly;
  end;
if fieldX<>1 then Halt(224);
{ k=c*2^r, c in 1,3,5. L=x^(2^c)+x gives a Cantor chain
  over the constant-size subfield GF(2^c), including degrees 10/20. }
c:=k; blocks:=1;
while (c and 1)=0 do begin c:=c div 2; blocks:=blocks*2; end;
h104Odd:=c;
SetLength(root,count); FillChar(root[BWIndex(0)],count*SizeOf(TBW32),1);
for x:=0 to count-1 do
  begin
  d:=x; for j:=1 to c do d:=H104Square(d);
  root[BWIndex(d xor BW32(x))]:=x;
  end;
SetLength(chain,blocks); chain[BWIndex(0)]:=1;
for j:=1 to blocks-1 do
  begin
  if root[BWIndex(chain[BWIndex(j-1)])]=$FFFFFFFF then Halt(224);
  chain[BWIndex(j)]:=root[BWIndex(chain[BWIndex(j-1)])];
  end;
SetLength(theta,c);
for j:=0 to c-1 do theta[BWIndex(j)]:=h104Exp[BWIndex((order div ((1 shl c)-1)*j) mod order)];
FillChar(h104Sub,SizeOf(h104Sub),0); h104Sub[BWIndex(0),BWIndex(0)]:=1;
for j:=0 to c-1 do
  begin
  d:=H104SubValue(theta[BWIndex(j)],j); h104Scale[BWIndex(j)]:=H104Inverse(d);
  for l:=0 to j+1 do
    begin
    if l>0 then h104Sub[BWIndex(j+1),BWIndex(l)]:=H104Square(h104Sub[BWIndex(j),BWIndex(l-1)]);
    if l<=j then h104Sub[BWIndex(j+1),BWIndex(l)]:=h104Sub[BWIndex(j+1),BWIndex(l)] xor H104Mul(d,h104Sub[BWIndex(j),BWIndex(l)]);
    end;
  end;
SetLength(beta,k);
for j:=0 to blocks-1 do
  for l:=0 to c-1 do beta[BWIndex(c*j+l)]:=H104Mul(chain[BWIndex(j)],theta[BWIndex(l)]);
for p:=0 to k-1 do
  begin
  a:=p div c; b:=p mod c; h104SupportCount[BWIndex(p)]:=0;
  for j:=0 to a do if (j and a)=j then
    for l:=0 to b do if h104Sub[BWIndex(b),BWIndex(l)]<>0 then
      begin
      e:=c*j+l;
      if e<p then
        begin
        cs:=h104SupportCount[BWIndex(p)]; h104Support[BWIndex(p),BWIndex(cs)]:=1 shl e;
        h104SupportCoef[BWIndex(p),BWIndex(cs)]:=h104Sub[BWIndex(b),BWIndex(l)]; inc(h104SupportCount[BWIndex(p)]);
        end;
      end;
  end;
SetLength(h104Point,count); SetLength(h104Label,count);
FillChar(h104Label[BWIndex(0)],count*SizeOf(TBW32),1);
h104Point[BWIndex(0)]:=0; h104Label[BWIndex(0)]:=0;
for j:=1 to count-1 do
  begin
  bit:=j and (-j); p:=0; t:=bit;
  while t>1 do begin t:=t shr 1; inc(p); end;
  fieldX:=h104Point[BWIndex(j xor bit)] xor beta[BWIndex(p)];
  if h104Label[BWIndex(fieldX)]<>$FFFFFFFF then Halt(224);
  h104Point[BWIndex(j)]:=fieldX; h104Label[BWIndex(fieldX)]:=j;
  end;
SetLength(h104LogFW,count);
for j:=0 to count-1 do
  if h104Point[BWIndex(j)]=0 then h104LogFW[BWIndex(j)]:=0 else h104LogFW[BWIndex(j)]:=h104Log[BWIndex(h104Point[BWIndex(j)])];
H104FWHT(h104LogFW);
end;

{ Enable only to study the additional O(nn log nn) D-family path.
  Default false avoids the measured large ambient-field overhead. }
var h110PlusRoots:boolean=false;

{ C_s(z+1/z)=z^s+z^(-s), C_0=0, C_1=x in characteristic two.
  C_(2s)=C_s^2 and C_(2s+1)=C_s*C_(s+1)+x. }
function H110Dickson(x:TBW32; index:longint):TBW32;
var a,b,t:TBW32; mask:longint;
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
var alpha,beta,a,b,t:TBW32;
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
  if (b=0) or (roots[BWIndex(b)]<>0) then exit;
  roots[BWIndex(b)]:=1; inc(used);
  t:=H104Mul(beta,b) xor a; a:=b; b:=t;
  end;
if (used<>period div 2) or (a<>b) then exit;
H110TorusRoots:=true;
end;

function H104FieldFor(nn:TBW32):longint;
const degrees:array[0..9] of longint=(2,3,4,5,6,8,10,12,16,20);
var k,count,period,j:longint;
begin
H104FieldFor:=0;
if (nn<2) or ((nn and 1)<>0) or (nn>1048576) then exit;
period:=BWIndex(nn)+1;
for j:=0 to High(degrees) do
  begin
  k:=degrees[BWIndex(j)]; count:=1 shl k;
  if (BWIndex(nn)=count) or
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
Move(mask[BWIndex(0)],values[BWIndex(0)],h104Count*SizeOf(TBW32));
H104FWHT(values);
for p:=0 to h104Count-1 do
  values[BWIndex(p)]:=BW32((BW64(values[BWIndex(p)])*h104LogFW[BWIndex(p)]) mod BW32(h104Order));
H104FWHT(values);
for p:=0 to h104Count-1 do values[BWIndex(p)]:=h104Exp[BWIndex(values[BWIndex(p)])];
end;

procedure H104IFFT(var a:TH104Array);
var i,h,base,j:longint; c,lo,hi:TBW32;
begin
for i:=0 to h104K-1 do
  begin
  h:=1 shl i; base:=0;
  while base<h104Count do
    begin
    c:=H104SubValue(h104Point[BWIndex(base shr (i div h104Odd*h104Odd))],i mod h104Odd);
    for j:=base to base+h-1 do
      begin
      hi:=H104Mul(a[BWIndex(j)] xor a[BWIndex(j+h)],h104Scale[BWIndex(i mod h104Odd)]);
      lo:=a[BWIndex(j)] xor H104Mul(c,hi);
      a[BWIndex(j)]:=lo; a[BWIndex(j+h)]:=hi;
      end;
    inc(base,h*2);
    end;
  end;
end;

{ H105: the small GF(2^c) basis has constant c in 1,3,5.
  A strided view avoids an extra transpose buffer. }
procedure H105Small(var a:TH104Array; base,stride,i:longint);
var h,p,j,src,dst:longint; value:TBW32;
begin
if i<0 then exit;
h:=1 shl i;
H105Small(a,base,stride,i-1); H105Small(a,base+h*stride,stride,i-1);
for p:=h to h*2-1 do
  begin
  src:=base+p*stride; value:=a[BWIndex(src)];
  if value<>0 then
    for j:=0 to h104SupportCount[BWIndex(i)]-1 do
      begin
      dst:=base+(p-h+h104Support[BWIndex(i),BWIndex(j)])*stride;
      a[BWIndex(dst)]:=a[BWIndex(dst)] xor H104Mul(value,h104SupportCoef[BWIndex(i),BWIndex(j)]);
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
  a[BWIndex(dst)]:=a[BWIndex(dst)] xor a[BWIndex(src)]; inc(dst,stride); inc(src,stride);
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
  One TBW32 holds 32 adjacent coefficients of a plane. The old
  sparse triangular map is evaluated with TBW16 masks and XOR shifts.
  All source planes for a chunk are saved before any destination write. }
function H106Monomial(var a:TH104Array):boolean;
type TPlanes=array[0..4] of TH104Array;
var plane:TPlanes;
var columns:array[0..19,0..4] of TBW32;
var u:array[0..4] of TBW32;
var i,j,p,t,l,h,words,base,q,src,dst,delta,shift:longint;
var labelValue,mask,value:TBW32;
begin
H106Monomial:=false;
{ The inverse triangular basis map is defined over GF(2^c).
  Check membership before changing a; retain H105 for other inputs. }
for p:=0 to h104Count-1 do
  if h104Label[BWIndex(a[BWIndex(p)])]>=BW32(1 shl h104Odd) then exit;
words:=(h104Count+31) shr 5;
for t:=0 to h104Odd-1 do SetLength(plane[BWIndex(t)],words);
for p:=0 to h104Count-1 do
  begin
  labelValue:=h104Label[BWIndex(a[BWIndex(p)])];
  for t:=0 to h104Odd-1 do
    if (labelValue and (BW32(1) shl t))<>0 then
      plane[BWIndex(t)][BWIndex(p shr 5)]:=plane[BWIndex(t)][BWIndex(p shr 5)] or (BW32(1) shl (p and 31));
  end;
for i:=0 to h104K-1 do
  begin
  h:=1 shl i;
  { Matrix columns for multiplication by each small-subfield constant. }
  for j:=0 to h104SupportCount[BWIndex(i)]-1 do
    for l:=0 to h104Odd-1 do
      columns[BWIndex(j),BWIndex(l)]:=h104Label[BWIndex(H104Mul(h104Point[BWIndex(1 shl l)],h104SupportCoef[BWIndex(i),BWIndex(j)]))];
  if h<32 then
    begin
    mask:=0;
    for p:=0 to 31 do if (p and h)<>0 then mask:=mask or (BW32(1) shl p);
    for q:=0 to words-1 do
      begin
      for l:=0 to h104Odd-1 do u[BWIndex(l)]:=plane[BWIndex(l)][BWIndex(q)] and mask;
      for j:=0 to h104SupportCount[BWIndex(i)]-1 do
        begin
        shift:=h-h104Support[BWIndex(i),BWIndex(j)];
        for t:=0 to h104Odd-1 do
          begin
          value:=0;
          for l:=0 to h104Odd-1 do
            if (columns[BWIndex(j),BWIndex(l)] and (BW32(1) shl t))<>0 then value:=value xor u[BWIndex(l)];
          plane[BWIndex(t)][BWIndex(q)]:=plane[BWIndex(t)][BWIndex(q)] xor (value shr shift);
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
        for l:=0 to h104Odd-1 do u[BWIndex(l)]:=plane[BWIndex(l)][BWIndex(src)];
        for j:=0 to h104SupportCount[BWIndex(i)]-1 do
          begin
          delta:=h104Support[BWIndex(i),BWIndex(j)]; dst:=((base+delta) shr 5)+q; shift:=delta and 31;
          for t:=0 to h104Odd-1 do
            begin
            value:=0;
            for l:=0 to h104Odd-1 do
              if (columns[BWIndex(j),BWIndex(l)] and (BW32(1) shl t))<>0 then value:=value xor u[BWIndex(l)];
            if shift=0 then plane[BWIndex(t)][BWIndex(dst)]:=plane[BWIndex(t)][BWIndex(dst)] xor value
            else
              begin
              plane[BWIndex(t)][BWIndex(dst)]:=plane[BWIndex(t)][BWIndex(dst)] xor (value shl shift);
              plane[BWIndex(t)][BWIndex(dst+1)]:=plane[BWIndex(t)][BWIndex(dst+1)] xor (value shr (32-shift));
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
    if ((plane[BWIndex(t)][BWIndex(p shr 5)] shr (p and 31)) and 1)<>0 then
      labelValue:=labelValue or (BW32(1) shl t);
  a[BWIndex(p)]:=h104Point[BWIndex(labelValue)];
  end;
H106Monomial:=true;
end;

procedure H104Interpolate(var a:TH104Array);
var p:longint;
begin
H104IFFT(a); if not H106Monomial(a) then H105Monomial(a,0,1,h104K);
for p:=0 to h104Count-1 do if a[BWIndex(p)]>1 then Halt(225);
end;

{ Invert P(x)=A(x^2+x)+x*B(x^2+x). After the binary divisions,
  even slots contain A and odd slots B. All coefficients remain binary. }
procedure H104Decompose(var a:TH104Array; base,count:longint);
var h,p:longint;
begin
if count<=2 then exit;
h:=count div 4;
for p:=base+count-1 downto base+count div 2 do a[BWIndex(p-h)]:=a[BWIndex(p-h)] xor a[BWIndex(p)];
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
    for j:=base to base+h-1 do a[BWIndex(j)]:=a[BWIndex(j)] xor a[BWIndex(j+h)];
    inc(base,h*2);
    end;
  h:=h*2;
  end;
end;

procedure H104FromField(const a:TH104Array; out b:THPoly);
var p:longint;
begin
HPAlloc(b,h104Count);
for p:=0 to h104Count-1 do
  begin
  if a[BWIndex(p)]>1 then Halt(225);
  b.v^[BWIndex(p)]:=a[BWIndex(p)]<>0;
  end;
b.d:=h104Count-1; HPNorm(b);
end;

procedure H104ToField(const a:THPoly; var b:TH104Array);
var p:longint;
begin
SetLength(b,h104Count); FillChar(b[BWIndex(0)],h104Count*SizeOf(TBW32),0);
for p:=0 to a.d do b[BWIndex(p)]:=ord(a.v^[BWIndex(p)]);
end;

procedure H104Project(var a:TH104Array; out b:THPoly; invariant:boolean);
var p:longint;
begin
H104Decompose(a,0,h104Count);
HPAlloc(b,h104Count div 2);
for p:=0 to h104Count div 2-1 do
  begin
  if invariant and (a[BWIndex(p*2+1)]<>0) then Halt(226);
  b.v^[BWIndex(p)]:=a[BWIndex(p*2)]<>0;
  end;
b.d:=h104Count div 2-1; HPNorm(b);
end;

function H104Equal(const a,b:THPoly):boolean;
var p:longint;
begin
H104Equal:=false;
if a.d<>b.d then exit;
if a.d<0 then begin H104Equal:=true; exit; end;
for p:=0 to a.d do if a.v^[BWIndex(p)]<>b.v^[BWIndex(p)] then exit;
H104Equal:=true;
end;

{ For m=nn+1 odd, put m'=2^(k+1)-m and t=abs(m-2^k).
  Let P_m=U_((m-1)/2)+U_((m-3)/2)=a+T*b in u=T^2+T,
  and P_m'=e+T*f. For the Dickson polynomials D, the identity
  T*P_m*P_m'=T^(2^k)+D_t(T) and its translate give
  a*(e+f)+b*(e+f+u*f)=1+D_t(T)+D_t(T+1).
  The right side has u-degree (t-1)/2 for odd t>1. }
type TH121Fib=record a,b:THPoly; end;

procedure H121TimesU(const a:THPoly; out b:THPoly);
begin
if a.d<0 then begin HPZero(b); exit; end;
HPAlloc(b,a.d+2); Move(a.v^[0],b.v^[1],(a.d+1)*SizeOf(boolean));
b.d:=a.d+1;
end;

procedure H121SquareFib(const p:TH121Fib; out q:TH121Fib);
var a,b:THPoly;
begin
HPSquareTrunc(p.a,a,2*p.a.d+1);
HPSquareTrunc(p.b,q.b,2*p.b.d+1);
H121TimesU(q.b,b); HPAdd(a,b,q.a);
end;

procedure H121TimesT(const p:TH121Fib; out q:TH121Fib);
begin
H121TimesU(p.b,q.a); HPAdd(p.a,p.b,q.b);
end;

{ U_k and U_(k-1), in the basis 1,T over GF(2)[u]. }
procedure H121FibPair(k:longint; out p,q:TH121Fib);
var a,b,s,t,e:TH121Fib;
begin
if k=0 then
  begin HPOne(p.a); HPZero(p.b); HPZero(q.a); HPZero(q.b); exit; end;
H121FibPair(k div 2,a,b);
H121SquareFib(a,s); H121SquareFib(b,t);
HPAdd(s.a,t.a,e.a); HPAdd(s.b,t.b,e.b);
if odd(k) then begin H121TimesT(s,p); q:=e; end
else begin p:=e; H121TimesT(t,q); end;
end;

function H121ExactQuotient(const a,b:THPoly; out q:THPoly):boolean;
var rem:THPoly;
begin
if b.d=0 then begin q:=a; H121ExactQuotient:=true; exit; end;
HPDivRemClassic(a,b,q,rem);
H121ExactQuotient:=rem.d<0;
end;

{ One side has degree O(t). Use the fixed-size carryless leaves here
  so even a long unbalanced product costs O(nn*(1+t)). }
procedure H121ShortProduct(const a,b:THPoly; out c:THPoly);
begin
if (a.d<0) or (b.d<0) then begin HPZero(c); exit; end;
if a.d=0 then begin c:=b; exit; end;
if b.d=0 then begin c:=a; exit; end;
if a.d>b.d then begin H121ShortProduct(b,a,c); exit; end;
HPAlloc(c,a.d+b.d+1);
MulBaseBool(a.v^,0,a.d+1,b.v^,0,b.d+1,c.v^,0,c.cap,false);
c.d:=a.d+b.d;
end;

{ First remove the common factor using only residues modulo cert.
  For A=a/g, B=b/g, C=cert/g, find s*A+t*B=1 (mod C).
  Then h=s*v0+t*u0 (mod C) makes both quotients below exact:
      U=(u0+B*h)/C, V=(v0+A*h)/C. }
function H121LiftBezout(const a,b,cert,u0,v0:THPoly; out g,u,v:THPoly):boolean;
var ra,rb,d,s,t,e,ei,q,r,ap,bp,cp,h,left,right,tmp:THPoly;
begin
H121LiftBezout:=false;
if b.d<0 then begin g:=a; HPOne(u); HPZero(v); H121LiftBezout:=true; exit; end;
if a.d<0 then begin g:=b; HPZero(u); HPOne(v); H121LiftBezout:=true; exit; end;
HPDivRemClassic(a,cert,q,ra); HPDivRemClassic(b,cert,q,rb);
HPXGCD(ra,rb,d,s,t);
HPXGCD(d,cert,g,s,t);
if not H121ExactQuotient(a,g,ap) then exit;
if not H121ExactQuotient(b,g,bp) then exit;
if not H121ExactQuotient(cert,g,cp) then exit;
HPZero(h);
if cp.d>0 then
  begin
  HPDivRemClassic(ap,cp,q,ra); HPDivRemClassic(bp,cp,q,rb);
  HPXGCD(ra,rb,d,s,t);
  HPXGCD(d,cp,e,ei,tmp);
  if e.d<>0 then exit;
  HPDivRemClassic(v0,cp,q,ra); HPDivRemClassic(u0,cp,q,rb);
  HPMul(s,ra,left); HPMul(t,rb,right); HPAdd(left,right,tmp);
  HPDivRemClassic(tmp,cp,q,r);
  HPMul(ei,r,tmp); HPDivRemClassic(tmp,cp,q,h);
  end;
H121ShortProduct(bp,h,left); HPAdd(u0,left,tmp);
if not H121ExactQuotient(tmp,cp,u) then exit;
H121ShortProduct(ap,h,right); HPAdd(v0,right,tmp);
if not H121ExactQuotient(tmp,cp,v) then exit;
{ Match the degree bounds and the equal-input tie of HPXGCD. }
if (ap.d=0) and (bp.d=0) then begin HPZero(u); HPOne(v); end
else if ap.d>=bp.d then
  begin
  HPDivRemClassic(v,ap,q,r); v:=r;
  H121ShortProduct(bp,q,left); HPAdd(u,left,tmp); u:=tmp;
  end
else
  begin
  HPDivRemClassic(u,bp,q,r); u:=r;
  H121ShortProduct(ap,q,right); HPAdd(v,right,tmp); v:=tmp;
  end;
H121LiftBezout:=true;
end;

{ If t^2<=16*k the long products and divisions have a short side:
  O(nn*(1+t)) coefficient operations, including canonical Bezout. }
function H121NearPower(const va,vb:TVec; var vg,vu,vv:TVec; hi,nn:longint;
                       out degree:longint):boolean;
var period,power,distance,mirror,level:longint;
var p,q,trace:TH121Fib;
var cert,g,u,v,u0,v0,a,b,f,one,shifted:THPoly;
begin
H121NearPower:=false;
if (nn<1024) or odd(nn) or (nn>=High(longint) div 2) then exit;
period:=nn+1; power:=1; level:=0;
while power<=period div 2 do begin power:=power shl 1; inc(level); end;
if period-power>2*power-period then begin power:=power shl 1; inc(level); end;
distance:=abs(period-power);
if (distance<3) or (int64(distance)*distance>16*level) then exit;
mirror:=longint(2*int64(power)-period);
H121GcdScratch(hi);
H121FibPair(distance-1,p,q); H121TimesT(p,trace);
HPOne(one); HPAdd(one,trace.b,cert);
if cert.d<0 then exit;
H121FibPair((mirror-1) div 2,p,q);
HPAdd(p.a,q.a,f); HPAdd(p.b,q.b,b);
HPAdd(f,b,u0); H121TimesU(b,shifted); HPAdd(u0,shifted,v0);
HPFromVec(va,hi,a); HPFromVec(vb,hi,b);
if not H121LiftBezout(a,b,cert,u0,v0,g,u,v) then exit;
if (g.d>hi) or (u.d>hi) or (v.d>hi) then exit;
HPToVec(g,vg,hi); HPToVec(u,vu,hi); HPToVec(v,vv,hi);
degree:=g.d; H121NearPower:=true;
end;

{ Only call this wrapper on D-family inputs constructed from an EVEN
  Fibonacci index nn. Arbitrary polynomial pairs still use GcdU. }
function GcdD(const va,vb:TVec; var vg,vu,vv:TVec; hi:longint; nn:TBW32):longint;
var k,p,j,step,period,m2,size,savedForce,savedBackend:longint;
var rootMask,ma,mb,mg,ra,rb,gv,av,bd,cv,hv,da,db,uf,vf,ss,tt:TH104Array;
var a,b,gx,hp,cp,ux,vx,dp,bp,prod,num,rem,gu,su,sv,ag,bg,quot,ur,vr,t0,t1:THPoly;
var fieldValue,traceValue:TBW32;
begin
if not h114FixedComparison and H121NearPower(va,vb,vg,vu,vv,hi,BWIndex(nn),p) then
  begin GcdD:=p; exit; end;
if h114FixedComparison or (h102Backend=7) then begin GcdD:=GcdU(va,vb,vg,vu,vv,hi); exit; end;
k:=H104FieldFor(nn);
if (k=0) or (PolyDeg(vb,hi)<0) then
  begin GcdD:=GcdU(va,vb,vg,vu,vv,hi); exit; end;
H104Prepare(k);
period:=BWIndex(nn)+1; m2:=BWIndex(nn) div 2; step:=h104Order div period;
SetLength(rootMask,h104Count);
if BWIndex(nn)=h104Count then
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
    rootMask[BWIndex(p)]:=traceValue;
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
    p:=j*step; fieldValue:=h104Exp[BWIndex(p)] xor h104Exp[BWIndex(h104Order-p)];
    rootMask[BWIndex(fieldValue)]:=1;
    end;
SetLength(ma,h104Count); SetLength(mb,h104Count); SetLength(mg,h104Count);
SetLength(ra,h104Count); SetLength(rb,h104Count);
for p:=0 to h104Count-1 do
  begin
  ma[BWIndex(p)]:=rootMask[BWIndex(h104Point[BWIndex(p)])]; mb[BWIndex(p)]:=rootMask[BWIndex(h104Point[BWIndex(p)] xor 1)];
  mg[BWIndex(p)]:=ma[BWIndex(p)] and mb[BWIndex(p)]; ra[BWIndex(p)]:=ma[BWIndex(p)] and (1 xor mb[BWIndex(p)]);
  rb[BWIndex(p)]:=mb[BWIndex(p)] and (1 xor ma[BWIndex(p)]);
  end;
H104RootValues(mg,gv);
for p:=0 to h104Count-1 do if mg[BWIndex(p)]<>0 then gv[BWIndex(p)]:=0;
H104Interpolate(gv);
H104RootValues(ra,av); H104RootValues(rb,bd);
SetLength(cv,h104Count); SetLength(hv,h104Count);
for p:=0 to h104Count-1 do if rb[BWIndex(p)]<>0 then
  begin
  cv[BWIndex(p)]:=H104Inverse(bd[BWIndex(p)]); hv[BWIndex(p)]:=H104Mul(cv[BWIndex(p)],H104Inverse(av[BWIndex(p)]));
  end;
H104Interpolate(cv); H104Interpolate(hv);
SetLength(da,h104Count); SetLength(db,h104Count);
for p:=0 to m2 do
  if ((m2-p) and (p shl 1))=0 then da[BWIndex(p)]:=1;
Move(da[BWIndex(0)],db[BWIndex(0)],h104Count*SizeOf(TBW32)); H104Translate(db);
{ Exact GF(2) products keep the selected backend here. Only the NTT
  range switches to its local NTT mode for this calculation. }
savedForce:=h102Force; savedBackend:=h102Backend;
if h102Backend=4 then begin h102Force:=3; h102Backend:=3; end;
size:=h104Count;
if Length(qPool)<size*128 then SetLength(qPool,size*128);
if Length(qA)<size then SetLength(qA,size); if Length(qB)<size then SetLength(qB,size);
if Length(qC)<size then SetLength(qC,size);
if Length(qR)<size*2 then SetLength(qR,size*2); if Length(qS)<size*2 then SetLength(qS,size*2);
if Length(qWork)<size*10 then SetLength(qWork,size*10);
qTop:=0;
HPFromVec(va,hi,a); HPFromVec(vb,hi,b);
H104FromField(gv,gx); H104FromField(hv,hp); H104FromField(cv,cp);
HPDivRem(hp,cp,ux,rem); if rem.d>=0 then Halt(227);
H104FromField(da,dp); H104FromField(db,bp);
HPMul(ux,dp,prod); HPAdd(gx,prod,num);
HPDivRem(num,bp,vx,rem); if rem.d>=0 then Halt(227);
H104ToField(ux,uf); H104ToField(vx,vf);
SetLength(ss,h104Count); SetLength(tt,h104Count);
for p:=0 to h104Count-1 do ss[BWIndex(p)]:=uf[BWIndex(p)] xor vf[BWIndex(p)];
tt[BWIndex(0)]:=vf[BWIndex(0)];
for p:=1 to h104Count-1 do tt[BWIndex(p)]:=ss[BWIndex(p-1)] xor vf[BWIndex(p)];
H104Project(gv,gu,true); H104Project(ss,su,false); H104Project(tt,sv,false);
HPDivRem(a,gu,ag,rem); if rem.d>=0 then Halt(227);
HPDivRem(b,gu,bg,rem); if rem.d>=0 then Halt(227);
{ Canonical u modulo b/g makes the result identical to extended Euclid,
  rather than merely returning some valid Bezout pair. }
HPDivRem(su,bg,quot,ur); HPMul(quot,ag,t0); HPAdd(sv,t0,vr);
HPMul(ur,a,t0); HPMul(vr,b,t1); HPAdd(t0,t1,num);
if not H104Equal(num,gu) then Halt(228);
HPToVec(gu,vg,hi); HPToVec(ur,vu,hi); HPToVec(vr,vv,hi);
GcdD:=gu.d;
qTop:=0; h102Force:=savedForce; h102Backend:=savedBackend;
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




{ H97: form H*a(H^2+H)+b(H^2+H), or a(H^2+H)+(H+1)*b(H^2+H),
  in one buffer. Dyadic U powers need only two ordinary-H shifts. }
procedure ConvertH(var a:TDynBool; first,count:longint; inverse:boolean); forward;
procedure ExpandUComboH(const va,vb:TVec; first,count,degmax,mode:longint;
                        var r:TDynBool; dst0:longint);
var h,g,p,step,base:longint; a,b:TMul64Bool;
begin
if count=32 then
  begin
  for p:=0 to 31 do
    begin
    if first+p<=degmax then begin a[p*2]:=va[first+p]; b[p*2]:=vb[first+p]; end
    else begin a[p*2]:=false; b[p*2]:=false; end;
    a[p*2+1]:=false; b[p*2+1]:=false;
    end;
  step:=1;
  while step<32 do
    begin
    base:=0;
    while base<64 do
      begin
      for p:=0 to step*2-1 do
        begin
        a[base+step+p]:=a[base+step+p] xor a[base+step*2+p];
        b[base+step+p]:=b[base+step+p] xor b[base+step*2+p];
        end;
      inc(base,step*4);
      end;
    step:=step shl 1;
    end;
  if mode=0 then
    begin
    r[dst0]:=b[0];
    for p:=1 to 63 do r[dst0+p]:=a[p-1] xor b[p];
    end
  else
    begin
    r[dst0]:=a[0] xor b[0];
    for p:=1 to 63 do r[dst0+p]:=a[p] xor b[p] xor b[p-1];
    end;
  exit;
  end;
h:=32; while (h shl 1)<count do h:=h shl 1;
g:=count-h;
ExpandUComboH(va,vb,first,h,degmax,mode,r,dst0);
ExpandUComboH(va,vb,first+h,g,degmax,mode,r,dst0+h*2);
for p:=0 to g*2-1 do r[dst0+h+p]:=r[dst0+h+p] xor r[dst0+h*2+p];
end;
procedure BuildUComboHalfKernel(const va,vb:TVec; degmax,mode:longint;
                                var r:TDynBool);
var count:longint;
begin
count:=((degmax+32) div 32)*32; if count<32 then count:=32;
SetLength(r,count*2);
ExpandUComboH(va,vb,0,count,degmax,mode,r,0);
ConvertH(r,0,count*2,false);
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



{ For an all-one source the four prefix windows cancel to two kernel bits. }
procedure ApplyUComboOnes(const va,vb:TVec; var vdst:TVec; hi,degmax,mode:longint);
var halfLen,period,convWords,convBits,i0:longint;
var combo,ha:TDynBool;
var bit0:boolean;
begin
halfLen:=hi+2;
period:=halfLen shl 1;
convWords:=(halfLen+32) shr 5;
convBits:=convWords shl 5;
BuildUComboHalfKernel(va,vb,degmax,mode,combo);
if (mode=0) and (degmax=(hi+1) div 2) then
  begin
  bit0:=combo[0];
  for i0:=0 to hi div 2 do
    begin vdst[i0]:=combo[i0+1] xor combo[hi-i0+1] xor bit0; vdst[hi-i0]:=vdst[i0]; end;
  vdst[-2]:=false; vdst[-1]:=false; vdst[hi+1]:=false; exit;
  end;
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

{ H95: share the current solve's summed kernel between mak and z. }
var currentSumKernel:TDynBool; currentSumDegree:longint=-1;
procedure ApplyFibonacciOnes(var dst:TVec; degree:longint);
var kernel:TDynBool;
var p,bits:longint; bit0:boolean;
begin
bits:=((degree+33) shr 5) shl 5;
BuildFibonacciHalfKernel(degree,kernel,bits,true);
currentSumKernel:=kernel; currentSumDegree:=degree;
bit0:=kernel[0];
for p:=0 to degree-1 do dst[p]:=kernel[p+1] xor kernel[degree-p] xor bit0;
dst[-2]:=false; dst[-1]:=false; dst[degree]:=false;
end;

{ H87: J=I+H, F_(-1)=0, F_0=1, S_d=sum(F_i,0<=i<d).
  Apply F_d(J) or S_d(J) by binary doubling on the reflected cycle.
  F_(2k)=F_k^2+F_(k-1)^2; F_(2k+1)=J*F_k^2.
  For cyclic shift R, J^(2^j)=I+R^(2^j)+R^(-2^j).
  Store one reflected half; the unfolded-cycle endpoints stay zero. }
{ H89: the same Fibonacci shifts; B reads interior word pairs directly,
  retaining reflected-cycle reads only for boundary words. }
procedure ApplyFibonacciFast(const src:TVec; var dst:TVec; hi,degree:longint; summed:boolean=false; knownSymmetric:boolean=false);
type TB=array[0..31] of boolean;
var a,b,t,tmp,ss,ts:TDynBool;
var half,period,mask,shift,p,j,base,take,outHi:longint;
var folded:boolean; var recover,seed,carry0,carry1:boolean; block:TB;
function FirstSum:boolean;
var kernel:TDynBool; p:longint; seed:boolean;
begin
seed:=false;
if (currentSumDegree=degree) and (Length(currentSumKernel)>=hi+3) then kernel:=currentSumKernel
else BuildFibonacciHalfKernel(degree,kernel,((hi+35) shr 5) shl 5,true);
for p:=0 to hi do seed:=seed xor (src[p] and (kernel[p] xor kernel[p+2]));
FirstSum:=seed;
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
if not knownSymmetric then for p:=0 to hi div 2 do
  if src[p]<>src[hi-p] then begin folded:=false; break; end;
half:=hi+2; period:=half*2;
if folded then begin period:=half; half:=period div 2; end;
SetLength(a,half+1); SetLength(b,half+1); SetLength(t,half+1);
if summed then begin SetLength(ss,half+1); SetLength(ts,half+1); end;
for p:=1 to half do if p<=hi+1 then a[p]:=src[p-1];
mask:=1; while mask<=degree div 2 do mask:=mask shl 1;
{ H92: split reflected/interior ranges once per shift, as in B. }
while mask>0 do
  begin
  shift:=mask mod period; if shift>half then shift:=period-shift;
  if summed then
    begin
    { S_(2k)=J*S_k^2+F_(k-1)^2; S_(2k+1)=J*S_k^2+F_k^2. }
    if (degree and mask)<>0 then
    begin
    if shift<=half div 2 then
      begin
    for p:=0 to shift-1 do
      begin ts[p]:=ss[p] xor ss[shift-p] xor ss[p+shift] xor a[p]; end;
    for p:=shift to half-shift do
      begin ts[p]:=ss[p] xor ss[p-shift] xor ss[p+shift] xor a[p]; end;
    for p:=half-shift+1 to half do
      begin ts[p]:=ss[p] xor ss[p-shift] xor ss[period-p-shift] xor a[p]; end;
      end
    else
      begin
    for p:=0 to half-shift do
      begin ts[p]:=ss[p] xor ss[shift-p] xor ss[p+shift] xor a[p]; end;
    for p:=half-shift+1 to shift-1 do
      begin ts[p]:=ss[p] xor ss[shift-p] xor ss[period-p-shift] xor a[p]; end;
    for p:=shift to half do
      begin ts[p]:=ss[p] xor ss[p-shift] xor ss[period-p-shift] xor a[p]; end;
      end;
    end
    else
    begin
    if shift<=half div 2 then
      begin
    for p:=0 to shift-1 do
      begin ts[p]:=ss[p] xor ss[shift-p] xor ss[p+shift] xor b[p]; end;
    for p:=shift to half-shift do
      begin ts[p]:=ss[p] xor ss[p-shift] xor ss[p+shift] xor b[p]; end;
    for p:=half-shift+1 to half do
      begin ts[p]:=ss[p] xor ss[p-shift] xor ss[period-p-shift] xor b[p]; end;
      end
    else
      begin
    for p:=0 to half-shift do
      begin ts[p]:=ss[p] xor ss[shift-p] xor ss[p+shift] xor b[p]; end;
    for p:=half-shift+1 to shift-1 do
      begin ts[p]:=ss[p] xor ss[shift-p] xor ss[period-p-shift] xor b[p]; end;
    for p:=shift to half do
      begin ts[p]:=ss[p] xor ss[p-shift] xor ss[period-p-shift] xor b[p]; end;
      end;
    end;
    tmp:=ss; ss:=ts; ts:=tmp;
    if mask=1 then break;
    end;
  { H95: the final bit needs only F_d, or F_d+F_(d-1) for recovery. }
  if mask=1 then
    begin
    if recover then
      begin
      if (degree and 1)=0 then begin tmp:=a; a:=b; b:=tmp; end;
    if shift<=half div 2 then
      begin
      for p:=0 to shift-1 do t[p]:=a[shift-p] xor a[p+shift] xor b[p];
      for p:=shift to half-shift do t[p]:=a[p-shift] xor a[p+shift] xor b[p];
      for p:=half-shift+1 to half do t[p]:=a[p-shift] xor a[period-p-shift] xor b[p];
      end
    else
      begin
      for p:=0 to half-shift do t[p]:=a[shift-p] xor a[p+shift] xor b[p];
      for p:=half-shift+1 to shift-1 do t[p]:=a[shift-p] xor a[period-p-shift] xor b[p];
      for p:=shift to half do t[p]:=a[p-shift] xor a[period-p-shift] xor b[p];
      end;
      tmp:=a; a:=t; t:=tmp;
      end
    else if (degree and 1)=0 then
      begin for p:=0 to half do a[p]:=a[p] xor b[p]; end
    else
      begin
    if shift<=half div 2 then
      begin
      for p:=0 to shift-1 do t[p]:=a[shift-p] xor a[p+shift] xor a[p];
      for p:=shift to half-shift do t[p]:=a[p-shift] xor a[p+shift] xor a[p];
      for p:=half-shift+1 to half do t[p]:=a[p-shift] xor a[period-p-shift] xor a[p];
      end
    else
      begin
      for p:=0 to half-shift do t[p]:=a[shift-p] xor a[p+shift] xor a[p];
      for p:=half-shift+1 to shift-1 do t[p]:=a[shift-p] xor a[period-p-shift] xor a[p];
      for p:=shift to half do t[p]:=a[p-shift] xor a[period-p-shift] xor a[p];
      end;
      tmp:=a; a:=t; t:=tmp;
      end;
    break;
    end;
  if (degree and mask)<>0 then
    begin
    if shift<=half div 2 then
      begin
    for p:=0 to shift-1 do
      begin t[p]:=a[p] xor a[shift-p] xor a[p+shift]; b[p]:=a[p] xor b[p]; end;
    for p:=shift to half-shift do
      begin t[p]:=a[p] xor a[p-shift] xor a[p+shift]; b[p]:=a[p] xor b[p]; end;
    for p:=half-shift+1 to half do
      begin t[p]:=a[p] xor a[p-shift] xor a[period-p-shift]; b[p]:=a[p] xor b[p]; end;
      end
    else
      begin
    for p:=0 to half-shift do
      begin t[p]:=a[p] xor a[shift-p] xor a[p+shift]; b[p]:=a[p] xor b[p]; end;
    for p:=half-shift+1 to shift-1 do
      begin t[p]:=a[p] xor a[shift-p] xor a[period-p-shift]; b[p]:=a[p] xor b[p]; end;
    for p:=shift to half do
      begin t[p]:=a[p] xor a[p-shift] xor a[period-p-shift]; b[p]:=a[p] xor b[p]; end;
      end;
    tmp:=a; a:=t; t:=tmp;
    end
  else
    begin
    if shift<=half div 2 then
      begin
    for p:=0 to shift-1 do
      begin t[p]:=b[p] xor b[shift-p] xor b[p+shift]; a[p]:=a[p] xor b[p]; end;
    for p:=shift to half-shift do
      begin t[p]:=b[p] xor b[p-shift] xor b[p+shift]; a[p]:=a[p] xor b[p]; end;
    for p:=half-shift+1 to half do
      begin t[p]:=b[p] xor b[p-shift] xor b[period-p-shift]; a[p]:=a[p] xor b[p]; end;
      end
    else
      begin
    for p:=0 to half-shift do
      begin t[p]:=b[p] xor b[shift-p] xor b[p+shift]; a[p]:=a[p] xor b[p]; end;
    for p:=half-shift+1 to shift-1 do
      begin t[p]:=b[p] xor b[shift-p] xor b[period-p-shift]; a[p]:=a[p] xor b[p]; end;
    for p:=shift to half do
      begin t[p]:=b[p] xor b[p-shift] xor b[period-p-shift]; a[p]:=a[p] xor b[p]; end;
      end;
    tmp:=b; b:=t; t:=tmp;
    end;
  mask:=mask shr 1;
  end;
{ H96: a polynomial in the path matrix preserves reflection symmetry.
  Recover only the first half, then mirror the actual computed result. }
outHi:=hi; if folded then outHi:=hi div 2;
if summed then a:=ss;
if recover then
  begin
  { H92: J*S_d=F_d+F_(d-1)+I. The first coordinate fixes the
    homogeneous solution even when J is singular. Divide by 1+t+t^2
    as (1+t)/(1+t^3), using the same 32-coefficient prefix in A/B. }
  carry0:=seed; carry1:=false; base:=0;
  while base<=outHi do
    begin
    take:=outHi-base+1; if take>32 then take:=32;
    block:=Default(TB);
    for j:=0 to take-1 do block[j]:=a[base+j+1] xor src[base+j];
    block[0]:=block[0] xor carry0 xor carry1; block[1]:=block[1] xor carry0;
    block[31]:=block[31] xor block[30]; block[30]:=block[30] xor block[29]; block[29]:=block[29] xor block[28]; block[28]:=block[28] xor block[27];
    block[27]:=block[27] xor block[26]; block[26]:=block[26] xor block[25]; block[25]:=block[25] xor block[24]; block[24]:=block[24] xor block[23];
    block[23]:=block[23] xor block[22]; block[22]:=block[22] xor block[21]; block[21]:=block[21] xor block[20]; block[20]:=block[20] xor block[19];
    block[19]:=block[19] xor block[18]; block[18]:=block[18] xor block[17]; block[17]:=block[17] xor block[16]; block[16]:=block[16] xor block[15];
    block[15]:=block[15] xor block[14]; block[14]:=block[14] xor block[13]; block[13]:=block[13] xor block[12]; block[12]:=block[12] xor block[11];
    block[11]:=block[11] xor block[10]; block[10]:=block[10] xor block[9]; block[9]:=block[9] xor block[8]; block[8]:=block[8] xor block[7];
    block[7]:=block[7] xor block[6]; block[6]:=block[6] xor block[5]; block[5]:=block[5] xor block[4]; block[4]:=block[4] xor block[3];
    block[3]:=block[3] xor block[2]; block[2]:=block[2] xor block[1]; block[1]:=block[1] xor block[0];
    { H95: three residue-class prefixes; B evaluates these prefixes in parallel. }
    block[3]:=block[3] xor block[0]; block[4]:=block[4] xor block[1]; block[5]:=block[5] xor block[2]; block[6]:=block[6] xor block[3];
    block[7]:=block[7] xor block[4]; block[8]:=block[8] xor block[5]; block[9]:=block[9] xor block[6]; block[10]:=block[10] xor block[7];
    block[11]:=block[11] xor block[8]; block[12]:=block[12] xor block[9]; block[13]:=block[13] xor block[10]; block[14]:=block[14] xor block[11];
    block[15]:=block[15] xor block[12]; block[16]:=block[16] xor block[13]; block[17]:=block[17] xor block[14]; block[18]:=block[18] xor block[15];
    block[19]:=block[19] xor block[16]; block[20]:=block[20] xor block[17]; block[21]:=block[21] xor block[18]; block[22]:=block[22] xor block[19];
    block[23]:=block[23] xor block[20]; block[24]:=block[24] xor block[21]; block[25]:=block[25] xor block[22]; block[26]:=block[26] xor block[23];
    block[27]:=block[27] xor block[24]; block[28]:=block[28] xor block[25]; block[29]:=block[29] xor block[26]; block[30]:=block[30] xor block[27];
    block[31]:=block[31] xor block[28];
    dst[base]:=carry0;
    for j:=1 to take-1 do dst[base+j]:=block[j-1];
    carry0:=block[31]; carry1:=block[30]; inc(base,32);
    end;
  if folded then for p:=outHi+1 to hi do dst[p]:=dst[hi-p];
  dst[-2]:=false; dst[-1]:=false; dst[hi+1]:=false;
  exit;
  end;
for p:=0 to outHi do dst[p]:=a[p+1];
if folded then for p:=outHi+1 to hi do dst[p]:=dst[hi-p];
dst[-2]:=false; dst[-1]:=false; dst[hi+1]:=false;
end;

{ H87: mode 2 uses Fibonacci shifts; modes 0/1 use the supplied coefficients. }





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
GcdD(sa,sb,tg,tu,tv,h,cur);
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

{ H88: detect g(U)=U^a*(U+1)^b from all its coefficients.
  U=t^(-2)*(1+t)*(1+t^3), U+1=t^(-2)*(1+t^5)/(1+t).
  The reciprocal kernel is (1+t)^(b-a)/((1+t^3)^a*(1+t^5)^b).
  Frobenius reduces each power to binomial shifts; no n-based table. }
function TrySolveXShift(const vg,rhs:TVec; var dst:TVec; degreeU,len:longint):boolean;
var rem:TVec;
var p,aa,bb,k,shift:longint;
procedure DivideBinomial(gap:longint);
var base,j,take:longint;
begin
if gap>=len then exit;
if gap<32 then
  begin
  base:=0;
  while base<len do
    begin
    take:=len-base; if take>32 then take:=32;
    if base>0 then
      for j:=0 to gap-1 do
        if j<take then rem[base+j]:=rem[base+j] xor rem[base+j-gap];
    { H95: each residue stream is a prefix XOR; B evaluates the same block in parallel. }
    for j:=gap to take-1 do rem[base+j]:=rem[base+j] xor rem[base+j-gap];
    inc(base,32);
    end;
  end
else
  for j:=gap to len-1 do rem[j]:=rem[j] xor rem[j-gap];
end;
procedure MultiplyBinomial(gap:longint);
var j:longint;
begin
for j:=len-1 downto gap do rem[j]:=rem[j] xor rem[j-gap];
end;
begin
TrySolveXShift:=false;
aa:=degreeU;
for p:=0 to degreeU do if vg[p] then begin aa:=p; break; end;
bb:=degreeU-aa;
for p:=aa to degreeU do
  if (vg[p])<>(((p-aa) and bb)=(p-aa)) then exit;
for p:=0 to len-1 do rem[p]:=rhs[longint(n)-1-p];
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
for p:=0 to len-1 do dst[len-1-p]:=rem[p];
TrySolveXShift:=true;
end;

procedure SolveXFast(const vg,rhs:TVec; var dst:TVec; degreeU:longint);
var smallG:TVec;
var kernel:TDynBool;
var tables:array of TFixedMulTable;
var qblock,product:TMul64Bool;
var den,iv,rem:THPoly;
var d,len,center,dl,blockLen,size,pos,k,j0,j1,lim:longint;
var stride,fullLen,residue,mask:longint;
begin
d:=degreeU*2; len:=longint(n)-d;
VecZeroHi(dst,longint(n));
if len<=0 then exit;
if TrySolveXShift(vg,rhs,dst,degreeU,len) then exit;
{ H90: g(U)=h(U^stride), with stride a power of two. Build only the
  kernel of h, then divide the independent residue streams by that kernel. }
mask:=0;
for j0:=0 to degreeU do if vg[j0] then mask:=mask or j0;
stride:=1;
if mask<>0 then while (mask and stride)=0 do stride:=stride shl 1;
{ A divisor that already fits one leaf gains no shorter multiplication. }
if (d*2<32) or (len<=32) then stride:=1;
fullLen:=len; len:=(fullLen+stride-1) div stride;

d:=d div stride;
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
if stride=1 then
  BuildUKernelFast(vg,degreeU,kernel,center)
else
  begin
  VecZeroHi(smallG,degreeU div stride);
  for j0:=0 to degreeU div stride do smallG[j0]:=vg[j0*stride];
  BuildUKernelFast(smallG,degreeU div stride,kernel,center);
  end;
HPAlloc(den,dl);
for j0:=0 to dl-1 do den.v^[j0]:=kernel[center-d+j0];
den.d:=dl-1; HPNorm(den);
HPAlloc(rem,len);
k:=blockLen; if k>len then k:=len;
HPInvSeries(den,k,iv);
if blockLen=32 then
  begin
  SetLength(tables,(den.d+32) div 32+1);
  PrepareFixedMul(iv.v^,0,iv.d+1,tables[0]);
  for j0:=0 to (den.d+32) div 32-1 do
    PrepareFixedMul(den.v^,j0*32,den.d+1-j0*32,tables[j0+1]);
  end;
for residue:=0 to stride-1 do
begin
len:=(fullLen-1-residue) div stride+1;
if residue>=fullLen then break;
for j0:=0 to len-1 do rem.v^[j0]:=rhs[longint(n)-1-residue-j0*stride];
rem.d:=len-1;
pos:=0;
{ The same fixed 32-coefficient multiplication leaf is fused in A/B. }
if blockLen=32 then
  begin

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
for j0:=0 to len-1 do dst[fullLen-1-residue-j0*stride]:=rem.v^[j0];
end;
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

{ H89: B packs the same even-branch coefficient expansion into words. }
{ The dyadic size has an invertible first-row operator, so no
  arbitrary choice among different valid solutions is introduced. }
{ The zero-boundary path is the reflection of a cycle of length
  2*(n+1); over GF(2), H^(2^a) is the sum of the two shifted reads. }
function H107Read(const v:TVec; p:longint):boolean;
var l,period:longint;
begin
l:=longint(n)+1; period:=l*2;
p:=(p+1) mod period; if p<0 then inc(p,period);
if p>l then p:=period-p;
if (p=0) or (p=l) then H107Read:=false else H107Read:=v[p-1];
end;

procedure H107Apply(const src:TVec; var dst:TVec; const coeff:TH107Small; degree:longint);
var a,b,tmp:PVec; j,p:longint;
begin
a:=@h107Work[0]; b:=@h107Work[1];
VecCopyHi(a^,src,longint(n));
for j:=degree-1 downto 0 do
  begin
  for p:=0 to longint(n)-1 do
    b^[p]:=H107Read(a^,p-h107Step) xor H107Read(a^,p+h107Step) xor (coeff[j] and src[p]);
  b^[-2]:=false; b^[-1]:=false; b^[n]:=false;
  tmp:=a; a:=b; b:=tmp;
  end;
VecCopyHi(dst,a^,longint(n));
end;

procedure H107FirstRow;
var t:TVec; p:longint;
begin
H107Apply(y,t,h107Q,h107QDeg);
for p:=0 to longint(n)-1 do x[p]:=t[p-1] xor t[p] xor t[p+1];
x[-2]:=false; x[-1]:=false; x[n]:=false;
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

var h108Kernel:TDynBool;

function H108Seed(const v:TVec):boolean;
var p:longint; value:boolean;
begin
value:=false;
for p:=0 to longint(n)-1 do value:=value xor (v[p] and (h108Kernel[p] xor h108Kernel[p+2]));
H108Seed:=value;
end;

function H108Group(first,last:longint):boolean;
var plan:TH108Plan; rhs,value:TH108Line;
var r,i,j,col,p:longint;
begin
H108Group:=false;
if first>last then begin H108Group:=true; exit; end;
if not H108MakePlan(first,plan) then exit;
for r:=first to last do
  begin
  for i:=0 to plan.rows-1 do rhs[i]:=h108Source[H108Position(r,plan.rowSlot[i])-1];
  for i:=0 to plan.rows-1 do
    begin
    value[i]:=false;
    for j:=0 to plan.rows-1 do value[i]:=value[i] xor (plan.transform[i,j] and rhs[j]);
    if (i>=plan.rank) and value[i] then exit;
    end;
  for i:=0 to plan.rank-1 do
    begin col:=plan.pivot[i]; p:=H108Position(r,plan.colSlot[col]); x[p-1]:=value[i]; end;
  if plan.nullity=1 then
    begin
    inc(h108NullCount); if h108NullCount>1 then exit;
    for col:=0 to plan.cols-1 do if plan.nullVector[col] then
      h108Null[H108Position(r,plan.colSlot[col])-1]:=true;
    end;
  end;
H108Group:=true;
end;

function H108FirstRow:boolean;
var p,half:longint; seed:boolean;
begin
H108FirstRow:=false;
if not h108Ready then exit;
h108Ready:=false;
VecZeroHi(x,longint(n)); VecZeroHi(h108Null,longint(n)); h108NullCount:=0;
for p:=0 to longint(n)-1 do h108Source[p]:=y[p-1] xor y[p] xor y[p+1];
half:=h107Step div 2;
if not H108Group(0,0) then exit;
if half>0 then if not H108Group(1,1) then exit;
if half>2 then if not H108Group(2,half-1) then exit;
if half>1 then if not H108Group(half,half) then exit;
BuildFibonacciHalfKernel(longint(n),h108Kernel,((longint(n)+35) shr 5) shl 5);
seed:=H108Seed(x);
if h108NullCount=1 then
  begin
  if not H108Seed(h108Null) then exit;
  if seed<>y[0] then for p:=0 to h108Length-1 do x[p]:=x[p] xor h108Null[p];
  end
else if seed<>y[0] then exit;
h108Ready:=true; H108FirstRow:=true;
end;

procedure H103FirstRow;
var p:longint;
begin
for p:=0 to longint(n)-1 do x[p]:=y[p-1] xor y[p] xor y[p+1];
x[-2]:=false; x[-1]:=false; x[n]:=false;
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
var half:TDynBool;
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
BuildFibonacciHalfKernel(b-1,half,b+2);
SetLength(prev,l); SetLength(cur,l);
for p:=0 to l-1 do
  begin
  j:=p; if j>b then j:=l-j;
  if j<b then cur[p]:=half[j];
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
var cycle:array of boolean;
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
FoldStripes:=false; count:=0; width:=h117Stride;
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
l:=longint(n)+1; SetLength(cycle,3*l);
for p:=0 to l-1 do
  begin
  cycle[p]:=src[p]; cycle[p+l]:=src[l-2-p];
  cycle[p+2*l]:=cycle[p];
  end;
VecZeroHi(dst,longint(n));
if not FoldStripes then
for k:=0 to High(coeff) do if coeff[k] then
  begin
  start:=k*h117Stride;
  for p:=0 to l-1 do dst[p]:=dst[p] xor cycle[start+p];
  end;
dst[-1]:=false; dst[-2]:=false; dst[n]:=false;
end;

procedure H117FirstRow;
var t:TVec; p:longint;
begin
H117Apply(y,t,h117Q);
for p:=0 to longint(n)-1 do x[p]:=t[p-1] xor t[p] xor t[p+1];
x[-2]:=false; x[-1]:=false; x[n]:=false;
end;

{ H119. Binary Laurent composition in two Frobenius axes.
  Split P(Y) at B, a power of two, and use u(t)^B=u(t^B).
  A length 4B-1 multiplicative Fourier transform separates the powers
  -2(B-1)..2(B-1). Each extension coordinate carries a separate fiber. }
type TH119Ints=array of longint;
type TH119NativeEntry=record index:longint; bits:array[0..11] of boolean; end;
type TH119Native=^TH119NativeEntry;
type TH119Plan=record
  dictionary:array of TH119NativeEntry;
  zech:TH119Ints;
  order,w,step:longint;
  power,logarithm,reduce,whereU,chirp:TH119Ints;
  forwardKernel,inverseKernel:TH119Bits;
end;
var h119Plans:array of TH119Plan;

function H119RowBit(const a:TVec; i:longint):boolean; inline;
begin H119RowBit:=a[i]; end;

procedure H119RowOne(var a:TVec; i:longint); inline;
begin a[i]:=true; end;

procedure H119ClearRow(var a:TVec); inline;
begin VecZeroHi(a,longint(n)); end;

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
var j,v:longint;
begin
v:=0; for j:=0 to w-1 do if odd(a shr j) xor odd(b shr j) then v:=v or (1 shl j);
H119XorIndex:=v;
end;

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
  SetLength(plan.dictionary,field);
  for i:=1 to d do
    begin
    plan.dictionary[i].index:=i;
    for ex:=0 to w-1 do plan.dictionary[i].bits[ex]:=(i and (1 shl ex))<>0;
    end;
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
begin if a=nil then H119NativeKey:=0 else H119NativeKey:=a^.index; end;

function H119NativeValue(const plan:TH119Plan; i:longint):TH119Native; inline;
begin if i=0 then H119NativeValue:=nil else H119NativeValue:=@plan.dictionary[i]; end;

function H119NativeBit(const a:TH119Native; bit:longint):boolean; inline;
begin if a=nil then H119NativeBit:=false else H119NativeBit:=a^.bits[bit]; end;

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
else BuildFibonacciHalfKernel(longint(n),kernel,longint(n)+3,summed);
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
type TH120Entry=record key:longint; bits:TH119Bits; end;
type TH120Lane=^TH120Entry;
type TH120Lanes=array of TH120Lane;
var h120W,h120Alphabet,h120Mask:longint;
    h120Leaf:TH120Lanes;
var h120Dictionary:array of TH120Entry; h120Sums:TH120Lanes;

function H120Key(const a:TH120Lane):longint; inline;
begin if a=nil then H120Key:=0 else H120Key:=a^.key; end;

function H120LaneAt(v:longint):TH120Lane; inline;
begin if v=0 then H120LaneAt:=nil else H120LaneAt:=@h120Dictionary[v]; end;

function H120Plus(const a,b:TH120Lane):TH120Lane; inline;
begin H120Plus:=h120Sums[H120Key(a)*h120Alphabet+H120Key(b)]; end;

function H120LaneBit(const a:TH120Lane; i:longint):boolean; inline;
begin if a=nil then H120LaneBit:=false else H120LaneBit:=a^.bits[i]; end;

procedure H120PrepareLanes(size:longint);
var w,lg,c,i,j,k,t,base:longint; powers:TH119Bits;
begin
lg:=0; t:=size; while t>1 do begin inc(lg); t:=t shr 1; end;
w:=8; while 2*w<=lg div 4 do w:=2*w;
if h120W=w then exit;
h120W:=w; c:=1 shl w; h120Alphabet:=c; h120Mask:=h120Alphabet-1;
SetLength(h120Dictionary,c); SetLength(h120Sums,c*c); h120Sums[0]:=nil;
for i:=1 to c-1 do
  begin
  h120Dictionary[i].key:=i; H119Space(h120Dictionary[i].bits,w);
  for j:=0 to w-1 do if (i and (1 shl j))<>0 then H119Flip(h120Dictionary[i].bits,j);
  end;
for i:=0 to c-1 do for j:=0 to c-1 do
  begin
  t:=2*H120Key(h120Sums[(i shr 1)*c+(j shr 1)])+ord(odd(i) xor odd(j));
  h120Sums[i*c+j]:=H120LaneAt(t);
  end;
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
  rr:=GcdD(sa,sb,hu,su,sv,hiS,n);
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
h117Ready:=H117Prepare;
if h117Ready then
  begin
  H117FirstRow;
  write('x ');for i:=0 to n-1 do if x[i] then write(1) else write(0);writeln;
  exit;
  end;
if H103Dyadic then
  begin
  H103FirstRow;
  write('x ');for i:=0 to n-1 do if x[i] then write(1) else write(0);writeln;
  exit;
  end;
if h107Ready then
  begin
  H107FirstRow;
  write('x ');for i:=0 to n-1 do if x[i] then write(1) else write(0);writeln;
  exit;
  end;
{ H87: P(H)*S_n(I+H)*1 = S_n(I+H)*P(H)*1. }
if h102Backend=7 then H119Z(qu,qv,z)
else
  begin
  ApplyUComboOnes(qu,qv,z,n-1,longint(n div 2),0);
  ApplyFibonacciFast(z,z,n-1,longint(n),true,true);
  end;

if r0=0 then
  begin
  if not H108FirstRow then for i:=0 to n-1 do x[i]:=z[i];
  end
else
begin
write('z ');for i:=0 to n-1 do if z[i] then write(1) else write(0);writeln;
if not H108FirstRow then
  if h102Backend=7 then H119SolveX(gu,z,x,rU) else SolveXFast(gu,z,x,rU);
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

function H118Size(const arg:ansistring):longint;
var err,value:longint;
begin
Val(arg,value,err);
if err<>0 then value:=0;
H118Size:=value;
end;

var firstN,lastN:longint;
begin
firstN:=1; lastN:=20;
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
InitMul8;
InitUKernel8;
for n:=firstN to lastN do
  begin
  writeln('#',n);
  MakeMat();
  CalcMat2();
  GeneMat();
  writeln();
  end;
end.
