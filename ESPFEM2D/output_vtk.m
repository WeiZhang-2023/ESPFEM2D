function []=output_vtk(par,nCoor,nDisp,nVel,nStress,nPstrain_eq,nMat,eNode)
filename=[par.project,num2str(par.istep),'.vtk'];
folder=[par.project,'\',par.dir_plus];
folder=['C:\vtkResults_solid\',folder];
if ~exist(folder,'dir')
    mkdir(folder);
end
str=[folder,'\',filename];
fid=fopen(str,'ww');
fprintf(fid,'# vtk DataFile Version 3.0\n');
fprintf(fid,'vtk output displacement\n');
fprintf(fid,'ASCII\n');

fprintf(fid,'\n');
fprintf(fid,'DATASET UNSTRUCTURED_GRID\n');
fprintf(fid,['POINTS ', num2str(par.node_cnt)  ,' float\n']);
for in=1:par.node_cnt
    fprintf(fid,'%10.6f %10.6f %10.6f\n',nCoor(in,1),nCoor(in,2),0);
end

fprintf(fid,'\n');
fprintf(fid,'CELLS  %d %d\n',par.element_cnt,par.element_cnt*4);
for ie=1:par.element_cnt
    fprintf(fid,'%d    %d    %d    %d\n',3,eNode(ie,1)-1,eNode(ie,2)-1,eNode(ie,3)-1);
end

fprintf(fid,'\n');
fprintf(fid,'CELL_TYPES %d\n',par.element_cnt);
for in=1:par.element_cnt
    fprintf(fid,'5\n');
end

fprintf(fid,'\n');
fprintf(fid,'POINT_DATA %d \n',par.node_cnt);

fprintf(fid,'VECTORS    nDisp     float\n');
for in=1:par.node_cnt
    fprintf(fid,'%10.6f %10.6f %10.6f\n',nDisp(in,1),nDisp(in,2),0);
end
fprintf(fid,'\n');

fprintf(fid,'VECTORS    nVel     float\n');
for in=1:par.node_cnt
    fprintf(fid,'%10.6f %10.6f %10.6f\n',nVel(in,1),nVel(in,2),0);
end
fprintf(fid,'\n');

fprintf(fid,'TENSORS6  nStress     float\n');
temp=nStress;
for in=1:par.node_cnt
    fprintf(fid,'%15.6f    %15.6f    %15.6f\n',temp(in,1),temp(in,2),temp(in,4));
    fprintf(fid,'%15.6f    %15.6f    %15.6f\n',temp(in,3),          0.,            0.           );
    fprintf(fid,'\n');
end

fprintf(fid,'\n');
fprintf(fid,'SCALARS   npStrain_eq   float\n');
fprintf(fid,'LOOKUP_TABLE default \n');
for in=1:par.node_cnt
    fprintf(fid,'%15.6f\n',nPstrain_eq(in));
end

fprintf(fid,'\n');
fprintf(fid,'SCALARS   nMat   float\n');
fprintf(fid,'LOOKUP_TABLE default \n');
for in=1:par.node_cnt
    p=nMat(in,1);
    fprintf(fid,'%3d\n',p);
end

fprintf(fid,'\n');
fclose(fid);
end