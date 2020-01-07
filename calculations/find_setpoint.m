function [L0, ASBT0] = find_setpoint(run)
    loc = find(run.t == run.t(end)-24*60);
    L0      = trapz(run.t(loc:end)-run.t(loc), ([run.v(loc:end).LIp].*[run.v(loc:end).k_sp]+[run.v(loc:end).LIs]))/(24*60);
    ASBT0   = trapz(run.t(loc:end)-run.t(loc), ([run.v(loc:end).ASBTp].*[run.v(loc:end).k_sp]+[run.v(loc:end).ASBTs]))/(24*60);
end
