function [cluster,J,H]=kernel_db_ilkka(K,m)
%%
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
%
% A = [0,  1,  1,  1,  1,  0,  0,  0,  0,  0
%      1,  0,  1,  1,  1,  0,  0,  0,  0,  0
%      1,  1,  0,  1,  1,  0,  0,  0,  0,  0
%      1,  1,  1,  0,  1,  1,  0,  0,  0,  0
%      1,  1,  1,  1,  0,  0, 0.5, 0,  0,  0
%      0,  0,  0,  1,  0,  0,  1,  1,  1,  1
%      0,  0,  0,  0, 0.5, 1,  0,  1,  1,  1
%      0,  0,  0,  0,  0,  1,  1,  0,  1,  1
%      0,  0,  0,  0,  0,  1,  1,  1,  0,  1
%      0,  0,  0,  0,  0,  1,  1,  1,  1,  0];

% Maximum number of iterations
maxIters = 100;
% Small value that avoids 1/0
epsilon = 1e-9;
printerror = 1;

[nr,nc] = size(K);
n = nr;
if nr ~= nc
    error('Non-square matrix!');
end

Jold = compute_criterion(K,(ones(n,1)),(ones(n,1)/n)); % total inertia of the whole data set
J = Jold;

% Initialization of the prototype vectors
p = randperm(n);
I = eye(n);
H = I(:,p(1:m));

for j = 1:maxIters
    % Computation of the distances of the nodes to the cluster prototypes,
    % in the embedded space:
    KH = K*H;
    HKH = H'*KH;    
    Hkk = repmat(diag(HKH)', n, 1);
    Kii = repmat(diag(K), 1, m);    
    Dist = Kii + Hkk - 2*KH;

    if j > 1
      Jnew = 0;
      % Compute the within-cluster inertia:
      for k = 1:m
        Jnew = Jnew + U(:,k)'*Dist(:,k);
      end

      if (~isempty(J)) && (Jnew > Jold) && printerror
       disp('the within-cluster inertia should always decrease!!!');
       printerror = 0;
      end
      J = [J; Jnew];
      if (abs(Jnew - Jold)/abs(Jold)) < 1e-6
        break
      end
      Jold = Jnew;
    end

    % We choose the class of a node according to the calculated distances
    [val,cluster] = min(Dist,[],2); % cluster contains the assigned cluster indexes, according to current prototypes
    U = zeros(n,m);
    for i = 1:n
        U(i,cluster(i)) = 1;
    end

    % We count the number of observations of each cluster and compute new
    % prototypes
    Hold = H;
    numb  = sum(U,1);
    for k = 1:m
        H(:,k) = U(:,k)./numb(k);
    end
%     if sum(sum(Hold-H)) == 0
%       break
%     end

end


function J = compute_criterion(K,U,H)

[nr,nc] = size(K);
if (nr ~= nc)
    error('Non-square matrix K !');
else
    n = nr;
end

[nr,nc] = size(H);
m = nc;
if (nr ~= n)
    error('The H matrix and K matrix are incompatible !'); 
end

[nr,nc] = size(U);
if ~( (nr == n) && (nc == m) )
    error('The H matrix and U matrix are incompatible !');
end

I = eye(n,n);
J = 0;
for i = 1:n
    for k = 1:m
        J = J + U(i,k) * (H(:,k) - I(:,i))' * K * (H(:,k) - I(:,i));
    end
end
return
    

