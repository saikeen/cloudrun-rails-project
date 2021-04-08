#!/bin/bash
set -ex
source ~/.bashrc
bundle install --system
yarn install
RAILS_ENV=${RAILS_ENV} bundle exec rails db:create
RAILS_ENV=${RAILS_ENV} bundle exec rails db:migrate
rm -f tmp/pids/server.pid
bin/webpack-dev-server &
RAILS_ENV=${RAILS_ENV} bundle exec pumactl -F config/puma.rb start
