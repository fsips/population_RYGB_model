function [] = extract_factor_RYGBexample1(post_days)

figure()
cs      = {[0.5 0.5 0.5] [0 0 0] [0.5 1 0.5]};

for it = 1:3
    for it2 = 1:size(post_days,2)
        ASBT_b(it, it2)     = post_days{it,it2}.v(end).k_sp * post_days{it,it2}.v(end).ASBTp + post_days{it,it2}.v(end).ASBTs;
        L_b(it, it2)        = post_days{it,it2}.v(end).k_sp * post_days{it,it2}.v(end).LIp + post_days{it,it2}.v(end).LIs;
    end
    
    subplot(1,2,1)
    plot([1:size(post_days,2)], ASBT_b(it,:), 'Color', cs{it}); hold on
    
    subplot(1,2,2)
    plot([1:size(post_days,2)], L_b(it,:), 'Color', cs{it}); hold on
end

ASBT_b(3,end) ./ ASBT_b(2,end)
F_ASBT = ASBT_b(1,end) ./ ASBT_b(2,end)

L_b(3,end) ./ L_b(2,end)
F_L = L_b(1,end) ./ L_b(2,end)

save F_L_forEX2 F_L