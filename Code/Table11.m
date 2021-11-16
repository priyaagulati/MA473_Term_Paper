clear all;
close all;
clc;

% European option for CIR model on bond with face value 100 
% and an annual coupon of 10% compounded
% semiannually at different strike prices

gamma = 0.5;
T = 5;
K_ar = [0.95 0.975 1 1.025 1.05];
kappa = 0.5;
tht = 0.08;
sig = 0.1;
mu = 400;
r_0 = 0.25;
r_min = 0;
r_max = 0.5;
T_0_ar = [0.5 1 1.5 2.0 3.0 4.0];
m = 320;
n = max(T * m * m / ((r_max - r_min) * (r_max - r_min) * mu), 20);

for T_0 = T_0_ar
    fprintf('T_0 = %f\n', T_0);
    for K = K_ar
        prc = jains_european_bond_option_coupon(m, n, gamma, T, K, kappa, tht, sig, r_0, r_min, r_max, T_0, 5);
        cr_prc = CN_european_bond_option_coupon(m, n, gamma, T, K, kappa, tht, sig, r_0, r_min, r_max, T_0);
        fprintf('Price = %f, Cr Price = %f\n', prc, cr_prc);
    end
    fprintf('\n');
end