{$define disp}
program diandeng;

{$ifdef disp}
uses display;
{$endif}

const m=1000;

type TMat=array[-1..m,-1..m]of Boolean;

var n:longword;
var l,r,t:TMat;
var i,j,k:longint;

{$ifdef disp}
var bb:pbitbuf;
var s:longword=0;
var b:pbitmap;
{$endif}

procedure PrintMat(mat:TMat);
var i,j:longint;
begin
writeln();
for j:=0 to n-1 do
  begin
  if mat[j,-1] then write('#') else write('.');write(' ');
  for i:=0 to n-1 do
    if mat[j,i] then write('#') else write('.');
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
    if mat[j,i] then SetBBPixel(bb,i,j,black) else SetBBPixel(bb,i,j,white);
SetBB(bb);
FreshWin();
end;

procedure PrintMat(s:ansistring;mat:TMAT);
begin
DrawMat(mat);
b:=CreateBMP(n,n);
DrawBMP(_pmain,b,0,0,n,n,0,0,n,n);
SaveBMP(b,'png'+s+'/'+i2s(n)+'.png');
ReleaseBMP(b);
end;
{$endif}

procedure MakeMat();
begin
for i:=0 to n-1 do l[0,i]:=False;
l[-1,0]:=False;
for j:=1 to n do
  for i:=0 to n-1 do
    begin
    l[j,i]:=not(l[j-1,i-1] xor l[j-1,i] xor l[j-1,i+1] xor l[j-2,i]);
    l[j,i]:=l[j,i];
    end;
for i:=0 to n-1 do l[-1,i]:=False;
l[-1,0]:=True;
for j:=0 to n-1 do
  for i:=0 to n-1 do
    begin
    l[j,i]:=(l[j-1,i-1] xor l[j-1,i] xor l[j-1,i+1]);
    if j>0 then l[j,i]:=l[j,i] xor l[j-2,i];
    end;
for i:=0 to n-1 do l[0,i]:=l[n-1,i];
for j:=1 to n-1 do
  for i:=0 to n-1 do
    begin
    l[j,i]:=(l[j-1,i-1] xor l[j-1,i+1]);
    if j>1 then l[j,i]:=l[j,i] xor l[j-2,i];
    end;
for i:=0 to n-1 do begin l[i,-1]:=l[n,i];l[n,i]:=False;end;
for i:=0 to n-1 do for j:=0 to n-1 do r[i,j]:=(i=j);
end;

procedure CalcMat();
var j0:longint;
begin
//writeln();
for k:=0 to n-1 do
  begin
  j0:=-1;
  for j:=n-1 downto k do
    if l[j,k] then j0:=j;
  j:=j0;
  if j>=0 then
    begin
    if j<>k then
      begin
      for i:=-1 to n-1 do
        begin
        l[j,i]:=l[j,i] xor l[k,i];
        l[k,i]:=l[j,i] xor l[k,i];
        l[j,i]:=l[j,i] xor l[k,i];
        r[j,i]:=r[j,i] xor r[k,i];
        r[k,i]:=r[j,i] xor r[k,i];
        r[j,i]:=r[j,i] xor r[k,i];
        end;
//writeln('swap ',j+1,' ',k+1);PrintMat(r);PrintMat(l);
      end;
    for j:=k+1 to n-1 do
      if l[j,k] then
        begin
        for i:=0 to n-1 do //for a-1
          begin
          l[j,i]:=l[j,i] xor l[k,i];
          r[j,i]:=r[j,i] xor r[k,i];
          end;
        l[j,-1]:=l[j,-1] xor l[k,-1];
        r[j,-1]:=r[j,-1] xor r[k,-1];
//writeln('xor1 ',k+1,' ',j+1);PrintMat(r);PrintMat(l);
        end;
    end;
  end;
for i:=n-1 downto 0 do
  if l[i,i] then
    for j:=i-1 downto 0 do
      if l[j,i] then
        begin
        for k:=0 to n-1 do // for a-1
          begin
          l[j,k]:=l[j,k] xor l[i,k];
          r[j,k]:=r[j,k] xor r[i,k];
          end;
        l[j,-1]:=l[j,-1] xor l[i,-1];
        r[j,-1]:=r[j,-1] xor r[i,-1];
