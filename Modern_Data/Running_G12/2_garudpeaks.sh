#!/bin/bash
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -t 00:30:00
#SBATCH -p normal

### In filenames, %j=jobid, %a=index in job array
#SBATCH -o  /work2/07880/devansh/lonestar/haplotypeScans/log.txt
#SBATCH -e /work2/07880/devansh/lonestar/haplotypeScans/log.txt
#SBATCH -A New-methods-in-strin
#write command-line command below this
if [[ $2 -eq 23 ]]; then
python /work2/07880/devansh/lonestar/haplotypeScans/SelectionHapStats/scripts/H12peakFinder.py /work2/07880/devansh/lonestar/haplotypeScans/data/Garud_files/G12_files/$1.$2.$3.$4.$5.G12.txt  -o /work2/07880/devansh/lonestar/haplotypeScans/data/Garud_files/Peak_files/$1.$2.$3.$4.$5.male.G12peaks.txt;
else
python /work2/07880/devansh/lonestar/haplotypeScans/SelectionHapStats/scripts/H12peakFinder.py /work2/07880/devansh/lonestar/haplotypeScans/data/Garud_files/G12_files/$1.$2.$3.$4.$5.G12.txt  -o /work2/07880/devansh/lonestar/haplotypeScans/data/Garud_files/Peak_files/$1.$2.$3.$4.$5.G12peaks.txt;
fi
