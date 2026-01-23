FROM ubuntu:24.04@sha256:cd1dba651b3080c3686ecf4e3c4220f026b521fb76978881737d24f200828b2b

LABEL org.opencontainers.image.source https://github.com/izumin5210/dotfiles

WORKDIR /dotfiles

RUN apt-get update \
  && apt-get install -y curl unzip zip \
  && rm -rf /var/lib/apt/lists/*

COPY . .

RUN ./bin/deploy-config-files
