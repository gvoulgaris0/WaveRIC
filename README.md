# WaveRIC: Wave Radar Inversion Code 
(see Alattabi, Cahl and Voulgaris (2019), JTECH)  

This is the code described in Alattabi et al. (2019) for the inversion of the 2nd-order of a Doppler spectrum from an HF/VHF radar system. This is a hybrid, empirical radar wave inversion technique that treats swell and wind waves separately. Prior to the inversion, the 2nd order spectrum is normalized using Barrick’s (1977b) weighting function as this removes harmonic and corner reflection peaks from the inversion and improves the results. 

Alattabi et al. (2019) presented calibrations coefficiens for the wind and swell parts of the Doppler spectrum. However, not clear if these coefficients are universal as this is under verification at this time. 

- Code Citation:  
Douglas, Cahl, Voulgaris, George, & Alattabi, Zaid. (2019, March 15). Wave Radar Inversion Code (WaveRIC) (Version V1.0.0). Zenodo. http://doi.org/10.5281/zenodo.2594033  
- Method Citation:  
Zaid Alattabi, Z., D. Cahl, and G. Voulgaris (2019). Swell and Wind Wave Inversion Using a Single Very High Frequency (VHF) Radar. Journal of Oceanic and Atmospheric Technology, XX: yyyy-yyyy  

Copyright 2019(c) Zaid Alattabi, Douglas Cahl, George Voulgaris

RadarWIC is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see https://www.gnu.org/licenses/.

The files are located in three directories  
- WaveRIC  
-It contains the main functions used to run the inversion (ConfigRWIC.m, masterRadarWIC.m, RadarWIC.m);  
-file RWIC_Contents.html contains inflormation about the functions included in the package;  
-master_testing.m is an example using the functions to recreate the spectra in the paper, figure 10;;
- WaveRIC/lib  
It contains a number of functions called by the main function
- WaveRIC/html and WaveRIC/lib/html
It contains explanations for each function in html files. These are called from RWIC_Contents.html  
- WaveRIC/data  
It contains the data files used by master_testing.m for running examples from the Alattabi et al (2019) paper; Events A to H. It recreates Figure 11.

List of Files  

Main Functions:  

  ConfigRWIC.m  
  masterRadarWIC.m  
  RadarWIC.m

Library Functions (../lib):

  Bragg_peak.m  
  ConditionDopRWIC.m  
  Gauss_fit.m  
  hfr_noise.m  
  findSwellRWIC.m  
  plot_swell.m  
  plot_wind.m  
  PXYint.m  
  PXYsideband.m  
  specSwellRWIC.m  
  specWindRWIC.m  
  spectral_noise.m  
  waveparams.m  
  weightf_barrick.m  
  wn2ndRWIC.m  
  wspecRWIC.m
