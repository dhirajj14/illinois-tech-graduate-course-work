from __future__ import print_function

from pyspark.sql import SparkSession

spark = SparkSession.builder.appName("Demo Spark Python Cluster Program").getOrCreate()
 
df2 = spark.read.format("csv").option("inferSchema","true").repartition(200).option("header","false").load("hdfs://namenode/output/itmd-521/dpj/dpj-2009-partition-two-hundred.csv").toDF('Weather_Station', 'WBAN', 'Observation_Date', 'Observation_Hour', 'Latitude', 'Longitude', 'Elevation', 'Wind_Direction', 'WD_Quality_Code', 'Sky_Ceiling_Height', 'SC_Quality_Code', 'Visibility_Distance', 'VD_Quality_Code', 'Air_Temperature', 'AT_Quality_Code', 'Dew_Point', 'DP_Quality_Code', 'Atmospheric_Pressure', 'AP_Quality_Code')

df2.write.format("csv").option("compression","lz4").mode("overwrite").save("hdfs://namenode/output/itmd-521/dpj/dpj-2009-partition-two-hundred-read.csv")
