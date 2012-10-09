function [EstIndex,RITrue,MutualInfo,variold] = DKC_clustering_db (Kernel,k,TrueID,param,dessin,Repetitions)
%kmeansCluster va lancer le programme dckmeans un certain nombre de fois
%(donn� par Repetitions) et renvoyer � la sortie la solution � la variance
% in intra-cluster totale minimale. 
%
% Kernel est la matrice kernel des donn�es.
% k    est le nombre de cluster qu'il faudra trouver.
% TrueID est l'attribution exacte des donn�es, c'est un vecteur contenant
%        le n� de classe de chaque �l�ment (param facultatif, []->non connu).
% dessin = 1 si on veut le graphe de l'�volution de taux de classification 
% Repetitions (facultatif)est le nombre de fois qu'il faudra relancer 
%             l'algorithme de clustering (1 par d�faut).
%
% EstIndex est le label de classe donn� par la solution optimale de
%          dckmeans.
% RITrue est le "(adjusted) Rand Index" par rapport � la vraie solution (si
%        connue).
% MutualInfo est l'information mutuelle 
% variold  est la variance intra-classe totale pour tous les clusters
%
% Luh Yen
%

if nargin < 2
   error('DKC requires at least 2 arguments !');
   help DKC
   return
end
[R,C]=size(Kernel);
if nargin < 3, TrueID = []; end	
if nargin < 5, dessin = 0; end		
if nargin < 6, Repetitions = 50;end

lengthTrueID=length(TrueID);
if length(TrueID)>0 & length(TrueID)~=R
   error('KMEANSCLUSTER number of labels doesn''t match number of records');
   return
end

if k == 1			%Only want one cluster? Well, ...OK
   RITrue=0;
   EstIndex=ones(R,1);
   return
end

if R ~= C
    error('Kernel non carree, calcul de kernel\n');
end


variold = realmax;
trace = [];
dkc = [];
valmax = realmin;
%Do the clustering
for i =1:Repetitions
    %fprintf('repetition : %d\n',i);
    %[pos,J,gamma]  = kernel_spherical_db (Kernel,k);
    [pos,J,gamma]  = kernel_db_marco(Kernel,k);
    %[pos,P,J,gamma] = kernel_fuzzy_db (Kernel,k,param);
    %mu = 6.5;
    %[pos,J,gamma]  = kernel_db_modularity(Kernel,k,mu);
    %J
    %gamma
   
   variance = J(end);
   if dessin == 1
      trace = [trace; variance];
      [val,Mat] = confusion(pos,TrueID,k);
      dkc = [dkc; val];
   end

   if variance < variold
       variold = variance;
       EstIndex = pos;
       elu = i;
   end
   
   
end %of repetitions loop
%gamma

if dessin == 1
    trace
    figure
    plot(trace,'b-');
    hold on
    plot(elu, trace(elu),'r*');
    figure
    plot (dkc,'m-');
    hold on
    plot(elu, dkc(elu),'r*');
end

% return adjusted Rand index (accuracy) for each iteration if true 
   % labels are giv
if length(TrueID)>0
   RITrue = RandIndex(EstIndex, TrueID);   
else
    lengthTrueID2 = length(TrueID);
   RITrue=-1;
end

MutualInfo = nmi(TrueID, EstIndex);
   
