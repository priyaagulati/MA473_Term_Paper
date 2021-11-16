function z = bond_price(kappa, tht, sig, r, t, T)
	% analytical solution for calculating CIR bond price
	% Equation 4 of paper
    h = sqrt(kappa * kappa + 2 * sig * sig);
    A = ((2 * h * exp((kappa + h) * (T - t) / 2)) / (2 * h + (kappa + h) * (exp((T - t) * h) - 1))) ^ (2 * kappa * tht / (sig * sig));
    B = (2 * (exp((T - t) * h) - 1)) / (2 * h + (kappa + h) * (exp((T - t) * h) - 1)); 
    z = A .* exp(-B .* r);
    
end