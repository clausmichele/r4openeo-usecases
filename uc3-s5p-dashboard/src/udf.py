from openeo_r_udf.udf_lib import prepare_udf, execute_udf 
from openeo.udf import XarrayDataCube 
r_udf = """ 
udf = function(data, context) {
  n = 31
  filter(t(data), rep(1/n, n))  
  }
""" 
udf_path = prepare_udf(r_udf, '.') 

def apply_datacube(cube: XarrayDataCube, context) -> XarrayDataCube: 
  # You need to change the dimension parameter if you want to reduce the bands dimension! 
  new_cube = execute_udf("apply_dimension", 
  udf_path, 
  cube.get_array(), 
  dimension="t", 
  context = context) 
  return XarrayDataCube(new_cube) 
