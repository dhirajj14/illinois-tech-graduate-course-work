# Chapter 01 - Designing in a Distributed World

1. What is distributed computing?
   
    >
        * Distributed Computing is also called as clod or cloud-native.
  
        * Distribute Computing is the art of dividing the work over many small systems, maybe 1000's or 100,000's.

        * For examples servies like ATM, Social Media, etc.

2. Describe the three major composition patterns in distributed computing.

    >
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

            3. Server Tree
3. What are the three patterns discussed for storing state?

4. Sometimes a master server does not reply with an answer but instead replies with where the answer can be found. What are the benefits of this method?

5. Section 1.4 describes a distributed file system, including an example of how reading terabytes of data would work. How would writing terabytes of data work?

6. Explain the CAP Principle. (If you think the CAP Principle is awesome, read “The Part-Time Parliament” (Lamport & Marzullo 1998) and “Paxos Made Simple” (Lamport 2001).)

7. What does it mean when a system is loosely coupled? What is the advantage of these systems?

8. Give examples of loosely and tightly coupled systems you have experience with. What makes them loosely or tightly coupled? (if you haven't worked on any use a system you have seen or used)

9. How do we estimate how fast a system will be able to process a request such as retrieving an email message?

10. In Section 1.7 three design ideas are presented for how to process email deletion requests. Estimate how long the request will take for deleting an email message for each of the three designs. First outline the steps each would take, then break each one into individual operations until estimates can be created.
