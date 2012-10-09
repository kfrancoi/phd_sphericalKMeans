function Q = BoP_modularity_kernels(A,theta,hitting,zlp)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Bag of paths modularity matrix
% Ilkka Kivim?ki 15/03/2012
% 
% Input:   
% - A:        Adjacency matrix
% - theta:    inverse temperature. Must lie between eps (= 0.00000001) and
%             20.0
% - hitting:  If 0, all paths are considered,
%             if 1, hitting paths are considered.
% - zlp:      If 0, zero-length paths are excluded,
%             if 1, zero-length paths are excluded.
% 
% Output:
% - Q:        The modularity matrix corresponding to the given set of
%             paths.
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
eps   = 1000000 * realmin;
myMax = realmax;

[nr,nc] = size(A);

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

% Computation of the cost matrix C (inverse of affinities)
% and P, the reference transition probabilities matrix
% representing the natural random walk on the graph

C  = A;
C(A >= eps) = 1./(A(A >= eps));
C(A < eps)   = myMax;
A(A < eps) = 0;

P = A;
Den = sum(P,2)*e';
P(Den > eps) = P(Den > eps)./Den(Den > eps);
P(P <= eps) = 0;

% Computation of the W matrix
W = exp(-theta * C) .* P;
% Computation of the Z matrix
Z   = (I - W)\I; %% = inv(I - W) % Matrix inverse-based method

% Non-hitting path probabilities:
if ~hitting
  % Including zero-length paths:
  if zlp
    z   = sum(sum(Z));
    Pi = Z/z;
  % Excluding zero-length paths:
  else
    Znz = Z-I;
    znz = sum(sum(Znz));
    Pi = Znz/znz;
  end
% Hitting path probabilities:
else
  diagZ = diag(Z);
  diagZ(diagZ==0) = Inf;
  Dh = diag(1./diagZ);
  Zh = Z*Dh;
  % Including zero-length paths:
  if zlp
    zh   = sum(sum(Zh));
    Pi   = Zh/zh;
  % Excluding zero-length paths:    
  else
    Zhnz   = Zh - I;
    zhnz = sum(sum(Zhnz));
    Pi   = Zhnz/zhnz;
  end
end
Pi_sym = (Pi+Pi')./2;

di = sum(Pi_sym,1);
do = sum(Pi_sym,2);
D  = do*di;

Q = Pi - D;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
