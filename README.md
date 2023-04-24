# Ancient_DNA_simulations

Simulations for manuscript: Pandey D, Harris M, Garud N and Narasimhan V.
  **Understanding Natural Selection in the European Holocene using Ancient DNA** 
  
 
We include files used to run hard and soft sweep simulations as well as the code used to compute the false discovery rate values computed from neutral simulations ("Neutral" folder).

We simulated the Tennessen et al. demographic model which describes the ancestral human population in Africa, followed by the out-of-Africa event and two periods of European population growth.

<img width="463" alt="image" src="https://user-images.githubusercontent.com/52009392/234131938-8e1ae97f-0492-4607-aa59-1ef633da373e.png">

**Figure 1.** Tennessen et al. model (Fu et al. 2013, Fig S5).

**Selective sweep simulations**

We modified the _stdpopsim_ code  (https://popsim-consortium.github.io/stdpopsim-docs/stable/catalog.html#sec_catalog_HomSap_models) for the Two-population out-of-Africa demographic model (Tennessen et al. 2012) to include positive selection. The corresponding code for hard and soft sweep models are: _Tennessen_HardSweeps.slim_ and _Tennessen_SoftSweeps.slim_, respectively.

We varied the time of the onset of selection, generation of sample and the selection coefficient of the sweeps. We consider a mean generation time of 28 years and obtain samples of 177 individuals at each sampling time point. For the hard sweep simulations, a single beneficial mutation was introduced halfway through the chromosome of a random individual from the European population. For the soft sweep simulations we introduced K beneficial mutations at the time of the onset of selection for K=5,10,25 and 50. All sweep simulations are conditional on the sweep not being lost.


**Missing data and pseudo-haploidization**

Based on missingness observed in the data we added missing data to our simulated datasets with a mean rate of 0.55 missingness per SNP and standard deviation of 0.23. We next pseudo haploidized the data using a pseudo haploidization scheme in which we randomly selected one of the two alleles in the case of heterozygous genotypes. Based on previous haplotype-based statistics (Garud et al. 2015; Harris et al. 2018), we define the multilocus-genotype based statistic for aDNA data as:

$$G12_{anciet}= (p_1 + p_2)^2 + \sum_{i>2}p_i^2,$$

where $p_i$ is the frequency of the _i_-th most common pseudo-haplotype in a sample.

The code to run 100 simulations for each combination of parameters can be found in the _run_HardSweeps_1000.sh_ and _run_SoftSweeps_1000.sh_ files for hard and soft sweeps, respectively.
