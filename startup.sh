#! /bin/sh



set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /rails-app/tmp/pids/server.pid

# exec "$@"

# Prepare DB (Migrate - If not? Create db & Migrate)
sh ./config/docker/prepare-db.sh

# Pre-comple app assets
sh ./config/docker/asset-pre-compile.sh

# Start Application
# bundle exec puma -C config/puma.rb