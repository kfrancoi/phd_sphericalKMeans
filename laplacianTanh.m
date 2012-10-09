function [X,Xc] = laplacianTanh(A,a)
% return the hyperbolic tangent commute-time kernel
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
    
    %X  = ones(m)./(ones(m) + exp(-(a*Lp)/s));
    X = tanh((a*Lp)/s);
    
    Xc = H*X*H;

