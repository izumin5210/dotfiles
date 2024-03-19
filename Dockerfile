FROM ubuntu:20.04

LABEL org.opencontainers.image.source https://github.com/izumin5210/dotfiles

WORKDIR /dotfiles

RUN apt-get update \
  && apt-get install -y curl unzip zip \
  && rm -rf /var/lib/apt/lists/*

COPY . .

RUN apt-get update \
  && ./bin/setup-codespace \
  && rm -rf /var/lib/apt/lists/*
