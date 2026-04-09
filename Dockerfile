# --- Build stage: Jekyll ---
FROM ruby:3.2-slim AS builder

RUN apt-get update && apt-get install -y build-essential && rm -rf /var/lib/apt/lists/*

WORKDIR /site

COPY Gemfile ./
RUN bundle install

COPY . .
RUN rm -f Gemfile.lock
RUN JEKYLL_ENV=production bundle exec jekyll build --config _config.yml,_config.prod.yml

# --- Runtime stage: nginx ---
FROM nginx:alpine

COPY --from=builder /site/_site /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
