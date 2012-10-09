#!/bin/sh
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:$(find ~/MCR -type d | tr '\n' ':' | sed 's/:$//')
#
# COMMON PARAMETERS
#
# SGE: mandatory!! the requested run-time, expressed as
#$ -l h_rt=240:00:00
#$ -N matlab
#
# GREEN PARAMETERS
#
# -l mf=8G
# -l hm=false
# -pe snode 2
# -l nb=true
# -q all.q
#
# LEMAITRE PARAMETERS
#
#$ -l p=2
#$ -pe smp 4
#$ -q all.q
# SGE: your Email here, for job notification
# -M kevin.francoisse@uclouvain.be
# SGE: when do you want to be notified (b for begin, e for end, s for error)?
#$ -m bes
#
# SGE: ouput in the current working dir
#$ -cwd
#
# Specify that all the environement variable must be included in the jobs environement
#$ -V


echo -n "job starts at "
date

dataset=$1
kernel=$2
param=$3

CMD="KevGridExp ".$dataset." ".$kernel." ".$param
echo $CMD
$CMD

echo -n "job ends at "
date
# end of job
