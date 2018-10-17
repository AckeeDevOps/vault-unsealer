FROM ruby:2.6.0-preview2-alpine3.8
MAINTAINER stepan.vrany@ackee.cz

WORKDIR /usr/src/app

copy . .

RUN bundle install --without development

CMD ["rake", "run"]
