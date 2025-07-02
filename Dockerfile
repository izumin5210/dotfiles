FROM ubuntu:24.04@sha256:440dcf6a5640b2ae5c77724e68787a906afb8ddee98bf86db94eea8528c2c076

LABEL org.opencontainers.image.source https://github.com/izumin5210/dotfiles

WORKDIR /dotfiles

RUN apt-get update \
  && apt-get install -y curl unzip zip \
  && rm -rf /var/lib/apt/lists/*

COPY . .

RUN ./bin/deploy-config-files
