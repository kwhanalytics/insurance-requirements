#!/bin/bash
docker rm ins_develop

if [ "$1" == "--start-jupyter" ]; then
    docker-compose run --service-ports --name ins_develop insurance_env \
        jupyter notebook --ip 0.0.0.0 --port 8888 --no-browser --allow-root --NotebookApp.token='kwh'
elif ["$1" == ""]; then
    docker-compose run --service-ports --name ins_develop insurance_env bash
else
    echo "Invalid arg. Please indicate --start-jupyter if you want to start Jupyter."\
        "Don't add an argument if you want to exec into bash on docker startup."
fi

