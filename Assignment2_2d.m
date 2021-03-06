clear;
clc;

N=100;
si=10^-2;
for l=1:N
    V0=1;
    so=1;
    W=20;
    L=30;
    Wb=(2/5)*W;
    Lb=(1/3)*L;
    
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
    
    [X Y]=gradient(Emap);
    
    Ex=-X;
    Ey=-Y;
    
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
    
    % I = J*A; Suppose we are interested in the current coming out from the
    % right side of the conductor
    I=0;
    for i=1:W
        I=J(i,L)+I;
    end
    II(l)=I;
    sob(l)=si;
    
    fprintf('Current is %f --- (%i/%i)\n',I,l,N);
    si=si*0.1;
end
figure(1);
plot(sob,II);
title('Current vs sigma of the box');