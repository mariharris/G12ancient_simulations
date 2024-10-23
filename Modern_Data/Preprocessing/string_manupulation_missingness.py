import sys, getopt
import pandas as pd
import numpy as np


def main(argv):
    inputfile = ''
    try:
      opts, args = getopt.getopt(argv,"hi:m:o:c:",["ifile=","mfile=","ofile=","Chr="])
    except getopt.GetoptError:
       print('string_manupulation_missingness.py -i <inputfile> -m <lmiss file> -o <outputfile> -c <chromosome>')
       sys.exit(2)
    for opt, arg in opts:
       if(opt == '-h'):
          print('string_manupulation_missingness.py -i <inputfile> -m <lmiss file> -o <outputfile> -c <chromosome>')
          sys.exit()
       elif(opt in ("-i", "--ifile")):
          inputfile = arg
       elif(opt in ("-m", "--mfile")):
          lmissfile = arg        
       elif(opt in ("-o", "--ofile")):
          outputfile = arg
       elif(opt in ("-c", "--Chr")):
          chr = arg
    
    
    
    
    #Reading and String Manupulation
    data = pd.read_csv(inputfile,sep=' ')
    data = data.iloc[:,6:]
    data = data.fillna(3, axis =1)
    data = data.replace(to_replace =3.0, value ="N")
    if(str(chr) == '23'):	
    	data = data.replace(to_replace = 2.0,value = ".")
    else:
        data = data.replace(to_replace = 1.0,value = ".")
    for i in data.columns:
        data[i] = data[i].replace(0.0, str(i[-5]))
        data[i] = data[i].replace(0, str(i[-5]))
        data[i] = data[i].replace(2.0, str(i[-2]))
        data[i] = data[i].replace(2, str(i[-2]))
    col_new = []
    for i in data.columns:
      chr = i.split('-')[0]
      if(len(chr)>1):
          i = i[3:-6]
      else:
          i = i[2:-6]
      col_new.append(i)
    data.columns = col_new
    
    
    #Incorporating Missingness in the data
    lmiss = pd.read_csv(lmissfile, sep ="\s+|\t+|\s+\t+|\t+\s+")
    missing_percentage = lmiss['F_MISS'].values
    
    for i in data.columns:
        a = np.random.choice(missing_percentage, size=1)
        dfupdate=data.sample(frac=a[0],axis =0)
        dfupdate[i] = 'N'
        data[i].update(dfupdate[i])
    
    
    data = data.T
    data.to_csv(outputfile, header = False, sep = ",")
    
      
if __name__ == "__main__":
   main(sys.argv[1:])
