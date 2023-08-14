function  nFhg=force_hourglass(par,nRNN,nRNs,nMat,nArea,nCoor,nVel,nF)
nFhg=zeros(par.node_cnt,2);
for in=1:par.node_cnt
    nnode=nRNN(in);
    if nnode==0  %isoliated node
        continue;
    end
    f_hg=zeros(2,1);
    mat=nMat(in);
    Ei=par.mat_props(mat,2);
    F=zeros(2,2);
    F(1,1)=nF(in,1);
    F(1,2)=nF(in,2);
    F(2,1)=nF(in,3);
    F(2,2)=nF(in,4);
    for i = 1:nnode
        curnode=nRNs(in,i);
        mat=nMat(in);
        Ej=par.mat_props(mat,2);
        if(in~=curnode)
            xi_xj=nCoor(curnode,:)'-nCoor(in,:)';
            xi_xj_0=xi_xj-(nVel(curnode,:)'-nVel(in,:)')*par.dtime;
            lpij=norm(xi_xj);
            lpij0=norm(xi_xj_0);
            if (lpij>1.e-12 && lpij0>1.e-12)
                xij_i=F *xi_xj_0;
                epsilon_ij_i=xij_i-xi_xj;
                Fj=zeros(2,2);
                Fj(1,1)=nF(curnode,1);
                Fj(1,2)=nF(curnode,2);
                Fj(2,1)=nF(curnode,3);
                Fj(2,2)=nF(curnode,4);
                xij_j=Fj*xi_xj_0;
                epsilon_ij_j=xij_j-xi_xj;
                f_hg=f_hg-0.5*par.hour_glass_alpha*xi_xj/lpij^2/lpij0^2*...
                    (Ei*nArea(in)*dot(epsilon_ij_i,xi_xj)+Ej*nArea(curnode)*dot(epsilon_ij_j,xi_xj));
            end
        end
    end
    nFhg(in,:)=f_hg;
end
end