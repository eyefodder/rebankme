#!/usr/bin/env bash

echo "Installing Apache and setting it up..."
apt-get update >/dev/null 2>&1
apt-get install -y apache2 >/dev/null 2>&1
rm -rf /var/www
ln -fs /vagrant /var/www
echo "Apache Installed "

echo "Installing dev libraries"
 apt-get install -y build-essential zlib1g-dev libssl-dev libreadline-dev >/dev/null 2>&1
 apt-get install -y git-core curl libyaml-dev libcurl4-openssl-dev libsqlite-dev postgresql >/dev/null 2>&1
echo "dev libraries installed"

echo "Installing ruby 2.1.1"
rm -rf /opt/vagrant_ruby
echo 'downloading'
curl --remote-name http://ftp.ruby-lang.org/pub/ruby/2.1/ruby-2.1.1.tar.gz >/dev/null 2>&1
tar zxf ruby-2.1.1.tar.gz >/dev/null 2>&1
cd ruby-2.1.1/
echo 'configure'
./configure >/dev/null 2>&1
echo 'make'
make  >/dev/null 2>&1
echo 'install'
make install >/dev/null 2>&1
echo "ruby installed"

echo "install puppet"
useradd --comment "Puppet" --no-create-home --system --shell /bin/false puppet -g puppet
gem install puppet -v 3.6.2 --no-rdoc --no-ri
puppet apply --verbose /etc/puppet/manifests/site.pp >/dev/null 2>&1
echo "puppet installed"