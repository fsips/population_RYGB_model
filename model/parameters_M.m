function [p] = parameters_M(k_sp)

p(1) = 70.2744;     %    GIr_beta_GB;
p(2) = 10.2676;     %    GIr_beta_SI;
p(3) = 44.3465;     %    GIr_delta_GB;
p(4) = 2.9318;      %    GIr_delta_SI;
p(5) = 0.11753;     %    k_xl;
p(6) = 0.94811;     %    frac_gb;
p(7) = 0.0028652;   %    k_xg;
p(8) = 9.0396e-05;  %    k_xi_up_si;
p(9) = 0.00019177;  %    k_xi_up_co;
p(10) = 439.0471;   %    vmax_asbt;
p(11) = 9661.5151;  %    km_asbt;
p(12) = 0.55822;    %    frac_li_pu;
p(13) = 0.89483;    %    frac_li_pc;
p(14) = 0.50645;    %    frac_li_su;
p(15) = 0.82305;    %    frac_li_sc;
p(16) = 0.0025175;  %    k_uc;
p(17) = 0.076861;   %    k_bact_dsi;
p(18) = 0.15218;    %    k_si_1;
p(19) = 0.010429;   %    k_si_2;
p(20) = 0.0021237;  %    k_co_1;
p(21) = 0.82363;    %    k_u;
p(22) = 0;          %    k_FXR1
p(23) = 0;          %    k_FXR2
p(24) = 0;          %    k_ASBT
p(25) = 1/6000;     %    k_d1
p(26) = 1/6000;     %    k_d2
p(27) = 1/6000;     %    k_d3
p(28) = 0.0027;     %    k_deh;
p(29) = 0;          %    k_dis
p(30) = 0;          %    k_app
p(31) = k_sp;       %    k_sp

end