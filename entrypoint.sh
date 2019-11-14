#!/bin/sh

set -e

cd "$GITHUB_WORKSPACE" || exit

export REVIEWDOG_GITHUB_API_TOKEN="${GITHUB_TOKEN}"

gems=$(echo "rubocop ${INPUT_RUBOCOP_PLUGINS}" | xargs)

if [ "${INPUT_BUNDLE}" != 'true' ]; then [ "${INPUT_BUNDLE}" = 'false' ]; fi

if [ "${INPUT_BUNDLE}" == 'true' ]; then
  bundle install
  bundle exec rubocop -v
  bundle exec rubocop | reviewdog -f=rubocop -name="rubocop" -reporter=github-pr-check
else
  gem install "$gems"
  rubocop | reviewdog -f=rubocop -name="rubocop" -reporter=github-pr-check
fi
