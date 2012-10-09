function [pos,P,J,gamma]=kernel_db(K,nb_cl)
% cette fonction effectue un clustering des donn�es bas� sur la matrice 
% kernel des donn�es.
%
% K = la matricclase kernel, donne le produit scalaire entre tous pairs de points
% nb_cl = le nombre de clusters qu'il faut trouver
% Kinv (facultatif)= La matrice inverse du kernel, pour le cas du kernel L+
%
% Classe = le vecteur contenant la classe de chaque point
% Rindex = le adjusted RAND index du clustering trouv�
%
% prog de L. Yen
%

% param�tre pour le clustering
MaxIters=500;
% param�tre pour la descente de gradient
alpha = 0.9;
% valeur petite pour �viter d'avoir 1/0
epsilon = 1e-6;

[nb_data,m] = size(K);
if nb_data ~= m
    error('matrice K n''est pas carree');
end

J = [];

% initialisation de la matrice de centre de gravit�

I = randperm(nb_data);
E = eye(nb_data);
gamma = E(:,I(1:nb_cl));


for i = 1:MaxIters
    
    test = zeros(nb_cl,nb_data);

    for k = 1:nb_cl
        gkg = gamma(:,k)' * K * gamma(:,k);

        for j = 1:nb_data
            kg = K(j,:)*gamma(:,k);
            test(k,j) = epsilon + K(j,j)+ gkg - 2*kg;
        end
    end
 
    % attribution des classes en fonction de la distance
    [Val,pos] = min(test);
    
    % le calcul du centre de gravit� pour chaque classe
    gamma_new = [];
    Pq = P.^q;
    J = [J; sum(sum(Pq .* test))];
    gamma_new = Pq ./ repmat(sum(Pq,2),1,nb_data);
    gamma_new = gamma_new';
    if sum(sum(abs(gamma-gamma_new))) < 1e-5
        break
    end
    gamma = gamma_new;
    
end
    