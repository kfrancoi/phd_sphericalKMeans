function [Kac,Kn] = amplifiedCommuteTimeKernel01(A)
% Usage: D = compute_amplified_commute_distance(A)
% Input: adjacency matrix A
% Output: amplified commute distance matrix D, with 0 diagonal. 

n  = size(A,2); 
e  = ones(n,1);
I  = eye(n);
H  = (I - (e*e'/n));
 
% first compute exact commute distance: 
R = resistance_distance(A); 

% compute commute time limit expression: 
d = sum(A, 2); 
Rlimit = repmat( (1./d ),1,n) + repmat( (1./d)',n,1);

% compute correction term u_{ij}: 
tmp = repmat(diag(A), 1, n) ./ (repmat(d.^2, 1, n)); 
tmp2 = repmat(d, 1, n) .* repmat(d', n, 1); 
uAu =  tmp + tmp' - 2 * A ./ tmp2; 

% compute amplified commute: 
tmp = R  - Rlimit - uAu; 

% enforce 0 diagonal: 
D = tmp - diag(diag(tmp));

% compute the associated kernel
Ds  = 0.5 * (D + D'); %% Symmetrize the distance
Ds  = Ds - diag(diag(Ds));
Kac = -0.5 * H*Ds*H;

% normalize the kernel matrix
Dn = diag(diag(Kac));
Kn = Dn^(-1/2) * Kac * Dn^(-1/2); % the normalized commute-time kernel
