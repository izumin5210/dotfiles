FROM ubuntu:24.04@sha256:353675e2a41babd526e2b837d7ec780c2a05bca0164f7ea5dbbd433d21d166fc

LABEL org.opencontainers.image.source https://github.com/izumin5210/dotfiles

WORKDIR /dotfiles

RUN apt-get update \
  && apt-get install -y curl unzip zip \
  && rm -rf /var/lib/apt/lists/*

COPY . .

RUN ./bin/deploy-config-files
