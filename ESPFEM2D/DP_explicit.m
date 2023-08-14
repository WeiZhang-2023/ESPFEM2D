function [sigma,dpdedt] = DP_explicit(sigma0,dedt,E,v,c,phi,psi)
K=E/(3*(1-2*v));
G=E/(2*(1+v));
alpha=(2*sind(phi))/(3^0.5*(3+sind(phi)));
k=(6*c*cosd(phi))/(3^0.5*(3+sind(phi)));
alpha_psi=(2*sind(psi))/(3^0.5*(3+sind(psi)));
if alpha<=1.e-6
    tenf=0;
else
    tenf=k/(3*alpha);
end
D=[(1-v)   v     v       0          0          0;...
    v   (1-v)   v       0          0          0;...
    v     v   (1-v)     0          0          0;...
    0     0     0   (1-2*v)/2      0          0;...
    0     0     0       0      (1-2*v)/2      0;...
    0     0     0       0          0      (1-2*v)/2];
dee=E/((1+v)*(1-2*v))*D;
sigma=sigma0+dee*dedt;
I1=sigma(1)+sigma(2)+sigma(3);
sigma(1)=sigma(1)-I1/3;
sigma(2)=sigma(2)-I1/3;
sigma(3)=sigma(3)-I1/3;
dpTi=I1/3-tenf;
if dpTi>=1.e-6
    dlamda=dpTi/K;
    I1=3*tenf;
end
J2=0.5*(sigma(1)^2+sigma(2)^2+sigma(3)^2+2*sigma(4)^2+2*sigma(5)^2+2*sigma(6)^2);
dpFi=J2^0.5+alpha*I1-k;
if dpFi>=1.e-6
    dlamda=dpFi/(G+9*K*alpha*alpha_psi);
    I1=I1-9*K*alpha_psi*dlamda;
    tau=k-alpha*I1+G*dlamda;
    if tau<1.e-10
        ratio=1.0;
    else
        ratio=(k-alpha*I1)/(k-alpha*I1+G*dlamda);
    end
    sigma(1)=sigma(1)*ratio;
    sigma(2)=sigma(2)*ratio;
    sigma(3)=sigma(3)*ratio;
    sigma(4)=sigma(4)*ratio;
    sigma(5)=sigma(5)*ratio;
    sigma(6)=sigma(6)*ratio;
end
sigma(1)=sigma(1)+I1/3;
sigma(2)=sigma(2)+I1/3;
sigma(3)=sigma(3)+I1/3;
C=1/E*[1,-v,-v,0,0,0;...
       -v,1,-v,0,0,0;...
       -v,-v,1,0,0,0;...
       0,0,0,2*(1+v),0,0;...
       0,0,0,0,2*(1+v),0;...
       0,0,0,0,0,2*(1+v)];
dedt_elas=C*(sigma-sigma0);
dpdedt=dedt-dedt_elas;
end