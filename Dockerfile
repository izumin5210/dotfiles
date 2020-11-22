FROM ubuntu:20.04

WORKDIR /dotfiles

RUN apt-get update \
  && apt-get install -y curl unzip zip \
  && rm -rf /var/lib/apt/lists/*

ENV MITAMAE_VERSION 1.11.7
RUN url="https://github.com/itamae-kitchen/mitamae/releases/download/v${MITAMAE_VERSION}/mitamae-x86_64-linux"; \
  mkdir bin \
  && curl -sfL -o /usr/local/bin/mitamae $url \
  && chmod +x /usr/local/bin/mitamae

# COPY . .

# RUN apt-get update \
#   && ./bin/mitamae local lib/recipe.rb \
#   && rm -rf /var/lib/apt/lists/*
