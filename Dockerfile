FROM ruby:onbuild
ENV RAILS_ENV=production
VOLUME /usr/src/app/db/production.rb
RUN bundle exec rake assets:precompile
CMD bundle exec unicorn
EXPOSE 8080
