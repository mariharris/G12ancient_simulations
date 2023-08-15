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


for introMut in 280 500 1000; do
for s in 0.0075 0.01 0.025 0.05 0.1; do
	awk -v s="$s" 'BEGIN{FS=OFS="\t"} { $NF = $NF "\t40\t" s } 1' SF2_output/CLR_wNeutralSFS_introMut${introMut}_AgeSweep40_s${s}.txt  > SF2_output/CLR_introMut${introMut}_AgeSweep40_s${s}.txt_tmp
done
        cat SF2_output/*_tmp > SF2_output/CLR_introMut${introMut}_AgeSweep40.txt
        rm SF2_output/*_tmp
	awk -v g="$introMut" 'BEGIN{FS=OFS="\t"} {$NF = $NF "\t" g} 1' SF2_output/CLR_introMut${introMut}_AgeSweep40.txt > SF2_output/CLR_AgeSweep40.txt_${introMut}
done

cat SF2_output/CLR_AgeSweep40.txt_1000 SF2_output/CLR_AgeSweep40.txt_280 SF2_output/CLR_AgeSweep40.txt_500 > SF2_output/CLR_wNeutralSFS_HS_AgeSweep40.txt

echo "Job $JOB_ID ended on:   " `hostname -s`
echo "Job $JOB_ID ended on:   " `date `
echo " "
