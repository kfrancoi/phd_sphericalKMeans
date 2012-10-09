function [X,Xc] = regularizedCTkernel(A,a)
% return the regularized commute-time kernel
% A  = the adjacency matrix containing affinities
% a  = the parameter regularized CT kernel
% X  = the regularized commute-time matrix
% Xc = the centered regularized commute-time matrix

eps = 0.000000001;

if (a < eps) || (a > (1 - eps))
    fprintf('ERROR: The value of a is out of the admissible range [0,1]: %g !\n',a);
    return;
end;
    [m,n] = size(A);


    D  = diag(sum(A,2));
    Lr = D - a*A;
    X  = inv(Lr);

    H = eye(m) - ones(m)./m;
        
    Xc = H*X*H;