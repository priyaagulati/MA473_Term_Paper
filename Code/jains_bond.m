function prc = jains_bond(m, n, gamma, T, kappa, tht, sig, r_0, r_min, r_max, z)
	
	% For bond prices
	
    h = (r_max - r_min) / m;
    k = T / n;
    
    r = linspace(r_min, r_max, m + 1);
    r_1 = linspace(r_min - h, r_max - h, m + 1);
    r1 = linspace(r_min + h, r_max + h, m + 1);
    
    xi = -kappa * (tht - r);
    xi_1 = -kappa * (tht - r_1);
    xi1 = -kappa * (tht - r1);
    
    b = 4 .* ((r1 .^ (2 * gamma))) .* (h * k * xi_1 .* (h * xi + sig * sig * (r .^ (2 * gamma))) + (r_1 .^ (2 * gamma)) .* (r1 .^ (-2 * gamma)) .* (h * h * k .* xi .* xi1 + sig * sig * (-h * k .* xi1 .* (r .^ (2 * gamma)) + (r1 .^ (2 * gamma)) .* (10 * h * h + 5 * h * h * k * r + 6 * k * sig * sig * (r .^ (2 * gamma))))));
    b_1 = (sig * sig .* (r .^ (2 * gamma)) .* (h * k .* xi1 .* (r_1 .^ (2 * gamma)) + (r1 .^ (2 * gamma)) .* (4 * h * h - 3 * h * k .* xi_1 + 2 * h * h * k * r_1 - 12 * k * sig * sig .* (r_1 .^ (2 * gamma)))) + h .* xi .* (-h * k * xi1 .* (r_1 .^ (2 * gamma)) + (r1 .^ (2 * gamma)) .* (4 * h * h - 3 * h * k .* xi_1 + 2 * h * h * k * r_1 - 10 * k * sig * sig .* (r_1 .^ (2 * gamma)))));
    b1 = (sig * sig .* (r .^ (2 * gamma)) .* (-h * k .* xi_1 .* (r1 .^ (2 * gamma)) + (r_1 .^ (2 * gamma)) .* (4 * h * h + 3 * h * k .* xi1 + 2 * h * h * k * r1 - 12 * k * sig * sig .* (r1 .^ (2 * gamma)))) - h .* xi .* (h * k * xi_1 .* (r1 .^ (2 * gamma)) + (r_1 .^ (2 * gamma)) .* (4 * h * h + 3 * h * k .* xi1 + 2 * h * h * k * r1 - 10 * k * sig * sig .* (r1 .^ (2 * gamma)))));
    
    c = 4 .* ((r1 .^ (2 * gamma))) .* (h * k * xi1 .* (r_1 .^ (2 * gamma)) .* (r1 .^ (-2 * gamma)) .* (-h * xi + sig * sig * (r .^ (2 * gamma))) + (-h * h * k .* xi .* xi_1 - sig * sig * h * k .* xi_1 .* (r .^ (2 * gamma))) + sig * sig *(r_1 .^ (2 * gamma)) .* (10 * h * h - 5 * h * h * k * r - 6 * k * sig * sig * (r .^ (2 * gamma))));
    c_1 = (sig * sig .* (r .^ (2 * gamma)) .* (-h * k .* xi1 .* (r_1 .^ (2 * gamma)) + (r1 .^ (2 * gamma)) .* (4 * h * h + 3 * h * k .* xi_1 - 2 * h * h * k * r_1 + 12 * k * sig * sig .* (r_1 .^ (2 * gamma)))) + h .* xi .* (h * k * xi1 .* (r_1 .^ (2 * gamma)) + (r1 .^ (2 * gamma)) .* (4 * h * h + 3 * h * k .* xi_1 - 2 * h * h * k * r_1 + 10 * k * sig * sig .* (r_1 .^ (2 * gamma)))));
    c1 = (sig * sig .* (r .^ (2 * gamma)) .* (h * k .* xi_1 .* (r1 .^ (2 * gamma)) + (r_1 .^ (2 * gamma)) .* (4 * h * h - 3 * h * k .* xi1 - 2 * h * h * k * r1 + 12 * k * sig * sig .* (r1 .^ (2 * gamma)))) + h .* xi .* (h * k * xi_1 .* (r1 .^ (2 * gamma)) + (r_1 .^ (2 * gamma)) .* (-4 * h * h + 3 * h * k .* xi1 + 2 * h * h * k * r1 - 10 * k * sig * sig .* (r1 .^ (2 * gamma)))));
    
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
        
        for j = 1 : z + 1
            P(j, i) = bond_price(kappa, tht, sig, r_min + (j - 1) * h, t, T);
            P(m + 2 - j, i) = bond_price(kappa, tht, sig, r_max - (j - 1) * h, t, T);
        end
    end
    
    x = floor((r_0 - r_min) / h) + 1;
    prc = (P(x + 1, n + 1) - P(x, n + 1)) * (r_0 - (x - 1) * h) / h + P(x, n + 1);
%     prc = P(floor((r_0 - r_min) / h) + 1, n + 1);
%     fprintf('Jains m = %d err = %e\n', m, max(abs(err(m / 2 - 0 : m / 2 + 0, n + 1))));
end