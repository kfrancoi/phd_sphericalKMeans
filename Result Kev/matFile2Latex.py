import sys
import os
import scipy.io as sio
from numpy import *

def main():
	resultRandIndex = zeros((9,12))
	resultClassif = zeros((9,12))
	resultMI = zeros((9,12))
	for ci, c in enumerate(['2cl', '3cl', '5cl']):
		for di, d in enumerate(['1', '2', '3']):
			for mi, m in enumerate(['potential', 'surprisingHittingPath', 'distanceHittingPath', 'modularityHittingPath', 'laplacianlogit', 'sopDistance']):
				sfile = 'news_%s_%s%s.mat'%(c,d,m)
				result = sio.loadmat(sfile)['resultsExp']
				resultRandIndex[(ci*3)+di, (mi*2)] = result[0][0]
				resultRandIndex[(ci*3)+di, (mi*2)+1] = result[0][1]
				resultClassif[(ci*3)+di, (mi*2)] = result[0][2]
				resultClassif[(ci*3)+di, (mi*2)+1] = result[0][3]
				resultMI[(ci*3)+di, (mi*2)] = result[0][4]
				resultMI[(ci*3)+di, (mi*2)+1] = result[0][5]
	writeLatex('randIndexLatex.txt', resultRandIndex)
	writeLatex('ClassifRateLatex.txt', resultClassif)
	writeLatex('MILatex.txt', resultMI)

def writeLatex(fname, results):
	
	ofile = open(fname, 'w')
	for di, d in enumerate(['G-2cl-1', 'G-2cl-2', 'G-2cl-3', 'G-3cl-1', 'G-3cl-2', 'G-3cl-3', 'G-5cl-1', 'G-5cl-2', 'G-5cl-3']):
		ofile.write('%s '%d)
		for k in range(6):
			ofile.write('& %.1f $\pm$ %.2f'%(results[di,k*2], results[di, (k*2)+1]))
		ofile.write('// \n')
	ofile.close()

if __name__ == '__main__':
	main()