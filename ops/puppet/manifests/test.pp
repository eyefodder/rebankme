Exec {
  path => "/usr/bin:/usr/local/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin"
}

# Class: update_ruby
#
#
class update_ruby {
  include apt
  apt::ppa{'ppa:brightbox/ruby-ng-experimental':
    alias => 'ruby_repo',
    before => Class['ruby']
    }
  class { 'ruby':
    version         => '2.1'
    # gems_version    => '2.2.2',
  }
  #  install bundler
  # gem install --include-dependencies --no-rdoc --no-ri bundler
  # exec { "install bundler":
  #     command => "gem install --no-rdoc --no-ri bundler",
  #     #path => "/usr/bin:/usr/sbin:/bin:/usr/local/bin",
  #     #refreshonly => true,
  # }
  #   exec { "rubygem_version":
  #     command => "gem update --system 1.8.25",
  #     #path => "/usr/bin:/usr/sbin:/bin:/usr/local/bin",
  #     #refreshonly => true,
  # }


  #   exec { "gem_env":
  #     command => "gem env",
  #     logoutput => true
  #     #path => "/usr/bin:/usr/sbin:/bin:/usr/local/bin",
  #     #refreshonly => true,
  # }
}
# Class: install_development_packages
#
#
class install_development_packages {
    include apt::update
    package { "ruby2.1-dev": ensure => installed,}
    package { "build-essential": ensure => installed,}
    package { "zlib1g-dev": ensure => installed,}
    package { "libssl-dev": ensure => installed,}

    package { "libreadline-dev": ensure => installed,}
    package { "git-core": ensure => installed,}
    package { "curl": ensure => installed,}
    package { "libyaml-dev": ensure => installed,}
    package { "libcurl4-openssl-dev": ensure => installed,}
    package { "libsqlite-dev": ensure => installed,}
    package { "postgresql": ensure => installed,}

    package { "libpq-dev": ensure => installed,}
    package { "sqlite3": ensure => installed,}
    package { "libsqlite3-dev": ensure => installed,}
    package { "bcrypt": ensure => installed,}
    package { "ruby-bundler": ensure => installed,}

    include bundler
}

# Class: setup_db
#
#
class create_db_role {
      # ensure dev db is created
    class { 'postgresql::server': }
    postgresql::server::role { 'rebankme':
        createdb => true,
    }
    # postgresql::server::db { 'rebank_me_dev':
    #     user     => 'postgres',
    #     password => 'dbpass',
    #     require => Class['install_development_packages'],
    # }
    # postgresql::server::db { 'rebank_me_test':
    #     user     => 'postgres',
    #     password => 'dbpass',
    #     require => Class['install_development_packages'],
    # }
}

# Class: install_gems
#
#
class install_gems {
    # resources

    include bundler
    exec { "bundle install '/app'":
        user        => 'vagrant',
        group       => 'vagrant',
        command     => 'bundle install',
        cwd         => '/app',
        path        => "/bin:/usr/bin:/usr/local/bin:/opt/vagrant_ruby/bin",
        unless      => 'bundle check',
        require     => [Class['update_ruby'],Package['bundler'],Class['install_development_packages'] ],
        logoutput   => true,
        loglevel      => debug,
        environment => "HOME='/app'",
        timeout     => 0,
      }

    # bundler::install { '/app':
    #     require => [Class['install_development_packages'], Class['update_ruby']]}
}

# Class: start rails server
#
#
class start_rails_server {
    # resources
    # unicorn::app { 'rebankme':
    #     approot     => '/app',
    #     pidfile     => '/app/unicorn.pid',
    #     socket      => '/app/unicorn.sock',
    #     user        => 'vagrant',
    #     group       => 'vagrant',
    #     preload_app => true,
    #     rack_env    => 'development',
    #     source      => 'bundler',
    #     require     => [
    #         Class['install_gems'],
    #         Class['migrate_DB'],
    #         Class['seed_database'],
    #       ],
    # }
    exec { "rails s":
    command     => 'rails s -d',
    cwd         => '/app',
    path        => "/bin:/usr/bin:/usr/local/bin:${ruby::params::gem_binpath}",
    require     => [Class['seed_database'] ],
    logoutput   => true,
    environment => "HOME='/app'",
    creates     => "/app/tmp/pids/server.pid"
  }
}

# Class: migrate_DB
#
#
class migrate_DB {
    # resources
    exec { "rake db:migrate":
    command     => 'rake db:migrate',
    cwd         => '/app',
    path        => "/bin:/usr/bin:/usr/local/bin:${ruby::params::gem_binpath}",
    require     => [Class['setup_db'] ],
    logoutput   => true,
    environment => "HOME='/app'",
  }
}
# Class: seed database
#
#
class seed_database {
    # resources
    exec { "rake db:seed":
    command     => 'rake db:seed',
    cwd         => '/app',
    path        => "/bin:/usr/bin:/usr/local/bin:${ruby::params::gem_binpath}",
    require     => [Class['migrate_DB'] ],
    logoutput   => true,
    environment => "HOME='/app'",
  }
}

include update_ruby
include install_development_packages
include create_db_role
 # include setup_db

 # include install_gems


# include migrate_DB
# include seed_database
#  include start_rails_server



