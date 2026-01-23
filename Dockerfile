FROM ruby:3.3-alpine AS main
RUN apk --no-cache add nodejs git g++ make postgresql-dev sqlite-dev tzdata file imagemagick yaml-dev libffi-dev
WORKDIR /app
COPY Gemfile /app
COPY Gemfile.lock /app
VOLUME /app/public/system
RUN bundle config --local build.sassc --disable-march-tune-native
RUN bundle config set force_ruby_platform true
# For some reason bigdecimal needs to be installed seperatly - otherwise docker build segfaults (On a macbook pro M2 Pro on linux/amd64 - linux/arm64 works fine)
RUN gem install bigdecimal:3.2.3
RUN bundle install
COPY . /app
RUN bundle exec rake assets:precompile
ENTRYPOINT ["./docker-entrypoint.sh"]
CMD ["rails", "server", "--binding", "[::]", "--port", "80"]
EXPOSE 80
