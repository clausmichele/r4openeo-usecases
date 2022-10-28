from openeo_r_udf.udf_lib import prepare_udf, execute_udf, save_result
import time
import xarray as xr

## This script is mimicking what the backend would be doing when running an UDF ##

# activate the environment openeo-r-udf


# config
load_file = "../r4openeo_uc2_ndvi_mskd_small.nc"
save_file = "result_bfast_udf_small.nc"

udf_file


# load and prepare data
dataset = xr.load_dataset(load_file)
dataset = dataset.drop('transverse_mercator') # ('crs')
data = dataset.to_array(dim = 'var')
data = data.squeeze('var')
data = data.drop('var')
data['t'] = data.t.astype('str')

# define runer for udf
def run(process, udf, dimension = None, context = None):
    # Run UDF executor
    t1 = time.time() # Start benchmark
    print('start: ', udf) #t1
    result = execute_udf(process, udf, data, dimension = dimension, context = context, parallelize = parallelize, chunk_size = chunk_size)
    t2 = time.time() # End benchmark
    print('end: ', udf) #t2

    # Print result and benchmark
    print('  Time elapsed: %s' % (t2 - t1))
    save_result(result, save_file)

print('reduce_dimension bfast')
run('reduce_dimension', './udfs/reduce_bfast.R', dimension = 't', context = {'start_monitor': 2018})
