#!/bin/bash
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -t 03:00:00
#SBATCH -p small

### In filenames, %j=jobid, %a=index in job array
#SBATCH -o  /work2/07880/devansh/lonestar/haplotypeScans/log.txt
#SBATCH -e /work2/07880/devansh/lonestar/haplotypeScans/log.txt
#SBATCH -A  MCB20049
#write command below this line
if [[ $2 -eq 23 ]]; then
ind=`wc -l /work2/07880/devansh/lonestar/haplotypeScans/data/recode_data/$1.$2.male.raw |head -n1 | cut -d " " -f1`
else
ind=`wc -l /work2/07880/devansh/lonestar/haplotypeScans/data/recode_data/$1.$2.raw |head -n1 | cut -d " " -f1`#
fi
num_ind=$((ind-1))
if [[ $2 -eq 23 ]]; then
python /work2/07880/devansh/lonestar/haplotypeScans/SelectionHapStats/scripts/H12_H2H1.py /work2/07880/devansh/lonestar/haplotypeScans/data/Garud_files/Garud_data/$1.$2.male.txt $num_ind -o /work2/07880/devansh/lonestar/haplotypeScans/data/Garud_files/G12_files/$1.$2.$3.$4.$5.G12.txt -w $3 -j $4 -d $5;
else
python /work2/07880/devansh/lonestar/haplotypeScans/SelectionHapStats/scripts/H12_H2H1.py /work2/07880/devansh/lonestar/haplotypeScans/data/Garud_files/Garud_data/$1.$2.txt $num_ind  -o /work2/07880/devansh/lonestar/haplotypeScans/data/Garud_files/G12_files/$1.$2.$3.$4.$5.G12.txt -w $3 -j $4 -d $5;
fi
