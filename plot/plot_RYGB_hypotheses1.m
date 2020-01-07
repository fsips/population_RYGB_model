function [] = plot_RYGB(hyp_chars)

%% Do the before/after sim
[basis]         = prep_for_exp(10);
basis.input(6)  = 0;
pre            = run_condition(basis, 1);
pre_chars      = determine_char(pre);

y_vals_pre(1) = pre_chars.fasting_pl;
y_vals_pre(2) = 100*pre_chars.meal_30  /      pre_chars.fasting_pl;
y_vals_pre(3) = 100*pre_chars.meal_max /      pre_chars.fasting_pl;
y_vals_pre(4) = 100*pre_chars.fasting_pl_p /  pre_chars.fasting_pl;

%% Prep
if nargin <1
    load('basic_RYGB.mat');
end

fn      = 'Arial';
fs1     = 13;
fs1h    = 12;
fs2     = 8;

figure('Position', [17  184  1794 927]);
ys = 4;
xs = 9;
dir = [1 -1 1 1 -1 -1 1 1 1];

l  = 0.4;
m1 = 0.6;
m2 = 0.8;
h  = 0.9;
cs = {[l h l] [m1 h l] [m2 h l] [h h l] [h m2 l] [h m1 l] [h l l] [h/2 l/2 l/2] [h/4 l/4 l/4]};
yl = {[0 20] [100 700] [100 1000] [0 100]};

%% Plot
for it = 1:9
    if it == 1
        x_vals = 2:8;
        n_rep  = 3;
    elseif it == 9
        n_rep = (length(hyp_chars{it})+1)/2;
        runs1   = [10:-9/(n_rep-1):1];
        runs2   = [1:(1e-3-1)/(n_rep-1):1e-3];
        x_vals  = [runs1(1:end-1) runs2];
    else
        n_rep = (length(hyp_chars{it})+1)/2;
        runs    = -1:1/(n_rep-1):1;
        x_vals = 10.^runs;
    end
    
    y_vals = zeros(length(hyp_chars{it}),4);
    for it_2 = 1:length(hyp_chars{it})
        try
            y_vals(it_2,1) = hyp_chars{it}(it_2).fasting_pl;
            y_vals(it_2,2) = 100*hyp_chars{it}(it_2).meal_30 / hyp_chars{it}(it_2).fasting_pl;
            y_vals(it_2,3) = 100*hyp_chars{it}(it_2).meal_max / hyp_chars{it}(it_2).fasting_pl;
            y_vals(it_2,4) = 100*hyp_chars{it}(it_2).fasting_pl_p/hyp_chars{it}(it_2).fasting_pl;
            
        catch
        end
    end
    
    for it_3 = 1:4
        subplot(ys, xs, (it_3-1)*xs+it)
        if it>1
            semilogx(x_vals,y_vals(:,it_3), 'LineWidth', 2, 'Color', cs{it}); hold on
        else
            plot(x_vals,y_vals(:,it_3), 'LineWidth', 2, 'Color', cs{it}); hold on
        end
        plot([x_vals(1) x_vals(end)], [y_vals_pre(it_3) y_vals_pre(it_3)], ':', 'Color', [0.5 0.5 0.5])
        plot([x_vals(n_rep) x_vals(n_rep)], [yl{it_3}(1) yl{it_3}(2)], '-', 'Color', [0.5 0.5 0.5])
        set(gca, 'FontName', fn, 'FontSize', fs2)
        ylim(yl{it_3})
        if it>1
            xlim([min(x_vals) max(x_vals)])
        else
            xlim([2 8])
        end
        
        if dir(it) == -1
            set(gca, 'XDir', 'reverse')
        end
        
    end
end

%% Annotate
subplot(ys,xs,0*ys+1); ylabel('Fasting plasma BA (\mumol/L)', 'FontName', fn, 'FontSize', fs1h)
subplot(ys,xs,1*xs+1); ylabel('30 minute increase (%)', 'FontName', fn, 'FontSize', fs1h)
subplot(ys,xs,2*xs+1); ylabel('Maximal increase (%)', 'FontName', fn, 'FontSize', fs1h)
subplot(ys,xs,3*xs+1); ylabel('Primary BA (%))', 'FontName', fn, 'FontSize', fs1h)

subplot(ys,xs,1); title({'H1a' '# of meals'},           'FontName', fn, 'FontSize', fs1)
subplot(ys,xs,2); title({'H2a' 'Size of meals'},        'FontName', fn, 'FontSize', fs1)
subplot(ys,xs,3); title({'H3a' 'Proximal transit (PP)'},'FontName', fn, 'FontSize', fs1)
subplot(ys,xs,4); title({'H3b' 'Proximal transit (F)'}, 'FontName', fn, 'FontSize', fs1)
subplot(ys,xs,5); title({'H4a' 'Distal transit'},       'FontName', fn, 'FontSize', fs1)
subplot(ys,xs,6); title({'H4b' 'Colon transit'},        'FontName', fn, 'FontSize', fs1)
subplot(ys,xs,7); title({'H5a' 'ASBT capacity'},        'FontName', fn, 'FontSize', fs1)
subplot(ys,xs,8); title({'H6'  'Dehydroxylation'},      'FontName', fn, 'FontSize', fs1)
subplot(ys,xs,9); title({'H7'  'Extraction'},           'FontName', fn, 'FontSize', fs1)

subplot(ys,xs,(ys-1)*xs+1); xlabel('# of meals', 'FontName', fn, 'FontSize', fs1)
subplot(ys,xs,(ys-1)*xs+2); xlabel('fold change', 'FontName', fn, 'FontSize', fs1)
subplot(ys,xs,(ys-1)*xs+3); xlabel('fold change', 'FontName', fn, 'FontSize', fs1)
subplot(ys,xs,(ys-1)*xs+4); xlabel('fold change', 'FontName', fn, 'FontSize', fs1)
subplot(ys,xs,(ys-1)*xs+5); xlabel('fold change', 'FontName', fn, 'FontSize', fs1)
subplot(ys,xs,(ys-1)*xs+6); xlabel('fold change', 'FontName', fn, 'FontSize', fs1)
subplot(ys,xs,(ys-1)*xs+7); xlabel('fold change', 'FontName', fn, 'FontSize', fs1)
subplot(ys,xs,(ys-1)*xs+8); xlabel('fold change', 'FontName', fn, 'FontSize', fs1)
subplot(ys,xs,(ys-1)*xs+9); xlabel('power', 'FontName', fn, 'FontSize', fs1)
