function [] = run_RYGB(type_models)
% type_model should be a cell array.
% Options are:
% 'basic' 'regulation1' 'regulation2' 'regulation3'

load(['kD_n12.mat']);

for type_model = type_models
    disp(['Initiating ', type_model{1}])
    
    %% Prepare
    n_rep           = 20;
    [basis]         = prep_for_exp(10);
    basis.days      = 500;
    
    %% Any more preparations
    switch type_model{1}
        case 'basic'
            basis.input(6)  = 1;
            
        case {'regulation1' 'regulation2' 'regulation 3'}
            basis.input(6)  = 1;

            switch type_model{1}
                case 'regulation1'
                    basis.param(22) = l_D1;
                case 'regulation2'
                    basis.param(23) = l_D2;
                case 'regulation3'
                    basis.param(24) = l_D3;
            end
    end
    
    %% Simulations
    for it = 1:9
        switch it
            case 1 % More frequent meals
                for it_rep = 1:7 % Number of meals -1
                    
                    change_current = basis;
                    
                    if it_rep == 0
                        curr_rythm = [24];
                    else
                        curr_rythm = [];
                        for it3 = 1:it_rep
                            curr_rythm = [curr_rythm 12/it_rep];
                        end
                        curr_rythm = [curr_rythm 12];
                    end
                    change_current.rythm   = curr_rythm;
                    hypotheses{it}(it_rep) = run_condition(change_current, 1);
                    hyp_chars{it}(it_rep)  = determine_char(hypotheses{it}(it_rep));
                end
                
            case 2 % Smaller meals
                n_par   = 3;
                runs    = -1:1/(n_rep-1):1; % Number of meals
                
            case 3 % Smaller meals
                n_par   = 4;
                runs    = -1:1/(n_rep-1):1; % Number of meals
                
            case 4 % ksi,a
                n_par   = 18;
                runs    = -1:1/(n_rep-1):1; % Number of meals
                
            case 5 % ksi,b
                n_par   = 19;
                runs    = -1:1/(n_rep-1):1; % Number of meals
                
            case 6 % kco
                n_par   = 20;
                runs    = -1:1/(n_rep-1):1; % Number of meals
                
            case 7 % Vmax
                n_par   = 10;
                runs    = -1:1/(n_rep-1):1; % Number of meals
                
            case 8
                n_par   = 28;
                runs    = -1:1/(n_rep-1):1; % Number of meals
                
            case 9
                n_par   = [12:15];
                runs1   = [10:-9/(n_rep-1):1];
                runs2   = [1:(1e-3-1)/(n_rep-1):1e-3];
                runs    = [runs1(1:end-1) runs2];
        end
        
        if it > 1 && it < 9
            for it_rep = 1:length(runs)
                change_current              = basis;
                change_current.param(n_par) = basis.param(n_par)*10^runs(it_rep);
                curr_hypothesis             = run_condition(change_current, 1);
                hyp_chars{it}(it_rep)       = determine_char(curr_hypothesis);
            end
        end
        
        if it ==  9
            for it_rep = 1:length(runs)
                change_current              = basis;
                for it2 = 1:length(n_par)
                    change_current.param(n_par(it2)) = basis.param(n_par(it2))^runs(it_rep);
                end
                curr_hypothesis             = run_condition(change_current, 1);
                hyp_chars{it}(it_rep)       = determine_char(curr_hypothesis);
            end
        end 
        
        disp(['   ', num2str(it) ' of 9 is done.'])
    end
    
    %% Save
    switch type_model{1}
        case 'basic'
            save basic_RYGB hyp_chars -v7.3
            
        case {'regulation1' 'regulation2' 'regulation3'}
            switch type_model{1}
                case 'regulation1'
                    save R1_RYGB hyp_chars
                case 'regulation2'
                    save R2_RYGB hyp_chars
                case 'regulation3'
                    save R3_RYGB hyp_chars
            end
    end
end

