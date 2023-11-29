function [par,nCoor,nDisp,nVel,nStress,nPstrain_eq]=mesh_lap_smoothing(par,nCoor,nBoundT,nRNN,nRNs,nDisp,nVel,nStress,nPstrain_eq)
lap_smoothing_threshold=par.Lap_threshold*par.space;
for in=1:par.node_cnt
    % determine if smoothing
    nnode=nRNN(in,1);
    curx=nCoor(in,1);
    cury=nCoor(in,2);
    min_dis=1.e6;
    for t=1:nnode
        tnode=nRNs(in,t);
        if (tnode==in) continue; end
        tx=nCoor(tnode,1);
        ty=nCoor(tnode,2);
        cur_dis=((curx-tx)*(curx-tx)+(cury-ty)*(cury-ty))^0.5;
        if cur_dis<min_dis
            min_dis=cur_dis;
        end
    end
    if min_dis>lap_smoothing_threshold
        continue;
    end
    % smoothing
    coor=zeros(1,2);
    cnt=0;
    for t=1:nnode
        tnode=nRNs(in,t);
        if (tnode==in) continue; end
        coor=coor+nCoor(tnode,:);
        cnt=cnt+1;
    end
    coor_raw=coor/cnt;
    diff=coor_raw-nCoor(in,:);
    for i=1:2
        type=nBoundT(in,i);
        if (type==1) %velocity boundary
            diff(i)=0;
        end
    end
    nCoor(in,:)=nCoor(in,:)+diff;
end