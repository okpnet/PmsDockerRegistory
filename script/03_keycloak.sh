echo 'keycloak image'
docker pull quay.io/keycloak/keycloak:26.3.3
docker tag quay.io/keycloak/keycloak:26.3.3 ${REGISTRY_HOST}:${REGISTRY_PORT}/quay.io/keycloak/keycloak:latest
docker push ${REGISTRY_HOST}:${REGISTRY_PORT}/quay.io/keycloak/keycloak:latest