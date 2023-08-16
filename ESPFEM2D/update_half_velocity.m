function [nVel,nDisp,nCoor]=update_half_velocity(par,nBoundT,nBoundV,nVel,nAccel,nDisp,nCoor)
for in=1:par.node_cnt
    for i=1:2
        type=nBoundT(in,i);
        value=nBoundV(in,i);
        if (type==1) %velocity boundary
            nVel(in,i)=value;
        else
            nVel(in,i)=nVel(in,i)+nAccel(in,i)*par.dtime*0.5;
        end
    end
end
nDisp=nDisp+nVel*par.dtime;
nCoor=nCoor+nVel*par.dtime;
end