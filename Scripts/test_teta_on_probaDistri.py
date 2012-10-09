from CoreDiscriminant import *

G = GraphDiscriminant('../data/news5B.txt', 0.5, KRCT, 5)
#G = GraphDiscriminant('../data/WebKB-texas-graph.txt', 0.5, KRCT, 5)
#G = GraphDiscriminant('../data/WebKB-wisconsin-graph.txt', 0.5, KRCT, 5)
G.kernelTeta = 45
G.projectionTool = 'discrim'
G.readGraph()

K = G._graphKernel(True, G.kernel, 0.95)

probas = getGroupingNodeBetProbas(G.graph, K, G.kernelTeta)

plt.hist(probas[:,0])
plt.show()
