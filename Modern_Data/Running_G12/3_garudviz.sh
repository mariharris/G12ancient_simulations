#!/bin/bash
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -t 00:15:00
#SBATCH -p normal

### In filenames, %j=jobid, %a=index in job array
#SBATCH -o  /work2/07880/devansh/lonestar/haplotypeScans/log.txt
#SBATCH -e /work2/07880/devansh/lonestar/haplotypeScans/log.txt
#SBATCH -A New-methods-in-strin
#write command below this line
if [[ $2 -eq 23 ]]; then
Rscript /work2/07880/devansh/lonestar/haplotypeScans/SelectionHapStats/scripts/H12_viz.R /work2/07880/devansh/lonestar/haplotypeScans/data/Garud_files/G12_files/$1.$2.$3.$4.$5.G12.txt /work2/07880/devansh/lonestar/haplotypeScans/data/Garud_files/Peak_files/$1.$2.$3.$4.$5.male.G12peaks.txt /work2/07880/devansh/lonestar/haplotypeScans/data/Garud_files/Viz_files/$1.$2.$3.$4.$5.male.G12viz.pdf 10;
else
Rscript /work2/07880/devansh/lonestar/haplotypeScans/SelectionHapStats/scripts/H12_viz.R /work2/07880/devansh/lonestar/haplotypeScans/data/Garud_files/G12_files/$1.$2.$3.$4.$5.G12.txt /work2/07880/devansh/lonestar/haplotypeScans/data/Garud_files/Peak_files/$1.$2.$3.$4.$5.G12peaks.txt /work2/07880/devansh/lonestar/haplotypeScans/data/Garud_files/Viz_files/$1.$2.$3.$4.$5.G12viz.pdf 10;
fi
