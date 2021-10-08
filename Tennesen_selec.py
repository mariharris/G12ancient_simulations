from optparse import OptionParser
import numpy as np
import pandas as pd
import subprocess
from bisect import bisect_left, bisect_right


def parseVCF(VCF):
	pos= VCF['POS'].to_numpy()
	gen_id= [col for col in VCF if col.startswith('i')]
	gen_df=VCF[gen_id]
	gen_df.columns = range(gen_df.shape[1])
	return(pos, gen_df)

def VCFhaps(gen_df):
	s=gen_df.shape
	n=  s[1]
	m= s[0]*2
	hap = np.empty((m,n))
	for i in gen_df. columns:
		hapsdf=gen_df.assign(var=gen_df[i].str.split('|')).explode('var')
		hap[:,i]=hapsdf[hapsdf.columns[-1]]
	return(hap)

def per_n_SNP(Mut,n):
	return Mut.iloc[::n, :]

def pseudo_haplo(gen_df):
	#print(gens.iloc[j][i])
	s=gen_df.shape
	n=  s[1]
	m= s[0]
	ps_hap = np.empty((m,n))
	for i in gen_df. columns:
		gens = gen_df[i].str.split('|')
		ber = np.random.binomial(1, 0.5,m)
		for j in range(0,m):
			ps_hap[j,i]= (gens[j])[ber[j]]
	return(ps_hap)

def sparse_pseudo_hap(gen_df,l):
	#print(gens.iloc[j][i])
	s=gen_df.shape
	n=  s[1]
	m= s[0]
	ps_hap = np.empty((m,n))
	for i in gen_df.columns:
		gens = gen_df[i].str.split('|')
		ber = np.random.binomial(1, 0.5,m)
		for j in range(0,m):
			ps_hap[j,i]= (gens[l*j])[ber[j]]
	return(ps_hap)

def parseAT(Mut,pos):
	Mut2=np.where(Mut==0, 'A',Mut)
	Mut2 =np.where(Mut==1, 'T',Mut2).transpose()
	posMut=(np.vstack((pos,Mut2))).transpose()
	return posMut

def parseCG(Mut,pos):
	Mut2=np.where(Mut==0, 'C',Mut)
	Mut2 =np.where(Mut==1, 'G',Mut2).transpose()
	posMut=(np.vstack((pos,Mut2))).transpose()
	return posMut

def sample_n(VCF,sampl):
	VCF_df = VCF.sample(n=sampl)
	VCF_df[0] = pd.to_numeric(VCF_df[0])
	VCF_df=VCF_df.sort_values(VCF_df.columns[0])
	return VCF_df

def sample_n_genes(VCF,sampl):
	VCF_df = VCF.sample(n=sampl)
	VCF_df=VCF_df.sort_values(by=['POS'])
	return VCF_df

def window_sample(VCF):
	lower= 120976777 #lower bound for window of approximate size 239976bp
	upper = 121216753 #upper bound for window of approximate size 239976bp
	l=bisect_left(VCF['POS'].values, lower)
	up = bisect_left(VCF['POS'].values, upper)
	VCF_window= VCF.iloc[l:(up+1),]
	return VCF_window

def per_n_SNP(Mut,n):
	return Mut.iloc[::n, :]

def Sperbp(Mut,L): #Mut data frame with snps positions vertically and horizontally observetions
	return Mut.shape[0]/L

def Pi(Mut):
	k = Mut.shape[0]
	N=Mut.shape[1]
	pi = np.array(Mut.sum(axis=1)).flatten().astype(np.float)/N
	pi=2*np.multiply(pi,1-pi)
	return pi

def parseForH12_full(file_df):
	VCF = sample_n_genes(file_df,101)# (num of Snps in window)/2
	pos, muts=parseVCF(VCF)
	haps = VCFhaps(muts)
	pos_hap = np.repeat(pos,2)
	posMuts = parseAT(haps,pos_hap)
	return posMuts

def parseForH12_psh(file_df):
	pos, muts=parseVCF(file_df)
	ps_haps=pseudo_haplo(muts)
	posMutsFull = parseAT(ps_haps,pos)
	if posMutsFull.shape[0]>=201:
		 posMuts=posMutsFull[np.random.choice(posMutsFull.shape[0], 201, replace=False)]
		 posMuts=posMuts[(posMuts[:,0]).astype(int).argsort()]
	else:
		posMuts=posMutsFull
	#posMuts=sample_n(pd.DataFrame(posMutsFull),101) #sample 101 SNps after pseudohap
	return posMuts

