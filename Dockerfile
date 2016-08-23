FROM ruby:2.3

ADD ./ /tests
WORKDIR /tests

RUN sed -i "s/httpredir.debian.org/ftp.us.debian.org/" /etc/apt/sources.list
RUN chmod +x ./bin/* && ./bin/prepare

ENTRYPOINT ["/tests/bin/run"]
