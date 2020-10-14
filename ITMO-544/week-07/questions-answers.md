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

3. Describe the common web service architectures, in order from smallest to largest (include cloud tier/scale).

4. Describe how different local load balancer types work and what their pros and cons are. You may choose to make a comparison chart.

5. What is “shared state” and how is it maintained between replicas?

6. What are the services that a four-tier architecture provides in the first tier?

7. What does a reverse proxy do? When is it needed?

8. Suppose you wanted to build a simple image-sharing web site. How would you design it if the site was intended to serve people in one region of the world? How would you then expand it to work globally?

9. What is a message bus architecture and how might one be used?

10. What is an SOA?

11. Why are SOAs loosely coupled?

12. How would you design an email system as an SOA?

13. Who was Christopher Alexander and what was his contribution to architecture?
