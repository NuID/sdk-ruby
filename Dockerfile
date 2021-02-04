FROM nuid/proving-ground:latest AS nuid-pg
FROM ruby:2.7-alpine
LABEL maintainer="NuID Developers <dev@nuid.io>"
WORKDIR /nuid/sdk-ruby
ADD . .
RUN apk add git
RUN gem install bundler
RUN bundle install
COPY --from=nuid-pg /usr/local/bin/* /usr/local/bin/
RUN rm /usr/local/bin/docker-entrypoint.sh
COPY --from=nuid-pg /usr/bin/nuid-pg /usr/bin/nuid-pg
COPY --from=nuid-pg /nuid /nuid
# ENTRYPOINT "rake test"
CMD /bin/sh
