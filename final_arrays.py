import numpy as np
import xarray as xr
import matplotlib.pyplot as plt
import pandas as pd
from pathos.threading import ThreadPool as Pool

def yearly_arrays(vt,year,sample_size=1000):
    if (vt==1) or (vt==2) or (vt==6) or (vt==9):
        th=format(0.90, ".2f")
    if (vt==3):
        th=format(0.85, ".2f")
    if (vt==4) or (vt==13):
        th=format(0.75, ".2f")
    if (vt==5) or (vt==16) or (vt==17):
        th=format(0.70, ".2f")
        
    th_str = str(th)
    
    fol='/home/vanoorschot/work/fransje/scripts/LAI_FCOVER/fittings/fitting_1km/final'
    f = xr.open_dataset(f'{fol}/fc_lai_data/fc_lai_{year}_unst.nc')
    lc = xr.open_dataset(f'{fol}/esacci_masked/esacci_unst_{vt}_{th}.nc')
    
    lc_ar = lc[f'{vt}']
    n = np.where(~np.isnan(lc_ar))
    
    lat_ar = np.array([])
    lon_ar = np.array([])
    fc_ar = np.array([])
    lai_ar = np.array([])
    for k in range(36):
        n_sel = np.random.choice(n[0],sample_size,replace=False)
        fc_val = f.FCOVER[k,n_sel].values
        lai_val = f.LAI[k,n_sel].values
        lat_val = f.lat[n_sel].values
        lon_val = f.lon[n_sel].values
        fc_ar = np.concatenate([fc_ar, fc_val])
        lai_ar = np.concatenate([lai_ar, lai_val])
        lat_ar = np.concatenate([lat_ar,lat_val])
        lon_ar = np.concatenate([lon_ar,lon_val])

    # remove negative points & NAN points
    a = np.where(fc_ar<0)[0]
    b = np.where(lai_ar<0)[0]
    c = np.where(np.isnan(fc_ar))[0]
    d = np.where(np.isnan(lai_ar))[0]
    ab = np.concatenate([a,b,c,d])
    ab = np.sort(ab)
    ab = np.unique(ab)
    fc_ar = np.delete(fc_ar,ab)
    lai_ar = np.delete(lai_ar,ab)
    lat_ar = np.delete(lat_ar,ab)
    lon_ar = np.delete(lon_ar,ab)
        
    np.save(f'{fol}/output/yearly_arrays/x_{year}_{vt}_{th}.npy',lai_ar)
    np.save(f'{fol}/output/yearly_arrays/y_{year}_{vt}_{th}.npy',fc_ar)
    np.save(f'{fol}/output/yearly_arrays/lat_{year}_{vt}_{th}.npy',lat_ar)
    np.save(f'{fol}/output/yearly_arrays/lon_{year}_{vt}_{th}.npy',lon_ar)
    
# make lists for parallel computation
year_l = [2013,2014,2015,2016,2017,2018,2019]#2006,2007,2008,2009,2010,2011,2012]
# year_list = [1999,2000,2001,2002,2003,2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2014,2015,2016,2017,2018,2019]
vt_l = [1,2,3,4,5,6,9,13,16,17]
vt_list = vt_l * (len(year_l))
year_list = year_l * len(vt_l)
year_list.sort()
print(vt_list)
print(year_list)

#%% run function parallel
def run_function_parallel(vt_list=list,
                          year_list=list,
                          threads=200):
    if threads is None:
        pool = Pool()
    else:
        pool=Pool(nodes=threads)
    results = pool.map(yearly_arrays,
                       vt_list,
                       year_list,
                      )
    return results

# run function parallel -> do this with slurm
run_function_parallel(vt_list,year_list)
