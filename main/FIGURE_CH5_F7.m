%% Generate results

% 1. With, without, and one in between
%
% run_RYGB_example()

% 2. Create factor F_L from difference of L0 from with and without. Note
% that ASBT difference, which is also calculated, is almost identical
%
% load('RYGB_example.mat')
% extract_factor_RYGBexample1(post_days)

% 3. Use this factor to create examples 2 (multiple curves in Reg a) and 4
% (multiple curves in Reg b)
%
% run_RYGB_example2()
% run_RYGB_example4()

%% PLOT IN SILICO (reg a)
load('RYGB_example2.mat')
plot_insilico_RYGB()

%% PLOT IN SILICO (reg b)
% load('RYGB_example4.mat')
% plot_insilico_RYGB()