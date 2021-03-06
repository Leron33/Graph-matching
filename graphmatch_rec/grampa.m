n = size(adj1, 1);
m=size(adj2,1);
[U, Lambda] = eigs(adj1);
[V, Mu] = eigs(adj2);
lambda = diag(Lambda);
mu = diag(Mu);
Coeff = 1 ./ ((lambda - mu').^2 + eta^2);
Coeff = Coeff .* (U' * ones(n,m) * V);
X = sparse(U * Coeff * V');