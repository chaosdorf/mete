FROM ruby:2.4
RUN apt-get update && apt-get -y install nodejs git
COPY . /app
WORKDIR /app
VOLUME /app/public/system
RUN bundle install && bundle exec rake assets:precompile
ENTRYPOINT ["./docker-entrypoint.sh"]
CMD ["rails", "server", "-p", "8080"]
EXPOSE 8080
