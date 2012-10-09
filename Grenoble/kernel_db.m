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
    	['cluster ',num2str(k)];
    	gamma(:,k)';
        gkg = gamma(:,k)' * K * gamma(:,k);
        for j = 1:nb_data
        	K(j,:);
            kg = K(j,:)*gamma(:,k);
            test(k,j) = epsilon + K(j,j)+ gkg - 2*kg;
        end
    end
    
    % we choose the class of an observation according to the calculated distances
    test;
    [Val,pos] = min(test); % pos are the real classes according to current centers
    %test
    %pos
   	%count the number of observations of each cluster
    n = zeros(1,nb_cl);
    for k = 1:nb_cl
    	for j = 1:nb_data
    		if (pos(j) == k)
    			n(1,k) = n(1,k) + 1;
    		end
    	end
    end
    n
    
    % le calcul du centre de gravité pour chaque classe
    gamma_new = [];
    %gamma_new = repmat(pos,nb_cl,1);
    Jaux = 0;
    for k = 1:nb_cl
    	for j = 1:nb_data
    		if (pos(j) == k) %(gamma_new(k,j) == k)
    			gamma_new(k,j) = (1/n(1,k));
    			Jaux = Jaux + test(k,j);
    		else
    			gamma_new(k,j) = 0;
    		end
    	end
    end
    if (isempty(J) ~= 1) && (Jaux > J(end))
    	 er = 'ALERT'
    end
    J = [J; Jaux];
    gamma_new = gamma_new';
    %gamma
    %gamma_new
    %sum(sum(abs(gamma-gamma_new)))
    if sum(sum(abs(gamma-gamma_new))) < 1e-5
        break
    end
    gamma = gamma_new;
     
end

gamma
return;  
    
    
