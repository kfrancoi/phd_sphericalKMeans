function [X,zmin] = optassign(Mat)
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

% a naive algorithm to check all n! assignments and 
% select the assignment with the smallest cost

[n,n] = size(C);
% p contains all possible assignments
p = perms(1:n);
% m = number of all possible assignment
% z = vector containing the obtained cost for all assignment
[m,q] = size(p);
z = zeros(1,m);

for ip = 1 : m
    X = zeros(n); % the assignment matrix
    for i = 1:n
        X(i,p(ip,i)) = 1;
    end
    z(ip)= sum(sum(C.*X));
end

[zMin,iMin] = min(z);
X = zeros(n); % the assignment matrix
for i = 1:n
        X(i,p(iMin,i)) = 1;
end

%zMin
%X
