## Chapter 02 - Designing for Operations

**1. Why is design for operations so important?**
    
    * 80% of the development life cycle is given to operations.

**2. How is automated configuration typically supported?**
    
    * Automated configuration is typically supported by following task or actions:
        1. Make a backup of a configuration and restore it.
        2. View the diffrence between the configs
        3. Archive the current running configuration.
        4. Record the system state via API, Configuration or text file, or Binary Blob.

**3. List the important factors for redundancy through replication.**
    
    * Service must be designed to work behid the load-balancer.
    * Should cosider the user-state
    * Must handle pattern to handle-traffic
        1. Round Robin
        2. Least Loaded
        3. Slow-Start 

**4. Give an example of a partially implemented process in your current environment. What would you do to fully implement it?**

**5. Why might you not want to solve an issue by coding the solution yourself?**
    
    * There are two reasons not to code or solve issue yourself:
        1. First, the developers might not accept your code. As an outsider, you do not know their coding standards, the internal infrastructure, and their overall vision for the future software architecture. Any bugs in your code will receive magnified blame.
        
        2. Second, it sets a bad precedent. It sends a message that developers do not need to care about operational features because if they delay long enough you’ll write them yourself

**6. Which type of problems should appear first on your priority list?**
    
    * According to me the **Backup and Restore** problems should appear first on the priority list. 
    * **Backup and Restore** will have high impact on the system or the service and it is easy to implement with less efforts.

![fggf](https://user-images.githubusercontent.com/54300222/95276202-35cc1c00-0810-11eb-9bc7-647e61835e5b.PNG)


**7. Which factors can you bring to an outside vendor to get the vendor to take your issue seriously?**
    
    * Factors that can bring an outside vendor take your issue seriously are:

        1. Filing bugs and not just saying it orally.
        2. Having Periodic meetings to discuss issue or solution.
        3. Always raise the visibility of your issues in a constructive way.
        4. write a postmortem report that includes the feature request or solving issue request.
