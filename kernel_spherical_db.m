function [pos,J,gamma]=kernel_db(K,nb_cl)
% K-means Kernel Clustering
%
% "K" > kernel matrix
% "nb_cl" > number of clusters
% "Kinv"(optional) > inverse of K for kernel L+
%
% Classe > vector that contains the class of each point
% Rindex > RAND index of found clustering
%
% Authors: L. Yen & S. Garcia
%

% maximum number of iterations
MaxIters=500;
% small value that avoids 1/0
epsilon = 1e-6;

[nb_data,m] = size(K);
if nb_data ~= m
    error('non-squared matrix!');
end

J = [];

% initialization of gravity center matrix

I = randperm(nb_data);
%I = [1:nb_data];
E = eye(nb_data);
gamma = E(:,I(1:nb_cl));


for i = 1:MaxIters
    
    test = zeros(nb_cl,nb_data);
    for k = 1:nb_cl
        for j = 1:nb_data
            test(k,j) = epsilon + K(j,:)*gamma(:,k);
        end
    end
    
    % we choose the class of an observation according to the calculated
    % inner products
    [Val,pos] = max(test); % pos are the real classes according to current centers
    
    % le calcul du centre de gravité pour chaque classe
    %gamma_new = [];
    %gamma_new = repmat(pos,nb_cl,1);
    gamma_new = zeros(nb_cl,nb_data);
    Jaux = 0;
    theMean = zeros(nb_cl,1);
    for k = 1:nb_cl
    	for j = 1:nb_data
    		if (pos(j) == k)
    			gamma_new(k,j) = 1;
                theMean(k) = theMean(k) + gamma_new(k,j);
    			Jaux = Jaux + test(k,j);
    		else
    			gamma_new(k,j) = 0;
    		end
        end
        gamma_new(k,:) = gamma_new(k,:) - (theMean(k)/nb_data);
    end
    sum(gamma_new,2);
    norm = [];
    for k = 1:nb_cl
        norm(k) = sqrt(gamma_new(k,:)*K*(gamma_new(k,:))');
        gamma_new(k,:) = gamma_new(k,:) ./ norm(k);
    end;
    
    
    if (isempty(J) ~= 1) && (Jaux < J(end))
    	 er = 'ALERTAAAAAAAAAAAAAAAAAA'
    end
    J = [J; Jaux];
    gamma_new = gamma_new';
    
    %gamma
    %gamma_new
    %sum(sum(abs(gamma-gamma_new)))
    
    if sum(sum(abs(gamma - gamma_new))) < 1e-3
        break
    end
    gamma = gamma_new;
     
end
J;
return;  
    
    
