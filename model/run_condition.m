function cond1 = run_condition(cond0, M)

[cond1.t,cond1.x]   = simulate(cond0.x0, cond0.param, cond0.input, cond0.days, cond0.rythm, 1, M);

cond1.x0    = cond1.x(end,:)';
cond1.param = cond0.param;
cond1.input = cond0.input;
cond1.days  = cond0.days;
cond1.rythm = cond0.rythm;

% Calculate variables: tau
cond1.tspans      = [0];
for it = 1:cond1.days
    cond1.tspans  = [cond1.tspans,cond1.tspans(end)+cumsum(cond0.rythm)];
end
cond1.tspans     = cond1.tspans*60;

for it = 1:length(cond1.t)
    cond1.tau(it)         = cond1.tspans(find(cond1.tspans<=cond1.t(it), 1, 'last'));
end

% Calculate other variables
for it = 1:length(cond1.t)
    input      	= cond1.input;
    input(1)  	= cond1.tau(it);

    if M
        cond1.v(it)  = var_M(cond1.t(it), cond1.x(it,:), cond1.param, cond1.input);
    else
        cond1.v(it)  = var(cond1.t(it), cond1.x(it,:), cond1.param, cond1.input);
    end
end

% Determine the final day
cond1.i_finday   = cond1.t > (cond1.t(end)-24*60);
cond1.t_finday   = (cond1.t(cond1.i_finday) - (cond1.t(end)-24*60))/60;