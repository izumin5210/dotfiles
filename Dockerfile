FROM ruby:2.3

RUN gem install serverspec

RUN useradd -m test

ENV HOME /home/test
WORKDIR $HOME

COPY install.sh .
COPY scripts ./scripts
RUN chown test install.sh
RUN chown test -R scripts/*.sh

USER test

COPY spec ./spec
COPY Rakefile .
COPY .rspec .

RUN ./install.sh

CMD rake spec
