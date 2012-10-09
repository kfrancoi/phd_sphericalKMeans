function Xc = laplacian(A)
% returns the commute-time kernel
% A = the adjacency matrix
% Xc = the laplacian matrix

    [m,n] = size(A);


    D  = diag(sum(A,2));
    L  = D - A;
    Xc = pinv(L);

