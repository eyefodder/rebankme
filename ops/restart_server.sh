#!/usr/bin/env bash
cd /app
kill `cat /app/tmp/pids/server.pid`
rails s -d