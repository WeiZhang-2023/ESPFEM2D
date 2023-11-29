function par=mesh_quality(par,eNode,nCoor)
par.if_delaunay=0;
min_angle=180.;
for ie=1:par.element_cnt
    %% get element area
    nodeID=eNode(ie,:);
    x=nCoor(nodeID,:);
    area=x(1,1)*x(2,2)-x(2,1)*x(1,2)-x(1,1)*x(3,2)+x(3,1)*x(1,2)+x(2,1)*x(3,2)-x(3,1)*x(2,2);
    area=area*0.5;
    if area<0
        min_angle=-1;
    else
        % edge 0
        a=sqrt((x(2,1)-x(3,1))*(x(2,1)-x(3,1))+(x(2,2)-x(3,2))*(x(2,2)-x(3,2)));
        % edge 1
        b=sqrt((x(1,1)-x(3,1))*(x(1,1)-x(3,1))+(x(1,2)-x(3,2))*(x(1,2)-x(3,2)));
        % edge 2
        c=sqrt((x(1,1)-x(2,1))*(x(1,1)-x(2,1))+(x(1,2)-x(2,2))*(x(1,2)-x(2,2)));
        angle0=asind(2*area/c/b);
        if (angle0<min_angle); min_angle=angle0; end
        
        angle1=asind(2*area/a/c);
        if (angle1<min_angle); min_angle=angle1; end
        
        angle2=asind(2*area/b/a);
        if (angle2<min_angle); min_angle=angle2; end
    end
end
par.mesh_quality=min_angle;
end