clear all;
close all;
clc;

% Bermudan put option under CIR model on a bond with face value
% 1000 with coupon of 4% compounded annually

gamma = 0.5;
T = 5;
K = 0.8;
kappa = 0.1;
tht = 0.08;
sig = 0.075;
mu = 1000;
r_0 = 0.25;
r_min = 0;
r_max = 0.5;
T_0 = 3;

M = [2^4 2^5 2^6 2^7 2^8];
prv_err = 0;

m = 2^9;
n = max(T * m * m / ((r_max - r_min) * (r_max - r_min) * mu), 20);
n = floor(n);
ac_prc = CN_bermudan_bond_option_coupon(m, n, gamma, T, kappa, tht, sig, r_0, r_min, r_max) + 1e-12;
fprintf('Exact Price = %f\n\n', ac_prc);

fprintf('Crank Nicolson\n');
for m = M
    n = max(T * m * m / ((r_max - r_min) * (r_max - r_min) * mu), 20);
    n = floor(n);
    h = (r_max - r_min) / m;

    tic();
    prc = CN_bermudan_bond_option_coupon(m, n, gamma, T, kappa, tht, sig, r_0, r_min, r_max);
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
    n = floor(n);
    h = (r_max - r_min) / m;

    tic();
    prc = jains_bermudan_bond_option_coupon(m, n, gamma, T, kappa, tht, sig, r_0, r_min, r_max, z);
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