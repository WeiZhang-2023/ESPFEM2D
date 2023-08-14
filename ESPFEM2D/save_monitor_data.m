function monitor=save_monitor_data(par,nVel,nDisp,nStress,monitor)
nMonitor=length(monitor.ID);
for t=1:nMonitor
    cur_Item=monitor.Item{t};
    cur_ID=monitor.ID(t);
    cur_mCol=monitor.Col(t);
    if strcmp(cur_Item,'nVel')
        monitor.REC(par.istep,t)=nVel(cur_ID,cur_mCol);
    elseif strcmp(cur_Item,'nDisp')
        monitor.REC(par.istep,t)=nDisp(cur_ID,cur_mCol);
    elseif strcmp(cur_Item,'nStress')
        monitor.REC(par.istep,t)=nStress(cur_ID,cur_mCol);
    end
end
if (par.if_remesh==1)
    monitor.REC(par.istep,nMonitor+1)=par.remesh_cnt;
    monitor.REC(par.istep,nMonitor+3)=par.mesh_quality;
end
end