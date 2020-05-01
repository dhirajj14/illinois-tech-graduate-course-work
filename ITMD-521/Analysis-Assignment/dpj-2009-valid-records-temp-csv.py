from __future__ import print_function

from pyspark.sql import SparkSession


spark = SparkSession.builder.appName("Demo Spark Python Cluster Program").getOrCreate()

columns = ['Weather_Station', 'WBAN', 'Observation_Date', 'Observation_Hour', 'Latitude', 'Longitude', 'Elevation', 'Wind_Direction', 'WD_Quality_Code', 'Sky_Ceiling_Height', 'SC_Quality_Code', 'Visibility_Distance', 'VD_Quality_Code', 'Air_Temperature', 'AT_Quality_Code', 'Dew_Point', 'DP_Quality_Code', 'AP_Quality_Code']

df2 = spark.read.format("csv").option("inferSchema","true").option("header","false").load("hdfs://namenode/output/itmd-521/dpj/2009.csv").toDF(columns)

# https://spark.apache.org/docs/latest/api/python/pyspark.sql.html#pyspark.sql.DataFrame.withColumnRenamed
dfnew = df2.filter(df2['Air_Temperature'] != 999.9)

print(dfnew.show(15))

dfnew.write.format("csv").mode("overwrite").save("hdfs://namenode/output/itmd-521/dpj/dpj-2009-valid-records-temp.csv")

