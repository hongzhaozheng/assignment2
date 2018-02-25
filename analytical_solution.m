% Analytical Solution
clear;
clc;

W=20;
L=30;
V0=1;
N=300;
V=zeros(W,L);

n=1;
b = L/2;
a = W;

x=linspace(-b,b,30);
y=linspace(0,a,20);
[xx,yy]=meshgrid(x,y);
figure(3);
for n = 1:2:N
    Vp =(4*V0/pi)*(1/n)*(cosh(n*pi*xx/a)/cosh(n*pi*b/a)).*(sin(n*pi*yy/a));   
    V =V + Vp ;
    mesh(V);
    pause(0.001)
end


