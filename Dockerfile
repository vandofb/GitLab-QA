FROM ruby:2.3

ADD ./ /tests
WORKDIR /tests

RUN chmod +x ./bin/*; \
    ./bin/prepare

ENTRYPOINT ["/tests/bin/run"]
