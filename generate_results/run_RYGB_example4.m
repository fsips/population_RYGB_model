% function [] = run_RYGB_example()
% type_model should be a cell array.
% Options are:
% 'basic' 'regulation1' 'regulation2' 'regulation3'
clear all

%%
close all; figure();

load('F_L_forEX2.mat')

hvt     = (365/20)*10.^(sort([1-([1:5].^1.25)/(5^1.25) 1 1+([1:5].^1.25)/(5^1.25)]));
hvt0    = 365/2;

vmax0   = F_L-1;

t_final = 10*365;
ys      = 1;
xs      = 3;

for it = 1:length(hvt)
    x       = 1:t_final;
    y       = 1+vmax0*x./(hvt(it)+x);
    
    subplot(ys,xs,1)
    plot(x,y,'Color',[0 0.5+(it/length(hvt)/2) 0]); hold on
    xlim([0 t_final/10])
    ylim([0 3.5])
    
    subplot(ys,xs,2)
    plot(x,y,'Color',[0 0.5+(it/length(hvt)/2) 0]); hold on
    xlim([0 t_final])
    ylim([0 3.5])
    
    subplot(ys,xs,3)
    semilogx(x,y,'Color',[0 0.5+(it/length(hvt)/2) 0]); hold on
    ylim([0 3.5])
end


%% Do HVT sequence

% Sequence thought out to be first evenly spaced logarithmically, and then,
% after rounding and taking out duplicates, to have 100 entries. Of course,
% now it is no linger evenly spaced in the beginning, but it isnt possible
% to do smaller steps in the beginning. 
sequence = unique(ceil(10.^[0:log10(10*365)/(126):log10(10*365)]));

load(['kD_n24.mat']);

[basis]             = prep_for_exp(10);
basis.days          = 500;

for c = 1:2+length(hvt)
    
    % Before surgery
    if c>1
        basis.param(23)     = l_D2;
    end
    
    pre_surgery{c}      = run_condition(basis, 1);
    L0                  = pre_surgery{c}.input(7);
    ASBT0               = pre_surgery{c}.input(8);
    
    % Prepare for after surgery sims
    curr_sim            = pre_surgery{c};
    curr_sim.input(6)   = 1;
    curr_sim.days       = 1;
    curr_sim.param(19)  = curr_sim.param(19)/3;
    curr_sim.param(4)   = curr_sim.param(4)*3;
    
    curr_t              = 1;
    
    for it = 1:t_final
        if c >= 3
            curr_sim.input(7)= L0*(1+vmax0*it./(hvt(c-2)+it));
            curr_sim.input(8)= ASBT0*(1+vmax0*it./(hvt(c-2)+it));
        end
        
        curr_sim = run_condition(curr_sim, 1);
        
        if sum(it == sequence)
            post_days{c,find(it==sequence)}   = curr_sim;
            hyp_chars{c,find(it==sequence)}   = determine_char(curr_sim);
        end
    end
end


save 'RYGB_example4' pre_surgery post_days hyp_chars -v7.3


