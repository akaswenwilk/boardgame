FROM ruby:2.7

WORKDIR /app
COPY Gemfile /app/Gemfile
RUN bundle

COPY . /app

RUN cat app.rb

CMD ["ruby", "app.rb", "-o", "0.0.0.0"]
