clear l
t_final = 10*365;
sequence = unique(ceil(10.^[0:log10(10*365)/(126):log10(10*365)]));

h = figure('units', 'normalized', 'Position', [0.1 0.05 0.6 0.9]);
types   = {'-' '-' ':'};
oom     = [1 10 100 1000];
ys      = 3;
xs      = 3;
fn      = 'Arial';
fs1     = 10;
fs2     = 14;
 
%% B

subplot(ys,xs,4) 
load('F_L_forEX2.mat')

hvt     = (365/20)*10.^(sort([1-([1:5].^1.25)/(5^1.25) 1 1+([1:5].^1.25)/(5^1.25)]));
hvt0    = 365/2;

vmax0   = F_L-1;

t_final = 10*365;

semilogx([0.9 t_final], [1 1], 'k-', 'LineWidth', 2); hold on 
semilogx([0.9 t_final], [F_L F_L], 'g:', 'LineWidth', 2); hold on 

for it = 1:length(hvt)
    x       = 1:t_final;
    y       = 1+vmax0*x./(hvt(it)+x);
    
    semilogx([0.9, x],[1, y],'Color',[0 0.5+(it/length(hvt)/2) 0], 'LineWidth', 2); hold on
  
    ylim([0 3.5])
    xlim([0.9 t_final])
end
plot([0.9], 1, 'o', 'MarkerFaceColor', [0 0.5+(it/length(hvt)/2) 0],'MarkerEdgeColor', [0 0.5+(it/length(hvt)/2) 0]); hold on


xlabel('Time (days)', 'FontName', fn, 'FontSize', fs2)
ylabel('[BA]_0 (FC from pre-surgery)', 'FontName', fn, 'FontSize', fs2)
set(gca, 'XTick', oom, 'FontName', fn, 'FontSize', fs1)

%% C, D, E, F
for c = 1:size(post_days,1)
    for it = 1:length(sequence)
        hyp_chars_pre   = determine_char(pre_surgery{c});
        plots.PL(c,it) = hyp_chars{c,it}.fasting_pl;
        plots.HA(c,it) = hyp_chars{c,it}.meal_30;
        plots.MA(c,it) = hyp_chars{c,it}.meal_max;
        plots.SY(c,it) = hyp_chars{c,it}.synthesis;
    end
    
    if c == 1
        curr_cs = [0.5 0.5 0.5];
    elseif c == 2
        curr_cs = [0 0 0];
    elseif c>=3
        curr_cs = [0 0.45+((c-2)/20) 0];
    end
    
    subplot(ys,xs,[2 3 5 6])
    l(c) = semilogx([0.9, sequence], [hyp_chars_pre.fasting_pl, plots.PL(c,:)]/hyp_chars_pre.fasting_pl, 'Color', curr_cs, 'LineWidth', 2); hold on
    plot([0.9], [hyp_chars_pre.fasting_pl]/hyp_chars_pre.fasting_pl, 'o', 'MarkerFaceColor', curr_cs,'MarkerEdgeColor', curr_cs); hold on
    xlabel('Time (days)', 'FontName', fn, 'FontSize', fs2)
    ylabel('Fasting [TBA]_{pl} (FC from pre-surgery)', 'FontName', fn, 'FontSize', fs2)
    if c == 3
        legend(l,{'No regulation' 'Constant regulation' 'Time varying regulation'}, 'Location', 'NorthWest');
    end
    xlim([0.9 t_final])
    ylim([0 3])
    set(gca, 'XTick', oom, 'FontName', fn, 'FontSize', fs1)
    
    subplot(ys,xs,7)
    semilogx([0.9, sequence], [hyp_chars_pre.meal_30./hyp_chars_pre.fasting_pl, plots.HA(c,:)./plots.PL(c,:)], 'Color', curr_cs, 'LineWidth', 2); hold on
    plot([0.9], hyp_chars_pre.meal_30./hyp_chars_pre.fasting_pl, 'o', 'MarkerFaceColor', curr_cs,'MarkerEdgeColor', curr_cs); hold on
    xlabel('Time (days)', 'FontName', fn, 'FontSize', fs2)
    ylabel('30 minute increase (FC from fasting)', 'FontName', fn, 'FontSize', fs2)
    xlim([0.9 t_final])
    ylim([1 6])
    set(gca, 'XTick', oom, 'FontName', fn, 'FontSize', fs1)
    
    subplot(ys,xs,9)
    semilogx([0.9, sequence], [hyp_chars_pre.synthesis, plots.SY(c,:)], 'Color', curr_cs, 'LineWidth', 2); hold on
    plot([0.9], hyp_chars_pre.synthesis, 'o', 'MarkerFaceColor', curr_cs,'MarkerEdgeColor', curr_cs); hold on
    xlabel('Time (days)', 'FontName', fn, 'FontSize', fs2)
    ylabel('Synthesis (\mumol/min)', 'FontName', fn, 'FontSize', fs2)
    xlim([0.9 t_final])
    ylim([0 2])
    set(gca, 'XTick', oom, 'FontName', fn, 'FontSize', fs1)
    
    
    subplot(ys,xs,8)
    semilogx([0.9, sequence], [hyp_chars_pre.meal_max./hyp_chars_pre.fasting_pl, plots.MA(c,:)./plots.PL(c,:)], 'Color', curr_cs, 'LineWidth', 2); hold on
    plot([0.9],hyp_chars_pre.meal_max./hyp_chars_pre.fasting_pl, 'o', 'MarkerFaceColor', curr_cs,'MarkerEdgeColor', curr_cs); hold on
    xlabel('Time (days)', 'FontName', fn, 'FontSize', fs2)
    ylabel('Maximal increase (FC from fasting)', 'FontName', fn, 'FontSize', fs2)
    xlim([0.9 t_final])
    ylim([1 6])
    set(gca, 'XTick', oom, 'FontName', fn, 'FontSize', fs1)
    
end

%%
figure()
for c = 1:size(post_days,1)
    for it = 1:length(sequence)
        hyp_chars_pre   = determine_char(pre_surgery{c});
        plots.P(c,it) = hyp_chars{c,it}.fasting_pl_p ./ hyp_chars{c,it}.fasting_pl * 100;
    end
    
    if c == 1
        curr_cs = [0.5 0.5 0.5];
    elseif c == 2
        curr_cs = [0 0 0];
    elseif c>=3
        curr_cs = [0 0.45+((c-2)/20) 0];
    end
    
    semilogx([0.9, sequence], [hyp_chars_pre.fasting_pl_p./hyp_chars_pre.fasting_pl*100, plots.P(c,:)], 'Color', curr_cs, 'LineWidth', 2); hold on
%     plot([0.9],hyp_chars_pre.meal_max./hyp_chars_pre.fasting_pl, 'o', 'MarkerFaceColor', curr_cs,'MarkerEdgeColor', curr_cs); hold on
    xlabel('Time (days)', 'FontName', fn, 'FontSize', fs2)
    ylabel('% Primary bile acids (of fasting TBA)', 'FontName', fn, 'FontSize', fs2)
    xlim([0.9 t_final])
%     ylim([1 6])
    set(gca, 'XTick', oom, 'FontName', fn, 'FontSize', fs1)
end
%%
hgexport(h,'CHAPTER_5_FIGURE_6.eps');
hgexport(h,'CHAPTER_5_FIGURE_6.fig');