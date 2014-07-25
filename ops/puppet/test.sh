#!/usr/bin/env bash
echo "ruby version: $(ruby -e 'print RUBY_VERSION')"
if [ "$(ruby -e 'print RUBY_VERSION')" = '2.1.1' ]
then
    echo "don't Need a ruby install"
else
    echo " need a ruby install"
fi

