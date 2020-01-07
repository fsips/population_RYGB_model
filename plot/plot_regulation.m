function [] = plot_regulation(basis,  charac, type)
fn      = 'Arial';
fs1     = 10;
fs2     = 14;

c1 = [67 77 160]/256;
c2 = [109 75 158]/256;
c3 = [150 75 157]/256;

switch type
    case 1 % Calibration plots
        
        load('kD_n12.mat')
        
        for it1 = 1:3
            for it2 =1:length(charac(it1).run)
                asbt(it1,it2)       = charac(it1).run(it2).v(end).Vmax;
                synth(it1,it2)      = charac(it1).run(it2).v(end).li_x_pc;
                plasma(it1,it2)     = sum(charac(it1).run(it2).x(end,69:72));
            end
        end
        
        h = figure('units', 'normalized', 'Position', [0.1 0.05 0.2 0.6]);
        subplot(2,2,1)
        loglog(charac(1).par, synth(1,:)'./basis.param(21), 'Color', c1, 'Linewidth', 2); hold on
        loglog(charac(2).par, synth(2,:)'./basis.param(21), 'Color', c2, 'Linewidth', 2)
        plot(l_D1, 10, 's','Color', c1, 'MarkerFaceColor', c1)
        plot(l_D2, 10, 's','Color', c2, 'MarkerFaceColor', c2)
        legend({'R\alpha', 'R\beta'})
        xlabel('k_{reg,\alpha} / k_{reg,\beta}', 'FontName', fn, 'FontSize', fs2)
        ylabel('Change of synthesis (FC)', 'FontName', fn, 'FontSize', fs2)
        set(gca, 'FontName', fn, 'FontSize', fs1)
        xlim([min(charac(1).par) max(charac(1).par)])
        
        subplot(2,2,2)
        loglog(charac(3).par, asbt(3,:)'./basis.param(10), 'Color', c3, 'Linewidth', 2); hold on
        plot(l_D3, 4, 's','Color', c3, 'MarkerFaceColor', c3)
        legend('R\gamma')
        xlabel('k_{reg,\gamma}', 'FontName', fn, 'FontSize', fs2)
        ylabel('Change of ASBT (FC)', 'FontName', fn, 'FontSize', fs2)
        set(gca, 'FontName', fn, 'FontSize', fs1)
        xlim([min(charac(3).par) max(charac(3).par)])
        
        subplot(2,2,3)
        text(0,0,'Show transition into regulation')
        
        subplot(2,2,4)
        text(0,0,'Show meals with regulation')
        
        hgexport(h,'CHAPTER_5_FIGURE_A3.eps');
        hgexport(h,'CHAPTER_5_FIGURE_A3.fig');
        
    case 2 % Disappearance plots
        h       = figure('units', 'normalized','Position', [0.1 0.1 0.65 0.25]);
        ys      = 1;
        xs      = 4;
        lw      = 2.5;
        
        cs      = {[67 77 160]/255 [109 75 158]/255 [150 75 155]/255 [0 0 0]};
        
        for it1 = 1:3
            synth   = zeros(1, length(charac(it1).run));
            plasma  = zeros(1, length(charac(it1).run));
            rel_pri = zeros(1, length(charac(it1).run));
            rel_dis = zeros(1, length(charac(it1).run));
            
            for it2  = 1:length(charac(it1).par)
                synth(it2)      = charac(it1).run(it2).v(end).li_x_pc;
                plasma(it2)     = sum(charac(it1).run(it2).x(end,69:72));
                rel_pri(it2)    = 100*sum(charac(it1).run(it2).x(end,69:70))/sum(charac(it1).run(it2).x(end,69:72));
                rel_dis(it2)    = 100*charac(it1).run(it2).v(end).feces2 / (charac(it1).run(it2).v(end).feces1+charac(it1).run(it2).v(end).feces2);
            end
            
            subplot(ys, xs, 1)
            semilogx(charac(it1).par, synth, 'Color', cs{it1}, 'LineWidth', lw); hold on ;
            xlabel('BA disappearance (min^{-1})', 'FontName', 'Arial', 'FontSize',14)
            ylabel('Synthesis of bile acids', 'FontName', 'Arial', 'FontSize',14)
            axis square; ylim([0 15]); xlim([charac(it1).par(1) charac(it1).par(end)])
            set(gca,'FontName', 'Arial', 'FontSize',8, 'XTick',[10^-6 10^-4 10^-2 10^0 10^2])
            
            subplot(ys, xs, 2)
            semilogx(charac(it1).par, plasma, 'Color', cs{it1}, 'LineWidth', lw); hold on ;
            xlabel('BA disappearance (min^{-1})', 'FontName', 'Arial', 'FontSize',14)
            ylabel('Fasting plasma level', 'FontName', 'Arial', 'FontSize',14)
            axis square; ylim([0 3]); xlim([charac(it1).par(1) charac(it1).par(end)])
            set(gca,'FontName', 'Arial', 'FontSize',8, 'XTick',[10^-6 10^-4 10^-2 10^0 10^2])
            
            subplot(ys, xs, 3)
            semilogx(charac(it1).par, rel_pri, 'Color', cs{it1}, 'LineWidth', lw); hold on ;
            xlabel('BA disappearance (min^{-1})', 'FontName', 'Arial', 'FontSize',14)
            ylabel('Primary (%)', 'FontName', 'Arial', 'FontSize',14)
            axis square; ylim([0 105]); xlim([charac(it1).par(1) charac(it1).par(end)])
            set(gca,'FontName', 'Arial', 'FontSize',8, 'XTick',[10^-6 10^-4 10^-2 10^0 10^2])
            
            subplot(ys, xs, 4)
            semilogx(charac(it1).par, rel_dis, 'Color', cs{it1}, 'LineWidth', lw); hold on ;
            xlabel('BA disappearance (min^{-1})', 'FontName', 'Arial', 'FontSize',14)
            ylabel('Disappearance (% of outflux)', 'FontName', 'Arial', 'FontSize',14)
            axis square; ylim([0 105]); xlim([charac(it1).par(1) charac(it1).par(end)])
            set(gca,'FontName', 'Arial', 'FontSize',8, 'XTick',[10^-6 10^-4 10^-2 10^0 10^2])
        end
        
    case 3 % Appearance plots
        h       = figure('units', 'normalized','Position', [0.1 0.1 0.65 0.25]);
        ys      = 1;
        xs      = 4;
        lw      = 2.5;
        
        cs      = {[67 77 160]/255 [109 75 158]/255 [150 75 155]/255 [0 0 0]};
        
        
        for it1 = 1:4
            synth   = zeros(1, length(charac(it1).run));
            plasma  = zeros(1, length(charac(it1).run));
            rel_pri = zeros(1, length(charac(it1).run));
            rel_dis = zeros(1, length(charac(it1).run));
            
            for it2  = 1:length(charac(it1).par)
                synth(it2)      = charac(it1).run(it2).v(end).li_x_pc;
                plasma(it2)     = sum(charac(it1).run(it2).x(end,69:72));
                rel_pri(it2)    = 100*sum(charac(it1).run(it2).x(end,69:70))/sum(charac(it1).run(it2).x(end,69:72));
                rel_app(it2)    = 100*charac(it1).par(it2) / (synth(it2)+charac(it1).par(it2));
            end
            
            subplot(ys, xs, 1)
            semilogx(charac(it1).par, synth, 'Color', cs{it1}, 'LineWidth', lw); hold on ;
            xlabel('BA appearance (\mumol/min)', 'FontName', 'Arial', 'FontSize',14)
            ylabel('Synthesis of bile acids', 'FontName', 'Arial', 'FontSize',14)
            axis square; ylim([0 1.1]); xlim([charac(it1).par(1) 10^2])
            set(gca,'FontName', 'Arial', 'FontSize',8, 'XTick',[10^-4 10^-2 10^0 10^2])
            
            subplot(ys, xs, 2)
            loglog(charac(it1).par, plasma, 'Color', cs{it1}, 'LineWidth', lw); hold on ;
            xlabel('BA appearance (\mumol/min)', 'FontName', 'Arial', 'FontSize',14)
            ylabel('Fasting plasma level', 'FontName', 'Arial', 'FontSize',14)
            axis square; ylim([0 100]); xlim([charac(it1).par(1) 10^2])
            set(gca,'FontName', 'Arial', 'FontSize',8, 'XTick',[10^-4 10^-2 10^0 10^2])
            
            subplot(ys, xs, 3)
            semilogx(charac(it1).par, rel_pri, 'Color', cs{it1}, 'LineWidth', lw); hold on ;
            xlabel('BA appearance (\mumol/min)', 'FontName', 'Arial', 'FontSize',14)
            ylabel('Primary (%)', 'FontName', 'Arial', 'FontSize',14)
            axis square; ylim([0 105]); xlim([charac(it1).par(1) 10^2])
            set(gca,'FontName', 'Arial', 'FontSize',8, 'XTick',[10^-4 10^-2 10^0 10^2])
            
            subplot(ys, xs, 4)
            semilogx(charac(it1).par, rel_app, 'Color', cs{it1}, 'LineWidth', lw); hold on ;
            xlabel('BA appearance (\mumol/min)', 'FontName', 'Arial', 'FontSize',14)
            ylabel('Appearance (% of influx)', 'FontName', 'Arial', 'FontSize',14)
            axis square; ylim([0 105]); xlim([charac(it1).par(1) 10^2])
            set(gca,'FontName', 'Arial', 'FontSize',8, 'XTick',[10^-4 10^-2 10^0 10^2])
        end
        
        
    case 4 % Disappearance plots for chapter!
        h       = figure('units', 'normalized','Position', [0.1 0.1 0.4 0.3]);
        ys      = 1;
        xs      = 2;
        lw      = 2.5;
        
        cs      = {[67 77 160]/255 [109 75 158]/255 [150 75 155]/255 [0 0 0]};
        
        for it1 = 1:3
            synth   = zeros(1, length(charac(it1).run));
            plasma  = zeros(1, length(charac(it1).run));
            rel_pri = zeros(1, length(charac(it1).run));
            rel_dis = zeros(1, length(charac(it1).run));
            
            for it2  = 1:length(charac(it1).par)
                synth(it2)      = charac(it1).run(it2).v(end).li_x_pc;
                plasma(it2)     = sum(charac(it1).run(it2).x(end,69:72));
                rel_pri(it2)    = 100*sum(charac(it1).run(it2).x(end,69:70))/sum(charac(it1).run(it2).x(end,69:72));
                rel_dis(it2)    = 100*charac(it1).run(it2).v(end).feces2 / (charac(it1).run(it2).v(end).feces1+charac(it1).run(it2).v(end).feces2);
            end
            
            subplot(ys, xs, 1)
            semilogx(charac(it1).par, synth, 'Color', cs{it1}, 'LineWidth', lw); hold on ;
            xlabel('BA disappearance (min^{-1})', 'FontName', 'Arial', 'FontSize',14)
            ylabel('Synthesis of bile acids', 'FontName', 'Arial', 'FontSize',14)
            axis square; ylim([0 15]); xlim([charac(it1).par(1) charac(it1).par(end)])
            set(gca,'FontName', 'Arial', 'FontSize',8, 'XTick',[10^-6 10^-4 10^-2 10^0 10^2])
            
            subplot(ys, xs, 2)
            semilogx(charac(it1).par, plasma, 'Color', cs{it1}, 'LineWidth', lw); hold on ;
            xlabel('BA disappearance (min^{-1})', 'FontName', 'Arial', 'FontSize',14)
            ylabel('Fasting plasma level', 'FontName', 'Arial', 'FontSize',14)
            axis square; ylim([0 3]); xlim([charac(it1).par(1) charac(it1).par(end)])
            set(gca,'FontName', 'Arial', 'FontSize',8, 'XTick',[10^-6 10^-4 10^-2 10^0 10^2])
        end
        
        hgexport(h,'CHAPTER_5_FIGURE_4D1.eps');
        hgexport(h,'CHAPTER_5_FIGURE_4D1.fig');
        
    case 5 % Appearance plots for chapter!
        
        h       = figure('units', 'normalized','Position', [0.1 0.1 0.4 0.3]);
        ys      = 1;
        xs      = 2;
        lw      = 2.5;
        
        cs      = {[67 77 160]/255 [109 75 158]/255 [150 75 155]/255 [0 0 0]};
        for it1 = 1:3
            synth   = zeros(1, length(charac(it1).run));
            plasma  = zeros(1, length(charac(it1).run));
            rel_pri = zeros(1, length(charac(it1).run));
            rel_dis = zeros(1, length(charac(it1).run));
            
            for it2  = 1:length(charac(it1).par)
                synth(it2)      = charac(it1).run(it2).v(end).li_x_pc;
                plasma(it2)     = sum(charac(it1).run(it2).x(end,69:72));
                rel_pri(it2)    = 100*sum(charac(it1).run(it2).x(end,69:70))/sum(charac(it1).run(it2).x(end,69:72));
                rel_app(it2)    = 100*charac(it1).par(it2) / (synth(it2)+charac(it1).par(it2));
            end
            
            subplot(ys, xs, 1)
            semilogx(charac(it1).par, synth, 'Color', cs{it1}, 'LineWidth', lw); hold on ;
            xlabel('BA appearance (\mumol/min)', 'FontName', 'Arial', 'FontSize',14)
            ylabel('Synthesis of bile acids', 'FontName', 'Arial', 'FontSize',14)
            axis square; ylim([0 1.25]); xlim([charac(it1).par(1) 10^2])
            set(gca,'FontName', 'Arial', 'FontSize',8, 'XTick',[10^-4 10^-2 10^0 10^2])
            
            subplot(ys, xs, 2)
            loglog(charac(it1).par, plasma, 'Color', cs{it1}, 'LineWidth', lw); hold on ;
            xlabel('BA appearance (\mumol/min)', 'FontName', 'Arial', 'FontSize',14)
            ylabel('Fasting plasma level', 'FontName', 'Arial', 'FontSize',14)
            axis square; ylim([0 100]); xlim([charac(it1).par(1) 10^2])
            set(gca,'FontName', 'Arial', 'FontSize',8, 'XTick',[10^-4 10^-2 10^0 10^2])
        end
                
        hgexport(h,'CHAPTER_5_FIGURE_4D2.eps');
        hgexport(h,'CHAPTER_5_FIGURE_4D2.fig');
        
end
