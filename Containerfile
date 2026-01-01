# syntax=docker/dockerfile:1
# check=error=true

# This Dockerfile is designed for production, not development. Use with Kamal or build'n'run by hand:
# docker build -t blog .
# docker run -d -p 80:80 -e RAILS_MASTER_KEY=<value from config/master.key> --name blog blog

# For a containerized dev environment, see Dev Containers: https://guides.rubyonrails.org/getting_started_with_devcontainer.html

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version
ARG RUBY_VERSION=3.4.8
FROM ruby:$RUBY_VERSION-slim

# Rails app lives here
ADD . /rails
WORKDIR /rails

# Install base packages
RUN apt-get update -qq
RUN apt-get install --no-install-recommends -y curl libjemalloc2 libpq-dev \
            build-essential pkg-config libyaml-dev libvips

# Install application gems
RUN bundle config set --local without 'development test'
RUN bundle install

ENV RAILS_ENV production

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile -j 0 app/ lib/

# Precompiling assets for production without requiring secret RAILS_MASTER_KEY
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

# Entrypoint prepares the database.
ENTRYPOINT ["/rails/bin/entrypoint"]

CMD ["rails", "server", "-b", "0.0.0.0"]
