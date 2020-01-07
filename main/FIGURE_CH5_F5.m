%% Generate and plot FXR regulation calibration

% Prepare for all experiments
n1  = 12;
n2  = 24;
fn1  ={['Charac1_n',num2str(n1),'.mat']
       ['Charac2_n',num2str(n1),'.mat']
       ['Charac3_n',num2str(n1),'.mat']
       ['Charac4_n',num2str(n1),'.mat']
       ['Charac5_n',num2str(n1),'.mat']};
fn2  ={['Charac1_n',num2str(n2),'.mat']
       ['Charac2_n',num2str(n2),'.mat']
       ['Charac3_n',num2str(n2),'.mat']
       ['Charac4_n',num2str(n2),'.mat']
       ['Charac5_n',num2str(n2),'.mat']};
   
ind1 = [0 0 0 0 0];
ind2 = [0 0 0 0 0];

% Determine which experiments need performing
for it = 1:5 % "small"
    try load(fn1{it})

    catch
        ind1(it) = 1;
    end
end

for it = 1:3 % "big"- Do not do 4 and 5 for the bigger n
    try load(fn2{it})

    catch
        ind2(it) = 1;
    end
end

% Run experiments
% charac2 = characterize_regulation(n2, ind2);
% charac1 = characterize_regulation(n1, ind1);

%% Load results

load(fn1{1});
C1 = curr_char;

load(fn1{2});
C2 = curr_char;

load(fn1{3});
C3 = curr_char;


%% Make characterization plots
[basis]     = prep_for_exp(10);
basis.days  = 500;

% plot_regulation(basis, C1, 1)
% plot_regulation(basis, C2, 2)
% plot_regulation(basis, C3, 3)

plot_regulation(basis, C2, 4)
plot_regulation(basis, C3, 5)

