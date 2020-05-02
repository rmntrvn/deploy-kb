FROM node:10.20.1-alpine3.9

RUN mkdir /wiki
WORKDIR /wiki
COPY . /wiki/
RUN mv config.sample.yml config.yml

EXPOSE 3000

CMD [ "node","server" ]
