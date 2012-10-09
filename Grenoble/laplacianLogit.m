function [X,Xc,Xs] = laplacianLogit(A,a)
% return the sigmoid commute-time kernel
% A = the adjacency matrix
% a = the parameter for the sigmoid transform
% X = the sigmoid commute-time kernel
% Xc = the centered sigmoid commute-time kernel
% Lp = the commute-time kernel
% L = the laplacian matrix

    [m,n] = size(A);


    D  = diag(sum(A,2));
    L  = D - A;
    Lp = pinv(L);

    s  = std(reshape(Lp,m*n,1));

    H = eye(m) - ones(m)./m;
    
    X  = ones(m)./(ones(m) + exp(-(a*Lp)/s));
    Xs = 2*X - 1;
    Xc = H*X*H;

