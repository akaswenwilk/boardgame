FROM ruby:2.7

RUN apt-get update
RUN apt-get install vim --assume-yes
WORKDIR /app
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle

COPY . /app

EXPOSE 9292

CMD ["bundle", "exec", "rackup", "-o", "0.0.0.0"]
