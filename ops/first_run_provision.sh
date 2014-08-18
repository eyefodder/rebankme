#!/usr/bin/env bash
echo 'updating package list'
apt-get update >/dev/null 2>&1
echo 'updated'

echo "Installing dev libraries"

apt-get install -y build-essential zlib1g-dev libssl-dev libreadline-dev >/dev/null 2>&1
apt-get install -y git-core curl libyaml-dev libcurl4-openssl-dev libsqlite-dev postgresql  >/dev/null 2>&1
apt-get install -y libpq-dev sqlite3 libsqlite3-dev bcrypt libnotify-bin >/dev/null 2>&1

echo "dev libraries installed"



echo "current ruby version: $(ruby -e 'print RUBY_VERSION')"
if [ "$(ruby -e 'print RUBY_VERSION')" = '2.1.2' ]
  then
  echo "ruby already installed, skipping"
else
  echo "Installing ruby 2.1.2"
  rm -rf /opt/vagrant_ruby
  echo 'downloading'
  curl --remote-name http://ftp.ruby-lang.org/pub/ruby/2.1/ruby-2.1.2.tar.gz >/dev/null 2>&1
  tar zxf ruby-2.1.2.tar.gz >/dev/null 2>&1
  cd ruby-2.1.2/
  echo 'configure'
  ./configure >/dev/null 2>&1
  echo 'make (this could take a while, while I make ruby, you should make tea...)'
  make  >/dev/null 2>&1
  echo 'install'
  make install >/dev/null 2>&1
  echo "ruby installed"
fi

echo "install puppet"
id -u puppet &>/dev/null || useradd --comment "Puppet" --no-create-home --system --shell /bin/false puppet -g puppet
gem install puppet -v 3.6.2 --no-rdoc --no-ri
echo "puppet installed"

echo "install bundler"
gem install bundler -v 1.6.5

echo 'install foreman'
gem install foreman
