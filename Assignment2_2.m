clear;
clc;

W=20;
L=30;
V0=1;
so=1;
si=10^-2;
Wb=8;
Lb=10;

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
        if (j>Lb && j<2*Lb) && (i<Wb || i>(W-Wb))
            sigma(i,j)=si;
        else
            sigma(i,j)=so;
        end
    end
end
figure(2);
surf(sigma);
    
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
            if i==1
                if j == Lb || j == 2*Lb
                    G(n,n)=-(1/(2*si)+1/(2*so))-2/so;
                    G(n,s)=1/so;
                    if j==Lb
                        G(n,a)=1/so;
                        G(n,d)=1/si;
                    else
                        G(n,a)=1/si;
                        G(n,d)=1/so;
                    end
                elseif j<Lb || j>2*Lb
                    G(n,s)=1/so;
                    G(n,n)=-3/so;
                    G(n,a)=1/so;
                    G(n,d)=1/so;          
                elseif j == Lb+1 || j == 2*Lb-1
                    G(n,n)=-(1/(2*si)+1/(2*so))-2/si;
                    G(n,s)=1/si;
                    if j==Lb
                        G(n,a)=1/so;
                        G(n,d)=1/si;
                    else
                        G(n,a)=1/si;
                        G(n,d)=1/so;
                    end
                else
                    G(n,s)=1/si;
                    G(n,n)=-3/si;
                    G(n,a)=1/si;
                    G(n,d)=1/si;
                end
            else
                if j == Lb || j == 2*Lb
                    G(n,n)=-(1/(2*si)+1/(2*so))-2/so;
                    G(n,w)=1/so;
                    if j==Lb
                        G(n,a)=1/so;
                        G(n,d)=1/si;
                    else
                        G(n,a)=1/si;
                        G(n,d)=1/so;
                    end
                elseif j<Lb || j>2*Lb
                    G(n,w)=1/so;
                    G(n,n)=-3/so;
                    G(n,a)=1/so;
                    G(n,d)=1/so;
                elseif j == Lb+1 || j == 2*Lb-1
                    G(n,n)=-(1/(2*si)+1/(2*so))-2/si;
                    G(n,w)=1/si;
                    if j==Lb
                        G(n,a)=1/so;
                        G(n,d)=1/si;
                    else
                        G(n,a)=1/si;
                        G(n,d)=1/so;
                    end      
                else
                    G(n,w)=1/si;
                    G(n,n)=-3/si;
                    G(n,a)=1/si;
                    G(n,d)=1/si;
                end
            end
        elseif i==Wb || i==(W-Wb)
            if i==Wb
                if j>Lb && j<2*Lb
                    G(n,s)=1/so;
                    G(n,w)=1/si;
                    G(n,n)=-3/so-(1/(2*si)+1/(2*so));
                    G(n,d)=1/so;
                    G(n,a)=1/so;            
                else 
                    G(n,a)=1/so;
                    G(n,n)=-4/so;
                    G(n,d)=1/so;
                    G(n,s)=1/so;
                    G(n,w)=1/so;
                end
            else
                if j > Lb && j < 2*Lb
                    G(n,s)=1/si;
                    G(n,w)=1/so;
                    G(n,n)=-3/so-(1/(2*si)+1/(2*so));
                    G(n,d)=1/so;
                    G(n,a)=1/so;        
                else
                    G(n,a)=1/so;
                    G(n,n)=-4/so;
                    G(n,d)=1/so;
                    G(n,s)=1/so;
                    G(n,w)=1/so;
                end
            end
        elseif i>Wb && i<(W-Wb)
            G(n,a)=1/so;
            G(n,n)=-4/so;
            G(n,d)=1/so;
            G(n,s)=1/so;
            G(n,w)=1/so;
        elseif i==Wb-1 || i==W-Wb+1
            if i==Wb-1
                if j == Lb || j == 2*Lb
                    G(n,n)=-3/so-(1/(2*si)+1/(2*so));
                    G(n,w)=1/so;
                    G(n,s)=1/so;
                    if j == Lb
                        G(n,a)=1/so;
                        G(n,d)=1/si;
                    else
                        G(n,a)=1/si;
                        G(n,d)=1/so;
                    end
                elseif j==Lb+1 || j==2*Lb-1
                    G(n,n)=-2/si-2*(1/(2*si)+1/(2*so));
                    G(n,w)=1/si;
                    G(n,s)=1/so;
                    if j==Lb+1
                        G(n,a)=1/so;
                        G(n,d)=1/si;
                    else
                        G(n,a)=1/si;
                        G(n,d)=1/so;
                    end
                elseif j>Lb+1 && j<2*Lb-1
                    G(n,n)=-3/si-(1/(2*si)+1/(2*so));
                    G(n,w)=1/si;
                    G(n,s)=1/so;
                    G(n,a)=1/si;
                    G(n,d)=1/si;
                else
                    G(n,n)=-4/so;
                    G(n,w)=1/so;
                    G(n,s)=1/so;
                    G(n,a)=1/so;
                    G(n,d)=1/so;
                end
            else
                if j == Lb || j == 2*Lb
                    G(n,n)=-3/so-(1/(2*si)+1/(2*so));
                    G(n,w)=1/so;
                    G(n,s)=1/so;
                    if j == Lb
                        G(n,a)=1/so;
                        G(n,d)=1/si;
                    else
                        G(n,a)=1/si;
                        G(n,d)=1/so;
                    end
                elseif j==Lb+1 || j==2*Lb-1
                    G(n,n)=-2/si-2*(1/(2*si)+1/(2*so));
                    G(n,w)=1/so;
                    G(n,s)=1/si;
                    if j==Lb+1
                        G(n,a)=1/so;
                        G(n,d)=1/si;
                    else
                        G(n,a)=1/si;
                        G(n,d)=1/so;
                    end
                elseif j>Lb+1 && j<2*Lb-1
                    G(n,n)=-3/si-(1/(2*si)+1/(2*so));
                    G(n,w)=1/so;
                    G(n,s)=1/si;
                    G(n,a)=1/si;
                    G(n,d)=1/si;
                else
                    G(n,n)=-4/so;
                    G(n,w)=1/so;
                    G(n,s)=1/so;
                    G(n,a)=1/so;
                    G(n,d)=1/so;
                end
            end
        else
            if j==Lb || j==2*Lb
                G(n,n)=-3/so-(1/(2*si)+1/(2*so));
                G(n,w)=1/so;
                G(n,s)=1/so;
                if j==Lb
                    G(n,a)=1/so;
                    G(n,d)=1/si;
                else
                    G(n,a)=1/si;
                    G(n,d)=1/so;
                end
            elseif j==Lb+1 || j==2*Lb-1
                G(n,n)=-3/si-1*(1/(2*si)+1/(2*so));
                G(n,w)=1/si;
                G(n,s)=1/si;
                if j==Lb+1
                    G(n,a)=1/so;
                    G(n,d)=1/si;
                else
                    G(n,a)=1/si;
                    G(n,d)=1/so;
                end
            elseif j<Lb || j>2*Lb
                G(n,n)=-4/so;
                G(n,w)=1/so;
                G(n,s)=1/so;
                G(n,a)=1/so;
                G(n,d)=1/so;
            else
                G(n,n)=-4/si;
                G(n,w)=1/si;
                G(n,s)=1/si;
                G(n,a)=1/si;
                G(n,d)=1/si;
            end
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
[X Y]=gradient(Emap);
Ex=-X;
Ey=-Y;
figure(5);
quiver(Ex,Ey);

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
figure(6);
quiver(Jx,Jy);