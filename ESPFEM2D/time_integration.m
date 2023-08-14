function [nVel,nDisp,nCoor]=time_integration(par,nMat,nArea,nBoundT,nBoundV,nVel,nDisp,nCoor,nFint,nFhg)
for in=1:par.node_cnt    
    mat=nMat(in);
    rho=par.mat_props(mat,1);
    mass=nArea(in)*rho;
    for i=1:2
        gravity=par.mat_gravity(mat,i);
        type=nBoundT(in,i);
        value=nBoundV(in,i);
        if (type==1) %velocity boundary
            nVel(in,i)=value;
        else
            force=-nFint(in,i);
            %gravity
            force=force+gravity*mass;
            if (type==3) %force boundary
                force=force+value;
            end
            if (par.hour_glass_alpha>1.e-6) %hourglass control force
                force=force+nFhg(in,i);
            end
            if nVel(in,i)>=0 %damping
                force=force-abs(force)*par.damping;
            else
                force=force+abs(force)*par.damping;
            end
            nVel(in,i)=nVel(in,i)+force/mass*par.dtime*1.0;
        end
    end
end
nDisp=nDisp+nVel*par.dtime;
nCoor=nCoor+nVel*par.dtime;
end