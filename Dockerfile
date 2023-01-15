# syntax=docker/dockerfile:1
FROM ruby:3.2
RUN apt-get update -qq && apt-get install -y postgresql-client build-essential autoconf bison libssl-dev libyaml-dev libreadline-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm-dev libpq-dev curl nodejs npm ruby-full
WORKDIR /contact-api
COPY Gemfile /contact-api/Gemfile
COPY Gemfile.lock /contact-api/Gemfile.lock
RUN bundle install

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Configure the main process to run when running the image
CMD ["rails", "server", "-b", "0.0.0.0"]