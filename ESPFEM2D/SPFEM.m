%--------------------------------------------------------------------------
% Zhang W, Liu Y H, Li J H, Yuan W H. ESPFEM2D: A MATLAB 2D explicit smoothed particle finite element method code for geotechnical large deformation analysis[J]. Computational Mechanics, 2024, 74(2):467-484.
% All copyrights reserved Zhang Wei(1), Liu Yihui(1), Yuan Weihai(2)
% 1: South China Agricultural University, Guangzhou, China
% 2: Hohai University, Nanjing, China
%--------------------------------------------------------------------------
% SPFEM main
clc
clear
%The directory ESPFEM2D
addpath(genpath('example')) ;
addpath(genpath('comp')) ;
addpath(genpath('mesh')) ;
addpath(genpath('constitutive_model')) ;

%example input
iEX=1;
[par,monitor,nCoor,nMat,nAccel,nVel,nStress,nBoundT,nBoundV] ...
    =input_data(iEX);
[par,eNode,nREN,nREs,nRNN,nRNs,nDisp,nPstrain_eq,nF,nFrd]=initializing(par,nCoor);

tic

ctime=0.;
istep=0;
par.ctime=ctime;
par.istep=istep;
%prepare for the leapfrog time integration
[nVel,nDisp,nCoor]=update_half_velocity(par,nBoundT,nBoundV,nVel,nAccel,nDisp,nCoor);
while (ctime<par.totaltime+1.e-9)
    % output vtk
    if mod(istep,par.vtk)==0
        output_vtk(par,nCoor,nDisp,nVel,nStress,nPstrain_eq,nMat,eNode);
        disp(['istep = ',num2str(istep),' curtime =',num2str(ctime)]);  
        plot_mesh(nCoor,eNode,1);
        hold on
        title(['istep = ',num2str(istep),' curtime =',num2str(ctime)]);
    end
    %remeshing
    if par.if_remesh==1
        [par,nCoor,nMat,nBoundT,nBoundV,nREN,nREs,nRNN,nRNs,nDisp,nVel,nStress,nPstrain_eq,eNode]...
            =mesh_remesh(par,nCoor,nMat,nBoundT,nBoundV,nREN,nREs,nRNN,nRNs,nDisp,nVel,nStress,nPstrain_eq,eNode);
    end
    %obtain the basic information of elements and nodes
    [eArea,eDNdx,eDNdy]=element_data_prepare(nCoor,par,eNode);
    [nArea,nDNdx,nDNdy]=node_data_prepare(par,nREN,nREs,nRNN,nRNs,eNode,eArea,eDNdx,eDNdy);
    %calculate the nodal internal forces
    [nFint,nStress,nPstrain_eq,nF]=...
        force_int(par,nRNN,nRNs,nArea,nMat,nDNdx,nDNdy,nVel,nStress,nPstrain_eq);  
    %rank deficiency treatment
    if (par.rank_deficiency>1.e-6)
        nFrd=force_rank_deficiency(par,nRNN,nRNs,nMat,nArea,nCoor,nVel,nF);
    end
    %time integration
    [nVel,nDisp,nCoor]=time_integration(par,nMat,nArea,nBoundT,nBoundV,nVel,nDisp,nCoor,nFint,nFrd);
    %rigid boundary contact
    if par.rigid_wall>0.5
        [par,nVel,nDisp,nCoor]=contact_wall(par,nCoor,nMat,nArea,nVel,nDisp);
    end
    ctime=ctime+par.dtime;par.ctime=ctime;
    istep=istep+1;par.istep=istep;
    monitor=save_monitor_data(par,nVel,nDisp,nStress,monitor);
end
toc
save
save initial_stress nStress
