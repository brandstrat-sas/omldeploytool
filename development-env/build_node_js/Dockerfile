#FROM node:16.14.0-alpine
FROM node:21.6-alpine

ENV NODE_OPTIONS=--openssl-legacy-provider

RUN apk add --update python3 make g++ && ln -sf python3 /usr/bin/python
WORKDIR /home/app
RUN npm install -g @vue/cli
