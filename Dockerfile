FROM ruby:2.4
RUN apt-get update && apt-get -y install nodejs git
RUN groupadd -r app && useradd -r -d /app -g app app
COPY . /app
WORKDIR /app
RUN chown -R app:app /app
USER app
RUN bundle install && bundle exec rake assets:precompile
ENTRYPOINT ["./docker-entrypoint.sh"]
CMD ["rails", "server", "-p", "8080"]
EXPOSE 8080
