clear all;
close all;
clc;

% European option for CIR model on bond with face value 100
% with an annual coupon of 10% compounded
% semiannually

gamma = 0.5;
T = 5;
K = 1;
kappa = 0.5;
tht = 0.08;
sig = 0.1;
mu = 500;
r_0 = 0.25;
r_min = 0;
r_max = 0.5;
T_0 = 2;

M = [10 20 40 80 160 320];
prv_err = 0;

m = 320;
n = max(T * m * m / ((r_max - r_min) * (r_max - r_min) * mu), 20);
ac_prc = CN_european_bond_option_coupon(m, n, gamma, T, K, kappa, tht, sig, r_0, r_min, r_max, T_0) + 1e-12;
fprintf('Exact Price = %f\n\n', ac_prc);

fprintf('Crank Nicolson\n');
for m = M
    n = max(T * m * m / ((r_max - r_min) * (r_max - r_min) * mu), 20);
    h = (r_max - r_min) / m;

    tic();
    prc = CN_european_bond_option_coupon(m, n, gamma, T, K, kappa, tht, sig, r_0, r_min, r_max, T_0);
    tm = toc();

    err = abs(prc - ac_prc) / ac_prc;
    
    if prv_err == 0
        fprintf('M = %d, Price = %f, Error = %e, Order = -, cpu = %f\n', m, prc, err, tm);
    else
        ord = log2(prv_err / err);
        fprintf('M = %d, Price = %f, Error = %e, Order = %f, cpu = %f\n', m, prc, err, ord, tm);
    end
    prv_err = err;
end
fprintf('\n\n');

fprintf('Jains Scheme\n');
z = 1;
for m = M
    n = max(T * m * m / ((r_max - r_min) * (r_max - r_min) * mu), 20);
    h = (r_max - r_min) / m;

    tic();
    prc = jains_european_bond_option_coupon(m, n, gamma, T, K, kappa, tht, sig, r_0, r_min, r_max, T_0, z);
    tm = toc();

    err = abs(prc - ac_prc) / ac_prc;
    
    if prv_err == 0
        fprintf('M = %d, Price = %f, Error = %e, Order = -, cpu = %f\n', m, prc, err, tm);
    else
        ord = log2(prv_err / err);
        fprintf('M = %d, Price = %f, Error = %e, Order = %f, cpu = %f\n', m, prc, err, ord, tm);
    end
    prv_err = err;
    z = z + 1;
end