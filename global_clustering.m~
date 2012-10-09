function [res_randInd, res_randInd_conf, res_classifRate, res_classifRate_conf, res_mutualInfo, res_mutualInfo_conf]=global_clustering(K, nbclu, classe, nbrep)
% Lance un certain nombre de fois l'algorithme de clustering et affiche en
% sortie la moyenne et l'intervalle de confiance des r�sultats.
%
% K = kernel
% nbclu = nombre de cluster
% classe = le vecteur de classe des donn�es
% nbrep = le nombre de r�p�titions (facultatif)
%
% Luh Yen
%

if nargin < 4
    nbrep = 30;
end

param = 1.2;

taux = [];
adrand = [];
aMI = [];

fprintf('run n� ');
for i = 1:nbrep 
    fprintf('%d ', i);
    [EstIndex,RITrue,MutualInfo] = DKC_clustering_db(K,nbclu,classe,param,0,10);
    taux = [taux confusion(EstIndex,classe,nbclu)];
    adrand = [adrand RITrue];
    aMI = [aMI MutualInfo];
end

fprintf('\n');
res_randInd = mean(adrand)*100;
res_randInd_conf = 1.96*std(100*taux)/sqrt(nbrep);
fprintf('Adjusted RAND index est de %f +/- %f\n',res_randInd, res_randInd_conf);

res_classifRate = mean(taux)*100;
res_classifRate_conf = 1.96*std(100*adrand)/sqrt(nbrep);
fprintf('Le taux de classification est de %f +/- %f\n',res_classifRate, res_classifRate_conf);

res_mutualInfo = mean(aMI)*100;
res_mutualInfo_conf = 1.96*std(100*aMI)/sqrt(nbrep);
fprintf('Information mutuelle de %f +/- %f\n',res_mutualInfo, res_mutualInfo_conf);