//writeln('xor2 ',i+1,' ',j+1);PrintMat(r);PrintMat(l);
        end;
end;

const
  BLOCK_THRESHOLD=32;
  STRASSEN_THRESHOLD=64;

type
  TBoolRow=array of boolean;
  TBoolMat=array of TBoolRow;

procedure SwapRows(var mat:TMat; row1,row2,colStart,colEnd:Integer);
var i:Integer; t:boolean;
begin
  if row1=row2 then exit;
  for i:=colStart to colEnd do begin t:=mat[row1,i]; mat[row1,i]:=mat[row2,i]; mat[row2,i]:=t; end;
end;

procedure XORRow(var mat:TMat; destRow,srcRow,colStart,colEnd:Integer);
var i:Integer;
begin
  for i:=colStart to colEnd do mat[destRow,i]:=mat[destRow,i] xor mat[srcRow,i];
end;

procedure StandardGaussJordanSubmatrix(var A,R:TMat; rowStart,colStart,sz:Integer);
var row,col,pivot,ridx:Integer;
begin
  row:=rowStart;
  for col:=colStart to colStart+sz-1 do
  begin
    pivot:=-1;
    for ridx:=rowStart+sz-1 downto row do if A[ridx,col] then begin pivot:=ridx; break; end;
    if pivot=-1 then continue;
    if pivot<>row then begin SwapRows(A,pivot,row,0,n-1); SwapRows(R,pivot,row,0,n-1); end;
    for ridx:=0 to n-1 do if (ridx<>row) and A[ridx,col] then begin XORRow(A,ridx,row,colStart,colStart+sz-1); XORRow(A,ridx,row,col+1,n-1); XORRow(R,ridx,row,0,n-1); end;
    inc(row); if row>rowStart+sz-1 then break;
  end;
end;

procedure AllocSq(var M:TBoolMat; s:Integer);
var i:Integer;
begin
  SetLength(M,s); for i:=0 to s-1 do SetLength(M[i],s);
end;

procedure ZeroSq(var M:TBoolMat; s:Integer);
var i,j:Integer;
begin
  for i:=0 to s-1 do for j:=0 to s-1 do M[i][j]:=false;
end;

procedure CopyRectToSq(var Src:TMat; r0,c0,h,w,s:Integer; var D:TBoolMat);
var i,j:Integer;
begin
  AllocSq(D,s); ZeroSq(D,s);
  for i:=0 to h-1 do for j:=0 to w-1 do D[i][j]:=Src[r0+i,c0+j];
end;

procedure CopySqToRect(var Src:TBoolMat; h,w:Integer; var D:TBoolMat);
var i:Integer;
begin
  SetLength(D,h); for i:=0 to h-1 do SetLength(D[i],w);
  for i:=0 to h-1 do move(Src[i][0],D[i][0],w*SizeOf(boolean));
end;

procedure XorSq(var A,B:TBoolMat; s:Integer; var C:TBoolMat);
var i,j:Integer;
begin
  AllocSq(C,s);
  for i:=0 to s-1 do for j:=0 to s-1 do C[i][j]:=A[i][j] xor B[i][j];
end;

procedure AddSqInPlace(var A:TBoolMat; const B:TBoolMat; s:Integer);
var i,j:Integer;
begin
  for i:=0 to s-1 do for j:=0 to s-1 do A[i][j]:=A[i][j] xor B[i][j];
end;

procedure NaiveSqMul(var A,B:TBoolMat; s:Integer; var C:TBoolMat);
var i,j,k:Integer;
begin
  AllocSq(C,s); ZeroSq(C,s);
  for i:=0 to s-1 do
    for k:=0 to s-1 do
      if A[i][k] then
        for j:=0 to s-1 do C[i][j]:=C[i][j] xor B[k][j];
end;

