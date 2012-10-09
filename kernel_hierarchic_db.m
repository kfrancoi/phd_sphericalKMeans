function [pos,tree] = kernel_hierarchic_db(K,nb_cl)
%function [pos,J,Pwx,gamma,test]=kernel_clustering6(K,nb_cl,Kinv)
% cette fonction effectue un clustering des données basé sur la matrice 
% kernel des données.
%
% K = la matricclase kernel, donne le produit scalaire entre tous pairs de points
% nb_cl = le nombre de clusters qu'il faut trouver
%
% pos = le vecteur contenant la classe de chaque point
% J = la mesure de variance intra-classe au final
%
% prog de L. Yen
%

MAXIMUM = 10000000;


[nb_data,m] = size(K);
if nb_data ~= m
    error('matrice K n''est pas carree');
end
pos = zeros(1,nb_data);
%matrice pour dendrogram
tree = [];

% construction de la matrice des prototype, chaque ligne est le prototype
% de chaque classe. Au départ, chaque noeud est une classe
proto = eye(nb_data);

% vecteur contenant le nombre de points dans chaque classe
vec_cl = ones(nb_data,1);

% index des clusters en cours
index = 1:nb_data;

% la classe des noeuds
Estindex = 1:nb_data;

% le numéro de la dernière classe
dernier = nb_data;

%tic
% initialisation de la matrice de différence de prototype
%Diff = ones(size(proto,1));%*MAXI;
Diff = ones(size(proto,1))*MAXIMUM;
for q = 1:size(proto,1)
    %diff = repmat(proto(q,:),nb_data,1)-proto;
    %Diff(:,q) = diag(diff*K*diff').*repmat(vec_cl(q),nb_data,1).*vec_cl./(repmat(vec_cl(q),nb_data,1)+vec_cl);
    %Diff(q:end,q)=MAXI;
    for r = (q+1) : size(proto,1)
        nb1 = vec_cl(index(q));
        nb2 = vec_cl(index(r));
        Diff(q,r) = (proto(q,:)-proto(r,:))*K*(proto(q,:)-proto(r,:))'*nb1*nb2./(nb1+nb2);
    end
    
end 
%toc

for i = 1:(nb_data-1)
    %[i size(proto)]
    [vv,ll] = min(Diff);
    [val,cc] = min(vv);
    elu = [ll(cc) cc];
    val1 = index(elu(1));
    val2 = index(elu(2));
    nb1 = vec_cl(val1);
    nb2 = vec_cl(val2);
    
    % ajouter l'info dans l'arbre
    tree = [tree; val1 val2 val];
    
    % fusionner les points des deux classes
    I = find(Estindex == val1);
    Estindex(I) = dernier+1;
    vec_cl = [vec_cl;length(I)];
    I = find(Estindex == val2);
    Estindex(I) = dernier+1;
    vec_cl(end) = vec_cl(end) + length(I);
        
    % le prototype de la nouvelle classe
    new_proto = (proto(elu(1),:).*nb1+ proto(elu(2),:).*nb2)./(nb1+nb2);
    
    % supprimer les deux classes mergés de index et de proto
    I = find(index ~= val1);
    index = index(I);
    proto = proto(I,:);
    Diff = Diff(I,:);
    Diff = Diff(:,I);
    I = find(index ~= val2);
    index = index(I);
    proto = proto(I,:);
    Diff = Diff(I,:);
    Diff = Diff(:,I);
    
    if size(proto,1)<=0
        break;
    end
    % ajout de ligne/col pour la nouvelle classe
    newj = diag((proto-repmat(new_proto,size(proto,1),1))*K*(proto-repmat(new_proto,size(proto,1),1))');
    newj = newj .* repmat(nb1+nb2,size(proto,1),1).*vec_cl(index)./(repmat(nb1+nb2,size(proto,1),1)+vec_cl(index));
    
    % modifier les prototypes
    proto = [proto; new_proto];
    
    % modifier l'info dans l'index des classes existants
    index = [index dernier+1];
    
    % modification de Diff
    Diff = [Diff newj;ones(1,size(proto,1))*MAXIMUM];

    % incrémentation du numéro de la dernière classe
    dernier = dernier + 1;
    
    % garder le bon résultat si on arrive au bon nombre de clusters
    if (length(index)==nb_cl)
        pos = zeros(1,nb_data);
        for z = 1 : nb_cl
            I = find(Estindex == index(z));
            pos(I)=z;
        end
    end
end

            
        