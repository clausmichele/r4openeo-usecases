from openeo_r_udf.udf_lib import prepare_udf, execute_udf
import time
import xarray as xr


testfile = "./models/testing.nc"

dataset = xr.open_dataset(testfile)
dataset = dataset.drop('transverse_mercator') # ('crs')
data = dataset.to_array(dim = 'var')
data = data.transpose('x','y','var')


def run(process, udf, dimension = None, context = None):

    # Run UDF executor
    t1 = time.time() # Start benchmark
    result = execute_udf(process, udf, data, dimension = dimension, context = context)
    t2 = time.time() # End benchmark


    # Print result and benchmark
    print('  Time elapsed: %s' % (t2 - t1))


print('apply model')
run('reduce_dimension','./udfs/reduce_udf.R', dimension = 'var', context=1)
