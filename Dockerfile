FROM ruby:2.6.5-alpine

RUN wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh| sh -s -- -b /usr/local/bin/ v0.9.13
RUN apk --update add build-base git curl gnupg2 && \
  rm -rf /var/lib/apt/lists/* && \
  rm /var/cache/apk/*

RUN gem install bundler

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
