#!/bin/bash
module load java/jre8
#module load java
#module load netcdf4
#add this on ecgate
#export LD_LIBRARY_PATH=$NETCDF_DIR/lib:$LD_LIBRARY_PATH

base=~/work/fransje/DATA/CONFESS/lc-user-tools-4.3/
output=~/work/fransje/DATA/CONFESS/lc-user-tools-4.3/output
data_dir=~/work/fransje/DATA/CONFESS/ESACCI-LC


for year in {2016..2019}
do
#ESACCI_FILE="ESACCI-LC-L4-LCCS-Map-300m-P1Y-$year-v2.0.7cds.nc"

ESACCI_FILE="C3S-LC-L4-LCCS-Map-300m-P1Y-${year}-v2.1.1.nc"
${base}/bin/aggregate-map.sh -PgridName=GEOGRAPHIC_LAT_LON -PnumRows=20160 -PoutputLCCSClasses=false -PnumMajorityClasses=20 -PoutputPFTClasses=true -PuserPFTConversionTable="${base}/resources/BATS_LCCS2PFT_LUT_v4_fransje.csv" -Pnorth=80 -Peast=180 -Psouth=-59.9866 -Pwest=-180 -PtargetDir=""${base}/output/final_output/" ""${data_dir}/${ESACCI_FILE}"

rm -rf /work/users/vanoorschot/snap-vanoorschot
rm -rf /work/users/vanoorschot/jna--*
done


