clear all;
close all;
clc;

% Bond prices under CKLS model for different values of the parameter γ

Gamma = [0.4 0.6 0.8 1.0];
T = 5;
kappa = 0.5;
tht = 0.08;
sig = 0.1;
mu = 500;
r_0 = 0.25;
r_min = 0;
r_max = 0.5;

M = [10 20 40 80 160 320];

for gamma = Gamma

    m = 320;
    n = max(T * m * m / ((r_max - r_min) * (r_max - r_min) * mu), 20);
    cn_prc = CN_bond(m, n, gamma, T, kappa, tht, sig, r_0, r_min, r_max);
    fprintf('gamma = %f, CN Price = %f\n', gamma, cn_prc);

    z = 1;
    for m = M
        n = max(T * m * m / ((r_max - r_min) * (r_max - r_min) * mu), 20);
        h = (r_max - r_min) / m;

        prc = jains_bond(m, n, gamma, T, kappa, tht, sig, r_0, r_min, r_max, z);

        fprintf('M = %d, Price = %f \n', m, prc);
        
        z = z + 1;
    end
    fprintf('\n\n');
end