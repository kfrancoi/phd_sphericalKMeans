function [X,Xc,Xa] = modularity01(A)
% return the sigmoid commute-time kernel
% A  = the square adjacency matrix
% X  = the modularity matrix
% Xc = the centered modularity kernel

    [m,n] = size(A);
    e   = ones(n,1);
    I   = eye(n);
    H   = I - e*e'/n;
    vol = sum(sum(A));


    di = sum(A,1);
    do = sum(A,2);
    D  = (do * di)/vol;
    
    X  = (A - D)/vol;

    Xc = H*X*H;
    Xa = H*A*H;

