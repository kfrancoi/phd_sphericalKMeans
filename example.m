
function example
%Lance un exemple de clustering avec le dataset zachary ou newsgroup_2_1

% A = [0,  1,  1,  1,  1,  0,  0,  0,  0,  0
%      1,  0,  1,  1,  1,  0,  0,  0,  0,  0
%      1,  1,  0,  1,  1,  0,  0,  0,  0,  0
%      1,  1,  1,  0,  1,  1,  0,  0,  0,  0
%      1,  1,  1,  1,  0,  0, 0.5, 0,  0,  0
%      0,  0,  0,  1,  0,  0,  1,  1,  1,  1
%      0,  0,  0,  0, 0.5, 1,  0,  1,  1,  1
%      0,  0,  0,  0,  0,  1,  1,  0,  1,  1
%      0,  0,  0,  0,  0,  1,  1,  1,  0,  1
%      0,  0,  0,  0,  0,  1,  1,  1,  1,  0];
%  
%  c = [1, 1, 1, 1, 1, 2, 2, 2, 2, 2];

%load zachary;
%load newsgroup_3_1;
%load news_3cl_1;
load data/news_3_parameterTuning;
%load -ascii palDocsOk.txt; load -ascii palTopicsOk.txt;


% Plusieurs choix de kernel - laplacianLogit donne les meilleurs resultats
[K,Kc,Ks] = laplacianLogit(Docr, 7);

%[K,Kc,Ks] = laplacianLogit(A, 7);
%laplacianLogit(palDocsOk, 7);
K;

%K = laplacian(Docr);

%theta = 3.0;
%s = sopRelatedness01(zachc,theta);
%K = s.Kd;

%theta = 3.0;
%s = sopRelatedness01(palDocsOk,theta);
%K = s.Kdn;

%theta = 1.3;
%s = sopRelatedness01(A,theta);
%s = sopRelatednessDistance01(Docr,theta,1);
%K = s.Ken;
%s = sopRelatedness01(K,theta);
%K = s.Kd;

%theta = 1.2;
%s  = sopCondRelatedness01(Docr,theta);
%Pc = s.Pc;
%K  = s.Ken;


%theta = 1.5;
%[K,Kc,Kd] = sopRelatednessTrees01(Docr,theta); % sopRelatednessTrees01(Docr,theta);
%K = Kd;

%theta = 0.8;
%K = SumOverPathsCovariance(Docr,theta,4);

%[K,Kc,Ks] = laplacianLogit(Docr, 7);
%K = K;

%[K,Kc] = laplacianTanh(Docr, 7);
%K = K;

%[K,Kc] = regularizedCTkernel(Docr, 0.95);

%[K,Kc] = regularizedLaplacianKernel(palDocsOk, 0.8);

%theta = 1.5;
%K = maxEntKullbackKernel01(Docr,theta,0);
%K = maxEntKullbackKernel01(A,theta,1);

%[Kac,Kn] = amplifiedCommuteTimeKernel01(Docr);
%K = Kac;

%[K,Kc,Ka] = modularity01(A);
%[K,Kc,Ka] = modularity01(Docr);
%K = K;

[nr,nc] = size(K);

%global_clustering(K, 2, palTopicsOk, 5);
global_clustering(K, 3, classeo, 10);
%global_clustering(K, 2, c, 1);

%K = K - eye(nr,nc).*K;
%figure(1);

%newplot
imagesc(K)
colorbar;
%hold on

% save Docr.txt -ascii -TABS Docr
% save class.txt -ascii -TABS classeo
% load -ascii Docr.txt
% load -ascii class.txt
end
