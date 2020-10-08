## Chapter 03 - Selecting a Service Platform

1. Compare IaaS, PaaS, and SaaS on the basis of cost, configurability, and control.
    
    | Type of Service | Cost | Configurability | Control |
    | :------------- |:-------------:|:-----:|:-----:|
    | IaaS      | Iaas is expensive then PaaS and SaaS as everyting is to be setup manaually from scratch. | In IaaS you need to confiugre everything from hardware to the service to be provided. You need to handle all the hardware failures and power outage For e.g AWS| You have control over everything(Hardware, OS, Software, Cofiguration) |
    | PaaS      | PaaS is less expensive than IaaS as you don't need to pay for infrastucture. You only need to pay for the palatform you are using.      |  In PaaS you need to cofigure a layer above infrastructure. You have to run your application on the framework provided by provider. For e.g Google App Engine |You have control over your application and the data. Don't allow to manage system libraries |
    | SaaS | SaaS is less expensive than IaaS and PaaS as you are only paying for the serivce you are using and don't have to look at the infrastructure and platform.| In SaaS you need to only develope a service which can be access from anywhere without any aditional installation. In SaaS you need not require to worry about the Platform and the infrastructure.  | You have control only over your data.|

2. What are the caveats to consider in adopting Software as a Service?

* The caveats to consider in adopting are:
    * You don't want customer to concern themselves with software installation, upgrades, and operations. 
    * There is no client software to download. The service is fully managed, upgraded, and maintained by the you(owner).
    * This affects architecture and security decisions as the service is going to be accessed from everywhere.

3. List the key advantages of virtual machines.
    
    * Advantages of Virtual Machines:
        1. Fast to create and Destroy
        2. Very little led time.
        3. Easy to create and destroy (ephemeral machine).
        4. An API can be used to create, start, stop, modify and destroy virtual machines 
        5. virtual machines are controlled through software, virtualization systems are programmable.

4. Why might you choose physical over virtual machines?
    * For the following reasons I might choose physical over virtual machine:
        * In vistal machines some resources are shared for e.g CPU cores.
        * Some resources are shared in an unbounded manner. For example, if one virtual machine is generating a huge amount of network traffic, the other virtual machines may suffer. 
        * Limitation of Disk I/O per second.
        * Virtual Machines are heavy weight as the they require lot of space to run operating system.

5. Which factors might make you choose private over public cloud services?
    * The choice between private or public use of a platform is a business decision based on four factors: compliance, privacy, cost, and control.
    * You can select the private cloud for the followinf reasons:
        1. You don't want to fail in compilance audit which can have a significant consequences.
        2. You don't want your data to be accessed by someone else. In public cloud there is no direct access but they can access your data.
        3. When you want to use a cloud fully and for long term.
        4. When you want to have full control over the data.

6. Which selection strategy does your current organization use? What are the benefits and caveats of using this strategy?
    * I think my organization (IIT) is using **Develop an In-House Service Provider** .
    * We have in house service provider OTS which helps to control cost and maintian privacy.
    * Benefits of using strategy are:
        * Each and every situation is different and according to situation these startegies are made to take decisions.
        * These strategies are cost effective and easy to adopt depending on requirement.
