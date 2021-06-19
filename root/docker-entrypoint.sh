#!/bin/bash

args="${@}"
if [ "$1" = '/usr/bin/ssfd' ]; then
    
    if [ ! -d "/certs/trusted" ]; then
        mkdir -p /certs/trusted
    fi

    if [ ! -f "/certs/extfile.txt" ]; then
        cp /staged/certs/extfile.txt /certs/extfile.txt
    fi

    if [ ! -f "/etc/ssf/ssf.conf" ]; then
        cp  /staged/etc/ssf/ssf.conf /etc/ssf/ssf.conf
    fi

    if [ ! -f "/certs/dh4096.pem" ]; then
        openssl dhparam -out /certs/dh4096.pem -outform PEM 4096
    fi

    if [ ! -f "/certs/trusted/ca.crt" ]; then
        openssl req -x509 -nodes -newkey rsa:4096 -keyout /certs/ca.key -out /certs/trusted/ca.crt -days 3650 -batch 
    fi

    if [ ! -f "/certs/private.key" ]; then
        openssl req -newkey rsa:4096 -nodes -keyout /certs/private.key -out /certs/certificate.csr -batch
    fi

    if [ ! -f "/certs/certificate.crt" ]; then
        openssl x509 -extfile /certs/extfile.txt -extensions v3_req_p -req -sha1 -days 3650 \
                -CA /certs/trusted/ca.crt -CAkey /certs/ca.key -CAcreateserial -in /certs/certificate.csr -out /certs/certificate.crt 
    fi

    if [ $GATEWAY_PORTS -eq "1" ]; then
        args+=( "-g" )
    fi

    if [ $RELAY_ONLY -eq "1" ]; then
        args+=( "-R" )
    fi

    if [ $BIND_ADDRESS ]; then
        args+=( "-l $BIND_ADDRESS")
    fi

fi
echo ${args[@]}
exec ${args[@]}
