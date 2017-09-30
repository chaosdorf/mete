FROM ruby:2.4
RUN apt-get update && apt-get -y install nodejs
RUN groupadd -r app && useradd -r -d /app -g app app
COPY . /app
WORKDIR /app
ENV RAILS_ENV=production
VOLUME var
RUN chown -R app:app /app
USER app
RUN bundle install && bundle exec rake assets:precompile
CMD bundle exec unicorn
EXPOSE 8080
