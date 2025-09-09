echo 'Hasura graphql image'
docker pull hasura/graphql-engine:v2.46.0
docker tag hasura/graphql-engine:v2.46.0 ${REGISTRY_HOST}:${REGISTRY_PORT}/hasura/graphql-engine:latest
docker push ${REGISTRY_HOST}:${REGISTRY_PORT}/hasura/graphql-engine:latest

echo 'Hasura connector image'
docker pull hasura/graphql-data-connector:v2.46.0
docker tag hasura/graphql-data-connector:v2.46.0 ${REGISTRY_HOST}:${REGISTRY_PORT}/hasura/graphql-data-connector:latest
docker push ${REGISTRY_HOST}:${REGISTRY_PORT}/hasura/graphql-data-connector:latest

echo 'keycloak image'
docker pull ncarlier/webhookd:latest
docker tag ncarlier/webhookd:latest ${REGISTRY_HOST}:${REGISTRY_PORT}/ncarlier/webhookd:latest
docker push ${REGISTRY_HOST}:${REGISTRY_PORT}/ncarlier/webhookd:latest