#from udf_lib import execute_udf, create_dummy_cube
from openeo_r_udf.udf_lib import prepare_udf, execute_udf
import pandas as pd
import time
import xarray as xr
import numpy as np


testfile = "./models/testing.nc"

dataset = xr.open_dataset(testfile)
dataset = dataset.drop('transverse_mercator') # ('crs')
data = dataset.to_array(dim = 'var')
data = data.transpose('x','y','var')
#data = data[0:18,0:18]


def run(process, udf, dimension = None, context = None):
    # Prepare data
    print(type(data))
    #data = create_dummy_cube(dims, sizes, labels)

    # Run UDF executor
    t1 = time.time() # Start benchmark
    #result = execute_udf(process, udf, data, dimension = dimension, context = context, parallelize = parallelize, chunk_size = chunk_size)
    result = execute_udf(process, udf, data, dimension = dimension, context = context)
    t2 = time.time() # End benchmark


    # Print result and benchmark
    print('  Time elapsed: %s' % (t2 - t1))


print('apply model')
run('reduce_dimension','./udfs/reduce_udf_chunk.R', dimension = 'var', context=1)
