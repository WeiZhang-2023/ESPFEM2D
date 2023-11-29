function [stress,dpstrain_eq]=constitutive_model(mat_model,mat_props,stress,dstrain,pstrain_eq)
if mat_model==1 %elas
    stress=mat_model_elas(mat_props,stress,dstrain);
    dpstrain_eq=0.;
elseif mat_model==2 %DP
    [stress,dpstrain_eq]=mat_model_DP(mat_props,stress,dstrain,pstrain_eq);
end
end