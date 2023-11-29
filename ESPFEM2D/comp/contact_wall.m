function [par,nVel,nDisp,nCoor]=contact_wall(par,nCoor,nMat,nArea,nVel,nDisp)
for iwall=1:par.rigid_wall
    wall=par.wall(iwall,:);
    coor1=wall(1:2);
    coor2=wall(3:4);
    mu=wall(5); %frictional coefficient
    wall_vel=[0.,0.];
    for in=1:par.node_cnt
        vector12=coor2-coor1;
        mag_vector12=norm(vector12);
        vector12=vector12/mag_vector12;
        vector_n=[-vector12(2),vector12(1)];
        vector1s=nCoor(in,:)-coor1;
        gap=dot(vector1s,vector_n);
        if (gap>-1.e-6) continue; end
        mat=nMat(in);
        rho=par.mat_props(mat,1);
        mp=nArea(in)*rho;
        vp=nVel(in,:)-wall_vel;
        fc=-mp*vp/par.dtime;
        if mu<1.%frictional contact
            fn=dot(fc,vector_n)*vector_n;
            ft=fc-fn;
            ft_mag=norm(ft);
            fn_mag=norm(fn);
            if(ft_mag>mu*fn_mag)ft=ft*mu*fn_mag/ft_mag;end
            fc=ft+fn;
        end
        vel_correction=fc*par.dtime/mp;
        nVel(in,:)=nVel(in,:)+vel_correction;
        nDisp(in,:)=nDisp(in,:)+vel_correction*par.dtime;
        nCoor(in,:)=nCoor(in,:)+vel_correction*par.dtime;  
    end
end
end