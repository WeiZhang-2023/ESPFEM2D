%% ��ͼ���ڵ㼸����Ϣ
function plot_mesh(nCoor,eNode,index)
figure(index)
clf
triplot(eNode,nCoor(:,1),nCoor(:,2)); 
axis equal
end