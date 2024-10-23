# -*- coding: utf-8 -*-
"""
Created on Tue Mar 16 17:08:04 2021

@author: Devansh Pandey
"""

import pandas as pd

def main():
    data = pd.read_csv(r'/work/07880/devansh/lonestar/haplotypeScans/data/regionwise_data/samples/Ancient_European_samples.csv',encoding='utf-16',sep ='\t')
    data = data.iloc[:,5:7]
    for i in data['Group label'].unique():
        data_new = data.loc[data['Group label']==str(i)]
        data_new = data_new.iloc[:,0:1]
        data_new.to_csv('/work/07880/devansh/lonestar/haplotypeScans/data/regionwise_data/samples/'+str(i)+'.txt',header=False,index=False)
    


if __name__ == "__main__":
   main()
