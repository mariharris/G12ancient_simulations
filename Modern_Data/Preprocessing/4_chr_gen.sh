#!/bin/bash
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -t 00:30:00
#SBATCH -p  small
### In filenames, %j=jobid, %a=index in job array
#SBATCH -o  /work2/07880/devansh/lonestar/haplotypeScans/log.txt
#SBATCH -e /work2/07880/devansh/lonestar/haplotypeScans/log.txt
#SBATCH -A MCB20049
#write command-line command below this line
/work/07880/devansh/lonestar/haplotypeScans/plink2 --bfile /work2/07880/devansh/lonestar/haplotypeScans/data/regionwise_data/GBR/v51.0.$1 --chr $2  --make-bed  --out /work2/07880/devansh/lonestar/haplotypeScans/data/population_data/v51.0.$1.$2;
