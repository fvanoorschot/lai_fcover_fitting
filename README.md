# lai_fcover_fitting

# requirements:
- cdo
- python environment from https://ewatercycle.readthedocs.io/en/latest/system_setup.html#conda-environment

# steps taken:
1. downloading fcover and lai data
- https://land.copernicus.eu/global/products/lai
- https://land.copernicus.eu/global/products/fcover
- download 1km data via product portal (copernicus account is required)

2. cdf matching
- Need to scale the 2014-2019 LAI and FC data because of changed sensor and non consistent results using cdf-matching based on 1999-2013 period
- cdf_matching_final.sh for LAI and cdf_matching_final_fc.sh for FCOVER

3. esacci explicit vegetation fraction
- data: https://cds.climate.copernicus.eu/cdsapp#!/dataset/satellite-land-cover?tab=form + cross walking table (BATS_LCCS2PFT_LUT_v4_fransje.csv)
- tool: http://maps.elie.ucl.ac.be/CCI/viewer/download.php user tool 4.3
- aggregate-map script: aggregate-map.sh
- run script: run_esacci_gen.sh
- post process: esacci_explicit_postprocessing.sh
- shift grid: shift_esacci_grid.py

4. fitting 
- create unstructured grids: fc_lai_unstructured.sh
- mask esacci to vegtype and threshold and make unstructurd: mask_esacci.sh
- make python arrays per year for lai and fc based on esacci mask: final_arrays.py
- run fitting and make plots: run_fitting.ipynb

final arrays stored in fitting_1km_output.tar.gz, 1km LAI,FCover and ESA-CCI files saved on tintin (too large to transfer).