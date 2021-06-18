FROM elixir:latest

RUN apt-get update && \
    apt-get install -y postgresql-client && \
    apt-get install -y inotify-tools && \
    curl -fsSL https://deb.nodesource.com/setup_14.x | bash - && \
    apt-get install -y nodejs && \
    curl -L https://npmjs.org/install.sh | sh && \
    mix local.hex --force && \
    mix archive.install hex phx_new 1.5.9 --force && \
    mix local.rebar --force

RUN mkdir jeopardixir

COPY . /jeopardixir

WORKDIR /jeopardixir

RUN cd assets && npm install && node node_modules/webpack/bin/webpack.js --mode development

CMD ["./entrypoint.sh"]