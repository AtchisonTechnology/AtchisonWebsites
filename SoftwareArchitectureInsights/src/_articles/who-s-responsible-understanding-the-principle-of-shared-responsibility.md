---
title: Who’s Responsible? Understanding the Principle of Shared Responsibility
subtitle: ""
author: Lee Atchison
status: published
created: 2025-03-27
date: 2025-03-27
published_on: 2025-03-27

sai_url: https://softwarearchitectureinsights.com/posts/who-s-responsible-understanding-the-principle-of-shared-responsibility
email_sent: 2025-03-27
linkedin_url:

hero_image: 

internal_note:
meta_description: The Principle of Shared Responsibility splits security duties between cloud provider and customer — and the dividing line moves depending on the service.
slug: who-s-responsible-understanding-the-principle-of-shared-responsibility
description: >
  Cloud security is a split contract, not a handoff. Using AWS EC2 vs. RDS as examples, the dividing line between what your cloud provider secures and what you must secure yourself shifts service by service — and you need to know exactly where it falls.
categories:
  - "Security & Risk"

---

Both you and your cloud provider have a critical role in keeping your application safe. It's a principle of security known as the *Principle of Shared Responsibility*. It describes a model for assigning ownership of various security aspects between the cloud provider and you.

It's a principle that has been championed heavily by AWS, but it applies to all cloud providers in all situations.

The key to the principle is an agreed-upon set of responsibilities for keeping the application safe for each cloud service you use within an application. Each individual service and each individual service provider have a different set of responsibilities — and hence a different set of assumptions — about who is responsible for each action. To build a secure application, you must understand the assumptions made by the cloud provider, what they are responsible for, and what you are responsible for.

To illustrate this, let's look at an example. Let's look at the AWS EC2 service. The AWS EC2 service provides virtual servers for your application to utilize as it needs. Keeping the virtual servers secure involves a multi-layer security model. The different layers of security responsibility for this service are shown in Figure 1.

![Figure 1. Principle of Shared Responsibility as applied to the AWS EC2 service.](https://embed.filekitcdn.com/e/g8RtC4MRhUXatmA4STpkpZ/pp8yyyvCEe7xaS5Qavrg9N/email)

When you operate an application running on one or more EC2 instances, you create an agreement between you and AWS to manage the application's security on those services. For the EC2 service, AWS is responsible for the following security aspects of operating your application:

- **Facilities security**. AWS is responsible for maintaining the security of the physical data center and the physical plant that operates that data center.
- **Hardware security**. AWS is responsible for securing all of the hardware necessary for running the EC2 service.
- **Network infrastructure security**. AWS is responsible for the networking between systems and the hardware's physical and infrastructure security.
- **Virtualization system**. AWS is responsible for keeping the server virtualization layer safe, including all security in the virtualization host operating system and the virtualization software itself.
- **Security Tooling**. AWS is responsible for providing you with the tools necessary to keep your application safe and secure, including things such as Identity and Access Management (IAM), and similar services.

You are responsible for the rest of the security of your application, for example:

- **Operating system**. The security of the operating system running on the virtual server. Even if AWS provides the operating system distribution, you are responsible for ensuring it is configured securely.
- **Software**. The security of all the software running on top of the operating system in this virtual server, including identifying and remediating vulnerabilities. This includes 3rd party software, processes, daemons, etc., whether the software was included in the operating system by default or specifically added by you.
- **Your application**. The security of your application, services, databases, and everything you are using to operate, install, and monitor your application. If you are developing and operating a custom application, this means you are also responsible for securing the continuous integration and continuous development (CI/CD) pipeline.
- **Application data**. The security for all data you store on the server or transfer on and off the server.
- **Credentials**. You have access to many credentials for many components of the infrastructure, operating environment, and third-party software. These credentials give users and systems access to various non-public aspects of your application and the infrastructure it runs on. You are responsible for the security of all of these credentials, keeping them out of the hands of bad actors.
- **Policies and Procedures**. You are responsible for all policies you require to ensure a secure system configuration and other system constraints and requirements.

Each service in AWS has a distinct set of requirements specifying who is responsible for which security aspects of your overall application security. Some services are the same, but some services offer a very different set of requirements. For example, the AWS RDS service, which provides a database as a service (DBaaS) capability, has different responsibilities. This is illustrated in Figure 2.

![Figure 2. Comparing security responsibilities for AWS EC2 and RDS.](https://staging.softwarearchitectureinsights.com/assets/images/articles/psr-rds.png)

Here you can see the lower parts of the security stack are still AWS' responsibilities, and the upper parts are still clearly the application owner's responsibility. However, things are notably different in the middle—the dividing line between the two. For EC2, the operating system and application security are clearly the application owner's responsibility. However, for RDS, the application *is* the database the service operates. So, for RDS, the operating system and application security are the responsibility of AWS. The application owner's responsibilities don't start until the application data layer. This makes sense if you think about this and the services RDS offers. AWS is providing the database as a service and must keep it secure and up-to-date. The application owner, though, is responsible for the security of the data that is being stored *inside the database*, which is the application data itself.

The **Principle of Shared Responsibility** is the cornerstone for keeping an application safe and secure in a public cloud operating environment.
