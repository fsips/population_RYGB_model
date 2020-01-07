function [t, x] = simulate(x0, p, u, days, rythm, type, M)

%% Run model for 100 days with daily rythm

options     = []; % ODE-solver options (see help)

switch type
    case 0
        % Single simulation, one meal at t=0
        tspans      = days*24*60;
        
    case 1
        % 3 meals a day, with 6, 6, and 12 hour gaps
        tspans      = [];
        for it = 1:days
            tspans = [tspans,rythm];
        end
        tspans      = tspans*60;
end

t_curr      = 0;
t           = [0];
x           = [x0'];

for it = 1:length(tspans)
    
    % 1. Define current time span and simulate
    if days > 50 && it < length(tspans)-25
        tspan   = [t_curr t_curr+tspans(it)/2 t_curr+tspans(it)];
    else
        tspan   = [t_curr:5:t_curr+tspans(it)];
    end
    u(1)    = t_curr;
    
    if M
        [t_step,x_step]   = ode15s(@ode_M, tspan, x0, options, p, u);  
    else
        [t_step,x_step]   = ode15s(@ode, tspan, x0, options, p, u);  
    end
    
    % 2. Save results in matrices
    t       = [t; t_step(2:end)];
    x       = [x; x_step(2:end, :)];
    
    % 3. Update current time and current x0
    t_curr  = t_curr+tspans(it);
    x0      = x(end,:);
end