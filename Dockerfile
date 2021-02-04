FROM ruby:2.7-alpine3.13
LABEL maintainer="NuID Developers <dev@nuid.io>"
WORKDIR /nuid/sdk-ruby
ADD . .
RUN apk add git nodejs npm
RUN gem install bundler
RUN bundle install
RUN npm install
ENV PATH=$PATH:/nuid/sdk-ruby/node_modules/.bin
CMD /bin/sh
