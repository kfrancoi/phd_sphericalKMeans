function SoPstruct = sopCondRelatedness01(A0,theta);
% The SoP structure:
%
% - A0 is a square adjacency matrix.
%   The elements of A0 are positive.
%   If it is impossible to jump from node k to node l, A0(k,l) = 0,
%   which corresponds to an infinite cost.
%   Node j is supposed to be reachable from node i.
%
% 
% - theta  = 1;  %% theta must lie between eps (= 0.00000001) and 20.0.
%                %% If theta = 0, we obtain the expected cost between
%                %% i and j.
%                %% If theta = INFINITY, we obtain the shortest-path kernel.
%
%
% - i;  %% Initial node 1 <= i <= n.
% - j;  %% Destination node 1 <= j <= n.
%
%
% Returns SoPstruct: the SoP structure containing:
%  - MEstruct.K: the relatedness probability similarity matrix.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
eps   = 1000000 * realmin;
myMax = realmax;

[nr,nc] = size(A0);

if (nr ~= nc)
    fprintf('Error: The cost matrix is not square !\n');
    return;
end;

if (theta < eps) || (theta > 20.0)
    fprintf('Error: The value of theta is out of the admissible range [%g,20.0] !\n',eps);
    return;
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    e = ones(nr,1);
    I = eye(nr);
    H = I - e*e'/nr;
    
    % Computation of the cost matrix C (inverse of affinities)
    C  = A0;
    C(A0 >= eps) = 1./(A0(A0 >= eps));
    C(C < eps)   = myMax;
    A0(A0 < eps) = 0;

    % Computation of P, the reference transition probabilities matrix
    % representing the natural random walk on the graph
    P = costToPtrans01(C,eps);
    
    % Computation of the W matrix
    W = exp(-theta * C) .* P;
    
    % Computation of the Z matrix
    K   = (I - W)\I; %% = inv(I - W) % Matrix inverse-based method
    z   = sum(sum(K));
    K   = K/z;
    
    d   = K*e;
    Pc  = K ./ (d*e');
    Pc(1,1:5);
    PP = Pc*Pc;
    PP(1,1:5);
    
    Km  = K; % Modularity matrix
    di  = sum(Km,1);
    do  = sum(Km,2);
    D   = do * di;
    Ken = (log(Km) - log(D));
    Km  = (Km - D);
    
    Kd  = K;
    Kd(Kd < eps) = eps;
    D   = -log(Kd + eps);
    D  = 0.5 * (D + D'); %% Symmetrize the distance
    D  = D - diag(diag(D)); %% Set diagonal to zero
    Kd  = -0.5 * H*D*H;
    
    Kdc  = Pc;
    Kdc(Kdc < eps) = eps;
    Dc   = -log(Kdc + eps);
    Dc  = 0.5 * (Dc + Dc'); %% Symmetrize the distance
    Dc  = Dc - diag(diag(Dc)); %% Set diagonal to zero
    Kdc  = -0.5 * H*Dc*H;

    
    Di  = diag(diag(Kd));
    Kdn = (Di^-0.5)*Kd*(Di^-0.5);
    s   = std(reshape(Kd,nr*nc,1));
    a   = 1;
    Ks  = ones(nr)./(ones(nr) + exp(-(a*Kd)/s));
    Ks  = 2*Ks - 1;
         
SoPstruct.K   = K;
SoPstruct.Kn  = K - (e*e'/(nr*nc));
SoPstruct.Kc  = H*K*H;
SoPstruct.D   = D;
SoPstruct.Kd  = Kd;
SoPstruct.Kdn = Kdn;
SoPstruct.Ks  = Ks;
SoPstruct.Km  = Km;
SoPstruct.Ken = Ken;
SoPstruct.Pc  = Pc;
SoPstruct.Kdc = Kdc;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%