FROM ruby:2.3

RUN gem install serverspec

RUN useradd -m test

ENV HOME /home/test
WORKDIR $HOME

COPY install.sh .
RUN chown test install.sh

USER test

RUN ./install.sh
