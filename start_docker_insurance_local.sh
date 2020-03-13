#!/bin/bash
docker rm ins_develop

NETWORKFLAG=$(grep "network_mode: host" ./docker-compose.yml |sed -e 's/[[:space:]]*//' |  head -c 1)
JUPYTERPEMFLAG=$(grep "\- /etc/jupyter-kwha-cert:/etc/jupyter-kwha-cert" ./docker-compose.yml |sed -e 's/[[:space:]]*//' |  head -c 1)

if [ "$NETWORKFLAG" != "#" ]; then
    sed -i '' 's/network_mode/#&/' ./docker-compose.yml
fi

if [ "$JUPYTERPEMFLAG" != "#" ]; then
    sed -i '' 's/\- \/etc\/jupyter-kwha-cert/#&/' ./docker-compose.yml
fi

if [ "$1" == "--start-jupyter" ]; then
    docker-compose run --service-ports --name ins_develop insurance_env \
        jupyter notebook --ip 0.0.0.0 --port 8888 --no-browser --allow-root --NotebookApp.token='kwh'
elif [ "$1" == "" ]; then
    docker-compose run --service-ports \
	-v /run/host-services/ssh-auth.sock:/run/host-services/ssh-auth.sock \
	-e SSH_AUTH_SOCK="/run/host-services/ssh-auth.sock" \
	--name ins_develop insurance_env bash
else
    echo "Invalid arg. Please indicate --start-jupyter if you want to start Jupyter."\
        "Don't add an argument if you want to exec into bash on docker startup."
fi

