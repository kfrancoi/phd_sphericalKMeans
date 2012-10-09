function KevGridExp(varargin)

%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Bag of path experiments %
%%%%%%%%%%Kevin Francoisse%

dataset = {varargin{1}};

kernel = {varargin{2}};

params = {eval(varargin{3})};

%dataset = {'news_3cl_1' 'news_3cl_2' 'news_3cl_3' 'news_5cl_1' 'news_5cl_2' 'news_5cl_3'};
%kernel = {'potential' 'modularity' 'surprising' 'laplacianlogit' 'sopDistance' 'somOverTrees'};
%params = {{0.1 1} {} 0.1 10 {0.05 1} 0.05};

%dataset = {'news_3cl_1'};
%kernel = {'laplacianlogit'};
%params = {7};


%dataset = {'news_3cl_1'};
%kernel = {'surprising'};
%params = {1.3};

resultsExp = zeros(size(dataset,2),size(kernel,2), 6);


for d = 1:size(dataset,2)
    fprintf('Load dataset %s',dataset{d});
    
    eval(['load ', dataset{d}]);
    
    for k = 1:size(kernel,2)
        fprintf('Apply Kernel %s',kernel{k});
        K = getKernel(kernel{k}, Docr, params{k});
        s=size(unique(classeo));
        tic;
        [res_randInd, res_randInd_conf, res_classifRate, res_classifRate_conf,res_mutualInfo,res_mutualInfo_conf]=global_clustering(K, s(1,1), classeo, 20);
        tempT = toc;
        fprintf('Time elapsed :');
        tempT
        resultsExp(d, k, 1) = res_randInd;
        resultsExp(d, k, 2) = res_randInd_conf;
        resultsExp(d, k, 3) = res_classifRate;
        resultsExp(d, k, 4) = res_classifRate_conf;
        resultsExp(d, k, 5) = res_mutualInfo;
        resultsExp(d, k, 6) = res_mutualInfo_conf;
    end
end

save([dataset{1} kernel{1}], 'resultsExp');