procedure StrassenSqMul(var A,B:TBoolMat; s:Integer; var C:TBoolMat);
var m:Integer; A11,A12,A21,A22,B11,B12,B21,B22,M1,M2,M3,M4,M5,M6,M7,T1,T2,C11,C12,C21,C22:TBoolMat; i,j:Integer;
begin
  if s<=STRASSEN_THRESHOLD then begin NaiveSqMul(A,B,s,C); exit; end;
  m:=s shr 1;
  AllocSq(A11,m); AllocSq(A12,m); AllocSq(A21,m); AllocSq(A22,m);
  AllocSq(B11,m); AllocSq(B12,m); AllocSq(B21,m); AllocSq(B22,m);
  for i:=0 to m-1 do begin
    for j:=0 to m-1 do begin
      A11[i][j]:=A[i][j]; A12[i][j]:=A[i][j+m]; A21[i][j]:=A[i+m][j]; A22[i][j]:=A[i+m][j+m];
      B11[i][j]:=B[i][j]; B12[i][j]:=B[i][j+m]; B21[i][j]:=B[i+m][j]; B22[i][j]:=B[i+m][j+m];
    end;
  end;
  XorSq(A11,A22,m,T1); XorSq(B11,B22,m,T2); StrassenSqMul(T1,T2,m,M1);
  XorSq(A21,A22,m,T1); StrassenSqMul(T1,B11,m,M2);
  XorSq(B12,B22,m,T2); StrassenSqMul(A11,T2,m,M3);
  XorSq(B21,B11,m,T2); StrassenSqMul(A22,T2,m,M4);
  XorSq(A11,A12,m,T1); StrassenSqMul(T1,B22,m,M5);
  XorSq(A21,A11,m,T1); XorSq(B11,B12,m,T2); StrassenSqMul(T1,T2,m,M6);
  XorSq(A12,A22,m,T1); XorSq(B21,B22,m,T2); StrassenSqMul(T1,T2,m,M7);
  AllocSq(C11,m); AllocSq(C12,m); AllocSq(C21,m); AllocSq(C22,m);
  C11:=M1; AddSqInPlace(C11,M4,m); AddSqInPlace(C11,M5,m); AddSqInPlace(C11,M7,m);
  C12:=M3; AddSqInPlace(C12,M5,m);
  C21:=M2; AddSqInPlace(C21,M4,m);
  C22:=M1; AddSqInPlace(C22,M2,m); AddSqInPlace(C22,M3,m); AddSqInPlace(C22,M6,m);
  AllocSq(C,s);
  for i:=0 to m-1 do begin
    move(C11[i][0],C[i][0],m*SizeOf(boolean));
    move(C12[i][0],C[i][m],m*SizeOf(boolean));
    move(C21[i][0],C[i+m][0],m*SizeOf(boolean));
    move(C22[i][0],C[i+m][m],m*SizeOf(boolean));
  end;
end;

function NextPow2(x:Integer):Integer;
begin
  dec(x); x:=x or (x shr 1); x:=x or (x shr 2); x:=x or (x shr 4); x:=x or (x shr 8); x:=x or (x shr 16); NextPow2:=x+1;
end;

procedure StrassenRectMul(var A:TMat; ar,ac,ah,aw:Integer; var B:TMat; br,bc,bh,bw:Integer; var C:TBoolMat);
var s,i,j:Integer; Asq,Bsq,Rsq:TBoolMat;
begin
  s:=NextPow2(ah); if NextPow2(aw)>s then s:=NextPow2(aw); if NextPow2(bw)>s then s:=NextPow2(bw);
  CopyRectToSq(A,ar,ac,ah,aw,s,Asq);
  CopyRectToSq(B,br,bc,bh,bw,s,Bsq);
  StrassenSqMul(Asq,Bsq,s,Rsq);
  SetLength(C,ah); for i:=0 to ah-1 do begin SetLength(C[i],bw); for j:=0 to bw-1 do C[i][j]:=Rsq[i][j]; end;
end;

procedure RecursiveRREFSubmatrix(var A,R:TMat; r0,c0,sz:Integer);
var mid,sz1,sz2,i,j,pivotRow,rr,cc,cnt1,cnt2:Integer;
    pivotRows1,pivotCols1,pivotRows2,pivotCols2:array of Integer;
    temp,Sblock:TBoolMat;
