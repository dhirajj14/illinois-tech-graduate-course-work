from __future__ import print_function

from pyspark.sql import SparkSession
from pyspark.sql.functions import year
from pyspark.sql.types import StringType
from pyspark.sql.types import IntegerType
from pyspark.sql.functions import to_date
from pyspark.sql.types import FloatType

spark = SparkSession.builder.appName("Demo Spark Python Cluster Program").getOrCreate()
 
df2 = spark.read.text("hdfs://namenode/output/itmd-521/dpj/2009.csv")

# https://spark.apache.org/docs/latest/api/python/pyspark.sql.html#pyspark.sql.DataFrame.withColumnRenamed
dfnew = df2.filter(df2['Air_Temperature'] != 999.9)

print(dfnew.show(15))

dfnew.write.format("csv").mode("overwrite").save("hdfs://namenode/output/itmd-521/dpj/dpj-2009-valid-records-temp.csv")


