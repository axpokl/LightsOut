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
var b:pbitmap;
{$endif}

procedure PrintMat(mat:TMat);
var i,j:longint;
begin
writeln();
for j:=0 to n-1 do
  begin
//  if mat[j,-1] then write('#') else write('.');
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
for k:=0 to n-1 do
  begin
  j0:=-1;
  for j:=n-1 downto k do
    if l[j,k] then j0:=j;
  j:=j0;
  if j>=0 then
    begin
    if j<>k then
      for i:=-1 to n-1 do
        begin
        l[j,i]:=l[j,i] xor l[k,i];
        l[k,i]:=l[j,i] xor l[k,i];
        l[j,i]:=l[j,i] xor l[k,i];
        r[j,i]:=r[j,i] xor r[k,i];
        r[k,i]:=r[j,i] xor r[k,i];
        r[j,i]:=r[j,i] xor r[k,i];
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
        end;
end;

var f,g:array[-2..0,-1..m]of boolean;

function rank(n:longint):longint;
var fn,gn,cn:array[-1..m]of boolean;
var ni,nt,k,kg,kf,kt:longint;
begin
if f[0,n-1]=false then begin f[0,0]:=true;g[0,0]:=true;nt:=1;end else nt:=n;
for ni:=nt to n do
begin
f[-2]:=f[-1];f[-1]:=f[0];g[-2]:=g[-1];g[-1]:=g[0];
for k:=0 to ni do
begin
f[0,k]:=f[-1,k-1] xor f[-2,k];
g[0,k]:=g[-1,k-1] xor g[-1,k] xor g[-2,k];
end;
end;
fn:=f[0];gn:=g[0];
kg:=n;kf:=n;
repeat
kt:=-1;
for k:=0 to kf do
begin 
if k>=(kf-kg) then fn[k]:=fn[k] xor gn[k-(kf-kg)];
if fn[k] then kt:=k;
end;
if kt=-1 then rank:=kg;
if kt<kg then begin cn:=fn;fn:=gn;gn:=cn;kf:=kg;kg:=kt;end else kf:=kt;
until kt=-1;
end;

procedure CalcMat2;
type
  TRow = array of QWord;
var
  Abits,Bbits: array of TRow;
  tmpRow: TRow;
  bvec,xvec: array[0..m-1] of Boolean;
  words: longint;
  i,j,w,row,col: longint;
begin
  words := (n + 63) shr 6;
  SetLength(Abits, n);
  SetLength(Bbits, n);
  for i := 0 to n-1 do
  begin
    SetLength(Abits[i], words);
    SetLength(Bbits[i], words);
    for w := 0 to words-1 do
    begin
      Abits[i][w] := 0;
      Bbits[i][w] := 0;
    end;
    for j := 0 to n-1 do
      if l[i,j] then
        Abits[i][j shr 6] := Abits[i][j shr 6] or (QWord(1) shl (j and 63));
    Bbits[i][i shr 6] := Bbits[i][i shr 6] or (QWord(1) shl (i and 63));
  end;

  row := 0;
  for col := 0 to n-1 do
  begin
    i := row;
    while (i < n) and (((Abits[i][col shr 6] shr (col and 63)) and QWord(1)) = 0) do Inc(i);
    if i = n then continue;
    if i <> row then
    begin
      tmpRow := Abits[row]; Abits[row] := Abits[i]; Abits[i] := tmpRow;
      tmpRow := Bbits[row]; Bbits[row] := Bbits[i]; Bbits[i] := tmpRow;
    end;
    for j := 0 to n-1 do
      if j <> row then
        if (((Abits[j][col shr 6] shr (col and 63)) and QWord(1)) <> 0) then
          for w := 0 to words-1 do
          begin
            Abits[j][w] := Abits[j][w] xor Abits[row][w];
            Bbits[j][w] := Bbits[j][w] xor Bbits[row][w];
          end;
    Inc(row);
    if row = n then break;
  end;

  for i := 0 to n-1 do
    for j := 0 to n-1 do
      r[i,j] := (((Bbits[i][j shr 6] shr (j and 63)) and QWord(1)) <> 0);

  for i := 0 to n-1 do bvec[i] := l[i,-1];
  for i := 0 to n-1 do
  begin
    xvec[i] := false;
    for j := 0 to n-1 do
      if r[i,j] and bvec[j] then xvec[i] := not xvec[i];
  end;
  for i := 0 to n-1 do l[i,-1] := xvec[i];
end;
procedure GeneMat();
begin
for i:=0 to n-1 do
  begin
  t[0,i]:=l[i,-1];
  l[i,-1]:=false;
  end;
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
//  write(#9,s,#9,n*n,#9,s/n/n:0:5);
  {$ifdef disp}if not(iswin()) then halt;{$endif}
  writeln();
  end;
end.
