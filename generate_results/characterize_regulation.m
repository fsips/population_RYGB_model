function [charac] = characterize_regulation(n, include)

[basis]     = prep_for_exp(10);
basis.days  = 500;

%% Lets set regulation
if include(1)
    par_num          = 29;
    par_values1      = 10.^2;
    par_values2      = 10.^[-5:6/(n-1):1];
    
    for curr_case = 1:3
        disp(['Initiating case ', num2str(curr_case) ' of 3.'])
        
        change_current = basis;
        
        change_current.param(25)        = 1/6000;
        change_current.param(26)        = 1/6000;
        change_current.param(27)        = 1/6000;
        change_current.param(par_num)   = par_values1;
        
        for it = 1:length(par_values2)
            if curr_case == 1
                change_current.param(22)        = par_values2(it);
            end
            if curr_case == 2
                change_current.param(23)        = par_values2(it);
            end
            if curr_case == 3
                change_current.param(24)        = par_values2(it);
            end
            
            charac{1,curr_case}.run(it)     = run_condition(change_current, 1);
            charac{1,curr_case}.par(it)     = par_values2(it);
            disp(['   ', num2str(it) ' of ',num2str(length(par_values2)),' is done.'])
        end
    end
    
    
    for it1 = 1:3
        for it2 =1:length(charac{1,it1}.run)
            synth(it1,it2)      = charac{1,it1}.run(it2).v(end).li_x_pc;
            asbt(it1,it2)       = charac{1,it1}.run(it2).v(end).Vmax;
            plasma(it1,it2)     = sum(charac{1,it1}.run(it2).x(end,69:72));
        end
    end
    
    l_D1 = interp1(synth(1,:)'./basis.param(21), charac{1,1}.par, 10);
    l_D2 = interp1(synth(2,:)'./basis.param(21), charac{1,2}.par, 10);
    l_D3 = interp1(asbt(3,:)' ./basis.param(10), charac{1,3}.par, 4);
   
    curr_char = [charac{1,:}];
    save(['Charac1_n', num2str(n), '.mat'], 'curr_char');
    save(['kD_n', num2str(n), '.mat'], 'l_D1', 'l_D2', 'l_D3');
end

%% What is the influence of disappearing BA from si4?
if include(2)
    load(['kD_n', num2str(n), '.mat']);
    
    par_num          = 29;
    par_values       = 10.^[-6:(8/(n-1)):2];
    
    for curr_case = 1:4
        disp(['Initiating case ', num2str(curr_case) ' of 4.'])
        change_current = basis;
        change_current.param(25)        = 1/6000;
        change_current.param(26)        = 1/6000;
        change_current.param(27)        = 1/6000;
        
        if curr_case == 1 || curr_case == 4
            change_current.param(22)        = l_D1;
        end
        if curr_case == 2 || curr_case == 4
            change_current.param(23)        = l_D2;
        end
        if curr_case == 3 || curr_case == 4
            change_current.param(24)        = l_D3;
        end
        
        for it = 1:length(par_values)
            change_current.param(par_num)   = par_values(it);
            charac{2,curr_case}.run(it)       = run_condition(change_current, 1);
            charac{2,curr_case}.par(it)       = par_values(it);
            
            disp(['   ', num2str(it) ' of ',num2str(length(par_values)),' is done.'])
        end
    end
    
    curr_char = [charac{2,:}];
    save(['Charac2_n', num2str(n), '.mat'], 'curr_char');
end

%% What is the influence of BA appearing into si4?
if include(3)
    par_num          = 30;
    par_values       = 10.^[-4:(6/(n-1)):2];
    
    for curr_case = 1:4
        disp(['Initiating case ', num2str(curr_case) ' of 4.'])
        change_current = basis;
        change_current.param(25)        = 1/6000;
        change_current.param(26)        = 1/6000;
        change_current.param(27)        = 1/6000;
        
        if curr_case == 1 || curr_case == 4
            change_current.param(22)        = l_D1;
        end
        if curr_case == 2 || curr_case == 4
            change_current.param(23)        = l_D2;
        end
        if curr_case == 3 || curr_case == 4
            change_current.param(24)        = l_D3;
        end
        
        for it = 1:length(par_values)
            change_current.param(par_num)   = par_values(it);
            charac{3,curr_case}.run(it)     = run_condition(change_current, 1);
            charac{3,curr_case}.par(it)     = par_values(it);
            
            disp(['   ', num2str(it) ' of ',num2str(length(par_values)),' is done.'])
        end
    end
    
    curr_char = [charac{3,:}];
    save(['Charac3_n', num2str(n), '.mat'], 'curr_char');
end

%% What is the influence of disappearing BA from si4?
if include(4)
    load(['kD_n', num2str(n), '.mat']);
    
    par_num          = 29;
    par_values       = 10.^[-6:(8/(n/2-1)):2];
    
    par_values_2     = [1:(9/(n/2-1)):10]; % k_sp
    par_values_3     = [-n/2:1:n/2]/2;
    
%     matlabpool(3);
    for curr_case = 1:3
        disp(['Initiating case ', num2str(curr_case) ' of 3.'])
        
        for it1 = 1:length(par_values_2)
            [basis]                         = prep_for_exp(par_values_2(it1));
            basis.days                      = 500;
            change_current                  = basis;
            change_current.param(25)        = 1/6000;
            change_current.param(26)        = 1/6000;
            change_current.param(27)        = 1/6000;
            
            for it2 = 1:length(par_values_3)
                
                if curr_case == 1 || curr_case == 4
                    change_current.param(22)        = l_D1*10^par_values_3(it2);
                end
                if curr_case == 2 || curr_case == 4
                    change_current.param(23)        = l_D2*10^par_values_3(it2);
                end
                if curr_case == 3 || curr_case == 4
                    change_current.param(24)        = l_D3*10^par_values_3(it2);
                end
                
                for it3 = 1:length(par_values)
                    change_current.param(par_num)   = par_values(it3);
                    charac{4,curr_case}.run(it1,it2,it3)       = run_condition(change_current, 1);
                    charac{4,curr_case}.par(it1,it2,it3)       = par_values(it3);
                end
            end
        end
    end
%     matlabpool close
    
    curr_char = [charac{4,:}];
    save(['Charac4_n', num2str(n), '.mat'], 'curr_char', '-v7.3');
end

%% What is the influence of BA appearing into si4?

if include(5)
    load(['kD_n', num2str(n), '.mat']);
    
    par_num          = 30;
    par_values       = 10.^[-4:(6/(n/2-1)):2];
    
    par_values_2     = [1:(9/(n/2-1)):10]; % k_sp
    par_values_3     = [-n/2:1:n/2]/2;
    
%     matlabpool(3);
    for curr_case = 1:3
        disp(['Initiating case ', num2str(curr_case) ' of 3.'])
        
        for it1 = 1:length(par_values_2)
            [basis]                         = prep_for_exp(par_values_2(it1));
            basis.days                      = 500;
            change_current                  = basis;
            change_current.param(25)        = 1/6000;
            change_current.param(26)        = 1/6000;
            change_current.param(27)        = 1/6000;
            
            for it2 = 1:length(par_values_3)
                
                if curr_case == 1 || curr_case == 4
                    change_current.param(22)        = l_D1*10^par_values_3(it2);
                end
                if curr_case == 2 || curr_case == 4
                    change_current.param(23)        = l_D2*10^par_values_3(it2);
                end
                if curr_case == 3 || curr_case == 4
                    change_current.param(24)        = l_D3*10^par_values_3(it2);
                end
                
                for it3 = 1:length(par_values)
                    change_current.param(par_num)   = par_values(it3);
                    charac{5,curr_case}.run(it1,it2,it3)       = run_condition(change_current, 1);
                    charac{5,curr_case}.par(it1,it2,it3)       = par_values(it3);
                end
            end
        end
    end
%     matlabpool close
    
    curr_char = [charac{5,:}];
    save(['Charac5_n', num2str(n), '.mat'], 'curr_char', '-v7.3');
end


