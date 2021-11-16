clear all;
close all;
clc;

% European bond option prices under the CIR model for option 
% maturities To = 2 and T0 = 5

gamma = 0.5;
T = 10;
K = 0.35;
kappa = 0.5;
tht = 0.08;
sig = 0.1;
mu = 1000;
r_0 = 0.25;
r_min = 0;
r_max = 0.5;
T_0 = 5;

M = [10 20 40 80 160 320];

m = 320;
n = max(T * m * m / ((r_max - r_min) * (r_max - r_min) * mu), 20);
cn_prc = CN_european_bond_option(m, n, gamma, T, K, kappa, tht, sig, r_0, r_min, r_max, T_0);

fprintf('CN Price = %f\n\n', cn_prc);

z = 1;
prv_err = 0;

for m = M

    n = max(T * m * m / ((r_max - r_min) * (r_max - r_min) * mu), 20);
    h = (r_max - r_min) / m;

    tic;
    prc = jains_european_bond_option(m, n, gamma, T, K, kappa, tht, sig, r_0, r_min, r_max, T_0, z);
    tm = toc;

    err = abs(prc - cn_prc) / cn_prc;
    
    if prv_err == 0
        fprintf('M = %d, Price = %f, Error = %e, Order = -, cpu = %f\n', m, prc, err, tm);
    else
        ord = log2(prv_err / err);
        fprintf('M = %d, Price = %f, Error = %e, Order = %f, cpu = %f\n', m, prc, err, ord, tm);
    end
    prv_err = err;
    z = z + 1;
end
fprintf('\n\n');

T_0 = 2;

m = 320;
n = max(T * m * m / ((r_max - r_min) * (r_max - r_min) * mu), 20);
cn_prc = CN_european_bond_option(m, n, gamma, T, K, kappa, tht, sig, r_0, r_min, r_max, T_0);

fprintf('CN Price = %f\n\n', cn_prc);

z = 1;
prv_err = 0;

for m = M

    n = max(T * m * m / ((r_max - r_min) * (r_max - r_min) * mu), 20);
    h = (r_max - r_min) / m;

    tic;
    prc = jains_european_bond_option(m, n, gamma, T, K, kappa, tht, sig, r_0, r_min, r_max, T_0, z);
    tm = toc;

    err = abs(prc - cn_prc) / cn_prc;
    
    if prv_err == 0
        fprintf('M = %d, Price = %f, Error = %e, Order = -, cpu = %f\n', m, prc, err, tm);
    else
        ord = log2(prv_err / err);
        fprintf('M = %d, Price = %f, Error = %e, Order = %f, cpu = %f\n', m, prc, err, ord, tm);
    end
    prv_err = err;
    z = z + 1;
end