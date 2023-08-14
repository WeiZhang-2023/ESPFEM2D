function [par,eNode,nREN,nREs,nRNN,nRNs,nDisp,nPstrain_eq,nF,nFhg]=initializing(par,nCoor)
% generate mesh
disp('generating mesh... ');
tri_raw=delaunay(nCoor(:,1),nCoor(:,2));
% alpha shape
[eNode]=mesh_alpha_shape(nCoor, tri_raw, par);
par.element_cnt=size(eNode,1);
% get related infos
[nREN,nREs,nRNN,nRNs]=mesh_get_related_element_node(par,eNode,nCoor);
nDisp=zeros(par.node_cnt,2);
nPstrain_eq=zeros(par.node_cnt,1);
nF=zeros(par.node_cnt,4);
nFhg=zeros(par.node_cnt,2);
end