import sys
import os
import re
import scipy.io as sio
import matplotlib.pyplot as plt
from numpy import *

#def main(fileExp, dirname):
#	dataStruct = dict()
#	datasetLabel = list()
#	kernelLabel = list()
#	perfLabel = list()
#	fileList = os.listdir(dirname)
#	for f in fileList:
#		if re.match('news', f):
#			datasetLabel.append(f.split('_')[1])
#			#dataset = datasetLabel.rstrip('cl')
#			kernelLabel.append(re.findall((r"^[0-9](\w+).mat", f.split('_')[2]))			
#			matcontent = sio.loadmat(f)
#			results = mat_content['resultsExp']

def main2(datasetExp='news', nbClasses='3cl'):
	dataStruct = zeros((3,7,6))
	datasetName = ['2cl', '3cl', '5cl']
	kernelName = ['laplacianlogit', 'sopDistance', 'modularity', 'potential', 'surprisingHittingPath', 'distanceHittingPath', 'modularityHittingPath']
	for d, dataset in enumerate(datasetName):
		for k, kernel in enumerate(kernelName):
			for p in range(6):
				print 'Processing news_%s_%s%s.mat'%(nbClasses, d+1, kernel)
				dataStruct[d, k, p] = sio.loadmat('%s_%s_%s%s.mat'%(datasetExp, nbClasses, d+1, kernel))['resultsExp'][0][p]

	return dataStruct, datasetName, kernelName

def barChart(dataStruct, kernelName, nbClasses='3cl', perfMeasure=2):
	N = dataStruct.shape[0]+2 #Number of dataset
	ind = arange(N) #the x location for the group
	width = 0.13
	colors = ['r', '#ff9600', 'y', 'g', 'c', 'b', 'm']
	
	bars = list()
	count = 0
	fig = plt.figure()
	ax = fig.add_subplot(111)
	
	for k in range(dataStruct.shape[1]):
		means = list()
		for d in range(dataStruct.shape[0]):
			means.append(dataStruct[d, k, perfMeasure])
		
		means.append(0)
		means.append(0)	
		
		bars.append(plt.bar(ind+(count*width), means, width, color=colors[count]))
		count+=1
		

	if perfMeasure == 0:
		perfLabel = 'RandIndex'
	if perfMeasure == 2:
		perfLabel = 'Classification Rate'
	if perfMeasure == 4:
		perfLabel = 'Mutual Information'
	
	plt.ylabel(perfLabel)
	ax.set_ylim(0, 100)
	plt.title('%s on different dataset and kernels'%perfLabel)
	plt.xticks(ind+2*width, ('News %s 1'%nbClasses, 'News %s 2'%nbClasses, 'News %s 3'%nbClasses))
	plt.legend( (i[0] for i in bars), kernelName)


	def autolabel(rects):
		#attach some labels on top of rectangle
		for rect in rects[:-2]:
			height = rect.get_height()
			ax.text(rect.get_x()+rect.get_width()/2., 1.01*height, '%.1f'%height, ha='center', va='bottom')

	for i in bars:
		autolabel(i)
	
	plt.show()

