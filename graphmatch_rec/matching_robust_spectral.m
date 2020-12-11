% Improved implementation of our new robust spectral method 
% A and B are the matrices to be matched 
% eta is the tuning parameter comparable to noise level sigma
% Return permutation matrix P so that P*A*P' is matched to B 

function [X] = matching_robust_spectral(A, B, eta)
    n = size(A, 1);
    m=size(B,1);
    [U, Lambda] = eigs(A);
    [V, Mu] = eigs(B);
    lambda = diag(Lambda);
    mu = diag(Mu);
    Coeff = 1 ./ ((lambda - mu').^2 + eta^2);
    Coeff = Coeff .* (U' * ones(n,m) * V);
    X = U * Coeff * V';
    
    %% Rounding by linear assignment - better but slower 
%    M = matchpairs(X', -99999, 'max');
%    P = full(sparse(M(:, 1), M(:, 2), 1, n, n));
%    C=X-min(min(min(X),0));
%    C=C*10^6;
%    C=round(C);
%    [assignments,P]=sparseAssignmentProblemAuctionAlgorithm(C');
    %% Greedy matching - faster but worse 
%    P = full(greedy_match_better(X',A,DA_model,DB_model));

    %% Greedy rounding
%     [~, ind_max] = max(X);
%     P = full(sparse(1:n, ind_max, 1, n, n));