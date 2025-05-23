FROM ruby:3.2-alpine AS main
RUN apk --no-cache add nodejs git g++ make postgresql-dev sqlite-dev tzdata file imagemagick yaml-dev libffi-dev
WORKDIR /app
COPY Gemfile /app
COPY Gemfile.lock /app
VOLUME /app/public/system
RUN bundle config --local build.sassc --disable-march-tune-native
RUN bundle config set force_ruby_platform true
RUN bundle install
COPY . /app
RUN bundle exec rake assets:precompile
ENTRYPOINT ["./docker-entrypoint.sh"]
CMD ["rails", "server", "--binding", "[::]", "--port", "80"]
EXPOSE 80

FROM node:20-alpine AS tablet_fix
RUN corepack enable
RUN apk add --no-cache brotli
WORKDIR /app
COPY tabletFix/ /app
COPY --from=main /app/public/assets /app/assets
RUN pnpm i --frozen-lockfile
RUN pnpm tabletFix

FROM main
COPY --from=tablet_fix /app/assets /app/public/assets
