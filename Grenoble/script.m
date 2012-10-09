
load -ASCII DocsOk.txt
load -ASCII TopicsOk.txt

[K,Kc,Ks] = laplacianLogit(DocsOk, 7);

[pos,J,gamma] = kernel_db(K,2);
[pos,P,J,gamma] = kernel_fuzzy_db(K, 2, 1.2);