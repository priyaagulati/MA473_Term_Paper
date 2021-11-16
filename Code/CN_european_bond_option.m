function prc = CN_european_bond_option(m, n, gamma, T, K, kappa, tht, sig, r_0, r_min, r_max, T_0)
	
	%  for European bond option prices 
	
    h = (r_max - r_min) / m;
    k = T / n;
    
    r = linspace(r_min, r_max, m + 1);
    
    A = sig * sig * (r .^ (2 * gamma)) / 2;
    B = kappa * (tht - r);
    C = -r;

    b_1 = -2 * k * A + B * h * k;
    b = 4 * k * A - 2 * h * h * k * C + 4 * h * h;
    b1 = -2 * k * A - B * h * k;
    
    c_1 = 2 * k * A - B * h * k;
    c = -4 * k * A + 2 * h * h * k * C + 4 * h * h;
    c1 = +2 * k * A + B * h * k;
    
    A = zeros(m + 1, m + 1);
    for i = 1 : m + 1
        if i - 1 > 0
            A(i, i - 1) = b_1(i);
        end
        A(i, i) = b(i);
        if i < m
            A(i, i + 1) = b1(i);
        end
    end
    
    B = zeros(m + 1, m + 1);
    for i = 1 : m + 1
        if i - 1 > 0
            B(i, i - 1) = c_1(i);
        end
        B(i, i) = c(i);
        if i < m
            B(i, i + 1) = c1(i);
        end
    end
    
    P = zeros(m + 1, n + 1);
    P(:, 1) = (ones(1, m + 1))';
    
    for i = 2 : n + 1    
        P(:, i) = A \ (B * P(:, i - 1));
        t = T - (i - 1) * k;
        P(1, i) = bond_price(kappa, tht, sig, r_min, t, T);
        P(m + 1, i) = bond_price(kappa, tht, sig, r_max, t, T);
    end
    
    V = zeros(m + 1, n + 1);
    V(:, 1) = max(P(:, floor(T_0 / k) + 1) - K, 0);
    
    for i = 2 : n + 1    
        V(:, i) = A \ (B * V(:, i - 1));
    end
    
    x = floor((r_0 - r_min) / h) + 1;
    prc = (V(x + 1, n + 1) - V(x, n + 1)) * (r_0 - (x - 1) * h) / h + V(x, n + 1);
%     fprintf('Crank m = %d err = %e\n\n', m, max(abs(err(m / 2 - 0 : m / 2 + 0, n + 1))));
end