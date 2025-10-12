import pandas as pd
import numpy as np

class FileValidator:
  def __init__(self, df, metadata):
    self.df = df
    self.metadata = metadata
  
  def validate_all_mandatory_columns_exist(self):
    not_found_columns = []
    mandatory_columns = [column["name"] for column in self.metadata['columns']]
    for column in mandatory_columns:
      if column not in self.df.columns:
        not_found_columns.append(column)

    if len(not_found_columns) > 0:
      print(f"\n\nMandatory columns {not_found_columns} not found on source file.\n\n")
    
    return not_found_columns
  
  def remove_extra_columns(self, df):
    extra_columns = [column for column in df.columns if column not in [column["name"] for column in self.metadata['columns']]]
    return df.drop(extra_columns, axis=1)
  
  def validate_data_types(self, df):
    """
    Force dataframe columns to expected types from self.columns_validations.
    Return a list of columns with conversion errors.
    """
    type_map = {
      "text": "object",
      "object": "object",
      "date": "datetime64[ns]",
      "datetime": "datetime64[ns]",
      "int": "Int64",
      "float": "float64"
    }
    conversion_errors = []
    for column in self.metadata['columns']:
      column_name = column["name"]
      if column_name not in df.columns:
        continue
      
      column_type = column.get("type", None)
      if column_type == None:
        conversion_errors.append({"column": column_name, "expected": "have data type", "actual": "not configured data type on YAML metadata"})
        continue

      expected_type = type_map.get(column_type.lower(), None)
      if expected_type is None:
        conversion_errors.append({"column": column_name, "expected": "", "actual": f"df column type is {str(df[column_name].dtype)} but the data type on YAML metadata not exists on {__file__} script (type: {column_type})"})
        continue

      if expected_type == "datetime64[ns]":
        df[column_name] = pd.to_datetime(df[column_name], errors="coerce")
      elif expected_type == "Int64":
        df[column_name] = pd.to_numeric(df[column_name], errors="coerce").astype("Int64")
        pass
      elif expected_type == "float64":
        df[column_name] = pd.to_numeric(df[column_name], errors="coerce").astype('float64')
      elif expected_type == "object":
        df[column_name] = df[column_name].astype(str)
        df[column_name] = df[column_name].replace('nan', np.nan)
      
      # Check if conversion succeeded
      if expected_type and (str(df[column_name].dtype) != expected_type):
        conversion_errors.append({"column": column_name, "expected": expected_type, "actual": str(df[column_name].dtype)})
    
    return conversion_errors
