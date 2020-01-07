%% Generate results, both basic model / regulation models (if necessary)

fn = {'basic_RYGB.mat' 'R1_RYGB.mat' 'R2_RYGB.mat' 'R3_RYGB.mat'};

for it = 1:length(fn)
    
    % Run (optional) and load
    try load(fn{it})
        load(fn{it})
    catch
        switch it
            case 1
                run_RYGB({'basic'})
            case 2
                run_RYGB({'regulation1'})
            case 3
                run_RYGB({'regulation2'})
            case 4
                run_RYGB({'regulation3'})
        end
        load(fn{it})
    end
    
    % Define variable name
    switch it
        case 1
            hyp_chars_basic = hyp_chars;
        case 2
            hyp_chars_R1 = hyp_chars;
        case 3
            hyp_chars_R2 = hyp_chars;
        case 4
            hyp_chars_R3 = hyp_chars;
    end
end


%% Plot results

plot_RYGB_hypotheses2(hyp_chars_basic, hyp_chars_R1, hyp_chars_R2, hyp_chars_R3)
