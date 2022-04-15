#!/bin/bash

cd fc_lai_data/

for year in {1999..2019}
#for year in 2019
do
cdo -setgridtype,unstructured fc_lai_${year}_1km.nc fc_lai_${year}_unst.nc
echo $year
done
