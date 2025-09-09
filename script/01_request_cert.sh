#!/usr/bin/env bash
# 01_request_cert.sh
mkdir -p ./certbot/www

# 初回証明書取得（スタンドアロンモード）
docker run --rm   -v /etc/letsencrypt:/etc/letsencrypt   -v /var/lib/letsencrypt:/var/lib/letsencrypt   -v ./certbot/www:/var/www/certbot   certbot/certbot certonly --standalone   --preferred-challenges http   --agree-tos   --no-eff-email   --email ${EMAIL}   -d ${REGISTRY_HOST}
