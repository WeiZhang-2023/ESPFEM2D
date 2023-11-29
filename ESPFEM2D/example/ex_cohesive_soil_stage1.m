function [par,monitor,nCoor,nMat,nAccel,nVel,nStress,nBoundT,nBoundV] ...
    = ex_cohesive_soil_stage1
%% Parameters
par.project='cohesive_soil';
par.dir_plus='stage1';
par.totaltime=2.5;
par.dtime=5.e-5; %t_c=3.8158e-04
par.rank_deficiency=0.1;
par.MN=16; %possible maximum number of related elements
par.vtk=200;
par.damping=0.7;
par.rigid_wall=1; %number of rigid walls
%x0 y0 x1 y1 mu
par.wall=[4., 0., 10., 0., 10.]; % n x 5 matrix, where n is the total number of rigid walls
%% Mesh parameters
par.if_remesh=1; %if remshing during the whole simulation
%reference node ID, alpha shape radius, xmin offset,xmax offset,ymin offset,ymax offset
par.alpha_shape=[1,1.5,-1000,1000,-1000,1000]; % n x 6 matrix, where n is the total number of alpha shape treatments
par.remesh_threshold=20; % if the minimum angle of elements is less than it, the remeshing is conducted
par.max_remesh_threshold=20; %maximum remesh_threshold
par.min_remesh_threshold=5;
par.remesh_quality_space=5;
%reference node ID, alpha shape radius, xmin offset,xmax offset,ymin offset,ymax offset
par.Lap_threshold=0.2; %if nodal distance is smaller than par.space*par.Lap_threshold, smooth it
par.remesh_cnt=0;
%% Material parameters
%gx,gy
par.mat_gravity=[0. -10.]; % n x 2 matrix, where n is the total number of material types
%rho, E, v, c, phi, psi, c soften, phi soften, eps value, mu
par.mat_props=[1850,1.8e6,0.2,5.e3,25.,0.]; %n x p matrix, where n is the total number of material types
%1 elas 2 DP
par.mat_model=[1];  %n x 1 matrix, where n is the total number of material types
%% Computational mesh
load ans_soil_cohesive_soil
par.space=[0.02]; %space for all bodies
% solid, body 1
nCoor=solid_node(:,1:2);
pNN=size(nCoor,1);
par.node_cnt=pNN;
%% Initial conditions
nMat=ones(pNN,1);
nAccel=zeros(pNN,2);
nVel=zeros(pNN,2);
nDdisp=zeros(pNN,2);
nDisp=zeros(pNN,2);
nBoundT=zeros(pNN,2);
nBoundV=zeros(pNN,2);
nStress=zeros(pNN,4);
nPstrain_eq=zeros(pNN,1);
%% Boundary conditions
for in=1:pNN
    nBoundT(in,:) = [-1, -1];
    nBoundV(in,:) = [0., 0.];
    curx=nCoor(in,1);
    cury=nCoor(in,2);
    if cury<0.+1.e-6
        nBoundT(in,1)=1; %fixed velocity+
        nBoundV(in,1)=0; %value of the fixed velocity
        nBoundT(in,2)=1; %fixed velocity
        nBoundV(in,2)=0; %value of the fixed velocity
    end
    if curx<0.+1.e-6||curx>4.-1.e-6
        nBoundT(in,1)=1; %fixed velocity+
        nBoundV(in,1)=0; %value of the fixed velocity
    end
end
%% Record history data
nstep=ceil(par.totaltime/par.dtime);
monitor.REC=zeros(nstep,8);
monitor.Item={'nVel','nDisp','nStress','nStrain','nVel','nDisp','nStress','nStrain'};
monitor.ID=[202, 202, 202, 202, 202, 202, 202, 202];
monitor.Col=[1, 1, 1, 1, 2, 2, 2, 2];