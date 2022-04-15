#!/bin/bash

# Fransje september 2021
# Apply cdf-matching to FCOVER and FCOVER datasets from copernicus
# Method described in deliverable1 WP1 by Souhail


## FCOVER DATA
folder=~/work/fransje/DATA/FCOVER_COPERNICUS/ncfiles

# get all SPOT files 1999-2013
fc_1999=$folder/1999/mergetime_fcover_1999.nc
fc_2000=$folder/2000/mergetime_fcover_2000.nc
fc_2001=$folder/2001/mergetime_fcover_2001.nc
fc_2002=$folder/2002/mergetime_fcover_2002.nc
fc_2003=$folder/2003/mergetime_fcover_2003.nc
fc_2004=$folder/2004/mergetime_fcover_2004.nc
fc_2005=$folder/2005/mergetime_fcover_2005.nc
fc_2006=$folder/2006/mergetime_fcover_2006.nc
fc_2007=$folder/2007/mergetime_fcover_2007.nc
fc_2008=$folder/2008/mergetime_fcover_2008.nc
fc_2009=$folder/2009/mergetime_fcover_2009.nc
fc_2010=$folder/2010/mergetime_fcover_2010.nc
fc_2011=$folder/2011/mergetime_fcover_2011.nc
fc_2012=$folder/2012/mergetime_fcover_2012.nc
fc_2013=$folder/2013/mergetime_fcover_2013.nc

# get all PROBAV files 2014-2019
fc_2014=$folder/2014/mergetime_fcover_2014.nc
fc_2015=$folder/2015/mergetime_fcover_2015.nc
fc_2016=$folder/2016/mergetime_fcover_2016.nc
fc_2017=$folder/2017/mergetime_fcover_2017.nc
fc_2018=$folder/2018/mergetime_fcover_2018.nc
fc_2019=$folder/2019/mergetime_fcover_2019.nc

## mergetime PROBAV - mean PROBAV - std PROBAV
cdo mergetime $fc_2014 $fc_2015 $fc_2016 $fc_2017 $fc_2018 $fc_2019 fc_mergetime_probav_2014_2019.nc
cdo timmean fc_mergetime_probav_2014_2019.nc fc_mergetime_probav_2014_2019_mean.nc
cdo timstd fc_mergetime_probav_2014_2019.nc fc_mergetime_probav_2014_2019_std.nc
## mergetime SPOT - mean SPOT - std SPOT
cdo mergetime $fc_1999 $fc_2000 $fc_2001 $fc_2002 $fc_2003 $fc_2004 $fc_2005 $fc_2006 $fc_2007 $fc_2008 $fc_2009 $fc_2010 $fc_2011 $fc_2012 $fc_2013 fc_mergetime_spot_1999_2013.nc
cdo timmean fc_mergetime_spot_1999_2013.nc fc_mergetime_spot_1999_2013_mean.nc
cdo timstd fc_mergetime_spot_1999_2013.nc fc_mergetime_spot_1999_2013_std.nc
# select only fc-data and change datatype to f32
cdo -b f32 -select,name=FCOVER fc_mergetime_probav_2014_2019.nc fc_mergetime_probav_2014_2019_sel.nc
cdo -b f32 -select,name=FCOVER fc_mergetime_probav_2014_2019_mean.nc fc_mergetime_probav_2014_2019_mean_sel.nc
cdo -b f32 -select,name=FCOVER fc_mergetime_probav_2014_2019_std.nc fc_mergetime_probav_2014_2019_std_sel.nc
#cdo -b f32 -select,name=FCOVER fc_mergetime_spot_1999_2013.nc fc_mergetime_spot_1999_2013_sel.nc
cdo -b f32 -select,name=FCOVER fc_mergetime_spot_1999_2013_mean.nc fc_mergetime_spot_1999_2013_mean_sel.nc
cdo -b f32 -select,name=FCOVER fc_mergetime_spot_1999_2013_std.nc fc_mergetime_spot_1999_2013_std_sel.nc

# calculate alpha parameter (std-spot/std-probav)
sfile_fit=fc_mergetime_probav_2014_2019_std_sel.nc
sfile_ref=fc_mergetime_spot_1999_2013_std_sel.nc

cdo div $sfile_ref $sfile_fit fc_alpha.nc
alpha=fc_alpha.nc

## process the files
mfile_fit=fc_mergetime_probav_2014_2019_mean_sel.nc
mfile_ref=fc_mergetime_spot_1999_2013_mean_sel.nc

for year in 2014 2015 2016 2016 2017 2018 2019
do
cdo -L -b f32 -f nc4 -setctomiss,255 -setmissval,255 -selvar,FCOVER $folder/$year/mergetime_fcover_$year.nc tmp0_$year.nc
cdo sub tmp0_$year.nc $mfile_fit tmp1_$year.nc #original-mean_original
cdo mul $alpha tmp1_$year.nc tmp2_$year.nc #alpha*(original-mean_original)
cdo add $mfile_ref tmp2_$year.nc fc_outfile_$year #alpha*(original-mean_original)+mean_ref
done





