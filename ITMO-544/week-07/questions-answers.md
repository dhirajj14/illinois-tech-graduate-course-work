# Chapter 04 - Application Architecture

1. Describe the single-machine, three-tier, and four-tier web application architectures.

    * Single-Machine
        1. It is a self sufficient machine used to provide web service.
        2. The machine runs software that speaks theHTTP protocol, receiving requests, processing them, generating a result, andsending the reply.
        3. Single machine web server generates the web pages from three diffrent sources:
            * Static Content: Files are stored in local storage and sent to users. e.g. HTML pages, Images, music, video, softwares, etc.

            * Dynamic Content:Programs running on the web server generate HTML and possibly other output that is sent to the user. They may do soindependently or based on input received from the user.

            * Database-Driven Dynamic Content: This is a special case of dynamiccontent where the programs running on the web server consult a databasefor information and use that to generate the web page. In this architecture,the database software and its data are on the same machine as the webserver.

    * Three-Tier Web Application Architecture:
        1. Three-Tier service is similar to single-machine architecture and it is the lowest comman denominator for cloud native.
        2. In three-tier there is seperations of the resources at multiple levels. we have Load Balancer tier, then Web Server tier and then Data server tier.
        3. Load-balancer tier is the external facing feature of this three-tier architecture. All the request from the internet are send to Load Balancer and the Load balancer routes to frontend(Web server)
        4. In Three-tier Web server(Front-end) don't save any state (i.e any information). These web servers relley on data server
        5. S3, Amazon rora, Database
        6. Advantage of three-tier is that we have seperated the resources and now we can sclae it.

    * Four-Tier Machine:
        1. The four-tier architecture is similar to three-tier architecture but has many individual application which serves the same frontends.
        2. The frontends handle interactions with the users, and communicate to theapplication servers for content. 
        3. Fou-tier architecture has the Load Balancer, Frontends, Application server and Data Servers.
        4. All the request are sent to load balancer and then load balancer routes this request to frontends.
        5. Then the frontends send queries to the application servers. Because all HTTPprocessing is handled by the frontends, this permits the frontend-to-applicationprotocol to be something other than HTTP.
#

2. Describe how a single-machine web server, which uses a database to generate content, might evolve to a three-tier web server. How would this be done with minimal downtime?

    * Execute the following steps to evolve a single-machine web server to a three-tier web-server at minimal downtime :
        1. Create a load-Balancer and configure it to route queries or request to the web-server.
        2. Create a data server which is similar to single machine data base content and create API points to which web server can make Calls.
        3. Connect Load-Balancer to the Web-server (Single-Machine Web Server). Therefore, till this step there is no downtime of the system.
        4. Now, take a copy of single-machine web server and modify it's configuration to make the API calls or request to the data server.
        5. Test the web-server to pass all the test cases.
        6. Now replace the single-machine web server with the new modified web-server. Here we will have downtime until we replace the web-server.
        7. Now make the replicas of the web-server.

#

3. Describe the common web service architectures, in order from smallest to largest (include cloud tier/scale).


#

4. Describe how different local load balancer types work and what their pros and cons are. You may choose to make a comparison chart.

| Load Balancer Types | Working | Pros | Cons |
| :------------- |:-------------:|:-----:|:-----:|
|DNS Round Robin| In this type IP address of all the replicas are listed and then randomly picked one to forward the request.|Easy to implement and free.|If one replica dies clients will continue to try to access it as they cache DNS heavily .Difficult to control.|
|Layer 3 & 4 load Balancers| |Thebenefit of these load balancers is that they are simple and fast. Also, if areplica goes down, the load balancer will route traffic to the remainingreplicas.||
|Layer 7 Load Balancer||They can examinewhat is inside the HTTP protocol itself (cookies, headers, URLs, and soon) and make decisions based on what was found.||

#

5. What is “shared state” and how is it maintained between replicas?
    
    * There is an issue with the load-balancer and replicas is shared-state. There are diffrent stategies to overcome this issue like Sticky Connections, Shared-State and Hybrid.
    * In Shared-State strategy the fact that user is logged in and the user's profile infromation are stored somewhere that all backends can access. For each HTTP connection, the user’s state is fetched from this shared area. With this approach, it doesn’t matter if each HTTP request goes to a different machine. The user is not asked to log in every time the backends are switched.

#

6. What are the services that a four-tier architecture provides in the first tier?

    * Four-tier architecture provides a Load Balancer in the first tier which  divides the traffic among the various frontends.
#

7. What does a reverse proxy do? When is it needed?

    * A reverse proxy enables one web server to provide content from another web server transparently. The user sees one cohesive web site, even though it is actually made up of a patchwork of applications.

    * Reverse proxy is needed when you have multiple web servers and want user to access all the servers from one URL. It combine all the servers and gives seamlessly unified user experience to the user.

    * Requests go to the reverse proxy, which interprets the URL and collects the required pages from the appropriate server or service. This result is then relayed to the original requester.