def addMissingData(posMuts): #frac is the fraction of missing data per column
	Nan_df=pd.DataFrame(posMuts[:,1:])
	for col in Nan_df.columns:
		f = np.random.beta(1.97388,1.62809,1)
		nanidx =Nan_df[col].sample(frac=f[0]).index
		Nan_df[col][nanidx]=np.nan
	df = Nan_df.fillna('N')
	df.insert(0,'pos',posMuts[:,0])
	return df
####################################Main functions#################################################################
def main_haps (MD):
	#read VCF files
	VCF_modern = pd.read_csv('tmp/VCF_modern.csv', skiprows=13, sep='\t')
	VCF_mesolithic = pd.read_csv('tmp/VCF_mesolithic.csv', skiprows=13, sep='\t')
	#Mesolithic
	posMuts_mesolithic = parseForH12_full(VCF_mesolithic)
	posMuts_mesolithic_MD=addMissingData(posMuts_mesolithic)
	pd.DataFrame(posMuts_mesolithic).to_csv('tmp/out_selec_mesolithic.txt',mode = 'w', index=False,header=False)
	pd.DataFrame(posMuts_mesolithic_MD).to_csv('tmp/out_selec_mesolithic_MD.txt',mode='w', index=False,header=False)
	#Mesolithic
	posMuts_modern = parseForH12_full(VCF_modern)
	posMuts_modern_MD=addMissingData(posMuts_modern)
	pd.DataFrame(posMuts_modern).to_csv('tmp/out_selec_modern.txt',mode = 'w', index=False,header=False)
	pd.DataFrame(posMuts_modern_MD).to_csv('tmp/out_selec_modern_MD.txt',mode = 'w', index=False,header=False)

def main_pseudoh (MD):
    VCF_modern = pd.read_csv('tmp/VCF_modern.csv', skiprows=13, sep='\t')
    VCF_250 = pd.read_csv('tmp/VCF_250.csv', skiprows=13, sep='\t')
    VCF_100 = pd.read_csv('tmp/VCF_100.csv', skiprows=13, sep='\t')
    VCF_mesolithic = pd.read_csv('tmp/VCF_mesolithic.csv', skiprows=13, sep='\t')
    #Mesolithic
    posMuts_mesolithic = parseForH12_psh(VCF_mesolithic)
    posMuts_mesolithic_MD=addMissingData(posMuts_mesolithic)
    pd.DataFrame(posMuts_mesolithic).to_csv('tmp/out_selec_mesolithic.txt',mode = 'w', index=False,header=False)
    pd.DataFrame(posMuts_mesolithic_MD).to_csv('tmp/out_selec_mesolithic_MD.txt',mode='w', index=False,header=False)
    #250
    posMuts_250 = parseForH12_psh(VCF_250)
    posMuts_250_MD=addMissingData(posMuts_250)
    pd.DataFrame(posMuts_250_MD).to_csv('tmp/out_selec_250_MD.txt',mode = 'w', index=False,header=False)
    pd.DataFrame(posMuts_250).to_csv('tmp/out_selec_250.txt',mode = 'w', index=False,header=False)

    #100
    posMuts_100 = parseForH12_psh(VCF_100)
    posMuts_100_MD=addMissingData(posMuts_100)
    pd.DataFrame(posMuts_100_MD).to_csv('tmp/out_selec_100_MD.txt',mode = 'w', index=False,header=False)
    pd.DataFrame(posMuts_100).to_csv('tmp/out_selec_100.txt',mode = 'w', index=False,header=False)

    #modern
    posMuts_modern = parseForH12_psh(VCF_modern)
    posMuts_modern_MD=addMissingData(posMuts_modern)
    pd.DataFrame(posMuts_modern_MD).to_csv('tmp/out_selec_modern_MD.txt',mode = 'w', index=False,header=False)
    pd.DataFrame(posMuts_modern).to_csv('tmp/out_selec_modern.txt',mode = 'w', index=False,header=False)

############################### Main ##############################################################################
if __name__=="__main__":
	#Mising data
	usage = """%prog  <input> <snp data>"""
	parser = OptionParser(usage)
	parser.add_option("-m", "--MD", type="float",  default=0.1,    help="Missing rate per snp")
	options, args= parser.parse_args()
	MD= options.MD
	#main_haps(MD)
	main_pseudoh(MD)
