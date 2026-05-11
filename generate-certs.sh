#!/bin/bash

# Script for generating a self-signed certificate in the directory structure
# used by docker compose

CERT_DIR="ssl-certs"

if [ ! -d "$CERT_DIR" ]; then
  mkdir -p "$CERT_DIR"
  echo "Created directory: $CERT_DIR"
fi

echo "Generating self-signed 2048-bit RSA certificate..."

openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout "$CERT_DIR/privkey.pem" \
  -out "$CERT_DIR/fullchain.pem" \
  -subj "/C=ES/ST=Local/L=Local/O=Development/CN=localhost" \
  -addext "subjectAltName=DNS:localhost,IP:127.0.0.1" # Fix this?

if [ $? -eq 0 ]; then
  echo "Success! Certificates are ready to use."
  echo "Private Key: $CERT_DIR/privkey.pem"
  echo "Certificate: $CERT_DIR/fullchain.pem"
else
  echo "Error: Failed to generate certificates. Please ensure OpenSSL is installed."
fi