begin
  if sz<=BLOCK_THRESHOLD then begin StandardGaussJordanSubmatrix(A,R,r0,c0,sz); exit; end;
  mid:=sz div 2; sz1:=mid; sz2:=sz-mid;
  SetLength(pivotRows1,sz1); SetLength(pivotCols1,sz1); SetLength(pivotRows2,sz2); SetLength(pivotCols2,sz2);
  RecursiveRREFSubmatrix(A,R,r0,c0,sz1);
  cnt1:=0; rr:=r0;
  for cc:=c0 to c0+sz1-1 do
    begin pivotRow:=-1; for i:=rr to r0+sz1-1 do if A[i,cc] then begin pivotRow:=i; break; end;
    if pivotRow=-1 then continue; pivotRows1[cnt1]:=pivotRow; pivotCols1[cnt1]:=cc; inc(cnt1); inc(rr); if rr>r0+sz1-1 then break;
    end;
  for i:=0 to cnt1-1 do for j:=r0+sz1 to r0+sz-1 do if A[j,pivotCols1[i]] then begin XORRow(A,j,pivotRows1[i],c0,c0+sz-1); XORRow(R,j,pivotRows1[i],0,n-1); end;
  StrassenRectMul(A,r0+sz1,c0,sz2,sz1,A,r0,c0+sz1,sz1,sz2,temp);
  SetLength(Sblock,sz2); for i:=0 to sz2-1 do begin SetLength(Sblock[i],sz2); for j:=0 to sz2-1 do Sblock[i][j]:=A[r0+sz1+i,c0+sz1+j] xor temp[i][j]; end;
  for i:=0 to sz2-1 do for j:=0 to sz2-1 do A[r0+sz1+i,c0+sz1+j]:=Sblock[i][j];
  RecursiveRREFSubmatrix(A,R,r0+sz1,c0+sz1,sz2);
  cnt2:=0; rr:=r0+sz1;
  for cc:=c0+sz1 to c0+sz1+sz2-1 do begin pivotRow:=-1; for i:=rr to r0+sz1+sz2-1 do if A[i,cc] then begin pivotRow:=i; break; end;
  if pivotRow=-1 then continue; pivotRows2[cnt2]:=pivotRow; pivotCols2[cnt2]:=cc; inc(cnt2); inc(rr); if rr>r0+sz1+sz2-1 then break; end;
  for i:=0 to cnt2-1 do for j:=r0 to r0+sz1-1 do if A[j,pivotCols2[i]] then begin XORRow(A,j,pivotRows2[i],c0,c0+sz-1); XORRow(R,j,pivotRows2[i],0,n-1); end;
  StandardGaussJordanSubmatrix(A,R,r0,c0,sz);
end;

procedure CalcMat2;
begin
  RecursiveRREFSubmatrix(l,r,0,0,n);
end;

procedure GeneMat();
begin
{
for i:=0 to n-1 do
  begin
  t[0,i]:=l[i,-1];
  l[i,-1]:=false;
  end;
}
//printmat(l);printmat(r);printmat(t);
for j:=0 to n-1 do
  begin
  t[0,j]:=false;
  for i:=0 to n-1 do
    begin
    t[0,j]:=t[0,j] xor (l[i,-1] and r[j,i]);
//    writeln(j,' ',i,' ',t[0,j]:6,' ',l[i,-1]:6,' ',r[j,i]:6,' ',l[i,-1] and r[j,i]:6);
    end;
  end;
for i:=0 to n-1 do
  l[i,-1]:=false;
//printmat(l);printmat(r);printmat(t);
for j:=1 to n-1 do
  for i:=0 to n-1 do
    t[j,i]:=not(t[j-1,i-1] xor t[j-1,i] xor t[j-1,i+1] xor t[j-2,i]);
end;

begin
{$ifdef disp}
CreateWin(m,m);
bb:=CreateBB(GetWin());
b:=CreateBMP(m,m);
{$endif}
for n:=1 to 20 do
  begin
  write(n,#9);
  write('m');MakeMat();{$ifdef disp}write('%');PrintMat('_A',l);{$endif}
  write('c');CalcMat2();{$ifdef disp}write('%');PrintMat('_E',l);write('%');PrintMat('_R',r);{$endif}
  write('g');GeneMat();{$ifdef disp}write('%');PrintMat('_T',t);{$endif}
  {$ifdef disp}write(#9,s,#9,n*n,#9,s/n/n:0:5);{$endif}
  {$ifdef disp}if not(iswin()) then halt;{$endif}
  writeln();
  end;
end.
