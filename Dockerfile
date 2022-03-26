FROM ruby:2.6.5

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client yarn
RUN apt-get update && apt-get install -y cron

RUN mkdir /var/app
RUN mkdir /var/app/current
ENV APP_ROOT /var/app/current

WORKDIR $APP_ROOT

COPY Gemfile $APP_ROOT/Gemfile
COPY Gemfile.lock $APP_ROOT/Gemfile.lock

RUN gem uninstall bundler
RUN gem install bundler:2.1.4
RUN bundle install --jobs=4

EXPOSE 80
COPY . $APP_ROOT
CMD ["rails", "s", "-b", "0.0.0.0", "-p", "80"]