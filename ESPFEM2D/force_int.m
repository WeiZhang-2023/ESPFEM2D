function [nFint,nStress,nPstrain_eq,nF]=...
    force_int(par,nRNN,nRNs,nArea,nMat,nDNdx,nDNdy,nVel,nStress,nPstrain_eq)
nFint=zeros(par.node_cnt,2);
nF=zeros(par.node_cnt,4);
alpha=1.0;
for in=1:par.node_cnt
    nnode=nRNN(in);
    mat=nMat(in,1);
    mat_model=par.mat_model(mat);
    mat_props=par.mat_props(mat,:);
    dudx =zeros(1,4); 
    for i=1:nnode
        curnode=nRNs(in,i);
        ddisp=nVel(curnode,:)*par.dtime;
        dudx(1)=dudx(1)+nDNdx(in,i)*ddisp(1);
        dudx(2)=dudx(2)+nDNdy(in,i)*ddisp(1);
        dudx(3)=dudx(3)+nDNdx(in,i)*ddisp(2);
        dudx(4)=dudx(4)+nDNdy(in,i)*ddisp(2);
    end
    dstrain = zeros(4,1);
    dstrain(1)=dudx(1);
    dstrain(2)=dudx(4);
    dstrain(3)=dudx(2)+dudx(3);
    if (par.hour_glass_alpha>1.e-6)
        nF(in,1)=dudx(1)+1.;
        nF(in,2)=dudx(2);
        nF(in,3)=dudx(3);
        nF(in,4)=dudx(4)+1.;
    end 
    stress=nStress(in,:)';
    pstrain_eq=nPstrain_eq(in,1);
    [stress,dpstrain_eq]=constitutive_model(mat_model,mat_props,stress,dstrain,pstrain_eq);
    nPstrain_eq(in,1)=nPstrain_eq(in,1)+dpstrain_eq;
    nStress(in,:)=stress';
    %calculate force_int
    for i=1:nnode
        bee=zeros(4,2);
        bee(1,1)=nDNdx(in,i);
        bee(2,2)=nDNdy(in,i);
        bee(3,1)=bee(2,2);
        bee(3,2)=bee(1,1);
        fint=bee'*stress*nArea(in);
        curnode=nRNs(in,i);
        nFint(curnode,:)=nFint(curnode,:)+fint(:)'*alpha;
    end
end
end