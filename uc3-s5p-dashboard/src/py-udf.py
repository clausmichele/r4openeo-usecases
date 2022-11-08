from pandas import Series
import numpy as np

def apply_timeseries(series: Series, context: dict) -> Series:
  return np.convolve(series, np.ones(31)/31, mode='same')
