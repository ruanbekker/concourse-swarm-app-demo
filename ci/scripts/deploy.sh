#!/usr/bin/env sh

export DOCKER_HOST="localhost:2376"
#export

echo ${DOCKER_SWARM_KEY} | sed -e 's/\(KEY-----\)\s/\1\n/g; s/\s\(-----END\)/\n\1/g' | sed -e '2s/\s\+/\n/g' > key.pem
#echo ${DOCKER_SWARM_KEY} > key.pem
chmod 600 key.pem

screen -S \
  sshtunnel -m -d sh -c \
  "ssh -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null -i ./key.pem -NL localhost:2376:/var/run/docker.sock root@$DOCKER_SWARM_HOSTNAME"

sleep 5
docker login -u $DOCKER_HUB_USER -p $DOCKER_HUB_PASSWORD
docker stack deploy --prune -c ./main-repo/ci/docker-compose.${ENVIRONMENT}.yml $SERVICE_NAME --with-registry-auth

if [ $? != "0" ]
  then
    echo "deploy failure for: $SERVICE_NAME"
    screen -S sshtunnel -X quit
    exit 1
  else
    set -x
    echo "deploy success for: $SERVICE_NAME"
    screen -S sshtunnel -X quit
fi

