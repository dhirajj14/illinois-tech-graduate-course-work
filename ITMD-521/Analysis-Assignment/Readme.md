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

    dfStats = spark.createDataFrame([(totalCount,badCount,percentage)], ['Total_Record_Count', 'Bad_Record_Count','Percentage_(bad/total)*100'])```

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
    
    dfStats = spark.createDataFrame([(totalCount,badCount,percentage)], ['Total_Record_Count', 'Bad_Record_Count','Percentage_(bad/total)*100'])```

  ![image](https://user-images.githubusercontent.com/54300222/80897505-02b0ba00-8cbf-11ea-99e4-121c02692bae.png)
## Question 2 - Explain Partition Effect

* Briefly explain in a paragraph with references, what happens to execution time when you reduce the shuffle partitions from the default of 200 to 20?

## Question 3

No written deliverable needed

## Question 4

* Show a screenshot of the execution times for your year
  * 1
  * 50
  * 200

* Show a screenshot of the execution times for your decade
  * 1
  * 50
  * 200

* Compare the execution times and explain why or why not there are any significant differences in the first group and in the second group