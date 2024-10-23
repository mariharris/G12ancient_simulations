import sys, getopt  # Import sys for command-line arguments, getopt for parsing options
import pandas as pd  # Import pandas for data manipulation
import numpy as np  # Import numpy for numerical operations, like generating random values


def main(argv):
    inputfile = ''  # Variable to hold the input file path
    try:
        # Parse command-line arguments for input file, missingness file, output file, and chromosome information
        opts, args = getopt.getopt(argv, "hi:m:o:c:", ["ifile=", "mfile=", "ofile=", "Chr="])
    except getopt.GetoptError:
        # If argument parsing fails, print the correct usage and exit
        print('string_manupulation_missingness.py -i <inputfile> -m <lmiss file> -o <outputfile> -c <chromosome>')
        sys.exit(2)
    
    # Process each argument
    for opt, arg in opts:
        if opt == '-h':
            # Help flag shows usage information and exits
            print('string_manupulation_missingness.py -i <inputfile> -m <lmiss file> -o <outputfile> -c <chromosome>')
            sys.exit()
        elif opt in ("-i", "--ifile"):
            # Input file path
            inputfile = arg
        elif opt in ("-m", "--mfile"):
            # Missingness file path
            lmissfile = arg
        elif opt in ("-o", "--ofile"):
            # Output file path
            outputfile = arg
        elif opt in ("-c", "--Chr"):
            # Chromosome number
            chr = arg
    
    # Reading and String Manipulation Section
    data = pd.read_csv(inputfile, sep=' ')  # Read input data as space-separated values
    data = data.iloc[:, 6:]  # Select only columns starting from the 7th column onward
    data = data.fillna(3, axis=1)  # Fill missing values (NaN) with 3
    data = data.replace(to_replace=3.0, value="N")  # Replace all 3.0 with 'N'
    
    # If the chromosome is '23' (likely X chromosome), replace 2.0 with '.'
    if str(chr) == '23':	
        data = data.replace(to_replace=2.0, value=".")
    else:
        # For other chromosomes, replace 1.0 with '.'
        data = data.replace(to_replace=1.0, value=".")
    
    # Loop through each column and replace values based on column name structure
    for i in data.columns:
        # Replace 0.0 and 0 with the 5th-last character of the column name
        data[i] = data[i].replace(0.0, str(i[-5]))
        data[i] = data[i].replace(0, str(i[-5]))
        # Replace 2.0 and 2 with the 2nd-last character of the column name
        data[i] = data[i].replace(2.0, str(i[-2]))
        data[i] = data[i].replace(2, str(i[-2]))
    
    # Create a new list for updated column names
    col_new = []
    
    # Adjust column names by removing unnecessary parts related to chromosome details
    for i in data.columns:
        chr = i.split('-')[0]  # Extract chromosome number or ID
        if len(chr) > 1:
            i = i[3:-6]  # For longer chromosome IDs (e.g., 'chr23'), slice accordingly
        else:
            i = i[2:-6]  # For shorter chromosome IDs (e.g., 'chr2'), slice differently
        col_new.append(i)  # Add updated column name to the list
    
    # Assign updated column names back to the dataframe
    data.columns = col_new
    
    # Incorporating Missingness into the Data
    # Read the missingness data (lmiss file) and handle different possible delimiters (spaces or tabs)
    lmiss = pd.read_csv(lmissfile, sep="\s+|\t+|\s+\t+|\t+\s+")
    
    # Extract the column with missingness percentages (F_MISS)
    missing_percentage = lmiss['F_MISS'].values
    
    # Apply random missingness to the data
    for i in data.columns:
        # Select a random missingness percentage for the column
        a = np.random.choice(missing_percentage, size=1)
        # Sample a fraction of rows equal to the selected percentage and mark them as 'N'
        dfupdate = data.sample(frac=a[0], axis=0)
        dfupdate[i] = 'N'
        # Update the column in the original dataframe with the missing values
        data[i].update(dfupdate[i])
    
    # Transpose the dataframe (swap rows and columns) for the final output
    data = data.T
    
    # Write the modified data to the output CSV file without including a header, and use commas as delimiters
    data.to_csv(outputfile, header=False, sep=",")
    

if __name__ == "__main__":
    # Entry point for the script; pass command-line arguments to the main function
    main(sys.argv[1:])
