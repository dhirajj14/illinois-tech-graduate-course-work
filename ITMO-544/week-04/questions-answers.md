# Chapter 01 - Designing in a Distributed World

1. What is distributed computing?
   
* Distributed Computing is also called as clod or cloud-native.
* Distribute Computing is the art of dividing the work over many small systems, maybe 1000's or 100,000's.
* For examples servies like ATM, Social Media, etc.
#
2. Describe the three major composition patterns in distributed computing.

* The three major composition patterns in distributed computing are: 
    1. Load Balancer with multiple backend replicas:
            
        * when the requests are send to server, Load balancer selects  one backend among the replicas to forward the request. The response from the backend is then sent to load balancer which gives it to original requester.

        * To select backend to forward query, load balancer uses any one of the following method:

            - Round Robin
            - Least Loaded
            - Slow Start

    2. Server Tree with multiple backend replicas:
        * This type of composition is used when the query or the request can be easily destructed.

        * When the request is send to server, it sends queries or request to multiple backends and in return gives response by combining multiple answers.

        * Advantages : 
            - Backends works in paralle

    3. Server Tree:
        * In this type of composition many servers work together with one as root and others as children and leaf node.

        * Server tree is used when there is a large datasets to be broken up. For e.g Wikipedia
#
3. What are the three patterns discussed for storing state?
    
    1. shards
    2. Replicate 
    3. Distribute
#
4. Sometimes a master server does not reply with an answer but instead replies with where the answer can be found. What are the benefits of this method?

* This methods helps to redirect the requester to appropriate/server node instead of searching all the nodes or server in the tree.

* Therefore, this methods helps to find the data quickly.
#

5. Section 1.4 describes a distributed file system, including an example of how reading terabytes of data would work. How would writing terabytes of data work?
* For writing the terabytes, it split the data into gigabyte-sized chunks and store it on multiple machines.

* While Storing the files master server tracks the files and records where those chunks are saved.

* This results in storing terabytes with the track of files which will be easy get during read operation.
#

6. Explain the CAP Principle. (If you think the CAP Principle is awesome, read “The Part-Time Parliament” (Lamport & Marzullo 1998) and “Paxos Made Simple” (Lamport 2001).)

* CAP stands for consitency, Avaibility and Partition. This principle says that it is not possible to build a distributed system that guarantees consistency, availability, and patitions tolerance.
    1.  Consistency
        
        * Consistency says that all data has state, so when you update data it should be updated in all the replicas and each node should see the same update at same time.

        * Alternative is eventual consistency, which  guarantee that any update will propagate to all replicas in a certain amount of time.  
    
    2.  Avaibility
        
        * Avaibility says that every request must recieve a response. It is must that it should be available. Even a "no" is a response. System parts must always be up.

        * Systems can report failures of parts even its busy. 
    
    3. Partition Tolerance

        * Partition tolerance says that system should continue to work even if its parts fails.
 
#

7. What does it mean when a system is loosely coupled? What is the advantage of these systems?

* Distributed systems are expected to be highly available, to last a long time, and to evolve and change without disruption. Entire subsystems are often replaced while the system is up and running. 

* The system is said loosely coupled if each component has little or no knowledge of the internals of the other components.

* Advantages:
    * loosely coupled systems are easier to evolve
and change over time.
#

8. Give examples of loosely and tightly coupled systems you have experience with. What makes them loosely or tightly coupled? (if you haven't worked on any use a system you have seen or used)

* I don't remember if I had experience with loosely or tightly coupled system, but I can refer some system where I think I indirectly worked with loosely coupled system.
    1. In the project APIT, where I am working, we have added some of the additional features to our backend server whithout taking it down or affecting the other features and Functionalities. 
    2. Second is the cellular network service I am using. They offent grow and reduce their coverage network. 
#

9. How do we estimate how fast a system will be able to process a request such as retrieving an email message?
* To determine the speed of retrieving an email message we look at the following points:
    1. index lookup (How many disk seeks and how much time per seek)
    2. How much size of infromation is read within particular lookup time (seeks * time per seeks)
    3. How much time its takes to read the actual message.
#

10. In Section 1.7 three design ideas are presented for how to process email deletion requests. Estimate how long the request will take for deleting an email message for each of the three designs. First outline the steps each would take, then break each one into individual operations until estimates can be created.
    
* The three design ideas presented for how to process email deletion request are:
    1. contact the server and delete the message from the storage system and the index
    2. The storage system simply marks the message as deleted in the index
    3. Asynchronous design where the client sends requests to the server and quickly returns control to the user without waiting for the request to complet.
