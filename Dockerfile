FROM buildpack-deps:jessie

RUN useradd -m test

ENV HOME /home/test
WORKDIR $HOME

COPY install.sh .
RUN chown test install.sh

USER test

RUN ./install.sh
