# ITMD-521 Cluster Analysis

## Phase 1

All the results are written out to: ```hdfs://namenode/output/itmd-521/dpj```

## Question 1 - Air Temperature and Atmospheric Pressure

#### Air Temperature

* To remove the invalidate record I used the filter function on the 2009.csv and 2009.parquet to get the output of validate records.

  ```dfnew = df2.filter(df2['Air_Temperature'] != 999.9)```

  As per the question the invalidate data should be 9999, but as in the last assignment we divided 'Air_Temperature' by 10 its 999.9
      
      * Output file location: hdfs://namenode/output/itmd-521/dpj/dpj-2009-valid-records-temp.csv and hdfs://namenode/output/itmd-521/dpj/dpj-2009-valid-records-temp.parquet
      
  * Insert Screenshot of just the above output here

* An additional Dataframe written to a file that has three columns: the total record count, the bad record count, and the percentage (bad/total)
  * Insert Screenshot of just the above output here

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
