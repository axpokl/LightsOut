program diandeng;
uses display;
const maxn=500;
var
    am0,al1,al2,ar1,ar2:packed array[1..maxn,1..maxn,1..maxn]of boolean;
    am:packed array[1..maxn*maxn]of boolean;
    //a:packed array[1..maxn*maxn,1..maxn*maxn+1]of boolean;
    i,j,k,l:longint;
    h,w,m,t:longint;
    s:longint;

             {
procedure output;
begin
append(f);
writeln(f,'#####################');
for i:=1 to m do
  begin
  if a[i,m+1]=0 then write(f,'　') else write(f,'█');
  if (i mod w=0) then writeln(f);
  end;
close(f);
end;          }

const ac:array[boolean]of longword=(black,white);
var ax,ay,bx,by:longint;

function a(x,y:longint):boolean;
begin
a:=false;
ax:=(x-1)div w+1;
ay:=(y-1)div h+1;
bx:=(x-1)mod w+1;
by:=(y-1)mod h+1;
if ay-ax=-2 then a:=al2[ax,bx,by];
if ay-ax=-1 then a:=al1[ax,bx,by];
if ay-ax=+0 then a:=am0[ax,bx,by];
if ay-ax=+1 then a:=ar1[ax,bx,by];
if ay-ax=+2 then a:=ar2[ax,bx,by];
if y=m+1 then a:=am[x];
end;

procedure a(x,y:longint;b:boolean);
begin
ax:=(x-1)div w+1;
ay:=(y-1)div h+1;
bx:=(x-1)mod w+1;
by:=(y-1)mod h+1;
if ay-ax=-2 then al2[ax,bx,by]:=b;
if ay-ax=-1 then al1[ax,bx,by]:=b;
if ay-ax=+0 then am0[ax,bx,by]:=b;
if ay-ax=+1 then ar1[ax,bx,by]:=b;
if ay-ax=+2 then ar2[ax,bx,by]:=b;
if y=m+1 then am[x]:=b;
end;

procedure outputall();
var i,j:longword;
begin
k:=5;
for j:=1 to m do
  for i:=1 to m+1 do
    SetPixel(i,j,ac[a(j,i)]);
//bar(i*k,j*k,k,k,ac[a(j,i)]);
while IsNextMsg do ;
freshwin();
end;

procedure outputpng();
var i:longword;
var b:pbitmap;
begin
for i:=1 to m do SetPixel((i-1)mod w,(i-1)div w,ac[a(i,m+1)]);
while IsNextMsg do ;
freshwin();
b:=CreateBMP(w,h);
DrawBMP(_pmain,b,0,0,w,h,0,0,w,h);
SaveBMP(b,'png/'+i2s(w)+'.png');
ReleaseBMP(b);
end;

begin
//assign(f,'diandeng.txt');
//rewrite(f);
//close(f);
createwin(maxn,maxn);
for k:=1 to maxn do
  begin
  writeln('start: ',k);
  w:=k;
  h:=k;
  m:=w*h;
//从这里开始设置线性方程组阵。
//将灯阵排成一条行，即1到25=m。
//j列代表按钮，i行代表灯。
//a[i,j]=1代表按动第j个按钮会打开第i个灯。
//将所有按钮在这里设置（按钮也是1到25=m）。
  for i:=1 to m do
    for j:=max(1,i-w-w) to min(i+w+w,m) do
      begin
      l:=i-j;
      if (l=0)
      or ((l=-1) and not(j mod w=1))
      or ((l=1) and not(j mod w=0))
      or (l=w)
      or (l=-w)
      then
        a(i,j,true)
      else
        a(i,j,false);
      end;
//这条语句设置矩阵的初始状态。
//a[i,m+1]中的i代表第i个灯。
  for i:=1 to m do
    a(i,m+1,true);
//从这里开始解线性方程组。下面的部分不用修改。
write('@');
  for j:=1 to m do
    begin
//outputall();waitkey();
while IsNextMsg do
    t:=j;
    if a(j,j)=false then
      begin
      for i:=min(j+h,m) downto j+1 do
        if a(i,j)=true then t:=i;
      if t<>0 then
        begin
        for l:=j to min(j+w+w,m) do
          a(j,l,a(t,l) xor a(j,l));
        l:=m+1;
          a(j,l,a(t,l) xor a(j,l));
        end;
      end;
while IsNextMsg do ;
    for i:=j+1 to min(j+h,m) do
      if a(i,j)=true then
        begin
        for l:=j to min(j+w+w,m) do
          a(i,l,a(j,l) xor a(i,l));
        l:=m+1;
          a(i,l,a(j,l) xor a(i,l));
        end;
    end;
write('#');
//  outputpng();
  for j:=m downto 1 do
    begin
//outputall();waitkey();
while IsNextMsg do ;
    for i:=j-1 downto max(j-h-h,1) do
      if a(i,j)=true then
        begin
        l:=j;
          a(i,l,a(j,l) xor a(i,l));
        l:=m+1;
          a(i,l,a(j,l) xor a(i,l));
        end;
    end;
write('$');
  outputpng();
//线性方程组解完，下面计算矩阵的秩。
  s:=0;
  for i:=1 to m do if a(i,i)=false then s:=s+1;
//s=n代表方程组还有n个未知量，则方程有2^n个解。
//  append(f);
//  writeln(f,k:5,s:15);
//  close(f);
end;
writeln('end');
readln();
end.
