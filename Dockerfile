FROM ruby:2.2

ADD ./ /tests
WORKDIR /tests

RUN chmod +x ./bin/*; ./bin/prepare
