from __future__ import print_function

from pyspark.sql import SparkSession
from pyspark.sql.functions import month

spark = SparkSession.builder.appName("Demo Spark Python Cluster Program").getOrCreate()


df2 = spark.read.format("csv").option("inferSchema","true").option("header","false").load("hdfs://namenode/output/itmd-521/dpj/2009.csv").toDF('Weather_Station', 'WBAN', 'Observation_Date', 'Observation_Hour', 'Latitude', 'Longitude', 'Elevation', 'Wind_Direction', 'WD_Quality_Code', 'Sky_Ceiling_Height', 'SC_Quality_Code', 'Visibility_Distance', 'VD_Quality_Code', 'Air_Temperature', 'AT_Quality_Code', 'Dew_Point', 'DP_Quality_Code', 'Atmospheric_Pressure', 'AP_Quality_Code')

dfnew = dfnew.withColumn('Month', month(df2['Observation_Date']))

dfnew.write.partitionBy("Month").format("parquet").mode("overwrite").save("hdfs://namenode/output/itmd-521/dpj/dpj-2009-partitionby.parquet")
