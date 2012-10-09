function SoPstruct = sopRelatednessPotentialDistance01(A0,theta,distID);
% The SoP structure:
%
% - A0 is a square adjacency matrix.
%   The elements of A0 are positive and represent affinities between nodes.
%   If it is impossible to jump from node k to node l, A0(k,l) = 0,
%   which corresponds to an infinite cost.
%   Each node j is supposed to be reachable from each node i.
%
% 
% - theta  = 1;  %% theta must lie between eps (= 0.00000001) and 20.0.
%                %% If theta = 0, we obtain the expected cost between
%                %% i and j.
%                %% If theta = INFINITY, we obtain the shortest-path kernel.
%
% - distID = 1;  %% = 1 if "distance with an absorbing state" (default
%                %%     value).
%                %% = 0 if "simple distance without any absorbing state".
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

if (theta < eps) || (theta > 30.0)
    fprintf('Error: The value of theta is out of the admissible range [%g,30.0] !\n',eps);
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
    %W = exp(-theta * C);
    
    % Computation of the Z matrix
    Z   = (I - W)\I; % = inv(I - W) % Matrix inverse-based method
                     % paths of length zero are taken into account

    if (distID == 1) % Absorbing state distance (hitting paths)
        da = diag(Z);
        Za  = Z ./ (e*da');
    else % Non absorbing state distance (non hitting paths)
        Za = Z;
    end;
    
    K   = Za; % The potential matrix - paths of length zero are taken into account
    Ks  = (K + K')/2; % Symmetrize the potential matrix
    
    Kd  = Ks;
    Kd(Kd < eps) = eps;
    D   = -log(Kd + eps)/theta;  % The potential distance matrix
    D   = 0.5 * (D + D'); % Symmetrize the distance
    D   = D - diag(diag(D)); % Set diagonal to zero
    Kd  = -0.5 * H*D*H; % Compute a kernel matrix
    
    Di  = diag(diag(Kd));
    Kdn = (Di^-0.5)*Kd*(Di^-0.5);
         
SoPstruct.K   = K; % The potential matrix
SoPstruct.Ks  = Ks; % The symmetrized potential matrix
SoPstruct.Kd  = Kd; % Kernel associated to the potential distance
SoPstruct.Kdn = Kdn; % Normalized kernel associated to the potential distance

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%