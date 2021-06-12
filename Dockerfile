FROM ruby:3.0.1

# install rails dependencies
RUN apt-get clean all && apt-get update -qq && apt-get install -y build-essential libpq-dev \
    curl gnupg2 apt-utils default-libmysqlclient-dev git libcurl3-dev cmake \
    libssl-dev pkg-config openssl imagemagick file nodejs yarn npm netcat

RUN npm install --global yarn


RUN mkdir /rails-app
WORKDIR /rails-app

# Adding gems
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install
RUN yarn install --check-files


COPY . /rails-app

# Add a script to be executed every time the container starts.
COPY startup.sh /usr/bin/
COPY ./config/docker/asset-pre-compile.sh /usr/bin/
COPY ./config/docker/prepare-db.sh /usr/bin/
RUN chmod +x /usr/bin/startup.sh
RUN chmod +x /usr/bin/asset-pre-compile.sh
RUN chmod +x /usr/bin/prepare-db.sh
ENTRYPOINT ["startup.sh"]