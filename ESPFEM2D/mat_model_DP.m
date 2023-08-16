function [stress,dpstrain_eq]=mat_model_DP(mat_props,stress,dstrain,pstrain_eq)
%% parameters
E=mat_props(1,2);
v=mat_props(1,3);
c=mat_props(1,4);
phi=mat_props(1,5);
psi=mat_props(1,6);

stress3d=zeros(6,1);
dstrain3d=zeros(6,1);
stress3d(1)=stress(1);
stress3d(2)=stress(2);
stress3d(3)=stress(4);
stress3d(4)=stress(3);
dstrain3d(1)=dstrain(1);
dstrain3d(2)=dstrain(2);
dstrain3d(3)=dstrain(4);
dstrain3d(4)=dstrain(3);
[stress3d,dpstrain3d]=DP_implicit(stress3d,dstrain3d,E,v,c,phi,psi);
stress(1)=stress3d(1);
stress(2)=stress3d(2);
stress(3)=stress3d(4);
stress(4)=stress3d(3);
dpstrain(1)=dpstrain3d(1);
dpstrain(2)=dpstrain3d(2);
dpstrain(3)=dpstrain3d(4);
dpstrain(4)=dpstrain3d(3);
dpstrain_dev=zeros(4,1);
meandpstrain=(dpstrain(1)+dpstrain(2)+dpstrain(4))/3.;
dpstrain_dev(1)=dpstrain(1)-meandpstrain;
dpstrain_dev(2)=dpstrain(2)-meandpstrain;
dpstrain_dev(4)=dpstrain(4)-meandpstrain;
dpstrain_dev(3)=dpstrain(3);
dpstrain_eq=sqrt(0.666666666666666*(dpstrain_dev(1)*dpstrain_dev(1)+dpstrain_dev(2)*dpstrain_dev(2)+...
    dpstrain_dev(4)*dpstrain_dev(4)+0.5*dpstrain_dev(3)*dpstrain_dev(3)));
end