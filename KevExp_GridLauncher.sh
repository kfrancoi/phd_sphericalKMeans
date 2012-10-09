#!/bin/sh

echo "Start experiments"

for dataset in 'news_3cl_1' 'news_3cl_2' 'news_3cl_3' 'news_5cl_1' 'news_5cl_2' 'news_5cl_3'
do
	
	echo "Launch exp with dataset : $dataset and kernel : potential"
	qsub KevExp_QSUB.sh $dataset 'potential' '{0.1 1}'

	echo "Launch exp with dataset : $dataset and kernel : modularity"
	qsub KevExp_QSUB.sh $dataset 'modularity' '{}'

	echo "Launch exp with dataset : $dataset and kernel : surprising"
	qsub KevExp_QSUB.sh $dataset 'surprising' '0.1'

	echo "Launch exp with dataset : $dataset and kernel : laplacianlogit"
	qsub KevExp_QSUB.sh $dataset 'laplacianlogit' '10'

	echo "Launch exp with dataset : $dataset and kernel : sopDistance"
	qsub KevExp_QSUB.sh $dataset 'sopDistance' '{0.05 1}'

	echo "Launch exp with dataset : $dataset and kernel : sumOverTrees"
	qsub KevExp_QSUB.sh $dataset 'sumOverTrees' '0.05'
done

echo "End"
date
