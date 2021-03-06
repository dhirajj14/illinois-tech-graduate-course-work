# Chapter 05 - Application Architecture

1. What is scaling?

    * A system’s ability to scale is its ability to process a growing workload, usually
    measured in transactions per second, amount of data, or number of users. There
    is a limit to how far a system can scale before reengineering is required to permit
    additional growth.

#

2. What are the options for scaling a service that is CPU bound?
    * For the CPU bound services we can use the most common technique which is called as "Scaling UP".
    * This is the simplest methodology for scaling a system is to use bigger, faster equipment.
    * A system that runs too slowly can be moved to a machine with a faster CPU, more CPUs, more RAM, faster disks, faster network interfaces, and so on. 
    * Often an existing computer can have one of those attributes improved without replacing the entire machine. This is called scaling up because the system is increasing in size.
    * When this solution works well, it is often the easiest solution because it does not require a redesign of the software.
#

3. What are the options for scaling a service whose storage requirements are growing?
    * The options for scaling a service whose storage requirements are growing is by using the AKF cube's Z-Axis (Split into Lookup and Formulaic Splits) option.
    * Using this options we have three diffrent sub options we can use for a service whose storage requirements are growing:
        1.  start a new database server every time the current one fills up.
            * For e.g  To divide, or segment, a database by date. If the database is an accumulation of data, such as log data, one can start a new database server every time the current one fills up. There may be a database for 2013 data, 2014 data, and so on.
        2. Another way to segment data is by geography. In a global service it is common practice to set up many individual data stores around the world. Each user’s data is kept on the nearest store. This approach also gives users faster access to their data because it is stored closer to them.
        3. Using T-Bird, based on Gizzard system to scale automatically.

#

4. The data in Figure 1.10 is outdated because hardware tends to get less expensive every year. Update the chart for the current year. Which items changed the least? Which changed the most?
     | Action | Typical Time | Year 2020 | Change |
    | :------------- |:-------------:|:-----:|:-----:|
    |L1 Cache Reference|0.5 ns| 1 ns| Normal Change|
    |Branch Mispredict|5 ns|3 ns|Least Change|
    |L2 Cache Reference|7 ns|4 ns|Least Change|
    |Mutex Lock/unLock|100 ns|17 ns|Most Change|
    |Main Memory Reference|100 ns|100 ns|No Change|
    |Compress 1kb with Zippy|10,000 ns|2000 ns| Most Change|
    |send 2k bytes over 1Gbps Network|20,000|44 ns|Most Change|
    |Read 1MB Sequentially from memory|250,000 ns| 3,000| Most Change|
    |Round Trip with Same DataCenter|500,000 ns|500,000 ns|No Change|
    |Read 1MB from SSD|1,000,000 ns|49,000 ns| Most Change|
    |Disk Seek|10,000,000 ns|2,000,000 ns| Most Change|
    |Read 1MB Sequentially from Network| 10,000,000 ns|||
    |Read 1MB Sequentially from Disk|30,000,000 ns|825,000 ns| Most Change|
    |Packet roundtrip CA to Netherlands|150,000,000 ns| 150,000,000ns|No Change|
#

5. Rewrite the data in Figure 1.10 in terms of proportion. If reading from main memory took 1 second, how long would the other operations take? For extra credit, draw your answer to resemble a calendar or the solar system.

    | Action | Typical Time (ns) | Proportion (s)|
    | :------------- |:-------------:|:-----:|
    |L1 Cache Reference|0.5 ns| 0.000002 s|
    |Branch Mispredict|5 ns|0.00005 s|
    |L2 Cache Reference|7 ns| 0.000028 s|
    |Mutex Lock/unLock|100 ns|0.0004 s|
    |Main Memory Reference|100 ns|0.0004 s|
    |Compress 1kb with Zippy|10,000 ns|0.04 s|
    |send 2k bytes over 1Gbps Network|20,000|0.08 s|
    |Read 1MB Sequentially from memory|250,000 ns| 1 s|
    |Round Trip with Same DataCenter|500,000 ns| 2 s|
    |Read 1MB from SSD|1,000,000 ns| 4 s|
    |Disk Seek|10,000,000 ns| 40 s|
    |Read 1MB Sequentially from Network| 10,000,000 ns| 40s|
    |Read 1MB Sequentially from Disk|30,000,000 ns|120 s|
    |Packet roundtrip CA to Netherlands|150,000,000 ns| 600 s|

