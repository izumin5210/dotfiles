FROM ubuntu:26.04@sha256:53958ec7b67c2c9355df922dd08dbf0360611f8c3cdb656875e81873db9ffdba

LABEL org.opencontainers.image.source https://github.com/izumin5210/dotfiles

WORKDIR /dotfiles

RUN apt-get update \
  && apt-get install -y curl unzip zip \
  && rm -rf /var/lib/apt/lists/*

COPY . .

RUN ./bin/deploy-config-files
