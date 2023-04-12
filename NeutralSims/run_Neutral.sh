#!/bin/bash

#This script runs 100 simulations of the neutral Tennessen et al model and obtains the G12_ancient values

id=$1

for trial in {1..600};do
      #run slim simulation
       #slim -d burn_in=10.0 -d sampleSize=177 -d "file_300='SLiMout/VCF_300_id${id}_${trial}.csv'" \
       # -d "file_250='SLiMout/VCF_250_id${id}_${trial}.csv'" -d "file_200='SLiMout/VCF_200_id${id}_${trial}.csv'" \
       # -d "file_100='SLiMout/VCF_100_id${id}_${trial}.csv'" -d "file_40='SLiMout/VCF_40_id${id}_${trial}.csv'" Tennesen_Neutral.slim

        ##################################################################################
        #######################run G12_ancient ###########################################
        ##################################################################################
	
	for sample in 300 250 200 100 40;do 
		#run python code to pseudo haplodize and add missing data 
		python Tennesen_Neutral.py -m 0.54827 -s 0.2321 -i SLiMout/VCF_${sample}_id${id}_${trial}.csv -o tmp/MS_${sample}_id${id}_${trial}.txt
        
        
	#run G12_ancient in simulated data
        #H12_H2H1_MD.py
         python H12_H2H1_Py3_v2.py tmp/MS_${sample}_id${id}_${trial}.txt 177 -o tmp/H12_MD_${sample}_id${id}_${trial}.txt -w 200 -j 1 -d 0 -m 0.9
         #sed -e 'y/\t/\n/'  tmp/out_H12_mesolithic_NoNAhap.txt | sed -n '9p' > tmp/H12_mesolithic_NoNAhap.txt
         sed 's/.*/&\t '"$sample"'/' tmp/H12_MD_${sample}_id${id}_${trial}.txt >> out/H12_r1e-8_m0.9_id${id}.txt
   done

	# delete tmp files
	rm  tmp/*id${id}_${trial}.txt

done
