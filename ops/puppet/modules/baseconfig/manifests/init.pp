class baseconfig{
  exec { 'apt-get update':
    command => '/usr/bin/apt-get update',
    alias => 'update_packages',
  }

  include apt
  apt::ppa{'ppa:brightbox/ruby-ng-experimental':
    alias => 'ruby_repo',
    before => Class['ruby']
  }

  class { 'ruby':
    version         => '2.1.2',
  }

  # ensure dev db is created
  class { 'postgresql::server': }
    postgresql::server::db { 'rebank_me_dev2':
    user     => 'postgres',
    password => 'dbpass',
  }

  notice "hello bundler app root ${bundler::install::app_root}"
  notice "hello ruby gem path ${ruby::params::gem_binpath}"



  # class {'bundler::install':}
  bundler::install { '/app':
    user => 'vagrant',
    group=> 'vagrant',
  }
}