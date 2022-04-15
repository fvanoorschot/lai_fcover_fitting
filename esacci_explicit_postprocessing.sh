#!/bin/bash

fol=~/work/fransje/DATA/CONFESS/lc-user-tools-4.3/output/final_output
year=1992

#cd $fol
#file=ESACCI-LC-L4-LCCS-Map-300m-P1Y-aggregated-0.008929Deg-USER_REGION-${year}-v2.0.7cds.nc
#
#cdo -selvar,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20 ${file} var_${file}
#
#cdo gennn,esacci_grid.txt var_${file} weigths.nc
#cdo remap,esacci_grid.txt,weigths.nc var_${file} esacci_expfraction_${year}.nc
#rm var_${file}

#for year in {2018..2019}
#do
year=2019
cd $fol
#file=ESACCI-LC-L4-LCCS-Map-300m-P1Y-aggregated-0.008929Deg-USER_REGION-${year}-v2.0.7cds.nc
file=ESACCI-LC-L4-LCCS-Map-300m-P1Y-aggregated-0.008929Deg-USER_REGION-${year}-v2.1.1.nc
cdo -selvar,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20 ${file} var_${file}

cdo remap,esacci_grid.txt,weigths.nc var_${file} esacci_expfraction_${year}.nc
rm var_${file}
#done

