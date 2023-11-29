function [par,monitor,nCoor,nMat,nAccel,nVel,nStress,nBoundT,nBoundV] ...
    =input_data(iEX)

%iEX=1; % Oscillation of an elastic cantilever beam
%iEX=2; % non-cohesive soil collapse stage1
%iEX=3; % non-cohesive soil collapse stage2
%iEX=4; % cohesive soil collapse stage1
%iEX=5; % cohesive soil collapse stage2
%iEX=6; % failure of a mohr-c soil slope stage1
%iEX=7; % failure of a mohr-c soil slope stage2

switch(iEX)
    case 1
        [par,monitor,nCoor,nMat,nAccel,nVel,nStress,nBoundT,nBoundV] ...
            = ex_bar_gravity_vibration;
    case 2
        [par,monitor,nCoor,nMat,nAccel,nVel,nStress,nBoundT,nBoundV] ...
            = ex_non_cohesive_soil_stage1;
    case 3
        [par,monitor,nCoor,nMat,nAccel,nVel,nStress,nBoundT,nBoundV] ...
            = ex_non_cohesive_soil_stage2;
    case 4
        [par,monitor,nCoor,nMat,nAccel,nVel,nStress,nBoundT,nBoundV] ...
            = ex_cohesive_soil_stage1;
    case 5
        [par,monitor,nCoor,nMat,nAccel,nVel,nStress,nBoundT,nBoundV] ...
            = ex_cohesive_soil_stage2;
    case 6
        [par,monitor,nCoor,nMat,nAccel,nVel,nStress,nBoundT,nBoundV] ...
            = ex_slope_stage1;
    case 7
        [par,monitor,nCoor,nMat,nAccel,nVel,nStress,nBoundT,nBoundV] ...
            = ex_slope_stage2;
end