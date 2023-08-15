#### submit_Admixture job####
#!/bin/bash                         #-- what is the language of this shell

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


# load the job environment:
. /u/local/Modules/default/init/modules.sh
module load anaconda3
module load python/3.7.3


for id in `seq 1 10`; do
for i in `seq 1 50`; do #1100 
for AgeSweep in 40 100 250; do
for s in 0.001 0.1 0.025 0.05; do
for introduceMut in 280 500 1000; do

    	#parse for H12
   

	#parse to get SF2 data format
        python SF2_Parse.py -m 0.55 -s 0.23 -i  SLiMout/VCF_introMut${introduceMut}_AgeSweep${AgeSweep}_s${s}_id${id}_${i}.csv -o SF2_data/SF2_introMut${introduceMut}_AgeSweep${AgeSweep}_s${s}_id${id}_${i}.txt
    

done
done
done
done
done

# echo job info on joblog:
echo "Job $JOB_ID ended on:   " `hostname -s`
echo "Job $JOB_ID ended on:   " `date `
echo " "
