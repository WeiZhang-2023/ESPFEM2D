function [par,nCoor,nMat,nBoundT,nBoundV,nREN,nREs,nRNN,nRNs,nDisp,nVel,nStress,nPstrain_eq,eNode]...
    =mesh_remesh(par,nCoor,nMat,nBoundT,nBoundV,nREN,nREs,nRNN,nRNs,nDisp,nVel,nStress,nPstrain_eq,eNode)
%% determine if remesh
par=mesh_quality(par,eNode,nCoor);
if par.mesh_quality<par.remesh_threshold %too distorted mesh
    par.if_remesh_now=1;
else
    par.if_remesh_now=0;
end
if par.if_remesh_now == 0
    return;
end
plot_mesh(nCoor,eNode,1);
hold on
title(['istep = ',num2str(par.istep),' curtime =',num2str(par.ctime), ' before remeshing']);
%% remesh
% re-triangulation
tri_raw=delaunay(nCoor(:,1),nCoor(:,2));
% alpha shape
[eNode]=mesh_alpha_shape(nCoor,tri_raw,par);
par.element_cnt=size(eNode,1);
% get related infos
[nREN,nREs,nRNN,nRNs]=mesh_get_related_element_node(par,eNode,nCoor);
% Laplacian smoothing
[par,nCoor,nDisp,nVel,nStress,nPstrain_eq]=mesh_lap_smoothing(par,nCoor,nBoundT,nRNN,nRNs,nDisp,nVel,nStress,nPstrain_eq);
%% adjust remeshing threshold
par=mesh_quality(par,eNode,nCoor);
par.remesh_threshold=par.mesh_quality-par.remesh_quality_space;
if par.remesh_threshold>par.max_remesh_threshold
    par.remesh_threshold=par.max_remesh_threshold;
end
if par.remesh_threshold<par.min_remesh_threshold
    par.remesh_threshold=par.min_remesh_threshold;
    disp('Warning: min_remesh_threshold has been reached!');
end
par.remesh_cnt=par.remesh_cnt+1;
plot_mesh(nCoor,eNode,2);
hold on
title(['istep = ',num2str(par.istep),' curtime =',num2str(par.ctime), ' after remeshing']);
par.if_remesh_now=0;
end