from openeo_r_udf.udf_lib import prepare_udf, execute_udf
import time
import xarray as xr


testfile = "/home/btufail@eurac.edu/git_projects/r4openeo-usecases/uc1-ml-landcover/test_data/data/test_site.nc"

data = xr.open_dataarray(testfile)
#data = data[dict(x=slice(0, 100))]
#data = data[dict(y=slice(0, 100))]
#data = data.drop('transverse_mercator') # ('crs')
#data = data.to_array(dim = 'var')
#data = data.transpose('x','y','var')


def run(process, udf, dimension = None, context = None):

    # Run UDF executor
    t1 = time.time() # Start benchmark
    result = execute_udf(process, udf, data, dimension = dimension, context = context)
    t2 = time.time() # End benchmark
    #print(result)

    # Print result and benchmark
    print('  Time elapsed: %s' % (t2 - t1))
    #result.to_netcdf("/home/btufail@eurac.edu/git_projects/r4openeo-usecases/uc1-ml-landcover/test_data/udf_local/udf_local/result_local_udf.nc")



print('apply model')
run('reduce_dimension','/home/btufail@eurac.edu/git_projects/r4openeo-usecases/uc1-ml-landcover/test_data/udf/reduce_udf.R', dimension = 'variable', context=1)
