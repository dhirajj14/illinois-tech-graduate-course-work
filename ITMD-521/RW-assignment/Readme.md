# ITMD-521 Read & Write Assignment

# Question 1:

# pySpark Functions:

## 1. Year()

```bash
from pyspark.sql.functions import year
```
### Explanation

This function is used to get the year from the date. This function can be used on col which is of type date to extract the year from it.

https://spark.apache.org/docs/latest/api/python/pyspark.sql.html#pyspark.sql.functions.year

## 2. to_date(col, format)   

```bash
from pyspark.sql.functions import to_date
```
### Explanation

This function is used to convert the StringType or timeStamp type into the pySpark DateType. This function can be used on col which is of type type string to extract the date from it. to_date function accepts two arguments column and the format of the date.

https://spark.apache.org/docs/latest/api/python/pyspark.sql.html#pyspark.sql.functions.to_date


# pySpark Class Types:

## 1. StringType
```bash
from pyspark.sql.types import StringType
```
### Explanation
StringType is the string data type. In this assignment it is used to casting in to string type.

https://spark.apache.org/docs/latest/api/python/pyspark.sql.html#pyspark.sql.types.StringType

## 2. IntergerType
```bash
from pyspark.sql.types import IntegerType
```
### Your Explanation

This is Int data type, i.e. a signed 32-bit integer. In this assignment it is used to casting in to integer type.

https://spark.apache.org/docs/latest/api/python/pyspark.sql.html#pyspark.sql.types.IntegerType

# Code Explaination

## Read Text 
```bash
df2 = spark.read.text("hdfs://namenode/user/controller/ncdc-orig/2000-2018.txt")
```

The above code will read the my assigned file 2000-2018.txt from the server and store it in dataframe df2.

## Parsing the Dataframe
```bash
dfnew = df2.withColumn('Weather_Station', df2['value'].substr(5, 6)) \
.withColumn('WBAN', df2['value'].substr(11, 5)) \
.withColumn('Observation_Date',to_date(df2['value'].substr(16,8), 'yyyyMMdd')) \
.withColumn('Observation_Hour', df2['value'].substr(24, 4).cast(IntegerType())) \
.withColumn('Latitude', df2['value'].substr(29, 6).cast('float') / 1000) \
.withColumn('Longitude', df2['value'].substr(35, 7).cast('float') / 1000) \
.withColumn('Elevation', df2['value'].substr(47, 5).cast(IntegerType())) \
.withColumn('Wind_Direction', df2['value'].substr(61, 3).cast(IntegerType())) \
.withColumn('WD_Quality_Code', df2['value'].substr(64, 1).cast(IntegerType())) \
.withColumn('Sky_Ceiling_Height', df2['value'].substr(71, 5).cast(IntegerType())) \
.withColumn('SC_Quality_Code', df2['value'].substr(76, 1).cast(IntegerType())) \
.withColumn('Visibility_Distance', df2['value'].substr(79, 6).cast(IntegerType())) \
.withColumn('VD_Quality_Code', df2['value'].substr(86, 1).cast(IntegerType())) \
.withColumn('Air_Temperature', df2['value'].substr(88, 5).cast('float') /10) \
.withColumn('AT_Quality_Code', df2['value'].substr(93, 1).cast(IntegerType())) \
.withColumn('Dew_Point', df2['value'].substr(94, 5).cast('float')) \
.withColumn('DP_Quality_Code', df2['value'].substr(99, 1).cast(IntegerType())) \
.withColumn('Atmospheric_Pressure', df2['value'].substr(100, 5).cast('float')/ 10) \
.withColumn('AP_Quality_Code', df2['value'].substr(105, 1).cast(IntegerType())) \
.filter(year(to_date(df2['value'].substr(16,8),'yyyyMMdd')).cast(StringType()) == '2009') \
.drop('value')
```
This code will parse the dataframe df2 into diffrent columns in dataframe df2.

> **_Problem faced and solved:_** While using the code provided by professor for my case it was giving error of blank spaces. The logs gave me the solution of using alias function but instead of that I changed the column names. 
e.g. 'Weather Station' --> 'Weather_Station'. This solved the problem.

## Filter dataframe according to year assigned i.e 2009

```bash
.filter(year(to_date(df2['value'].substr(16,8),'yyyyMMdd')).cast(StringType()) == '2009') \
```
### Explaination
* For filtering the data according to year I am using the filter function. 
* In filter function I am taking the year from the date which is obtained using to_date function. 
* Then on this date I am applying the year funtion to get the year. 
* Then I am using filter function to which I am passing the year and comparing with year i.e. 2009

```bash
filter(condition)
```
Filters rows using the given condition. where() is an alias for filter().

https://spark.apache.org/docs/latest/api/python/pyspark.sql.html#pyspark.sql.DataFrame.filter


## Wrtie the filter data to csv and parquet files

### Parquet

```bash
dfnew.write.format("parquet").mode("overwrite").save("hdfs://namenode/output/itmd-521/dpj/2009.parquet")
```

### Explaination
This code will write the data to the parquet file as 2009.parquet on the servers in directory dpj.

### CSV

```bash
dfnew.write.format("csv").mode("overwrite").save("hdfs://namenode/output/itmd-521/dpj/2009.csv")
```

### Explaination
This code will write the data to the csv file as 2009.parquet on the server in directory dpj.

## Links

Entire code for write CSV file : https://github.com/illinoistech-itm/djain14/blob/master/ITMD-521/RW-assignment/dpj-read-write-csv-2009.py

Entire code for write parquet file : https://github.com/illinoistech-itm/djain14/blob/master/ITMD-521/RW-assignment/dpj-read-write-parquet-2009.py


# Question 2:

### I didn't encounter any bad data only one column [''] has null values but that is to be analyzed in the next assignment.

# Question 3: 

### To execute the spark jobs in most efficient way is to coonfigure the cluster in following way:

## Available Resources:

No. of cores available : 56 - 4 = 52 ( -4 becuase we have four nodes and each node will require one core for OS )

No. of cores per Node : 52/4 = 13

No. of executors core: 4

So no. of executors per machine = 13/4
i.e 3 machines will have 3 executors and 1 machines will have 4 executors.

### Memory

Available memory per node: 172/4 = 43

Available memory per executors 43/4 = 10.75 GB

Yarn over Head : 2 GB

Therefore, available memory per executor: 10.75 - 2 = 8.75 GB


