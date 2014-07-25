#!/usr/bin/env bash
cd /app
echo 'starting rails app'
bundle install
rake db:migrate
rake db:seed
rails s -d
echo 'rails app started - you can find it on localhost:3001'
