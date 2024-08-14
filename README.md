# README
## Article Information
This repository provides access to the data and source code used for the manuscript    
### **Wasted efforts impair random search efficiency and reduce the level of choosiness in mate-pairing termites**    
### Nobuaki Mizumoto, Naohisa Nataya, Ryusuke Fujisawa  
Contact, Nobuaki Mizumoto: nzm0095@auburn.edu

This paper is accepted at The American Naturalist.  
Preprint is available at bioRxiv. [![DOI:10.1101/2024.02.01.578198](http://img.shields.io/badge/DOI-10.1101/2024.02.01.578198.svg)]  
The data and code are also available at Dryad  [DOI:10.5061/dryad.sn02v6xbq](https://doi.org/10.5061/dryad.sn02v6xbq)

This study examines how movement patterns of mate searchers of a termite _Reticulitermes speratus_ changes according to time. Then investigated how this change in movement patterns affect random search efficiency and mate choice behavior.  
This includes tracking data, R codes to analyze it, and Cpp code for simulations.  

## Table of Contents
* [README](./README.md)
* [scripts](./analysis/scripts)
  * [output.R](./analysis/scripts/output.R) - output all results
  * [processing.R](./analysis/scripts/processing.R) - data processing of coordinates obtained from servosphere
  * [simulations.R](./analysis/scripts/simulations.R) - for data-based simulations
  * [onesim.cpp](./analysis/scripts/onesim.cpp) - functions for simulations
* [output](./analysis/output) - all outputs are stored
* [data](./analysis/data)
  * [raw](./analysis/data/raw) - raw data in .csv
    * [ANTAM_4day](./analysis/data/raw/ANTAM_4day) - directory includes raw data obtained from servosphere. Ignore the first four columns. col4: x, col5: y, col6: time
    * **colonyfoundation.csv** - data for colony foundation experiments.
    * **tandem_sum.csv** - the number of observations of individual units in each experiment. units include solomale (single male), solofemale (single female), heterotandem (female-male tandem), male tandem (male-male tandem), female tandem (female-female tandem), and tandem3 (tandem run with >= 3 individuals).
    * **tandem_timedevelopment.csv** - breakdown of tandem_sum.csv. The measurement was not summarized but for each observation bouts (5: 0-5 min, 10: 5-10 min, ...).
    * **termite_weight.csv** - Termite weight measurement. fresh: fresh weight in mg.
  * [fmt](./analysis/data/fmt) - formatted data created in processing.R and simulations.R. The formatted data will be used for output.R. The all formatted data are in .rda files. The .csv files with the same contents are also generated for reviewing purpose.
    * **df_all.rda** - The processed data of trajectories for furthur analysis. It has three datafrmaes named df_all (trajectories with traveled distance information for each frame), df_MSD (MSD data for each individual), df_pause (duration of pauses for each pausing events for each individual). The corresponding csv files are df_all.csv, df_MSD.csv, and df_pause.csv
    * **df_sum.rda** - The file further processed df_all.rda to summarize all parameters for each individual. df_sum.csv is corresponding. 
    * **df_sim.rda** - The simulation results that record encounter time for each searching attempts. encounter_time = 1501 indicates the failure to encounter. df_sim.csv is corresponding. 
    
    

## Session information
```
R version 4.3.1 (2023-06-16 ucrt)
Platform: x86_64-w64-mingw32/x64 (64-bit)
Running under: Windows 11 x64 (build 22621)

Matrix products: default


locale:
[1] LC_COLLATE=English_United States.utf8 
[2] LC_CTYPE=English_United States.utf8   
[3] LC_MONETARY=English_United States.utf8
[4] LC_NUMERIC=C                          
[5] LC_TIME=English_United States.utf8    

time zone: Asia/Tokyo
tzcode source: internal

attached base packages:
[1] stats     graphics  grDevices utils     datasets  methods   base     

other attached packages:
 [1] CircStats_0.2-6       boot_1.3-28.1         MASS_7.3-60          
 [4] stringr_1.5.0         survival_3.5-5        survminer_0.4.9      
 [7] ggpubr_0.6.0          Rcpp_1.0.10           PupillometryR_0.0.5  
[10] rlang_1.1.1           dplyr_1.1.2           viridis_0.6.3        
[13] viridisLite_0.4.2     ggplot2_3.4.2         Rmisc_1.5.1          
[16] plyr_1.8.8            lattice_0.21-8        exactRankTests_0.8-35
[19] car_3.1-2             carData_3.0-5         lme4_1.1-34          
[22] Matrix_1.6-1          data.table_1.14.8    
```
