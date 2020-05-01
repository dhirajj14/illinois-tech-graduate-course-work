from __future__ import print_function

from pyspark.sql import SparkSession


spark = SparkSession.builder.appName("Demo Spark Python Cluster Program").getOrCreate()
 
df2 = spark.read.format("parquet").option("inferSchema","true").option("header","true").load("hdfs://namenode/output/itmd-521/dpj/2009.parquet")

# https://spark.apache.org/docs/latest/api/python/pyspark.sql.html#pyspark.sql.DataFrame.withColumnRenamed
dfnew = df2.filter(df2['Air_Temperature'] != 999.9)

print(dfnew.show(15))

dfnew.write.format("parquet").mode("overwrite").save("hdfs://namenode/output/itmd-521/dpj/dpj-2009-valid-records-temp.parquet")

