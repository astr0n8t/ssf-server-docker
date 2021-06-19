FROM ubuntu:latest

RUN mkdir -p /etc/ssf && mkdir -p /certs && apt update && apt install openssl unzip wget -y && wget https://github.com/securesocketfunneling/ssf/releases/download/3.0.0/ssf-linux-x86_64-3.0.0.zip \
    && unzip -j ssf-linux-x86_64-3.0.0.zip ssf-linux-x86_64-3.0.0/ssfd -d /usr/bin/ && apt remove unzip wget -y

COPY /root /

ENV GATEWAY_PORTS=0
ENV RELAY_ONLY=0 
ENV BIND_ADDRESS=

EXPOSE 8011
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/bin/ssfd", "-c", "/etc/ssf/ssf.conf"]

