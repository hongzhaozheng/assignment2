clear;
clc;

W=20;
L=30;
V0=1;
G=sparse(W*L,W*L);

%n:i,j  
%nl:i,j-1    
%nr:i,j+1
for i=1:(W*L)
    if i <= W || i > (L-1)*W
        G(i,i)=1;
    end
end

for j=2:(L-1)
    for i=1:W
        n = i+(j-1)*W;
        a= i+(j-2)*W;
        d= i+j*W;
        w= (i-1)+(j-1)*W;
        s= (i+1)+(j-1)*W;
        if i==1||i==W
            G(n,n)=1;
        else
            G(n,a)=1;
            G(n,n)=-4;
            G(n,d)=1;
            G(n,s)=1;
            G(n,w)=1;
        end      
    end
end
figure(1);
spy(G);

F=sparse(W*L,1);
for i=1:(W*L)
    if i <= W || i > (L-1)*W
        F(i,1)=V0;
    end
end

V=G\F;

for i=1:W
    for j=1:L
        n=i+(j-1)*W;
        Emap(i,j) = V(n);
    end
end
figure(2);
mesh(Emap);

% Analytical Solution
N=300;
Vas=zeros(W,L);
b = L/2;
a = W;
x=linspace(-b,b,30);
y=linspace(0,a,20);
[xx,yy]=meshgrid(x,y);
figure(3);
for n = 1:2:N
    Vp =(4*V0/pi)*(1/n)*(cosh(n*pi*xx/a)/cosh(n*pi*b/a)).*(sin(n*pi*yy/a));   
    Vas =Vas + Vp ;
    mesh(Vas);
    % pause(0.01);
end

