#!/bin/bash
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -t 00:30:00
#SBATCH -p  normal

### In filenames, %j=jobid, %a=index in job array
#SBATCH -o  /work2/07880/devansh/lonestar/haplotypeScans/log.txt
#SBATCH -e /work2/07880/devansh/lonestar/haplotypeScans/log.txt
#SBATCH -A MCB21115
#write command-line command below this line
grep -wFf /work2/07880/devansh/lonestar/haplotypeScans/data/regionwise_data/samples/$1.txt /work2/07880/devansh/lonestar/haplotypeScans/data/regionwise_data/samples/v51.0.fam > /work2/07880/devansh/lonestar/haplotypeScans/data/regionwise_data/samples/samples2plink.$1.txt;

