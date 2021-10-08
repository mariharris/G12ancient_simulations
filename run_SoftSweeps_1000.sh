#!/bin/bash
#load modules
module load anaconda3
source /u/local/apps/anaconda3/2020.11/etc/profile.d/conda.sh
conda activate slim

for trial in {1..100};do
	for K in 5 10 25 50;do
      #run slim simulation
        slim -d burn_in=11.0 -d selec=0.1 -d K=${K} -d introduceMut=1000 -d sampleSize=177 Tennessen_SoftSweeps.slim

	#run python file
	python Tennesen_selec.py -m 0.548
	
	##################################################################################$
        #######################No NA haplotypes############################################$
        ##################################################################################$

	## Mesolithic sample
        python H12_H2H1_MD.py tmp/out_selec_mesolithic_MD.txt 177 -o tmp/out_H12_mesolithic_NoNAhap.txt -w 200 -j 1 -d 0
        sed -e 'y/\t/\n/'  tmp/out_H12_mesolithic_NoNAhap.txt | sed -n '9p' > tmp/H12_mesolithic_NoNAhap.txt
        sed 's/.*/&\t '"$K"'/' tmp/H12_mesolithic_NoNAhap.txt >> out/out_H12_mesolithic_NoNAhap.txt

	##250
 	python H12_H2H1_MD.py tmp/out_selec_250_MD.txt 177 -o tmp/out_H12_250_NoNAhap.txt -w 200 -j 1 -d 0
        sed -e 'y/\t/\n/'  tmp/out_H12_250_NoNAhap.txt | sed -n '9p' > tmp/H12_250_NoNAhap.txt
        sed 's/.*/&\t '"$K"'/' tmp/H12_250_NoNAhap.txt >> out/out_H12_250_NoNAhap.txt

	##100
	python H12_H2H1_MD.py tmp/out_selec_100_MD.txt 177 -o tmp/out_H12_100_NoNAhap.txt -w 200 -j 1 -d 0
        sed -e 'y/\t/\n/'  tmp/out_H12_100_NoNAhap.txt | sed -n '9p' > tmp/H12_100_NoNAhap.txt
        sed 's/.*/&\t '"$K"'/' tmp/H12_100_NoNAhap.txt >> out/out_H12_100_NoNAhap.txt

	## Modern
        python H12_H2H1_MD.py tmp/out_selec_modern_MD.txt 177 -o tmp/out_H12_modern_NoNAhap.txt -w 200 -j 1 -d 0
        sed -e 'y/\t/\n/'  tmp/out_H12_modern_NoNAhap.txt | sed -n '9p' > tmp/H12_modern_NoNAhap.txt
        sed 's/.*/&\t '"$K"'/' tmp/H12_modern_NoNAhap.txt >> out/out_H12_modern_NoNAhap.txt

        ##################################################################################$
        #######################Average H12#################################################$
        ##################################################################################$
	#runs H12 101 SNP window
	#for i in {1..100};do
	#    python H12_H2H1_Py3.py tmp/out_selec_mesolithic_MD.txt 187 -o H12_tmp_meso/out_H12_mesolithic_${i}.txt -w 100
	#    python H12_H2H1_Py3.py tmp/out_selec_modern_MD.txt 187 -o H12_tmp_mod/out_H12_modern_${i}.txt -w 100
	#done

	#Merge H12 files and get mean H12 of 100 runs
	#L_meso=$(wc -l H12_tmp_meso/out_H12_mesolithic_1.txt)
	#numL_meso=${L_meso%% *}
	#python H12_MD.py -d H12_tmp_meso/ -l ${numL_meso} -f tmp/H12_merged_mesolithic.txt

	#L_modern=$(wc -l H12_tmp_mod/out_H12_modern_1.txt)
	#numL_modern=${L_modern%% *}
	#python H12_MD.py -d H12_tmp_mod/ -l ${numL_modern} -f tmp/H12_merged_modern.txt

	#converts tabs from H12 output to lines and reads 9th line which corresponds to H12
	#sed -e 'y/\t/\n/'  tmp/H12_merged_mesolithic.txt | sed -n '9p' > tmp/H12_tmp.txt
	#sed 's/.*/&\t '"$K"'/' tmp/H12_tmp.txt >> out/out_H12_mesolithic_MD.txt

	#sed -e 'y/\t/\n/'  tmp/H12_merged_modern.txt | sed -n '9p' > tmp/H12_tmp.txt
	#sed 's/.*/&\t '"$K"'/' tmp/H12_tmp.txt >> out/out_H12_modern_MD.txt

	######################################################################################
	#######################No missing data################################################
	######################################################################################
        
	## Mesolithic sample
        python H12_H2H1_Py3.py tmp/out_selec_mesolithic.txt 177 -o tmp/out_H12_mesolithic.txt -w 200 -j 1 -d 0
        sed -e 'y/\t/\n/'  tmp/out_H12_mesolithic.txt | sed -n '9p' > tmp/H12_mesolithicFull.txt
        sed 's/.*/&\t '"$K"'/' tmp/H12_mesolithicFull.txt >> out/out_H12_mesolithic.txt

	##250
 	python H12_H2H1_Py3.py tmp/out_selec_250.txt 177 -o tmp/out_H12_250.txt -w 200 -j 1 -d 0
        sed -e 'y/\t/\n/'  tmp/out_H12_250.txt | sed -n '9p' > tmp/H12_250Full.txt
        sed 's/.*/&\t '"$K"'/' tmp/H12_250Full.txt >> out/out_H12_250.txt

	##100
       	python H12_H2H1_Py3.py tmp/out_selec_100.txt 177 -o tmp/out_H12_100.txt -w 200 -j 1 -d 0
        sed -e 'y/\t/\n/'  tmp/out_H12_100.txt | sed -n '9p' > tmp/H12_100Full.txt
        sed 's/.*/&\t '"$K"'/' tmp/H12_100Full.txt >> out/out_H12_100.txt

	## Modern
        python H12_H2H1_Py3.py tmp/out_selec_modern.txt 177 -o tmp/out_H12_modern.txt -w 200 -j 1 -d 0
        sed -e 'y/\t/\n/'  tmp/out_H12_modern.txt | sed -n '9p' > tmp/H12_modernFull.txt
        sed 's/.*/&\t '"$K"'/' tmp/H12_modernFull.txt >> out/out_H12_modern.txt


         ######################################################################################
	#######################normal H12 with missing data##################################
	######################################################################################

        python H12_H2H1_Py3.py tmp/out_selec_mesolithic_MD.txt 177 -o tmp/out_H12_mesolithic_MD.txt -w 200 -j 1 -d 0
        sed -e 'y/\t/\n/'  tmp/out_H12_mesolithic_MD.txt | sed -n '9p' > tmp/H12_mesolithic_MD.txt
        sed 's/.*/&\t '"$K"'/' tmp/H12_mesolithic_MD.txt >> out/out_H12_mesolithic_MD.txt

 	 ##250
	python H12_H2H1_Py3.py tmp/out_selec_250_MD.txt 177 -o tmp/out_H12_250_MD.txt  -w 200 -j 1 -d 0
        sed -e 'y/\t/\n/'  tmp/out_H12_250_MD.txt | sed -n '9p' > tmp/H12_250_MD.txt
        sed 's/.*/&\t '"$K"'/' tmp/H12_250_MD.txt >> out/out_H12_250_MD.txt

        ##100
	python H12_H2H1_Py3.py tmp/out_selec_100_MD.txt 177 -o tmp/out_H12_100_MD.txt  -w 200 -j 1 -d 0
        sed -e 'y/\t/\n/'  tmp/out_H12_100_MD.txt | sed -n '9p' > tmp/H12_100_MD.txt
        sed 's/.*/&\t '"$K"'/' tmp/H12_100_MD.txt >> out/out_H12_100_MD.txt

        python H12_H2H1_Py3.py tmp/out_selec_modern_MD.txt 177 -o tmp/out_H12_modern_MD.txt -w 200 -j 1 -d 0
        sed -e 'y/\t/\n/'  tmp/out_H12_modern_MD.txt | sed -n '9p' > tmp/H12_modern_MD.txt
        sed 's/.*/&\t '"$K"'/' tmp/H12_modern_MD.txt >> out/out_H12_modern_MD.txt

	# delete tmp files
	rm  tmp/*
	#rm  H12_tmp_meso/*
	#rm H12_tmp_mod/*

      done
done
