from __future__ import print_function

from pyspark.sql import SparkSession
from pyspark.sql.functions import year
from pyspark.sql.types import StringType
from pyspark.sql.types import IntegerType
from pyspark.sql.functions import to_date

spark = SparkSession.builder.appName("Demo Spark Python Cluster Program").getOrCreate()
 
df2 = spark.read.text("hdfs://namenode/user/controller/ncdc-orig/2000-2018.txt")

# https://spark.apache.org/docs/latest/api/python/pyspark.sql.html#pyspark.sql.DataFrame.withColumnRenamed
dfnew = df2.withColumn('Weather Station', df2['value'].substr(5, 6)) \
.withColumn('WBAN', df2['value'].substr(11, 5)) \
.withColumn('Observation Date',to_date(df2['value'].substr(16,8), 'yyyyMMdd')) \
.withColumn('Observation Hour', df2['value'].substr(24, 4).cast(IntegerType())) \
.withColumn('Latitude', df2['value'].substr(29, 6).cast('float') / 1000) \
.withColumn('Longitude', df2['value'].substr(35, 7).cast('float') / 1000) \
.withColumn('Elevation', df2['value'].substr(47, 5).cast(IntegerType())) \
.withColumn('Wind Direction', df2['value'].substr(61, 3).cast(IntegerType())) \
.withColumn('WD Quality Code', df2['value'].substr(64, 1).cast(IntegerType())) \
.withColumn('Sky Ceiling Height', df2['value'].substr(71, 5).cast(IntegerType())) \
.withColumn('SC Quality Code', df2['value'].substr(76, 1).cast(IntegerType())) \
.withColumn('Visibility Distance', df2['value'].substr(79, 6).cast(IntegerType())) \
.withColumn('VD Quality Code', df2['value'].substr(86, 1).cast(IntegerType())) \
.withColumn('Air Temperature', df2['value'].substr(88, 5).cast('float') /10) \
.withColumn('AT Quality Code', df2['value'].substr(93, 1).cast(IntegerType())) \
.withColumn('Dew Point', df2['value'].substr(94, 5).cast('float')) \
.withColumn('DP Quality Code', df2['value'].substr(99, 1).cast(IntegerType())) \
.withColumn('Atmospheric Pressure', df2['value'].substr(100, 5).cast('float')/ 10) \
.withColumn('AP Quality Code', df2['value'].substr(105, 1).cast(IntegerType())) \
.filter(year(to_date(df2['value'].substr(16,8),'yyyyMMdd')).cast(StringType()) == '2009') \
.drop('value')

dfnew.write.format("parquet").mode("overwrite").save("hdfs://namenode/output/dpj/2009.parquet")
dfnew.write.format("csv").mode("overwrite").save("hdfs://namenode/output/dpj/2009.csv")