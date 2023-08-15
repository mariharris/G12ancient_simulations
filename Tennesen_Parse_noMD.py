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

def addMissingData(posMuts,MD,sd): #frac is the fraction of missing data per column
    alpha=(MD**2*(1-MD))/sd**2-MD
    beta=alpha/MD*(1-MD)
    Nan_df=pd.DataFrame(posMuts[:,1:])
    for col in Nan_df.columns:
        f = np.random.beta(alpha,beta,1)
        nanidx =Nan_df[col].sample(frac=f[0]).index
        Nan_df[col][nanidx]=np.nan
    df = Nan_df.fillna('N')
    df.insert(0,'pos',posMuts[:,0])
    return df
####################################Main functions#################################################################
def main_haps (MD):
    #read VCF files
    VCF = pd.read_csv(inFilePath, skiprows=13, sep='\t')
    
    posMuts = parseForH12_full(VCF)
    posMuts_MD=addMissingData(posMuts,MD,sd)
    #pd.DataFrame(posMuts).to_csv('tmp/out_selec_mesolithic.txt',mode = 'w', index=False,header=False)
    pd.DataFrame(posMuts_MD).to_csv('outFilePath',mode='w', index=False,header=False)
    
def main_pseudoh (MD,sd,inFilePath,outFilePath):
    VCF = pd.read_csv(inFilePath, skiprows=13, sep='\t')
    
    posMuts = parseForH12_psh(VCF)
    #posMuts_MD=addMissingData(posMuts,MD,sd)
    #pd.DataFrame(posMuts).to_csv('tmp/out_selec_mesolithic.txt',mode = 'w', index=False,header=False)
    pd.DataFrame(posMuts).to_csv(outFilePath,mode='w', index=False,header=False)
    
############################### Main ##############################################################################
if __name__=="__main__":
    #Mising data
    usage = """%prog  <input> <snp data>"""
    parser = OptionParser(usage)
    parser.add_option("-m", "--MD", type="float",  default=0.4,    help="mean missing rate per snp")
    parser.add_option("-s", "--sd", type="float",  default=0.2,    help="sd of missing data rate per snp")
    parser.add_option("-i", "--inFile", type="string",  default="-",    help="input file path")
    parser.add_option("-o", "--outFile", type="string",  default="-",    help="output file path")
    options, args= parser.parse_args()
    MD= options.MD
    sd= options.sd
    inFilePath= options.inFile
    outFilePath= options.outFile
    #main_haps(MD)
    main_pseudoh(MD,sd,inFilePath,outFilePath)
