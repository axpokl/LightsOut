program diandeng;
uses display;

const m=10000;
type TMatB=bitpacked array[-1..((m shr 5)+1)*((m shr 5)+1)shl 5] of DWord;
type TMatE=bitpacked array[0..31]of DWord;
type TMat=bitpacked array[0..m+1,0..m+1]of boolean;
var ma,mb,mc:TMatB;
var me,me2,mf,mf2,mg,mt:TMatE;
var mp,mq:TMat;
var n,l,t,s:longint;
var i,j,k:longint;
var pi,pj,pk:longint;
var si,sk:longint;
var v:longword;

procedure print(var m:TMat);
const chm:array[false..true]of char=('.','x');
begin
for pj:=1 to n do
  begin
  for pi:=1 to n+1 do
    write(chm[m[pi,pj]]:2);
  writeln();
  end;
writeln();
end;

procedure printpng(var m:TMat);
const clm:array[false..true]of longword=(white,black);
var b:pbitmap;
begin
b:=CreateBMP(n,n);
for j:=1 to n do
  for i:=1 to n do
    Bar(b,j-1,n-i,1,1,clm[m[i,j]]);
SaveBMP(b,'png/'+i2s(n)+'.png');
ReleaseBMP(b);
end;

procedure unpack(var mb:TMatB;var m:TMat);
begin
for pj:=1 to n do
  for pi:=1 to n+1 do
    m[pi,pj]:=(mb[((pi-1)shr 5)*((n shr 5)+1)shl 5+(pj-1)] and me[(pi-1)and 31])=me[(pi-1)and 31];
end;

procedure xorMat(var me,mf,mg:TMatE);
begin
for pk:=0 to 31 do
  mg[pk]:=me[pk] xor mf[pk];
end;

procedure initme(var me:TMatE);
begin
me[0]:=1;
for k:=1 to 31 do
  me[k]:=me[k-1]shl 1;
for k:=0 to 31 do
  me2[k]:=me[k];
for k:=n and 31 to 31 do
  me2[k]:=0;
end;

procedure initmf(var mf:TMatE);
begin
for k:=0 to 31 do
  mf[k]:=v;
for k:=0 to 31 do
  mf2[k]:=v;
for k:=n and 31 to 31 do
  mf2[k]:=0;
end;

procedure init(var m:TMatB);
begin
FillDWord(m,((n shr 5)+1)*((n shr 5)+1)shl 5,0);
end;

procedure initE(var m:TMatB);
begin
t:=n shr 5;
for k:=0 to t-1 do
  Move(me,m[(k*(t+2))shl 5],128);
Move(me2,m[(t*(t+2))shl 5],128);
end;

procedure copy(var x,y:TMatB);
begin
Move(x,y,((n shr 5)+1)*((n shr 5)+1)shl 5 shl 2);
end;

procedure calc(var a,b,c:TMatB);
begin
copy(b,c);
t:=n shr 5;
for i:=0 to t do
  for j:=0 to t do
     begin
     s:=(j+i*(t+1))shl 5;
     Move(a[s],mg,128);
     Move(c[s],mt,128);
     xorMat(mg,mt,mg);
     Move(c[s-1],mt,128);
     if j=0 then mt[0]:=0;
     if j=t then mt[n and 31]:=0;
     xorMat(mg,mt,mg);
     Move(c[s+1],mt,128);
     if j=t then mt[31]:=0;
     xorMat(mg,mt,mg);
     Move(mg,b[s],128);
     end;
for k:=0 to t do
  begin
  s:=(k+t*(t+1))shl 5;
  Move(b[s],mg,128);
  if k<t then
    xorMat(mg,mf,mg)
  else
    xorMat(mg,mf2,mg);
  Move(mg,b[s],128);
  end;
copy(c,a);
end;

procedure solve(var m:TMatB);
begin
for k:=0 to n-1 do
  begin
  sk:=(k shr 5)*((n shr 5)+1)shl 5;
  if (m[sk+k] and me[k and 31]=me[k and 31])=false then
    begin
    t:=-1;
    for j:=k+1 to n-1 do
      if (m[sk+j] and me[k and 31]=me[k and 31])=true then t:=j;
    if t<>-1 then
      for i:=0 to (n shr 5) do
        begin
        si:=i*((n shr 5)+1) shl 5;
        m[si+k]:=m[si+k] xor m[si+t];
        end;
    end;
  for j:=k+1 to n-1 do
    if (m[sk+j] and me[k and 31]=me[k and 31])=true then
      for i:=0 to (n shr 5) do
        begin
        si:=i*((n shr 5)+1) shl 5;
        m[si+j]:=m[si+j] xor m[si+k];
        end;
  end;
for k:=n-1 downto 0 do
  begin
  sk:=(k shr 5)*((n shr 5)+1)shl 5;
  for j:=k-1 downto 0 do
    if (m[sk+j] and me[k and 31]=me[k and 31])=true then
      for i:=0 to (n shr 5) do
        begin
        si:=i*((n shr 5)+1) shl 5;
        m[si+j]:=m[si+j] xor m[si+k];
        end;
  end;
end;

procedure solve(var m:TMat);
begin
for k:=1 to n do
  begin
  if m[k,k]=false then
    begin
    t:=0;
    for j:=k+1 to n do
      if m[k,j]=true then t:=j;
    if t<>0 then
      for i:=k to n+1 do
        m[i,k]:=m[i,k] xor m[i,t];
    end;
  for j:=k+1 to n do
    if m[k,j]=true then
      for i:=k to n+1 do
        m[i,j]:=m[i,j] xor m[i,k];
  end;
for k:=n downto 1 do
  begin
  for j:=k-1 downto 1 do
    if m[k,j]=true then
      for i:=k to n+1 do
        m[i,j]:=m[i,j] xor m[i,k];
  end;
end;

procedure make(var min,mout:TMat);
begin
for j:=1 to n do
  mout[1,j]:=min[n+1,j];
for i:=2 to n do
  for j:=1 to n do
    mout[i,j]:=not(mout[i-1,j-1] xor mout[i-1,j] xor mout[i-1,j+1] xor mout[i-2,j]);
end;

begin
//CreateWin(m,m);
for n:=1 to m do
  begin
  v:=DWord(1 shl (n and 31));
  write('i');
  initme(me);
  initmf(mf);
  init(ma);
  init(mb);
  init(mb);
  initE(mb);
  write('c');
  for l:=0 to n-1 do
    calc(ma,mb,mc);
  write('s');
  solve(mb);
  write('u');
  unpack(mb,mq);
  write('m');
  make(mq,mp);
  write('p');
  //printPNG(mp);
  write('#');
  writeln(n);
  end;
end.
