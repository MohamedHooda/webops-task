#!/bin/sh

set -e

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi
gem install rack-cors
bundle exec sidekiq
find . -name mysqlx.sock