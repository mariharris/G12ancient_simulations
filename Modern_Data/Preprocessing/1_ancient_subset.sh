#!/bin/bash
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -t 00:10:00
#SBATCH -p normal

### In filenames, %j=jobid, %a=index in job array
#SBATCH -o  /work/07880/devansh/lonestar/haplotypeScans/log.txt
#SBATCH -e /work/07880/devansh/lonestar/haplotypeScans/log.txt
#SBATCH -A natural-selection
#write command-line command below this line
python /work/07880/devansh/lonestar/haplotypeScans/scripts/Data_preprocessing/ancient_subset.py

