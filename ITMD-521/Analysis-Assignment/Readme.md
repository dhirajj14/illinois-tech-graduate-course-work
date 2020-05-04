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

> **This screenshot shows the start and end time from the point when the job was accepted. To see actual execution I reffered the full logs to get the timestamp**
![image](https://user-images.githubusercontent.com/54300222/80919237-8d7ccd80-8d2e-11ea-979e-383e0919f5b4.png)

* Execution time for the job with the default shuffle partition (200) 20 mins and for the job with 20 shuffle partition was 18 mins based on full logs

  |  Shuffle Partitions| Time              | Execution Time |
  | -------------      |:-----------------:| :-------------:|
  | 200 (Default)      | 0 : 46 to 1 : 06  | 20 mins        |
  | 20                 | 1 : 30 to 1 : 48  | 18 mins        |

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

###  Year 2009 and Decade 2000-2018 (2000-2005 i.e 5 years) Execution write repartition Screenshot

> **This screenshot shows the start and end time from the point when the job was accepted. To see actual execution I reffered the full logs to get the timestamp**
![image](https://user-images.githubusercontent.com/54300222/80916689-e98c2580-8d1f-11ea-860f-ec4557b291de.png)

  * Actual Execution times (approx.) for year 2009 (Write)
    * 1: 

      Time: 1:21 to 1:45 = **25 mins**

    * 50:

      Time: 1:27 to 1:54 = **27 mins**

    * 200:

      Time: 1:46 to 2:12 = **26 mins**

  * Actual Execution times (approx.) according to full logs for your decade (write)
    * 1:
    
      Time - 2:27 to 8:27 = **6 hrs**

    * 50:
    
      Time - 2:39 to 8:37 = **5 hrs 58 mins**

    * 200:
    
      Time - 2:40 to 8:08 = **5 hrs 28 mins**


|  Partitions| Year Data Execution Time(2009)| Decade Data Execution Time(2000-2015)  |
| ------------- |:-------------:| :-------------:|
| 1             | 25 mins       | 6 hrs 58 mins  |
| 50            | 27 mins       | 5 hrs 58 mins  |
| 200           | 26 mins       | 5 hrs 28 mins  |


> #### **From the execution time for both year and decade we can say that small data should have less number of partition to execute it efficiently and large data should have more numbers of partitions to execute efficiently**

___

###  Year 2009 and Decade 2000-2018 (2000-2005 i.e 5 years) Execution read repartition Screenshot


> **This screenshot shows the start and end time from the point when the job was accepted. To see actual execution I reffered the full logs to get the timestamp**
![image](https://user-images.githubusercontent.com/54300222/81019914-4cb7ae00-8e2d-11ea-9248-e290a44b7895.png)

  * Actual Execution times (approx.) for year 2009 (Read)
    * 1: 

      Time: 4:41 to 5:32 = **51 mins**

    * 50:

      Time: 4:56 to 5:29 = **33 mins**

    * 200:

      Time: 5:04 to 5:28 = **24 mins**

  * Actual Execution times (approx.) according to full logs for your decade (Read)
    * 1:
    
      Time - 3:40 to 5:27 = **1 hr 47 mins**

    * 50:
    
      Time - 3:47 to 5:40 = **1 hr 53 mins**

    * 200:
    
      Time - 5:45 to 7:46 = **2 hrs 1 min**


|  Partitions| Year Data Execution Time(2009) (Read)| Decade Data Execution Time(2000-2015) (Read) |
| ------------- |:-------------:| :-------------:|
| 1             | 51 mins       | 1 hr 47 mins  |
| 50            | 33 mins       | 1 hr 53 mins  |
| 200           | 24 mins       | 2 hrs 1 min  |

> #### **From the execution time for both year and decade (Read) we can say that small data should have more number of partition to execute it efficiently and large data should have less numbers of partitions to execute efficiently**
___

### Diffrence between write repartition(1, 50, 200) and read repartition(1, 50, 200)

> #### **From the execution time for both **Write** and **Read** using repartition(1,50,200) we can say that read repartition is exactly opposite of write repartition. In write repartition for small data having less number of partition will execute the task efficiently whereas for read using repartition with less number of partition will not execute the task efficiently. For write repartition on large data having less number of partition will not execute the task efficiently whereas for read using repartition with less number of partition will execute the task efficiently**