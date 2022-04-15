#!/bin/bash

fol=~/work/fransje/scripts/LAI_FCOVER/fittings/fitting_1km
fol_lc=~/work/fransje/DATA/CONFESS/lc-user-tools-4.3/output/final_output/shifted_output/final
#mkdir -p $fol/final/tmp
tmp_dir=$fol/final/tmp

for year in {1999..2019}
do
fc_lai=$fol/final/fc_lai_data/fc_lai_${year}_1km.nc
lc=$fol_lc/esacci_${year}_shifted_grid.nc

#th=0.90
#th=0.85
#th=0.75
th=0.70

#for vt in 1 2 6 9 #th=0.90
#for vt in 3 #th=0.85
#for vt in 4 13 #th=0.75
for vt in 5 16 17 #th=0.70
do

#select vegtype
cdo -selname,$vt $lc $tmp_dir/exp_frac_$vt.nc

#mask threshold (greather and equal to)
cdo -gec,$th $tmp_dir/exp_frac_${vt}.nc $tmp_dir/mask_${vt}_${th}.nc
cdo -setctomiss,0 $tmp_dir/mask_${vt}_${th}.nc $tmp_dir/mask2_${vt}_${th}.nc #set all zero values to missing
cdo -setgridtype,unstructured $tmp_dir/mask2_${vt}_${th}.nc $fol/final/esacci_masked/esacci_${year}_unst_${vt}_${th}.nc

echo $vt

done
done

