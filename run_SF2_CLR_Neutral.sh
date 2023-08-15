#!/bin/bash

#$ -cwd
# error = Merged with joblog
#$ -o joblog.$JOB_ID.$TASK_ID
#$ -j y
## Edit the line below as needed:
#$ -l h_rt=200:00:00,h_data=13G,highp
## Modify the parallel environment
## and the number of cores as needed:
#$ -pe shared 1
# Notify when
##$ -m a
#  Job array indexes
##$ -t 1-1:1

# echo job info on joblog:
echo "Job $JOB_ID started on:   " `hostname -s`
echo "Job $JOB_ID started on:   " `date `
echo " "


#compute neutral CLR sore
for samp in 40 100 250; do
        for id in `seq 1 10`; do
                for i in `seq 1 50`; do #1100
                        SpectFile_neutral="/u/scratch/m/mharrish/aDNAoutput/Neutral/SF2_data/SF2_AgeSweep${samp}_id${id}_${i}.txt"

                        #compute CLR
                        ~/Applications/SF2/SweepFinder2 -sg 1000 ${SpectFile_neutral} tmp/CLR_Neutral.txt

                        # Find the highest value in the second column (excluding the first line i.e headers)
                        max_CLR=$(awk 'NR>1 {if ($2 > max || NR==2) max=$2} END {print max}' tmp/CLR_Neutral.txt)
                        # Print the line containing the highest value in the second column using grep
                        grep -w "$max_CLR" tmp/CLR_Neutral.txt >> SF2_output/CLR_NEUTRAL_Sample${samp}_s0.txt

                        rm tmp/CLR_Neutral.txt

                done
        done
done


# echo job info on joblog:
echo "Job $JOB_ID ended on:   " `hostname -s`
echo "Job $JOB_ID ended on:   " `date `
echo "
