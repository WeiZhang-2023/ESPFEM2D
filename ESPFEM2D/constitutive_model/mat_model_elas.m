function stress=mat_model_elas(mat_props, stress, dstrain)
E=mat_props(1,2);
v=mat_props(1,3);
a=E/((1+v)*(1-2*v));
dee=[(1-v)   v      0        v;...
       v   (1-v)    0        v;...
       0     0   (1-2*v)/2   0;...
       v     v      0       1-v];
dee=dee*a;
stress=stress+dee*dstrain;
end