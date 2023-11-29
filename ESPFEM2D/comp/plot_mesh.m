%% 画图检查节点几何信息
function plot_mesh(nCoor,eNode,index)
figure(index)
clf
triplot(eNode,nCoor(:,1),nCoor(:,2)); 
axis equal
end