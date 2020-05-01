from __future__ import print_function

from pyspark.sql import SparkSession
from pyspark.sql.functions import year
from pyspark.sql.types import StringType
from pyspark.sql.types import IntegerType
from pyspark.sql.functions import to_date
from pyspark.sql.types import FloatType

spark = SparkSession.builder.appName("Demo Spark Python Cluster Program").getOrCreate()
 
df2 = spark.read.format("csv").option("inferSchema","true").option("header","false").load("hdfs://namenode/output/itmd-521/dpj/2009.csv").toDF('Weather_Station', 'WBAN', 'Observation_Date', 'Observation_Hour', 'Latitude', 'Longitude', 'Elevation', 'Wind_Direction', 'WD_Quality_Code', 'Sky_Ceiling_Height', 'SC_Quality_Code', 'Visibility_Distance', 'VD_Quality_Code', 'Air_Temperature', 'AT_Quality_Code', 'Dew_Point', 'DP_Quality_Code', 'Atmospheric_Pressure', 'AP_Quality_Code')

totalCount = float(df2.count())

badCount = float(df2.filter(df2['Atmospheric_Pressure'] == 9999.9).count())

percentage = round((badCount/totalCount)*100, 2)

dfStats = spark.createDataFrame([(totalCount,badCount,percentage)], ['Total_Record_Count', 'Bad_Record_Count','Percentage_(bad/total)*100'])

print(dfStats.show())

dfStats.write.format("csv").mode("overwrite").save("hdfs://namenode/output/itmd-521/dpj/dpj-2009-valid-records-count-press.csv")


