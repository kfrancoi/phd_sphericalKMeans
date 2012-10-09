function X = optassign2(Mat)
% compute the optimal assignment for the confusion matrix
% Mat = the confusion matrix
%

[m,n] = size(Mat);

C = -1*Mat;
C = C - repmat(min(C,[],2),1,n);

if min(min(C))<0
    C
    error('oh oh problem')
end

% the computational algorithm to approach 
% to the optimal solution with smallest cost

[n,n] = size(C);
X = sparse(zeros(n)); % the assignment matrix

% first assignment: row-by-row
for i = 1:n
       [Crow,Irow] = sort(C(i,:));
        for j = 1:length(Crow)
            if (~any(X(:,Irow(j)))) % in this case the column Irow(j) is not yet assigned
                X(i,Irow(j)) = 1;
                break; % break the j-loop
            end
        end
end
z = sum(sum(C.*X));

k = 1; % counter of new assignments

while (k ~= 0)
    k = 0; % new loop

    for i = 1:n
        d = zeros(1,n);
        indD = zeros(1,n);
        iZ = find(X(i,:));
        for j = 1:n
            if (j ~= iZ)
                jZ = find(X(:,j));
                d(j) = C(i,j)+C(jZ,iZ)-C(i,iZ)-C(jZ,j);
                indD(j) = jZ;
            end
        end
        % interchange of the assignment
        [dMin,iMin] = min(d);
        if (dMin < 0)
            X(i,iZ) = 0;
            X(indD(iMin),iMin) = 0;
            X(i,iMin) = 1;
            X(indD(iMin),iZ) = 1;
            z = sum(sum(C.*X));
            k = k+1;
        end  
    end
    
end
