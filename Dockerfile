FROM ruby:2.4
RUN apt-get update && apt-get -y install nodejs git
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
