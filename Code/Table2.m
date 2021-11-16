clear all;
close all;
clc;

% Bond prices under the CIR model for T = 5
% For Crank Nicolson and Jain's Scheme

gamma = 0.5;
T = 5;
kappa = 0.5;
tht = 0.08;
sig = 0.1;
mu = 500;
r_0 = 0.25;
r_min = 0;
r_max = 0.5;

M = [10 20 40 80 160 320];
prv_err = 0;

ac_prc = bond_price(kappa, tht, sig, r_0, 0, T);
fprintf('Exact Price = %f\n\n', ac_prc);

fprintf('Crank Nicolson\n');
for m = M
    n = max(T * m * m / ((r_max - r_min) * (r_max - r_min) * mu), 20);
    h = (r_max - r_min) / m;

    tic();
    prc = CN_bond(m, n, gamma, T, kappa, tht, sig, r_0, r_min, r_max);
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
    prc = jains_bond(m, n, gamma, T, kappa, tht, sig, r_0, r_min, r_max, z);
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