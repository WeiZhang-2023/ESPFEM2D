function [nREN,nREs,nRNN,nRNs]=mesh_get_related_element_node(par,eNode,nCoor)
% related elements
nREN=zeros(par.node_cnt,1);
nREs=zeros(par.node_cnt,par.MN);
for ie=1:par.element_cnt
    nodeID=eNode(ie,:);
    for j=1:3
        curnode=nodeID(j);
        nREN(curnode)=nREN(curnode)+1;
        if nREN(curnode)>par.MN
            disp(['Error! mesh_get_related_element_node: number of related element is larger than MN, node ID = ',num2str(curnode)]);
            pause;
        else
            nREs(curnode,nREN(curnode))=ie;
        end
    end
end
% related nodes
nRNN=zeros(par.node_cnt,1);
nRNs=zeros(par.node_cnt,par.MN*3);
for in=1:par.node_cnt
    temp=zeros(1,par.MN);
    cnt=0;
    if nREN(in)==0
        nRNN(in,1)=0;
        nRNs(in,:) =zeros(1,par.MN*3);
        continue;
    end
    for t=1:nREN(in)
        if cnt+3>par.MN*3
            disp(['Error! mesh_get_related_element_node: nodeID=',num2str(in),', number of related nodes is larger than MM*3']);
            pause;
        else
            curelement=nREs(in,t);
            temp(cnt+1)=eNode(curelement,1);
            temp(cnt+2)=eNode(curelement,2);
            temp(cnt+3)=eNode(curelement,3);
            cnt=cnt+3;
        end
    end
    cur_related_node=unique(temp(1:cnt));
    cur_related_node_cnt=length(cur_related_node);
    temp=zeros(1,par.MN*3);
    temp(1,1:cur_related_node_cnt)=cur_related_node;
    nRNN(in,1)=cur_related_node_cnt;
    nRNs(in,:)=temp;
end
end