6. Take the data table in Figure 1.10 and add a column that identifies the cost of each item. Scale the costs to the same unit—for example, the cost of 1 terabyte of RAM, 1 terabyte of disk, and 1 terabyte of L1 cache. Add another column that shows the ratio of performance to cost.

    Cost for 1ns = $ 0.1;
    
    Normal Speed to read or access 1MB = 1ns;




    | Action | Typical Time (ns) | Unit |Cost ($)| Performance to Cost Ratio|
    | :------------- |:-------------:|:-----:|:-----:|:----:|
    |L1 Cache Reference|0.5 ns| 1 MB |  0.05 | 10 |
    |Branch Mispredict|5 ns| 1 MB| 0.5 | 10 |
    |L2 Cache Reference|7 ns| 1 MB| 0.7| 10 |
    |Mutex Lock/unLock|100 ns|1 MB| 10 | 10 |
    |Main Memory Reference|100 ns|1 MB| 100|10|
    |Compress 1kb with Zippy|10,000 ns|1 MB|10000*1024 = 10240000 * 0.1 = 1024000 |0.0097|
    |send 2k bytes over 1Gbps Network|20,000|1 MB|20000*512 = 10240000 * 0.1 = 1024000 | 0.0195
    |Read 1MB Sequentially from memory|250,000 ns| 1 MB | 25000| 10|
    |Round Trip with Same DataCenter|500,000 ns| 1 MB|50000| 10|
    |Read 1MB from SSD|1,000,000 ns| 1 MB | 100000 | 10
    |Disk Seek|10,000,000 ns| 1 MB | 1000000 | 10
    |Read 1MB Sequentially from Network| 10,000,000 ns| 1 MB|  10000000|10
    |Read 1MB Sequentially from Disk|30,000,000 ns|1 MB|  30000000| 10    
    |Packet roundtrip CA to Netherlands|150,000,000 ns| 1 MB| 15000000| 10
#

7. What is the theoretical model that describes the different kinds of scaling techniques?

    * The theeoritical model that descriobes the different kinds of scaling techniques is "The AKF Scaling Cube".   
         1. x: Horizontal Duplication
         2. y: Functional or Service Splits
         3. z: Lookup-Oriented Split

#

8. How do you know when scaling is needed?
    
    * We can know when the scaling is required by identifying the bottlenecks.
    * **Bottlenecks-**
        * A bottleneck is a point in the system where congestion occurs. 
        * It is a point that is resource starved in a way that limits performance. Every system has a bottleneck. 
        * If a system is underperforming, the bottleneck can be fixed to permit the system to perform better. If the system is performing well, knowing the location of the bottleneck can be useful because it enables us to predict and
        prevent future problems. In this case the bottleneck can be found by generating
        additional load, possibly in a test environment, to see at which point performance suffers.
    * Deciding what to scale is a matter of finding the bottleneck in the system and eliminating it.
 
#

9. What are the most common scaling techniques and how do they work? When are they most appropriate to use?
    * The most commonn scaling technique is x:Horizontal Duplication or Horizontal scaling or scaling out.
    * Horizontal duplication increases throughput by replicating the service. 
    * For example, the technique of using many replicas of a web server behind a load balancer is an example of horizontal scaling.
    * The appropriate use of this technique is when the data is not increasing and there is no complex trasactions that need special handling.
    * If each transaction can be completed independently on all replicas, then the performance improvement can be proportional to the number of replicas.

#

10. Which scaling techniques also improve resiliency?
    * According to me the scaling techiniques that improves the resiliency is the Z-axis with Data Sharding. 
    * Sharding is a way to segment a database (z-axis) that is flexible, scalable, and resilient. It divides the database based on the hash value of the database keys.
    * Shards can be replicated on multiple machines to improve performance. With
    such an approach, each replica processes a share of the queries destined for that
    shard. Replication can also provide better availability. 
    * If multiple machines store
    any shard, then any machine can crash or be taken down for maintenance and the
    other replicas will continue to service the requests.

#

11. Describe how your environment uses a CDN or research how it could be used.
    * A content delivery network (CDN) is a web-acceleration service that delivers
    content (web pages, images, video) more efficiently on behalf of your service.
    CDNs cache content on servers all over the world. Requests for content are
    serviced from the cache nearest the user. Geolocation techniques are used to
    identify the network location of the requesting web browser.

    * I have two examples in my environment where I using the CDN:
        1. To download the ubuntu ISO Image using during packer Build. The link we use is the nearest to our location.
        2. If the university wants to share some software or application (Mobile app or desktop app) it can use AWS CDN to share the files amound different networks.

#

12. Research Amdahl’s Law and explain how it relates to the AKF Scaling Cube.
    * AKF scaling Cube is all related to what part of the service should be scaled up or on what part of the service the reengineering should be done.
         * x: Horizontal Duplication
         * y: Functional or Service Splits
         * z: Lookup-Oriented Split

    * Amdhal's Law is all about what difference will reengineering will make. For. e.g WHat difference will changing the CPU will make.
    * Amdhal's gives the theoretical speedup in latency of the execution of a task at a fixed workload that can be expected of a system whose resources are improved. In other words, it is a formula used to find the maximum improvement possible by just improving a particular part of a system. It is often used in parallel computing to predict the theoretical speedup when using multiple processors. (Source: GeeksForGeeks)
    * It has given two formulas

        Pe is the performance for entire task using the enhancement when possible 
        Pw is the performance for entire task without using the enhancement
        Ew is the execution time for entire task without using the enhancement and 
        Ee is the execution time for entire task using the enhancement when possible

        Speedup = Pe/Pw
            
        or
            
        Speedup = Ew/Ee
#