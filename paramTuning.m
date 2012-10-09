%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Bag of path experiments %
%%%%%%%%%%Kevin Francoisse%

classicRange = {1e-2 5e-2 1e-1 5e-1 1 3 5 10};
classicRangeExt = {{1e-2 1} {5e-2 1} {1e-1 1} {5e-1 1} {1 1} {3 1} {5 1} {10 1}};
dataset = {'data/news_3_parameterTuning'};
kernel = {'potential' 'surprising' 'laplacianlogit' 'sopDistance' 'modularityHittingPath' 'surprisingHittingPath' 'distanceHittingPath'};
params = {classicRangeExt classicRange classicRange classicRangeExt classicRangeExt classicRangeExt classicRangeExt};
results = zeros(size(kernel,2), 6);

fprintf('Load dataset %s\n',dataset{1});
eval(['load ', dataset{1}]);
    
for k = 1:size(kernel,2)
    for p=1:size(params{k},2)
        fprintf('Apply Kernel %s\n',kernel{k});
        K = getKernel(kernel{k}, Docr, params{k}{p});
        s=size(unique(classeo));
        tic;
        [res_randInd, res_randInd_conf, res_classifRate, res_classifRate_conf,res_mutualInfo,res_mutualInfo_conf]=global_clustering(K, s(1,1), classeo, 10);
        tempT = toc;
        fprintf('Time elapsed :');
        tempT
        if (results(k, 2) < res_randInd)
            results(k, 2) = res_randInd;
            results(k, 3) = res_randInd_conf;
            results(k, 1) = classicRange{p};
        end
        if (results(k, 5) < res_classifRate)
            results(k, 5) = res_classifRate;
            results(k, 6) = res_classifRate_conf;
            results(k, 4) = classicRange{p};
        end
    end
end

save('paramTuningResult', 'resultsExp');