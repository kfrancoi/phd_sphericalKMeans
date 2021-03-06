function K = getKernel(kName, A, varargin)

    switch kName
        case 'surprising'
            SoPstruct = sopRelatedness01(A,varargin{1});
            K = SoPstruct.Kd;
        case 'potential'
            SoPstruct = sopRelatednessPotentialDistance01(A,varargin{1}{1,1}, varargin{1}{1,2});
            K = SoPstruct.Kd;
            %[V,D]=eig(K);
            %D(find(diag(D)<0),find(diag(D)<0)) = 0;
            %K = V*D*inv(V);
        case 'modularity'
            [X,Xc,Xa] = modularity01(A);
            K = X;
        case 'laplacianlogit'
            [X,Xc,Xs] = laplacianLogit(A,varargin{1});
            K = X;
        case 'sopDistance'
            %Param : theta / distID
            K = maxEntKullbackKernel01(A,varargin{1}{1,1}, varargin{1}{1,2});
        case 'sumOverTrees'
            %Param : theta
            [K,Kc,Kd] = sopRelatednessTrees01(A,varargin{1});
        case 'modularityHittingPath'
            SoPstruct = sopRelatedness03(A, varargin{1}{1,1}, varargin{1}{1,2});
            K = SoPstruct.Km;
        case 'surprisingHittingPath' %KBPI - Mutual Information Matrix
            SoPstruct = sopRelatedness03(A, varargin{1}{1,1}, varargin{1}{1,2});
            K = SoPstruct.Ken;
        case 'distanceHittingPath'
            SoPstruct = sopRelatedness03(A, varargin{1}{1,1}, varargin{1}{1,2});
            K = SoPstruct.Kd;
        case 'Q'
            K = BoP_modularity_kernels(A, varargin{1}, 0, 0);
        case 'Q0'
            K = BoP_modularity_kernels(A, varargin{1}, 0, 1);
        case 'Qh'
            K = BoP_modularity_kernels(A, varargin{1}, 1, 0);
        case 'Qh0'
            K = BoP_modularity_kernels(A, varargin{1}, 1, 1);    
    end
end
