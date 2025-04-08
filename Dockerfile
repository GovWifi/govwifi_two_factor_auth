FROM ruby:3.4.2-alpine

# required for certain linting tools that read files, such as erb-lint
ENV \
  LANG='C.UTF-8' \
  RACK_ENV=test

WORKDIR /usr/src/app

RUN apk add build-base yaml-dev libffi-dev tzdata

COPY . .

RUN bundle install

COPY . .

CMD ["bundle", "exec", "rake", "spec"]
