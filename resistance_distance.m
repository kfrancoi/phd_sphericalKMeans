%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Dist = resistance_distance(A)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Returns the sigmoid commute-time kernel
%
% INPUT ARGUMENTS
% A: the (n x n) symmetric adjacency matrix
% a: the parameter for the sigmoid transform
%
% OUTPUT ARGUMENTS
% K: the (n x n) sigmoid commute-time kernel
% Kn: the (n x n) normalized sigmoid commute-time kernel
% Kamp: the (n x n) corrected, amplified commute-time kernel proposed by Von
% Luxburg
%
% AUTHORS: L. Yen & M. Saerens
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[nr,nc] = size(A);
n = nr;
if (nr ~= nc)
    error('Non-square matrix!');
end

e  = ones(n,1);
D  = diag(sum(A,2)); % the outdegree matrix
L  = D - A; % the laplacian matrix
K  = pinv(L); % the commute-time kernel

Dn = diag(K);

Dist = Dn*e' + e'*Dn - 2*K;

return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
