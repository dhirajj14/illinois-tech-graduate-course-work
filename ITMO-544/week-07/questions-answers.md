# Chapter 04 - Application Architecture

1. Describe the single-machine, three-tier, and four-tier web application architectures.

    * Three-Tier Web Application Architecture:
        1. Three-Tier service is similar to single-machine architecture and it is the lowest comman denominator for cloud native.
        2. In three-tier there is seperations of the resources at multiple levels. we have Load Balancer tier, then Web Server tier and then Data server tier.
        3. Load-balancer tier is the external facing feature of this three-tier architecture. All the request from the internet are send to Load Balancer and the Load balancer routes to frontend(Web server)
        4. In Three-tier Web server(Front-end) don't save any state (i.e any information). These web servers relley on data server
        5. S3, Amazon rora, Database
        6. Advantage of three-tier is that we have seperated the resources and now we can sclae it.

2. Describe how a single-machine web server, which uses a database to generate content, might evolve to a three-tier web server. How would this be done with minimal downtime?

    * Execute the following steps to evolve a single-machine web server to a three-tier web-server at minimal downtime :
        1. Create a load-Balancer and configure it to route queries or request to the web-server.
        2. Create a data server which is similar to single machine data base content and create API points to which web server can make Calls.
        3. Connect Load-Balancer to the Web-server (Single-Machine Web Server). Therefore, till this step there is no downtime of the system.
        4. Now, take a copy of single-machine web server and modify it's configuration to make the API calls or request to the data server.
        5. Test the web-server to pass all the test cases.
        6. Now replace the single-machine web server with the new modified web-server. Here we will have downtime until we replace the web-server.
        7. Now make the replicas of the web-server.

3. Describe the common web service architectures, in order from smallest to largest (include cloud tier/scale).

4. Describe how different local load balancer types work and what their pros and cons are. You may choose to make a comparison chart.

5. What is “shared state” and how is it maintained between replicas?
    
    * There is an issue with the load-balancer and replicas is shared-state. There are diffrent stategies to overcome this issue like Sticky Connections, Shared-State and Hybrid.
    * In Shared-State strategy the fact that user is logged in and the user's profile infromation are stored somewhere that all backends can access. For each HTTP connection, the user’s state is fetched from this shared area. With this approach, it doesn’t matter if each HTTP request goes to a different machine. The user is not asked to log in every time the backends are switched.


6. What are the services that a four-tier architecture provides in the first tier?

7. What does a reverse proxy do? When is it needed?

    * A reverse proxy enables one web server to provide content from another web server transparently. The user sees one cohesive web site, even though it is actually made up of a patchwork of applications.

    * Reverse proxy is needed when you have multiple web servers and want user to access all the servers from one URL. It combine all the servers and gives seamlessly unified user experience to the user.

    * Requests go to the reverse proxy, which interprets the URL and collects the required pages from the appropriate server or service. This result is then relayed to the original requester.

8. Suppose you wanted to build a simple image-sharing web site. How would you design it if the site was intended to serve people in one region of the world? How would you then expand it to work globally?

9. What is a message bus architecture and how might one be used?

10. What is an SOA?

11. Why are SOAs loosely coupled?

12. How would you design an email system as an SOA?

13. Who was Christopher Alexander and what was his contribution to architecture?
