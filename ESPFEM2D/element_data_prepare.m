function [eArea,eDNdx,eDNdy]=element_data_prepare(nCoor,par,eNode)
eArea=zeros(par.element_cnt,1);
eDNdx=zeros(par.element_cnt,3);
eDNdy=zeros(par.element_cnt,3);
for ie=1:par.element_cnt
    nodeID=eNode(ie,:);
    x=zeros(3,2);
    for t=1:3
        x(t,:)=nCoor(nodeID(t),:);
    end
    area=x(1,1)*x(2,2)-x(2,1)*x(1,2)-x(1,1)*x(3,2)+x(3,1)*x(1,2)+x(2,1)*x(3,2)-x(3,1)*x(2,2);
    area=area*0.5;
    x1=0.;x2=0.;y1=0.;y2=0.;
    for j=1:3
        switch j
            case 1
                x1=x(2,1);	y1=x(2,2);
                x2=x(3,1);	y2=x(3,2);
            case 2
                x1=x(3,1);	y1=x(3,2);
                x2=x(1,1);	y2=x(1,2);
            case 3
                x1=x(1,1);	y1=x(1,2);
                x2=x(2,1);	y2=x(2,2);
        end
        b=y1-y2;
        c=x2-x1;
        eDNdx(ie,j)=b/(2*area);
        eDNdy(ie,j)=c/(2*area);
    end
    eArea(ie)=area;
end
end