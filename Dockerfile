FROM ruby:2.7-alpine
RUN apk --no-cache add nodejs git g++ make postgresql-dev sqlite-dev tzdata file imagemagick
WORKDIR /app
COPY Gemfile /app
COPY Gemfile.lock /app
VOLUME /app/public/system
RUN bundle config --local build.sassc --disable-march-tune-native
RUN bundle install
COPY . /app
RUN bundle exec rake assets:precompile
ENTRYPOINT ["./docker-entrypoint.sh"]
CMD ["rails", "server", "--binding", "[::]", "--port", "80"]
EXPOSE 80
