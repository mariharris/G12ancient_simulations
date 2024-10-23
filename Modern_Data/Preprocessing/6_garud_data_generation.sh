#!/bin/bash
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -t 03:00:00
#SBATCH -p rtx

### In filenames, %j=jobid, %a=index in job array
#SBATCH -o  /work2/07880/devansh/lonestar/haplotypeScans/log.txt
#SBATCH -e /work2/07880/devansh/lonestar/haplotypeScans/log.txt
#SBATCH -A  MCB20049
#write command below this lin
if [[ $2 -eq 23 ]]; then
	python /work2/07880/devansh/lonestar/haplotypeScans/scripts/Data_preprocessing/string_manupulation.py -i "/work2/07880/devansh/lonestar/haplotypeScans/data/recode_data/$1.$2.male.raw" -o "/work2/07880/devansh/lonestar/haplotypeScans/data/Garud_files/Garud_data/$1.$2.male.txt" -c $2;

else
	python /work2/07880/devansh/lonestar/haplotypeScans/scripts/Data_preprocessing/string_manupulation.py -i "/work2/07880/devansh/lonestar/haplotypeScans/data/recode_data/$1.$2.raw" -o "/work2/07880/devansh/lonestar/haplotypeScans/data/Garud_files/Garud_data/$1.$2.txt" -c $2;
fi
	

