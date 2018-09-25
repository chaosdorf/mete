FROM ruby:2.4-alpine
RUN apk --no-cache add nodejs git g++ make postgresql-dev sqlite-dev tzdata file imagemagick
WORKDIR /app
COPY Gemfile /app
COPY Gemfile.lock /app
VOLUME /app/public/system
RUN bundle install
COPY . /app
RUN bundle exec rake assets:precompile
ENTRYPOINT ["./docker-entrypoint.sh"]
CMD ["rails", "server", "-p", "8080"]
EXPOSE 8080
