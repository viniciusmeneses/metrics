FROM ruby:3.1.2
WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

EXPOSE 3001

ENTRYPOINT ["sh", "bin/entry"]
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "3001"]
