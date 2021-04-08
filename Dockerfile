FROM ruby:3.0.0

RUN apt-get update -qq && apt-get install -y npm
# nodejsのバージョンを指定
RUN curl -sL https://deb.nodesource.com/setup_9.x | bash
RUN apt-get install -y nodejs
RUN npm install -g yarn

RUN mkdir /usr/src/app
WORKDIR /usr/src/app
COPY Gemfile /usr/src/app/Gemfile
COPY Gemfile.lock /usr/src/app/Gemfile.lock
RUN bundle install
COPY . /usr/src/app