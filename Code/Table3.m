clear all;
close all;
clc;

%CIR and Vasicek bond prices for T = 30

gamma = 0.5;
T = 30;
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

fprintf('CIR Model\n');
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
fprintf('\n\n');

r_min = -0.5;
gamma = 0;

m = 320;
n = max(T * m * m / ((r_max - r_min) * (r_max - r_min) * mu), 20);
cn_prc = CN_bond(m, n, gamma, T, kappa, tht, sig, r_0, r_min, r_max);
fprintf('CN Price = %f\n\n', cn_prc);

fprintf('Vasicek Model\n');
z = 1;
for m = M
    n = max(T * m * m / ((r_max - r_min) * (r_max - r_min) * mu), 20);
    h = (r_max - r_min) / m;

    tic();
    prc = jains_bond(m, n, gamma, T, kappa, tht, sig, r_0, r_min, r_max, z);
    tm = toc();

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