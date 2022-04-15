import xarray as xr
import numpy as np
from pathos.threading import ThreadPool as Pool

fol = '/home/vanoorschot/work/fransje/DATA/CONFESS/lc-user-tools-4.3/output/final_output/'
t = xr.open_dataset('/home/vanoorschot/work/fransje/DATA/CONFESS/esacci_lc_ifs_explicit_fraction.nc')
s = t.vtypefr[0,:,:].to_dataframe()

def shift_latlon_esa(vt,year,s=s):
    fol = '/home/vanoorschot/work/fransje/DATA/CONFESS/lc-user-tools-4.3/output/final_output/'
    if (year== 2016) or (year== 2017) or (year== 2018) or (year== 2019):
        e = xr.open_dataset(f'{fol}/ESACCI-LC-L4-LCCS-Map-300m-P1Y-aggregated-0.008929Deg-USER_REGION-{year}-v2.1.1.nc')
    else:
        e = xr.open_dataset(f'{fol}/ESACCI-LC-L4-LCCS-Map-300m-P1Y-aggregated-0.008929Deg-USER_REGION-{year}-v2.0.7cds.nc')
    f = e[f'{vt}'] #select vegetation type
    d = f.to_dataframe() #xarray to dataframe
   
    d.index = s.index  #change index to index of target grid
    dx = d.to_xarray() 
    dx.to_netcdf(f'{fol}/shifted_output/esacci_{year}_{vt}_shifted.nc')
    
#%% run function parallel
def run_function_parallel(vt_list=list,
                          year_list=list,
                          threads=200):
    if threads is None:
        pool = Pool()
    else:
        pool=Pool(nodes=threads)
    results = pool.map(shift_latlon_esa,
                       vt_list,
                       year_list,
                      )
    return results


# make lists for parallel computation
year_l = [2016,2017,2018]
vt_l = [1,2,3,4,5,6,9,13,16,17]
vt_list = vt_l * (len(year_l))
year_list = year_l * len(vt_l)
year_list.sort()
print(vt_list)
print(year_list)

run_function_parallel(vt_list,year_list)
