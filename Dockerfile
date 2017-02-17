FROM ruby:2.3

WORKDIR /home/qa

RUN wget -q https://get.docker.com/builds/Linux/x86_64/docker-1.12.1.tgz && \
    tar -zxf docker-1.12.1.tgz && mv docker/docker /usr/local/bin/docker && \
    rm docker-1.12.1.tgz

COPY ./Gemfile* ./
RUN bundle install
