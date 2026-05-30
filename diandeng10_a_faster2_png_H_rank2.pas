{$define disp}
program diandeng;

{$ifdef disp}
uses display;
{$endif}

const m=1000;

type TMat=array[-1..m,-1..m]of Boolean;

var n:longword;
var a,l,r,t:TMat;
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
    l[j,i]:=l[j,i] xor a[j-1,i];
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
var
 v:array[0..m-1,0..m-1]of Boolean;
 Cmat,Fmat:array[0..m-1,0..m-1]of Boolean;
 cvec,pvec,col,bvec,xvec:array[0..m-1]of Boolean;
 prev2,prev1,cura,chi,r0a,r1a,r2a,s0a,s1a,s2a,t0a,t1a,t2a,qpoly,qs1,qt1,tmp:array[0..m]of Boolean;
 ii,jj,kk,deg_r1,deg_r2,db,sh,k,def,ri,dj:longint;
 left,right,s:boolean;
begin
 def:=rank(n);
 k:=n-def;
 for jj:=0 to k-1 do for ii:=0 to k-1 do v[jj,ii]:=false;
 v[0,0]:=true;
 for jj:=1 to k-1 do
  for ii:=0 to k-1 do
   begin
    left:=false;
    if ii>0 then if v[jj-1,ii-1] then left:=true;
    right:=false;
    if ii<k-1 then if v[jj-1,ii+1] then right:=true;
    v[jj,ii]:=left xor right;
   end;
 for ii:=0 to k-1 do cvec[ii]:=l[ii,0];
 for ii:=0 to k-1 do pvec[ii]:=false;
 for ii:=k-1 downto 0 do
  begin
   s:=cvec[ii];
   for jj:=ii+1 to k-1 do if v[jj,ii] and pvec[jj] then s:=s xor true;
   pvec[ii]:=s;
  end;
 for ii:=0 to k do begin prev2[ii]:=false; prev1[ii]:=false; end;
 prev2[0]:=true;
 if k>0 then prev1[1]:=true;
 if k=1 then for ii:=0 to k do chi[ii]:=prev1[ii] else
  begin
   for kk:=2 to k do
    begin
     for ii:=0 to k do cura[ii]:=false;
     for ii:=0 to k-1 do if prev1[ii] then cura[ii+1]:=cura[ii+1] xor true;
     for ii:=0 to k do if prev2[ii] then cura[ii]:=cura[ii] xor true;
     for ii:=0 to k do begin prev2[ii]:=prev1[ii]; prev1[ii]:=cura[ii]; end;
    end;
   for ii:=0 to k do chi[ii]:=prev1[ii];
  end;
 for ii:=0 to k do
  begin
   r0a[ii]:=false;
   r1a[ii]:=false;
   r2a[ii]:=false;
   s0a[ii]:=false;
   s1a[ii]:=false;
   s2a[ii]:=false;
   t0a[ii]:=false;
   t1a[ii]:=false;
   t2a[ii]:=false;
   qpoly[ii]:=false;
   qs1[ii]:=false;
   qt1[ii]:=false;
   tmp[ii]:=false;
  end;
 for ii:=0 to k-1 do r0a[ii]:=pvec[ii];
 for ii:=0 to k do r1a[ii]:=chi[ii];
 s0a[0]:=true;
 t1a[0]:=true;
 while true do
  begin
   deg_r1:=-1;
   for ii:=k downto 0 do if r1a[ii] then begin deg_r1:=ii; break; end;
   if deg_r1<0 then break;
   for ii:=0 to k do begin qpoly[ii]:=false; r2a[ii]:=r0a[ii]; end;
   db:=deg_r1;
   while true do
    begin
     deg_r2:=-1;
     for ii:=k downto 0 do if r2a[ii] then begin deg_r2:=ii; break; end;
     if (deg_r2<db) or (deg_r2<0) then break;
     sh:=deg_r2-db;
     qpoly[sh]:=qpoly[sh] xor true;
     for ii:=0 to k do tmp[ii]:=false;
     for ii:=0 to k-sh do if r1a[ii] then tmp[ii+sh]:=tmp[ii+sh] xor true;
     for ii:=0 to k do r2a[ii]:=r2a[ii] xor tmp[ii];
    end;
   for ii:=0 to k do qs1[ii]:=false;
   for sh:=0 to k do if qpoly[sh] then for ii:=0 to k-sh do if s1a[ii] then qs1[ii+sh]:=qs1[ii+sh] xor true;
   for ii:=0 to k do s2a[ii]:=s0a[ii] xor qs1[ii];
   for ii:=0 to k do qt1[ii]:=false;
   for sh:=0 to k do if qpoly[sh] then for ii:=0 to k-sh do if t1a[ii] then qt1[ii+sh]:=qt1[ii+sh] xor true;
   for ii:=0 to k do t2a[ii]:=t0a[ii] xor qt1[ii];
   for ii:=0 to k do begin r0a[ii]:=r1a[ii]; r1a[ii]:=r2a[ii]; end;
   for ii:=0 to k do begin s0a[ii]:=s1a[ii]; s1a[ii]:=s2a[ii]; end;
   for ii:=0 to k do begin t0a[ii]:=t1a[ii]; t1a[ii]:=t2a[ii]; end;
  end;
 for ii:=0 to k-1 do col[ii]:=false;
 for jj:=0 to k-1 do if s0a[jj] then for ii:=0 to k-1 do if v[jj,ii] then col[ii]:=col[ii] xor true;
 for ii:=0 to k-1 do r[0,ii]:=col[ii];
 for ii:=k to n-1 do r[0,ii]:=false;
 for jj:=1 to k-1 do
  for ii:=0 to k-1 do
   begin
    s:=false;
    if ii>0 then s:=s xor r[jj-1,ii-1];
    if ii<k-1 then s:=s xor r[jj-1,ii+1];
    if jj>=2 then s:=s xor r[jj-2,ii];
    r[jj,ii]:=s;
   end;
 for jj:=0 to k-1 do for ii:=k to n-1 do r[jj,ii]:=false;
 if def>0 then
  begin
   for ii:=0 to k-1 do
    for jj:=0 to def-1 do
     Cmat[ii,jj]:=l[ii,k+jj];
   for ii:=0 to k-1 do
    for jj:=0 to def-1 do
     begin
      s:=false;
      for kk:=0 to k-1 do if r[ii,kk] and Cmat[kk,jj] then s:=s xor true;
      Fmat[ii,jj]:=s;
     end;
   for dj:=0 to def-1 do
    begin
     ri:=k+dj;
     for ii:=0 to k-1 do r[ri,ii]:=Fmat[ii,dj];
     for ii:=0 to def-1 do r[ri,k+ii]:=(ii=dj);
    end;
  end;
 for ii:=0 to n-1 do bvec[ii]:=l[ii,-1];
 for ii:=0 to n-1 do
  begin
   s:=false;
   for jj:=0 to n-1 do if r[ii,jj] and bvec[jj] then s:=s xor true;
   xvec[ii]:=s;
  end;
 for ii:=0 to n-1 do l[ii,-1]:=xvec[ii];
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
    t[j,i]:=not(t[j-1,i-1] xor t[j-1,i] xor t[j-1,i+1] xor t[j-2,i]) xor a[j-1,i];
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
