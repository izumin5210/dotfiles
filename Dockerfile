FROM ubuntu:20.04

LABEL org.opencontainers.image.source https://github.com/izumin5210/dotfiles

WORKDIR /dotfiles

COPY . .

RUN apt-get update \
  && ./bin/setup-codespace \
  && ./bin/deploy-config-files \
  && rm -rf /var/lib/apt/lists/*
