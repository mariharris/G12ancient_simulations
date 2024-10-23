# -*- coding: utf-8 -*-
"""
Created on Thu Dec 10 22:24:51 2020

@author: Devansh Pandey
"""

import sys, getopt  # Importing the sys module to handle command-line arguments, and getopt to parse options
import pandas as pd  # Importing pandas for data manipulation and analysis


def main(argv):
    inputfile = ''  # Variable to hold the input file path
    try:
        # Parsing command-line arguments for input file, output file, and chromosome information
        opts, args = getopt.getopt(argv, "hi:o:c:", ["ifile=", "ofile=", "Chr="])
    except getopt.GetoptError:
        # If the argument parsing fails, print the correct usage of the script and exit
        print('test.py -i <inputfile> -o <outputfile>')
        sys.exit(2)
    
    # Process each argument provided
    for opt, arg in opts:
        if opt == '-h':
            # If help flag is passed, show usage and exit
            print('test.py -i <inputfile> -o <outputfile>')
            sys.exit()
        elif opt in ("-i", "--ifile"):
            # Get input file path
            inputfile = arg
        elif opt in ("-o", "--ofile"):
            # Get output file path
            outputfile = arg
        elif opt in ("-c", "--Chr"):
            # Get chromosome number
            chr = arg
         
    # Load the data from the input file using pandas, assuming space-separated values
    data = pd.read_csv(inputfile, sep=' ')
    
    # Extract all columns starting from the 7th column onward
    data = data.iloc[:, 6:]
    
    # Replace any NaN values with '3' (likely representing missing data)
    data = data.fillna(3, axis=1)
    
    # Replace all occurrences of '3' with the letter 'N' (perhaps indicating a specific condition in the data)
    data = data.replace(to_replace=3.0, value="N")
    
    # Special case for chromosome 23 (likely the X chromosome), replacing '2' with '.' (potentially indicating homozygosity)
    if str(chr) == '23':	
        data = data.replace(to_replace=2.0, value=".")
    else:
        # For all other chromosomes, replace '1' with '.'
        data = data.replace(to_replace=1.0, value=".")
    
    # Loop through each column to replace values with the corresponding chromosome numbers
    for i in data.columns:
        # Replace '0' with the 5th-last character of the column name (assumed to be related to genetic data)
        data[i] = data[i].replace(0.0, str(i[-5]))
        data[i] = data[i].replace(0, str(i[-5]))
        
        # Replace '2' with the 2nd-last character of the column name
        data[i] = data[i].replace(2.0, str(i[-2]))
        data[i] = data[i].replace(2, str(i[-2]))
    
    # Create a new list to hold modified column names
    col_new = []
    
    # Loop through the columns and reformat the names to remove chromosome details
    for i in data.columns:
        chr = i.split('-')[0]  # Extract chromosome number (or ID)
        if len(chr) > 1:
            # For multi-character chromosome names (e.g., 'chr23'), slice the name differently
            i = i[3:-6]
        else:
            # For single-character chromosome names (e.g., 'chr2'), slice differently
            i = i[2:-6]
        col_new.append(i)  # Append the modified name to the new list
    
    # Assign the new column names to the dataframe
    data.columns = col_new
    
    # Transpose the dataframe (swap rows and columns) to prepare it for output
    data = data.T
    
    # Save the processed data to the output file in CSV format, without including the header row
    data.to_csv(outputfile, header=False, sep=",")
    
      
if __name__ == "__main__":
    # Entry point for the script; passes command-line arguments (excluding the script name) to the main function
    main(sys.argv[1:])
