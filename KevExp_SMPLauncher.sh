#!/bin/sh

echo "Start experiments"

for dataset in 'news_5cl_2' 'news_5cl_3' 'news_5cl_1' 'news_3cl_1' 'news_3cl_2' 'news_3cl_3' #'news_2cl_1' 'news_2cl_2' 'news_2cl_3'  #'news_3cl_1' 'news_3cl_2' 'news_3cl_3'
do
	
	echo "Launch exp with dataset : $dataset and kernel : potential"
	ts matlab -nojvm -nosplash -r "KevGridExp2('$dataset','potential','{0.1 1}')"

	#echo "Launch exp with dataset : $dataset and kernel : modularity"
	#ts matlab -nojvm -nosplash -r "KevGridExp2('$dataset','modularity','{}')"

	#echo "Launch exp with dataset : $dataset and kernel : surprising"
	#ts matlab -nojvm -nosplash -r "KevGridExp2('$dataset','surprising','0.1')"

	#echo "Launch exp with dataset : $dataset and kernel : laplacianlogit"
	#ts matlab -nojvm -nosplash -r "KevGridExp2('$dataset','laplacianlogit','10')"

	#echo "Launch exp with dataset : $dataset and kernel : sopDistance"
	#ts matlab -nojvm -nosplash -r "KevGridExp2('$dataset','sopDistance','{0.05 1}')"

	#echo "Launch exp with dataset : $dataset and kernel : sumOverTrees"
	#ts matlab -nojvm -nosplash -r "KevGridExp2('$dataset','sumOverTrees','0.05')"

	#echo "Launch exp with dataset : $dataset and kernel : modularityHittingPath"
	#ts matlab -nojvm -nosplash -r "KevGridExp2('$dataset','modularityHittingPath','{0.05 1}')"

	#echo "Launch exp with dataset : $dataset and kernel : surprisingHittingPath"
	#ts matlab -nojvm -nosplash -r "KevGridExp2('$dataset','surprisingHittingPath','{0.1 1}')"

	#echo "Launch exp with dataset : $dataset and kernel : distanceHittingPath"
	#ts matlab -nojvm -nosplash -r "KevGridExp2('$dataset','distanceHittingPath','{0.1 1}')"

done

echo "End"
date
