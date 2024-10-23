# G12 Scans on Modern Data from 1000 Genomes Project

This repository contains scripts designed to run G12 scans on modern data from the 1000 Genomes Project. The data has already been processed into pseudo-haplotypes and ascertained using the 1240k capture array, mimicking ancient DNA (aDNA) data.

## Repository Structure

### 1. [**Processing/**](Preprocessing/)
This directory contains scripts for processing the raw modern data and converting it to the default G12 format. The processing includes handling pseudo-haplotypes and ensuring compatibility with G12 scans.

### 2. [**Running_G12/**](Running_G12/)
In this directory, you will find scripts that run G12 scans on the processed modern data. These scripts are designed to simulate conditions typical for ancient DNA (aDNA) data analysis.

## How to Use

1. **Data Processing:**
   - Navigate to the [**Processing/**](Preprocessing/) directory and execute the provided scripts to transform your modern data into the required G12 format.

2. **Running G12:**
   - Once your data is in the correct format, move to the [**Running_G12/**](Running_G12/) directory to run the G12 scan on the processed data.

## Prerequisites

- Ensure that your input data has been pre-processed to pseudo-haplotypes and ascertained on the 1240k capture array before using the scripts in this repository.
