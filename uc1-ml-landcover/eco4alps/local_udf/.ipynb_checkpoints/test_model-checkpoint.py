from openeo_r_udf.udf_lib import prepare_udf, execute_udf
import time
import xarray as xr


testfile = "/home/btufail@eurac.edu/git_projects/r4openeo-usecases/uc1-ml-landcover/eco4alps/data/result (14).nc"

data = xr.open_dataarray(testfile)
# dataset = dataset[dict(x=slice(0, 100))]
# data = dataset[dict(y=slice(0, 100))]
#dataset = dataset.drop('transverse_mercator') # ('crs')
#data = dataset.to_array(dim = 'var')
#data = dataset.transpose('x','y','variable')


def run(process, udf, dimension = None, context = None):

    # Run UDF executor
    t1 = time.time() # Start benchmark
    result = execute_udf(process, udf, data, dimension = dimension, context = context)
    t2 = time.time() # End benchmark

    result.to_netcdf("/home/btufail@eurac.edu/git_projects/r4openeo-usecases/uc1-ml-landcover/eco4alps/local_udf/Eco4Alps_result1.nc")

    # Print result and benchmark
    print('  Time elapsed: %s' % (t2 - t1))


print('apply model')
run('reduce_dimension','/home/btufail@eurac.edu/git_projects/r4openeo-usecases/uc1-ml-landcover/eco4alps/udf/reduce_udf_chunk_eco4alps.R', dimension = 'variable', context=1)
