# insurance-requirements

This repo contains all of the requirements needed for Docker to create a virtual container for standardizing the
insurance environment.

## Why Docker?
* What is Docker?
    * Docker is a tool created to help standardize environments. It uses a single source of truth for computing 
    environments called an image that anyone can pull and use to make a container (the actual environment).
    * https://www.docker.com/resources/what-container
* How is the DS team using Docker?
    * We are already using Docker for Heliostats in the Concourse environment. The data science team will be using 
    Docker for working in the insurance environment.
    * We created and will maintain a Docker image in this repo. `Dockerfile` and `docker-compose.yml` are the core
    components of Docker.
* How do you use Docker in your daily workflow?
    * Treat docker like a venv, whenever you are coding you should be in it.
    * Whenever you add packages to the insurance model, you must update the appropriate `requirements.txt` file here.
    This repo is linked to DockerHub, so that any time you push a change to this Bitbucket repo, it will trigger an
    automatic new build of the Docker image on DockerHub. In this way, whenever we make a change to the insurance image,
    every single insurance container can be updated, whether local or remote!

## Setup
* **LOCAL** Installation
    * Download and install the latest version of Docker from https://www.docker.com/products/docker-desktop
    * Make sure you have Docker 18.03+ installed. You can use docker --version
* **REMOTE** Installation
    * Docker should be already installed on the datascience EC2 instance. Check using `docker —version`. If not, check 
    https://bitbucket.org/kwh/devops/src/master/ansible/datascience.yml  to see if Docker is listed as a requirement. 
    If it is not there, reach out to Steve Hutton about getting it re-added.
    * If you are working remotely and want to be able to connect to Jupyter, you must first set up Jupyter config.
        * Open `~/.jupyter/.jupyter_notebook_config.py` and find `c.NotebookApp.port = ####`. This is the port
        number that Jupyter will be hosted on. Jupyter's default port is 8888.
        * If the port number is anything other than 8888, you must edit the `docker-compose.yml` file to ensure Docker 
        knows where to find Jupyter. Open `docker-compose.yml` and find the `ports` section. Edit `8888:8888` to be 
        `####:####`, matching the four digit number in `c.NotebookApp.port=####`
 
 ## Run Docker
* Spin up a container
    * Make sure you’re working in the insurance-requirements directory where the docker-compose.yml file lives. Spin up 
    a new container with the command `docker-compose run --service-ports --name <container_name> insurance_env bash`.
    * You can specify container name to be anything you like. You can see it running with `docker-compose ps -a`, stop 
    it with `docker stop <container_name>`, and remove it with `docker rm <container_name>`. Note that removing the 
    container will permanently delete any files that you created/modified on the container that were not mounted from 
    the host filesystem.
    * The first time you run a container, Docker pulls the image from DockerHub and installs all dependencies (may take 
    a bit). You can always do this manually with `docker pull <image_name>`, using the `image:<image_name>` found in the 
    `docker-compose.yml` file.
    * If your prompt looks something like `root@ee864182468f:~#` then you have successfully started the container! You 
    can use `exit` to jump out of the container. Note the container will still be running and you can re-enter it with
    `docker exec -it <container_name> bash`. You can have multiple shell sessions in the same container using `docker
    exec`!
* **LOCAL** Connect to Jupyter
    * Once inside your container, `jupyter notebook --ip 0.0.0.0 --port 8888 --no-browser 
    --allow-root --NotebookApp.token='kwh'`. You can customize the `--NotebookApp.token=''` to be any string you like.
    * You can access Jupyter at `localhost:8888` in your browser. When prompted for a password or token by the 
    browser, enter the value you set `--NotebookApp.token` equal to.
* **REMOTE** Connect to Jupyter
    * Once inside your container, `--config=~/.jupyter/jupyter_application_config.py`.
    * You can access Jupyter from your local machine using the IP of the server and port `###.##.###.##:<PORT>`.
* Connect to Postgres **TODO: Is this part necessary? If we're moving away from local DB, then there is no need for this
to be a component of Docker.**