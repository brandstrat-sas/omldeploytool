FROM ubuntu:latest

RUN apt update \
&& apt install -y wget git \
&& cd ~ \
&& wget https://github.com/digitalocean/doctl/releases/download/v1.92.0/doctl-1.92.0-linux-amd64.tar.gz \
&& tar xf ~/doctl-1.92.0-linux-amd64.tar.gz \
&& mv ~/doctl /usr/local/bin


