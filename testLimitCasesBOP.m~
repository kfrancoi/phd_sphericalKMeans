A  =    [  0   1   1   1
            1   0   1   1
            1   1   0   1
            1   1   1   0 ];

C  =    [  0   2   1   1
            2   0   1   1
            1   1   0   1
            1   1   1   0 ];

[nr, nc] = size(C);
n = nr;

theta = 1.3;
eps = 1000000 * realmin;

e  = ones(nr,1);
P0 = A;
Den = sum(P0,2)*e';
P0(Den > eps) = P0(Den > eps)./Den(Den > eps);
P0(P0 <= eps) = 0;

W = P0 .* exp(-theta*C);

I = eye(nr,nc);
Z = inv(I - W);

Dh = diag(diag(Z));
% Zh = Z
Zh = Z * (Dh)^(-1);
% Zh = Zh - diag(diag(Zh)); % diagonal set to 0
zh = sum(sum(Zh));
Ph = Zh/zh;

for i=1:n
     for j=1:n
         for k=1:n
             Pi(i,j,k) = zh * Ph(i,j) * Ph(j,k);
         end
     end
end

sum(sum(Ph))
sum(sum(sum(Pi)))

