#!/bin/bash
set -e
bundle install --system
RAILS_ENV=${RAILS_ENV} bundle exec rails tmp:cache:clear
RAILS_ENV=${RAILS_ENV} bundle exec rails assets:precompile assets:clean --trace
RAILS_ENV=${RAILS_ENV} bundle exec rails db:create
RAILS_ENV=${RAILS_ENV} bundle exec rails db:migrate
rm -f tmp/pids/server.pid
RAILS_ENV=${RAILS_ENV} bundle exec pumactl -F config/puma.rb start
