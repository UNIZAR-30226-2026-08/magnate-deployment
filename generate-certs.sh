#!/bin/bash

# Script for generating a self-signed certificate in the directory structure
# used by docker compose

source .env

CERT_DIR="ssl-certs"
if [ ! -d "$CERT_DIR" ]; then
  mkdir -p "$CERT_DIR"
  echo "Created directory: $CERT_DIR"
fi


SAN="DNS:localhost,IP:127.0.0.1"

if [ -n "$SSL_BACKEND_IP" ]; then
  SAN="$SAN,IP:$SSL_BACKEND_IP"
fi

if [ -n "$SSL_DOMAIN" ]; then
  CN="$SSL_DOMAIN"
  SAN="$SAN,DNS:$SSL_DOMAIN"
else
  CN="${SSL_BACKEND_IP:-localhost}"
fi


echo "Generating self-signed 2048-bit RSA certificate..."
echo "  CN:  $CN"
echo "  SAN: $SAN"

openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout "$CERT_DIR/privkey.pem" \
  -out "$CERT_DIR/fullchain.pem" \
  -subj "/C=ES/ST=Local/L=Local/O=Development/CN=$CN" \
  -addext "subjectAltName=$SAN"

if [ $? -eq 0 ]; then
  echo "Success! Certificates are ready to use."
  echo "Private Key: $CERT_DIR/privkey.pem"
  echo "Certificate: $CERT_DIR/fullchain.pem"
else
  echo "Error: Failed to generate certificates. Please ensure OpenSSL is installed."
fi
