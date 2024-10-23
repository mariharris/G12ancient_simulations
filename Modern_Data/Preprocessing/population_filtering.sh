#!/bin/bash
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -t 03:00:00
#SBATCH -p normal

### In filenames, %j=jobid, %a=index in job array
#SBATCH -o  /work/07880/devansh/lonestar/haplotypeScans/log.txt
#SBATCH -e /work/07880/devansh/lonestar/haplotypeScans/log.txt
#SBATCH -A natural-selection
#write command-line command below this line
for j in GBR P H IA BA S EN AN M;
do
        for i in {1..24};
        do
		
		/work/07880/devansh/lonestar/haplotypeScans/plink2/plink --bfile /work/07880/devansh/lonestar/haplotypeScans/data/regionwise_data/europe_data/v40.3.europe --chr $i --keep /work/07475/vagheesh/lonestar5/haplotypeScans/samples$j.txt --make-bed  --out /work/07880/devansh/lonestar/haplotypeScans/data/population_data/europeChr_data/v40.3.europe.$j.$i;
 	done;
 done  
