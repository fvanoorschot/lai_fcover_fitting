#!/bin/bash

# Fransje september 2021
# Apply cdf-matching to LAI and FCOVER datasets from copernicus
# Method described in deliverable1 WP1 by Souhail


## LAI DATA
folder=~/work/fransje/DATA/LAI_COPERNICUS/nc_files

# get all SPOT files 1999-2013
lai_1999=$folder/1999/mergetime_lai_1999.nc
lai_2000=$folder/2000/mergetime_lai_2000.nc
lai_2001=$folder/2001/mergetime_lai_2001.nc
lai_2002=$folder/2002/mergetime_lai_2002.nc
lai_2003=$folder/2003/mergetime_lai_2003.nc
lai_2004=$folder/2004/mergetime_lai_2004.nc
lai_2005=$folder/2005/mergetime_lai_2005.nc
lai_2006=$folder/2006/mergetime_lai_2006.nc
lai_2007=$folder/2007/mergetime_lai_2007.nc
lai_2008=$folder/2008/mergetime_lai_2008.nc
lai_2009=$folder/2009/mergetime_lai_2009.nc
lai_2010=$folder/2010/mergetime_lai_2010.nc
lai_2011=$folder/2011/mergetime_lai_2011.nc
lai_2012=$folder/2012/mergetime_lai_2012.nc
lai_2013=$folder/2013/mergetime_lai_2013.nc

# get all PROBAV files 2014-2019
lai_2014=$folder/2014/mergetime_lai_2014.nc
lai_2015=$folder/2015/mergetime_lai_2015.nc
lai_2016=$folder/2016/mergetime_lai_2016.nc
lai_2017=$folder/2017/mergetime_lai_2017.nc
lai_2018=$folder/2018/mergetime_lai_2018.nc
lai_2019=$folder/2019/mergetime_lai_2019.nc

## mergetime PROBAV - mean PROBAV - std PROBAV
cdo mergetime $lai_2014 $lai_2015 $lai_2016 $lai_2017 $lai_2018 $lai_2019 lai_mergetime_probav_2014_2019.nc
cdo -b f32 -select,name=LAI lai_mergetime_probav_2014_2019.nc lai_mergetime_probav_2014_2019_sel.nc
cdo timmean lai_mergetime_probav_2014_2019_sel.nc lai_mergetime_probav_2014_2019_mean_sel.nc
cdo timstd lai_mergetime_probav_2014_2019_sel.nc lai_mergetime_probav_2014_2019_std_sel.nc

# mergetime SPOT - mean SPOT - std SPOT
cdo mergetime $lai_1999 $lai_2000 $lai_2001 $lai_2002 $lai_2003 $lai_2004 $lai_2005 $lai_2006 $lai_2007 $lai_2008 $lai_2009 $lai_2010 $lai_2011 $lai_2012 $lai_2013 lai_mergetime_spot_1999_2013.nc
cdo -b f32 -select,name=LAI lai_mergetime_spot_1999_2013.nc lai_mergetime_spot_1999_2013_sel.nc
cdo timmean lai_mergetime_spot_1999_2013_sel.nc lai_mergetime_spot_1999_2013_mean_sel.nc
cdo timstd lai_mergetime_spot_1999_2013_sel.nc lai_mergetime_spot_1999_2013_std_sel.nc

## select only lai-data and change datatype to f32
cdo -b f32 -select,name=LAI lai_mergetime_probav_2014_2019.nc lai_mergetime_probav_2014_2019_sel.nc
cdo -b f32 -select,name=LAI lai_mergetime_probav_2014_2019_mean.nc lai_mergetime_probav_2014_2019_mean_sel.nc
cdo -b f32 -select,name=LAI lai_mergetime_probav_2014_2019_std.nc lai_mergetime_probav_2014_2019_std_sel.nc

cdo -b f32 -select,name=LAI lai_mergetime_spot_1999_2013.nc lai_mergetime_spot_1999_2013_sel.nc
cdo -b f32 -select,name=LAI lai_mergetime_spot_1999_2013_mean.nc lai_mergetime_spot_1999_2013_mean_sel.nc
cdo -b f32 -select,name=LAI lai_mergetime_spot_1999_2013_std.nc lai_mergetime_spot_1999_2013_std_sel.nc

## calculate alpha parameter (std-spot/std-probav)
sfile_fit=lai_mergetime_probav_2014_2019_std_sel.nc
sfile_ref=lai_mergetime_spot_1999_2013_std_sel.nc

cdo div $sfile_ref $sfile_fit lai_alpha.nc
alpha=lai_alpha.nc

## process the files
mfile_fit=lai_mergetime_probav_2014_2019_mean_sel.nc
mfile_ref=lai_mergetime_spot_1999_2013_mean_sel.nc

for year in 2014 2015 2016 2016 2017 2018 2019
do
cdo -L -b f32 -f nc4 -setctomiss,255 -setmissval,255 -selvar,LAI $folder/$year/mergetime_lai_$year.nc tmp0_$year.nc
cdo sub tmp0_$year.nc $mfile_fit tmp1_$year.nc #original-mean_original
cdo mul $alpha tmp1_$year.nc tmp2_$year.nc #alpha*(original-mean_original)
cdo add $mfile_ref tmp2_$year.nc lai_outfile_$year.nc #alpha*(original-mean_original)+mean_ref
done





