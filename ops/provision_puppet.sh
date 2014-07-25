#!/usr/bin/env bash

echo "install puppet"
id -u puppet &>/dev/null || useradd --comment "Puppet" --no-create-home --system --shell /bin/false puppet -g puppet
gem install puppet -v 3.6.2 --no-rdoc --no-ri
echo "puppet installed"