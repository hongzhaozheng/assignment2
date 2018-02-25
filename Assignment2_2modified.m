clear;
clc;


W=20;
L=30;
V0=1;
so=1;
si=10^-2;
% si = 1;
Wb=(2/5)*W;
Lb=(1/3)*L;

figure(1);
xlim([0 L]);
ylim([-W 0]);

%block definition
line([Lb Lb],[0 -Wb]);
line([Lb Lb],[-W Wb-W]);
line([2*Lb 2*Lb],[0 -Wb]);
line([2*Lb 2*Lb],[-W Wb-W]);
line([Lb 2*Lb],[-Wb -Wb]);
line([Lb 2*Lb],[Wb-W Wb-W]);


for i=1:W
    for j=1:L
        n = i+(j-1)*W;
        if (j>Lb && j<2*Lb) && (i<Wb || i>(W-Wb))
            sigma(i,j)=si;
        else
            sigma(i,j)=so;
        end
        sigmaV(n) = sigma(i,j);
    end
end


figure(2);
surf(sigma);
title('sigma(x,y)');

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
        
        if i==1
            G(n,s)=1/(1/sigma(n) + 1/sigma(s));
            G(n,a)=1/(1/sigma(n) + 1/sigma(a));
            G(n,d)=1/(1/sigma(n) + 1/sigma(d));
            G(n,n)=-(G(n,s) + G(n,a) + G(n,d));
        elseif i==W
            G(n,w)=1/(1/sigma(n) + 1/sigma(w));
            G(n,a)=1/(1/sigma(n) + 1/sigma(a));
            G(n,d)=1/(1/sigma(n) + 1/sigma(d));
            G(n,n)=-(G(n,w) + G(n,a) + G(n,d));
        else
            G(n,s)=1/(1/sigma(n) + 1/sigma(s));
            G(n,w)=1/(1/sigma(n) + 1/sigma(w));
            G(n,a)=1/(1/sigma(n) + 1/sigma(a));
            G(n,d)=1/(1/sigma(n) + 1/sigma(d));
            G(n,n)=-(G(n,w) + G(n,a) + G(n,d) + G(n,s));
        end
        
    end
end
figure(3);
spy(G);
F=sparse(W*L,1);

for i=1:(W*L)
    if i <= W
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

figure(4);
mesh(Emap);
title('V(x,y)');

[X Y]=gradient(Emap);

Ex=-X;
Ey=-Y;

figure(5);
surf(Ex);
title('Ex');


figure(6);
surf(Ey);
title('Ey');


figure(7);
quiver(Ex,Ey);
title('E(x,y)');

for i=1:W
    for j=1:L
        if (j>Lb && j<2*Lb) && (i<Wb || i>(W-Wb))
            Jx=Ex*si;
            Jy=Ey*si;
        else
            Jx=Ex*so;
            Jy=Ey*so;
        end
    end
end
J=sqrt(Jx.*Jx+Jy.*Jy);

figure(8);
quiver(Jx,Jy);
title('J(x,y)');

% I = J*A; Suppose we are interested in the current coming out from the
% right side of the conductor
I=0;
for i=1:W
    I=J(i,L)+I;
end
fprintf('Current is %f\n',I);


