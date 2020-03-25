#!/bin/bash
docker rm ins_develop

if [ "$1" == "--start-jupyter" ]; then
    docker-compose -f local-docker-compose.yml run -d --service-ports \
	-v /run/host-services/ssh-auth.sock:/run/host-services/ssh-auth.sock \
        -e SSH_AUTH_SOCK="/run/host-services/ssh-auth.sock" \
	--name ins_develop insurance_env && \
        docker exec ins_develop jupyter notebook --ip 0.0.0.0 --port 8888 --no-browser --allow-root --NotebookApp.token='kwh'
#elif [ "$1" == "--create-dbs" ]; then
#    docker-compose -f local-docker-compose.yml run -d --service-ports \
#        -v /run/host-services/ssh-auth.sock:/run/host-services/ssh-auth.sock \
#        -e SSH_AUTH_SOCK="/run/host-services/ssh-auth.sock" \
#        --name ins_develop insurance_env && \
#	docker exec ins_develop bash \
#        docker exec -w /root/insurance/marvin ins_develop python -m utils.restore_db && \
#        docker exec -w /root/insurance ins_develop python ins_utils/download_koeppen_sql.py && \
#	docker exec -w /root/insurance ins_develop bash gunzip koeppen.sql.gz && \
#	docker exec -w /root/insurance ins_develop bash createdb koeppen && \
#	docker exec -w /root/insurance ins_develop bash psql koeppen < koeppen.sql
elif [ "$1" == "" ]; then
    docker-compose -f local-docker-compose.yml run -d --service-ports \
	-v /run/host-services/ssh-auth.sock:/run/host-services/ssh-auth.sock \
	-e SSH_AUTH_SOCK="/run/host-services/ssh-auth.sock" \
	--name ins_develop insurance_env && \
	docker exec -it ins_develop bash
else
    echo "Invalid arg. Please indicate --start-jupyter if you want to start Jupyter."\
        "Don't add an argument if you want to exec into bash on docker startup."
fi

