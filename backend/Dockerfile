FROM ruby:2.7

WORKDIR /app
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle

COPY . /app

EXPOSE 9292

CMD ["bundle", "exec", "rackup", "-o", "0.0.0.0"]
