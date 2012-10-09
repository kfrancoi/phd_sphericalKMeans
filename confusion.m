function [taux,Mat,mask] = confusion(trouve,reel,nbcl)
% cette fonction va renvoyer en sortie la matrice de confusion pour une
% classification trouvée.
%
% trouve = le vecteur contenant la classe trouvée pour chaque élément
% reel = le vecteur contenant la classe réelle pour chaque élément
% nbcl = le nombre de classes 
%
% Mat = la matrice confusion
% taux = le taux de bonne classification 

Mat = zeros(nbcl);

for i = 1 : length(reel)
    Mat(reel(i),trouve(i)) = Mat(reel(i),trouve(i)) + 1;
end

% mask(i,j)=1 if the found class j is assigned to the real class i
if nbcl >10
    mask = optassign2(Mat);
else
    mask = optassign(Mat);
end
% mask
taux = sum(sum(Mat.*mask))/length(trouve);

%Bonne_val = max(Mat);

%taux = sum(Bonne_val) / length(trouve);