#!/usr/bin/env bash
cd /app
echo 'running first time install, this may take a while...'
bundle install
rake db:create
echo 'first time install done!'