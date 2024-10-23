#!/bin/bash
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -t 02:00:00
#SBATCH -p rtx

### In filenames, %j=jobid, %a=index in job array
#SBATCH -o  /work2/07880/devansh/lonestar/haplotypeScans/log.txt
#SBATCH -e /work2/07880/devansh/lonestar/haplotypeScans/log.txt
#SBATCH -A MCB20049
#write command-line command below this line	
if [[ $2 -eq 23 ]]; then
	/work2/07880/devansh/lonestar/haplotypeScans/plink_2/plink --bfile /work2/07880/devansh/lonestar/haplotypeScans/data/population_data/v40.3.$1.$2 --filter-males --recodeA include-alt --out /work2/07880/devansh/lonestar/haplotypeScans/data/recode_data/$1.$2.male;
	
else
	/work/07880/devansh/lonestar/haplotypeScans/plink --bfile /work2/07880/devansh/lonestar/haplotypeScans/data/population_data/v51.0.$1.$2 --recodeA include-alt --out /work2/07880/devansh/lonestar/haplotypeScans/data/recode_data/$1.$2;
fi
