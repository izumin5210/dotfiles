FROM ubuntu:24.04@sha256:72297848456d5d37d1262630108ab308d3e9ec7ed1c3286a32fe09856619a782

LABEL org.opencontainers.image.source https://github.com/izumin5210/dotfiles

WORKDIR /dotfiles

RUN apt-get update \
  && apt-get install -y curl unzip zip \
  && rm -rf /var/lib/apt/lists/*

COPY . .

RUN ./bin/deploy-config-files
