#!/bin/bash
#### submit_Admixture job####
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


for AgeSweep in 40 100; do #40 100 250
	SpectFile_null="/u/scratch/m/mharrish/aDNAoutput/Neutral/SF2_NeutralSFS/SpecFile_AgeSweep${AgeSweep}_Null.txt"
	echo ${SpectFile_null}
	for s in 0.0075 0.01; do
		for introduceMut in 280 500 1000; do
			for id in `seq 1 10`; do #1 10
				for i in `seq 1 50`; do #1100 #1 50

					SF2_freq_file="/u/project/ngarud/Garud_lab/SLiM_simulations/aDNA/HardSweeps_revised/SF2_data/SF2_introMut${introduceMut}_AgeSweep${AgeSweep}_s${s}_id${id}_${i}.txt"

					#compute SFS to get number of lines for neutral SFS
					~/Applications/SF2/SweepFinder2 -f ${SF2_freq_file} tmp/SpectFile


					#set Neutral SFS
					line_count=$(wc -l < tmp/SpectFile)

					head -${line_count} ${SpectFile_null} > tmp/SpectFile_null

					# Compute CLR score with neutral SFS

					~/Applications/SF2/SweepFinder2 -lg 1000 ${SF2_freq_file} tmp/SpectFile_null tmp/CLR_wNeutralSFS.txt
    
					#get 10kb region surrounding adaptive site
					awk '$1 > 20000 && $1 < 30000' tmp/CLR_wNeutralSFS.txt > tmp/CLR_10kb.txt
    
					head tmp/CLR_10kb.txt

					# Get Max
					#Neutral SFS
					# Find the highest value in the second column
					max_CLR=$(awk '{if ($2 > max || NR==2) max=$2} END {print max}' tmp/CLR_10kb.txt)
					# Print the line containing the highest value in the second column using grep
					grep -w "$max_CLR" tmp/CLR_10kb.txt >> SF2_output/CLR_wNeutralSFS_introMut${introduceMut}_AgeSweep${AgeSweep}_s${s}.txt



					rm tmp/*
					

				done
			done
		done
	done
done







# echo job info on joblog:
echo "Job $JOB_ID ended on:   " `hostname -s`
echo "Job $JOB_ID ended on:   " `date `
echo " "
