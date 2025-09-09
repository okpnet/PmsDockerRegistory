docker pull postgres:14
docker tag postgres:14 ${REGISTRY_HOST}:${REGISTRY_PORT}/postgres:14
docker push ${REGISTRY_HOST}:${REGISTRY_PORT}/postgres:14