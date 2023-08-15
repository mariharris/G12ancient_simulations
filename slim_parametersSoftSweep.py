import numpy as np
import sys
#from scipy.stats import rv_discrete
import os.path

sampleSize=int(sys.argv[1])
PF=float(sys.argv[2])
introMut=int(sys.argv[3])
rho_in=float(sys.argv[4]) 
program=sys.argv[5]
K=int(sys.argv[6])
run=sys.argv[7]
ite=sys.argv[8]
burnIN=10.0

#Ne_max=326514
s=float(sys.argv[9])
AgeSweep=int(sys.argv[10])


command='slim ' + ' -d burn_in='+ str(burnIN) + ' -d sampleSize=' + str(sampleSize) + ' -d introduceMut=' +str(introMut) +' -d recomb_rate='+ str(rho_in) +' -d K='+ str(K)
command += ' -d selec='+str(s)+ ' -d PF='+str(PF)+ ' -d sampleAge='+str(AgeSweep)+ ' -d run='+str(run)+str(ite)
command +=  ' -d "file_out='+"'"+'SLiMout/VCF_K'+str(K)+'_introMut'+str(introMut)+'_AgeSweep'+str(AgeSweep)+'_s'+str(s)+'_id'+str(run)+'_'+str(ite)+'.csv'+"'"+'"' +' Tennesen_selec_SoftSweeps.slim'
print(command)
#"file_200='SLiMout/VCF_200_id${id}_${trial}.csv'"
