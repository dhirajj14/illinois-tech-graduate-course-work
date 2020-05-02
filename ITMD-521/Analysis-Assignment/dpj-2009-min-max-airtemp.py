from __future__ import print_function

from pyspark.sql import SparkSession
from pyspark.sql.functions import year
from pyspark.sql.types import StringType
from pyspark.sql.types import IntegerType
from pyspark.sql.functions import to_date
from pyspark.sql.types import FloatType
from pyspark.sql.functions import min, max


spark = SparkSession.builder.appName("Demo Spark Python Cluster Program").getOrCreate()
 
dfnew = spark.read.format("csv").option("inferSchema","true").option("header","false").load("hdfs://namenode/output/itmd-521/dpj/2009.csv").toDF('Weather_Station', 'WBAN', 'Observation_Date', 'Observation_Hour', 'Latitude', 'Longitude', 'Elevation', 'Wind_Direction', 'WD_Quality_Code', 'Sky_Ceiling_Height', 'SC_Quality_Code', 'Visibility_Distance', 'VD_Quality_Code', 'Air_Temperature', 'AT_Quality_Code', 'Dew_Point', 'DP_Quality_Code', 'Atmospheric_Pressure', 'AP_Quality_Code')

drange = dfnew.filter(dfnew['Air_Temperature'].between(-10.0, 11.5))

df = drange.groupBy(month(drange['Observation_Date']).alias('Month_Number')).agg(min(drange['Air_Temperature']*10).alias('Minimum_Temperature'), max(drange['Air_Temperature']*10).alias('Max_Temperature'))

print(df.show())

df.write.format("csv").mode("overwrite").save("hdfs://namenode/output/itmd-521/dpj/dpj-2009-min-max-airtemp.csv")



