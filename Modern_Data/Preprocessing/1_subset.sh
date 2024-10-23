#!/bin/bash
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -t 00:30:00
#SBATCH -p normal

### In filenames, %j=jobid, %a=index in job array
#SBATCH -o  /work2/07880/devansh/lonestar/haplotypeScans/log.txt
#SBATCH -e /work2/07880/devansh/lonestar/haplotypeScans/log.txt
#SBATCH -A New-methods-in-strin
#write command-line command below this line

grep $1.SG /work/07475/vagheesh/lonestar5/haplotypeScans/v40.3.selection.ind | cut -f1 > /work2/07880/devansh/lonestar/haplotypeScans/data/regionwise_data/samples/$1.txt;
