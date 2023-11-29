function [nArea,nDNdx,nDNdy]=node_data_prepare(par,nREN,nREs,nRNN,nRNs,eNode,eArea,eDNdx,eDNdy)
nArea=zeros(par.node_cnt,1);
nDNdx=zeros(par.node_cnt,par.MN*3);
nDNdy=zeros(par.node_cnt,par.MN*3);
for in=1:par.node_cnt
    cur_node_area=0.;
    related_element_cnt=nREN(in);
    related_node_cnt=nRNN(in);
    if related_element_cnt==0 %isoliated node
        nArea(in,1)=1.e-9;
        nDNdx(in,:)=zeros(1,par.MN*3);
        nDNdy(in,:)=zeros(1,par.MN*3);
        continue;
    end
    dNdx=zeros(1,related_node_cnt);
    dNdy=zeros(1,related_node_cnt);
    related_nodes=nRNs(in,:);
    for i=1:related_element_cnt
        curelem=nREs(in,i);
        curarea=eArea(curelem)*0.333333333333333;
        cur_node_area = cur_node_area+curarea;
        for j = 1:3
            curnode=eNode(curelem,j);
            curdNdx=eDNdx(curelem,j);
            curdNdy=eDNdy(curelem,j);
            cur_node_ID=find(related_nodes==curnode);
            dNdx(cur_node_ID)=dNdx(cur_node_ID)+curdNdx*curarea;
            dNdy(cur_node_ID)=dNdy(cur_node_ID)+curdNdy*curarea;
        end
    end
    nArea(in)=cur_node_area;
    cur_dNdx=zeros(1,par.MN*3);
    cur_dNdy=zeros(1,par.MN*3);
    cur_dNdx(1:related_node_cnt)=dNdx/cur_node_area;
    cur_dNdy(1:related_node_cnt)=dNdy/cur_node_area;
    nDNdx(in,:)=cur_dNdx;
    nDNdy(in,:)=cur_dNdy;
end
end