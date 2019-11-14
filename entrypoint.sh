#!/bin/sh

set -e

cd "$GITHUB_WORKSPACE" || exit

export REVIEWDOG_GITHUB_API_TOKEN="${GITHUB_TOKEN}"

if [ "${INPUT_BUNDLE}" != 'true' ]; then [ "${INPUT_BUNDLE}" = 'false' ]; fi

if [ "${INPUT_BUNDLE}" == 'true' ]; then
  bundle install
  bundle exec rubocop -v
  bundle exec rubocop | reviewdog -f=rubocop -name="rubocop" -reporter=github-pr-review
else
  gem install rubocop
  for i in "${INPUT_RUBOCOP_PLUGINS[@]}"
  do
    gem install "$i"
  done
  rubocop | reviewdog -f=rubocop -name="rubocop" -reporter=github-pr-review
fi
