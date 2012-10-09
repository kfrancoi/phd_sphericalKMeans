function K = maxEntKullbackKernel01(A0,theta,distID);
% The maximum entropy dissimilarity
%
% A0 is the square adjacency matrix containing affinities, for example:
%
% A0  =    [  0   1   1   0   0   0   0
%             1   0   1   0   0   0   0
%             1   1   0   1   0   0   0
%             0   0   1   0   1   1   1
%             0   0   0   1   0   1   1
%             0   0   0   1   1   0   1
%             0   0   0   1   1   1   0 ];
% 
% theta  = 1;  %% theta must lie between 0.000001 and 20.0.
%              %% If theta = 0 and distID = 1, we obtain the commute-time
%              %% distance.
%              %% If theta = INFINITY, we obtain the shortest-path distance.
%
% distID = 1;  %% = 1 if "distance with an absorbing state" (default
%              %%     value).
%              %% = 0 if "simple distance without any absorbing state".
%
% Returns Dme: the maximum entropy dissimilarity, a dissimilarity measure between the
% nodes of the network.

max = realmax;
eps = 0.00000001;

[nr,nc] = size(A0);
Ds      = eye(nr,nc);
    
if (nr ~= nc)
    fprintf('The adjacency matrix is not square !\n');
    return;
end;

if (theta < eps) || (theta > 20.0)
    fprintf('The value of theta is out of the admissible range [%g,20.0] !\n',eps);
    return;
end;

if ((distID ~= 0) && (distID ~= 1))
    fprintf('distID must be equal to 0 or 1 !\n');
    return;
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Computation of the cost matrix A
    A  = A0;
    A(A0 >= eps) = 1./(A0(A0 >= eps));
    A(A < eps)   = max;
    A0(A0 < eps) = 0;
    
    e  = ones(nr,1);
    I  = eye(nr);
    H = I - e*e'/nr;


    e1 = I(:,1);
    en = I(:,nc);

    % Computation of P, the transition probabilities matrix
    P   = A0;
    s   = sum(P,2);
    P   = P./(s*e');
    
    % Computation of the W and Z matrices
    W   = exp(-theta * A) .* P;
    Z   = (I - W)\I; %% = inv(I - W)
    
    D = zeros(nc,nr);
    if (distID == 1) %% Absorbing state distance
        % The most efficient computation of the update, but false up to
        % now. Do not use !
        %D = ( (Z * (A .* W) * Z) ./ Z ) - e * (diag((A .* W) * Z))' * diag((diag(Z) - e)./diag(Z));
        for j = 1:nc
            Ij  = I;
            Ij(j,j) = 0;
            ej  = I(:,j);

            % Still another very efficient optimized way of computing the
            % update
            %Zc  = Z;
            %Zc(:,j) = Zc(:,j)/Z(j,j);
            
			% An optimized way of computing the update (different from the KDD paper)
            zc  = Z(:,j); % zc  = Z*ej;
			zr  = Z(j,:); % zr  = ej'*Z;
			
			Zc  = Z - zc*(zr - ej')/Z(j,j);
			
			% The other way of computing the update (same as in the KDD paper)
            %wj  = (W(j,:))';
            %zj  = Z*ej;
            %Zc  = Z - ( (zj*wj'*Z) / (1 + wj'*zj) );
            
            
            zcj = Zc(:,j); % zcj = Zc*ej;
            
            D(:,j) = (Zc * (A .* (Ij*W)) * zcj) ./ zcj;
        end;
    else %% Non absorbing state distance
        D = (Z * (A .* W) * Z) ./ Z;
    end;
    D
    
    D  = 0.5 * (D + D'); %% Symmetrize the distance
    D  = D - diag(diag(D)); %% Set diagonal to zero
    K  = -0.5 * H*D*H; %% Convert to kernel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%