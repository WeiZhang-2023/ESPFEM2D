function [eNode] = mesh_alpha_shape(nCoor,tri_raw,par)
pEN_raw=size(tri_raw,1);
ifsave=zeros(pEN_raw,1);
pASs = par.alpha_shape;
pASs(:,2)=pASs(:,2)*par.space;
for ie=1:pEN_raw
    ifsave(ie,1)=1;
    curnode=tri_raw(ie,1);
    x0=nCoor(curnode,1);
    y0=nCoor(curnode,2);
    curnode=tri_raw(ie,2);
    x1=nCoor(curnode,1);
    y1=nCoor(curnode,2);
    curnode=tri_raw(ie,3);
    x2=nCoor(curnode,1);
    y2=nCoor(curnode,2);
    area=x0*y1-x1*y0-x0*y2+x2*y0+x1*y2-x2*y1;
    area=area*0.5;
    a=sqrt((x1-x0)*(x1-x0)+(y1-y0)*(y1-y0));
    b=sqrt((x2-x1)*(x2-x1)+(y2-y1)*(y2-y1));
    c=sqrt((x0-x2)*(x0-x2)+(y0-y2)*(y0-y2));
    %for regular tri_rawangle
    if (abs(area)>1.e-12)
        radius=a*b*c/(4*area);
        xcen=(x0+x1+x2)/3.;
        ycen=(y0+y1+y2)/3.;
    else
        ifsave(ie,1)=0;
        continue;
    end
    for i=1:size(pASs,1) % alpha_shape_cnt
        ref_node=pASs(i,1); % ashape_ref_node
        x_ref=nCoor(ref_node,1);
        y_ref=nCoor(ref_node,2);
        x_minus=pASs(i,3); % ashape_x_minus
        x_add=pASs(i,4);   % ashape_x_add
        y_minus=pASs(i,5); % ashape_y_minus
        y_add=pASs(i,6);   % ashape_y_add
        ref_radius=pASs(i,2); % ashape_radius  
        if (xcen< x_ref+x_add) && (ycen<y_ref+y_add)...
                && (xcen>x_ref+x_minus) && (ycen>y_ref+y_minus)...
                && (radius>ref_radius)
            ifsave(ie,1) = 0;   % delete current element
        end
    end
end
pEN=sum(ifsave);
if pEN==0
    disp('Error! mesh_alpha_shape: There is no element in the new mesh!');
    pause;
else
    cnt =0;
    eNode=zeros(pEN,3);
    for ie=1:pEN_raw
        if ifsave(ie,1)==1
            cnt=cnt + 1;
            eNode(cnt,1)=tri_raw(ie,1);
            eNode(cnt,2)=tri_raw(ie,2);
            eNode(cnt,3)=tri_raw(ie,3);
        end
    end
end
disp(['Alpha shape performed! Before: ',num2str(pEN_raw),' After: ', num2str(pEN)]);