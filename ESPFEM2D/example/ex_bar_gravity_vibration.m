function [par,monitor,nCoor,nMat,nAccel,nVel,nStress,nBoundT,nBoundV] ...
            = ex_bar_gravity_vibration
%% Parameters
par.project='bar_gravity_vibration';
par.dir_plus='initial';
par.totaltime=4.;
par.dtime=1.e-5; %t_c=3.8158e-04
par.rank_deficiency=0.1;
par.MN=16; %possible maximum number of related elements
par.vtk=4000;
par.damping=0.;
par.rigid_wall=0; %number of rigid walls
%x0 y0 x1 y1 mu
par.wall=0; % n x 5 matrix, where n is the total number of rigid walls
%% Mesh parameters
par.if_remesh=0; %if remshing during the whole simulation
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
par.mat_gravity=[0. -9.8]; % n x 2 matrix, where n is the total number of material types
%rho, E, v, c, phi, psi, c soften, phi soften, eps value
par.mat_props=[1850,80.e6,0.25,0.,0.,0.]; %n x p matrix, where n is the total number of material types
%1 elas 2 DP
par.mat_model=[1];  %n x 1 matrix, where n is the total number of material types
%% Computational mesh
xlen=2.;
ylen=0.2;
par.space=0.2/round(0.2/0.02);
% regular nodes
[meshx,meshy]=meshgrid(0:par.space:xlen,0:par.space:ylen);
[a, b]=size(meshx);
pNN=a*b;
nCoor=zeros(pNN,2);
cnt=0;
for i=1:a
    for j=1:b
        cnt=cnt+1;
        nCoor(cnt,1)=meshx(i,j);
        nCoor(cnt,2)=meshy(i,j);
    end
end
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
    nBoundT(in,:)=[-1, -1];
    nBoundV(in,:)=[0., 0.];
    curx=nCoor(in,1);
    cury=nCoor(in,2);
    if curx<0.+1.e-6
        nBoundT(in,1)=1; %fixed velocity
        nBoundV(in,1)=0; %value of the fixed velocity
        nBoundT(in,2)=1; %fixed velocity
        nBoundV(in,2)=0; %value of the fixed velocity
    end
end
%% Record history data
nstep=ceil(par.totaltime/par.dtime);
monitor.REC=zeros(nstep,8);
monitor.Item={'nVel','nVel','nDisp','nDisp','nStress','nStress','nStress','nStress'};
monitor.ID=[1111, 1111, 1111, 1111, 1, 1, 1011, 1011];
monitor.Col=[1, 2, 1, 2, 1, 2, 1, 2,];
end