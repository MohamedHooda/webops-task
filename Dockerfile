FROM ruby:2.5.1-alpine

ENV BUNDLER_VERSION=2.0.2

RUN apk add --update --no-cache \
      binutils-gold \
      build-base \
      curl \
      file \
      g++ \
      gcc \
      git \
      less \
      libstdc++ \
      libffi-dev \
      libc-dev \
      linux-headers \
      libxml2-dev \
      libxslt-dev \
      libgcrypt-dev \
      make \
      netcat-openbsd \
      openssl \
      pkgconfig \
      postgresql-dev \
      python \
      tzdata \
      yarn 

RUN apk update && apk upgrade && apk add ruby ruby-json ruby-io-console ruby-bundler ruby-irb ruby-bigdecimal tzdata postgresql-dev && apk add nodejs-current && apk add curl-dev ruby-dev build-base libffi-dev && apk add build-base libxslt-dev libxml2-dev ruby-rdoc mysql-dev sqlite-dev



RUN gem install bundler -v 2.0.2

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN bundle config build.nokogiri --use-system-libraries

RUN bundle check || bundle install

COPY package.json yarn.lock ./
# COPY /var/run/mysqld/mysqld.sock /host/mysql/mysqld.sock

# RUN yarn install --check-files

COPY . ./

RUN bundle exec rake webpacker:compile
RUN chmod +x ./entrypoints/docker-entrypoint.sh
RUN chmod +x ./entrypoints/prepare-db.sh
RUN chmod +x ./entrypoints/sidekiq-entrypoint.sh

CMD ["sh","./entrypoints/docker-entrypoint.sh"]