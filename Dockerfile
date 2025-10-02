FROM ubuntu:24.04@sha256:47d12cfcd8a60e27ffe5cb3471487c491ab2093acd8daeee9751c250a3a10c54

LABEL org.opencontainers.image.source https://github.com/izumin5210/dotfiles

WORKDIR /dotfiles

RUN apt-get update \
  && apt-get install -y curl unzip zip \
  && rm -rf /var/lib/apt/lists/*

COPY . .

RUN ./bin/deploy-config-files
