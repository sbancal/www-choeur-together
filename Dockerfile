
FROM ruby:3.4

RUN apt-get update && \
        apt-get install -y --no-install-recommends \
            build-essential \
            git \
            nodejs \
            npm \
            ca-certificates && \
        rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN bundle install

# Note: The right app content (main or next) has to be copied to the container run context.

EXPOSE 4000

ENV JEKYLL_ENV=development

CMD ["bundle", "exec", "jekyll", "serve", "--config", "_config.yml,_config_dev.yml", "--host", "0.0.0.0", "--port", "4000", "--livereload"]
