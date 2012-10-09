function [K,Kc] = regularizedLaplacianKernel(A,a)
% return the regularized Laplacian kernel
% A  = the adjacency matrix containing affinities
% a  = the parameter regularizing the Laplacian kernel
% K  = the regularized Laplacian matrix
% Kc = the centered regularized Laplacian matrix

eps = 0.000000001;

if (a < eps) || (a > (1 - eps))
    fprintf('ERROR: The value of a is out of the admissible range [0,1]: %g !\n',a);
    return;
end;
    [m,n] = size(A);

    I  = eye(m);
    D  = diag(sum(A,2));
    L  = D - A;
    
    K  = (I + (a*L))\I; %inv(I + (a*L));

    H = I - ones(m)./m;
        
    Kc = H*K*H;
end