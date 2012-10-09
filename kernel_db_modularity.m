function [cluster,J,U]=kernel_db_marco(K,m,mu)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Kernel k-means clustering
%
% INPUT ARGUMENTS
% K: the (n x n) kernel matrix
% m: number of clusters to be found
%
% OUTPUT ARGUMENTS
% cluster: a (n x 1) vector containing the cluster index of each node
% J: a (n_iterations x 1) vector containing the evolution of the within-cluster
% inertia criterion during iterations
% H: the (n x m) prototypes matrix containing the prototypes of each
% cluster as columns
%
% AUTHORS: L. Yen, S. Garcia & M. Saerens
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Maximum number of iterations
maxIters = 100;
% Small value that avoids 1/0
epsilon = 1e-9;

[nr,nc] = size(K);
n = nr;
if nr ~= nc
    error('Non-square matrix!');
end

Jold = compute_criterion(K,(ones(n,1))); % total modularity of the whole data set
J = [Jold];

% Initialization of the membership vectors
p = randperm(n);
I = eye(n);
U = I(:,p(1:m));
S = K*U;
[val,cluster] = max(S,[],2); % cluster contains the assigned cluster indexes, according to current prototypes
U = zeros(n,m);
for i = 1:n
    U(i,cluster(i)) = 1;
end

e = ones(m,1);

for i = 1:maxIters
    % Computation of the distances of the nodes to the cluster prototypes,
    % in the embedded space
    K*U
    U = exp(mu*K*U);
    D = diag(U*e);
    U = inv(D) * U;
    
    % Compute the new within-inertia criterion
    Jold = J(end);
    Jnew = compute_criterion(K,U);
    
    if (~isempty(J)) && (Jnew < Jold)
    	 er = 'ALERT'; %  the modularity should always increase
    end
    J = [J; Jnew];

    if (abs(Jnew - Jold)/abs(Jold)) < 1e-6
        break
    end     
end
[val,cluster] = max(U,[],2);
J
return


function J = compute_criterion(K,U)

[nr,nc] = size(K);
if (nr ~= nc)
    error('Non-square matrix K !');
else
    n = nr;
end

[nr,nc] = size(U);
m = nc;
if (nr ~= n)
    error('The H matrix and K matrix are incompatible !'); 
end

J = 0;
for k = 1:m
    J = J + U(:,k)' * K * U(:,k);
end

return
    
    
