#!/bin/sh

set -e

cd "$GITHUB_WORKSPACE" || exit
[ -z "$GITHUB_TOKEN" ] && echo "Empty" || echo "Not empty"
export REVIEWDOG_GITHUB_API_TOKEN="$GITHUB_TOKEN"

if [ "${INPUT_BUNDLE}" != 'true' ]; then [ "${INPUT_BUNDLE}" = 'false' ]; fi

if [ "${INPUT_BUNDLE}" = 'true' ]; then
  bundle install && \
  bundle exec rubocop -v && \
  bundle exec rubocop | reviewdog -f=rubocop -name="rubocop" -reporter=github-pr-review
else
  gem install rubocop rubocop-performance rubocop-rails rubocop-minitest rubocop-rspec && \
  rubocop | reviewdog -f=rubocop -name="rubocop" -reporter=github-pr-review
fi
