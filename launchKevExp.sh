#!/bin/bash

#PBS -l select=1:ncpus=4:mem=4gb
#PBS -l walltime=12:00:00
 
#cd ${PBS_O_WORKDIR}
 
sudo matlab -nodisplay -nodesktop -r kevExp 
