FROM ruby:3.0.0

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

RUN set -ex \
    && wget -qO- https://deb.nodesource.com/setup_10.x | bash - \
    && apt-get update \
    && apt-get install -y \
                 default-mysql-client \
                 nodejs \
                 vim \
                 --no-install-recommends \
    && rm -rf /var/lib/apt/lists/* \
    && npm install -g yarn

ADD Gemfile /usr/src/app/
ADD Gemfile.lock /usr/src/app/
RUN bundle install --system

ADD . /usr/src/app

ENV HISTFILE=/usr/src/app/.bash_history
ENV LANG=ja_JP.UTF-8

EXPOSE 3000
CMD bin/start_server.sh