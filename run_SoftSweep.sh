#!/bin/bash
# This script runs sweep on tennessen et al model adds missing data and pseudohap 
file=$1
sampleSize=$2
id=$3
introduceMut=$4
PF=$5
recomb_rate=$6
AgeSweep=$7
s=$8
K=$9

for i in `seq 1 10`; do #1100 

	echo $id
	#get slim command
	#run slim
	
	python slim_parametersSoftSweep.py ${sampleSize} ${PF} ${introduceMut} $recomb_rate slim $K $id $i $s $AgeSweep > ${file}_var

	command=`cat ${file}_var | head -1` 

	echo $command
    	s=`echo $command | grep -o "selec=.*" | tr ' ' '\n' | head -1| cut -d"=" -f2- `
    	age=`echo $command | grep -o "sampleAge=.*" | tr ' ' '\n' | head -1| cut -d"=" -f2-`
   
    	echo 's is' $s
    	echo 'age is' $age	
    	eval $command

    	#parse for H12
   
    	#run python code to pseudo haplodize and add missing data
    	python Tennesen_Parse.py -m 0.55 -s 0.23 -i SLiMout/VCF_K${K}_introMut${introduceMut}_AgeSweep${AgeSweep}_s${s}_id${id}_${i}.csv -o tmp_intermediate_files/MS_K${K}_introMut${introduceMut}_AgeSweep${AgeSweep}_s${s}_id${id}_${i}.txt

	#parse to get SF2 data format
        python SF2_Parse.py -m 0.55 -s 0.23 -i SLiMout/VCF_K${K}_introMut${introduceMut}_AgeSweep${AgeSweep}_s${s}_id${id}_${i}.csv -o SF2_data/SF2_K${K}_introMut${introduceMut}_AgeSweep${AgeSweep}_s${s}_id${id}_${i}.txt
 	    	
	#run G12 in simulated data
    	#H12_H2H1_MD.py
    	python H12_H2H1_Py3_simulations_removeMDHaps.py  tmp_intermediate_files/MS_K${K}_introMut${introduceMut}_AgeSweep${AgeSweep}_s${s}_id${id}_${i}.txt 177 -o tmp_intermediate_files/H12_MD_K${K}_${introduceMut}_AgeSweep${AgeSweep}_s${s}_id${id}_${i}.txt  -w 200 -j 1 -d 0 -a $AgeSweep -l $s -m 0.9
    
	#comment this out if I want to keep VCFs
	SLiMout/VCF_K${K}_introMut${introduceMut}_AgeSweep${AgeSweep}_s${s}_id${id}_${i}.csv
done

echo ${K}
cat tmp_intermediate_files/H12_MD_K${K}_${introduceMut}_AgeSweep${AgeSweep}_s${s}_id${id}_* > outH12/H12_SoftSweeps_K${K}_introMut${introduceMut}_AgeSweep${AgeSweep}_s${s}_${id}.txt
#rm  SLiMout/*_id${id}_*
rm tmp_intermediate_files/*_tmp_${id}.txt_var
rm tmp_intermediate_files/H12_MD_K${K}_${introduceMut}_AgeSweep${AgeSweep}_s${s}_id${id}_*
rm tmp_intermediate_files/MS_K${K}_introMut${introduceMut}_AgeSweep${AgeSweep}_s${s}_id${id}_${i}.txt



