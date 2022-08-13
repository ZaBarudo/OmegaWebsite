# OmegaWebsite

<br>

# Dev Environment Setup Guide
This guide will allow you to rapidly build a ready-to-use developement environment for the Omega Server running in Docker.

## Prerequisites
Docker is the easiest way to install the Omega Server, play with it, and even modify the code.

Docker provides an isolated environment, very close to a Virtual Machine. This environment contains everything required to launch and view the backend server. There is no need to install any modules separately.


**Installation steps:**
- [Install Docker CE](https://docs.docker.com/install/#supported-platforms)
> If you run e.g. Debian, don't forget to add your user to the `docker` group!
- [Install Docker Compose](https://docs.docker.com/compose/install/)

<br>

## Setup

<br>

### Get an Apache server running on the host machine:

Run the following script to get apache and to setup a reverse proxy server:
```console
bash main/apche.sh
```
> Uncomment line 7 and 8 in apche.sh if you are running the script for the first time.
> Comment line 7 and 8 back when you are running it for the second or more times.

<br>

### Start the Docker container:

Use the below command to start the container 

```console
docker system prune --volumes
docker-compose build --no-cache
docker-compose up
```
<br>

## Working

Run the following command to populate the database

```
docker exec <ubuntu-container-id> python3 db.py
```
> Initially no transactions will exist so make sure to add dummy transactions to transaction history of any user to view it on the website

Type in the following url in a web browser of your choice

```
omegabank.local
```

You can see login to see the Transaction History of the user (Password is root for all users)


<br>

## Stop the containers

To stop the containers, run the follwing command
```console
docker-compose down
```
