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
  if [ -n "${INPUT_RUBOCOP_PLUGINS}" ]; then
    plugin_array=$(echo "${INPUT_RUBOCOP_PLUGINS}" | cut -d ":"  --output-delimiter=" " -f 1-)
    for i in "${plugin_array[@]}"
    do
      gem install "$i"
    done
  fi
  rubocop | reviewdog -f=rubocop -name="rubocop" -reporter=github-pr-review
fi
