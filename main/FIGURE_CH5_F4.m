%% Generate results for non-FXR regulated in silico hypothesis testing
% (skip if already present)

% run_RYGB({'basic'})
% load('basic_RYGB.mat')
% hyp_chars_basic = hyp_chars;

%% Load results

load('basic_RYGB.mat')
hyp_chars_basic = hyp_chars;

%% Plot results

plot_RYGB_hypotheses1(hyp_chars_basic)

