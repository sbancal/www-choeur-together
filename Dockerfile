FROM ruby:3.4-alpine

RUN apk add --no-cache \
    build-base \
    git \
    nodejs \
    npm

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN bundle install

# Note: The right app content (main or next) has to be copied to the container run context.

EXPOSE 4000

ENV JEKYLL_ENV=development

CMD ["bundle", "exec", "jekyll", "serve", "--config", "_config.yml,_config_dev.yml", "--host", "0.0.0.0", "--port", "4000", "--livereload"]
