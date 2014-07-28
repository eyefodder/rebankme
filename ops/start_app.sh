#!/usr/bin/env bash
cd /app
echo 'starting rails app'
bundle install
rake db:migrate
rake db:seed
rake test:prepare
rails s -d
echo 'rails app started - you can find it on localhost:3001'
echo '*****************************************************'
echo '*****************************************************'
echo 'The virtual machine uses rsync to keep files in sync with the host machine'
echo ''
echo 'This makes the app *much* more performant, but at the expense of a little '
echo 'bit of latency when files change. You will have to tell vagrant to keep things'
echo 'automatically synced by running the following script:'
echo '  `vagrant rsync-auto`  '