#

8. Suppose you wanted to build a simple image-sharing web site. How would you design it if the site was intended to serve people in one region of the world? How would you then expand it to work globally?

    * To build a simple image-sharing web site, I would use the three-tier architecture with clod-scale service.
    * Three-tier architecture has the feature of scaling and then I can scale the system by adding more data servers in the different regions and and replicate the web serevers to handle the requests from the load balancer.
    * Cloud-scale services are globally distributed.
    * In cloud scale service a global load balanceris used to direct traffic to the nearest location.
    * In this type of architecure We build multiple datacenters around the world, or we rent space in otherpeople’s datacenters, and replicate our services in each of them.

    <img width="800" alt="Screen Shot 2020-10-15 at 1 21 58 AM" src="https://user-images.githubusercontent.com/54300222/96084546-e11a4800-0e84-11eb-9873-17a1c36b02b1.png">

    `Source: The Practice of Cloud System Administration`
#

9. What is a message bus architecture and how might one be used?

    * A message bus is a many-to-many communication mechanism between servers.
    * It is a convenient way to distribute information among different services.Message buses are becoming a popular architecture used behind the scenes insystem administration systems, web-based services, and enterprise systems. This approach is more efficient than repeatedly polling a database to see if new information has arrived.
    * A message bus is a mechanism whereby servers send messages to “channels”(like a radio channel) and other servers listen to the channels they need. 
    * A server that sends messages is a publisher and the receivers are subscribers. A servercan be a publisher or subscriber of a given channel, or it can simply ignore thechannel. 
    * This permits one-to-many, many-to-many, and many-to-onecommunication. 
    * One-to-many communication enables one server to quicklysend information to a large set of machines. Many-to-many communicationresembles a chat room application, where many people all hear what is beingsaid. 
    * Many-to-one communication enables a funnel-like configuration wheremany machines can produce information and one machine takes it in. 
    * A central authority, or master, manages which servers are connected to which channels.The messages being sent may contain any kind of data. They may be real-timeupdates such as chat room messages, database updates, or notifications thatupdate a user’s display to indicate there are messages waiting in the inbox. 

#

10. What is an SOA?

    * Service Oriented Architecture enable large services to be managed more easily.
    * SOA is the collection of subsystems with each subsystem is a self-contained service.
    * Each service is access via it's own API.
    * The Various services communicate with one another by making API calls.
#

11. Why are SOAs loosely coupled?
    * SOAs have its services loosely coupled becuase it makes easy to add and remove services. This indirecly helps SOA to manage large services easily.
    * In SOA each service is presented API at high level of abstaction.
    * For example
        * Imagine a job scheduler service. It accepts requests to perform various actions, schedules them, coordinates them, and reports back progress asit executes. 
        * In a tightly coupled system, the API would be tightly linked to the inner workings of the job scheduler. Users of the API could specify detailsrelated to how the jobs work rather than what is needed. For example, the API might provide direct access to the status of the lock mechanism used to prevent the same job from being executed twice.
        * Suppose a new internal design was proposed that prevented duplicate job execution but did locking some other way. This change could not be madewithout changing the code of all the services that used the API. 
        * In a looselycoupled system, the API would provide job status at a higher level ofabstraction: is the job waiting, is it running, where is it running, can it bestopped, and so on. No matter what the internal implementation was, theserequests could be proces

#

12. How would you design an email system as an SOA?

    * To design email system as an SOA I will have the following services or Subsystems:
        1. Service to Send and Receive emails.
        2. Service to add attachments like music, files, images to database when they are added attached in email.
        3. I will have a delete API to delete the emails
        4. One filter service to filter emails according to their type like social, promotions, updates which will not be access by user directly but will be used by other services internally.
        5. I will also have one montioring service which will monitor the all other services.

#

13. Who was Christopher Alexander and what was his contribution to architecture?
    
    `Source : https://en.wikipedia.org/wiki/Christopher_Alexander`

    > Christopher Wolfgang Alexander (born 4 October 1936 in Vienna, Austria) is a widely influential British-American architect and design theorist, and currently emeritus professor at the University of California, Berkeley. His theories about the nature of human-centered design have affected fields beyond architecture, including urban design, software, sociology and others.Alexander has designed and personally built over 100 buildings, both as an architect and a general contractor. In software, Alexander is regarded as the father of the pattern language movement. The first wiki—the technology behind Wikipedia—led directly from Alexander's work, according to its creator, Ward Cunningham. Alexander's work has also influenced the development of agile software development.

    * Patterns are solutions to recurring problems in a context. —Christopher Alexander
    * He said that all the problems can be solved using patterns.
    * In this chapter we can see that different problems are solve using diffrent architecture probles lik three-tier architecture, four-tier architecture, message bus, etc.