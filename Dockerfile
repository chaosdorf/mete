FROM ruby:3.2-alpine as main
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

FROM node:18-alpine as tabletFix
RUN corepack enable
RUN apk add --no-cache brotli
WORKDIR /app
COPY tabletFix/ /app
RUN pnpm i
COPY --from=main /app/public/assets /app/assets
RUN pnpm tabletFix

FROM main
COPY --from=tabletFix /app/assets /app/public/assets
