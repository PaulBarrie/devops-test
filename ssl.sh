#!/bin/bash

function generate_cert() {
    mkdir certs
    openssl req -x509 -newkey rsa:4096 -sha256 -nodes -keyout certs/tls.key -out certs/tls.crt -subj "/CN=$1" -days 365
}

generate_cert uploader-app.polo.localhost