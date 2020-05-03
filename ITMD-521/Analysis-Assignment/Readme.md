# ITMD-521 Cluster Analysis

## Phase 1

All the results are written out to: ```hdfs://namenode/output/itmd-521/dpj```

## Question 1 - Air Temperature and Atmospheric Pressure

#### Air Temperature

* To remove the invalidate record I used the filter function on the 2009.csv and 2009.parquet to get the output of validate records.

  ```dfnew = df2.filter(df2['Air_Temperature'] != 999.9)```

  As per the question the invalidate data should be 9999, but as in the last assignment we divided 'Air_Temperature' by 10 so its 999.9
      
      Output file location: 
      hdfs://namenode/output/itmd-521/dpj/dpj-2009-valid-records-temp.csv 
      hdfs://namenode/output/itmd-521/dpj/dpj-2009-valid-records-temp.parquet

  * Percentage of Bad Count data

    ```totalCount = float(df2.count())
    badCount = float(df2.filter(df2['Air_Temperature'] == 999.9).count())

    percentage = round((badCount/totalCount)*100, 2)

    dfStats = spark.createDataFrame([(totalCount,badCount,percentage)], ['Total_Record_Count', 'Bad_Record_Count','Percentage_(bad/total)*100'])
    ```

    ![image](https://user-images.githubusercontent.com/54300222/80897251-84531880-8cbc-11ea-9d7f-6af5cefdd53d.png)

#### Air Pressure

* To remove the invalidate record I used the filter function on the 2009.csv and 2009.parquet to get the output of validate records.

  ```dfnew = df2.filter(df2['Atmospheric_Pressure'] != 9999.9)```

  As per the question the invalidate data should be 99999, but as in the last assignment we divided 'Air_Pressure' by 10 so its 9999.9
      
      Output file location: 
      hdfs://namenode/output/itmd-521/dpj/dpj-2009-valid-records-press.csv 

  * Percentage of Bad Count data

    ```totalCount = float(df2.count())
    
    badCount = float(df2.filter(df2['Atmospheric_Pressure'] == 9999.9).count())
    
    percentage = round((badCount/totalCount)*100, 2)
    
    dfStats = spark.createDataFrame([(totalCount,badCount,percentage)], ['Total_Record_Count', 'Bad_Record_Count','Percentage_(bad/total)*100'])
    ```

    ![image](https://user-images.githubusercontent.com/54300222/80897505-02b0ba00-8cbf-11ea-99e4-121c02692bae.png)


## Question 2 - Explain Partition Effect

* I submitted both the jobs at same time and the elasped time for the job with the default shuffle partition (200) was 3hrs 31mins 7secs and for the job with 20 shuffle partition was 3hrs 13mins 9secs

  Here we can see that the job with default partition took more time than the job with 20 partitions. This is because the data we read was not a big data. It was a data only for a year 2009.

  If we are having small data then having default shuffle partition value i.e. 200 will cause much overhead.

  Similarly, for large data having default shuffle partition willnot be effective. 

  And the book says that the number of partion should be accodring to the no. of executors and size of data. pdf page 44

  

* #### Min Max for Year 2009
  #### Code for minimum and Maximum air temperature for a year(2009) by month

  ```
  drange = dfnew.filter(dfnew['Air_Temperature'].between(-10.0, 11.5))
    
  df = drange.groupBy(month(drange['Observation_Date']).alias('Month_Number')).agg(min(drange['Air_Temperature']*10).alias('Minimum_Temperature'), max(drange['Air_Temperature']*10).alias('Max_Temperature')) 
  ```
  ![image](https://user-images.githubusercontent.com/54300222/80897649-9931ab00-8cc0-11ea-9733-982019af246f.png)

  > **Same output for suffle.partitions by 20** : Below is the code used to reduce default shuffle partition
    ```bash
    spark.conf.set("spark.sql.shuffle.partitions", 20)
    ```

* #### Min Max for Decade 2000-2018
  #### Code for minimum and Maximum air temperature for a Decade(2000-2018) by year-month

  ```    
  df = drange.groupBy(date_format(drange['Observation_Date'], 'yyyy-MM').alias('Year-Month')).agg(min(drange['Air_Temperature']*10).alias('Minimum_Temperature'), max(drange['Air_Temperature']*10).alias('Max_Temperature')
  ```
  ![image](https://user-images.githubusercontent.com/54300222/80897870-faf31480-8cc2-11ea-9b4b-a1e8a424f866.png)


## Question 3

#### partitionBy
    
  * #### Code for minimum and Maximum air temperature for a Decade(2000-2018) by year-month

    ```bash
    dfnew = df2.withColumn('Month', month(df2['Observation_Date']))
  
    dfnew.write.partitionBy("Month").format("parquet").mode("overwrite").save("hdfs://namenode/output/itmd-521/dpj/dpj-2009-partitionby.parquet")
    ```
    
    ```
    Output file location: hdfs://namenode/output/itmd-521/dpj/dpj-2009-partitionby.parquet
    ```
  * Screenshot
  
    ![image](https://user-images.githubusercontent.com/54300222/80898046-5b368600-8cc4-11ea-9e0c-8c8aaca38594.png)

#### lz4

```
Output file location:
hdfs://namenode/output/itmd-521/dpj/dpj-2009-lz4.json
hdfs://namenode/output/itmd-521/dpj/dpj-2009-lz4.csv
```

## Question 4

#### Jobs for all the files have been submitted and are in the queue. Out of 12 jobs 6 Jobs have been completed successfully (write jobs) and 6 jobs are failed(reads)

####  Year 2009 and Decade 2000-2018 (2000-2005 i.e 5 years) Execution write repartition Screenshot

> **This screenshot shows the start and end time from the point when the job was accepted. To see actual execution I reffered the full logs to get the timestamp**
![image](https://user-images.githubusercontent.com/54300222/80916689-e98c2580-8d1f-11ea-860f-ec4557b291de.png)

* Execution times for your year (Write)
  * 1 - 

  * 50

  * 200

* Actual Execution times according to full logs for your decade (write)
  * 1:
    
    Time - 2:27 to 8:27 = 6 hrs

  * 50:
    
    Time - 2:39 to 8:37 = 5 hrs 58mins

  * 200:
    
    Time - 2:40 to 8:08 = 5.47 hrs

####  Year 2009 and Decade 2000-2018 (2000-2005 i.e 5 years) Execution read repartition Screenshot

> **This screenshot shows the start and end time from the point when the job was accepted. To see actual execution I reffered the full logs to get the timestamp**
![image](https://user-images.githubusercontent.com/54300222/80916868-f9f0d000-8d20-11ea-9f87-5e2a4becd5eb.png)

* Execution times for your year (Read)
  * 1

  * 50

  * 200

* Execution times for your decade (Read)
  * 1

  * 50

  * 200

* Compare the execution times and explain why or why not there are any significant differences in the first group and in the second group
