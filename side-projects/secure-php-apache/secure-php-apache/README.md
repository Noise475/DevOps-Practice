# Secure CI/CD Pipeline

This document provides an overview of the pipeline steps and security measures implemented.

## Objective

The goal is to build a simplified Continuous Integration / Continuous Deployment (CI/CD) pipeline with a focus on security using Docker, Jenkins, Apache2, and PHP.

## Tasks

### Task 1: Create a Web Application

A simple "Hello, World!" web application using PHP that runs on Apache2. This web application is designed to be containerized using Docker.

### Task 2: Customize Apache2 with Mod Rewrite Rules

Custom mod rewrite rules for the Apache2 server have been created. These rules have been designed with security in mind, preventing possible injection attacks or unauthorized access to certain parts of the web application.

### Task 3: Verify File Permissions

File permissions of the application and its environment are carefully set. This includes permissions for PHP files, Apache2 configuration files and Docker files. The reasoning behind the chosen permissions will be documented.

### Task 4: Dockerize the Web Application

A Dockerfile for the web application has been created. This Dockerfile creates a Docker image of the web application that can run on any Docker host. The Docker image includes the Apache2 server and the PHP application.

### Task 5: Jenkins Pipeline

A Jenkinsfile that describes the pipeline is included. The pipeline includes the following steps:

1. Pull the latest code from a Git repository.
2. Build a Docker image from the Dockerfile.
3. Run a container from the Docker image.
4. Run security scans on the Docker image using a tool of choice (for example, Clair or Trivy).
5. If the security scans pass, push the Docker image to Docker Hub.
6. Deploy the Docker image to an AWS environment.

### Task 6: Documentation

Each step of the pipeline is documented and an explanation of how the pipeline ensures security during the build and deployment process is provided.

## Evaluation Criteria

The following criteria were considered during the development:

- Code quality and organization.
- Use of Docker, Jenkins, Apache2, and PHP.
- Application of Apache2 mod rewrite rules.
- Implementation and justification of file permissions.
- CI/CD pipeline flow.
- Security considerations and measures.
- Documentation.

This pipeline has been organized, designed, tested, and documented as if it were going into production, and the changes have been pushed to the master branch.

# My Documentation
#### Task 2:

- .htaccess locks down access to sensitive files, hidden files/directories, prevents directory browsing, prevents direct links to images (hosting at the app's expense) and includes logic for http to https redirects

The files added under .docker are also responsible for enhancing security:

- modsecurity defines deny rules for common web attacks, logging level

- unicode.mapping defines some common problematic ASCII representations

- vhost.conf sets headers, defines the document root and who can access it as well as error and access logging

#### Task 3:
I create a user to avoid defaulting to root. File/Directory permissions are explained below

```sh
RUN chown myuser:mygroup /etc/apache2/sites-available/000-default.conf && \
chmod 644 /etc/apache2/sites-available/000-default.conf
```

6 - No need to ever execute this file just read and write \
4 - groups, and others should only read configuration

```sh
RUN chmod 644 -R /etc/modsecurity/modsecurity.conf && \
    chmod 644 -R /etc/modsecurity/unicode.mapping && \
    chmod 755 -R /var/log/modsecurity
```
7 - We need permission to write logs here\
6 - Same as above \
5 - The execute privledge here is for something like log aggregators or reading from multiple users\
4 - same as above \

#### Task 4:

- Dockerfile was mostly provided (minus user and permissions)

- docker-compose.yml handles the build and starts the container, defines the restart policy, and exposes ports

#### Task 5:

I adhere to the instructions in this section; I left out 2 parts - the docker push and AWS deploy.

Although both are mostly due to time, I left docker push as I'm a bit unsure what username/password I should use here; The AWS deploy can be a costly setup depending on what is existing (or not) in this excercise. 

#### Task 6:
I'll go step-by-step

1. stage('Pull Latest Code')
    - ensures that we have the lastest code from master branch

2. stage('Build & Run Docker Container')
    - runs `docker-compose up` to create our web-app

3. stage('Install security tools')
    - Installation for security tools designed to make sure our config is already hardend when it is pushed to a docker repository.

4. stage('Run Security Scans')
    - ZAP (OWASP Zed Attack Proxy)\
        -  ZAP is a dynamic application security testing tool designed to find vulnerabilities in web applications. 
        
        - It performs automated and manual testing to identify common security issues like cross-site scripting (XSS), SQL injections

    - Nikto
        -  Nikto is a web server scanner that performs comprehensive tests against web servers to find vulnerabilities, outdated software, and misconfigurations.
        
        - It checks for known issues like insecure files and directories.

    - Trivy
        - Trivy is a vulnerability scanner for container images and filesystems. 
        
        - It scans for vulnerabilities in OS packages and application dependencies within container images.

I'll end out by saying I'm not too familiar with php or apache so no surprises if there are some mix-ups there. 
Thanks for taking the time to read! 