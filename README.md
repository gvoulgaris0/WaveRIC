# WaveRIC
Wave Radar Inversion Code (WaveRIC)  
(see Alattabi, Cahl and Voulgaris (2019), JATECH)  

This is the code described in Alattabi et al. (2019) for the inversion of the 2nd-order of a Doppler spectrum from an HF/VHF radar system. This is a hybrid, empirical radar wave inversion technique that treats swell and wind waves separately. Prior to the inversion, the 2nd order spectrum is normalized using Barrick’s (1977b) weighting function as this removes harmonic and corner reflection peaks from the inversion and improves the results. 

Alattabi et al. (2019) presented calibrations coefficiens for the wind and swell parts of the Doppler spectrum. However, not clear if these coefficients are universal as this is under verification at this time. 

Citation:  
Zaid Alattabi, Z., D. Cahl, and G. Voulgaris (2019). Swell and Wind Wave Inversion Using a Single Very High Frequency (VHF) Radar. Journal of Oceanic and Atmospheric Technology, XX: yyyy-yyyy  

Copyright 2019(c) Zaid Alattabi, Douglas Cahl, George Voulgaris

RadarWIC is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see https://www.gnu.org/licenses/.

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
  invSwellRWIC.m  
  invWindRWIC.m  
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
  wspecRWIC.m, 
