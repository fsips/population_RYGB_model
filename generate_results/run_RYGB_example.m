% function [] = run_RYGB_example()
% type_model should be a cell array.
% Options are:
% 'basic' 'regulation1' 'regulation2' 'regulation3'
clear all

%%
figure();

hvt = 50;
t_final = 10*365;

x = 1:t_final;
y = 1+2*x./(365/2+x);

subplot(1,2,1)
plot(x,y);
xlim([0 365])

subplot(1,2,2)
semilogx(x,y);

%%
% try
%     load('RYGB_example.mat')
    
% catch
    
    load(['kD_n12.mat']);
    
    [basis]             = prep_for_exp(10);
    basis.days          = 500;
    
    for c = 1:3
        
        % Before surgery
        if c>1
            basis.param(22)     = l_D1;
            %         basis.param(24)     = l_D3;
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
        
        for it = 1:t_final
            if c == 3
                curr_sim.input(7)= L0*(1+2*it./(hvt+it));
                curr_sim.input(8)= ASBT0*(1+2*it./(hvt+it));
            end
            
            post_days{c,it}   = run_condition(curr_sim, 1);
            hyp_chars{c,it}   = determine_char(post_days{c,it});
            
            [L0_vec(c,it), ASBT0_vec(c,it)] = find_setpoint(post_days{c,it});
            
            curr_sim        = post_days{c,it};
        end
    end
    
    save 'RYGB_example' pre_surgery post_days hyp_chars -v7.3
% end

%%
close all
clear plots

figure('units', 'normalized', 'Position', [0.1 0.05 0.4 0.9])
cs      = {[0.5 0.5 0.5] [0 0 0] [0.5 1 0.5]};
types   = {'-' '-' ':'};
oom     = [1 10 100 1000];

for c = 1:3
    for it = 1:t_final
        hyp_chars_pre   = determine_char(pre_surgery{c});
        plots.PL(c,it) = hyp_chars{c,it}.fasting_pl;
        plots.HA(c,it) = hyp_chars{c,it}.meal_30;
        plots.MA(c,it) = hyp_chars{c,it}.meal_max;
        plots.SY(c,it) = hyp_chars{c,it}.synthesis;
        plots.PR(c,it) = hyp_chars{c,it}.fasting_pl_p / hyp_chars{c,it}.fasting_pl * 100;
        plots.C(c,it) = (hyp_chars{c,it}.fasting_pl_pc+hyp_chars{c,it}.fasting_pl_sc) / hyp_chars{c,it}.fasting_pl * 100;
    end
    ys = 4;
    xs = 3;
    
    subplot(ys,xs,1:6)
    l(c) = semilogx([0.9, 1:t_final], [hyp_chars_pre.fasting_pl, plots.PL(c,:)]/hyp_chars_pre.fasting_pl, 'Color', cs{c}, 'LineWidth', 2); hold on
    plot([0.9], [hyp_chars_pre.fasting_pl]/hyp_chars_pre.fasting_pl, 'o', 'MarkerFaceColor', cs{c},'MarkerEdgeColor', cs{c}); hold on
    xlabel('Time (days)')
    ylabel('Fasting [TBA]_{pl}')
    if c == 3
        legend(l,{'No regulation' 'Constant regulation' 'Time varying regulation'}, 'Location', 'NorthWest');
    end
    xlim([0.9 t_final])
    ylim([0 3])
    set(gca, 'XTick', oom)
    
    subplot(ys,xs,7)
    semilogx([0.9, 1:t_final], [hyp_chars_pre.meal_30./hyp_chars_pre.fasting_pl, plots.HA(c,:)./plots.PL(c,:)], 'Color', cs{c}, 'LineWidth', 2); hold on
    plot([0.9], hyp_chars_pre.meal_30./hyp_chars_pre.fasting_pl, 'o', 'MarkerFaceColor', cs{c},'MarkerEdgeColor', cs{c}); hold on
    xlabel('Time (days)')
    ylabel('30 minute increase (fold change)')
    xlim([0.9 t_final])
    ylim([1 6])
    set(gca, 'XTick', oom)
    
    subplot(ys,xs,9)
    semilogx([0.9, 1:t_final], [hyp_chars_pre.synthesis, plots.SY(c,:)], 'Color', cs{c}, 'LineWidth', 2); hold on
    plot([0.9], hyp_chars_pre.synthesis, 'o', 'MarkerFaceColor', cs{c},'MarkerEdgeColor', cs{c}); hold on
    xlabel('Time (days)')
    ylabel('Synthesis (\mumol/min)')
    xlim([0.9 t_final])
    ylim([0 2])
    set(gca, 'XTick', oom)
    
    subplot(ys,xs,8)
    semilogx([0.9, 1:t_final], [hyp_chars_pre.fasting_pl_p ./hyp_chars_pre.fasting_pl * 100, plots.PR(c,:)], 'Color', cs{c}, 'LineWidth', 2); hold on
    plot([0.9], hyp_chars_pre.fasting_pl_p ./hyp_chars_pre.fasting_pl * 100, 'o', 'MarkerFaceColor', cs{c},'MarkerEdgeColor', cs{c}); hold on
    xlabel('Time (days)')
    ylabel('Fasting primary (%)')
    xlim([0.9 t_final])
    ylim([0 100])
    set(gca, 'XTick', oom)
    
    subplot(ys,xs,10)
    semilogx([0.9, 1:t_final], [hyp_chars_pre.meal_max./hyp_chars_pre.fasting_pl, plots.MA(c,:)./plots.PL(c,:)], 'Color', cs{c}, 'LineWidth', 2); hold on
    plot([0.9],hyp_chars_pre.meal_max./hyp_chars_pre.fasting_pl, 'o', 'MarkerFaceColor', cs{c},'MarkerEdgeColor', cs{c}); hold on
    xlabel('Time (days)')
    ylabel('Maximal increase (fold change)')
    xlim([0.9 t_final])
    ylim([1 6])
    set(gca, 'XTick', oom)
    
    subplot(ys,xs,12)
    plot(pre_surgery{c}.t_finday, [pre_surgery{c}.v(pre_surgery{c}.i_finday).li_x_pc], types{c},'Color', cs{c}, 'LineWidth', 2); hold on
    xlabel('Time (hours)')
    ylabel('Synthesis (\mumol/min)')
    ylim([0 1.5])
    xlim([0 24])
    set(gca, 'XTick', [0 6 12 18 24])
    
    subplot(ys,xs,11)
    semilogx([0.9, 1:t_final], [(hyp_chars_pre.fasting_pl_pc+hyp_chars_pre.fasting_pl_sc) ./hyp_chars_pre.fasting_pl * 100, plots.C(c,:)], 'Color', cs{c}, 'LineWidth', 2); hold on
    plot([0.9],(hyp_chars_pre.fasting_pl_pc+hyp_chars_pre.fasting_pl_sc) ./hyp_chars_pre.fasting_pl * 100, 'o', 'MarkerFaceColor', cs{c},'MarkerEdgeColor', cs{c}); hold on
    xlabel('Time (days)')
    ylabel('Fasting conjugated (%)')
    xlim([0.9 t_final])
    ylim([0 100])
    set(gca, 'XTick', oom)
    
end


