data = xlsread('observation.xls');
x=data(:,2);
y=data(:,3);
y=1014-y;
z=data(:,4);
X=1:1:2518;
Y=1:1:1014;
[Xi,Yi]=meshgrid(X,Y);
Zi=griddata(x,y,z,Xi,Yi,'cubic');
%%mesh(Xi,Yi,Zi)
contourf(Xi,Yi,Zi)